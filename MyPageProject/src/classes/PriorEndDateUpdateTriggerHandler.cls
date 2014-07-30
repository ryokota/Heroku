public with sharing class PriorEndDateUpdateTriggerHandler {
    
    public void beforeUpdate(Map<Id, StaffContract__c> oldRecord, List<StaffContract__c> newRecord) {
    
        for (StaffContract__c newContract : newRecord) {
            StaffContract__c oldContract = oldRecord.get(newContract.Id);
            
            if (oldContract.EndDate__c > newContract.EndDate__c) {
                newContract.PriorEndDate__c = oldContract.EndDate__c;
                
            }
        }
    }
}