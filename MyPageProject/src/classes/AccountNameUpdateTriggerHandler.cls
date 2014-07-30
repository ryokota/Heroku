public with sharing class AccountNameUpdateTriggerHandler {

    public void beforeUpsert(List<StaffContract__c> newRecord) {
        
        List<String> accNameByAtom = new List<String>();
        
        //取引先検索条件取得
        for (StaffContract__c e : newRecord) {
            
            if (e.CompanyNameByAtom__c != null) {
                accNameByAtom.add(e.CompanyNameByAtom__c);
            }
        }
        
        //取引先取得
        Map<String, Id> accIds = getAccountIds(accNameByAtom);
        
        //ダミー取引先取得（変更不可=true）
        Id dummyAccountId = getDummyAccountId();
        
        //主従項目設定
        for (StaffContract__c e : newRecord) {
            
            if (accIds.containsKey(e.CompanyNameByAtom__c)) {
                e.AccountNameBySFA__c = accIds.get(e.CompanyNameByAtom__c);
            } else {
                e.AccountNameBySFA__c = dummyAccountId != null ? dummyAccountId : null;
            }
        }
    }
    
    public void afterInsert(List<StaffContract__c> newRecord){
        List<ExtensionConfirm__c> insertResult = new List<ExtensionConfirm__c>();
        for(StaffContract__c newObj : newRecord){
            ExtensionConfirm__c targetObj = new ExtensionConfirm__c(StaffContract__c = newObj.id, 
                                                                             ContractStartDate__c = newObj.StartDate__c , 
                                                                             ContractEndDate__c = newObj.EndDate__c, 
                                                                             FirstConfirmDate__c = date.today());
            insertResult.add(targetObj);
        }
        if(insertResult.size() > 0)insert insertResult;
    }
    
    
    public void afterUpsert(List<StaffContract__c> oldRecord,List<StaffContract__c> newRecord){
        List<ExtensionConfirm__c> upsertList = new List<ExtensionConfirm__c>();
        system.debug('**********************old : ' + oldRecord.get(0).EndDate__c);
        system.debug('**********************new : ' + newRecord.get(0).EndDate__c);
        system.debug('**********************PriorEndDate__cold : ' + oldRecord.get(0).PriorEndDate__c);
        system.debug('**********************PriorEndDate__cnew : ' + newRecord.get(0).PriorEndDate__c);
        Set<Id> staffContractIdList = new Set<Id>();
        //IDを抽出する。
        for(StaffContract__c staff : newRecord ){
            staffContractIdList.add(staff.Id);
        }
        //延長確認の情報を取得する。
        List<ExtensionConfirm__c> childList = [SELECT StaffContract__c, ConfirmResultByClass__c 
                                                FROM ExtensionConfirm__c 
                                                WHERE StaffContract__c = :staffContractIdList 
                                                ORDER BY StaffContract__c, Name desc];
        Map<String, ExtensionConfirm__c> childMap = new Map<String, ExtensionConfirm__c>();
        //延長確認の各IDごとに最新レコードのみマッピングする。
        for(ExtensionConfirm__c extObj : childList){
            if(!childMap.containsKey(extObj.StaffContract__c)){
                childMap.put(extObj.StaffContract__c, extObj);
            }
        }
        
        List<ExtensionConfirm__c> updateResult = new List<ExtensionConfirm__c>();
        List<ExtensionConfirm__c> insertResult = new List<ExtensionConfirm__c>();
        
        for(integer i=0; i<newRecord.size(); i++){
            
            String id = newRecord.get(i).Id;
            
            //終了日が異なり、新たに入力した終了日が未来日の場合、前回終了日はトリガーの二重処理を防ぐための条件
            if(oldRecord.get(i).EndDate__c != newRecord.get(i).EndDate__c 
            && oldRecord.get(i).PriorEndDate__c == newRecord.get(i).PriorEndDate__c
            && (oldRecord.get(i).EndDate__c < newRecord.get(i).EndDate__c 
            || (oldRecord.get(i).EndDate__c == null && newRecord.get(i).EndDate__c != null))){
                
                //契約一覧IDが存在する場合は延長確認の情報が存在する
                if(childMap.containsKey(id)){
                    //延長確認の最新レコードを更新
                    ExtensionConfirm__c confirmObj = childMap.get(id);
                    
                    if(confirmObj.ConfirmResultByClass__c == null || 
                       confirmObj.ConfirmResultByClass__c == '' || 
                       confirmObj.ConfirmResultByClass__c == '終了見込'){
                        confirmObj.ConfirmResultByClass__c = '延長';
                        //入力規則での問題で別々に更新を掛ける。
                        //入力規則では過去のデータは更新不可のため
                        updateResult.add(confirmObj);
                    }
                    //新たな延長確認のレコード新規作成
                    ExtensionConfirm__c newObj = new ExtensionConfirm__c(StaffContract__c = id, 
                                                                         ContractStartDate__c = newRecord.get(i).StartDate__c , 
                                                                         ContractEndDate__c = newRecord.get(i).EndDate__c, 
                                                                         FirstConfirmDate__c = date.today());
                    insertResult.add(newObj);
                //新たな延長確認のレコード新規作成
                } else {
                    ExtensionConfirm__c newObj = new ExtensionConfirm__c(StaffContract__c = id, 
                                                                         ContractStartDate__c = newRecord.get(i).StartDate__c , 
                                                                         ContractEndDate__c = newRecord.get(i).EndDate__c, 
                                                                         FirstConfirmDate__c = date.today());
                    insertResult.add(newObj);
                }
                
            //終了日が過去方向に更新判定（契約期間の短縮化）
            } else if (oldRecord.get(i).EndDate__c > newRecord.get(i).EndDate__c ) {
                
                if(childMap.containsKey(id)){ 
                    ExtensionConfirm__c confirmObj = childMap.get(id);
                    confirmObj.ConfirmResultByClass__c = null;
                    confirmObj.ContractEndDate__c      = newRecord.get(i).EndDate__c;
                    //updateResult.add(confirmObj);
                }
            }
        }
        //入力規則による更新を優先でコミットする。
        if(updateResult.size() > 0) update updateResult;
        if(insertResult.size() > 0) insert insertResult;
    }
    
    private Map<String, Id> getAccountIds(List<String> accName) {
        
        Map<String, Id> accIds = new Map<String, Id>();
        
        if (accName.isEmpty()) {
            return accIds;
        }
        List<Account> acc = [select
                                    Id,
                                    Name
                                from
                                    Account
                                where
                                    Name in :accName
                                order by
                                    CreatedDate asc];
        
        for (Account e : acc) {
            accIds.put(e.Name, e.Id);
        }
        
        return accIds;
    }
    
    private Id getDummyAccountId() {
        
        List<Account> acc = new List<Account>();
        acc = [select
                      Id
                  from
                      Account
                  where
                      Name = '未登録企業'
                  order by
                      CreatedDate desc];
        
        if (!acc.isEmpty()) {
            return acc.get(0).Id;
        }
        
        return null;
    }

}