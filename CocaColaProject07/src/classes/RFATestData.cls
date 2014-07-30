/*
    updated by Jia Hu on 2013/11/08
    updated by Jia Hu on 2013/12/04
 */
@isTest(SeeAllData=false) 
public class RFATestData {
    
    public static User requester = new User();    
    //for All
    public static ProfitCenter__c testProfitCenter = new ProfitCenter__c();
       
    // used to generate random unique strings for creating user records
    private static Integer ctr = 0; 
    
    /*
     * This method creates a user record
     * @Paran : String profileId, String alias, String lastName
     * @return: User__c
     * @return void
     */
    //public User createUser(String profileId, String alias, String lastName, User testUser)
    public User createUser(String profileId, String alias, String lastName)
    {
        User testUser = new User();
        testUser.alias = alias;
        testUser.email = 'cokeuserfortest@cocacola.com' + ctr++;
        testUser.emailencodingkey ='UTF-8';
        testUser.lastName = lastName;
        testUser.languagelocalekey ='en_US';
        testUser.localesidkey ='en_US';
        testUser.ProfileId = profileId;
        testUser.timezonesidkey ='Europe/London';
        testUser.UserName = alias + String.valueOf(Math.Round( Math.Random() * 100000)) + '@rfa.cocacola.com';
        insert testUser;
        return testUser;
    }  

    public User createUser(String strGroup, String strAcronym)
    {
        User testUser = new User();
        testUser.alias = 'a' + String.valueOf(Math.Round( Math.Random() * 1000000));
        testUser.email = 'cokeuserfortest@cocacola.com' + ctr++;
        testUser.emailencodingkey ='UTF-8';
        testUser.lastName = 'l' + String.valueOf(Math.Round( Math.Random() * 100000));
        testUser.languagelocalekey ='en_US';
        testUser.localesidkey ='en_US';
        testUser.ProfileId = RFAConstants.getRFAStandardUserProfileId();
        testUser.timezonesidkey ='Europe/London';
        testUser.UserName = 'a' + String.valueOf(Math.Round( Math.Random() * 100000)) + '@rfa.cocacola.com';
        testUser.COA_Group__c = strGroup;
        testUser.COA_Acronym__c = strAcronym;
        insert testUser;
        return testUser;
    }      
    
    public User createCOAUser(String strGroup, String strAcronym, String Level, String L2EFunction, String L3EFunction, String L4EFunction)
    {
        User testUser = new User();
        testUser.alias = 'a' + String.valueOf(Math.Round( Math.Random() * 1000000));
        testUser.email = 'cokeuserfortest@cocacola.com' + ctr++;
        testUser.emailencodingkey ='UTF-8';
        testUser.lastName = 'l' + String.valueOf(Math.Round( Math.Random() * 100000));
        testUser.languagelocalekey ='en_US';
        testUser.localesidkey ='en_US';
        testUser.ProfileId = RFAConstants.getRFAStandardUserProfileId();
        testUser.timezonesidkey ='Europe/London';
        testUser.UserName = 'a' + String.valueOf(Math.Round( Math.Random() * 100000)) + '@rfa.cocacola.com';
        testUser.COA_Group__c = strGroup;
        testUser.COA_Acronym__c = strAcronym;
        testUser.L_level__c = Level;
        testUser.L2_Function_E__c = L2EFunction;
        testUser.L3_Function_E__c = L3EFunction;
        testUser.L4_Function_E__c = L4EFunction;
        insert testUser;
        return testUser;
    }     
       
    public User createRequester()
    {
        requester = createUser(RFAConstants.getRFAStandardUserProfileId(), 'rUsert', 'reqlastt');
        return requester;
    }      
    
    public Cost_Center__c buildCostCenter(String Function) {
        Cost_Center__c CostCenter = new Cost_Center__c();
        CostCenter.Name = RFAConstants.CostCenter_Name;
        CostCenter.ActiveInactive__c = 'Active';
        CostCenter.Function__c = Function;
        CostCenter.Function_En__c = Function;
        
        insert CostCenter;
        return CostCenter;
    }
    
