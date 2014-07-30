/*
    Author              : Accenture
    Date Created        : 6/11/2012
    Description         : This class will be called from the visualforce page <RFA_VFP03_ApprovalRouting>. 
    					  This class contains logic to order approvers
                          and submit them for the approval process  
    Version             : 2.0 
    
    updated by Jia Hu on 2013/10/28
    VP page: RFA_VFP03_ApprovalRouting   changing Profit Center to Cost Center
    CoCreator Removed
    
    updated by Jia Hu on 2013/11/06  remove Level
    level removed by Jia Hu on 2013/12/01
*/ 
//Controller of VP page: RFA_VFP03_ApprovalRouting
//need Class: RFA_AP03_ApprovalProcessHelper
public class RFA_VFC02_ApprovalRoutingController{  
    // variable for holding the approval process detail in context
    public ApprovalProcess__c processInstance {get; set;}
    // variable for holding the RFA Object related to the Approval process.
    public RFA__c rfaObj {get; private set;}
    
    // List variable for holding the list of ApprovalSequence
    public List<AppproverSequence> sequenceList {get; set;}
    
    // static variable for holding the default approval status
    //private static final String DEFAULT_STATUS_APPROVAL = 'Not Started';    
    //private static final String INPROGRESS_STATUS_APPROVAL = 'In Progress';
    
    // boolean variable to designate active approval process
    public boolean activeAppProcess {get; private set;}
    // boolean variable to flag errors./Being used for stoping JS parent script call in case of rollback.
    public boolean hasError {get; private set;}
    // list variable for storing all the notification users which are required to be flagged for email communoication
    private List<RFAUserRole__c> notificationUsers = new List<RFAUserRole__c>();
    // list of Info Only Copy User.
    private List<RFAUserRole__c> levelInfoCopyUsers = new List<RFAUserRole__c>();
    // Set containing level value for current and below.
    private rfa_AP02_Shareutil shareUtil = new rfa_AP02_Shareutil();
    
    // constructor for the class.    
    public RFA_VFC02_ApprovalRoutingController(ApexPages.StandardController controller) 
    {    	
    	//2013/11/13 by Jia Hu
    	//need to automatically translate into Japanese
    	//with Label toLabel(RecordType.Name) in SOQL ???
        // get RFA Obj     
        rfaObj = (RFA__c)controller.getRecord(); 
        
        // get the process instance for the level if it has already been submitted for recommendations.
        ApprovalProcess__c[] processes = RFA_AP03_ApprovalProcessHelper.getProcessInstance(rfaObj);
        
        // if processInstance is not available for the current RFA level, create a new instance
        if(processes.isEmpty())
        {            
            processInstance = new ApprovalProcess__c();            
            //removed by Jia Hu on 2013/11/01
            //processInstance.ApprovalProcessLevel__c = rfaObj.Level__c;           
            processInstance.Status__c = RFAConstants.ApprovalProcess_Not_Started;
            	//DEFAULT_STATUS_APPROVAL; //'Not Started'    
            activeAppProcess = false;                    
        } else {
            // create a new instance of approval process.
            processInstance = processes[0];
            activeAppProcess = (processes[0].Status__c == 
            	//INPROGRESS_STATUS_APPROVAL
            	RFAConstants.ApprovalProcess_In_Progress
            	)? true : false; //'In Progress'           
        }
        
        sequenceList = new List<AppproverSequence>(); 
        
        //removed by Jia Hu on 2013/12/01
        //Set<String> levelSet = new Set<String>();
        //levelSet = getLevelSet(levelSet);
        
        // get Info Only Copy users from the user role table related to the rfa
        getInfoOnlyUsers();
        
        //rmoved by Jia Hu on 2013/10/29
        // get co- creator users from the user role table related to the rfa
        //getCoCreatorUsers();
        
        // Get primary POC users from the user role table related to the rfa
        getPrimaryPOCUsers();
        
        // get existing approvers from the user role table related to the rfa
        sequenceApprover( //levelSet  //level removed by Jia Hu on 2013/12/01
        );                
    }//end of RFA_VFC02_ApprovalRoutingController();
    
