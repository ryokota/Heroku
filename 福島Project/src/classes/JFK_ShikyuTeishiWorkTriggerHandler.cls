public with sharing class JFK_ShikyuTeishiWorkTriggerHandler {

    private Map<String, String> RecordTypeMap;
    public JFK_ShikyuTeishiWorkTriggerHandler() {
        List<RecordType> types=[
            SELECT Id, DeveloperName
              FROM RecordType
             WHERE SobjectType='JFK_ShikyuTeishiWork__c'
        ];
        RecordTypeMap=new Map<String, String>();
        for(RecordType r : types){
             RecordTypeMap.put(r.DeveloperName, r.Id);
        }
    }

    // ==INSERT
    public void onBeforeInsert(JFK_ShikyuTeishiWork__c[] news, Map<Id, JFK_ShikyuTeishiWork__c> newMap) {
        calcShikyuKingaku(news);
    }
    public void  onAfterInsert(JFK_ShikyuTeishiWork__c[] news, Map<Id, JFK_ShikyuTeishiWork__c> newMap) {}
    
    // ==UPDATE
    public void onBeforeUpdate(JFK_ShikyuTeishiWork__c[] olds, JFK_ShikyuTeishiWork__c[] news, Map<Id, JFK_ShikyuTeishiWork__c> oldMap, Map<Id, JFK_ShikyuTeishiWork__c> newMap) {
        calcShikyuKingaku(news);
    }
    public void  onAfterUpdate(JFK_ShikyuTeishiWork__c[] olds, JFK_ShikyuTeishiWork__c[] news, Map<Id, JFK_ShikyuTeishiWork__c> oldMap, Map<Id, JFK_ShikyuTeishiWork__c> newMap) {}
    
    // ==DELETE
    public void onBeforeDelete(JFK_ShikyuTeishiWork__c[] olds, Map<Id, JFK_ShikyuTeishiWork__c> oldMap) {}
    public void  onAfterDelete(JFK_ShikyuTeishiWork__c[] olds, Map<Id, JFK_ShikyuTeishiWork__c> oldMap) {}

    // ==UNDELETE
    public void     onUndelete(JFK_ShikyuTeishiWork__c[] news) {}
    

    /**
     * 支給額計算ロジック
     * Before実施
     */    
    private void calcShikyuKingaku(JFK_ShikyuTeishiWork__c[] news){
        
        for(JFK_ShikyuTeishiWork__c w : news){
        
            if(w.RecordTypeId==RecordTypeMap.get('Ranking')){
            }else{
                continue;
            }
            
        }
    }
    
}