    public void buildTaxRate() {       
        List<Financial_Constant__c> FCList = new List<Financial_Constant__c>();
        Financial_Constant__c FinCont1 = new Financial_Constant__c();
        FinCont1.isActive__c = true;
        FinCont1.Tax_Rate__c = 0.05;
        FinCont1.RecordTypeId = RFAConstants.getRecordType(
                                RFAConstants.FinancialConstant_RT_TaxRate, 'Financial_Constant__c');
        FCList.add(FinCont1);
        
        Financial_Constant__c FinCont2 = new Financial_Constant__c();
        FinCont2.isActive__c = true;
        FinCont2.WACC__c = 0.05;
        FinCont2.RecordTypeId = RFAConstants.getRecordType(
                                RFAConstants.FinancialConstant_RT_WACC, 'Financial_Constant__c');
        FCList.add(FinCont2);        
                
        insert FCList;                
    }    
    
    public void buildProfitCenter()
    {
        testProfitCenter.ProfitCenterName__c = RFAConstants.ProfitCenter_Name_CCEJ; 
        testProfitCenter.Name = '0001';
        testProfitCenter.ActiveInactive__c = 'Active';
        insert testProfitCenter;
        
        buildProfitCenterUserRole(testProfitCenter.Id);                 
    }
     
    public void buildProfitCenterUserRole(String pcId)
    {
        List<ProfitCenterUserRole__c> pcUserRoleForInsert = new List<ProfitCenterUserRole__c>();
        
        User viewerUser = createUser(RFAConstants.getRFAStandardUserProfileId(), 'viewUser', 'viewerlastt');                    
        ProfitCenterUserRole__c viewerUserRole = new ProfitCenterUserRole__c();
        viewerUserRole.ProfitCenter__c = pcId;
        viewerUserRole.UserName__c = viewerUser.Id;
        viewerUserRole.UserType__c = RFAConstants.ProfitCenterUserRole_UserType_Viewer;    
        pcUserRoleForInsert.add(viewerUserRole);    
        
        /*
        User capUser = createUser(RFAConstants.getRFAStandardUserProfileId(), 'capUsert', 'caplastt');                  
        ProfitCenterUserRole__c capUserRole = new ProfitCenterUserRole__c();
        capUserRole.ProfitCenter__c = pcId;
        capUserRole.UserName__c = capUser.Id;
        capUserRole.UserType__c = RFAConstants.ProfitCenterUserRole_UserType_Capital;    
        pcUserRoleForInsert.add(capUserRole);  
        */         
                    
        insert pcUserRoleForInsert;
    }
    
    public static RFA__c createTestRFAwithType(String stage, String rt, Integer amount) {
        RFA__c testRFA = new RFA__c();
        
        testRFA.Stage__c = stage;
        Id rtId = RFAConstants.getRecordType(rt, 'RFA__c'); //'General Request'
        testRFA.RecordTypeId = rtId;
                
        testRFA.RequestTitle__c = 'Test Data Created in test class';
        testRFA.LCOACategorySubCategory__c = 'Testing 3 years Cash Spent';
        
        testRFA.Cost_Center_Number__c = [Select Id from Cost_Center__c limit 1].Id;

        testRFA.Legal_Entity__c = '【CCEJ】 Coca-Cola East Japan';
        testRFA.RequestAmountFunctionalCurrency__c = amount;
        
        testRFA.Expected_Cash_Spend_Date__c = System.Today();
        testRFA.Expected_Capitalization_Date__c = System.Today();
        testRFA.ExpectedCommitmentDate__c = System.Today();
        
        testRFA.PrimaryCOACategory__c = 'Purchase, Disposal, Revaluation or Write-off of Assets';
        testRFA.PrimaryCOASubCategory__c = 'Asset Impairments';
        testRFA.Objectives_Rationale_Background__c = 'test';
        testRFA.Benefits_Financial_Metrics_Assumptions__c = 'test';
        testRFA.Cost_Estimates__c = 'test';
        testRFA.Risks_and_Alternatives__c = 'test';
        testRFA.Other_Considerations__c = 'test';
        
        testRFA.IsthisanAnnualCapitalPlanrequest__c = 'Yes';
        testRFA.Budget_Approval_Number__c = 'Number';
        testRFA.InitialBudgetYear__c = '2013';
        testRFA.BudgetType__c = 'Formal';
        testRFA.OPEX_Amount__c = amount; //1200;
        
        testRFA.DiscountedPaybackPeriodYears__c = 0.05;
        testRFA.IRR__c = 0.05;
        testRFA.CashflowYears__c = 3;
        testRFA.NPVUSD__c = amount; //1200;

        insert testRFA;
        return testRFA;
    }    

