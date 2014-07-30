/*
 * 概要：契約の短縮や延長を判断するための項目への書き込み
 * 条件：取込のエラー防止のため短縮（old.終了日 > new.終了日）のみ書き込みとする
 */
trigger PriorEndDateUpdateTrigger on StaffContract__c (before update) {
    
    PriorEndDateUpdateTriggerHandler handler = new PriorEndDateUpdateTriggerHandler();
    
    if (trigger.isBefore && trigger.isUpdate) {
        //handler.beforeUpdate(trigger.oldMap, trigger.new);
    }
    

}