public with sharing class RFA_PDF_RelatedListController {
    
public RFA__c RFA    {get;set;}
//public List<RFA__c> RFAList1    {get;set;}
//public List<RFA__c> RFAList2    {get;set;}
//public List<RFA__c> RFAList3    {get;set;}
public List<RFAUserRole__c> RFAUserRoleList    {get;set;}
public List<ThreeYearCashSpend__c> ThreeYearCashSpendList    {get;set;}

    public RFA_PDF_RelatedListController(ApexPages.StandardController sc)
    {
        RFA = new RFA__c();
        RFA = (RFA__c) sc.getrecord();
//      RFAList1 = new List<RFA__c>();
//      RFAList2 = new List<RFA__c>();
//      RFAList3 = new List<RFA__c>();
        RFAUserRoleList = new List<RFAUserRole__c>();
        ThreeYearCashSpendList = new List<ThreeYearCashSpend__c>();
/*      
        if(RFA.Related_RFA_1__c != null){
        
            RFAList1 = [SELECT Name,RecordType.Name,RequestTitle__c,
                    RequestAmountFunctionalCurrency__c,Stage__c,
                    CreatedBy.Name,CreatedDate,LastModifiedBy.Name,
                    LastModifiedDate 
                    FROM RFA__c 
                    WHERE ID=:RFA.Related_RFA_1__c
                    Order By Name];
            
        }

        if(RFA.Related_RFA_2__c != null){
            RFAList2 = [SELECT Name,RecordType.Name,RequestTitle__c,
                        RequestAmountFunctionalCurrency__c,Stage__c,
                        CreatedBy.Name,CreatedDate,LastModifiedBy.Name,
                        LastModifiedDate 
                        FROM RFA__c 
                        WHERE ID=:RFA.Related_RFA_2__c
                        Order By Name]; 
        }

        if(RFA.Related_RFA_3__c != null){
            RFAList3 = [SELECT Name,RecordType.Name,RequestTitle__c,
                        RequestAmountFunctionalCurrency__c,Stage__c,
                        CreatedBy.Name,CreatedDate,LastModifiedBy.Name,
                        LastModifiedDate 
                        FROM RFA__c 
                        WHERE ID=:RFA.Related_RFA_3__c
                        Order By Name]; 
        }
*/
        RFAUserRoleList = [SELECT RecordTypeId,ApprovalOrder__c,UserName__r.Name,
                            L2_Function__c,Department__c,Company_Name__c,COA_Group__c,
                            COA_Acronym__c,ApprovalRecommendation__c 
                            FROM RFAUserRole__c 
                            WHERE RFA__c=:RFA.ID
                            Order By RecordTypeId,ApprovalOrder__c];

        ThreeYearCashSpendList = [SELECT Year__c,X3YearCashSpendFunc__c,Q1CashSpendFunc__c,
                                Q2CashSpendFunc__c,Q3CashSpendFunc__c,Q4CashSpendFunc__c,
                                IncrementalVolumebyYear__c 
                                FROM ThreeYearCashSpend__c 
                                WHERE RFA__c=:RFA.ID
                                Order By Year__c];

    }

}