public with sharing class HR_Evaculation3Controller {
public List<HR_Primary_Evaluators__c> EvaculationList1    {get;set;}
public HR_Primary_Evaluators__c Evaculation1    {get;set;}
public List<HR_Primary_Evaluators__c> EvaculationList2    {get;set;}
public HR_Primary_Evaluators__c Evaculation2    {get;set;}

public ApexPages.StandardSetController sstc {get;set;}


    public HR_Evaculation3Controller(ApexPages.StandardController stc)
    {
        EvaculationList1 = new List<HR_Primary_Evaluators__c>();
        EvaculationList2 = new List<HR_Primary_Evaluators__c>();
         
        
                 
        //一次担当情報を取得
        for(HR_Primary_Evaluators__c hrpe1:[SELECT Name,Primary_Assessment_Rank1__c,
        											   Primary_Assessment_Rank2__c,
        											   Primary_Assessment_Rank3__c,
        											   Primary_Assessment_Rank4__c,
        											   Primary_Assessment_Rank5__c
        											   FROM HR_Primary_Evaluators__c
        											   WHERE Manager__r.Applicant__c=:UserInfo.getName()]) {
        	Evaculation1 = new HR_Primary_Evaluators__c();
        	Evaculation1.Name=hrpe1.Name;
	        Evaculation1.Primary_Assessment_Rank1__c=hrpe1.Primary_Assessment_Rank1__c	;
	        Evaculation1.Primary_Assessment_Rank2__c=hrpe1.Primary_Assessment_Rank2__c	;
	        Evaculation1.Primary_Assessment_Rank3__c=hrpe1.Primary_Assessment_Rank3__c	;
	        Evaculation1.Primary_Assessment_Rank4__c=hrpe1.Primary_Assessment_Rank4__c	;
	        Evaculation1.Primary_Assessment_Rank5__c=hrpe1.Primary_Assessment_Rank5__c	;
	        EvaculationList1.add(Evaculation1);        	
        }
        
        //二次担当情報を取得
        for(HR_Primary_Evaluators__c hrpe2:[SELECT Name,Primary_Assessment_Rank1__c,
        											   Primary_Assessment_Rank2__c,
        											   Primary_Assessment_Rank3__c,
        											   Primary_Assessment_Rank4__c,
        											   Primary_Assessment_Rank5__c
        											   FROM HR_Primary_Evaluators__c
        											   WHERE Manager__r.Manager__r.Applicant__c=:UserInfo.getName()]) {
        	Evaculation2 = new HR_Primary_Evaluators__c();
        	Evaculation2.Name=hrpe2.Name;
	        Evaculation2.Primary_Assessment_Rank1__c=hrpe2.Primary_Assessment_Rank1__c	;
	        Evaculation2.Primary_Assessment_Rank2__c=hrpe2.Primary_Assessment_Rank2__c	;
	        Evaculation2.Primary_Assessment_Rank3__c=hrpe2.Primary_Assessment_Rank3__c	;
	        Evaculation2.Primary_Assessment_Rank4__c=hrpe2.Primary_Assessment_Rank4__c	;
	        Evaculation2.Primary_Assessment_Rank5__c=hrpe2.Primary_Assessment_Rank5__c	;
	        EvaculationList2.add(Evaculation2);        	
        }

        /*EvaculationList.add('ABC');
        EvaculationList.add('DEF');
        EvaculationList.add('GHI');
        EvaculationList.add('JKL');
        EvaculationList.add('MNO');
        EvaculationList.add('PQR');
        EvaculationList.add('STU');
        EvaculationList.add('VWX');
        EvaculationList.add('YZ');*/
    }
}