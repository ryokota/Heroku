/*    
 *  Trigger          : RUR_RFAUserRoleTrigger 
 *  Author           : Accenture
 *  Version History  : 2.0
 *  Creation         : 5/30/2012
 *  Assumptions      : N/A
 *  Description      : Trigger contains business logic to process RFA User role for different stages of parent RFA
 
 *  updated by Jia Hu on 2013/10/25                                   
 *  Level__c removed by Jia Hu on 2013/12/01
 */
//Record Types: Approver(RUR_Approver), Info Copy Only(RUR_InfoCopyOnly), Primary Point of Contact(RUR_PrimaryPointofContact) 
trigger RUR_RFAUserRoleTrigger on RFAUserRole__c (
	before insert, after insert, 
	before update, after update, 
	before delete, after delete) {
    
    // variable to hold unique set of approval process Ids.
    Set<Id> processIds = new Set<Id>();

    // variable to hold unique set of RFA Ids.
    Set<Id> rfaIds = new Set<Id>();
  
    // RFA User Role access to associated RFA
    Map<Id, String> rfaUserRoleRecordAccess = new Map<Id, String>();
    
    // RFA User Role access to be deleted for its associated RFA
    Map<Id, String> rfaUserRoleRecordAccessForDelete = new Map<Id, String>();
    
    Map<String,Map<Id,String>> rfaUserRoleMap = new Map<String,Map<Id, String>>();
    
    Map<String,Map<Id,String>> rfaUserRoleMapForDelete = new Map<String, Map<Id, String>>();
    
    // rfaIdsToCheck & rfaUserRoleValidateWrite attributes added for 2013 Q1 FR1.14
    // Set of RFA Ids to check if user has edit access to the triggered RFA User Role
    Set<Id> rfaIdsToCheck = new Set<Id>(); 
    // List of RFA User Roles to validate if user has Write access to
    List<RFAUserRole__c> rfaUserRoleValidateWrite = new List<RFAUserRole__c>(); 
    
    // Set of UserRoles for which the reference has been changed.
    Set<String> changedUserRole = new Set<String>();
    
    // Set of RFA Id for which Info Only needs to be processed
    Set<Id> rfaIdsInfoOnly = new Set<Id>();
    
    // List of RFA User Role for insert/update
    List<RFAUserRole__c> userRoleList = new List<RFAUserRole__c>();
    
    // List of Info Only RFA User Role for Insert/Update
    List<RFAUserRole__c> infoOnlyUserRoleList = new List<RFAUserRole__c>();
    
    // List of RFA Share record entry for insertion.
    List<RFA__Share> rfaShareForInsert = new List<RFA__Share>();
    
    // instantiate new rfa_AP02_ShareUtil
    RFA_AP02_Shareutil shareUtil = new RFA_AP02_Shareutil();
   
    // Get RecordTypes associated to RFAUser Role
    public static Map<String, RecordType> approverRecordTypeMap 
    	= RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());
    
  
    RFA_AP04_ApprovalWorkItemHelper workItemHelper = new RFA_AP04_ApprovalWorkItemHelper();
    
    RFA_VFC04_CompletionOfRFA instEmail = new RFA_VFC04_CompletionOfRFA();
    
    List<RFAUserRole__c> processDuplicateFlag = new List<RFAUserRole__c>();
    List<RFAUserRole__c> removeDuplicateFlag = new List<RFAUserRole__c>();
    
								    
    /********************************* BEFORE INSERT BLOCK STARTS***************************************/      
    if(Trigger.IsInsert && Trigger.isBefore)
    {     
        for(RFAUserRole__c app : Trigger.new)   
        {
        	system.debug('----- RFAUserRole__c in before insert Trigger: ' + app);
        	//can add in Circulation!
            // if user is not a RFA Admin, prevent Approvers from being added to RFA when RFA is completed - 2013 Q1 FR 1.87 
            if ( app.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id 
            	&& 
            	!RFAConstants.isRFAAdmin(UserInfo.getProfileId()) 
            	//!RFA_WS07_CheckRFAUser.isRFAAdmin() 
            	&&
                  ( app.RFAStage__c == RFAConstants.RFA_STATUS_CLOSED ||
                	app.RFAStage__c == RFAConstants.RFA_STATUS_APPROVED ||
                	app.RFAStage__c == RFAConstants.RFA_STATUS_REJECTED
                  ) 
               )
            {
            	//RFA_CL139: Approver cannot be added to a completed RFA.
                app.addError(System.Label.RFA_CL139);
                continue;
            }
            
            //If UserName for RFAUserRole is not null
            if(app.UserName__c != null)
            {           
                // For Primary POC   
                if(app.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id)
                   //|| app.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id)
                {                                     
                      processDuplicateFlag.add(app); //Added by Ashwani for FR1.54
                      
                      RFA__Share shareRec = new RFA__Share();
                      shareRec.UserOrGroupId = app.UserName__c;
                      shareRec.ParentId = app.RFA__c;
                      
                      // If Stage = "Draft" Or "Preliminary" Or "Return to Sender", set Accesslevel to "Edit"
                      if(app.RFAStage__c == RFAConstants.RFA_STATUS_DRAFT 
                      	|| app.RFAStage__c == RFAConstants.RFA_STATUS_ReturnToRequester
                      )
                      {
                          shareRec.AccessLevel = 'Edit';                          
                      }
                      // For stages other than Draft/Preliminary/Return To sender, set accesslevel to Read (for new user role insertion)
                      else
                      {
                          shareRec.AccessLevel = 'Read';
                      }
                      // Set rowcause   Primary POC = KO Requester
                      shareRec.RowCause = Schema.RFA__Share.RowCause.KORequestor__c;
                      // add to list for bulk insertion
                      rfaShareForInsert.add(shareRec);                    
                 }//end of if(Primary POC);      
          	}//end of if(app.UserName__c != null);
                            
            //For info only can be added when RFA closed
            if (app.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id)
            {
            	system.debug('--------- Trigger for Info Only ');
                    /* if rfa level != Capital management hold and return to sender and rfa stage != draft and
                     * info only level is same as RFA Level and RFA Stage != Pre-Circulation OR
                     * if info only level is below RFA Level, grant RFA access, associate approval process & set Notify User = true OR
                     * if RFA is in Pending Board Review OR a completed stage
                     */
                    if (//app.RFA_Level__c != RFAGlobalConstants.CAPITAL_MGMT_HOLD &&
                    	//app.RFA_Level__c != RFAGlobalConstants.RETURN_TO_SENDER &&
                    	
                    	//removed by Jia Hu on 2014/01/15
                    	/*
                    	app.RFAStage__c != RFAConstants.RFA_STATUS_ReturnToRequester
                    		//RFAGlobalConstants.RETURN_TO_SENDER 
                    	&&
                    	app.RFAStage__c != RFAConstants.RFA_STATUS_DRAFT
                    		//RFAGlobalConstants.RFA_STAGE_DRAFT 
                    	&&
                    	*/
                    	(
                    		//before insert trigger
                    		//removed by Jia Hu on 2013/11/06   remove Level__c on RFAUserRole__c
                    		//(
                    			//shareUtil.compareRFALevel(app.Level__c, app.RFA_Current_Level__c) == 0 
                    			//&& 
                    			//app.RFAStage__c != RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE && 
                    		//	app.RFAStage__c != null
                    		//) 
                    		//|| shareUtil.compareRFALevel(app.Level__c, app.RFA_Current_Level__c) < 0 
                    		//|| app.RFA_Level__c == RFAGlobalConstants.PENDING_BOARD_REVIEW 
                    		//|| 
                    		app.RFAStage__c == RFAConstants.RFA_STATUS_CLOSED
                    			//RFAGlobalConstants.RFA_STAGE_CLOSED 
                    		|| app.RFAStage__c == RFAConstants.RFA_STATUS_APPROVED
                    			//RFAGlobalConstants.RFA_STAGE_APPROVED 
                    		|| app.RFAStage__c == RFAConstants.RFA_STATUS_REJECTED
                    			//RFAGlobalConstants.RFA_STAGE_REJECTED
                    		//added by Jia Hu on 2014/01/15   can add Read Only in RFA Circulation + Read Only permission	
                    		|| app.RFAStage__c == RFAConstants.RFA_STATUS_CIRCULATION	
                    		|| app.RFAStage__c == RFAConstants.RFA_STATUS_DRAFT	
                    		|| app.RFAStage__c == RFAConstants.RFA_STATUS_ReturnToRequester	
                    		
                        )
                       )
                    {
                        // set notify users to true, 
                        app.NotifyUsers__c = true;
                        
                        // Grant info only user access to rfa
                        rfaShareForInsert.add(
                        	new RFA__Share(
                        		UserOrGroupId = app.UserName__c, 
                        		ParentId = app.RFA__c, 
                        		AccessLevel = 'Read', 
                        		RowCause = Schema.RFA__Share.RowCause.Reviewer__c)
                        );
                        
                        // If Agent 1 <> null, grant agent 1 access to rfa
                        if(app.Agent1__c <> null)   
                            rfaShareForInsert.add(
                            	new RFA__Share(
                            		UserOrGroupId = app.Agent1__c, 
                            		ParentId = app.RFA__c, 
                            		AccessLevel = 'Read', 
                            		RowCause = Schema.RFA__Share.RowCause.Reviewer__c)
                            );
                        
                        // If Agent 2 <> null, grant agent 2 access to rfa
                        if(app.Agent2__c <> null)
                            rfaShareForInsert.add(
                            	new RFA__Share(
                            		UserOrGroupId = app.Agent2__c, 
                            		ParentId = app.RFA__c, 
                            		AccessLevel = 'Read', 
                            		RowCause = Schema.RFA__Share.RowCause.Reviewer__c)
                            );
                        
                        // If Agent 3 <> null, grant agent 3 access to rfa
                        if(app.Agent3__c <> null)
                            rfaShareForInsert.add(
                            	new RFA__Share(
                            		UserOrGroupId = app.Agent3__c, 
                            		ParentId = app.RFA__c, 
                            		AccessLevel = 'Read', 
                            		RowCause = Schema.RFA__Share.RowCause.Reviewer__c)
                            );
                    }
                    
                    //if info only, add to list to associate existing approval process
                    infoOnlyUserRoleList.add(app);
                    rfaIdsInfoOnly.add(app.RFA__c);
            }//end of if(Read Only);
            
            // update approver's approval order if they are added for an inprogress Approval process
            if(app.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id
               //|| app.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id // GA: comment this out if info only should not have approval process populated
               && app.TECH_IsComplete__c.trim().equalsIgnoreCase('false'))
            {
            	system.debug('--------- Approver: ' + RFAConstants.RTLabel_RFAUserRole_Approver);
                  userRoleList.add(app);
                  rfaIds.add(app.RFA__c);
            }
            
        }//end of for(RFAUserRole__c app : Trigger.new) ;
        
        // insert rfa Share list
        if(!rfaShareForInsert.isEmpty()) {insert rfaShareForInsert;}
        //rfaUserRoleMap.put(app.Rfa__c, rfaUserRoleRecordAccess);
        
        system.debug('--------- userRoleList in Trigger: ' + userRoleList);
        
        // process User Role (Approver) records for in progress approval process before insertion.   
        if(!userRoleList.isEmpty()) {workItemHelper.processWorkITemBeforeInsert(userRoleList, rfaIds);}
        
        // process User Role (Info Only) records for associating existing approval processes
        if(!infoOnlyUserRoleList.isEmpty()) {workItemHelper.setInfoOnlyApprovalProcess(infoOnlyUserRoleList, rfaIdsInfoOnly);}
        
        //processDupliateFlag - Ashwani
        if(processDuplicateFlag.size() > 0) 
        {
             RFA_ProcessDuplicateFlag obj = new RFA_ProcessDuplicateFlag();
             obj.ProcessDuplicateFlagBeforeUpdateInsert(processDuplicateFlag);                  
             //End
        }
        
        // clear List after processing
        infoOnlyUserRoleList.clear();
        rfaIdsInfoOnly.clear();
        rfaShareForInsert.clear();
        userRoleList.clear();
        rfaIds.clear();
        processDuplicateFlag.clear();
        
    }//end of if(Trigger.IsInsert && Trigger.isBefore);
    /******************** BEFORE INSERT BLOCK ENDS ****************************************/
    
    /**************** UPDATE BLOCK STARTS***********************************************/
    
    /**************** BEFORE UPDATE BLOCK STARTS***********************************************/
    if(trigger.IsUpdate && trigger.IsBefore)
    {             
        for(RFAUserRole__c appr : Trigger.new)
        {
            //added by Ashwani for FR1.54
            if(
                (appr.username__c <> Trigger.oldMap.get(appr.id).username__c) && 
                (appr.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id)
                //|| appr.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id)
            )	           	  
            {
                processDuplicateFlag.add(appr);                
            }
			                                      
            // if RFA Approver / Info Only User is notified already 
            if( //appr.RFA_Level__c == RFAGlobalConstants.RETURN_TO_SENDER &&
            	appr.RFAStage__c == RFAConstants.RFA_STATUS_ReturnToRequester
            	//RFAGlobalConstants.RETURN_TO_SENDER 
            	&&
                (
                	(appr.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id 
                		&& appr.ApprovalProcess__c != null ) 
                	||
                	(appr.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id 
                		&& appr.Notifyuserfirsttime__c)
                ) 
              )
            {
                // Add to list and set to validate if logged in user has access to update RFAUserRole record
                rfaIdsToCheck.add(appr.RFA__c);
                rfaUserRoleValidateWrite.add(appr);
            }
            
            // Assign the Approval Requested Date for the RFA User Role of Record Type "Approver"
            //RFA_CL056: Awaiting Approval
            if(				            
            	appr.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id &&
                (
                	appr.ApprovalRecommendation__c <> NULL 
                	|| 
                	appr.ApprovalRecommendation__c <> '') &&  
               	Trigger.oldMap.get(appr.Id).ApprovalRecommendation__c == '' &&
               	appr.ApprovalRecommendation__c <> Trigger.oldMap.get(appr.Id).ApprovalRecommendation__c &&
               	appr.ApprovalRecommendation__c.trim().equalsIgnoreCase(
               		RFAConstants.ApproverRecommend_AwaitingApproval
               		//System.Label.RFA_CL056 //Awaiting Approval
               		)
            )
            {
                appr.ApprovalRequestedOn__c = System.Now();
                continue;
            }
            
            //removed by Jia Hu on 2013/11/06    level__c on RFAUserRole__c is removed
            //For info only (level change) @ before update trigger
            /*
            if (appr.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id &&
                appr.Level__c != Trigger.oldMap.get(appr.Id).Level__c)
            {                               
                // if info only level is less than or equal to RFA Level and user hasn't been processed for notification, 
                // set Notify User = true, access will be granted in afterUpdate
                if ( 
                	(
                		(shareUtil.compareRFALevel(appr.Level__c, appr.RFA_Current_Level__c) == 0 
                			&& appr.RFAStage__c != RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE && appr.RFAStage__c != null) 
                		||
                    	shareUtil.compareRFALevel(appr.Level__c, appr.RFA_Current_Level__c) < 0
                    ) 
                    && appr.Notifyuserfirsttime__c == false
                   )
                {
                    // if rfa level != Capital management hold or return to sender, rfa stage != draft
                    if (appr.RFA_Level__c != RFAGlobalConstants.CAPITAL_MGMT_HOLD &&
                        appr.RFA_Level__c != RFAGlobalConstants.RETURN_TO_SENDER &&
                        appr.RFAStage__c != RFAGlobalConstants.RFA_STAGE_DRAFT)
                    {
                        // set notify users to true,
                        appr.NotifyUsers__c = true;
                    }
                    
                    //if info only, add to list to associate existing approval process
                    infoOnlyUserRoleList.add(appr);
                    rfaIdsInfoOnly.add(appr.RFA__c);
                }
            }
            */
        }
        
        // logic to validate if logged in user has write permission to update RFAUserRole for RFAUserRoleValidateWrite list records
        if (
        	//!RFA_WS07_CheckRFAUser.isRFAAdmin() 
        	!RFAConstants.isRFAAdmin(UserInfo.getProfileId()) 
        	&& rfaUserRoleValidateWrite.size() > 0)
        {
            Map<Id, Boolean> hasEditOnRFAExcludingRequestor 
            	= RFAUtility.ignoreRequestorWithEditOnRFA(rfaIdsToCheck);
            	//= RFA_WS07_CheckRFAUser.ignoreRequestorWithEditOnRFA(rfaIdsToCheck);
            
            for (RFAUserRole__c toValidateWrite : rfaUserRoleValidateWrite)
            {
                // if logged in User is Creator, CoCreator or Primary POC and not any other type of user with edit access on RFA record, 
                // display error message
                if(!hasEditOnRFAExcludingRequestor.get(toValidateWrite.RFA__c))
                {
                	//updated by Jia Hu on 2013/12/09   need to check!!??
                	//got error when Approver select 'Return to Requester'
                    //RFA_CL138 = System has already sent a notification to this user. The record cannot be modified or deleted.
                    //toValidateWrite.addError(System.Label.RFA_CL138);
                }
            }
        }
        
        
        // process User Role (Info Only) records for associating existing approval processes
        if(!infoOnlyUserRoleList.isEmpty()) 
        {
        	workItemHelper.setInfoOnlyApprovalProcess(infoOnlyUserRoleList, rfaIdsInfoOnly);
        }
        
         //processDupliateFlag - Ashwani
        if(processDuplicateFlag.size() > 0) 
        {
             RFA_ProcessDuplicateFlag obj = new RFA_ProcessDuplicateFlag();
             obj.ProcessDuplicateFlagBeforeUpdateInsert(processDuplicateFlag);
             //End
        }
        
        // clear List after processing
        infoOnlyUserRoleList.clear();
        rfaIdsInfoOnly.clear();
        rfaIdsToCheck.clear();
        rfaUserRoleValidateWrite.clear();
        processDuplicateFlag.clear();
        
    }//end of if(trigger.IsUpdate && trigger.IsBefore);
    /**************** BEFORE UPDATE BLOCK ENDS***********************************************/
    
    /**************** AFTER UPDATE BLOCK STARTS***********************************************/
    if(trigger.IsUpdate && trigger.IsAfter)
    {		        
        for(RFAUserRole__c app : Trigger.new)
        {              
        	//added by Jia Hu on 2013/12/02  
        	//reject by Approver
        	if(
        		app.ApprovalProcess__c != null
        		&& app.ApprovalRecommendation__c != null
        		&& app.ApprovalRecommendation__c != Trigger.oldMap.get(app.Id).ApprovalRecommendation__c
        		//&& (app.ApprovalRecommendation__c == 'Rejected' || app.ApprovalRecommendation__c == '否認') 
        		&& app.ApprovalRecommendation__c == RFAConstants.ApproverRecommend_Rejected       		
        	) {
        		ApprovalProcess__c ap = [Select Id, Status__c from ApprovalProcess__c where Id =: app.ApprovalProcess__c];
        		ap.Status__c = 'Completed';
        		update ap;
        		
        		RFA__c rfa = [Select Id, Stage__c from RFA__c where Id =: app.RFA__c];
        		rfa.Stage__c = 'Rejected';
        		update rfa;
        	}
        	
            //added by Ashwani for FR1.54    
            if(
           		(app.username__c <> Trigger.oldMap.get(app.id).username__c) && 
           		(app.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id)
                   //|| app.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id)
            )
            {
                processDuplicateFlag.add(app);					                      
            }     
                
            // Process RFA User Role records which are associated to an Approval Process or the RFA is/was in Circulation Stage
            // This block of code will be triggered when Loal Coordinator submits an Approval Process for approval and
            // RFA User Role of current level and below are associated to the submitted Approval Process.
            
            system.debug('-------- Trigger After Update:  RFAUserRole__c.ApprovalRecommendation__c: ' + app.ApprovalRecommendation__c);
            system.debug('-------- app.ApprovalProcess__c: ' + app.ApprovalProcess__c);
            system.debug('-------- app.RecordTypeId: ' + app.RecordTypeId);
            system.debug('-------- RT ID: ' + approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id);
            system.debug('---------- approverRecordTypeMap ' + approverRecordTypeMap);
            system.debug('-------- app.ApprovalRecommendation__c: ' + app.ApprovalRecommendation__c);
            system.debug('-------- Trigger.oldMap.get(app.Id).ApprovalRecommendation__c: ' + Trigger.oldMap.get(app.Id).ApprovalRecommendation__c);
            //system.debug('-------- RFAGlobalConstants.PROCESS_PENDING_RECOMMENDATION: ' + RFAGlobalConstants.PROCESS_PENDING_RECOMMENDATION);
            
            //updated by Jia Hu on 2013/12/03   need Japanese support
            //add Read Only to Approver when Requester click Circulation button
            // Logic to grant RFA access to Approver to RFA when it enters circulation
            if(app.ApprovalProcess__c <> null
            	&& app.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id 
            	&& app.ApprovalRecommendation__c == RFAConstants.ApproverRecommend_AwaitingApproval
            	&& app.ApprovalRecommendation__c <> Trigger.oldMap.get(app.Id).ApprovalRecommendation__c)
            {
            	system.debug('--------- app.UserName__c: ' + app.UserName__c);
                // If ActualApprover <> null, set rowcause
                if(app.UserName__c <> null) 
                	rfaUserRoleRecordAccess.put(app.UserName__c,Schema.RFA__Share.RowCause.Approver__c);
                // If Agent 1 <> null, set rowcause
                if(app.Agent1__c <> null)   
                	rfaUserRoleRecordAccess.put(app.Agent1__c,Schema.RFA__Share.RowCause.Approver__c);
                // If Agent 2 <> null, set rowcause
                if(app.Agent2__c <> null)   
                	rfaUserRoleRecordAccess.put(app.Agent2__c,Schema.RFA__Share.RowCause.Approver__c);
                // If Agent 3 <> null, set rowcause
                if(app.Agent3__c <> null)   
                	rfaUserRoleRecordAccess.put(app.Agent3__c,Schema.RFA__Share.RowCause.Approver__c);    
                
                system.debug('------- Approver Status: ' + app.ApprovalRecommendation__c + ' RFA Stage: ' + app.RFAStage__c);
                
                //sending email:
                //there maybe multipule Approvers in the same level!
                //if(RFA_VFC04_CompletionOfRFA.emailAtWaitingForApproval) {
                if(app.RFAStage__c == RFAConstants.RFA_STATUS_CIRCULATION) {
                	if(!RFA_VFC04_CompletionOfRFA.emailApproverAtWaitingForApproval.contains(app.Id)) {
                		//Return to Requester / 差し戻し : don't send email to Approvers
                		List<RFAUserRole__c> appList = [Select Id, ApprovalRecommendation__c 
                			from RFAUserRole__c 
                			where RFA__c =: app.RFA__c And ApprovalRecommendation__c =: RFAConstants.ApproverRecommend_ReturnToRequester ];
                		
                		system.debug('------- RFAUserRole__c if has Return to Requester ' + appList);
                			
                		if(appList != null && appList.size() > 0) {
                			system.debug('------- appList != null && appList.size() > 0 ');
                		} else {
                			system.debug('-------- trying to send email to Approvers! ');
                			instEmail.sendEmail_Approver(app);	
                			RFA_VFC04_CompletionOfRFA.emailApproverAtWaitingForApproval.add(app.Id);
                		}
                		
                		
                		
                	}
                }
                //	RFA_VFC04_CompletionOfRFA.emailAtWaitingForApproval = false;
                //}
                	             
            }
            system.debug('--------- rfaUserRoleRecordAccess: ' + rfaUserRoleRecordAccess);
               
            // If Approver or Agent is changed for an RFA User Role with a valid Approval Process
            if(app.ApprovalProcess__c <> null
                        &&(app.UserName__c <> Trigger.oldMap.get(app.Id).UserName__c
                        || app.Agent1__c <> Trigger.oldMap.get(app.Id).Agent1__c
                        || app.Agent2__c <> Trigger.oldMap.get(app.Id).Agent2__c
                        || app.Agent3__c <> Trigger.oldMap.get(app.Id).Agent3__c))              
            {
                // if RFA Record Type equals "Approver" && Approval Recommendation = 'Awaiting Approval'
                if(app.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id 
                	&& app.ApprovalRecommendation__c == RFAConstants.ApproverRecommend_AwaitingApproval
                		//RFAGlobalConstants.PROCESS_PENDING_RECOMMENDATION
                	)
                {
                    // If Actual Approver reference has been changed
                    if(app.UserName__c <> Trigger.oldMap.get(app.Id).UserName__c)
                    {
                         // add to rfaUserRoleRecordAccess map for providing "Read Only" Access
                         if(app.UserName__c <> null)
                         	rfaUserRoleRecordAccess.put(app.UserName__c,Schema.RFA__Share.RowCause.Approver__c);
                         	
                         // if Old Approver was not blank/null  
                         if(Trigger.oldMap.get(app.Id).UserName__c <> null)
                         {
                            // add to rfaUserRoleRecordAccessForDelete map for deletion of corresponding share record from RFA level.
                            rfaUserRoleRecordAccessForDelete.put(
                            	Trigger.oldMap.get(app.Id).UserName__c, Schema.RFA__Share.RowCause.Approver__c);
                            
                            changedUserRole.add(app.Id);    
                         } 
                    }
                    
                    // If Agent 1 reference has been changed
                    if(app.Agent1__c <> Trigger.oldMap.get(app.Id).Agent1__c)
                    {
                        // add to rfaUserRoleRecordAccess map for providing "Read Only" Access
                         if(app.Agent1__c <> null)
                         	rfaUserRoleRecordAccess.put(app.Agent1__c,Schema.RFA__Share.RowCause.Approver__c);
                         // if Old Approver was not blank/null
                         if(Trigger.oldMap.get(app.Id).Agent1__c <> null)
                         {
                             // add to rfaUserRoleRecordAccessForDelete map for deletion of corresponding share record from RFA level.
                             rfaUserRoleRecordAccessForDelete.put(
                             	Trigger.oldMap.get(app.Id).Agent1__c, Schema.RFA__Share.RowCause.Approver__c);
                             changedUserRole.add(app.Id);   
                         }  
                    }
                    
                    // If Agent 2 reference has been changed
                    if(app.Agent2__c <> Trigger.oldMap.get(app.Id).Agent2__c)
                    {
                        // add to rfaUserRoleRecordAccess map for providing "Read Only" Access
                        if(app.Agent2__c <> null)
                        	rfaUserRoleRecordAccess.put(app.Agent2__c,Schema.RFA__Share.RowCause.Approver__c);
                        	
                        // if Old Agent 2 was not blank/null 
                        if(Trigger.oldMap.get(app.Id).Agent2__c <> null)
                        {
                             // add to rfaUserRoleRecordAccessForDelete map for deletion of corresponding share record from RFA level.
                             rfaUserRoleRecordAccessForDelete.put(
                             	Trigger.oldMap.get(app.Id).Agent2__c, Schema.RFA__Share.RowCause.Approver__c);
                             changedUserRole.add(app.Id);   
                        }       
                    }   
                    
                    // If Agent 3 reference has been changed
                    if(app.Agent3__c <> Trigger.oldMap.get(app.Id).Agent3__c)
                    {
                        // add to rfaUserRoleRecordAccess map for providing "Read Only" Access
                        if(app.Agent3__c <> null)
                        	rfaUserRoleRecordAccess.put(app.Agent3__c,Schema.RFA__Share.RowCause.Approver__c);
                        	
                        // if Old Agent 3 was not blank/null 
                        if(Trigger.oldMap.get(app.Id).Agent3__c <> null)
                        {
                            // add to rfaUserRoleRecordAccessForDelete map for deletion of corresponding share record from RFA level.
                             rfaUserRoleRecordAccessForDelete.put(
                             	Trigger.oldMap.get(app.Id).Agent3__c, Schema.RFA__Share.RowCause.Approver__c);
                             changedUserRole.add(app.Id);   
                        }   
                    }           
                }
            }
            
            // GA 5/9/2013: Moved Info Only logic below from if(app.ApprovalProcess__c <> null) block above and expanded logic to handle agent field updates
            // If RFA User Role record type equals "Info Only" and Info Only user has been marked for notification
            if(app.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id 
            	&& (app.Notifyuserfirsttime__c || app.NotifyUsers__c))
            {
                // if user was marked to be notified, grant Info Only user read only access to the RFA record 
                if (!Trigger.oldMap.get(app.Id).NotifyUsers__c)
                {
                    // set the rowcause to "Reviewer__c"
                    if(app.UserName__c <> null) 
                    	rfaUserRoleRecordAccess.put(app.UserName__c,Schema.RFA__Share.RowCause.Reviewer__c);
                    // If Agent 1 <> null, set rowcause
                    if(app.Agent1__c <> null)   
                    	rfaUserRoleRecordAccess.put(app.Agent1__c,Schema.RFA__Share.RowCause.Reviewer__c);
                    // If Agent 2 <> null, set rowcause
                    if(app.Agent2__c <> null)   
                    	rfaUserRoleRecordAccess.put(app.Agent2__c,Schema.RFA__Share.RowCause.Reviewer__c);
                    // If Agent 3 <> null, set rowcause
                    if(app.Agent3__c <> null)   
                    	rfaUserRoleRecordAccess.put(app.Agent3__c,Schema.RFA__Share.RowCause.Reviewer__c);      
                }
                
                // if Info Only userName reference has been changed
                if (app.UserName__c <> Trigger.oldMap.get(app.Id).UserName__c)
                {
                    // add to rfaUserRoleRecordAccess map for providing "Read Only" Access
                    if(app.UserName__c <> null)
                    	rfaUserRoleRecordAccess.put(app.UserName__c,Schema.RFA__Share.RowCause.Reviewer__c);
                    // if Old UserName was not blank/null
                    if(Trigger.oldMap.get(app.Id).UserName__c <> null)
                    {
                        // add to rfaUserRoleRecordAccessForDelete map for deletion of corresponding share record from RFA level.
                         rfaUserRoleRecordAccessForDelete.put(
                         	Trigger.oldMap.get(app.Id).UserName__c, Schema.RFA__Share.RowCause.Reviewer__c);
                         changedUserRole.add(app.Id);   
                    }
                }
                
                // If Info Only Agent 1 reference has been changed
                if(app.Agent1__c <> Trigger.oldMap.get(app.Id).Agent1__c)
                {
                    // add to rfaUserRoleRecordAccess map for providing "Read Only" Access
                     if(app.Agent1__c <> null)
                     	rfaUserRoleRecordAccess.put(app.Agent1__c, Schema.RFA__Share.RowCause.Reviewer__c);
                     // if Old Approver was not blank/null
                     if(Trigger.oldMap.get(app.Id).Agent1__c <> null)
                     {
                         // add to rfaUserRoleRecordAccessForDelete map for deletion of corresponding share record from RFA level.
                         rfaUserRoleRecordAccessForDelete.put(
                         	Trigger.oldMap.get(app.Id).Agent1__c, Schema.RFA__Share.RowCause.Reviewer__c);
                         changedUserRole.add(app.Id);   
                     }  
                }
                
                // If Info Only Agent 2 reference has been changed
                if(app.Agent2__c <> Trigger.oldMap.get(app.Id).Agent2__c)
                {
                    // add to rfaUserRoleRecordAccess map for providing "Read Only" Access
                    if(app.Agent2__c <> null)rfaUserRoleRecordAccess.put(
                    	app.Agent2__c, Schema.RFA__Share.RowCause.Reviewer__c);
                    // if Old Agent 2 was not blank/null 
                    if(Trigger.oldMap.get(app.Id).Agent2__c <> null)
                    {
                         // add to rfaUserRoleRecordAccessForDelete map for deletion of corresponding share record from RFA level.
                         rfaUserRoleRecordAccessForDelete.put(
                         	Trigger.oldMap.get(app.Id).Agent2__c, Schema.RFA__Share.RowCause.Reviewer__c);
                         changedUserRole.add(app.Id);   
                    }       
                }   
                
                // If Info Only Agent 3 reference has been changed
                if(app.Agent3__c <> Trigger.oldMap.get(app.Id).Agent3__c)
                {
                    // add to rfaUserRoleRecordAccess map for providing "Read Only" Access
                    if(app.Agent3__c <> null)rfaUserRoleRecordAccess.put(
                    	app.Agent3__c, Schema.RFA__Share.RowCause.Reviewer__c);
                    // if Old Agent 3 was not blank/null 
                    if(Trigger.oldMap.get(app.Id).Agent3__c <> null)
                    {
                        // add to rfaUserRoleRecordAccessForDelete map for deletion of corresponding share record from RFA level.
                         rfaUserRoleRecordAccessForDelete.put(
                         	Trigger.oldMap.get(app.Id).Agent3__c, Schema.RFA__Share.RowCause.Reviewer__c);
                         changedUserRole.add(app.Id);   
                    }   
                } 
            }         
            
            // If RFA User Role record type equals "Primary Point of Contact" OR "Creator" and userName reference has been changed
            if((app.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id) 
                //|| app.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id) 
                && app.UserName__c <> Trigger.oldMap.get(app.Id).UserName__c)
            {
                // new RFA Share
                RFA__Share shareRec = new RFA__Share();
                // Set UserOrGoupId
                shareRec.UserOrGroupId = app.UserName__c;
                // Set parent Id
                shareRec.ParentId = app.RFA__c;
                
                // If RFA Stage equals "Draft" Or "Preliminary" Or "Return to Sender", set AccessLevel to "Edit"
                if(app.RFAStage__c == RFAConstants.RFA_STATUS_DRAFT
                	//RFAGlobalConstants.RFA_STAGE_DRAFT 
                	//|| app.RFA_Level__c == RFAGlobalConstants.RETURN_TO_SENDER
                	|| app.RFAStage__c == RFAConstants.RFA_STATUS_ReturnToRequester
                	//RFAGlobalConstants.RETURN_TO_SENDER
                )
                {
                    shareRec.AccessLevel = 'Edit';                          
                }
                // share Access level to "Read Only"
                else
                {
                    shareRec.AccessLevel = 'Read';
                }
                // set the share rowcause
                shareRec.RowCause = Schema.RFA__Share.RowCause.KORequestor__c;
                // add to list
                rfaShareForInsert.add(shareRec);
                
                // if old UserName was not blank
                if(Trigger.oldMap.get(app.Id).UserName__c <> null)
                {
                     //<start> BSA 13-June-2013 - Fix for issues when editing Primary point (if creator ==Primary Point of Contact/Co-Creator)
                     RFA__c r = [Select Id, CreatedById FROM RFA__c where Id =:app.RFA__c limit 1];
                   
                        if(Trigger.oldMap.get(app.Id).UserName__c == r.CreatedById)
                        {
                            //do nothing...
                        }
                        else
                        {
                            system.debug('\n rsas PPOC or Co-Creator is not the Creator');
                    
		                    // add to rfaUserRoleRecordAccessForDelete map for deletion of corresponding share record from RFA level. 
		                    rfaUserRoleRecordAccessForDelete.put(
		                    	Trigger.oldMap.get(app.Id).UserName__c, Schema.RFA__Share.RowCause.KORequestor__c);
		                    changedUserRole.add(app.Id);
                        }
                    //<END> BSA 13-June-2013    
                }   
            }
            
            
            if(!rfaUserRoleRecordAccess.isEmpty())
            {
                if(rfaUserRoleMap.containsKey(app.RFA__c))
                {
                    rfaUserRoleMap.get(app.RFA__c).putAll(rfaUserRoleRecordAccess);
                } else
                {
                    rfaUserRoleMap.put(app.RFA__c, rfaUserRoleRecordAccess);
                }
            } 
                           
            if(!rfaUserRoleRecordAccessForDelete.isEmpty())
            {
                if(rfaUserRoleMapForDelete.containsKey(app.RFA__c))
                {
                    rfaUserRoleMapForDelete.get(app.RFA__c).putAll(rfaUserRoleRecordAccessForDelete);
                } else
                {
                    rfaUserRoleMapForDelete.put(app.RFA__c, rfaUserRoleRecordAccessForDelete);
                }
            }
                           
            if(app.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id
             && app.TECH_IsComplete__c.trim().equalsIgnoreCase('true')
             && app.ApprovalRecommendation__c <> Trigger.oldMap.get(app.Id).ApprovalRecommendation__c)
            {
                processIds.add(app.ApprovalProcess__c); 
            }
            System.debug(processIds + 'processIds');                        
        }
        
        if(!rfaShareForInsert.isEmpty()) {insert rfaShareForInsert;}
         
        //processDupliateFlag - Ashwani
        if(processDuplicateFlag.size() > 0) 
        {
             RFA_ProcessDuplicateFlag obj = new RFA_ProcessDuplicateFlag();
             obj.ProcessDuplicateFlagAfterUpdate(processDuplicateFlag, Trigger.oldMap);            
        }
    }//end of if(trigger.IsUpdate && trigger.IsAfter);
    
    /*********************************** END OF UPDATE BLOCK **********************************/
    
    /********************************** DELETE BLOCK STARTS ***********************************/
    
    if(trigger.isDelete && Trigger.isBefore)
    {
    	boolean isAdmin = RFAConstants.evaluateIfAdmin(UserInfo.getProfileId());
    	
        for(RFAUserRole__c deletedApp : Trigger.old)
        {  
        	if(deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id ) {
        		if(
        			(deletedApp.Approver_Source__c == 'Capital Mgmt.' || deletedApp.Approver_Source__c == 'Manager')
        			&&
        			!isAdmin
        		  ) {
        			deletedApp.addError(
        				Label.RFA_ErrorMsg_DeleteCM_Mgr
        				//'Capital ManagmentまたはManager削除できないです！ / Capital Managment or Manager can\'t be deleted!'
        				);
        		}
        		
        		
        	}
        	
        	
            //=========================START of Fix for INC0432162 - BSA - 18-Mar-2013 ==========================================
            if(deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id 
            	&& deletedApp.RFAStage__c == RFAConstants.RFA_STATUS_CIRCULATION
            		//RFAGlobalConstants.RFA_CIRCULATION_STAGE 
            	)
            {
                /* Labal.RFA_CL137 = 
                You cannot delete Approver during Circulation Stage. If the Approver is no longer needed, 
                you may Edit the Approver record and enter an Approval Recommendation of No Longer Needed. 
                Approver may be deleted during Pre-Circulation or Post-Circulation stage */
                Trigger.old[0].addError(System.Label.RFA_CL137);
            }
            //=========================END of Fix for INC0432162  - BSA - 18-Mar-2013 ==========================================
                            
            // if RFA Approver / Info Only User is notified already 
            if( //deletedApp.RFA_Level__c == RFAGlobalConstants.RETURN_TO_SENDER &&
            	deletedApp.RFAStage__c == RFAConstants.RFA_STATUS_ReturnToRequester
            		//RFAGlobalConstants.RETURN_TO_SENDER 
            	&&
                (
                	(deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id 
                		&& deletedApp.ApprovalProcess__c != null ) 
                	||
                	(deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id 
                		&& deletedApp.Notifyuserfirsttime__c)
                ) 
              )
            {
                // Add to list and set to validate if logged in user has access to update RFAUserRole record
                rfaIdsToCheck.add(deletedApp.RFA__c);
                rfaUserRoleValidateWrite.add(deletedApp);
            }
        }
        
        // logic to validate if logged in user has write permission to update RFAUserRole for RFAUserRoleValidateWrite list records
        if (
        	//!RFA_WS07_CheckRFAUser.isRFAAdmin() 
        	!RFAConstants.isRFAAdmin(UserInfo.getProfileId()) 
        	&& rfaUserRoleValidateWrite.size() > 0)
        {
            Map<Id, Boolean> hasEditOnRFAExcludingRequestor 
            	= RFAUtility.ignoreRequestorWithEditOnRFA(rfaIdsToCheck);
            	//= RFA_WS07_CheckRFAUser.ignoreRequestorWithEditOnRFA(rfaIdsToCheck);
            
            for (RFAUserRole__c toValidateWrite : rfaUserRoleValidateWrite)
            {
                // if logged in User is Creator, CoCreator or Primary POC and not any other type of user with edit access on RFA record, display error message
                if(!hasEditOnRFAExcludingRequestor.get(toValidateWrite.RFA__c))
                {
                	system.debug('--------- RFAUserRole__c toValidateWrite.Id ' + toValidateWrite.Id + '  ----- hasEditOnRFAExcludingRequestor: ' + hasEditOnRFAExcludingRequestor);
                	//by Jia Hu on 2013/12/09  need to check !!??
                    //RFA_CL138 = System has already sent a notification to this user. The record cannot be modified or deleted.
                    toValidateWrite.addError(System.Label.RFA_CL138);
                }
            }
        }
        
        // clear List after processing
        rfaIdsToCheck.clear();
        rfaUserRoleValidateWrite.clear();
        
    }//end of if(trigger.isDelete && Trigger.isBefore);

	    
    if(trigger.isDelete && Trigger.isAfter)  
    {						        
        for(RFAUserRole__c deletedApp : Trigger.old)
        {           
               //added by Ashwani for FR1.54
               if(deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id)
                   //|| deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id)
               {
                  removeDuplicateFlag.add(deletedApp);
                     
               }
                if(deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id
                  && deletedApp.TECH_IsComplete__c.trim().equalsIgnoreCase('false'))
                {
                    processIds.add(deletedApp.ApprovalProcess__c);  
                }
                
                // Approvers
                if(deletedApp.UserName__c <> null 
                	&& deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id)
                {
                    rfaUserRoleRecordAccessForDelete.put(deletedApp.UserName__c, Schema.RFA__Share.RowCause.Approver__c);   
                    changedUserRole.add(deletedApp.Id);
                }
                
                if(deletedApp.Agent1__c <> null 
                	&& deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id)
                {
                    rfaUserRoleRecordAccessForDelete.put(deletedApp.Agent1__c, Schema.RFA__Share.RowCause.Approver__c); 
                    changedUserRole.add(deletedApp.Id);
                }
                
                if(deletedApp.Agent2__c <> null 
                	&& deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id)
                {
                    rfaUserRoleRecordAccessForDelete.put(deletedApp.Agent2__c, Schema.RFA__Share.RowCause.Approver__c); 
                    changedUserRole.add(deletedApp.Id);
                }
                
                if(deletedApp.Agent3__c <> null 
                	&& deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id)
                {
                    rfaUserRoleRecordAccessForDelete.put(deletedApp.Agent3__c, Schema.RFA__Share.RowCause.Approver__c); 
                    changedUserRole.add(deletedApp.Id);
                }
                
                // NEED TO FIX the row cause assignment for Co-Creator and primary point of contact
                if(
                	(deletedApp.UserName__c <> null 
                		&& deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id) 
                	//|| (deletedApp.UserName__c <> null && deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id)
                  )
                {
                    
                    //<start> BSA 22-April-2013
                   
                    RFA__c r = [Select Id, CreatedById FROM RFA__c where Id =: deletedApp.RFA__c limit 1];
                   
                        if(deletedApp.UserName__c == r.CreatedById)
                        {
                            //do nothing...
                        }
                        else
                        {
                            system.debug('\n rsas PPOC or Co-Creator is not the Creator');
                            
                        rfaUserRoleRecordAccessForDelete.put(deletedApp.UserName__c, Schema.RFA__Share.RowCause.KORequestor__c);    
                        changedUserRole.add(deletedApp.Id); 
                        }
                   
                     //<end>
                }
                
                //commented out BSA 22-April-2013
                //if(deletedApp.UserName__c <> null && deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id)
                //{
                 //   rfaUserRoleRecordAccessForDelete.put(deletedApp.UserName__c, Schema.RFA__Share.RowCause.KORequestor__c);    
                  //  changedUserRole.add(deletedApp.Id); 
                //}
                
                // Info Only
                if(deletedApp.UserName__c <> null 
                	&& deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id)
                {
                    rfaUserRoleRecordAccessForDelete.put(deletedApp.UserName__c, Schema.RFA__Share.RowCause.Reviewer__c);    
                    changedUserRole.add(deletedApp.Id); 
                }
                
                if(deletedApp.Agent1__c <> null 
                	&& deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id)
                {
                    rfaUserRoleRecordAccessForDelete.put(deletedApp.Agent1__c, Schema.RFA__Share.RowCause.Reviewer__c); 
                    changedUserRole.add(deletedApp.Id);
                }
                
                if(deletedApp.Agent2__c <> null 
                	&& deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id)
                {
                    rfaUserRoleRecordAccessForDelete.put(deletedApp.Agent2__c, Schema.RFA__Share.RowCause.Reviewer__c); 
                    changedUserRole.add(deletedApp.Id);
                }
                
                if(deletedApp.Agent3__c <> null 
                	&& deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id)
                {
                    rfaUserRoleRecordAccessForDelete.put(deletedApp.Agent3__c, Schema.RFA__Share.RowCause.Reviewer__c); 
                    changedUserRole.add(deletedApp.Id);
                }
                
                if(deletedApp.TECH_IsComplete__c.trim().equalsIgnoreCase('false') 
                	&& deletedApp.ApprovalRecommendation__c == RFAConstants.ApproverRecommend_AwaitingApproval
                		//RFAGlobalConstants.PROCESS_PENDING_RECOMMENDATION 
                	&& deletedApp.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id
                  )
                {
                    userRoleList.add(deletedApp);
                    processIds.add(deletedApp.ApprovalProcess__c);
                }
                              
                if(!rfaUserRoleRecordAccessForDelete.isEmpty())
                {
                    if(rfaUserRoleMapForDelete.containsKey(deletedApp.RFA__c))
                    {
                        rfaUserRoleMapForDelete.get(deletedApp.RFA__c).putAll(rfaUserRoleRecordAccessForDelete);
                    } else
                    {
                        rfaUserRoleMapForDelete.put(deletedApp.RFA__c, rfaUserRoleRecordAccessForDelete);
                    }   
                }
                rfaUserRoleMapForDelete.put(deletedApp.RFA__c, rfaUserRoleRecordAccessForDelete);
            }
            
             if(!userRoleList.isEmpty())
            {
                workItemHelper.processWorkItemsAfterDelete(userRoleList, processIds);
            }
        
    }//end of if(trigger.isDelete && Trigger.isAfter);
    /*************************** DELETE BLOCK ENDS ******************************/
   
    if(!processIds.isEmpty()) {
    	system.debug('--------- processIds: ' + processIds);
    	workItemHelper.processWorkItems(processIds);
    }
    
    if(!rfaUserRoleMap.isEmpty())
    {
    	system.debug('--------- rfaUserRoleMap: ' + rfaUserRoleMap);        
        System.debug('\n map size ' + rfaUserRoleMap.size());
        shareUtil.rfaApproversShareInsert(rfaUserRoleMap);
         
    }
    //Added by Ashwani for FR1.54
    if(removeDuplicateFlag.size() > 0)
    {
    	system.debug('----- removeDuplicateFlag: ' + removeDuplicateFlag);
        RFA_ProcessDuplicateFlag obj = new RFA_ProcessDuplicateFlag();
        obj.ProcessDuplicateFlagAfterDelete(removeDuplicateFlag);
    
    }
    //End
    
    if(!rfaUserRoleMapForDelete.isEmpty())
    {
        System.debug('\n ***********************************Share deletion map ' + rfaUserRoleMapForDelete);
        shareUtil.rfaShareDeletion(rfaUserRoleMapForDelete, changedUserRole);    
    }
    
    //can't delete PPOC when only one is available
    if(Trigger.isBefore && Trigger.isDelete) {
    	for(RFAUserRole__c userrole : Trigger.old) {
    		if(userrole.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id) {
    			Integer ppocCount = [Select Count() from RFAUserRole__c 
    				where RFA__c =: userrole.RFA__c 
    					AND RecordTypeId =: approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id];
    			if(ppocCount <= 1) {
    				userrole.addError(
    					Label.RFA_ErrorMsg_PPOC
    					//'問い合わせ先削除できないです / Can\'t delete Primay Contact'
    					);
    			}
    		}
    	}
    	
    }
    
}//end of Trigger;