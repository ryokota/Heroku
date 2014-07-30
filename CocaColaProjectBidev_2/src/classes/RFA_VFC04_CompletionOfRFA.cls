/**   
 *  Author           : Pasona Tquila
 *  Version History  : 1.0
 *  Creation         : 2013/12/03
 *  Description      : Completion phase of RFA, including post-processing, like Email,...
 **/
public without sharing class RFA_VFC04_CompletionOfRFA {   
	
	public static boolean emailAtWaitingForApproval = true;
	
	public static Set<Id> emailApproverAtWaitingForApproval = new Set<Id>();

    public static Map<String, Map<String, RecordType>> RECORDTYPESMAP 
    	= RFAGlobalConstants.RECORDTYPESMAP;
    public static Map<String, RecordType> toLstRecordTypeMap 
    	= RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());

	Id idOrgWideEmailAddress;

	public RFA_VFC04_CompletionOfRFA() {
		idOrgWideEmailAddress = RFAConstants.getOrgWideEmailAddressId();
	}

	//RFA Status: Approved + Board / Rejected
	// g. To Requester, Primary Point of Contact(s), Approver(s), Agent(s) via Completion Memo
	// Template: RFAVFT07 Completion Memo                 /00X10000000eAx3?setupid=CommunicationTemplatesEmail
	//           RFAVFT07 Completion Memo to RelatedUsers /00X10000000eC4j?setupid=CommunicationTemplatesEmail
	// h. To Requester, Primary Point of Contact(s) when RFA enters Approved/Requires Board Approval
	// Template: RFAVFT08 Board Review - RelatedUser      /00X10000000eAx8?setupid=CommunicationTemplatesEmail	
	//           RFAVFT08 Board Review - Requester        /00X10000000eC4o?setupid=CommunicationTemplatesEmail
	//Ref: RFA_VFC04_CompletionMemoController    VF page: RFA VFP04 CM DetailsAsPDF
    public void sendEmail_CompleteMemo(RFA__c rfa)
    {   
    	String strComment = ''; //= getComment(rfa.Id);
    	String strComment_pdf = '\n\n';
    	
    	String strEmailSubject = '最終承認ステータス (Final Approval Status) - ' + rfa.Name + ': ' + rfa.RequestTitle__c;
    	
    	User requester; // = [Select Id, Name, IsActive from User where Id =: rfa.CreatedById];
    	User ppoc;
    	
    	Set<Id> ppocIds = new Set<Id>();
    	String ppocNameList = '';
    	
    	Set<Id> infoonlyIds = new Set<Id>();
    	String infoonlyNameList = '';
    	
    	Set<Id> approverIds = new Set<Id>();
    	String approverNameList = '';        	
    	    	
        Boolean requesterIsPPOC = false;
        
		for(RFAUserRole__c rfaUserRole : [
			Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email FROM RFAUserRole__c 
            where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id ) 
            and RFA__c =: rfa.Id
            and UserName__r.IsActive = true
            order by CreatedDate Desc
        ]) {
        	if(ppoc == null) {
        		ppoc = new User(Id = rfaUserRole.UserName__c, Email = rfaUserRole.UserName__r.Email, 
        			LastName = rfaUserRole.UserName__r.LastName, FirstName = rfaUserRole.UserName__r.FirstName);
        	}
        	ppocIds.add(rfaUserRole.UserName__c);
  
        	if(rfaUserRole.UserName__c == rfa.CreatedById) {
        		requesterIsPPOC = true;
        	}              
        	
        	if(RFAConstants.isBlank(ppocNameList)) {
        		ppocNameList = rfaUserRole.UserName__r.Name;
        	} else {
        		ppocNameList = ppocNameList + ', ' + rfaUserRole.UserName__r.Name;
        	}        	
        	   	
        }             
        
        if(!requesterIsPPOC) {
        	requester = [Select Id, Name, Lastname, Firstname, Email, IsActive from User where Id =: rfa.CreatedById];

        	if(RFAConstants.isBlank(ppocNameList)) {
        		ppocNameList = requester.Name;
        	} else {
        		ppocNameList = requester.Name + ', ' + ppocNameList;
        	}            	
        }
        
        //Info Only Copy
		for(RFAUserRole__c rfaUserRole : [
			Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email FROM RFAUserRole__c 
            where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id ) 
            and RFA__c =: rfa.Id
            and UserName__r.IsActive = true
            order by CreatedDate Desc
        ]) {
        	infoonlyIds.add(rfaUserRole.UserName__c);
         	if(RFAConstants.isBlank(infoonlyNameList)) {
         		infoonlyNameList = rfaUserRole.UserName__r.name;
         	} else {
         		infoonlyNameList = infoonlyNameList + ', ' + rfaUserRole.UserName__r.name;
         	}        	
        }      
		//Approver       
        for(RFAUserRole__c rfaUserRole : [
         	Select Id, UserName__c, UserName__r.name, ApprovalRecommendation__c, ApprovalComments__c, 
         		Approval_Count__c, ApprovalOrder__c 
         		FROM RFAUserRole__c 
                   where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id ) 
                   and RFA__c =: rfa.Id
                   and Approval_Count__c > 0
                   order by ApprovalOrder__c ASC
         ]) {
         	approverIds.add(rfaUserRole.UserName__c);
         	
         	if(RFAConstants.isBlank(approverNameList)) {
         		approverNameList = rfaUserRole.UserName__r.name;
         	} else {
         		approverNameList = approverNameList + ', ' + rfaUserRole.UserName__r.name;
         	}
         	
            if(RFAConstants.isBlank( rfaUserRole.ApprovalComments__c )) { //\n\n don't work  <br/><br/>
            	 strComment += rfaUserRole.UserName__r.name + ' - ' + rfaUserRole.ApprovalRecommendation__c + ' - ' + '<br/><br/>'; 
                 strComment_pdf += rfaUserRole.UserName__r.name + ' - ' + rfaUserRole.ApprovalRecommendation__c + ' - ' + '\n\n';  //dont' display null in Email 
            } else {
            	strComment += rfaUserRole.UserName__r.name + ' - ' + rfaUserRole.ApprovalRecommendation__c + ' - ' + rfaUserRole.ApprovalComments__c  + '<br/><br/>';
            	strComment_pdf += rfaUserRole.UserName__r.name + ' - ' + rfaUserRole.ApprovalRecommendation__c + ' - ' + rfaUserRole.ApprovalComments__c  + '\n\n'; 
            }         
                            
         }                          
        
        String ccNameList = '';
        if(RFAConstants.isBlank(infoonlyNameList)) {
        	ccNameList = approverNameList;
        } else {
        	ccNameList = infoonlyNameList + ', ' + approverNameList;
        }
        
        String strHtmlBody = RFAUtility_Email.getHtmlBody_CompletionMemo(
        	strEmailSubject, ppocNameList, ccNameList, strComment, rfa);    
		
		rfa.ToEmailAddressCM__c = ppocNameList;
		rfa.CCEmailAddressCM__c = ccNameList;
		
		Integer TextLimit = Schema.SObjectType.RFA__c.fields.CommentsConditions__c.getLength();
		if(strComment_pdf.length() > TextLimit ) {
			rfa.CommentsConditions__c = strComment_pdf.substring(0, TextLimit);
		} else {
			rfa.CommentsConditions__c = strComment_pdf;
		}
				
		if(requester != null && !requesterIsPPOC) {
			ppocIds.add(requester.Id);
		}
		
		approverIds.addAll(ppocIds);
		if(infoonlyIds != null && infoonlyIds.size() > 0) {
			approverIds.addAll(infoonlyIds);
		}
        sendSingleEmailMessageEmail(approverIds, strEmailSubject, strHtmlBody);  
        //sendSingleEmailMessageEmail(approverIds, strEmailSubject, strHtmlBody);     
        //sendSingleEmailMessageEmail(reviewerIds, strEmailSubject, strHtmlBody);  
        
        if(rfa.Stage__c == RFAConstants.RFA_STATUS_APPROVED && rfa.BoardSubItem__c == 'Board') {
        	String strBoardEmailSubject = '要取締役会承認 (Approved / Requires BOD Approval): ' + rfa.Name + ': ' + rfa.RequestTitle__c;
        	
        	Set<Id> CorporateAdmins = new Set<Id>();
        	CorporateAdmins.add(Label.RFA_BOD_CC1);	
        	CorporateAdmins.add(Label.RFA_BOD_CC2);	
        	CorporateAdmins.add(Label.RFA_BOD_CC3);	
        	CorporateAdmins.add(Label.RFA_BOD_CC4);	
        	
        	//added by Jia Hu on 2014/01/27
        	List<RFA__Share> rfaShareListInsert = new List<RFA__Share>();
        	if(Label.RFA_BOD_CC1 != null) {
        		RFA__Share newshare = new RFA__Share();
                newshare.ParentId = rfa.Id;
                newshare.AccessLevel = 'Read';
                newshare.RowCause = Schema.RFA__Share.RowCause.Board_Corporate_Management__c;
                newshare.UserOrGroupId = Label.RFA_BOD_CC1;
                
                rfaShareListInsert.add(newshare);
        	}
        	if(Label.RFA_BOD_CC2 != null) {
        		RFA__Share newshare = new RFA__Share();
                newshare.ParentId = rfa.Id;
                newshare.AccessLevel = 'Read';
                newshare.RowCause = Schema.RFA__Share.RowCause.Board_Corporate_Management__c;
                newshare.UserOrGroupId = Label.RFA_BOD_CC2;
                
                rfaShareListInsert.add(newshare);
        	}
        	if(Label.RFA_BOD_CC3 != null) {
        		RFA__Share newshare = new RFA__Share();
                newshare.ParentId = rfa.Id;
                newshare.AccessLevel = 'Read';
                newshare.RowCause = Schema.RFA__Share.RowCause.Board_Corporate_Management__c;
                newshare.UserOrGroupId = Label.RFA_BOD_CC3;
                
                rfaShareListInsert.add(newshare);
        	}
        	if(Label.RFA_BOD_CC4 != null) {
        		RFA__Share newshare = new RFA__Share();
                newshare.ParentId = rfa.Id;
                newshare.AccessLevel = 'Read';
                newshare.RowCause = Schema.RFA__Share.RowCause.Board_Corporate_Management__c;
                newshare.UserOrGroupId = Label.RFA_BOD_CC4;
                
                rfaShareListInsert.add(newshare);
        	}        
        	if(rfaShareListInsert != null && rfaShareListInsert.size() > 0) {
        		insert rfaShareListInsert;
        	}
        	
        	
        		        	        	
        	
        	String cc_Corporate_Administration = '';
        	
        	for(User auser : [Select Id, Name, isActive from User where Id IN: CorporateAdmins and isActive =: true]) {
        		if(RFAConstants.isBlank(cc_Corporate_Administration)) {
        			cc_Corporate_Administration = auser.Name;
        		} else {
        			cc_Corporate_Administration = cc_Corporate_Administration + ', ' + auser.Name;
        		}
        	}
        	
        	String strBoardHtmlBody = RFAUtility_Email.getHtmlBody_BoardApproval(
        		ppoc, ppocNameList, cc_Corporate_Administration, rfa);    
        		
        	ppocIds.addAll(CorporateAdmins);	
        	sendSingleEmailMessageEmail(ppocIds, strBoardEmailSubject, strBoardHtmlBody);  	
        	        	
        }                     

        //generate PFD attachment here           
        //RFA_WS04_PDFGeneratorCM.PDFGenerator(rfa.Id, UserInfo.getSessionId());     		          
    }
    
    //Close RFA from Draft or Return to Requester
    // i. To Requester, Primary Point of Contact(s) via Close Memo in "Draft"
    // XXRFAVFT12 Close Memo in Draft  /00X10000000eBCN?setupid=CommunicationTemplatesEmail
    // RFAVFT10_CloseNotify to Requester  /00X10000000eC11?setupid=CommunicationTemplatesEmail
    // j. To Requester, Primary Point of Contact(s) via Cloase Memo in "Return to Requester"
    // RFAVFT10 Close Notify to RelatedUser /00X10000000eC0w?setupid=CommunicationTemplatesEmail
    //To: Requester, PPOC from Draft    To: Requester, PPOC, Info Copy Only, Approver&Agent from RTR
    public void sendEmail_CloseRFA(RFA__c rfa, Boolean closeFromDraft)
    {      	
    	String strEmailSubject = '申請取り下げ通知 (RFA is Closed) ' + rfa.Name + ': ' + rfa.RequestTitle__c;
    	
    	User requester; // = [Select Id, Name, IsActive from User where Id =: rfa.CreatedById];
    	User ppoc;
    	
    	Set<Id> ppocIds = new Set<Id>();
    	Set<Id> infoonlyIds = new Set<Id>();
    	
    	Set<Id> approverIds = new Set<Id>();
    	
        Boolean requesterIsPPOC = false;
        
		for(RFAUserRole__c rfaUserRole : [
			Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email FROM RFAUserRole__c 
            where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id ) 
            and RFA__c =: rfa.Id
            and UserName__r.IsActive = true
            order by CreatedDate Desc
        ]) {
        	if(ppoc == null) {
        		ppoc = new User(Id = rfaUserRole.UserName__c, Email = rfaUserRole.UserName__r.Email, 
        			LastName = rfaUserRole.UserName__r.LastName, FirstName = rfaUserRole.UserName__r.FirstName);
        	}
        	ppocIds.add(rfaUserRole.UserName__c);
  
        	if(rfaUserRole.UserName__c == rfa.CreatedById) {
        		requesterIsPPOC = true;
        	}                            	
        	   	
        }             
        
        if(!requesterIsPPOC) {
        	requester = [Select Id, Name, Lastname, Firstname, Email, IsActive from User where Id =: rfa.CreatedById];          	
        } 
        
        if(!closeFromDraft) {
        	for(RFAUserRole__c rfaUserRole : [
			Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email FROM RFAUserRole__c 
            where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id ) 
            and RFA__c =: rfa.Id
            and UserName__r.IsActive = true
            order by CreatedDate Desc
        ]) {
        	infoonlyIds.add(rfaUserRole.UserName__c);
        }  
        
        //Approver
        for(RFAUserRole__c rfaUserRole : [
         	Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, ApprovalRecommendation__c, ApprovalComments__c, 
         		Approval_Count__c, ApprovalOrder__c 
         		FROM RFAUserRole__c 
                   where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id ) 
                   and RFA__c =: rfa.Id
                   and Approval_Count__c > 0
                   order by ApprovalOrder__c ASC
         ]) {
         	approverIds.add(rfaUserRole.UserName__c);         	                                
         }            
        }   
        
        String strHtmlBody = RFAUtility_Email.getHtmlBody_CloseRFA(
        	ppoc, strEmailSubject, rfa);    

		if(requester != null && !requesterIsPPOC) {
				ppocIds.add(requester.Id);
			}		
			
		if(closeFromDraft) {
			sendSingleEmailMessageEmail(ppocIds, strEmailSubject, strHtmlBody); 
		} else {
			approverIds.addAll(ppocIds);
			if(infoonlyIds != null && infoonlyIds.size() > 0) {
				approverIds.addAll(infoonlyIds);
			}
			sendSingleEmailMessageEmail(approverIds, strEmailSubject, strHtmlBody); 
		}	                           		          
    }    

	//e. To Requester and Primary Point of Contact(s) when RFA enters "Return to Requester"
	// Template: RFAVFT05_Return to Requester  /00X10000000eBWr?setupid=CommunicationTemplatesEmail
	// To: Requester, PPOC, Info Copy Only, Approver or Agent (Approved or Waiting for Approval) / 承認済み/承認待ち承認者
    public void sendEmail_ReturnToRequester(RFA__c rfa)
    {      	
    	String strEmailSubject = '要確認 (Action Required) : ' + rfa.Name + ': ' + rfa.RequestTitle__c;
    	
    	User requester; // = [Select Id, Name, Email, IsActive from User where Id =: rfa.CreatedById];
    	User ppoc;
  	
    	Set<Id> ppocIds = new Set<Id>();
    	String ppocNameList = '';
    	
    	Set<Id> approverIds = new Set<Id>();
    	String approverNameList = '';
    	
    	Set<Id> infoonlyIds = new Set<Id>();
    	String infoonlyNameList = '';
    	    	
        Boolean requesterIsPPOC = false;
        
		for(RFAUserRole__c rfaUserRole : [
			Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email FROM RFAUserRole__c 
            where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id ) 
            and RFA__c =: rfa.Id
            and UserName__r.IsActive = true
            order by CreatedDate Desc
        ]) {
        	if(ppoc == null) {
        		ppoc = new User(Id = rfaUserRole.UserName__c, Email = rfaUserRole.UserName__r.Email, 
        			LastName = rfaUserRole.UserName__r.LastName, FirstName = rfaUserRole.UserName__r.FirstName);
        		//[Select Id, Name, Username, Email from User where Id =: rfaUserRole.UserName__c];
        	}
        	ppocIds.add(rfaUserRole.UserName__c);
  
        	if(rfaUserRole.UserName__c == rfa.CreatedById) {
        		requesterIsPPOC = true;
        	}       
        	
        	if(RFAConstants.isBlank(ppocNameList)) {
        		ppocNameList = rfaUserRole.UserName__r.Name;
        	} else {
        		ppocNameList = ppocNameList + ', ' + rfaUserRole.UserName__r.Name;
        	}             	
        	          	
        }             
        
        if(!requesterIsPPOC) {
        	requester = [Select Id, Name, Lastname, Firstname, Email, IsActive from User where Id =: rfa.CreatedById];
        	
        	if(RFAConstants.isBlank(ppocNameList)) {
        		ppocNameList = requester.Name;
        	} else {
        		ppocNameList = requester.Name + ', ' + ppocNameList;
        	}           	
        	
        }
        //Info Only Copy
		for(RFAUserRole__c rfaUserRole : [
			Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email FROM RFAUserRole__c 
            where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id ) 
            and RFA__c =: rfa.Id
            and UserName__r.IsActive = true
            order by CreatedDate Desc
        ]) {
        	infoonlyIds.add(rfaUserRole.UserName__c);
        	
         	if(RFAConstants.isBlank(infoonlyNameList)) {
         		infoonlyNameList = rfaUserRole.UserName__r.name;
         	} else {
         		infoonlyNameList = infoonlyNameList + ', ' + rfaUserRole.UserName__r.name;
         	}          	
        	
        }      
        
        //Approver
        RFAUserRole__c approverRTR; //= new RFAUserRole__c();
        for(RFAUserRole__c rfaUserRole : [
         	Select Id, UserName__c, UserName__r.name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email, 
         		ApprovalRecommendation__c, ApprovalComments__c, 
         		Approval_Count__c, ApprovalOrder__c 
         		FROM RFAUserRole__c 
                   where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id ) 
                   and RFA__c =: rfa.Id
                   //and (Approval_Count__c > 0 OR ApprovalRecommendation__c =: RFAConstants.ApproverRecommend_AwaitingApproval )
                   and ApprovalRecommendation__c != null
                   order by ApprovalOrder__c ASC
         ]) {
         	approverIds.add(rfaUserRole.UserName__c);     
         	
         	if(RFAConstants.isBlank(approverNameList)) {
         		approverNameList = rfaUserRole.UserName__r.name;
         	} else {
         		approverNameList = approverNameList + ', ' + rfaUserRole.UserName__r.name;
         	}         	
         	
         	//pick up Approver who have slected Return to Requester    	 
         	if(rfaUserRole.ApprovalRecommendation__c == RFAConstants.ApproverRecommend_ReturnToRequester) {
         		approverRTR = rfaUserRole;
         	}                               
         }      
         
        String ccNameList = '';
        if(RFAConstants.isBlank(infoonlyNameList)) {
        	ccNameList = approverNameList;
        } else {
        	ccNameList = infoonlyNameList + ', ' + approverNameList;
        }                  
        
        String strHtmlBody;
        if(approverRTR != null) {//use Approver who has Return to Requester as the Contact
        	ppoc = new User(Id = approverRTR.UserName__c, Email = approverRTR.UserName__r.Email, 
        			LastName = approverRTR.UserName__r.LastName, FirstName = approverRTR.UserName__r.FirstName);
        	strHtmlBody = RFAUtility_Email.getHtmlBody_ReturnToRequester(
        		ppoc, strEmailSubject, rfa, ppocNameList, ccNameList);    
        } else {
        	strHtmlBody = RFAUtility_Email.getHtmlBody_ReturnToRequester(
        		ppoc, strEmailSubject, rfa, ppocNameList, ccNameList);    
        }

		if(requester != null && !requesterIsPPOC) {
			ppocIds.add(requester.Id);
		}
		if(infoonlyIds != null && infoonlyIds.size() > 0) {
			approverIds.addAll(infoonlyIds); 
		}
		approverIds.addAll(ppocIds);
		
		sendSingleEmailMessageEmail(approverIds, strEmailSubject, strHtmlBody); 		                          		          
    }       
    
    //Resume from Return to Requester:    RFA__c: Return to Requester -> Circulation
    // f. To Approver & Agent(s) when RFA resumes from "Return to Requester" status
    // RFAVFT06 RFA Resumes From Return To Requestor  /00X10000000eAwy?setupid=CommunicationTemplatesEmail
    // Requester, PPOC, Info Copy Only, Approver or Agent (Approved ro Waiting for Approval) ?
    // Approver part in d. Waiting for Approval (enter circulation) and approvers not just the next step of Resume from RTR, but approved once?
    // To: Requester, PPOC, Info Only Copy
    public void sendEmail_ResumeFromRTR(RFA__c rfa)
    { 
    	String strEmailSubject_ReqPPOC  = '再申請 (Return to Sender Update Complete) - ' + rfa.Name + ': ' + rfa.RequestTitle__c;   
    	String strEmailSubject_InfoOnly = '再申請 (Return to Sender Update Complete) - ' + rfa.Name + ': ' + rfa.RequestTitle__c;  	
    	//String strEmailSubject_Approver = '再申請 (Return to Sender Update Complete) - ' + rfa.Name + ': ' + rfa.RequestTitle__c;
    	
    	User requester; // = [Select Id, Name, IsActive from User where Id =: rfa.CreatedById];
    	User ppoc;

    	Set<Id> ppocIds = new Set<Id>();
    	
    	Set<Id> infoonlyIds = new Set<Id>();
    	    	
        Boolean requesterIsPPOC = false;
        
		for(RFAUserRole__c rfaUserRole : [
			Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email FROM RFAUserRole__c 
            where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id ) 
            and RFA__c =: rfa.Id
            and UserName__r.IsActive = true
            order by CreatedDate Desc
        ]) {
        	if(ppoc == null) {
        		ppoc = new User(Id = rfaUserRole.UserName__c, Email = rfaUserRole.UserName__r.Email, 
        			LastName = rfaUserRole.UserName__r.LastName, FirstName = rfaUserRole.UserName__r.FirstName);
        		//[Select Id, Name, Username, Email from User where Id =: rfaUserRole.UserName__c];
        	}
        	ppocIds.add(rfaUserRole.UserName__c);
  
        	if(rfaUserRole.UserName__c == rfa.CreatedById) {
        		requesterIsPPOC = true;
        	}                 	
        }             
        
        if(!requesterIsPPOC) {
        	requester = [Select Id, Name, IsActive from User where Id =: rfa.CreatedById];
        }
        
		for(RFAUserRole__c rfaUserRole : [
			Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email FROM RFAUserRole__c 
            where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id ) 
            and RFA__c =: rfa.Id
            and UserName__r.IsActive = true
            order by CreatedDate Desc
        ]) {
        	infoonlyIds.add(rfaUserRole.UserName__c);
        }      
        
        String strHtmlBody_ReqPPOC = RFAUtility_Email.getHtmlBody_Resume_From_RTR_ReqPPOC(
        	ppoc, strEmailSubject_ReqPPOC, rfa);    
        	                	
        sendSingleEmailMessageEmail(ppocIds, strEmailSubject_ReqPPOC, strHtmlBody_ReqPPOC); 	       	
		
		if(infoonlyIds != null && infoonlyIds.size() > 0) {
			String strHtmlBody_InfoOnly = RFAUtility_Email.getHtmlBody_Resume_From_RTR_InfoOnlyCopy(
        		ppoc, strEmailSubject_InfoOnly, rfa);     
        		
			sendSingleEmailMessageEmail(infoonlyIds, strEmailSubject_InfoOnly, strHtmlBody_InfoOnly); 	
		}				                          		          
    }      
    //Resume from Return to Requester:    RFA__c: Return to Requester -> Circulation
    // f. To Approver & Agent(s) when RFA resumes from "Return to Requester" status
    //To Approver & Agent
    //need to put into RFA User Role trigger??!!
    public void sendEmail_Approver(RFAUserRole__c approver)
    {  	
    	RFA__c rfa = [Select Id, Name, RequestTitle__c, Cost_Center_Number_Name__c, RequestAmountFunctionalCurrency__c 
         	from RFA__c where Id =: approver.RFA__c];	
         	
    	String strEmailSubject_Approver_New = '承認申請 (Request for Approval) : ' + rfa.Name + ': ' + rfa.RequestTitle__c;
    	String strEmailSubject_Approver_Again = '再申請 (Return to Sender Update Complete) - ' + rfa.Name + ': ' + rfa.RequestTitle__c;
    	
    	User ppoc;
    	
    	Set<Id> approverIds_new = new Set<Id>();
    	Set<Id> approverIds_again = new Set<Id>();    	
        
		RFAUserRole__c rfaUserRolePPOC = [
			Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email FROM RFAUserRole__c 
            where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id ) 
            and RFA__c =: approver.RFA__c
            and UserName__r.IsActive = true
            order by CreatedDate Desc
            limit 1
        ];
        
        if(rfaUserRolePPOC != null) {
        	ppoc = new User(Id = rfaUserRolePPOC.UserName__c, Email = rfaUserRolePPOC.UserName__r.Email, 
        			LastName = rfaUserRolePPOC.UserName__r.LastName, FirstName = rfaUserRolePPOC.UserName__r.FirstName);
        	}            	        

         if(approver.Approval_Count__c == 0) {
         	approverIds_new.add(approver.UserName__c);   
         } else {
         	approverIds_again.add(approver.UserName__c); 
         }    
                                                                               
		if(approverIds_new != null && approverIds_new.size() > 0) {
			String strHtmlBody_Approver_new = RFAUtility_Email.getHtmlBody_Enter_Circulation_Approver(
        		ppoc, strEmailSubject_Approver_new, rfa);     
        	                	
        	sendSingleEmailMessageEmail(approverIds_new, strEmailSubject_Approver_new, strHtmlBody_Approver_new); 				
		}

		if(approverIds_again != null && approverIds_again.size() > 0) {
        	String strHtmlBody_Approver_again = RFAUtility_Email.getHtmlBody_Resume_From_RTR_Approver(
        		ppoc, strEmailSubject_Approver_Again, rfa);    
        	                	
        	sendSingleEmailMessageEmail(approverIds_again, strEmailSubject_Approver_Again, strHtmlBody_Approver_again); 				
		}					                          		          
    }     
    
    
    public void sendEmail_Approver_ResumeFromRTR(RFA__c rfa)
    {  	
    	String strEmailSubject_Approver_New = '承認申請 (Request for Approval) : ' + rfa.Name + ': ' + rfa.RequestTitle__c;
    	String strEmailSubject_Approver_Again = '再申請 (Return to Sender Update Complete) - ' + rfa.Name + ': ' + rfa.RequestTitle__c;
    	
    	User ppoc;
    	
    	Set<Id> approverIds_new = new Set<Id>();
    	Set<Id> approverIds_again = new Set<Id>();
    	
    	Set<Id> reviewerIds = new Set<Id>();
        
		RFAUserRole__c rfaUserRolePPOC = [
			Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email FROM RFAUserRole__c 
            where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id ) 
            and RFA__c =: rfa.Id
            and UserName__r.IsActive = true
            order by CreatedDate Desc
            limit 1
        ];
        
        if(rfaUserRolePPOC != null) {
        	ppoc = new User(Id = rfaUserRolePPOC.UserName__c, Email = rfaUserRolePPOC.UserName__r.Email, 
        			LastName = rfaUserRolePPOC.UserName__r.LastName, FirstName = rfaUserRolePPOC.UserName__r.FirstName);
        	}            	        
        
        for(RFAUserRole__c rfaUserRole : [
         	Select Id, UserName__c, UserName__r.name, ApprovalRecommendation__c, ApprovalComments__c, 
         		Approval_Count__c, ApprovalOrder__c 
         		FROM RFAUserRole__c 
                   where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id ) 
                   and RFA__c =: rfa.Id
                   and ApprovalRecommendation__c =: RFAConstants.ApproverRecommend_AwaitingApproval 
                   //and Approval_Count__c > 0
                   order by ApprovalOrder__c ASC
         ]) {
         	if(rfaUserRole.Approval_Count__c == 0) {
         		approverIds_new.add(rfaUserRole.UserName__c);   
         	} else {
         		approverIds_again.add(rfaUserRole.UserName__c); 
         	}      	                                
         }               
                        

		if(approverIds_new != null && approverIds_new.size() > 0) {
			String strHtmlBody_Approver_new = RFAUtility_Email.getHtmlBody_Enter_Circulation_Approver(
        		ppoc, strEmailSubject_Approver_new, rfa);     
        	                	
        	sendSingleEmailMessageEmail(approverIds_new, strEmailSubject_Approver_new, strHtmlBody_Approver_new); 				
		}

		if(approverIds_again != null && approverIds_again.size() > 0) {
        	String strHtmlBody_Approver_again = RFAUtility_Email.getHtmlBody_Resume_From_RTR_Approver(
        		ppoc, strEmailSubject_Approver_Again, rfa);    
        	                	
        	sendSingleEmailMessageEmail(approverIds_again, strEmailSubject_Approver_Again, strHtmlBody_Approver_again); 				
		}					                          		          
    } 



	// RFA__c.Stage__c: Draft -> Circulation
	// c. To Requester, Primary Point of Contact(s) when RFA enters Circulation
	// Template: RFAVFT03_Upon Circulation - Requester  /00X10000000eBTi?setupid=CommunicationTemplatesEmail
	// To: Requester, PPOC
	// b. To Info Only Copy users when RFA enters circulation  -> Need to build  
	// Template: RFAVFT02 Upon Circulation - Info Only  /00X10000000eAqv?setupid=CommunicationTemplatesEmail
	// To: Info Only Copy
    public void sendEmail_EnterCirculation_ReqPPOC(RFA__c rfa)
    {      	
    	String strEmailSubject = '回覧通知 (Information Only) : ' + rfa.Name + ': ' + rfa.RequestTitle__c;
    	String strEmailSubject_InfoOnly = '起案通知 (Information Only) : ' + rfa.Name + ': ' + rfa.RequestTitle__c;
    	
    	//User requester = [Select Id, Name, IsActive from User where Id =: rfa.CreatedById];
    	User requester;
    	User ppoc;
    	    	
    	Set<Id> ppocIds = new Set<Id>();
    	//String ppocNameList = '';
    	
    	Set<Id> infoonlyIds = new Set<Id>();
        
        Boolean requesterIsPPOC = false;
        
		for(RFAUserRole__c rfaUserRole : [
			Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email FROM RFAUserRole__c 
            where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id ) 
            and RFA__c =: rfa.Id
            and UserName__r.IsActive = true
            order by CreatedDate Desc
        ]) {
        	if(ppoc == null) {
        		ppoc = new User(Id = rfaUserRole.UserName__c, Email = rfaUserRole.UserName__r.Email, 
        			LastName = rfaUserRole.UserName__r.LastName, FirstName = rfaUserRole.UserName__r.FirstName);
        		//[Select Id, Name, Username, Email from User where Id =: rfaUserRole.UserName__c];
        	}
        	//if(rfaUserRole.UserName__c != requester.Id) {
        		ppocIds.add(rfaUserRole.UserName__c);
        		
        		//if(RFAConstants.isBlank(ppocNameList)) {
        		//	ppocNameList = rfaUserRole.UserName__r.Name;
        		//} else {
        		//	ppocNameList = ppocNameList + ', ' + rfaUserRole.UserName__r.Name;
        		//}
        	//}    
        	if(rfaUserRole.UserName__c == rfa.CreatedById) {
        		requesterIsPPOC = true;
        	}                 	
        }             
        
        if(!requesterIsPPOC) {
        	requester = [Select Id, Name, IsActive from User where Id =: rfa.CreatedById];
        }
        
		for(RFAUserRole__c rfaUserRole : [
			Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email FROM RFAUserRole__c 
            where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id ) 
            and RFA__c =: rfa.Id
            and UserName__r.IsActive = true
            order by CreatedDate Desc
        ]) {
        	infoonlyIds.add(rfaUserRole.UserName__c);
        }        
        
        String strHtmlBody = RFAUtility_Email.getHtmlBody_Enter_Circulation_ReqPPOC(
        	ppoc, strEmailSubject, rfa);    
        
        String strHtmlBody_InfoOnly = RFAUtility_Email.getHtmlBody_Enter_Circulation_InfoOnly(
        	ppoc, strEmailSubject_InfoOnly, rfa);    	
		
		if(requester != null) {
			ppocIds.add(requester.Id);
		}
		system.debug('------- ppocIds: ' + ppocIds + ' requester: ' + requester + '  requesterIsPPOC: ' + requesterIsPPOC);
		sendSingleEmailMessageEmail(ppocIds, strEmailSubject, strHtmlBody); 
		
		system.debug('------- infoonlyIds: ' + ppocIds + ' strEmailSubject_InfoOnly: ' + strEmailSubject_InfoOnly);
		if(infoonlyIds != null && infoonlyIds.size() > 0) {
			sendSingleEmailMessageEmail(infoonlyIds, strEmailSubject_InfoOnly, strHtmlBody_InfoOnly); 
		}				                          		          
    }   


	//Approver & Agent: RFA enter Circulation
	//need to update, only to current Approver!
    public void sendEmail_EnterCirculation_Approver(RFA__c rfa)
    {      	
    	String strEmailSubject = '承認申請 (Request for Approval) : ' + rfa.Name + ': ' + rfa.RequestTitle__c;
    	
    	User requester = [Select Id, Name, IsActive from User where Id =: rfa.CreatedById];
    	User ppoc;
    	
    	Set<Id> ppocIds = new Set<Id>();
    	String ppocNameList = '';
    	
    	Set<Id> approverIds = new Set<Id>();
    	String approverNameList = '';
    	
    	Set<Id> reviewerIds = new Set<Id>();
    	String reviewerNameList = '';
        
		for(RFAUserRole__c rfaUserRole : [
			Select Id, UserName__c, UserName__r.Name, UserName__r.LastName, UserName__r.FirstName, UserName__r.Email FROM RFAUserRole__c 
            where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id ) 
            and RFA__c =: rfa.Id
            and UserName__r.IsActive = true
            order by CreatedDate Desc
        ]) {
        	if(ppoc == null) {
        		ppoc = [Select Id, Name, Username, Email from User where Id =: rfaUserRole.UserName__c];
        	}
        	if(rfaUserRole.UserName__c != requester.Id) {
        		ppocIds.add(rfaUserRole.UserName__c);
        		if(RFAConstants.isBlank(ppocNameList)) {
        			ppocNameList = rfaUserRole.UserName__r.Name;
        		} else {
        			ppocNameList = ppocNameList + ', ' + rfaUserRole.UserName__r.Name;
        		}
        	}                     	
        }     
        
        for(RFAUserRole__c rfaUserRole : [
         	Select Id, UserName__c, UserName__r.name, ApprovalRecommendation__c, ApprovalComments__c, 
         		Approval_Count__c, ApprovalOrder__c 
         		FROM RFAUserRole__c 
                   where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id ) 
                   and RFA__c =: rfa.Id
                   and Approval_Count__c > 0
                   order by ApprovalOrder__c ASC
         ]) {
         	approverIds.add(rfaUserRole.UserName__c);         	                                
         }               
        
        /*    
        List<User> reviewerList = getReviewerList(rfa.Id); 
        if(reviewerList != null && reviewerList.size() > 0) {
        	for(User cc : reviewerList) {
        		reviewerIds.add(cc.Id);
        	}
        }     */           
        
        /*
        String ccNameList = '';
        if(RFAConstants.isBlank(reviewerNameList)) {
        	ccNameList = approverNameList;
        } else {
        	ccNameList = approverNameList + ', ' + reviewerNameList;
        }*/
        
        String strHtmlBody = RFAUtility_Email.getHtmlBody_Enter_Circulation_Approver(
        	ppoc, strEmailSubject, rfa);    

		ppocIds.add(requester.Id);
		approverIds.addAll(ppocIds);
		//approverIds.addAll(reviewerIds); 
		sendSingleEmailMessageEmail(approverIds, strEmailSubject, strHtmlBody); 		                          		          
    }      






    //sendCompletionMemoEmail(toAddresses, ccdUsers, UserInfo.getUserId(), rfaObj.Id); 
    public void sendSingleEmailMessageEmail(
    	Set<Id> userIds,
    	String strEmailSubject, 
    	String strHtmlBody //,
    	)
    {         
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        if(userIds != null && userIds.size() > 0) {
        	for(Id userId : userIds) {
        		Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
        		mail.setSubject(strEmailSubject);
        		mail.setHtmlBody(strHtmlBody);
        		mail.setTargetObjectId(userId);
        		mail.saveAsActivity = false;
        		mail.orgWideEmailAddressId = idOrgWideEmailAddress; 
        		mail.setCharset('UTF-8');     
        		mails.add(mail);
        	}
        }               
        Messaging.sendEmail(mails);            
    }

	/*
    public void sendSingleEmailMessageSimple(
    	Id targetObjectId,  //userId 
    	Id templateId,
    	Id whatId //rfaId
    	)
    {          
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();        
        Messaging.SingleEmailMessage mail = new Messaging.Singleemailmessage();
        mail.setTemplateId(templateId);
        mail.setWhatId(whatId);
        mail.setTargetObjectId(targetObjectId); //To user
        mail.saveAsActivity = false;
        mail.orgWideEmailAddressId = Label.RFA_CL131; //From        
        mails.add(mail);       
        Messaging.sendEmail(mails);            
    }
    */
		
	//Profit Center: Viewer - All, Viewer - Capital Only  + RFA Approver/User: Info Copy Only
	/*
    public List<User> getReviewerList(Id rfaObjId) //, Set<Id> toList, Id requesterId)
    {   
    	List<User> reviewerList = new List<User>();     
    	Set<Id> associatedUsersIds = new Set<Id>();
    	
        Schema.DescribeSObjectResult d = Schema.SObjectType.User;
        String userKeyPrefix = d.getKeyPrefix();  
        system.debug('-------- userKeyPrefix: ' + userKeyPrefix );
                                     
        for(RFA__Share rfaShare : [
        	Select ParentId, RowCause, UserOrGroupId, AccessLevel 
        	FROM RFA__Share 
        	WHERE ParentId = : rfaObjId
        		//And UserOrGroupId NOT IN: toList
        		//And UserOrGroupId !=: requesterId
        		And (RowCause =: RFAConstants.RowCause_PCReviewer OR RowCause =: RFAConstants.RowCause_Reviewer)
        ])
        {
            String userAssociated = rfaShare.UserOrGroupId;
            if(userAssociated.substring(0,3) == userKeyPrefix)
                associatedUsersIds.add(rfaShare.UserOrGroupId); 
        }
             
        for(User user : [
        	Select Id, Name, FirstName, LastName, Email 
        	From User where isActive = true AND Id IN: associatedUsersIds 
        	ORDER BY FirstName
        ])
        {
            //if(user.Name <> RFAConstants.RFA_System_User) {
                reviewerList.add(user);
            //}
        }
        return reviewerList;                                                 
    }*/


    public List<RFAUserRole__c> getRelatedApprovers(Id rfaObjId) {
    	List<RFAUserRole__c> rfaUserRoleList = new List<RFAUserRole__c>();
    	
    	String defaultComments = '';
        if(rfaObjId != null) {     
         
         List<RFAUserRole__c> rfaUserList = [
         	Select Id, UserName__r.name, ApprovalRecommendation__c, ApprovalComments__c, 
         		Approval_Count__c, ApprovalOrder__c 
         		FROM RFAUserRole__c 
                   where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id ) 
                   and RFA__c =: rfaObjId
                   and Approval_Count__c > 0
                   order by ApprovalOrder__c ASC
         ];
		                                   
         	if(rfaUserList != NULL && rfaUserList.size() > 0) {
         		for(RFAUserRole__c ur : rfaUserList) {
                	if(RFAConstants.isBlank( ur.ApprovalComments__c )) {
                    	defaultComments += ur.UserName__r.name + ' - ' + ur.ApprovalRecommendation__c + ' - \n\n';  //dont' display null in Email 
                	} else {
                		defaultComments += ur.UserName__r.name + ' - ' + ur.ApprovalRecommendation__c + ' - ' + ur.ApprovalComments__c + '\n\n'; 
                	}         
            	}
                
            	system.debug('Value of the comments field ' + defaultComments.length());              
         	}                                            
        }  
		return rfaUserRoleList;                 
    }
  
		      
    public String getComment(Id rfaObjId) {
    	String defaultComments = '';
        if(rfaObjId != null) {     
         
         List<RFAUserRole__c> rfaUserList = [
         	Select Id, UserName__r.name, ApprovalRecommendation__c, ApprovalComments__c, 
         		Approval_Count__c, ApprovalOrder__c 
         		FROM RFAUserRole__c 
                   where (RecordTypeId =: toLstRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id ) 
                   and RFA__c =: rfaObjId
                   and Approval_Count__c > 0
                   order by ApprovalOrder__c ASC
         ];
		                                   
         	if(rfaUserList != NULL && rfaUserList.size() > 0) {
         		for(RFAUserRole__c ur : rfaUserList) {
                	if(RFAConstants.isBlank( ur.ApprovalComments__c )) {
                    	defaultComments += ur.UserName__r.name + ' - ' + ur.ApprovalRecommendation__c + ' - \n\n';  //dont' display null in Email 
                	} else {
                		defaultComments += ur.UserName__r.name + ' - ' + ur.ApprovalRecommendation__c + ' - ' + ur.ApprovalComments__c + '\n\n'; 
                	}         
            	}
                
            	system.debug('Value of the comments field ' + defaultComments.length());              
         	}                                            
        }  
		return defaultComments;                 
    }
    
   
   
 }