/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VFC03_OverrideController
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 05/15/2012
 *  Assumptions      : N/A
 *  Description      : This class is called from the visualforce page RFA_VFP02_Override and contains logic to
 *
 * updated by Jia Hu on 2013/10/30
 * Tasks: adding support for Japanese environment                                 
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
/*
	Controller of VF page: RFA_VFP02_Override
*/
public class RFA_VFC03_OverrideController extends RFA_Util_SecurityMatrix {

    /*~~~~Start of Variable Initialization~~~~*/
    public RFA__c rfaObj {get; set;}    
    public Id profitCenterId {get; set;}   
    //public String selectedStage{get;set;} 
    public String selectedLevel {get; set;}    
    private Boolean allowAccess = false;
    public boolean hasError {get; private set;}    
    public String returnReason {get; set;}   
    //private String currentLevel;  
    private String currentStage;   
    private String lc; //Added by BSA for INC0346541 - 14-Feb-2013  
    /*~~~~End of Variable Initialization~~~~*/
       
    // constructor for the class.
    public RFA_VFC03_OverrideController(ApexPages.StandardController controller) 
    {
        super(controller);
        rfaObj = (RFA__c)controller.getRecord();
        
        if(rfaObj.Id <> null)
        {
            //this.currentLevel = rfaObj.Level__c;           
            this.currentStage = rfaObj.Stage__c;
        }
    }
    