    public static RFA__c createTestRFAForCOA(
    	String stage, String rt, Id idCostCenter, 
    	String PrimaryCOACategory, String PrimaryCOASubCategory, String PrimaryCOASubCategory2, String PrimaryCOASubCategory3,
    	String SecondCOACategory, String SecondCOASubCategory, String SecondCOASubCategory2, String SecondCOASubCategory3,
    	String ThirdCOACategory, String ThirdCOASubCategory, String ThirdCOASubCategory2, String ThirdCOASubCategory3
    	) {
        RFA__c testRFA = new RFA__c();

        testRFA.PrimaryCOACategory__c = PrimaryCOACategory;
        testRFA.PrimaryCOASubCategory__c = PrimaryCOASubCategory;
        if(!RFAConstants.isBlank(PrimaryCOASubCategory2)) {
        	testRFA.PrimaryCOASubCategory2__c = PrimaryCOASubCategory2;
        }
        if(!RFAConstants.isBlank(PrimaryCOASubCategory3)) {
        	testRFA.PrimaryCOASubCategory3__c = PrimaryCOASubCategory3;
        }
        
        if(!RFAConstants.isBlank(SecondCOACategory)) {
        	testRFA.SecondCOACategory__c = SecondCOACategory;
        }
        if(!RFAConstants.isBlank(SecondCOASubCategory)) {
        	testRFA.SecondCOASubCategory__c = SecondCOASubCategory;
        }
        if(!RFAConstants.isBlank(SecondCOASubCategory2)) {
        	testRFA.SecondCOASubCategory2__c = SecondCOASubCategory2;
        }
        if(!RFAConstants.isBlank(SecondCOASubCategory3)) {
        	testRFA.SecondCOASubCategory3__c = SecondCOASubCategory3;        
        }
		
		if(!RFAConstants.isBlank(ThirdCOACategory)) {
        	testRFA.ThirdCOACategory__c = ThirdCOACategory;
		}
		if(!RFAConstants.isBlank(ThirdCOASubCategory)) {
        	testRFA.ThirdCOASubCategory__c = ThirdCOASubCategory;
		}
		if(!RFAConstants.isBlank(ThirdCOASubCategory2)) {
        	testRFA.ThirdCOASubCategory2__c = ThirdCOASubCategory2;
		}
		if(!RFAConstants.isBlank(ThirdCOASubCategory3)) {
        	testRFA.ThirdCOASubCategory3__c = ThirdCOASubCategory3;     
		}     
        
        testRFA.Stage__c = stage;
        Id rtId = RFAConstants.getRecordType(rt, 'RFA__c'); //'General Request'
        testRFA.RecordTypeId = rtId;
                
        testRFA.RequestTitle__c = 'Test Data Created in test class';
        testRFA.LCOACategorySubCategory__c = 'Testing 3 years Cash Spent';
        
        testRFA.Cost_Center_Number__c = idCostCenter; //[Select Id from Cost_Center__c limit 1].Id;

        testRFA.Legal_Entity__c = '【CCEJ】 Coca-Cola East Japan';
        testRFA.RequestAmountFunctionalCurrency__c = 1200;
        
        testRFA.Expected_Cash_Spend_Date__c = System.Today();
        testRFA.Expected_Capitalization_Date__c = System.Today();
        testRFA.ExpectedCommitmentDate__c = System.Today();
               
        testRFA.Objectives_Rationale_Background__c = 'test';
        testRFA.Benefits_Financial_Metrics_Assumptions__c = 'test';
        testRFA.Cost_Estimates__c = 'test';
        testRFA.Risks_and_Alternatives__c = 'test';
        testRFA.Other_Considerations__c = 'test';
        
        testRFA.IsthisanAnnualCapitalPlanrequest__c = 'Yes';
        testRFA.Budget_Approval_Number__c = 'Number';
        testRFA.InitialBudgetYear__c = '2013';
        testRFA.BudgetType__c = 'Formal';
        testRFA.OPEX_Amount__c = 1200;
        
        testRFA.DiscountedPaybackPeriodYears__c = 0.05;
        testRFA.IRR__c = 0.05;
        testRFA.CashflowYears__c = 3;
        testRFA.NPVUSD__c = 1200;

		Test.startTest();
        insert testRFA;
        Test.stopTest();
        
        return testRFA;
    }                

      
    
