@isTest
private class OpportunityUpdateTriggerHandlerTest {

    static testMethod void Test_PMP_OpportunityUpdateTriggerHandler_Insert() {
        
        //テストデータ作成
        TestDateCreateUtil tData = new TestDateCreateUtil();
        Opportunity opp = tData.createOpp(true, RecordTypeUtil.getId('Opportunity', 'Temp'));
        
        Test.startTest();
        
        Event eve = tData.createEvent(true, RecordTypeUtil.getId('Event', 'Visit'), opp.Id);
        
        Test.stopTest();
    }
    
    static testMethod void Test_PMP_OpportunityUpdateTriggerHandler_Insert_200Rows() {
        
        /*
        //テストデータ作成
        TestDateCreateUtil tData = new TestDateCreateUtil();
        
        List<Opportunity> opps = new List<Opportunity>();
        Id tempId = RecordTypeUtil.getId('Opportunity', 'Temp');
        for (Integer i = 0; i < 200; i++) {
            opps.add(tData.createOpp(false, tempId));
        }
        insert opps;
        
        Test.startTest();
        List<Event> eves = new List<Event>();
        Id visitId = RecordTypeUtil.getId('Event', 'Visit');
        for (Opportunity e : opps) {
            eves.add(tData.createEvent(false, visitId, e.Id));
        }
        insert eves;
        Test.stopTest();
        */
    }
    
    static testMethod void Test_PMP_OpportunityUpdateTriggerHandler_Update() {
        
        //テストデータ作成
        TestDateCreateUtil tData = new TestDateCreateUtil();
        Opportunity opp = tData.createOpp(true, RecordTypeUtil.getId('Opportunity', 'Temp'));
        Event eve = tData.createEvent(true, RecordTypeUtil.getId('Event', 'Visit'), opp.Id);
        Test.startTest();
        eve.StartDateTime = eve.StartDateTime.addMinutes(30);
        update eve;
        
        Test.stopTest();
    }
    
    static testMethod void Test_PMP_OpportunityUpdateTriggerHandler_Delete() {
        
        //テストデータ作成
        TestDateCreateUtil tData = new TestDateCreateUtil();
        Opportunity opp = tData.createOpp(true, RecordTypeUtil.getId('Opportunity', 'Temp'));
        Event eve = tData.createEvent(true, RecordTypeUtil.getId('Event', 'Visit'), opp.Id);
        Event eve2 = tData.createEvent(true, RecordTypeUtil.getId('Event', 'Visit'), opp.Id);
        Test.startTest();
        
        delete eve2;
        
        Test.stopTest();
    }
    
    static testMethod void Test_PMP_OpportunityUpdateTriggerHandler_Delete_1rows() {
        
        //テストデータ作成
        TestDateCreateUtil tData = new TestDateCreateUtil();
        Opportunity opp = tData.createOpp(true, RecordTypeUtil.getId('Opportunity', 'Temp'));
        Event eve = tData.createEvent(true, RecordTypeUtil.getId('Event', 'Visit'), opp.Id);
        Test.startTest();
        
        delete eve;
        
        Test.stopTest();
    }
}