    public List<SelectOption> getLevel()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(
        	RFAConstants.RFA_STATUS_ReturnToRequester
        	//RFAGlobalConstants.RETURN_TO_SENDER
        	, 
        	RFAConstants.RFA_STATUS_ReturnToRequester
        	//RFAGlobalConstants.RETURN_TO_SENDER
        	));  
        /*
        List<Schema.PicklistEntry> ple = RFA__c.Level__c.getDescribe().getPicklistValues();
        for(Schema.Picklistentry entry : ple)
        {
            options.add(new SelectOption(entry.getLabel(), entry.getValue()));
        }*/               
        return options; 
    }
          
    //Override button on VF page: RFA_VFP02_Override (Coordinator Action Button)
    public pageReference updateRFA()
    {
    	system.debug('--------- returnReason from input: ' + returnReason);
		    	
    	//if(returnReason == null || returnReason.length() == 0 ) {
    	//	system.debug('--------- returnReason : ' + returnReason);
        //            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '差し戻し理由を入力してください! / Please input Return Reason!'));
        //            	//throw new MyException('コメントを入力してください / Please enter reason'); 
    	//}           
            //System.savepoint sp = Database.setSavepoint();
            try
            {
                //reset error variable
                hasError = false;
                // User query to fetch profile Name for logged In user to bypass the custom validation
                User usr = [Select Profile.Name, id from User where id =: UserInfo.getUserId() Limit 1]; 
                //need support for Japanese here
                String UserNameProfile = usr.Profile.Name;
                //System.debug('\n Selected level : ' + selectedLevel + RFAGlobalConstants.RETURN_TO_SENDER);
                //System.debug('\n Selected Stage : ' + selectedStage);
                System.debug('\n returned reason from db : ' + rfaObj.ReturnReason__c);
                System.debug('\n returned reason from ui : ' + returnReason);
                /*
                if(
                	  !selectedlevel.equalsIgnoreCase(RFAGlobalConstants.RETURN_TO_SENDER)
                   //&& !selectedLevel.equalsIgnoreCase(RFAGlobalConstants.CAPITAL_MGMT_HOLD)
                   //&& !selectedLevel.equalsIgnoreCase(RFAGlobalConstants.PENDING_BOARD_REVIEW)
                   && (selectedStage == null || selectedStage.equalsIgnoreCase('--None--')
                  )
                )
                {
                    rfaObj.addError('Please select a stage for overriding the RFA');
                    hasError = true;
                    return null;
                }
                */
                
                this.profitCenterId = rfaObj.ProfitCenterNumber__c; 
                
                Map<Id, List<ProfitCenterUserRole__c>> profitCenterMap 
                	= new Map<Id, List<ProfitCenterUserRole__c>>();
                
                if(ApexPages.hasMessages()) 
                {
                    hasError = true;
                    return null;                                       
                }
                
                //??!! RTC with approval process, reset approval process
                if(currentStage == RFAConstants.RFA_STATUS_CIRCULATION
                	//RFAGlobalConstants.RFA_CIRCULATION_STAGE
                	)
                {
                    Map<Id, ApprovalProcess__c> approvalProcessMap 
                    	= RFA_AP03_ApprovalProcessHelper.getActiveProcessInstances(new Set<String>{rfaObj.Id});
                    
                    if(!approvalProcessMap.isEmpty()) {RFA_AP03_ApprovalProcessHelper.resetApprovalWorkItems(approvalProcessMap);}
                }
                
                /*
                	added by Jia Hu on 2013/11/06
                	for three specific levels, setting up the same value to Stage
                */
                if(
                	//selectedLevel == RFAGlobalConstants.PENDING_BOARD_REVIEW 
                	//|| selectedLevel == RFAGlobalConstants.CAPITAL_MGMT_HOLD 
                	//|| 
                	selectedlevel == RFAConstants.RFA_STATUS_ReturnToRequester
                		//RFAGlobalConstants.RETURN_TO_SENDER
                )
                {
                    //rfaObj.Level__c = selectedLevel;  
                    
                    
                    //updated by Jia Hu on 2013/12/03
                    if( RFAConstants.isBlank(returnReason)
                    	//returnReason == null || returnReason == ' ' || returnReason.length() == 0 
                      ) {
                    	system.debug('--------- returnReason from input: ' + returnReason);
                    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    		Label.RFA_ErrorMsg_ReturnReason
                    		//'差し戻し理由を入力してください! / Please input Return Reason!'
                    		));
                    	hasError = true;
                    	//throw new MyException('コメントを入力してください / Please enter reason'); 
                    } else {
                    	rfaObj.Stage__c = selectedLevel;  
                    	rfaObj.ReturnReason__c = returnReason;   
                    	update rfaObj; 
                    }
                    /*  
                    if(selectedlevel == RFAGlobalConstants.RETURN_TO_SENDER)
                    {
                        //rfaObj.PreviousLevel__c = currentLevel;
                        rfaObj.ReturnReason__c = returnReason;    
                        rfaObj.Stage__c = RFAGlobalConstants.RETURN_TO_SENDER;
                    } */
                    /*
                    else if(selectedlevel == RFAGlobalConstants.PENDING_BOARD_REVIEW) {
                    	rfaObj.Stage__c = RFAGlobalConstants.PENDING_BOARD_REVIEW;
                    } else if(selectedlevel == RFAGlobalConstants.CAPITAL_MGMT_HOLD) {
                    	rfaObj.Stage__c = RFAGlobalConstants.CAPITAL_MGMT_HOLD;
                    } */
                    
                    //commented by Jia Hu on 2013/11/06
                    //rfaObj.Stage__c = '';
                    
                } 
                /*
                else{                	
                    rfaObj.Stage__c = selectedStage;
                    rfaObj.Level__c = selectedLevel;    
                }*/
               
                //update rfaObj;
                //Database.Saveresult result = Database.update(rfaObj);
                
                 
            } catch(Exception ex)
            {
                System.debug('\n Exception caught');
                hasError = true;
                if(!ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))              
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); 
                //Database.rollback(sp);
                
               return null;               
            }
            return null;
            // new PageReference('/'+rfaObj.Id);
    }
    
    //can delete??
    /*
    public void validateOperation(Map<Id, List<ProfitCenterUserRole__c>> profitCenterMap)
    {      
        //<Start> - Added by BSA for INC0346541 - 14-Feb-2013
       	lc = null;
        ProfitCenter__c pc = [SELECT Id, Name, 
        	(Select id, UserName__c, 
        		//Level__c, 
        		Usertype__c 
        	from Profit_Center_Associated_Users__r 
        	where 
        		//UserType__c='Coordinator' 
        		//AND Level__c=: selectedLevel 
        		//AND 
        		UserName__c =: UserInfo.getUserId() Limit 1) //Location Coordinator
            FROM ProfitCenter__c
            WHERE Id =: profitCenterId];
    	List<ProfitCenterUserRole__c> locCoordinator  = pc.Profit_Center_Associated_Users__r;
    	 
    	 if(locCoordinator.size() > 0)
       	 {
       	 	ProfitCenterUserRole__c lc = locCoordinator.get(0);
       	 }
       	 else
       	 {
       	 	lc='';
       	 } 
    	//<End> - Added by BSA for INC0346541 - 14-Feb-2013
        
        
         for(ProfitCenterUserRole__c tempMap: profitCenterMap.get(rfaObj.profitCenterNumber__c) )
         {    	                    
             if(tempMap.UserName__C == UserInfo.getUserId())// UserInfo.getProfileId()!='00ed00000012gBs'  )
             {
                allowAccess=True;             
             }
                
             if(tempMap.UserName__C == UserInfo.getUserId() && tempMap.UserType__c != 'Coordinator')// UserInfo.getProfileId()!='00ed00000012gBs'  ) //Location Coordinator
             {
                   hasError = true; 
                   //RFA_CL100: You do not have permission to override the stage.
                   rfaObj.addError(Label.RFA_CL100);                 
             }   
         }
         	//EXCEPTION_NOT_PART_OF_PC = Label.RFA_CL079;  User is not part of this Profit Center.
           if(allowAccess == false) {
           		rfaObj.addError(RFAGlobalConstants.EXCEPTION_NOT_PART_OF_PC);
           }                            
    }*/
    
	//public class MyException extends Exception{}

}