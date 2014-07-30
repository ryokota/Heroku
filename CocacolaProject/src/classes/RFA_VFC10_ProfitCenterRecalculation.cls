/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VFC10_ProfitCenterRecalculation
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 07/10/2012
 *  Assumptions      : N/A
 *  Description      : Class for calling the schedule function for sharing recalculation from RFA_VFP10_ProfitCenterRecalculation. 
 *
 *  updated by Jia Hu on 2013/11/05                                   
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
//controller of VF page: RFA_VFP10_ProfitCenterRecalculation
//<apex:page standardController="ProfitCenter__c" extensions="RFA_VFC10_ProfitCenterRecalculation" action="{!callRecalculationMethod}">
//called from Update Sharing for Attached RFAs/Update_Sharing_for_Attached_RFAs button on Profit Center
public class RFA_VFC10_ProfitCenterRecalculation {
    
    /*~~~~Start of Variable Initialization~~~~*/ 
    public ProfitCenter__c profitCenter {get; set;}
    public String Query;   
    /*~~~~End of Variable Initialization~~~~*/
    
    /**
     * Constructor
     */
    public RFA_VFC10_ProfitCenterRecalculation (ApexPages.StandardController stdController) {
    	profitCenter = (ProfitCenter__c)stdController.getRecord();
    }
    
    /**
     *  pageReference method
     *  @param 
     *  @return pageReference   
     */
            
    public pageReference callRecalculationMethod()
    {
    	Query = 'Select Id, Name from ProfitCenter__c where Id = \'' + profitCenter.Id 
    		+ '\' and NeedRecalculation__c = true and ActiveInactive__c = \'Active\' ';
    	System.debug('------------- pageReference callRecalculationMethod(): query: ' + Query);
    	
    	RFA_AP09_Realignment controller = new RFA_AP09_Realignment(Query) ;
    
    	//updated by Jia Hu on 2014/03/07
    	Integer batchSize = 200;
    	//Integer batchSize = 1;
    	database.executebatch(controller , batchSize);
    	pageReference pref;
    	ApexPages.StandardController sc = new ApexPages.StandardController(profitCenter);
    	pref = sc.view();
    	pref.setRedirect(true);
    	return pref;
    }
    

}