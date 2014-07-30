//Controller for VF page: RFA_Requester_Close
public class RFA_VFC_RequesterCloseController extends RFA_Util_SecurityMatrix {

    /*~~~~Start of Variable Initialization~~~~*/
    public RFA__c rfaObj {get; set;}    

    //public String selectedStage{get;set;} 
    public String selectedLevel {get; set;}    
    //private Boolean allowAccess = false;
    public boolean hasError {get; private set;}    
    //public String returnReason{get; set;}   
    public String closeReason {get; set;} 
    //private String currentLevel;  
    public String currentStage;   
    //private String lc; //Added by BSA for INC0346541 - 14-Feb-2013  
    /*~~~~End of Variable Initialization~~~~*/
       
    // constructor for the class.
    public RFA_VFC_RequesterCloseController(ApexPages.StandardController controller) 
    {
        super(controller);
        rfaObj = (RFA__c)controller.getRecord();
        
        if(rfaObj.Id <> null)
        {         
            this.currentStage = rfaObj.Stage__c;
        }
    }
    
    public List<SelectOption> getLevel()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(
        	new SelectOption(
        		//RFAGlobalConstants.RFA_STAGE_CLOSED
        		RFAConstants.RFA_STATUS_CLOSED
        		, 
        		RFAConstants.RFA_STATUS_CLOSED
        		//RFAGlobalConstants.RFA_STAGE_CLOSED
        	));  
        /*
        List<Schema.PicklistEntry> ple = RFA__c.Level__c.getDescribe().getPicklistValues();
        for(Schema.Picklistentry entry : ple)
        {
            options.add(new SelectOption(entry.getLabel(), entry.getValue()));
        }*/               
        return options; 
    }
          
    //Close RFA button on VF page: RFA_Requester_Close (Requester Action Button)
    public pageReference updateRFA()
    {
                //reset error variable
                hasError = false;
                // User query to fetch profile Name for logged In user to bypass the custom validation
               // User usr = [Select Profile.Name, id from User where id =: UserInfo.getUserId() Limit 1]; 
                //need support for Japanese here
              //  String UserNameProfile = usr.Profile.Name;
                //System.debug('\n Selected level : ' + selectedLevel + RFAGlobalConstants.RETURN_TO_SENDER);
                //System.debug('\n Selected Stage : ' + selectedStage);
                System.debug('\n returned reason from db : ' + rfaObj.Close_Reason__c);
                System.debug('\n returned reason from ui : ' + closeReason);
 
                //this.profitCenterId = rfaObj.ProfitCenterNumber__c;                
                //Map<Id, List<ProfitCenterUserRole__c>> profitCenterMap 
                //    = new Map<Id, List<ProfitCenterUserRole__c>>();
               
                if(ApexPages.hasMessages()) 
                {
                    hasError = true;
                    return null;                                       
                }
                
                if(
                	(
                    currentStage == RFAConstants.RFA_STATUS_ReturnToRequester
                    	//RFAGlobalConstants.RETURN_TO_SENDER
                    ||
                    currentStage == RFAConstants.RFA_STATUS_DRAFT
                    	//RFAGlobalConstants.RFA_STAGE_DRAFT
                    )
                    &&
                    selectedlevel == RFAConstants.RFA_STATUS_CLOSED
                    	//RFAGlobalConstants.RFA_STAGE_CLOSED
                )
                {                 
                    system.debug('------- closeReason: ' + closeReason);
                    if(
                    	RFAConstants.isBlank(closeReason)
                    	//closeReason == null || closeReason == ' ' || closeReason.length() == 0
                    	) {
                    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    		Label.RFA_Msg_CloseReason
                    		//'クローズ理由を入力してください! / Please input Close Reason!'
                    	));
                    	hasError = true;
                    } else {                 
                    	rfaObj.Stage__c = RFAConstants.RFA_STATUS_CLOSED; //'Closed';   	
                    	rfaObj.Close_Reason__c = closeReason;  
                    	update rfaObj;
                    	//hasError = false;
                    	//return new PageReference('javascript:window.close()'); 
                    	new PageReference('/'+rfaObj.Id);
                    }                     
                } 
               
            return null;
    }

}