    public static void updateThreeYearCashSpentForRFA(RFA__c rfaObj, Double amount)
    {
        ThreeYearCashSpend__c[] cashSpents = [Select 
            //ARERate__c, 
            Name FROM ThreeYearCashSpend__c where RFA__c =: rfaObj.Id];
            
        cashSpents[0].X3YearCashSpendFunc__c = amount;
        update cashSpents[0];
    }
    
    public static void updateCapitalExpenditure(RFA__c rfaObj, Double amount)
    {
        Capital_Expenditure__c[] expenditureArray = [
            Select Amount__c 
            From Capital_Expenditure__c where RFA__c =: rfaObj.Id
        ];
        
        if(expenditureArray[0] != null) {
        	expenditureArray[0].Amount__c = amount;
        	update expenditureArray[0];
        }
        
    }
    
    //Approver
    public static RFAUserRole__c buildApprover(
        String rfaId, 
        User approver //, 
        //String level
    )
    {            
        RFAUserRole__c approver1 = new RFAUserRole__c();
        approver1.RFA__c = rfaId;
        approver1.UserName__c = approver.Id;
        //approver1.Level__c = level;
        approver1.RecordTypeId = RFAGlobalConstants.RECORDTYPESMAP.get(
            Schema.sObjectType.RFAUserRole__c.getName()).get(RFAConstants.RTLabel_RFAUserRole_Approver).Id;
        approver1.ApprovalOrder__c = 1;
        insert approver1;    
        return approver1;
    }
    //can delete?
    /*
    public static RFAUserRole__c buildApprover(
        String rfaId //, String level
        )
    {            
        RFAUserRole__c approver1 = new RFAUserRole__c();
        approver1.RFA__c = rfaId;
        //approver1.UserName__c = approver.Id;
        //approver1.Level__c = level;
        approver1.RecordTypeId 
            = RFAGlobalConstants.RECORDTYPESMAP.get(
                Schema.sObjectType.RFAUserRole__c.getName()).get(RFAGlobalConstants.APPROVER_RECORDTYPE).Id;
        return approver1;
    } */
    
    
    //Primary Point of Contact
    public static RFAUserRole__c buildPPOC(String rfaId, User PPOCUser)
    {
        RFAUserRole__c ppoc = new RFAUserRole__c();
        ppoc.RFA__c = rfaId;
        ppoc.UserName__c = PPOCUser.Id;
        ppoc.RecordTypeId 
            = RFAGlobalConstants.RECORDTYPESMAP.get(
                Schema.sObjectType.RFAUserRole__c.getName()).get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id;
        insert ppoc;
        return ppoc;   
    }
    //Info Copy Only
    public static RFAUserRole__c buildInfoOnlyUsers(String rfaId, User infoUsers)
    {
        RFAUserRole__c reviewer = new RFAUserRole__c();
        reviewer.RFA__c = rfaId;
        reviewer.UserName__c = infoUsers.Id;
        reviewer.RecordTypeId = RFAGlobalConstants.RECORDTYPESMAP.get(
            Schema.sObjectType.RFAUserRole__c.getName()).get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id;
        insert reviewer;
        return reviewer;
    }
    
    
    public void buildCapitalExpenditure() {
        List<RFACapitalExpenditure__c> CapitalExpenditureList = new List<RFACapitalExpenditure__c>();
        
        Id rtId1 = RFAConstants.getRecordType('Capital Project Request', 'Capital_Expenditure__c');
        
        RFACapitalExpenditure__c ceC1 = new RFACapitalExpenditure__c();
        ceC1.Name = 'CPR-1';
        ceC1.Record_Type_Name__c = 'Capital Project Request';
        ceC1.RecordTypeId__c = rtId1;
        ceC1.AssetCategory__c = '土地 / Land';
        ceC1.InvestmentObjective__c = '';
        CapitalExpenditureList.add(ceC1);

        RFACapitalExpenditure__c ceC2 = new RFACapitalExpenditure__c();
        ceC2.Name = 'CPR-2';
        ceC2.Record_Type_Name__c = 'Capital Project Request';
        ceC2.RecordTypeId__c = rtId1;
        ceC2.AssetCategory__c = '構築物 / Land Improvements';
        ceC2.InvestmentObjective__c = '';
        CapitalExpenditureList.add(ceC2);       
        
        RFACapitalExpenditure__c ceC3 = new RFACapitalExpenditure__c();
        ceC3.Name = 'CPR-3';
        ceC3.Record_Type_Name__c = 'Capital Project Request';
        ceC3.RecordTypeId__c = rtId1;
        ceC3.AssetCategory__c = 'ﾘｰｽ物件改良費 / Leasehold Improvements';
        ceC3.InvestmentObjective__c = '';
        CapitalExpenditureList.add(ceC3);       
        
        Id rtId2 = RFAConstants.getRecordType('Medium Project Request', 'Capital_Expenditure__c');
        
        RFACapitalExpenditure__c ceSA1 = new RFACapitalExpenditure__c();
        ceSA1.Name = 'SPR-1';
        ceSA1.Record_Type_Name__c = 'Medium Project Request';
        ceSA1.RecordTypeId__c = rtId2;
        ceSA1.AssetCategory__c = '土地 / Land';
        ceSA1.InvestmentObjective__c = 'その他の戦略的対応 / Strategic Initiatives';
        CapitalExpenditureList.add(ceSA1);

        RFACapitalExpenditure__c ceSA2 = new RFACapitalExpenditure__c();
        ceSA2.Name = 'SPR-2';
        ceSA2.Record_Type_Name__c = 'Medium Project Request';
        ceSA2.RecordTypeId__c = rtId2;
        ceSA2.AssetCategory__c = '土地 / Land';
        ceSA2.InvestmentObjective__c = '顧客ﾆｰｽﾞへの対応 / Customer Specific and Consumer Focus';
        CapitalExpenditureList.add(ceSA2);      
        
        RFACapitalExpenditure__c ceSA3 = new RFACapitalExpenditure__c();
        ceSA3.Name = 'SPR-3';
        ceSA3.Record_Type_Name__c = 'Medium Project Request';
        ceSA3.RecordTypeId__c = rtId2;
        ceSA3.AssetCategory__c = '土地 / Land';
        ceSA3.InvestmentObjective__c = '効率性/生産性向上 / Efficiency ・ Productivity';
        CapitalExpenditureList.add(ceSA3);          
        
        
        Id rtId3 = RFAConstants.getRecordType('Small Project Request', 'Capital_Expenditure__c');
        
        RFACapitalExpenditure__c ceSB1 = new RFACapitalExpenditure__c();
        ceSB1.Name = 'OPR-1';
        ceSB1.Record_Type_Name__c = 'Small Project Request';
        ceSB1.RecordTypeId__c = rtId3;
        ceSB1.AssetCategory__c = '土地 / Land';
        ceSB1.InvestmentObjective__c = 'その他の戦略的対応 / Strategic Initiatives';
        CapitalExpenditureList.add(ceSB1);

        RFACapitalExpenditure__c ceSB2 = new RFACapitalExpenditure__c();
        ceSB2.Name = 'OPR-2';
        ceSB2.Record_Type_Name__c = 'Small Project Request';
        ceSB2.RecordTypeId__c = rtId3;
        ceSB2.AssetCategory__c = '土地 / Land';
        ceSB2.InvestmentObjective__c = '顧客ﾆｰｽﾞへの対応 / Customer Specific and Consumer Focus';
        CapitalExpenditureList.add(ceSB2);      
        
        RFACapitalExpenditure__c ceSB3 = new RFACapitalExpenditure__c();
        ceSB3.Name = 'OPR-3';
        ceSB3.Record_Type_Name__c = 'Small Project Request';
        ceSB3.RecordTypeId__c = rtId3;
        ceSB3.AssetCategory__c = '土地 / Land';
        ceSB3.InvestmentObjective__c = '効率性/生産性向上 / Efficiency ・ Productivity';
        CapitalExpenditureList.add(ceSB3);          
        
        insert CapitalExpenditureList;
        
        //return null;
    }
    
