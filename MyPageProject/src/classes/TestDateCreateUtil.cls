public with sharing class TestDateCreateUtil {

    public Account createAccount(boolean isExe, boolean isDummy) {
        
        Account acc = new Account();
        
        acc.Name      = 'hogehoge';
        acc.NoEdit__c = isDummy;
        
        if (isExe) {
            insert acc;
        }
        
        return acc;
        
    }
    
    public StaffContract__c createStaffContract(boolean isExe, Id accountId, String atom) {
        
        StaffContract__c contract = new StaffContract__c();
        contract.Name  = 'hogehoge';
        contract.CompanyNameByAtom__c = atom;
        
        if (isExe) {
            contract.AccountNameBySFA__c = accountId;
            insert contract;
        }
        
        return contract;
    }
    
    public Opportunity createOpp(boolean isExe, Id recordTypeId) {
        
        Opportunity opp = new Opportunity();
        
        opp.Name         = 'hogehoge';
        opp.RecordTypeId = recordTypeId;
        opp.CloseDate    = Date.today();
        opp.StageName    = '受注';
        
        if (isExe) {
            insert opp;
        }
        
        return opp;
        
    }
    
    public Event createEvent(boolean isExe, Id recordTypeId, Id whatId) {
        
        Event eve = new Event();
        
        eve.Subject       = 'hogehoge';
        eve.OwnerId       = userInfo.getUserId();
        eve.StartDateTime = system.now();
        eve.EndDateTime   = system.now().addHours(1);
        eve.RecordTypeId  = recordTypeId;
        eve.WhatId        = whatId;
        
        if (isExe) {
            insert eve;
        }
        
        return eve;
        
    }

}