    /* removed by Jia Hu on 2013/12/01
    public Set<String> getLevelSet(Set<String> levelSet)
    {   
        //Integer currentLevel = RFAGlobalConstants.LEVEL_ORDER_MAP.get(rfaObj.Level__c);
        Integer currentLevel = RFAGlobalConstants.LEVEL_ORDER_MAP.get(rfaObj.Stage__c);
        for(Integer levelNumber = 1; levelNumber <= currentLevel; levelNumber ++)
        {
            levelSet.add(RFAGlobalConstants.ORDERED_LEVEL_MAP.get(levelNumber));    
        }
        return levelSet;
    }*/
    
    
    /* @Method <This method queries the RFAUserRole table for info only users and adds them to the list infoCopyUsers >
       @param <None>
       @return <List> - List of RFAUserRoles       
    */
    public void getInfoOnlyUsers()
    {	//List<RFAUserRole__c> notificationUsers
        notificationUsers.clear();
        notificationUsers.addAll(RFA_AP03_ApprovalProcessHelper.getInfoCopyUsers(rfaObj));
        //List<RFAUserRole__c> levelInfoCopyUsers
        levelInfoCopyUsers.addAll(notificationUsers);    
    }
    
    /* @Method <This method queries the RFAUserRole table for co-creator users and adds them to the list infoCopyUsers >
       @param <None>
       @return <List> - List of RFAUserRoles       
    */
    /*
    public void getCoCreatorUsers()
    {
        notificationUsers.addAll(RFA_AP03_ApprovalProcessHelper.getCoCreator(rfaObj));
    }
    */
    
    /* @Method <This method queries the RFAUserRole table for primary POC users and adds them to the list infoCopyUsers >
       @param <None>
       @return <List> - List of RFAUserRoles       
    */
    public void getPrimaryPOCUsers()
    {	//notificationUsers = Info Copy + PPOC
        notificationUsers.addAll(RFA_AP03_ApprovalProcessHelper.getPrimaryPointOfContact(rfaObj));
    }
        
    /* @Method <This method queries the RFAUserRole table and gets the associated approvers for that RFA Level >
       @param <None>
       @return <List> - List of RFAUserRoles       
    */
    public void sequenceApprover(
    	//Set<String> levelSet
    )
    {
        sequenceList.clear();      
			            
        for(RFAUserRole__c app : getApprovers(
        	//levelSet
        	)
        )
        {
        	if(app.Approver_Source__c == 'Manager' || app.Approver_Source__c == 'Capital Mgmt.') {
              sequenceList.add(
              	new AppproverSequence(
              		app.ApprovalOrder__c, 
              		app, 
              		//app.Level__c
              		false
              	) );
        	} else {
              sequenceList.add(
              	new AppproverSequence(
              		app.ApprovalOrder__c, 
              		app, 
              		//app.Level__c
              		true
              	) );    		
        	} 	
              	                           
        } //end of for();         
    }
    
    /*
        Class Type     : Inner Class (AppproverSequence)
        Date Created   : 6/11/2012
        Description    : This is our wrapper/container Inner class to display the Approvers (RFAUserRole__c) with approval order.
        Version        : 1.0 
    */   
    public class AppproverSequence
    {
        public Integer sequence {get; set;}
        public RFAUserRole__c approver {get; set;}
        public Boolean reorder {get; set;}
        
        //removed by Jia Hu on 2013/11/06
        //public String level{get;set;}
        
        // constructor for the inner class.
        public AppproverSequence(
        	Decimal order, 
        	RFAUserRole__c approver, 
        	//String level
        	Boolean reorder
        	)
        {		
            this.sequence = Integer.valueOf(order);
            this.approver = approver;
		    //this.level = level;
		    this.reorder = reorder;
        }
    }
    
