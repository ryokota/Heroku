/**
    updated by Jia Hu on 2013/11/08
 */
//@isTest(SeeAllData=true)
@isTest(SeeAllData=false) 
private class RFA_VFC03_OverrideController_Test {

    static testMethod void testOverrideController1() {
        RFATestData testData = new RFATestData();
        
        /*
        //testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        
        RFA__c testRFA;
        
        System.runAs(RFATestData.requester)
        {
            testRFA = RFATestData.buildTestRFA(testRFA, rt);
            
        }
        */
        RFA__c testRFA = RFATestData.buildRFACapital();
        
        Map<String, String> urlParams = new Map<String, String>
        {
            'Id' => testRFA.Id
        };
        //Test.startTest();
        //System.runAs(RFATestData.levelLCUserMap.get(testRFA.Level__c))
        //{
            ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(testRFA);
            RFA_VFC03_OverrideController controller1 = new RFA_VFC03_OverrideController(stdController1);
            //controller1.getStages();
            //controller1.selectedLevel = 'CCEJ';
            //controller1.selectedStage = 'Post-Circulation';         
            //controller1.updateRFA();
            
            RFA__c rfaVal = [Select Stage__c, Id 
            //Level__c 
            FROM RFA__c WHERE Id = : testRFA.Id];            
            //System.assertEquals('CCEJ', rfaVal.Level__c);
            //System.assertEquals('Post-Circulation', rfaVal.Stage__c);   
        //}
        
        
        ApexPages.Standardcontroller stdController2 = new ApexPages.Standardcontroller(testRFA);
        RFA_VFC03_OverrideController controller2 = new RFA_VFC03_OverrideController(stdController2);
        //controller2.getStages();
        //controller2.selectedLevel = 'Return To Sender';
        //controller2.returnReason = 'This is for the purpose of testing';
        //controller2.updateRFA();        
        
        RFA__c rfaVal2 = [Select Stage__c, Id
            //Level__c 
            FROM RFA__c WHERE Id = : testRFA.Id];
        //System.assertEquals(rfaVal2.Level__c, 'Return To Sender');
        //Test.stopTest();
        
    }
    
