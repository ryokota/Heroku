/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VFC04_CompletionMemoController
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 4/6/2012 
 *  Assumptions      : N/A
 *  Description      : Class for sending email to group of people chosen by the user when the RFA is either Approved or Rejected 
 *
 * updated by Jia Hu on 2013/10/29   RECORDTYPE_CO_CREATOR removed
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
//called by VF page: RFA_VFP04_CompletionMemo / class RFA_VFC05_RFAClosingController
//use Email Template: VFT07_Completion_Memo   by Label.RFA_CL048
public class RFA_VFC04_CompletionMemoController {
    
    // instance of RFA__c
    public RFA__c rfaObj {get; set;}
    
    // List of type selectOption for available list of org recipients
    public list<user> toList {get; set;}

    // List of type selectOption for available list of org recipients
    public SelectOption[] selectableRecipients {get; set;}
    
    // List of type SelectOption for list of selected recipients from the visualforce page.
    public SelectOption[] selectedRecipients {get; set;}
    
    // String variable for user inputed CC list of recipients.        
    public String selectedCCusers {get; set;}    

    // boolean variable used as identifier for any failures.
    public boolean hasError {get; private set;}

    public static Map<String, Map<String, RecordType>> RECORDTYPESMAP 
    	= RFAGlobalConstants.RECORDTYPESMAP;
    public static Map<String, RecordType> toLstRecordTypeMap 
    	= RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());
  
    // constructor for the class            
    public RFA_VFC04_CompletionMemoController(ApexPages.StandardController controller) {
        this.rfaObj = (RFA__c)controller.getRecord();
        
        if(rfaObj.Id <> null)
        {
            this.rfaObj = [
            	Select Id, Subject__c, Thefollowingitem__c, ProfitCenterNumber__c,
                       ProfitCenterName__c, 
                       //ControlNumber__c, 
                       //Functional_Currency__c, Functional_Currency__r.Name,
                       Theapprovalstatusofyourrequestis__c, CommentsConditions__c,
                       ApprovalLetterComments__c, 
                       //Business_Unit__c, 
                       RequestTitle__c,   
                       //LocalReferenceNumber__c, 
                       RequestAmountFunctionalCurrency__c, 
                       //RequestAmountUSD__c,
                       toEmailAddressCM__c,ccEmailAddressCM__c, CreatedById    
                       FROM RFA__c 
                       WHERE Id =: rfaObj.Id];
        
         /*         
         Requirement #FR1.89
         Description #On Completion Memo, To have default value as "Not Applicable" in the ApprovalLetterComments__c picklist.
         History     #Added by ASHWANI KAUSHIK on 03-May-2013
         */
         //RFA_FR1_89: Not Applicable 
         //ApprovalLetterComments__c: Follow-up: Approver Comments/Conditions
         if(rfaObj.ApprovalLetterComments__c == NULL) 
         {
         	rfaObj.ApprovalLetterComments__c = Label.RFA_FR1_89;
         }                
         
         /*
         Requirement #FR1.26
         Description #To populate Comments/Condition field with Approver comments and recommendations if the approval is (Conditionally Approved OR Rejected).
         History     #Added by ASHWANI KAUSHIK on 03-May-2013
         */
         /*
         	RFA_CL058: Conditionally Approved
         	RFA_CL059: Rejected
         */
         list<RFAUserRole__c> rfaUserList = [
         	Select Id, UserName__r.name, ApprovalRecommendation__c, ApprovalComments__c 
         		FROM RFAUserRole__c 
                                   where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id ) 
                                   
                                   //updated by Jia Hu on 2013/11/05  all comments are displayed now!
                                   //and (ApprovalRecommendation__c=:Label.RFA_CL058 
                                   //	OR ApprovalRecommendation__c=:Label.RFA_CL059) 
                                   and RFA__c =: rfaObj.Id
                  ];
                                   
         if(rfaObj.CommentsConditions__c == NULL && rfaUserList.size() > 0)
            {
            String defaultComments = '';
            Integer TextLimit = Schema.SObjectType.RFA__c.fields.CommentsConditions__c.getLength();
            
            
                for(RFAUserRole__c ur : rfaUserList)
                {
                  defaultComments+=ur.UserName__r.name+' - '+ur.ApprovalRecommendation__c+' - '+ur.ApprovalComments__c+'\n\n';
               
                }
                
                system.debug('Value of the comments field ' + defaultComments.length());
              
              if(defaultComments.length() > TextLimit )
                {
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Comments/Conditions has been truncated as the text size exceeded the maximum allowed character limit i.e. '+TextLimit+' Characters');
                   ApexPages.addmessage(myMsg);
                   rfaObj.CommentsConditions__c=defaultComments.substring(0,TextLimit);
                }
                else
                {
                    rfaObj.CommentsConditions__c=defaultComments;
                } 
            }                           
                                   
        //End               
                       
                       
        }
        
        //RFA_VFP04_CompletionMemo.page
        /*
        <c:RFA_C06_MultiselectPicklist leftLabel="Available Recipients" 
                    	leftOptions="{!selectableRecipients}" 
                    	rightLabel="Selected Recipients" 
                    	rightOptions="{!selectedRecipients}" 
                    	size="25" width="200px"/>        
        */
        
        //updated by Jia Hu on 2013/10/29
        //right side selection / CC: Selected Recipients
        //selectedRecipients = new List<SelectOption>();   
             
        //left side selection / CC: Available Recipients
        //selectableRecipients = getSelectableUsers();
        
        selectedRecipients = getSelectableUsers();
        selectableRecipients = new List<SelectOption>();
        

        toList = new list<user>();
        toList = gettoList();
        
    }
    
     /* @Method <This method sends completion memo to selected list of recipients in TO and CC list>
        @param <None> 
        @return <pagereference>
     */
    public pageReference sendEmail()
    {   
        //reset the error variable
        hasError = false;   
        Database.Saveresult[] result;   
        
        Savepoint sp = Database.setSavepoint();
        
        List<String> toAddresses = new List<String>();
        
        List<String> ccdUsers = new List<String>();
        String toEmailAddressCM, ccEmailAddressCM;
        
        try{
                        
            System.debug('\n Selected CCd users : ' + selectedCCusers);
            
            System.debug('\n selected recipients : ' + selectedRecipients);
                        
           /*if(selectedCCusers <> null || selectedCCusers <> '')
            {
                if(selectedCCusers.contains(';'))ccdUsers.addAll(selectedCCusers.split(';',0));
                else if(!RFAGlobalConstants.isBlank(selectedCCusers))ccdUsers.add(selectedCCusers);
            }*/
            /*if(selectedRecipients.isEmpty()) throw new CompletionMemoException('Please select recipients in To Addresses');*/
            
            /*for(SelectOption option : selectedRecipients)
            {
                toAddresses.add(option.getValue()); 
            }*/
            for(User toUser : toList){
                toAddresses.add(toUser.Email); 
                if(toEmailAddressCM != null)
                {
                	toEmailAddressCM = toEmailAddressCM + ',' + toUser.Name;
                } else {
                	toEmailAddressCM = toUser.Name;
                }
                
            }
            for(SelectOption option : selectedRecipients)
            {
                ccdUsers.add(option.getValue()); 
                if(ccEmailAddressCM != null){ccEmailAddressCM = ccEmailAddressCM +',' + option.getLabel();}
                else{ccEmailAddressCM = option.getLabel();}
            }            
            
            //Thefollowingitem__c: This request was circulated to
            if(rfaObj.Thefollowingitem__c == null 
            	|| rfaObj.Thefollowingitem__c == '') 
            	throw new CompletionMemoException(
            		'回覧先を選択してください / Please Select a value for This Request was Circulated To:');
            
            //Theapprovalstatusofyourrequestis__c: This request has been
            if(rfaObj.Theapprovalstatusofyourrequestis__c == null 
            	|| rfaObj.Theapprovalstatusofyourrequestis__c == '') 
            	throw new CompletionMemoException(
            		'申請の最終結果を選択してください / Please select Final Approval Status for the Request');
            
            // - added && condition in following line by Ashwani on 22 Apr 2013 for FR1.88
            //CommentsConditions__c: Comments/Conditions
            //RFA_CL057: Unconditionally Approved
            if((rfaObj.CommentsConditions__c == null 
            	|| rfaObj.CommentsConditions__c == '') 
            	&& (rfaObj.Theapprovalstatusofyourrequestis__c != RFAConstants.ApproverRecommend_UnconditionalApproved
            		//Label.RFA_CL057
            	)) 
            	throw new CompletionMemoException(
            		'コメントまたは条件を追加してください / Please Add Comments/Conditions');
            
            //ApprovalLetterComments__c: Follow-up: Approver Comments/Conditions
            if(rfaObj.ApprovalLetterComments__c == null 
            	|| rfaObj.ApprovalLetterComments__c == '') 
            	throw new CompletionMemoException(
            		'選択してください：承認者のコメントまたは条件 / Please select Followup: Approver Comments/Conditions');
            
           
            /****/
            rfaObj.toEmailAddressCM__c = null; //assigning null value before updating.
            rfaObj.ccEmailAddressCM__c = null; //assigning null value before updating.
                if(toEmailAddressCM != null) rfaObj.toEmailAddressCM__c = toEmailAddressCM;
                if(ccEmailAddressCM != null)rfaObj.ccEmailAddressCM__c = ccEmailAddressCM;
            
            /****/
                

            result = Database.update(new List<RFA__c>{rfaObj});
            
            if(result[0].isSuccess())
            {
                sendCompletionMemoEmail(toAddresses, ccdUsers, UserInfo.getUserId(), rfaObj.Id); 
                
                //stopped by Jia Hu on 2013/11/22
                //waiting for Japanese Version
                //generate PFD attachment here           
                //RFA_WS04_PDFGeneratorCM.PDFGenerator(rfaObj.Id,UserInfo.getSessionId());
            }
      
            
      }
        catch(Exception ex)
        {
            Database.rollback(sp);
            hasError = true;
            ApexPages.addMessage(
            	new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            
            return null;
        }
        
        //ApexPages.StandardController sc = new ApexPages.StandardController(rfaObj);
        
        //return sc.view();
        return null;
    }
    
    
    /* @Method <This method sends completion memo to selected list of recipients in TO and CC list>
        @param <List<String>, List<String>, String, String> 
        @return <pagereference>
     */
    public void sendCompletionMemoEmail(
    	List<String> toAddresses, 
    	List<String> ccAddresses, 
    	String targetObjectId, 
    	String whatId)
    {
        System.debug('\n To recipient address : ' + toAddresses);
        System.debug('\n To CCD address : ' + ccAddresses);
           
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
        mail.setToAddresses(toAddresses);
        //RFA_CL048: 00X10000000e7AU -> VFT07 Completion Memo (Visualforce Email Template)
        mail.setTemplateId(Label.RFA_CL048);
        if(ccAddresses.size() > 0)mail.setCcAddresses(ccAddresses);
        mail.setWhatId(whatId);
        mail.setTargetObjectId(targetObjectId);
        mail.saveAsActivity = false;
        //RFA_CL131:   ---> Org Wide Email Address
        mail.orgWideEmailAddressId=Label.RFA_CL131; //-added by RSAS 11-Oct-2012 for INC0075225
        
        mails.add(mail);
        Messaging.sendEmail(mails);      
       
    }
      
    public List<SelectOption> getSelectableUsers()
    {
        List<SelectOption> options = new List<SelectOption>();
        Set<String> associatedUsersIds = new Set<String>();
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.User;
        String userKeyPrefix = d.getKeyPrefix();  
                                     
        for(RFA__Share rfaShare : [
        	Select ParentId, RowCause, UserOrGroupId 
        	FROM RFA__Share WHERE ParentId = : rfaObj.Id LIMIT 1000])
        {
            String userAssociated = rfaShare.UserOrGroupId;
            if(userAssociated.substring(0,3) == userKeyPrefix)
                associatedUsersIds.add(rfaShare.UserOrGroupId); 
        }
        
        //hard code to revise?       
        for(User user : [
        	Select Id, Name, FirstName, LastName, Email 
        	From User where isActive = true AND Id IN: associatedUsersIds 
        	ORDER BY FirstName LIMIT 1000
        ])
        {
            //if(user.Id <> userInfo.getUserId())
            //{
            if(user.Name <> RFAConstants.RFA_System_User
            	//'RFA System'
            	)
                options.add(new SelectOption(user.Email, user.Name));
           // }
        }
        
        return options;                                                 
    }

/*
Function for ToList user's
*/

    public List<user> gettoList()
    {
        List<User> toListVal = new List<User>();
        Set<String> associatedUsersIds = new Set<String>();
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.User;
        String userKeyPrefix = d.getKeyPrefix();  
                                     
        /*for(RFA__Share rfaShare : [Select ParentId, RowCause, UserOrGroupId FROM RFA__Share WHERE ParentId = : rfaObj.Id LIMIT 1000])
        {
            String userAssociated = rfaShare.UserOrGroupId;
            if(userAssociated.substring(0,3) == userKeyPrefix)
                associatedUsersIds.add(rfaShare.UserOrGroupId); 
        }*/
        set<String> AppRec = new set<String>();
        AppRec.add(
        	RFAConstants.ApproverRecommend_UnconditionalApproved
        	//'Unconditionally Approved'
        	);
        AppRec.add(
        	RFAConstants.ApproverRecommend_ConditionalApproved
        	//'Conditionally Approved'
        );
        
        //removed by Jia Hu on 2013/11/05
        //set<string> AppLevel = new set<string>();
        //AppLevel.add('4. Corporate');
        //AppLevel.add('5. Executive');
        //AppLevel.add('6. Senior Executive');
        
        associatedUsersIds.add(rfaObj.CreatedById);
        associatedUsersIds.add(UserInfo.getUserId());
        
        
        /*****************************************************************************/
           list<RFAUserRole__c> rfaUserList = [
           		Select Id FROM RFAUserRole__c 
                                   where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id ) 
                                   and RFA__c =: rfaObj.Id
                                   and ApprovalRecommendation__c in : AppRec
                                   //and Level__c in: AppLevel
                             ];
                if(rfaUserList.size()>0 && rfaObj.ProfitCenterName__c!=null)
                {
                    for(ProfitCenterUserRole__c PCUR: [
                    	select ProfitCenter__c, UserName__c, UserName__r.Name from ProfitCenterUserRole__c 
                                                       where  ProfitCenter__c =: rfaObj.ProfitCenterNumber__c 
                                                       and  UserType__c ='Coordinator' //Location Coordinator
                                                       //and Level__c='3. Group'
                                                       ])
                    {   
                        if(PCUR.UserName__c != null)
                        {
                           associatedUsersIds.add(PCUR.UserName__c);
                        }
                    }
                } 
        /*****************************************************************************/
         set<ID> rtID = new set<ID>();
         rtID.add(toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id);
         //rtID.add(toLstRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id);
         for(RFAUserRole__c rfaUser : 
         	[Select UserName__c FROM RFAUserRole__c where (RecordTypeId in: rtID ) and RFA__c =: rfaObj.Id]
         )
        {
            String userAssociated = rfaUser.UserName__c;
            if(userAssociated.substring(0,3) == userKeyPrefix)
                associatedUsersIds.add(rfaUser.UserName__c); 
        }

		//hard code to revise?
        for(User user : [
        	Select Id, Name, FirstName, LastName, Email 
        	From User where isActive = true AND Id IN: associatedUsersIds 
        	ORDER BY FirstName LIMIT 1000
        ])
        {
            //if(user.Id <> userInfo.getUserId())
            //{
            if(user.Name <> RFAConstants.RFA_System_User
            	//'RFA System'
            	)
                toListVal.add(user);
           // }
        }
        return toListVal;                                                 
    }



    public String notNull(String check)
    {
        String returnString = ' ';
        if(check <> null) returnString = check;
        return returnString ;
    }
    
    public Class CompletionMemoException extends Exception{}
    
    //added by Jia Hu on 2013/11/08
    public String getLocalDT() {
    	return System.now().format();
    }
   
 }