/*    
 *  Trigger          : RFA_RFATrigger
 *  Author           : Accenture
 *  Version History  : 2.0
 *  Creation         : 5/11/2012
 *  Assumptions      : N/A
 *  Description      : Trigger contains business logic to process RFA for its different Stages/level
 *
 * Updated by Jia Hu on 2013/10/25                                    
 */
trigger RFA_RFATrigger on RFA__c (
	before insert, after insert, 
	before update, after update, 
	before delete
	) { 	
		
    // Instantiating the Processor class
    RFA_AP05_RFATrigger rfaHelper = new RFA_AP05_RFATrigger(); 
    RFA_Ap02_Shareutil shareUtilCls = new rfa_Ap02_Shareutil();
    RFA_VFC04_CompletionOfRFA inst = new RFA_VFC04_CompletionOfRFA();
    
    //added By Jia Hu on 2013/11/30 processing COA rules
    RFATriggerHandler instRFAHandler = new RFATriggerHandler();
    
    // Map variable for Storing RFA Id and RFa profit Center during RFA Stage of "Return To Sender"
    //notify user and give Edit permission to Requester in After Update
    Map<String, String> rfaMapForReturnToSender = new Map<String, String>();    
           
    // If RFA.Initial Budget Year field updated 
    Set<Id> rfaIdsInitialBudgetYearChange = new Set<Id>();  
    
    // List of RFAs for update  / for processRFAProfitCenterShare method
    List<Rfa__c> rfaList = new List<RFA__c>();     
    
    //used for rfaAgingCalculation() method
    // List To store the RFA records for which the Level or Stage has been updated
    List<RFA__c> rfaLstLvlStsChange = New List<RFA__c>(); 
    // Map To store the old copy of RFA records for which the Level or Stage has been updated
    Map<Id, RFA__c> rfaLstLvlStsChangeOld = New Map<Id, RFA__c>(); 
    
    // Set to store the RFA records for which the Level has been updated
    // Notify Info Only
    Set<Id> rfaIdsLvlStsChange = New Set<Id>(); 
    
    //List of RFA Share Object / Return To Sender: add Edit permission for Requester
    List<RFA__Share> rfaShareForUpdateList = new List<RFA__Share>(); 
        
    //when leaving Draft or RTS, read only for requester,..
    // Set to store unique set of RFA Ids which has been changed from "Draft" OR "Return To Sender" Stage.
    Set<String> rfaIdsForSharingDeletion = new Set<String>(); 
    
    // Store RFAId, ProfitCenterID Old id / used for rfaProfitCenterUpdateDeleteOldProfitCenter() method
    Map<Id,Id> rfaShareDeleteLvl = new Map<Id, Id>(); 
   
    //used for processRFAProfitCenterShare() method 
    List<RFA__c> rfaListLvlChange = new List<RFA__c>();
    
    List<RFA__Share> rfaShareListFromRequester = new List<RFA__Share>();
     
	//removed by Jia Hu on 2013/12/01
    //public static Map<String, Map<String, RecordType>> RECORDTYPESMAP 
    //	= RFAGlobalConstants.RECORDTYPESMAP;
    //public static Map<String, RecordType> rfaRecordTypeMap 
    // 	= RECORDTYPESMAP.get(Schema.sObjectType.RFA__c.getName());
    
    /*
	if( !(trigger.new.size() > 1) )  can't use with before delete / before delete will call trigger.old
	get error: System.NullPointerException: Attempt to de-reference a null object
	*/ 
    if( trigger.new != null && !(trigger.new.size() > 1) ) 
    {       
    /************************************** BEFORE BLOCK STARTS ****************************************/        
        if(trigger.IsBefore)
        {
            /************************************ BEFORE INSERT BLOCK STARTS *****************************************/           
            if(trigger.IsInsert) 
            {           
            	//do not need this function by Jia Hu on 2013/01/15
            	/*
            	if(Label.RFA_Trigger_AutoNumber == '1') {
            		RFA__c lastRFA = [Select Id, Name from RFA__c order by Name Desc limit 1 ALL ROWS];
            		system.debug('----- Last RFA: ' + lastRFA.Name);
            		String strLastRFANo = lastRFA.Name.subString(5, 13); 
            		system.debug('----- RFA No. String : ' + strLastRFANo);
            		
            		integer intLastRFANo = Integer.valueOf(strLastRFANo);
            		system.debug('----- RFA No. Int: ' + intLastRFANo);
            		
            		//integer intNextRFANo = intLastRFANo + 1;
            		
            		
            		
            		for(RFA__c rfa : Trigger.new) {
            			rfa.Name = RFA_AP05_RFATrigger.getNextRFANo(intLastRFANo);
            			rfa.RFA_Unique_No__c = rfa.Name;
            			intLastRFANo++;
            		}
            		
            	}*/
            	
            	    
                for(RFA__c rfa : Trigger.new)
                {
                    rfa.ProfitCenterNumber__c = [
                        	Select Id, Name, ProfitCenterName__c from ProfitCenter__c 
                        	where ProfitCenterName__c =: RFAConstants.ProfitCenter_Name_CCEJ].Id;                                      
                    
                    rfa.FC_TaxRate__c = [
                    	Select Id, Name from Financial_Constant__c 
                    	where isActive__c = true 
                    		And RecordTypeId =: RFAConstants.getRecordType(
                    			RFAConstants.FinancialConstant_RT_TaxRate, 'Financial_Constant__c')
                    	Order By CreatedDate Desc limit 1].Id;

                    rfa.FC_WACC__c = [
                    	Select Id, Name from Financial_Constant__c 
                    	where isActive__c = true 
                    		And RecordTypeId =: RFAConstants.getRecordType(
                    			RFAConstants.FinancialConstant_RT_WACC, 'Financial_Constant__c')
                    	Order By CreatedDate Desc limit 1].Id;       
                    	
					                               
                }
                
                
                rfaHelper.processTravelAndEntertainmentRFAs(Trigger.New);
                
                instRFAHandler.addRFAApproversFromCOA(Trigger.New, true);  
                
                
            }//end of if(trigger.IsInsert)            
            /*********************************** BEFORE  INSERT BLOCK ENDS ********************************************/
          
            /*********************************** BEFORE UPDATE BLOCK STARTS ******************************************/
            if(trigger.isUpdate)
            {
                try{      
                	
                	rfaHelper.processTravelAndEntertainmentRFAs(Trigger.New, Trigger.oldMap);
                	
                  	for(RFA__c rfa: trigger.new)
                    {                                               
                        // Check whether Level/ Stage has been Updated
                        if(rfa.Stage__c != trigger.oldmap.get(rfa.id).Stage__c 
                        ) {                            
                            // Create a list of the updated RFA if the Stage or Level of the RFA is Updated
                            rfaLstLvlStsChange.add(rfa); // Current Values
                            rfaLstLvlStsChangeOld.put(rfa.Id, trigger.oldmap.get(rfa.Id));  // Old Values    
                            
                            //added by Jia Hu on 2014/02/06
                            //only handle Manual Sharing reason by users
                            String ByRequesterRowCause = Schema.RFA__Share.RowCause.By_Requester__c;
                    
                    		Set<Id> GroupIds = new Set<Id>();
                    		Set<Id> PublicGroupIds = new Set<Id>();
                    		Set<Id> PrivateGroupIds = new Set<Id>();
                    		
                    		/*
                    		List<RFA__Share> updateShareAccessLevel = new List<RFA__Share>();                   		
                    		for(RFA__Share shareRec : [
                    			Select ParentId, RowCause, AccessLevel, UserOrGroupId 
                    			From RFA__Share 
                    			where ParentId =: rfa.Id And RowCause != 'Manual' And RowCause != 'Owner']) {
                    		
                    			if(shareRec.AccessLevel == 'Edit') {
                    				shareRec.AccessLevel = 'Read';
                    				updateShareAccessLevel.add(shareRec);
                    			}		
                    		                    		                    		
                    		} //end of for();                    		
                    		if(updateShareAccessLevel != null && updateShareAccessLevel.size() > 0) {
                    			update updateShareAccessLevel;
                    		}  */
                		
                    		
                    		// iterate over RFA share records
                    		for(RFA__Share shareRec : [
                    			Select ParentId, RowCause, AccessLevel, UserOrGroupId 
                    			From RFA__Share 
                    			where ParentId =: rfa.Id And RowCause = 'Manual'])
                    		{
                    			if(!String.valueOf(shareRec.UserOrGroupId).startsWith('00G')) {
                    				system.debug('------- UserOrGroupId: ' + shareRec.UserOrGroupId);
                    				system.debug('------- RowCause: ' + shareRec.RowCause);
                    				system.debug('------- AccessLevel: ' + shareRec.AccessLevel);
                    				RFA__Share rfaShare = new RFA__Share();
                    				rfaShare.ParentId = shareRec.ParentId;
                    				rfaShare.UserOrGroupId = shareRec.UserOrGroupId;
                        			// assign edit permission
                        			rfaShare.AccessLevel = 'Read';
                        			rfaShare.RowCause = ByRequesterRowCause;
                        			// add to list for bulk update
                        			rfaShareListFromRequester.add(rfaShare);
                    			} else {
                    				GroupIds.add(shareRec.UserOrGroupId);
                    			}
                    		}//end of for(); save Manual sharing for single users  
                    		
                    		//remove Personal Group                    		
                    		for(Group aGroup : [Select Id from Group where Id IN: GroupIds]) {
                    			PublicGroupIds.add(aGroup.Id);
                    		}
                    		
                    		
                    		//add Public Group manual sharing
                    		for(RFA__Share shareRec : [
                    			Select ParentId, RowCause, AccessLevel, UserOrGroupId 
                    			From RFA__Share 
                    			where ParentId =: rfa.Id And UserOrGroupId IN: PublicGroupIds])
                    		{
                    			system.debug('------- UserOrGroupId: ' + shareRec.UserOrGroupId);
                    			RFA__Share rfaShare = new RFA__Share();
                    			rfaShare.ParentId = shareRec.ParentId;
                    			rfaShare.UserOrGroupId = shareRec.UserOrGroupId;
                        		// assign edit permission
                        		rfaShare.AccessLevel = 'Read';
                        		rfaShare.RowCause = ByRequesterRowCause;
                        		// add to list for bulk update
                        		rfaShareListFromRequester.add(rfaShare);
                    		}//end of for(); save Manual sharing for single users  
                    		
                    		system.debug('-------- GroupIds: ' + GroupIds);
                    		system.debug('-------- PublicGroupIds: ' + PublicGroupIds);
                    		Boolean ifRemoveAll = GroupIds.removeAll(PublicGroupIds);
                    		system.debug('-------- boolean: ' + ifRemoveAll);
                    		if(GroupIds != null && GroupIds.size() > 0) {
                    			
                    			List<RFA__Share> rfaSharePrivateGroup = new List<RFA__Share>();
                    			
                    			for(RFA__Share shareRec : [
                    				Select ParentId, RowCause, AccessLevel, UserOrGroupId 
                    				From RFA__Share 
                    				where ParentId =: rfa.Id And UserOrGroupId IN: GroupIds])
                    			{
                    				system.debug('------- UserOrGroupId: ' + shareRec.UserOrGroupId);
                    				
                    				RFA__Share rfaShare = new RFA__Share();
                    				rfaShare.ParentId = shareRec.ParentId;
                    				rfaShare.UserOrGroupId = shareRec.UserOrGroupId;
                        			rfaShare.AccessLevel = 'Read';
                        			rfaShare.RowCause = ByRequesterRowCause;                    				
                    				rfaSharePrivateGroup.add(rfaShare);
                    			
                    				//if(shareRec.AccessLevel == 'Edit') {
                    				//	shareRec.AccessLevel = 'Read';
                    				//}                    			
                    				//shareRec.RowCause = ByRequesterRowCause;                   			
                        			//rfaSharePrivateGroup.add(shareRec);
                        			
                    			}//end of for();                     			
                    			
                    			if(rfaSharePrivateGroup != null && rfaSharePrivateGroup.size() > 0) {
                    				//get Field is not writeable: RFA__Share.RowCause error
                    				//update rfaSharePrivateGroup;
                    				insert rfaSharePrivateGroup;
                    			}
                    			
                    			
                    		}
                    		    
                            
                            if(rfa.Stage__c == RFAConstants.RFA_STATUS_CIRCULATION && rfa.OwnerId != Label.RFA_System) {
                            	rfa.OwnerId = Label.RFA_System;
                            }
                                                                    
                        } 
                                               
                        //RFA approval process finished / need post-process, like email,...
                        if(
                        	(      rfa.Stage__c == RFAConstants.RFA_STATUS_CLOSED
                        		|| rfa.Stage__c == RFAConstants.RFA_STATUS_APPROVED
                        		|| rfa.Stage__c == RFAConstants.RFA_STATUS_REJECTED
                        	) 
                        	&& 
                        	Trigger.oldMap.get(rfa.Id).Stage__c <> rfa.Stage__c)
                        {
                            rfa.CompletionDate__c = System.now();
                            
                         //added by Jia Hu on 2013/12/03
                        //RFA_VFC04_CompletionOfRFA inst = new RFA_VFC04_CompletionOfRFA();
                        
                        system.debug('--------- In RFA Trigger: Stage: ' + rfa.Stage__c);
                        
                        if(RFA_AP05_RFATrigger.emailAtComplete) {
                        	
                        if(rfa.Stage__c == RFAConstants.RFA_STATUS_APPROVED) {
							inst.sendEmail_CompleteMemo(rfa);
							RFA_AP05_RFATrigger.emailAtComplete = false;
                        } else if(rfa.Stage__c == RFAConstants.RFA_STATUS_REJECTED) {
							inst.sendEmail_CompleteMemo(rfa); 
							RFA_AP05_RFATrigger.emailAtComplete = false;
                        } else if(rfa.Stage__c == RFAConstants.RFA_STATUS_CLOSED) {
                        	
							if(Trigger.oldMap.get(rfa.Id).Stage__c == RFAConstants.RFA_STATUS_DRAFT) {
								//To: Requester, PPOC
                        		inst.sendEmail_CloseRFA(rfa, true);
							} else if(Trigger.oldMap.get(rfa.Id).Stage__c == RFAConstants.RFA_STATUS_ReturnToRequester) {
								//To: Requester, PPOC, Info Copy Only, Approver & Agent
								inst.sendEmail_CloseRFA(rfa, false);
							}
							RFA_AP05_RFATrigger.emailAtComplete = false;
                        }                         
                        }        
                            
                            
                        }//end of if(RFA_STATUS_CLOSED / RFA_STATUS_APPROVED / RFA_STATUS_REJECTED);
                        
						//class RFA_AP05_RFATrigger
                        //rfaHelper.captureEmailTempValues(rfa, levelMap);
                        //stopped by Jia Hu on 2013/12/17
                        //rfaHelper.captureEmailTempValues(rfa);
                        
                        /*****************************Level Stage Update logic Ends here***************************/
                                               
                        //********************* VALIDATION CHECK ***************************************//
                        //@ before update trigger  /  insert trigger don't check validation of RFA
                        // updated by Jia Hu  Draft/Return To Sender can close RFA without validation
                        if(rfa.Stage__c != 
                        	RFAConstants.RFA_STATUS_CLOSED
                        ) {
                        	Set<String> errorSet = RFA_AP05_RFATrigger.validateRFA(rfa, Trigger.oldMap.get(rfa.Id));
                        	
                        	if(!errorSet.isEmpty()) {
                        		//added by Jia Hu on 2014/01/07
                        		//processing error message
                        		integer index = 1;
                        		for(String str : errorSet) {
                        			//Trigger.new[0].addError( index + '. ' + str );
                        			Trigger.new[0].addError( str );
                        			index++;
                        		}
                        		
                        		
                        		throw new RFA_AP19_RFAValidationException(errorSet);                        		                       		
                        	}
                        }                                              
                    
                    }//end of for(RFA__c rfa: trigger.new)   
                }//end of try
                catch(RFA_AP19_RFAValidationException validationEx)
                {
                    //rfa.addError(validationEx);
                    
                    //Trigger.new[0].addError(validationEx.getSerializedErrMsg());
                    
                    //Trigger.new[0].addError('error 1');
                   	system.debug('validationEx.getMessage()+++ ' + validationEx.getMessage());
                   	//Trigger.new[0].addError(validationEx.getMessage());
                }
                
                //RFA_AP05_RFATrigger.rfaAgingCalculation
                if(!rfaLstLvlStsChange.isEmpty() && !rfaLstLvlStsChangeOld.isEmpty())
                	//Calcuate time spent in each stage
                    rfaHelper.rfaAgingCalculation(rfaLstLvlStsChange, rfaLstLvlStsChangeOld);   
           
                // calling Delete Function for capitalExpenditure ??              
            }//end of if(trigger.isUpdate)    
                    
            /************************************* BEFORE UPDATE BLOCK ENDS *******************************************/

             // Clear All List
                rfaList.clear();
                rfaIdsInitialBudgetYearChange.clear();
                rfaLstLvlStsChange.clear();
                rfaShareForUpdateList.clear();
                rfaLstLvlStsChangeOld.clear();
                
            
        }//end of if(trigger.IsBefore)        
    /****************************************** BEFORE BLOCK ENDS **********************************************/

    
    /****************************************** AFTER BLOCK STARTS *********************************************/    
        if(trigger.IsAfter)
        {  
            /********************************** AFTER INSERT BLOCK STARTS ****************************************/              
            if(trigger.IsInsert) //after insert
            {
            	//RFA_AP05_RFATrigger rfaHelper
            	//insert ThreeYearCashSpend__c
                rfaHelper.processRFAAfterInsert(Trigger.new);
                //insert Capital_Expenditure__c>
                rfaHelper.processRFAAfterInsertForCapitalExpenditure(Trigger.new);
                //
                rfaHelper.processRFAOwnerShare(Trigger.New);
                
                //set up Profit Center sharing
                rfaHelper.processRFAProfitCenterShare(Trigger.New);                
                
                //added by Jia Hu on 2013/11/29
                //need to check the share permission for each approver added??!!
                instRFAHandler.addRFAApproversFromCOA(Trigger.New, false);
                
                instRFAHandler.addDefaultPPOC(Trigger.New);
                
            }//end of if(trigger.IsInsert)            
            /********************************** AFTER INSERT BLOCK ENDS *****************************************/
            
            /********************************** AFTER UPDATE BLOCK STARTS ***************************************/        
            if (trigger.IsUpdate) //after update
            {              
                for(Rfa__c rfa: Trigger.New)
                {
                    // *********************** RFA level has changed ***********************/
                    // Populate rfaSetLvlChange & process info only notification.
                    if(//updated by Jia Hu on 2013/11/30
                    	rfa.Stage__c != trigger.oldmap.get(rfa.id).Stage__c
                    	)
                    {
                        rfaIdsLvlStsChange.add(rfa.Id);
                    }
                                                          
                    // *********************** Stage EQUALS : "Closed" OR "Approved" OR "Rejected"************/
                    // generate PDF after RFA Stage is "Closed" or "Approved" Or "Rejected"
                    if(
                    	(
                    	rfa.Stage__c == RFAConstants.RFA_STATUS_CLOSED
                    	|| rfa.Stage__c == RFAConstants.RFA_STATUS_APPROVED
                    	|| rfa.Stage__c == RFAConstants.RFA_STATUS_REJECTED
                        ) 
                    	&& trigger.new.Size() == 1 
                    	&& rfa.Stage__c <> Trigger.oldMap.get(rfa.Id).Stage__c
                      )
                    {   /* 2013/10/23 by Jia Hu
                         * PDF file will be added to Attachment of RFA record; Refreshing page to see the Attachment added;
                         * Not working for Rejected stage?
                         * Two RFA_STAGE_CLOSED conditions in the if(), change one to RFA_STAGE_REJECTED
                         */
                        //stopped by Jia Hu on 2013/11/22
                        //need to confirm the format 
                        //RFA_WS01_PDFGenerator.PDFGenerator(rfa.Id,UserInfo.getSessionId());  
                        
                        //using VF page: RFA_VFP04_CM_DetailsAsPDF   
                        if(RFA_AP05_RFATrigger.createPDF) {
                        	RFA_WS04_PDFGeneratorCM.PDFGenerator(rfa.Id, UserInfo.getSessionId());  
                        	RFA_AP05_RFATrigger.createPDF = false;
                        }
                        
                        //added by Jia Hu on 2013/12/03
                        /*
                        RFA_VFC04_CompletionOfRFA inst = new RFA_VFC04_CompletionOfRFA();
                        
                        system.debug('--------- In RFA Trigger: Stage: ' + rfa.Stage__c);
                        
                        if(rfa.Stage__c == RFAConstants.RFA_STATUS_APPROVED) {
							inst.sendEmail_CompleteMemo(rfa);
                        } else if(rfa.Stage__c == RFAConstants.RFA_STATUS_REJECTED) {
							inst.sendEmail_CompleteMemo(rfa); 
                        } else if(rfa.Stage__c == RFAConstants.RFA_STATUS_CLOSED) {
                        	
							if(Trigger.oldMap.get(rfa.Id).Stage__c == RFAConstants.RFA_STATUS_DRAFT) {
                        	inst.sendEmail_CloseRFA(rfa, true);
							} else if(Trigger.oldMap.get(rfa.Id).Stage__c == RFAConstants.RFA_STATUS_ReturnToRequester) {
								inst.sendEmail_CloseRFA(rfa, false);
							}
                        }  */
                        
                                  
                    }                    
                    
                    // *********************** RFA level has changed to RETURN to SENDER or Capital Hold***********************/
                    // Populate rfaList & recalculate share permission for all location coordinator .
                    if(//replaced by Jia Hu on 2013/11/30
                    	rfa.Stage__c == RFAConstants.RFA_STATUS_ReturnToRequester
                    	&& RFA_AP05_RFATrigger.emailAtRTR
                    )
                    {
                        rfaShareDeleteLvl.put(rfa.Id, Trigger.oldmap.get(rfa.id).profitCenterNumber__c);
                        rfaListLvlChange.add(rfa);  
                        
                        //RFA_VFC04_CompletionOfRFA inst = new RFA_VFC04_CompletionOfRFA();
                        if(rfa.Stage__c <> Trigger.oldMap.get(rfa.Id).Stage__c) {
                        	inst.sendEmail_ReturnToRequester(rfa);            
                        	RFA_AP05_RFATrigger.emailAtRTR = false;      
                        }
                    } 
                    
                    if(rfa.Stage__c == RFAConstants.RFA_STATUS_CIRCULATION && RFA_AP05_RFATrigger.emailAtCirculation
                    	//&&
                    	//Trigger.oldMap.get(rfa.Id).Stage__c == RFAConstants.RFA_STATUS_ReturnToRequester
                    ) {
                    	//RFA_VFC04_CompletionOfRFA inst = new RFA_VFC04_CompletionOfRFA();                   
                    	
                    	if(Trigger.oldMap.get(rfa.Id).Stage__c == RFAConstants.RFA_STATUS_DRAFT) {
                    		//To: Requester, PPOC, Info Copy Only
                    		inst.sendEmail_EnterCirculation_ReqPPOC(rfa);
                    		RFA_AP05_RFATrigger.emailAtCirculation = false;
                    	}
                    	if(Trigger.oldMap.get(rfa.Id).Stage__c == RFAConstants.RFA_STATUS_ReturnToRequester) {
                    		//To: Requester, PPOC, Info Only Copy
                    		inst.sendEmail_ResumeFromRTR(rfa);
                    		RFA_AP05_RFATrigger.emailAtCirculation = false;
                    	}
                    }                                                         
                   
                    //************************ Stage EQUALS: "Return To Sender" ******************************/
                    // Notify Local Coordinator of RFA current level once the RFA is returned to Sender
                    // Commented by Ashwani for Additional FR related for FR1.54                  
                    if(
                     	rfa.Stage__c == RFAConstants.RFA_STATUS_ReturnToRequester
                        &&
                        rfa.Stage__c <> Trigger.oldMap.get(rfa.Id).Stage__c
                     	&& 
                     	RFA_AP05_RFATrigger.isFirstRun
                     )
                    {                    
                        if(rfa.ProfitCenterNumber__c <> null) {
                        	rfaMapForReturnToSender.put(rfa.Id, rfa.ProfitCenterNumber__c); 
                        } 
                        
                        //removed by Jia Hu 2013/11/07
                        //if(rfa.PreviousLevel__c <> null)levelMap.put(rfa.Id, rfa.PreviousLevel__c); 
                    }  
                                      
                    //updated by Jia Hu on 2013/12/01  only reset for requester?
                    //*********************** Stage Change: Leaving "Draft" OR "Return To Sender" *******************/
                    // Reset the accesslevel for KOrequester, Co-Creator or Primary point of contact to "Read" Access once the RFA Stage is 
                    // no longer "Draft" OR "Return To Sender"
                    if(
                    	(
                    	rfa.Stage__c <> Trigger.oldMap.get(rfa.Id).Stage__c 
                    	&& Trigger.oldMap.get(rfa.Id).Stage__c == RFAConstants.RFA_STATUS_DRAFT
                        )
                     	|| 
                     	(
                     	Trigger.oldMap.get(rfa.Id).Stage__c == RFAConstants.RFA_STATUS_ReturnToRequester
                     	&& rfa.Stage__c <> Trigger.oldMap.get(rfa.Id).Stage__c 
                     	)
                     )
                    {
                        rfaIdsForSharingDeletion.add(rfa.Id);   
                    }
                    
                                      
                    // ********************** RFA Initial Budget Year field value has been changed ********************/
                    // Populate rfaIdsInitialBudgetYearChange List if the RFA Initial Budget Year field value has been changed and not null
                    if(rfa.InitialBudgetYear__c != trigger.OldMap.get(rfa.Id).InitialBudgetYear__c 
                    	&& rfa.InitialBudgetYear__c <> null)
                    {
                        rfaIdsInitialBudgetYearChange.add(rfa.id);
                    }
                    
                 }//end of for(Rfa__c rfa: Trigger.New);
                 
                 // evaluate if info only users should receive notification
                 if(rfaIdsLvlStsChange.size() > 0)
                 {
                    rfaHelper.processInfoOnlyNotificationFlag(rfaIdsLvlStsChange, trigger.oldMap);
                 }
                 
                 // update RFA Three Year Cash Spend related records after the RFA Initial Budget Year field is changed and not null
                 if(rfaIdsInitialBudgetYearChange.size() > 0)
                 {
                    rfaHelper.rfaThreeYearCashSpendUpdate(rfaIdsInitialBudgetYearChange);
                 }
                               
                
                 //need to check ??!!
                 // Process RFA Share after update / set up profit center when Stage changed
                 if(rfaList.size() > 0)
                 {  //calling shareUtilCls.profitCenterAtRfaCreateShare
                    rfaHelper.processRFAProfitCenterShare(rfaList);
                 } 
                 
                 if(!rfaShareDeleteLvl.IsEmpty())
                 {
                    shareUtilCls.rfaProfitCenterUpdateDeleteOldProfitCenter(rfaShareDeleteLvl);                
                 }
                 
                 if(!rfaListLvlChange.IsEmpty())
                 {
                    rfaHelper.processRFAProfitCenterShare(rfaListLvlChange);  
                 }
                                                   
                 if(!rfaIdsForSharingDeletion.isEmpty())
                 {//set Read Only for Requester
                    rfaHelper.restrictAccessForKORequester(rfaIdsForSharingDeletion);       
                 }              
                 
                 // Notify Local coordinator when the RFA Stage is "Return to Sender"
                 // Give edit permission to users with RowCause "KORequester__c"
                 // impact on sharing permission and approval process
                 if(!rfaMapForReturnToSender.isEmpty())
                 {                    
                    // Notify Associated Co-creator and Primary Point of contact
                    rfaHelper.notifyRelatedUsers(rfaMapForReturnToSender.keySet()); 
                    
                    // rowcause for KO requester
                    String koRequestRowCause = Schema.RFA__Share.RowCause.KORequestor__c;
                    
                    // iterate over RFA share records
                    for(RFA__Share shareRec : [
                    	Select ParentId, RowCause, AccessLevel 
                    	From RFA__Share 
                    	where ParentId IN: rfaMapForReturnToSender.keySet() AND rowcause = : koRequestRowCause])
                    {
                        // assign edit permission
                        shareRec.AccessLevel = 'Edit';
                        // add to list for bulk update
                        rfaShareForUpdateList.add(shareRec);
                    }
                    // Close in progress Approval provesses
                    Map<Id, ApprovalProcess__c> approvalProcessMap = 
                    	RFA_AP03_ApprovalProcessHelper.getActiveProcessInstances(rfaMapForReturnToSender.keySet()); 
                    // reset Approval Workitems after the approval process is closed.   
                    if(!approvalProcessMap.isEmpty()) {RFA_AP03_ApprovalProcessHelper.resetApprovalWorkItems(approvalProcessMap);}                
                     
                    if(!rfaShareForUpdateList.isEmpty()) {update rfaShareForUpdateList;}
                                    
                    // flag variable to false to prevent second run
                    RFA_AP05_RFATrigger.isFirstRun = false;
                 }
               
            }//end of if (trigger.IsUpdate)
            /******************************* AFTER UPDATE BLOCK ENDS *************************************/
            
             // Clear All List (Cache)
                rfaList.clear();
                rfaIdsInitialBudgetYearChange.clear();
                rfaLstLvlStsChange.clear();
                rfaShareForUpdateList.clear();              
       }//end of if(trigger.IsAfter)
    /**************************************** AFTER BLOCK ENDS ************************************/
    
    } //if( !(trigger.new.size() > 1) )

	/*
		added by Jia Hu on 2013/12/01
	*/
	if(Trigger.isBefore && Trigger.isUpdate) {
		for(RFA__c rfa : Trigger.New) {
			if(rfa.RecordTypeId != trigger.OldMap.get(rfa.Id).RecordTypeId) {
				rfa.addError('レコードタイプ変更できないです! / Can\'t change Record Type!');
			}
		}
	}
	
	/*
		added by Jia Hu on 2013/11/28
		RFA record delete control
		0 - can't be deleted by anyone
		1 - can be deleted only by System Administrator
		2 - can be deleted by anyone
	*/	
	if(Trigger.isBefore && Trigger.isDelete) {
		for(RFA__c rfa : Trigger.old) {
			if(LABEL.RFA_Delete_Flag == '0') {
				rfa.addError('レコードは削除できないです! / You can\'t delete this record!');
			} else if(LABEL.RFA_Delete_Flag == '1') {
				String strProfileName = [Select Id, Name from Profile where Id =: UserInfo.getProfileId()].Name;
				system.debug('------ Profile Name: ' + strProfileName);
				if( !(strProfileName == RFAConstants.SysAdminProfile
						//'System Administrator' 
						|| 
						strProfileName == RFAConstants.SysAdminJPProfile
						//'システム管理者'
						) ) {
					rfa.addError('レコードは削除できないです! / You can\'t delete this record! ');
				}
			}
		}
	}
	
	//added by Jia Hu on 2014/02/06 rebuit Manual Sharing of Requester when Owner changed to RFA System
	if(rfaShareListFromRequester != null && rfaShareListFromRequester.size() > 0 ) {
		insert rfaShareListFromRequester;
	}
	

}