    static testMethod void testOverrideController2() {
        RFATestData testData = new RFATestData();
        /*
        //testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        RFA__c testRFA; 
        
        
        System.runAs(RFATestData.requester)
        {
            testRFA = RFATestData.buildTestRFA(testRFA, rt);
            
        }
        */
        RFA__c testRFA = RFATestData.buildRFACapital();
        
        //System.runAs(RFATestData.levelLCUserMap.get(testRFA.Level__c))
        //{
            User approverUser = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app1', 'app1');
            RFAUserRole__c approver = RFATestData.buildApprover(testRFA.Id, approverUser
                //, testRFA.level__c
                );
            //insert approver;
            ApprovalProcess__c testProcess = new ApprovalProcess__c();
            Database.UpsertResult upsertResult = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA);
            if(upsertResult.isSuccess())
            {
                approver.ApprovalProcess__c = upsertResult.getId();
                approver.ApprovalOrder__c = 1;
                approver.ApprovalRecommendation__c = 'Awaiting Approval';
                update approver;    
            }
            RFA__c rfaVsal = [SELECT ApprovalLetterComments__c,
                              //AREMonth__c,ARERate__c,
                              //BoardSubItem__c,
                              BottlerDiscPaybackPeriodYears__c,
                              BottlerInvestmentDepreciationYears__c,BottlerIRR__c,BottlerLocalEffectiveTaxRate__c,
                              //BottlerNPVUSD__c,
                              BottlerParticipationAmountUSD__c,BottlerParticipation__c,
                              //BottlerROINPVCAPPr__c,
                              BottlerWACC__c,BudgetType__c,
                              //BusinessCaseGuideline__c,
                              //BusinessCase__c,
                              //BusinessUnitApprovers__c,
                              //Business_Unit__c,
                              CapitalExpenditureTotalFC__c,
                              CapitalizedInterestUSD__c,CapitalManagementAdministered__c,CashflowAnalysisYears__c,CashflowYears__c,
                              CirculationDate__c,CommentsaboutExpectedCommitmentDate__c,CommentsConditions__c,Comments__c,
                              CompanyDiscountPaybackPeriodYears__c,CompanyInvestmentAmortizationYears__c,CompanyIRR__c,CompanyLocalEffectiveTaxRate__c,
                              //CompanyNPVUSD__c,
                              CompanyParticipationAmountUSD__c,CompanyParticipation__c,CompanyWACC__c,CompletionDate__c,
                              //ControlNumber__c,
                              //ControlNumLink__c,
                              //CorporateApprovers__c,
                              CreatedById,
                              //CreatedByUser__c,
                              CreatedDate,
                              DataClassification__c,
                              //DaysinBusinessUnit__c,DaysinCorporate__c,DaysinExecutive__c,DaysinGroup__c,
                              //DaysinKeyOperations__c,DaysinSeniorExecutive__c,
                              DiscountedPaybackPeriodYears__c,EconomicProfitUSD__c,
                              EquipmentPlacementPeriodYears__c,
                              //ExecutiveApprovers__c, //ExecutiveSummary__c,
                              ExpectedCommitmentDate__c,From__c,
                              //Functional_Currency__c,
                              //GroupApprovers__c,
                              //Group__c,
                              Id,IncludeInCapitalReports__c,
                              InitialBudgetYear__c,IRR__c,IsDeleted,IsthisanAnnualCapitalPlanrequest__c,
                              //KeyOperationsApprovers__c,
                              //KeyOperation__c,
                              LastActivityDate,LastModifiedById,LastModifiedDate,LCOACategorySubCategory__c,
                              //LevelStage__c,
                              //Level__c,
                              //LocalReferenceNumber__c,
                              Name,
                              //NPVUSD__c,
                              NumberofUnitsofEquipment__c,OwnerId,PerformanceReportingPeriodMonths__c,
                              //PreviousLevel__c,
                              //PrimaryDOACategorySubCategory__c,
                              //PrimaryReportingUnitName__c,PrimaryReportingUnitNumberName__c,PrimaryReportingUnitNumber__c,ProfitCenterName__c,ProfitCenterNumberName__c,
                              ProfitCenterNumber__c,Ratification__c,RecordTypeId,
                              //ReportingUnitInformationGuideline__c,
                              //REP_DaysInBUCirculation__c,
                              //REP_DaysInBUPostCirculation__c,REP_DaysInBUPreCirculation__c,
                              REP_DaysInCapMgmtHold__c,
                              //REP_DaysInCorporateCirculation__c,
                              //REP_DaysInCorporatePostCirculation__c,REP_DaysInCorporatePreCirculation__c,
                              REP_DaysInDraft__c,
                              //REP_DaysInExecutiveCirculation__c,
                              //REP_DaysInExecutivePostCirculation__c,REP_DaysInGroup__c,
                              //REP_DaysInKeyOps__c,
                              REP_DaysInPendBoardReview__c,
                              //REP_DaysInPostGroup__c,
                              //REP_DaysInPostKeyOps__c,REP_DaysInPostSeniorExecutive__c,REP_DaysInPreExecutive__c,REP_DaysInPreGroup__c,REP_DaysInPreKeyOps__c,
                              //REP_DaysInPreSeniorExecutive__c,
                              REP_DaysInReturnToSender__c,
                              //REP_DaysInSeniorExecutive__c,
                              RequestAmountFunctionalCurrency__c,
                              //RequestAmountUSD__c,
                              RequestTitle__c,ReturnReason__c,
                              //SecondDOACategorySubCategory__c,
                              //SecondReportingUnitName__c,
                              //SecondReportingUnitNumberName__c,SecondReportingUnitNumber__c,
                              //SeniorExecutiveApprovers__c,
                              Stage__c,Subject__c,SystemModstamp,
                              //TaxRate__c,
                              TECH_LastStatusChangeDate__c,
                              //TECH_TimeInBUCirculation__c,TECH_TimeInBUPostCirculation__c,TECH_TimeInBUPreCirculation__c,
                              TECH_TimeInCapMgmtHold__c,
                              //TECH_TimeInCorporateCirculation__c,TECH_TimeInCorporatePostCirculation__c,TECH_TimeInCorporatePreCirculation__c,
                              TECH_TimeInDraft__c,
                              //TECH_TimeInExecutiveCirculation__c,TECH_TimeInExecutivePostCirculation__c,TECH_TimeInExecutivePreCirculation__c,TECH_TimeInGroupCirculation__c,TECH_TimeInGroupPostCirculation__c,TECH_TimeInGroupPreCirculation__c,
                              TECH_TimeInKeyOpsCirculation__c,TECH_TimeInKeyOpsPostCirculation__c,TECH_TimeInKeyOpsPreCirculation__c,TECH_TimeInPendBoardReview__c,TECH_TimeInReturnToSender__c,
                              //TECH_TimeInSrExecCirculation__c,TECH_TimeInSrExecPostCirculation__c,
                              //TECH_TimeInSrExecPreCirculation__c,
                              TermoftheAgreementYears__c,Theapprovalstatusofyourrequestis__c,Thefollowingitem__c,
                              //ThirdDOACategorySubCategory__c,
                              //ThirdReportingUnitName__c,ThirdReportingUnitNumberName__c,ThirdReportingUnitNumber__c,
                              ThreeYearCashSpendTotalFC__c,TotalDaystoApproval__c //,
                              //WACC__c 
                              FROM RFA__c where Id = : testRFA.Id];
            //System.assertEquals('CCEJ', rfaVsal.Level__c);
            System.assertEquals('Circulation', rfaVsal.Stage__c);
             