    public Attachment buildAttachment(Id RFAId) {
        Attachment attach = new Attachment();
        Blob body = Blob.valueOf('Some Text');
        attach.Body = body;
        // add the user entered name
        attach.Name = 'RFA_Attachment.pdf';
        attach.IsPrivate = false;
        // attach the pdf to the account
        attach.ParentId = RFAId;        
        insert attach;
        return attach;
    }
    
    public static RFA__c buildRFAGeneral() {
        RFATestData inst = new RFATestData();
        inst.buildCostCenter('Commercial');
        inst.buildProfitCenter();
        inst.buildProfitCenterUserRole(testProfitCenter.id);
        inst.buildTaxRate();           
        RFA__c rfa = createTestRFAwithType('Draft', 'General Request', 1200);
        
        User auser = inst.createRequester();
        RFAUserRole__c approver = buildApprover(rfa.Id, auser);
        RFAUserRole__c ppoc = buildPPOC(rfa.Id, auser);
        RFAUserRole__c infoonly = buildInfoOnlyUsers(rfa.Id, auser);    
        return rfa;
    }
    
    private static testMethod void testRFAGeneral() {
        RFATestData inst = new RFATestData();
        inst.buildCostCenter('Commercial');
        inst.buildProfitCenter();
        inst.buildProfitCenterUserRole(testProfitCenter.id);
        //inst.buildProfitCenterUserRole(testProfitCenterGeneral.id);
        inst.buildTaxRate();           
        
        Test.startTest();
        RFA__c rfa = createTestRFAwithType('Draft', 'General Request', 1200);
        Test.stopTest();
        
        User auser = inst.createRequester();
        RFAUserRole__c approver = buildApprover(rfa.Id, auser);
        RFAUserRole__c ppoc = buildPPOC(rfa.Id, auser);
        RFAUserRole__c infoonly = buildInfoOnlyUsers(rfa.Id, auser);
        
        Attachment attach = inst.buildAttachment(rfa.Id);
        
        RFA_Util_ObjectQuery instUtil = new RFA_Util_ObjectQuery();
        instUtil.getRFAwChilds(rfa.Id);
        instUtil.getAttachment(attach.Id);
        instUtil.getUserRole(approver.Id);
    }
    
