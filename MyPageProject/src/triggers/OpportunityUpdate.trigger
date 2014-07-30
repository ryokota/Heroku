trigger OpportunityUpdate on Event (after delete, after insert, after update) {
    
    OpportunityUpdateTriggerHandler hander = new OpportunityUpdateTriggerHandler();
    
    if (trigger.isInsert) {
        hander.afterInsert(trigger.new);
    }
    
    if (trigger.isUpdate) {
        hander.afterUpdate(trigger.new, trigger.oldMap);
    }
    
    if (trigger.isDelete) {
        hander.afterDelete(trigger.old);
    }

}