    /* @Method <This method queries the RFAUserRole table and gets the associated approvers for that RFA Level >
       @param <None>
       @return <List> - List of RFAUserRoles       
    */   
    public List<RFAUserRole__c> getApprovers(
    	//Set<String> levelSet
    	)    
    {
        //return [Select UserName__r.Name, Level__c, ApprovalOrder__c 
        //FROM RFAUserRole__c Where Level__c =: processInstance.ApprovalProcessLevel__c AND RecordType.Name = :'Approver' AND RFA__c = :  rfaObj.Id ORDER BY CreatedDate];
        return RFA_AP03_ApprovalProcessHelper.getApprovers(
        	rfaObj //, 
        	//levelSet
        	);
    }
    
    // variable for storing the approver list size.
    public Integer approverSize{
        get{
             return sequenceList.size();
        }
        private set;
    }
    
    /* @Method <This method submits the approval process for approval >
       @param <None>
       @return <PageReference>
    */
    //Submit for Approval button on Page: RFA_VFP03_ApprovalRouting
    public void submitForApproval()
    {
        this.hasError = false;
        System.debug('\n ------- user inouted sequence list : ' + sequenceList);
        //validateApprovalSequence(List<AppproverSequence> approverSequence)
        validateApprovalSequence(sequenceList);
        System.Savepoint sp = Database.setSavepoint(); 
        
       // RFA_AP03_ApprovalProcessHelper.ProcessResult result;      
        
        List<RFAUserRole__c> approverForUpdateList = new List<RFAUserRole__c>();  
        List<ApprovalProcess__c> processList = new List<ApprovalProcess__c>();
        Database.UpsertResult result;
        //reset error variable
        
        system.debug('------- processInstance.Status__c + ' + processInstance.Status__c + '   processInstance: ' + processInstance);
        
        Integer initialOrder = 1;
        try{
            if(!ApexPages.hasMessages())
            {
                if(processInstance.Status__c == RFAConstants.ApprovalProcess_In_Progress
                	//INPROGRESS_STATUS_APPROVAL
                	) {//'In Progress'
                	throw new ApprovalRoutingException(RFAGlobalConstants.EXCEPTION_PROCESSHASBEEN_SUBMITTED);
                	//RFA_CL071: Process has already been submitted for Approval
                }
                
                if(!sequenceList.isEmpty())
                {
                	system.debug('------ in the new aproval process');
                    result = RFA_AP03_ApprovalProcessHelper.submitForApproval(processInstance, rfaObj); 
                }
                else if(sequenceList.isEmpty() && !levelInfoCopyUsers.isEmpty())
                {
                    System.debug('\n ----- inside post circulation block');
                    result = RFA_AP03_ApprovalProcessHelper.submitForApproval(processInstance, rfaObj, true);
                } 
                System.debug('\n ------ result object returned :' + result); 
                //if(!result[0].isSuccess()) throw new ApprovalRoutingException('Exception occured while saving the record.');
                
                if(result.isSuccess())
                {	//link each approver to the Approval Process and set up the order
                    //updateRFAStage();
                    Id processId = result.getId();
                    //List<RFAUserRole__c> approverList = getApprovers();
                    System.debug('\n ----- Sequence list' + sequenceList);
                    integer count1 = 1;
                    for(AppproverSequence appSequence : sequenceList)
                    {                           
                        RFAUserRole__c approver = appSequence.approver;
                        approver.ApprovalOrder__c = appSequence.sequence;
                        approver.ApprovalProcess__c = processId;
                        approver.ApprovalRecommendation__c  //Approval Recommendation picklist (Unconditionally Approved, ...)
                        	//= (Integer.valueOf(approver.ApprovalOrder__c) == initialOrder ? 'Awaiting Approval' : ' ');
                        	= (Integer.valueOf(approver.ApprovalOrder__c) == initialOrder ? RFAConstants.ApproverRecommend_AwaitingApproval : ' ');
                        approver.ApprovalRequestedOn__c  
                        	= (Integer.valueOf(approver.ApprovalOrder__c) == initialOrder ? System.now() : null);
                        approverForUpdateList.add(approver);    
                        system.debug('-------- approver ' + count1 + ' added: ' + approver);       
                        count1++;         
                    }
                                        
                    if(!notificationUsers.isEmpty()) {
                    	RFA_AP03_ApprovalProcessHelper.notifyInfoCopyUsers(notificationUsers, true, processId);
                    }
                } else
                {                        
                    throw new ApprovalRoutingException(result.getErrors()); 
                }
                              
               // if(!approverForUpdateList.isEmpty()) RFA_Util_PerformDML.performUpdOperation(approverForUpdateList);
                  System.debug('\n ----- approver list ' + approverForUpdateList);  
                  
                  if(!approverForUpdateList.isEmpty()) {update approverForUpdateList;}              
            }
        } catch(ApprovalRoutingException routingEx)
        {
            System.debug('\n ----- Exception caught in routing Exception : ' + routingEx.getErrorMessages());    
            Database.rollback(sp); 
            for(String errString : routingEx.getErrorMessages())
            {
                if(!errString.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errString));   
            }
            hasError = true;
        } catch(Exception ex)
        { 
           System.debug('\n Exception caught :'+ex.getMessage());        
           Database.rollback(sp); 
           if(!ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))               
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
                       
