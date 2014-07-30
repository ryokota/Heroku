/*
    Author           : Accenture
    Date Created     :  5/18/2012
    Description      : This class is called from the visualforce page <PAGE NAME> and contains logic pertaining to the closing of an RFA    
                       
    Version          : 2.0 
    
    updated by Jia Hu 0n 2013/10/29
    called from VF page: RFA_VFP06_RFAClosing
*/ 
//Controller of Page: RFA_VFP06_RFAClosing
public class RFA_VFC05_RFAClosingController{    
    // variable for holding the user selected stage value
    public String selectedStage {get; set;}   
    // variable for holding the in context rfa
    public RFA__c rfaObj {get; set;}
    // variable for determining the error during the processing
    public boolean hasError {get; private set;}
    // variable for determining the validation check for Approver
    public boolean hasApproved {get; private set;}
    public boolean atInfoCopy {get; private set;}
    // variable for holding the approver ID's
    public String approverIds {get;set;}   

    public static Map<String, Map<String, RecordType>> RECORDTYPESMAP = RFAGlobalConstants.RECORDTYPESMAP;
    public static Map<String, RecordType> approverInfoCopyMap 
    	= RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());
    
    //constructor for the class    
    public RFA_VFC05_RFAClosingController() {          
    }

    // override constructor
    public RFA_VFC05_RFAClosingController(ApexPages.StandardController controller) {
        hasApproved = false;
        atInfoCopy = false;
        this.rfaObj = (RFA__c)controller.getRecord();
        
         /*set<ID> rtID = new set<ID>();
         rtID.add(approverInfoCopyMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id);
         rtID.add(approverInfoCopyMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id);*/
        
        /*
         	Approval Recommendation(ApprovalRecommendation__c) add Japanese Support by Jia Hu on 2013/11/05
         	Need to update when the value changes!!!
        */
        list<RFAUserRole__c> RFA_UUR = [select UserName__r.Name from RFAUserRole__c where RFA__c=: rfaObj.Id 
                                            and (
                                                    (
                                                        recordtypeId =: approverInfoCopyMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id 
                                                        and ApprovalRecommendation__c not in (
                                                        	'Unconditionally Approved / 承認（条件なし）',
                                                        	'Conditionally Approved / 承認（条件付き）',
                                                        	'Rejected / 否認',
                                                        	'Awaiting Approval / 承認待ち'
                                                        	//RFAConstants.ApproverRecommend_UnconditionalApproved,
                                                        	//'Unconditionally Approved',
                                                        	//RFAConstants.ApproverRecommend_ConditionalApproved,
                                                        	//'Conditionally Approved',
                                                        	//RFAConstants.ApproverRecommend_Rejected
                                                        	//'Rejected', 
                                                        	//'No Longer Needed', 
                                                        	//'Ratification', //??? old one ???
                                                        	//'承認（条件なし）',
                                                        	//'承認（条件付き）',
                                                        	//'否認',
                                                        	//'不要',
                                                        	//'承認待ち',
                                                        	//RFAConstants.ApproverRecommend_AwaitingApproval
                                                        	//'Awaiting Approval'
                                                        	)
                                                    )
                                                OR (
                                                        Notifyuserfirsttime__c = false 
                                                        and recordtypeId =: approverInfoCopyMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id
                                                    )
                                                )
                                            ];
        if (RFA_UUR.size() > 0){
        	
            hasApproved= true;
            
            for(RFAUserRole__c UUR : RFA_UUR){
                if(approverIds == null){
                	approverIds = UUR.UserName__r.Name;
                } else {
                	approverIds = approverIds + ', ' + UUR.UserName__r.Name;
                }
            }
        }
    }
    
    /* @Method <This method evaluates is called from the action button of the page and contains logic to update an RFA >
       @param <None>
       @return <pagereference>        
    */
    public pageReference updateRFA()
    {   
    	/*
    	  Approved, Rejected, Closed is hard coded in the VF page! 
    	  The value is same with Stage picklist on RFA.
    	*/
        try{
            // if user has not selected a stage for the error,force an error
            if(selectedStage == null || selectedStage == ' ') 
            	throw new RFAException('選択してください / Please select an Action');
            // set the selected stage
            rfaObj.Stage__c = selectedStage;
            // update the rfa
            update rfaObj;
            
        } catch(Exception ex) {
            // catch exception
            hasError = true;
            return null;
        }
            /*PageReference pref;
            ApexPages.StandardController sc = new ApexPages.StandardController(rfaObj);
            pref = sc.view();
            pref.setRedirect(true); 
            */
            //return null;
             return new pageReference('/apex/RFA_VFP04_CompletionMemo?id=' + rfaObj.Id);
    }
   
   /*
        Class Type     : Inner Class (RFAException) extends Exception
        Date Created   : 5/18/2012
        Description    : Custom Exception class extending the parent exeption class.
        Version        : 1.0 
    */ 
   public class RFAException extends Exception{ }
   
}