    public static RFA__c buildRFACapital() {
        RFATestData inst = new RFATestData();
        inst.buildCostCenter('Commercial');
        inst.buildProfitCenter();
        inst.buildProfitCenterUserRole(testProfitCenter.id);
        inst.buildTaxRate();
        
        inst.buildCapitalExpenditure();
        
        Test.startTest();
        integer amount = 70000000;
        RFA__c testRFACapital = createTestRFAwithType('Draft', 'Capital Project Request', amount);
        Test.stopTest();
        
        inst.buildAttachment(testRFACapital.Id);
        
        User auser = inst.createRequester();
        RFAUserRole__c approver = buildApprover(testRFACapital.Id, auser);
        RFAUserRole__c ppoc = buildPPOC(testRFACapital.Id, auser);
        RFAUserRole__c infoonly = buildInfoOnlyUsers(testRFACapital.Id, auser);  
        
        updateThreeYearCashSpentForRFA(testRFACapital, amount);  
        updateCapitalExpenditure(testRFACapital, amount); 
        
        return testRFACapital;      
    }    
    
    private static testMethod void testRFACapital() {   
        RFA__c testRFA = RFATestData.buildRFACapital();
        
        RFAUserRole__c testRFARole = [Select Id, UserName__c, RFA__c 
            from RFAUserRole__c where RFA__c =: testRFA.Id limit 1];
    }
    
