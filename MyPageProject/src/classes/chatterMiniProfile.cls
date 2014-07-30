// Jonathan Hersh - jhersh@salesforce.com - 3/1/2010
public with sharing class chatterMiniProfile {
    public integer followers    { get; set; }
    public integer following    { get; set; }
    public integer updates      { get; set; }
    
    public boolean isTest       { get; set; }
    
    public chatterMiniProfile() {
        isTest = false;
    }
    
    public pageReference loadProfile() {
        AggregateResult[] followersAR, followingAR, updatesAR;
        
        if( !isTest ) {
            followersAR = [select count(id)
                from EntitySubscription
                where parentid = :UserInfo.getUserId()];
                
            followingAR = [select count(id)
                from EntitySubscription
                where subscriberid = :UserInfo.getUserId()];
                
            updatesAR = [select count(id)
                from UserFeed
                where createdbyid = :UserInfo.getUserId()];
                
            followers = integer.valueof(followersAR[0].get('expr0'));
            following = integer.valueof(followingAR[0].get('expr0'));   
            updates = integer.valueof(updatesAR[0].get('expr0'));
        } else {
            followers = 1;
            following = 1;
            updates = 1;
        }   
        
        return null;
    }
    
    public static testmethod void runTest() {
        chatterMiniProfile cmp = new chatterMiniProfile();
        cmp.isTest = true;
        
        cmp.loadProfile();
    }
}