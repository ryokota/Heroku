@isTest
private class AccountNameUpdateTriggerHandlerTest {

    static testMethod void Test_AccountNameUpdateTriggerHandler_Insert() {
        
        //テストデータ作成
        TestDateCreateUtil tData = new TestDateCreateUtil();
        Account acc = tData.createAccount(true, false);
        
        Test.startTest();
        
        StaffContract__c con = tData.createStaffContract(true, acc.Id, acc.Name);
        
        Test.stopTest();
        
    }
    
    static testMethod void Test_AccountNameUpdateTriggerHandler_InsertDummy() {
        
        //テストデータ作成
        TestDateCreateUtil tData = new TestDateCreateUtil();
        Account acc = tData.createAccount(true, true);
        
        Test.startTest();
        
        StaffContract__c con = tData.createStaffContract(true, acc.Id, 'hogehoge2');
        
        Test.stopTest();
        
    }
    
    static testMethod void Test_AccountNameUpdateTriggerHandler_beforeUpsert() {
        
        //テストデータ作成
        TestDateCreateUtil tData = new TestDateCreateUtil();
        Account acc = tData.createAccount(true, true);
        
        Test.startTest();
        
        StaffContract__c con = tData.createStaffContract(true, acc.Id, 'hogehoge2');
        con.Name = 'hogehoge2';
        update con;
        
        List<StaffContract__c> conList = new List<StaffContract__c>();
        conList.add(con);
        AccountNameUpdateTriggerHandler handler = new AccountNameUpdateTriggerHandler();
        handler.beforeUpsert(conList);
        
        Test.stopTest();
        
    }
    
    static testMethod void Test_AccountNameUpdateTriggerHandler_afterInsert() {
        
        //テストデータ作成
        TestDateCreateUtil tData = new TestDateCreateUtil();
        Account acc = tData.createAccount(true, true);
        
        Test.startTest();
        
        StaffContract__c con = tData.createStaffContract(true, acc.Id, 'hogehoge2');
        
        List<StaffContract__c> conList = new List<StaffContract__c>();
        conList.add(con);
        AccountNameUpdateTriggerHandler handler = new AccountNameUpdateTriggerHandler();
        handler.afterInsert(conList);
        
        Test.stopTest();
        
    }
    
    static testMethod void Test_AccountNameUpdateTriggerHandler_afterUpdate() {
        
        //テストデータ作成
        TestDateCreateUtil tData = new TestDateCreateUtil();
        Account acc = tData.createAccount(true, true);
        
        Test.startTest();
        
        StaffContract__c con = tData.createStaffContract(true, acc.Id, 'hogehoge2');
        
        List<StaffContract__c> conList = new List<StaffContract__c>();
        conList.add(con);
        AccountNameUpdateTriggerHandler handler = new AccountNameUpdateTriggerHandler();
        handler.afterUpsert(conList, conList);
        
        Test.stopTest();
        
    }
}