    public static RFA__c buildRFASmallA() {
        RFATestData inst = new RFATestData();
        inst.buildCostCenter('Commercial');
        inst.buildProfitCenter();
        inst.buildProfitCenterUserRole(testProfitCenter.id);
        inst.buildTaxRate();
        
        inst.buildCapitalExpenditure();
             
        Test.startTest();
        integer amount = 40000000;
        RFA__c testRFASmallA = createTestRFAwithType('Draft', 'Medium Project Request', amount);
        Test.stopTest();
        
        inst.buildAttachment(testRFASmallA.Id);

        User auser = inst.createRequester();
        RFAUserRole__c approver = buildApprover(testRFASmallA.Id, auser);
        RFAUserRole__c ppoc = buildPPOC(testRFASmallA.Id, auser);
        RFAUserRole__c infoonly = buildInfoOnlyUsers(testRFASmallA.Id, auser);    
        
        updateThreeYearCashSpentForRFA(testRFASmallA, amount);  
        updateCapitalExpenditure(testRFASmallA, amount);   
        
        return testRFASmallA;        
    }    

    public static RFA__c buildRFASmallB() {
        RFATestData inst = new RFATestData();
        inst.buildCostCenter('Commercial');
        inst.buildProfitCenter();
        inst.buildProfitCenterUserRole(testProfitCenter.id);
        //inst.buildProfitCenterUserRole(testProfitCenterGeneral.id);
        inst.buildTaxRate();
        
        inst.buildCapitalExpenditure();   
        
        Test.startTest();     
        integer amount = 5000;
        RFA__c testRFASmallB = createTestRFAwithType('Draft', 'Small Project Request', amount);
        Test.stopTest();
        
        inst.buildAttachment(testRFASmallB.Id);
        
        User auser = inst.createRequester();
        RFAUserRole__c approver = buildApprover(testRFASmallB.Id, auser);
        RFAUserRole__c ppoc = buildPPOC(testRFASmallB.Id, auser);
        RFAUserRole__c infoonly = buildInfoOnlyUsers(testRFASmallB.Id, auser);          
        
        updateThreeYearCashSpentForRFA(testRFASmallB, amount);  
        updateCapitalExpenditure(testRFASmallB, amount);   
        
        return testRFASmallB;      
    }
    

    

    
    public static PageReference getPageReference(String page, Map<String, String> params) {
        String url = '/apex/'+page+'?';
        for (String param : params.keySet()) {
            url += param + '=' + params.get(param) + '&';
        }
        PageReference p = new PageReference(url);
        return p;
    }    
    
}