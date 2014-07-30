trigger JFK_ShikyuTeishiWorkTrigger on JFK_ShikyuTeishiWork__c (after delete, after insert, after update, after undelete, before delete, before insert, before update) {

    JFK_ShikyuTeishiWorkTriggerHandler handler = new JFK_ShikyuTeishiWorkTriggerHandler();
    
    // ==INSERT
    if(Trigger.isInsert && Trigger.isBefore){ // before insert
        handler.onBeforeInsert(Trigger.new, Trigger.newMap);
    }
    else if(Trigger.isInsert && Trigger.isAfter){ // after insert
        handler.onAfterInsert(Trigger.new, Trigger.newMap);
    }
    
    // ==UPDATE
    else if(Trigger.isUpdate && Trigger.isBefore){ // before update
        handler.onBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){ // after update
        handler.onAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    }
    
    // ==DELETE
    else if(Trigger.isDelete && Trigger.isBefore){ // before delete
        handler.onBeforeDelete(Trigger.old, Trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isAfter){  // after delete
        handler.onAfterDelete(Trigger.old, Trigger.oldMap);
    }
    
    // ==UNDELETE
    else if(Trigger.isUnDelete){ // undelete
        handler.OnUndelete(Trigger.new);
    }

}