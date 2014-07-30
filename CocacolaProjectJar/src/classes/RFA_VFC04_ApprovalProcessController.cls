/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VFC04_ApprovalProcessController extends RFA_Util_SecurityMatrix
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 4/6/2012 
 *  Assumptions      : N/A
 *  Description      : This class contains logic for taking approval recommendation from the approvers/agents.
 *
 *  updated by Jia Hu on 2013/11/01
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
/*
	called from VF page: RFA_VFP05_ApprovalRecommendation
*/
public class RFA_VFC04_ApprovalProcessController extends RFA_Util_SecurityMatrix
{
    // instance variable for UserAccess set in RFA_Util_SecurityMatrix
    private UserAccess uAccess;
    
    // instance variable of RFAuserRole__c
    public RFAUserRole__c appWorkItem {get; set;}
    
    // variable for selected approval workitem
    public String selectedWorkItem {get; set;}
    
    // variable for storing the recommendation selected by the user
    public String selectedRecommendation {get; set;}
    
    // instance variable of RFA__c
    public RFA__c rfaObj {get; private set;}
    
    // variable for storing the approval comments provided by the user
    public String approvalComments {get; set;}
    public String approvalNotes {get; set;}
    
    // instance list variable for workitem options
    public List<SelectOption> workItemOptions {get; set;}
    
    // identifier variable for transaction failure
    public boolean hasError {get; private set;}
    
    // list variable of workitem list with approver/agent details
    public static List<RFAUserRole__c> onBehalfList = new List<RFAUserRole__c>();
    
    // constructor for the class.  
    public RFA_VFC04_ApprovalProcessController(ApexPages.StandardController controller)
    {
        // call parent class constructor
        super(controller);  
        // set rfaobj
        this.rfaObj = (RFA__c)controller.getRecord();
        // get UserAccess security settings
        uAccess = getRFAUserAccess();
        system.debug('---------  RFA_VFC04_ApprovalProcessController(): ' + uAccess);
        if(uAccess.isApprover() || uAccess.isAgent()) {
        	prepareWorkItem();         
        }   
        
        system.debug('------ RFA_VFC04_ApprovalProcessController(): selectedRecommendation: ' + selectedRecommendation);
    }
    
    public Pagereference testActionSupportForSelection() {
    	system.debug('------ testActionSupportForSelection(): selectedRecommendation: ' + selectedRecommendation);
    	return null;
    }
			      
    /*
      @Method <getter and setter method to check if the logged in user is agent>
      @param <None> 
      @return <boolean>
     */
    public boolean isAgent{
        get{
            return uAccess.isAgent();
        }	
        private set;
    }	
	      
      
    /*
      @Method <getter and setter method to check if the logged in user is approve>
      @param <None> 
      @return <boolean>
    */
    public boolean isApprover{
        get{
            return uAccess.isApprover();
        }
        private set;
    }
	      
