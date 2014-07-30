/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Milestone_ProjectMatrixReportCtrlTest {

    static testMethod void myUnitTest() {
    	Test.startTest();
    	//Project_Type__c : Key, Integration, Finance Specific, ERP
    	//Sub_Function__c : Controller's Group, BP&A, Commercial Finance, Supply Chain Finance, M&A, Finance Integration, Investor Relations, Internal Audit, Corporate Administrator

        Milestone1_Project__c p1 = new Milestone1_Project__c(Name = 'Project1', Sub_Function__c='Commercial Finance', Project_Type__c='Integration',Function__c='Finance', Project_Status__c='Green');
        insert p1;
        
        Milestone_ProjectMatrixReportCtrl matrix = new Milestone_ProjectMatrixReportCtrl();
        //マップキー確認
        System.assertEquals(true, matrix.projectTypeMap.containsKey('Integration'));
        System.assertEquals(true, matrix.subFunctionMap.containskey('Commercial Finance'));
        
        //設定したPickListサイズチェック
        List<SelectOption> projectFilter = matrix.getFilterProjectType();
        List<SelectOption> statusFilter = matrix.getFilterStatus();
        System.assertEquals(5, projectFilter.size());
        System.assertEquals(4, statusFilter.size());
        Test.stopTest();
    }
}