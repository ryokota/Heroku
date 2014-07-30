trigger AccountNameUpdate on StaffContract__c (before insert, before update, after insert, after update) {
    
    AccountNameUpdateTriggerHandler handler = new AccountNameUpdateTriggerHandler();
    if(trigger.isBefore){
        if (trigger.isInsert || trigger.isUpdate) {
            handler.beforeUpsert(trigger.new);
        }
    } else if(trigger.isAfter){
        if(trigger.isInsert){
            handler.afterInsert(trigger.new);
        }
        //契約一覧の終了日が変更された場合、延長確認情報を変更する。
        //延長確認の最新データの状況ステータスが「結果未入力」または「終了見込」の場合、
        //　－＞そのデータのステータスを「延長」に更新し、新たな新規データを作成
        //「延長」または「終了」の場合、新たな新規データを作成する。
        if(trigger.isUpdate){
            handler.afterUpsert(trigger.old, trigger.new);
        }
    }

}