            Map<String, String> urlParams = new Map<String, String>{
                'Id' => rfaVsal.Id
            };
            //Test.startTest();
            Test.setCurrentPage(getPageReference('RFA_VFP02_Override', urlParams));
            ApexPages.Standardcontroller stdController2 = new ApexPages.Standardcontroller(rfaVsal);
            RFA_VFC03_OverrideController controller2 = new RFA_VFC03_OverrideController(stdController2);
            controller2.getLevel();
            controller2.selectedLevel = 'CCEJ';
            //controller2.selectedStage = 'Post-Circulation';
            controller2.updateRFA();
            
            ApexPages.Standardcontroller stdController3 = new ApexPages.Standardcontroller(rfaVsal);
            RFA_VFC03_OverrideController controller3 = new RFA_VFC03_OverrideController(stdController3);
            controller3.getLevel();
            controller3.selectedLevel = 'CCEJ';//1. Key Operations
            //controller3.selectedStage = 'Post-Circulation';
            controller3.updateRFA();
            //Test.stopTest();
        //}
    }
    
    static testMethod void testOverrideController3()
    {
        RFATestData testData = new RFATestData();
        /*
        //testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        RFA__c testRFA; 
        
        System.runAs(RFATestData.requester)
        {
            testRFA = RFATestData.buildTestRFA(testRFA, rt);            
        }   
        */
        RFA__c testRFA = RFATestData.buildRFACapital();
        
        //System.runAs(RFATestData.levelLCUserMap.get(testRFA.Level__c))
        //{
            Map<String, String> urlParams = new Map<String, String>
            {
                'Id' => testRFA.Id
            };
            Test.setCurrentPage(getPageReference('RFA_VFP02_Override', urlParams));
            ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(testRFA);
            RFA_VFC03_OverrideController controller1 = new RFA_VFC03_OverrideController(stdController1);
            /*
            controller1.selectedLevel = '6. Senior Executive';
            controller1.selectedStage = 'Post-Circulation';
            controller1.updateRFA();
            controller1.selectedLevel = '5. Executive';
            controller1.selectedStage = 'Post-Circulation';
            controller1.updateRFA();
            controller1.selectedLevel = '4. Corporate';
            controller1.selectedStage = 'Post-Circulation';
            controller1.updateRFA();
            controller1.selectedLevel = '3. Group';
            controller1.selectedStage = 'Post-Circulation';
            controller1.updateRFA();
            controller1.selectedLevel = '2. Business Unit';
            controller1.selectedStage = 'Post-Circulation';
            controller1.updateRFA();
            */
        //}
    }
    
    static PageReference getPageReference(String page, Map<String, String> params) {
        String url = '/apex/'+page+'?';
        for (String param : params.keySet()) {
            url += param + '=' + params.get(param) + '&';
        }
        PageReference p = new PageReference(url);
        return p;
    }
}