           hasError = true;            
        }         
        
        system.debug('------- End of submitApproval():  processInstance.Status__c + ' + processInstance.Status__c + '   processInstance: ' + processInstance);
                
    }
      
    /* @Method <This method validates all the approvers for proper data and sequence>
       @param <List> - List of ApproverSequence
       @return <None>
    */  
    //EXCEPTION_NO_APPROVERS_REVIEWERS = Label.RFA_CL063 =
    //承認者または校閲者から提出してください / There should be either Approvers OR Reviewers to push the RFA into Circulation
    public void validateApprovalSequence(List<AppproverSequence> approverSequence)
    {
        try{            
            System.debug('\n Approver sequence size : ' + approverSequence.size() + ' approverSequence: ' + approverSequence);
            System.debug('\n info copy users : ' + levelInfoCopyUsers.size() + ' levelInfoCopyUsers: ' + levelInfoCopyUsers);
            Map<Integer, AppproverSequence> orderApproverMap = new Map<Integer, AppproverSequence>();
            
            //updated by Jia Hu on 2013/12/15
            if(approverSequence.isEmpty() 
            	//&& levelInfoCopyUsers.isEmpty()
              ) { 
            	throw new ApprovalRoutingException(
            		Label.RFA_ErrorMsg_AssignPPOC_Approver
            		//RFAGlobalConstants.EXCEPTION_NO_APPROVERS_REVIEWERS
            		);
            	//RFA_CL063: There should be either Approvers OR Reviewers to push the RFA into Circulation
            }
            
            if(!approverSequence.isEmpty())
            {
                for(AppproverSequence appSequence : approverSequence)
                {
                    System.debug('\n Approver sequence : ' + appSequence.sequence);
                     orderApproverMap.put(appSequence.sequence, appSequence);                         
                }
              
                Integer order = 1;
                    	
                for(Integer oSequence : orderApproverMap.keySet())
                {		
                	if(oSequence != order) {throw new ApprovalRoutingException(RFAGlobalConstants.EXCEPTION_LIST_ORDER);}
                    order = order + 1;
                }   
            }                             
        } catch(Exception ex)
        {
               if(!ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {              
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); 
               }
                    
               //pageMessages = ApexPages.getMessages();        
               hasError = true;
        }                 
    }
      
    public class ApprovalRoutingException extends Exception{    
        List<String> exMessages = new List<String>();      
          
        public ApprovalRoutingException(List<Database.Error> errorList)
        {
            for(Database.Error err : errorList)
            {
                exMessages.add(err.getMessage());   
            }
        }  
        
        public List<String> getErrorMessages()
        {
            return exMessages;
        }           
    }
      
}