    /*
    	@Method Prepare ACT ON BEHALF select list for the usert>
        @param <None> 
        @return <void>
    */    
    public void prepareWorkItem()
    {
        String loggedInUser = UserInfo.getUserId();
        onBehalfList = RFA_AP03_ApprovalProcessHelper.getApproversForProcess(loggedInUser, rfaObj);  
        workItemOptions = new List<SelectOption>();
                                    
        for(RFAUserRole__c wi : onBehalfList)
        {
            if(wi.UserName__c == loggedInUser)
            {
                workItemOptions.add(new SelectOption(wi.Id, wi.UserName__r.Name));  
            }
            else if(wi.Agent1__c == loggedInUser)
            {
                workItemOptions.add(new SelectOption(wi.Id, wi.UserName__r.Name));  
            }
            else if(wi.Agent2__c == loggedInUser)
            {
                workItemOptions.add(new SelectOption(wi.Id, wi.UserName__r.Name)); 
            }
            else if(wi.Agent3__c == loggedInUser)
            {
                workItemOptions.add(new SelectOption(wi.Id, wi.UserName__r.Name)); 
            }
        }	                          
    }	
		      
      
    /*
    	@Method <Action method executed when the user clicks on "Submit" button, method contains logic to insert recommendation>
        @param <None> 
        @return <pagereference>
    */
    //Submit button on Page: RFA_VFP05_ApprovalRecommendation
    public pageReference submitRecommendation()
    {
    	system.debug('------- In pageReference submitRecommendation() ');
    	try{
                hasError = false;
                if(selectedRecommendation == '--Select Recommendation--') {
                	throw new ApprovalException(
                	Label.RFA_ErrorMsg_SelectRecommendation
                	//'推奨を選択してください / Please provide a Recommendation'
                	);
                }
                
                //updated by Jia Hu on 2013/11/11
                //why there is a space in the condition? approvalComments == ' '
                //commment is needed for all selection now!
                //if(selectedRecommendation == 'Conditionaly Approved' && approvalComments == ' ') throw new ApprovalException('Please enter comments'); 
                if(
                	( RFAConstants.isBlank(approvalComments)
                	)
                	&& 
                	(
                		(selectedRecommendation != RFAConstants.ApproverRecommend_UnconditionalApproved
                			//'Unconditionally Approved'
                		) 
                		//|| 
                		//(selectedRecommendation != '承認（条件なし）') 
                	) 
                	//&& (selectedRecommendation != RFAConstants.ApproverRecommend_UnconditionalApproved_JP
                		//'承認（条件なし）'
                	//	)             	
                ) {
                	//if(selectedRecommendation == RFAConstants.ApproverRecommend_ReturnToRequester) {
                	//	throw new ApprovalException(
                	//	)
                	//} else { 
                		throw new ApprovalException(
                			Label.RFA_ErrorMsg_CommentRQ
                			//'コメントを入力してください / Please enter comments'
                		);  
                	//}
                }
                               
                System.debug('\n Selected Approval workitem : ' + selectedWorkItem);
                RFAUserRole__c approval = new RFAUserRole__c(Id = selectedWorkItem);
                approval.ApprovedBy__c = UserInfo.getUserId();
                approval.ApprovalRecievedDateTime__c = DateTime.now();
                approval.ApprovalComments__c = approvalComments;
                approval.ApprovalNotes__c = approvalNotes;
                system.debug('------ approval.ApprovalComments__c: ' + approval.ApprovalComments__c);
                approval.ApprovalRecommendation__c = selectedRecommendation;
                update approval;       
                
                if(selectedRecommendation == RFAConstants.ApproverRecommend_ReturnToRequester) {
                	rfaObj.Stage__c = RFAConstants.RFA_STATUS_ReturnToRequester;
                	rfaObj.ReturnReason__c = approvalComments;
                	update rfaObj;
                }
                
                //update approval; 
                
            }
            catch(ApprovalException appEx)
            {
            	system.debug('------- ApprovalException: ' + appEx);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, appEx.getMessage()));
                hasError = true;
                return null;    
            } 
            catch(Exception ex)
            {
            	system.debug('------- Exception: ' + ex);
                if(!ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))              
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); 
                
                hasError = true;
                return null;
            }  
            return null;
    }
	      	      	      
    /*
    	@Method <getter and setter method for approval recommendation option>
        @param <None> 
        @return <List<SelectOption>>
    */
    //updated by Jia Hu on 2013/11/14
    //add Japanese support
    public List<SelectOption> recommendationOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
                  List<Schema.PicklistEntry> ple = RFAUserRole__c.ApprovalRecommendation__c.getDescribe().getPicklistvalues();
                  options.add(new SelectOption('--Select Recommendation--', '--Select Recommendation--'));
                  for(Schema.PicklistEntry schemaPle : ple)
                  {
                    if(! (schemaPle.getLabel().contains(
                    	RFAConstants.ApproverRecommend_AwaitingApproval
                    	//'Awaiting Approval'
                    	) 
                    	//|| 
                    	//schemaPle.getLabel().contains(
                    	//	RFAConstants.ApproverRecommend_AwaitingApproval_JP
                    		//'承認待ち'
                    	//) 
                    	) 
                    )  //承認待ち
                        options.add(new SelectOption(schemaPle.getLabel(), schemaPle.getValue()));
                  }
                  return options;                            
        }
        private set;
    }
      
    // Custom Exception class extending Exception.	      
    public class ApprovalException extends Exception{}
	          
}