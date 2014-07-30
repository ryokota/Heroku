/*
 *  Class            : RFATriggerHandler
 *  Author           : Pasona Tquila
 *  Version History  : 1.0
 *  Creation         : 2013/11/29
 *  Created by       : Jia Hu
 *  Called by        : RFA_RFATrigger on RFA__c
 */
public class RFATriggerHandler {
	
	List<RFAUserRole__c> listRFAApproverToInsert = new List<RFAUserRole__c>();
	
	//these two lists are mapping to each RFA record
	//since only one cost center is available, all COA rules for one RFA record should have same function
	//Map<String, String> FunctionToGroup = new Map<String, String>();
	//List<String> GroupNoList = new List<String>();
	
	Set<String> Group2To4List = new Set<String>();
	Set<String> Group5List = new Set<String>();
	List<String> AcronymList = new List<String>();
	List<String> ELTList = new List<String>();
	Set<String> InfoCopyList = new Set<String>();
	
	Id smallRTId = RFAConstants.getRecordType(RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST, 'RFA__c'); 		
    //Id smallRTId = RFAConstants.getRecordType(RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST_LessThan25MM, 'RFA__c'); 
	//Id mediumRTId = RFAConstants.getRecordType(RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST_A, 'RFA__c'); 
	Id mediumRTId = RFAConstants.getRecordType(RFAConstants.RECORDTYPE_Medium_PROJECT_REQUEST, 'RFA__c'); 
    Id capitalRTId = RFAConstants.getRecordType(RFAConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST, 'RFA__c'); 
    
	Id travelRTId = RFAConstants.getRecordType(RFAConstants.RECORDTYPE_Travel_Expenses_REQUEST, 'RFA__c'); 
    Id entertainmentRTId = RFAConstants.getRecordType(RFAConstants.RECORDTYPE_Entertainment_REQUEST, 'RFA__c');     		
	
	Map<String, String> Gr1FunctionToAcronym = new Map<String, String>{
		'Commercial' => 'CCO', 
		'Supply Chain' => 'CSCO',
		'Finance' => 'CFO', 
		'HR' => 'CHRO', 
		'Procurement' => 'CPO', 
		'IT' => 'CITO', 
		'BI' => 'CBIO', 
		'PAC' => 'CPACO', 
		'Legal' => 'CLO'
	}; //CEO

	List<String> Gr1AcronymList = new String[]{'CCO', 'CSCO', 'CFO', 'CHRO', 'CPO', 'CITO', 'CBIO', 'CPACO', 'CLO', 'CEO'};
		
	/*
		BOD: Board of Directors / processing in RFA Trigger before insert 
		add RFA approvers based on COA rules
		called by RFA_RFATrigger: after insert
	*/
	public void addRFAApproversFromCOA(List<RFA__c> rfaList, Boolean isBOD) {		
				
		//first level: process by each RFA record
		for(RFA__c rfa : rfaList) {
			//second level: process by each COA Category Set
			//Primary COA Category  &  Second COA Category  &  Third COA Category
			if(rfa.PrimaryCOACategory__c != null && rfa.SecondCOACategory__c == null && rfa.ThirdCOACategory__c == null) {
				system.debug('----- PrimaryCOACategory__c: ' + rfa.PrimaryCOACategory__c );
				
				//thrid level: process by each COA sub category
				processPrimaryCOACategory(rfa, isBOD);
														
				
			} //end of if(rfa.PrimaryCOACategory__c != null && rfa.SecondCOACategory__c == null && rfa.ThirdCOACategory__c == null);
			else if(rfa.PrimaryCOACategory__c != null && rfa.SecondCOACategory__c != null && rfa.ThirdCOACategory__c == null) {
				system.debug('----- PrimaryCOACategory__c: ' + rfa.PrimaryCOACategory__c + ' SecondCOACategory__c: ' + rfa.SecondCOACategory__c);
				
				processPrimaryCOACategory(rfa, isBOD);
				processSecondCOACategory(rfa, isBOD);
				
			} 
			else if(rfa.PrimaryCOACategory__c != null && rfa.SecondCOACategory__c == null && rfa.ThirdCOACategory__c != null) {
				system.debug('----- PrimaryCOACategory__c: ' + rfa.PrimaryCOACategory__c + ' SecondCOACategory__c: ' + rfa.SecondCOACategory__c
					+ ' ThirdCOACategory__c: ' + rfa.ThirdCOACategory__c);
				
				processPrimaryCOACategory(rfa, isBOD);	
				processThirdCOACategory(rfa, isBOD);
					
			} 
			else if(rfa.PrimaryCOACategory__c != null && rfa.SecondCOACategory__c != null && rfa.ThirdCOACategory__c != null) {
				system.debug('----- PrimaryCOACategory__c: ' + rfa.PrimaryCOACategory__c + ' SecondCOACategory__c: ' + rfa.SecondCOACategory__c
					+ ' ThirdCOACategory__c: ' + rfa.ThirdCOACategory__c);
				
				processPrimaryCOACategory(rfa, isBOD);	
				processSecondCOACategory(rfa, isBOD);
				processThirdCOACategory(rfa, isBOD);
			
			
			}//end of Second Level process: if-else (Primary COA Category  &  Second COA Category  &  Third COA Category);
			
			//*************************************************************				
			//STEP 2
			//query user object based on the approver selected from COA
			//*************************************************************	
			
			if(!isBOD) {//not process BOD
				
				Integer appprover_order = 1;
				
				Id approverRTId 
					= RFAConstants.getRecordType(
						RFAConstants.RTLabel_RFAUserRole_Approver, 
						RFAConstants.Obj_RFAUserRole_APIName
				);
			
				Id infoOnlyRTId 
					= RFAConstants.getRecordType(
						RFAConstants.RTLabel_RFAUserRole_InfoOnly, 
						RFAConstants.Obj_RFAUserRole_APIName
				);			
			
				User me = [Select Id, Username, ManagerId, CokeOne_Manager__c,
					COA_Group__c, COA_Acronym__c, L_level__c,
					L2_Function_E__c, L3_Function_E__c, L4_Function_E__c, Location_E__c
					from User where Id =: Userinfo.getUserId()];	
				
				List<User> groupCandidateList = new List<User>();	
				
				system.debug('------ Group2To4List: ' + Group2To4List);	
				system.debug('------ Group5List:    ' + Group5List);	
				system.debug('------ AcronymList:   ' + AcronymList);
				
				//if( (rfa.RecordTypeId == travelRTId || rfa.RecordTypeId == entertainmentRTId) && rfa.Cost_Center_Function__c == 'CokeOne') {
				//CokeOne can use COA_Function__c field to Stand for Function 2
				if(Group2To4List != null && Group2To4List.size() > 0 && rfa.Cost_Center_Function__c == 'CokeOne' ) {
					groupCandidateList = [
						Select Id, Username, COA_Group__c, COA_Acronym__c, L_level__c,
								L2_Function_E__c, L3_Function_E__c, L4_Function_E__c, Location_E__c,
								COA_Function__c
						from User 
						where 
							COA_Group__c IN: Group2To4List 
							AND COA_Function__c = 'CokeOne'
							order by COA_Group__c desc
					];	
				} 		
				
				system.debug('---------- groupCandidateList for CokeOne: ' + groupCandidateList);		
				
				
				//if( (rfa.RecordTypeId == travelRTId || rfa.RecordTypeId == entertainmentRTId) && rfa.Cost_Center_Function__c == 'CokeOne') {
				if(Group2To4List != null && Group2To4List.size() > 0 && rfa.Cost_Center_Function__c != 'CokeOne' ) {
					if(me.L_level__c == 'L3') {
						system.debug('--------- me.L_level__c == L3');
						groupCandidateList = [
							Select Id, Username, COA_Group__c, COA_Acronym__c, L_level__c,
								L2_Function_E__c, L3_Function_E__c, L4_Function_E__c, Location_E__c
							from User 
							where 
								COA_Group__c IN: Group2To4List 
								AND L2_Function_E__c =: me.L2_Function_E__c
								AND L3_Function_E__c =: me.L3_Function_E__c
								AND L2_Function_E__c != null
								order by COA_Group__c desc
							];	
					} else if(me.L_level__c != null && me.L_level__c != 'L1' && me.L_level__c != 'L2' && me.L_level__c != 'L3') {
						system.debug('--------- me.L_level__c != L1 / L2 / L3');
						for(User auser: [
							Select Id, Username, COA_Group__c, COA_Acronym__c, L_level__c, 
								L2_Function_E__c, L3_Function_E__c, L4_Function_E__c, Location_E__c
							from User 
							where 
								COA_Group__c IN: Group2To4List 
								AND L2_Function_E__c =: me.L2_Function_E__c
								AND L3_Function_E__c =: me.L3_Function_E__c
								AND L2_Function_E__c != null
								order by COA_Group__c desc
							]) {
								if(auser.L_level__c == 'L3') {
									groupCandidateList.add(auser);
								} else if(auser.L_level__c != null && auser.L_level__c != 'L1' && auser.L_level__c != 'L2' && auser.L_level__c != 'L3') {
									if(me.L4_Function_E__c == auser.L4_Function_E__c) {
										groupCandidateList.add(auser);	
									}
								}
							}												
					}
					
					system.debug('---------- groupCandidateList for Non CokeOne: ' + groupCandidateList);
					
					
				
					
					
					/*
					if(me.L4_Function_E__c != null) {
						groupCandidateList = [
							Select Id, Username, COA_Group__c, COA_Acronym__c, 
								L2_Function_E__c, L3_Function_E__c, L4_Function_E__c, Location_E__c
							from User 
							where 
								COA_Group__c IN: Group2To4List 
								AND L2_Function_E__c =: me.L2_Function_E__c
								AND L3_Function_E__c =: me.L3_Function_E__c
								And L4_Function_E__c =: me.L4_Function_E__c
								order by COA_Group__c desc
							];			
					} else if(me.L3_Function_E__c != null) {
						groupCandidateList = [
							Select Id, Username, COA_Group__c, COA_Acronym__c, 
								L2_Function_E__c, L3_Function_E__c, L4_Function_E__c, Location_E__c
							from User 
							where 
								COA_Group__c IN: Group2To4List 
								AND L2_Function_E__c =: me.L2_Function_E__c
								AND L3_Function_E__c =: me.L3_Function_E__c
								order by COA_Group__c desc
							];								
					}	*/																
							
				}
				
				if(Group5List != null && Group5List.size() > 0) {
					List<User> group5CandidateList = new List<User>();	
					if(me.L4_Function_E__c != null) {
						group5CandidateList = [
							Select Id, Username, COA_Group__c, COA_Acronym__c, 
								L2_Function_E__c, L3_Function_E__c, L4_Function_E__c, Location_E__c
							from User 
							where 
								COA_Group__c IN: Group5List 
								AND L2_Function_E__c =: me.L2_Function_E__c
								AND L3_Function_E__c =: me.L3_Function_E__c
								And L4_Function_E__c =: me.L4_Function_E__c
								And Location_E__c =: me.Location_E__c
								order by COA_Group__c desc
							];	
							
						if(group5CandidateList != null && group5CandidateList.size() > 0) {
							groupCandidateList.addAll(group5CandidateList);
						}
									
					} else if(me.L3_Function_E__c != null) {
						group5CandidateList = [
							Select Id, Username, COA_Group__c, COA_Acronym__c, 
								L2_Function_E__c, L3_Function_E__c, L4_Function_E__c, Location_E__c
							from User 
							where 
								COA_Group__c IN: Group5List 
								AND L2_Function_E__c =: me.L2_Function_E__c
								AND L3_Function_E__c =: me.L3_Function_E__c
								And Location_E__c =: me.Location_E__c
								order by COA_Group__c desc
							];	
							
						if(group5CandidateList != null && group5CandidateList.size() > 0) {
							groupCandidateList.addAll(group5CandidateList);
						}								
					}				
				}				
				
				/*
				List<User> groupCandidateList = [
						Select Id, Username, COA_Group__c, COA_Acronym__c, COA_Function__c 
						from User 
						//where 
						//COA_Group__c IN: GroupNoList AND  COA_Function__c =: rfa.Cost_Center_Function__c
						order by COA_Group__c desc
						];	*/					
						
				//system.debug('-------- CandidateList: ' + groupCandidateList + ' GroupNoList: ' + GroupNoList + ' AcronymList: ' + AcronymList);	
			
			system.debug('-------- ELTList: ' + ELTList);
			List<User> eltCandidateList = new List<User>();
			Set<Id> existingApproverIds = new Set<Id>();	
			
			existingApproverIds.add(rfa.CreatedById);
			
			if(ELTList != null && ELTList.size() > 0) {
				eltCandidateList = [
							Select Id, Username, COA_Group__c, COA_Acronym__c, 
								L2_Function_E__c, L3_Function_E__c, L4_Function_E__c, Location_E__c
							from User 
							where 
								COA_Acronym__c IN: ELTList And Id NOT IN: existingApproverIds
								order by COA_Group__c desc
							];	
			}
			if(eltCandidateList != null && eltCandidateList.size() > 0) {
				for(User auser : eltCandidateList) {
					existingApproverIds.add(auser.Id);
				}
			}
				
					
			//Capital/Small A,B
			//Capital Mgmt (Maniwa-san or Maruyama san)
			//Treasury Mgr (Info Copy Only)
			//Fix Asset Mgr (Info Copy Only)			
			if(rfa.RecordTypeId == smallRTId || rfa.RecordTypeId == mediumRTId || rfa.RecordTypeId == capitalRTId) {
				if(Label.RFA_CapitalMgmt_Approver_1 != null && Label.RFA_CapitalMgmt_Approver_1 != rfa.CreatedById) {
					RFAUserRole__c approver = new RFAUserRole__c();
					approver.UserName__c = Label.RFA_CapitalMgmt_Approver_1;
					approver.RFA__c = rfa.Id;
					approver.ApprovalOrder__c = appprover_order;
					approver.RecordTypeId = approverRTId;
					approver.Approver_Source__c = RFAConstants.Approver_Source_CapitalMgmt;
					listRFAApproverToInsert.add(approver);
					appprover_order++;	
					
					existingApproverIds.add(Label.RFA_CapitalMgmt_Approver_1);				
				}		
				
				if(Label.RFA_Capital_Treasury_Mgr != null) {
					RFAUserRole__c infoonly = new RFAUserRole__c();
					infoonly.UserName__c = Label.RFA_Capital_Treasury_Mgr;
					infoonly.RFA__c = rfa.Id;
					infoonly.RecordTypeId = infoonlyRTId;
					infoonly.Approver_Source__c = RFAConstants.Approver_Source_TreasuryMgr;
					listRFAApproverToInsert.add(infoonly);				
				}				
				if(Label.RFA_Capital_Fix_Asset_Mgr != null) {
					RFAUserRole__c infoonly = new RFAUserRole__c();
					infoonly.UserName__c = Label.RFA_Capital_Fix_Asset_Mgr;
					infoonly.RFA__c = rfa.Id;
					infoonly.RecordTypeId = infoonlyRTId;
					infoonly.Approver_Source__c = RFAConstants.Approver_Source_FixAssetMgr;
					listRFAApproverToInsert.add(infoonly);				
				}	
										
			}						
			
			//added by Jia Hu on 2014/02/14  Travel and Entertainment Request from CokeOne Project
			if( (rfa.RecordTypeId == travelRTId || rfa.RecordTypeId == entertainmentRTId) && rfa.Cost_Center_Function__c == 'CokeOne') {
				if(Label.RFA_Project_Finance != null && Label.RFA_Project_Finance != rfa.CreatedById) {
					RFAUserRole__c approver = new RFAUserRole__c();
					approver.UserName__c = Label.RFA_Project_Finance;
					approver.RFA__c = rfa.Id;
					approver.ApprovalOrder__c = appprover_order;
					approver.RecordTypeId = approverRTId;
					approver.Approver_Source__c = RFAConstants.Approver_Source_CokeOne_ProjectFinance;
					listRFAApproverToInsert.add(approver);
					appprover_order++;	
					
					existingApproverIds.add(Label.RFA_Project_Finance);				
				}	
			}			
			
			
			
					
			//add Manager of the Requester
			//User me = [Select Id, Username, ManagerId from User where Id =: Userinfo.getUserId()];
			
			system.debug('--------- Current User: ' + me);
			
			Boolean hasManager = false;
			Boolean hasCokeOneManager = false;
			
			//non CokeOne requester
			if(me != null && me.ManagerId != null && rfa.Cost_Center_Function__c != 'CokeOne') {
				hasManager = true;
				//If Manaager is in ELT, leave the approver in ELT, not in Manager
				if(!existingApproverIds.contains(me.ManagerId)) {
					RFAUserRole__c approver = new RFAUserRole__c();
					approver.UserName__c = me.ManagerId;
					approver.RFA__c = rfa.Id;
					approver.ApprovalOrder__c = appprover_order;
					approver.RecordTypeId = approverRTId;
					approver.Approver_Source__c = RFAConstants.Approver_Source_Manager;
					listRFAApproverToInsert.add(approver);
					appprover_order++;
								
					existingApproverIds.add(me.ManagerId);
				}
			}	
			//CokeOne requester
			if(me != null && rfa.Cost_Center_Function__c == 'CokeOne') {
				
				if(me.CokeOne_Manager__c != null) {
					hasCokeOneManager = true;
					//If Manaager is in ELT, leave the approver in ELT, not in Manager
					if(!existingApproverIds.contains(me.CokeOne_Manager__c)) {
						RFAUserRole__c approver = new RFAUserRole__c();
						approver.UserName__c = me.CokeOne_Manager__c;
						approver.RFA__c = rfa.Id;
						approver.ApprovalOrder__c = appprover_order;
						approver.RecordTypeId = approverRTId;
						approver.Approver_Source__c = RFAConstants.Approver_Source_CokeOneManager;
						listRFAApproverToInsert.add(approver);
						appprover_order++;
								
						existingApproverIds.add(me.ManagerId);
					}
				}//
				
				if(me.ManagerId != null) {
					RFAUserRole__c infoonly = new RFAUserRole__c();
					infoonly.UserName__c = me.ManagerId;
					infoonly.RFA__c = rfa.Id;
					infoonly.RecordTypeId = infoonlyRTId;
					infoonly.Approver_Source__c = RFAConstants.Approver_Source_InfoCopy_Manager;
					listRFAApproverToInsert.add(infoonly);	
				}
				
			}				
			
					
			system.debug('------------- RFAApproverToInsert by my manager: ' + listRFAApproverToInsert);
			
			Map<String, Integer> GroupToOrder = new Map<String, Integer>();
			GroupToOrder.put(RFAConstants.Group1, 0);
			GroupToOrder.put(RFAConstants.Group2, 0);
			GroupToOrder.put(RFAConstants.Group3, 0);
			GroupToOrder.put(RFAConstants.Group4, 0);
			GroupToOrder.put(RFAConstants.Group5, 0);
			GroupToOrder.put(RFAConstants.Group6, 0);
											
			existingApproverIds.add(me.Id);
			
			//approver squence need to be set up here!!??			
			if(groupCandidateList != null && groupCandidateList.size() > 0) {
				String Previous_Group = null;
				for(User auser : groupCandidateList) { //remove current user!
					
					if(
						//auser.Id != me.Id   //Userinfo.getUserId()
						//&& 
						//(auser.Id != me.ManagerId)
						//&&
						!existingApproverIds.contains(auser.Id)
					) {//exlude Requester as Approver
						RFAUserRole__c approver = new RFAUserRole__c();
						approver.UserName__c = auser.Id;
						approver.RFA__c = rfa.Id;						
						approver.RecordTypeId = approverRTId;
						approver.Approver_Source__c = RFAConstants.Approver_Source_COA_Group;
						
						if(GroupToOrder.get(auser.COA_Group__c) == 0) {
							approver.ApprovalOrder__c = appprover_order;
							GroupToOrder.put(auser.COA_Group__c, appprover_order);
							listRFAApproverToInsert.add(approver);
							
							appprover_order++;			
										
						} else {
							approver.ApprovalOrder__c = GroupToOrder.get(auser.COA_Group__c);
							listRFAApproverToInsert.add(approver);
						}
						
						existingApproverIds.add(auser.Id); //add current Approver
						
					}//end of if-else;
				}
			}
			
			/*
				Approvers of single users, should consider the order of CEO, CFO,....
			*/
			/*
			Set<Id> existingApprovers = new Set<Id>();
			for(User au : groupCandidateList) {
				existingApprovers.add(au.Id);
			}
			existingApprovers.add(Userinfo.getUserId());
			existingApprovers.add(me.ManagerId);
			existingApprovers.add(Label.RFA_CapitalMgmt_Approver_1);
			*/
			system.debug('--------- AcronymList: ' + AcronymList);
			List<User> singeCandidateList = [
						Select Id, Username, COA_Group__c, COA_Acronym__c 
						from User where COA_Acronym__c IN: AcronymList And Id NOT IN: existingApproverIds
						order by L_level__c desc
						];			
			
			//Since Acronym may have duplicates, can't use Acronym as the Key in Map
			if(singeCandidateList != null && singeCandidateList.size() > 0 && AcronymList != null && AcronymList.size() > 0) {
				//old one, need Sequence in the Approver Order
				/*
				for(User auser : singeCandidateList) {
					RFAUserRole__c approver = new RFAUserRole__c();
					approver.UserName__c = auser.Id;
					approver.RFA__c = rfa.Id;						
					approver.RecordTypeId = approverRTId;
					approver.Approver_Source__c = RFAConstants.Approver_Source_COA_Single;
					approver.ApprovalOrder__c = appprover_order;
					listRFAApproverToInsert.add(approver);
					
					appprover_order++;	
					
					existingApproverIds.add(auser.Id);
				}
				*/
				
				for(integer i = 0; i < AcronymList.size(); i++) {
					for(User auser : singeCandidateList) {
						if(auser.COA_Acronym__c == AcronymList[i]) {
							RFAUserRole__c approver = new RFAUserRole__c();
							approver.UserName__c = auser.Id;
							approver.RFA__c = rfa.Id;						
							approver.RecordTypeId = approverRTId;
							approver.Approver_Source__c = RFAConstants.Approver_Source_COA_Single;
							approver.ApprovalOrder__c = appprover_order;
							listRFAApproverToInsert.add(approver);
					
							appprover_order++;	
					
							existingApproverIds.add(auser.Id);
						}//end of if();
					}//end of for(singeCandidateList);
				}//end of for(AcronymList)
				
			}
			
			
			if(eltCandidateList != null && eltCandidateList.size() > 0 && ELTList != null && ELTList.size() > 0) {
				/*
				for(User auser : eltCandidateList) {
					RFAUserRole__c approver = new RFAUserRole__c();
					approver.UserName__c = auser.Id;
					approver.RFA__c = rfa.Id;						
					approver.RecordTypeId = approverRTId;
					approver.Approver_Source__c = RFAConstants.Approver_Source_ELT;
					approver.ApprovalOrder__c = appprover_order;
					listRFAApproverToInsert.add(approver);
					
					appprover_order++;	
					
					existingApproverIds.add(auser.Id);
				}*/
				//add the Order to ELT approvers; ELT approvers is higer than COA group and COA single, must appear!
				for(integer i = 0; i < ELTList.size(); i++) {
					for(User auser : eltCandidateList) {
						if(auser.COA_Acronym__c == ELTList[i]) {
						
							RFAUserRole__c approver = new RFAUserRole__c();
							approver.UserName__c = auser.Id;
							approver.RFA__c = rfa.Id;						
							approver.RecordTypeId = approverRTId;
							approver.Approver_Source__c = RFAConstants.Approver_Source_ELT;
							approver.ApprovalOrder__c = appprover_order;
							listRFAApproverToInsert.add(approver);
					
							appprover_order++;	
					
							existingApproverIds.add(auser.Id);
						}//end of if();		
					}//end of for(eltCandidateList);			
				}//end of for(ELTList);
				
			}	
			
			if(InfoCopyList != null && InfoCopyList.size() > 0) {
				for(User auser : [
						Select Id, Username, COA_Group__c, COA_Acronym__c 
						from User where COA_Acronym__c IN: InfoCopyList And Id NOT IN: existingApproverIds
						]			) {
				
					
					RFAUserRole__c infoonly = new RFAUserRole__c();
					infoonly.UserName__c = auser.Id;
					infoonly.RFA__c = rfa.Id;
					infoonly.RecordTypeId = infoonlyRTId;
					infoonly.Approver_Source__c = RFAConstants.Approver_Source_InfoCopy;
					listRFAApproverToInsert.add(infoonly);	
				}					
			}
			system.debug('-------- InfoCopyList: ' + InfoCopyList);							
			
			}//end of if(!isBOD) / not process BOD
			
			//preparing for new RFA record
			//GroupNoList = new List<String>();
			Group2To4List = new Set<String>();
			Group5List = new Set<String>();
			AcronymList = new List<String>();
			ELTList = new List<String>();
			InfoCopyList = new Set<String>();		
			
						
		}//end of for(RFA__c rfa : rfaList) ;
		
		//STEP 3
		//insert approver list for each RFA record
		insert listRFAApproverToInsert;			
		system.debug('------ After Insert: ' + listRFAApproverToInsert);	
		
	}//end of addRFAApproversFromCOA();
	
				
	//--------------- Utility Method -----------------//
		
	public void processPrimaryCOACategory(RFA__c rfa, Boolean isBOD) {
		//thrid level: process by each COA sub category
		if(rfa.PrimaryCOASubCategory3__c != null) {//Primary COA Sub Category 3
			//STEP 1: 				
			List<COA__c> coaList = [
						Select Id, Name,
						PrimaryCOACategory__c, PrimaryCOASubCategory__c, PrimaryCOASubCategory2__c, PrimaryCOASubCategory3__c,
						Threshold_Type__c, Record_Type_List__c, Left_Bracket__c, Left_Sign__c, Right_Sign__c, Right_Bracket__c, 
						Function_Commercial_1__c, Function_Commercial_2__c, Function_Commercial_3__c, Function_Commercial_4__c,
						Function_Commercial_5__c, Function_Commercial_6__c, Function_Commercial_7__c, Function_Commercial_8__c,
						Function_Supply_Chain_1__c, Function_Supply_Chain_2__c, Function_Supply_Chain_3__c, Function_Supply_Chain_4__c,
						Function_Supply_Chain_5__c, Function_Supply_Chain_6__c, Function_Supply_Chain_7__c, Function_Supply_Chain_8__c,
						Function_Finance_1__c, Function_Finance_2__c, Function_Finance_3__c, Function_Finance_4__c,
						Function_Finance_5__c, Function_Finance_6__c, Function_Finance_7__c, Function_Finance_8__c,
						Function_HR_1__c, Function_HR_2__c, Function_HR_3__c, Function_HR_4__c,
						Function_HR_5__c, Function_HR_6__c, Function_HR_7__c, Function_HR_8__c,
						Function_Procurement_1__c, Function_Procurement_2__c, Function_Procurement_3__c, Function_Procurement_4__c,
						Function_Procurement_5__c, Function_Procurement_6__c, Function_Procurement_7__c, Function_Procurement_8__c,
						Function_CokeOne_1__c, Function_CokeOne_2__c, Function_CokeOne_3__c, Function_CokeOne_4__c,
						Function_CokeOne_5__c, Function_CokeOne_6__c, Function_CokeOne_7__c, Function_CokeOne_8__c,
						Function_Other_1__c, Function_Other_2__c, Function_Other_3__c, Function_Other_4__c,
						Function_Other_5__c, Function_Other_6__c, Function_Other_7__c, Function_Other_8__c,
						ELT_1__c, ELT_2__c, ELT_3__c, ELT_4__c, ELT_5__c, ELT_6__c, ELT_7__c, ELT_8__c,
						Info_Copy_1__c, Info_Copy_2__c, Info_Copy_3__c, Info_Copy_4__c, Info_Copy_5__c,
						Info_Copy_6__c, Info_Copy_7__c, Info_Copy_8__c, Info_Copy_9__c, Info_Copy_10__c,
						BOD__c
			from COA__c 
			where   PrimaryCOACategory__c     =: rfa.PrimaryCOACategory__c 
				AND PrimaryCOASubCategory__c  =: rfa.PrimaryCOASubCategory__c
				AND PrimaryCOASubCategory2__c =: rfa.PrimaryCOASubCategory2__c
				AND PrimaryCOASubCategory3__c =: rfa.PrimaryCOASubCategory3__c
			];
			system.debug('----- PrimaryCOACategory__c != null && PrimaryCOASubCategory2__c != null && PrimaryCOASubCategory3__c != null: ' 
						+ coaList);
					
			//thouth level: process by each COA rule
			processCOARules(rfa, coaList, isBOD);	
												
		} else if(rfa.PrimaryCOASubCategory2__c != null) {//Primary COA Sub Category 2
			//STEP 1: 				
			List<COA__c> coaList = [
						Select Id, Name,
						PrimaryCOACategory__c, PrimaryCOASubCategory__c, PrimaryCOASubCategory2__c, PrimaryCOASubCategory3__c,
						Threshold_Type__c, Record_Type_List__c, Left_Bracket__c, Left_Sign__c, Right_Sign__c, Right_Bracket__c, 
						Function_Commercial_1__c, Function_Commercial_2__c, Function_Commercial_3__c, Function_Commercial_4__c,
						Function_Commercial_5__c, Function_Commercial_6__c, Function_Commercial_7__c, Function_Commercial_8__c,
						Function_Supply_Chain_1__c, Function_Supply_Chain_2__c, Function_Supply_Chain_3__c, Function_Supply_Chain_4__c,
						Function_Supply_Chain_5__c, Function_Supply_Chain_6__c, Function_Supply_Chain_7__c, Function_Supply_Chain_8__c,
						Function_Finance_1__c, Function_Finance_2__c, Function_Finance_3__c, Function_Finance_4__c,
						Function_Finance_5__c, Function_Finance_6__c, Function_Finance_7__c, Function_Finance_8__c,
						Function_HR_1__c, Function_HR_2__c, Function_HR_3__c, Function_HR_4__c,
						Function_HR_5__c, Function_HR_6__c, Function_HR_7__c, Function_HR_8__c,
						Function_Procurement_1__c, Function_Procurement_2__c, Function_Procurement_3__c, Function_Procurement_4__c,
						Function_Procurement_5__c, Function_Procurement_6__c, Function_Procurement_7__c, Function_Procurement_8__c,
						Function_CokeOne_1__c, Function_CokeOne_2__c, Function_CokeOne_3__c, Function_CokeOne_4__c,
						Function_CokeOne_5__c, Function_CokeOne_6__c, Function_CokeOne_7__c, Function_CokeOne_8__c,
						Function_Other_1__c, Function_Other_2__c, Function_Other_3__c, Function_Other_4__c,
						Function_Other_5__c, Function_Other_6__c, Function_Other_7__c, Function_Other_8__c,
						ELT_1__c, ELT_2__c, ELT_3__c, ELT_4__c, ELT_5__c, ELT_6__c, ELT_7__c, ELT_8__c,
						Info_Copy_1__c, Info_Copy_2__c, Info_Copy_3__c, Info_Copy_4__c, Info_Copy_5__c,
						Info_Copy_6__c, Info_Copy_7__c, Info_Copy_8__c, Info_Copy_9__c, Info_Copy_10__c,
						BOD__c
			from COA__c 
			where   PrimaryCOACategory__c     =: rfa.PrimaryCOACategory__c 
				AND PrimaryCOASubCategory__c  =: rfa.PrimaryCOASubCategory__c
				AND PrimaryCOASubCategory2__c =: rfa.PrimaryCOASubCategory2__c
				AND PrimaryCOASubCategory3__c = null
			];
			system.debug('----- PrimaryCOACategory__c != null && PrimaryCOASubCategory2__c != null: ' + coaList);
					
			//thouth level: process by each COA rule
			processCOARules(rfa, coaList, isBOD);			
							
		} else if(rfa.PrimaryCOASubCategory__c != null) {//Primary COA Sub Category 1
			//STEP 1: query COA object to get the COA rules for each RFA record					
			List<COA__c> coaList = [
						Select Id, Name,
						PrimaryCOACategory__c, PrimaryCOASubCategory__c, PrimaryCOASubCategory2__c, PrimaryCOASubCategory3__c,
						Threshold_Type__c, Record_Type_List__c, Left_Bracket__c, Left_Sign__c, Right_Sign__c, Right_Bracket__c, 
						Function_Commercial_1__c, Function_Commercial_2__c, Function_Commercial_3__c, Function_Commercial_4__c,
						Function_Commercial_5__c, Function_Commercial_6__c, Function_Commercial_7__c, Function_Commercial_8__c,
						Function_Supply_Chain_1__c, Function_Supply_Chain_2__c, Function_Supply_Chain_3__c, Function_Supply_Chain_4__c,
						Function_Supply_Chain_5__c, Function_Supply_Chain_6__c, Function_Supply_Chain_7__c, Function_Supply_Chain_8__c,
						Function_Finance_1__c, Function_Finance_2__c, Function_Finance_3__c, Function_Finance_4__c,
						Function_Finance_5__c, Function_Finance_6__c, Function_Finance_7__c, Function_Finance_8__c,
						Function_HR_1__c, Function_HR_2__c, Function_HR_3__c, Function_HR_4__c,
						Function_HR_5__c, Function_HR_6__c, Function_HR_7__c, Function_HR_8__c,
						Function_Procurement_1__c, Function_Procurement_2__c, Function_Procurement_3__c, Function_Procurement_4__c,
						Function_Procurement_5__c, Function_Procurement_6__c, Function_Procurement_7__c, Function_Procurement_8__c,
						Function_CokeOne_1__c, Function_CokeOne_2__c, Function_CokeOne_3__c, Function_CokeOne_4__c,
						Function_CokeOne_5__c, Function_CokeOne_6__c, Function_CokeOne_7__c, Function_CokeOne_8__c,
						Function_Other_1__c, Function_Other_2__c, Function_Other_3__c, Function_Other_4__c,
						Function_Other_5__c, Function_Other_6__c, Function_Other_7__c, Function_Other_8__c,
						ELT_1__c, ELT_2__c, ELT_3__c, ELT_4__c, ELT_5__c, ELT_6__c, ELT_7__c, ELT_8__c,
						Info_Copy_1__c, Info_Copy_2__c, Info_Copy_3__c, Info_Copy_4__c, Info_Copy_5__c,
						Info_Copy_6__c, Info_Copy_7__c, Info_Copy_8__c, Info_Copy_9__c, Info_Copy_10__c,
						BOD__c
			from COA__c 
			where   PrimaryCOACategory__c     =: rfa.PrimaryCOACategory__c 
				AND PrimaryCOASubCategory__c  =: rfa.PrimaryCOASubCategory__c
				AND PrimaryCOASubCategory2__c = null
				AND PrimaryCOASubCategory3__c = null
			];
			system.debug('----- PrimaryCOACategory__c != null : ' + coaList);
					
			//thouth level: process by each COA rule
			processCOARules(rfa, coaList, isBOD);
					
		} else {//Primary COA Sub Category 1
			//STEP 1: query COA object to get the COA rules for each RFA record					
			List<COA__c> coaList = [
						Select Id, Name,
						PrimaryCOACategory__c, PrimaryCOASubCategory__c, PrimaryCOASubCategory2__c, PrimaryCOASubCategory3__c,
						Threshold_Type__c, Record_Type_List__c, Left_Bracket__c, Left_Sign__c, Right_Sign__c, Right_Bracket__c, 
						Function_Commercial_1__c, Function_Commercial_2__c, Function_Commercial_3__c, Function_Commercial_4__c,
						Function_Commercial_5__c, Function_Commercial_6__c, Function_Commercial_7__c, Function_Commercial_8__c,
						Function_Supply_Chain_1__c, Function_Supply_Chain_2__c, Function_Supply_Chain_3__c, Function_Supply_Chain_4__c,
						Function_Supply_Chain_5__c, Function_Supply_Chain_6__c, Function_Supply_Chain_7__c, Function_Supply_Chain_8__c,
						Function_Finance_1__c, Function_Finance_2__c, Function_Finance_3__c, Function_Finance_4__c,
						Function_Finance_5__c, Function_Finance_6__c, Function_Finance_7__c, Function_Finance_8__c,
						Function_HR_1__c, Function_HR_2__c, Function_HR_3__c, Function_HR_4__c,
						Function_HR_5__c, Function_HR_6__c, Function_HR_7__c, Function_HR_8__c,
						Function_Procurement_1__c, Function_Procurement_2__c, Function_Procurement_3__c, Function_Procurement_4__c,
						Function_Procurement_5__c, Function_Procurement_6__c, Function_Procurement_7__c, Function_Procurement_8__c,
						Function_CokeOne_1__c, Function_CokeOne_2__c, Function_CokeOne_3__c, Function_CokeOne_4__c,
						Function_CokeOne_5__c, Function_CokeOne_6__c, Function_CokeOne_7__c, Function_CokeOne_8__c,
						Function_Other_1__c, Function_Other_2__c, Function_Other_3__c, Function_Other_4__c,
						Function_Other_5__c, Function_Other_6__c, Function_Other_7__c, Function_Other_8__c,
						ELT_1__c, ELT_2__c, ELT_3__c, ELT_4__c, ELT_5__c, ELT_6__c, ELT_7__c, ELT_8__c,
						Info_Copy_1__c, Info_Copy_2__c, Info_Copy_3__c, Info_Copy_4__c, Info_Copy_5__c,
						Info_Copy_6__c, Info_Copy_7__c, Info_Copy_8__c, Info_Copy_9__c, Info_Copy_10__c,
						BOD__c
			from COA__c 
			where   PrimaryCOACategory__c     =: rfa.PrimaryCOACategory__c 
				AND PrimaryCOASubCategory__c  = null
				AND PrimaryCOASubCategory2__c = null
				AND PrimaryCOASubCategory3__c = null		
			
			];
			system.debug('----- PrimaryCOACategory__c != null : ' + coaList);
					
			//thouth level: process by each COA rule
			processCOARules(rfa, coaList, isBOD);
					
		}//end of if-else(category);		
		
	}
	
	//Second COA Category   SecondCOACategory__c	Picklist	
	public void processSecondCOACategory(RFA__c rfa, Boolean isBOD) {
		//thrid level: process by each COA sub category
		if(rfa.SecondCOASubCategory3__c != null) {
			//STEP 1: 				
			List<COA__c> coaList = [
						Select Id, Name,
						PrimaryCOACategory__c, PrimaryCOASubCategory__c, PrimaryCOASubCategory2__c, PrimaryCOASubCategory3__c,
						Threshold_Type__c, Record_Type_List__c, Left_Bracket__c, Left_Sign__c, Right_Sign__c, Right_Bracket__c, 
						Function_Commercial_1__c, Function_Commercial_2__c, Function_Commercial_3__c, Function_Commercial_4__c,
						Function_Commercial_5__c, Function_Commercial_6__c, Function_Commercial_7__c, Function_Commercial_8__c,
						Function_Supply_Chain_1__c, Function_Supply_Chain_2__c, Function_Supply_Chain_3__c, Function_Supply_Chain_4__c,
						Function_Supply_Chain_5__c, Function_Supply_Chain_6__c, Function_Supply_Chain_7__c, Function_Supply_Chain_8__c,
						Function_Finance_1__c, Function_Finance_2__c, Function_Finance_3__c, Function_Finance_4__c,
						Function_Finance_5__c, Function_Finance_6__c, Function_Finance_7__c, Function_Finance_8__c,
						Function_HR_1__c, Function_HR_2__c, Function_HR_3__c, Function_HR_4__c,
						Function_HR_5__c, Function_HR_6__c, Function_HR_7__c, Function_HR_8__c,
						Function_Procurement_1__c, Function_Procurement_2__c, Function_Procurement_3__c, Function_Procurement_4__c,
						Function_Procurement_5__c, Function_Procurement_6__c, Function_Procurement_7__c, Function_Procurement_8__c,
						Function_CokeOne_1__c, Function_CokeOne_2__c, Function_CokeOne_3__c, Function_CokeOne_4__c,
						Function_CokeOne_5__c, Function_CokeOne_6__c, Function_CokeOne_7__c, Function_CokeOne_8__c,
						Function_Other_1__c, Function_Other_2__c, Function_Other_3__c, Function_Other_4__c,
						Function_Other_5__c, Function_Other_6__c, Function_Other_7__c, Function_Other_8__c,
						ELT_1__c, ELT_2__c, ELT_3__c, ELT_4__c, ELT_5__c, ELT_6__c, ELT_7__c, ELT_8__c,
						Info_Copy_1__c, Info_Copy_2__c, Info_Copy_3__c, Info_Copy_4__c, Info_Copy_5__c,
						Info_Copy_6__c, Info_Copy_7__c, Info_Copy_8__c, Info_Copy_9__c, Info_Copy_10__c,
						BOD__c
			from COA__c 
			where   PrimaryCOACategory__c     =: rfa.SecondCOACategory__c
				AND PrimaryCOASubCategory__c  =: rfa.SecondCOASubCategory__c
				AND PrimaryCOASubCategory2__c =: rfa.SecondCOASubCategory2__c
				AND PrimaryCOASubCategory3__c =: rfa.SecondCOASubCategory3__c
			];
			system.debug('----- econdCOASubCategory__c != null && SecondCOASubCategory2__c != null && SecondCOASubCategory3__c != null: ' 
						+ coaList);
					
			//thouth level: process by each COA rule
			processCOARules(rfa, coaList, isBOD);	
												
		} else if(rfa.SecondCOASubCategory2__c != null) {
			//STEP 1: 				
			List<COA__c> coaList = [
						Select Id, Name,
						PrimaryCOACategory__c, PrimaryCOASubCategory__c, PrimaryCOASubCategory2__c, PrimaryCOASubCategory3__c,
						Threshold_Type__c, Record_Type_List__c, Left_Bracket__c, Left_Sign__c, Right_Sign__c, Right_Bracket__c, 
						Function_Commercial_1__c, Function_Commercial_2__c, Function_Commercial_3__c, Function_Commercial_4__c,
						Function_Commercial_5__c, Function_Commercial_6__c, Function_Commercial_7__c, Function_Commercial_8__c,
						Function_Supply_Chain_1__c, Function_Supply_Chain_2__c, Function_Supply_Chain_3__c, Function_Supply_Chain_4__c,
						Function_Supply_Chain_5__c, Function_Supply_Chain_6__c, Function_Supply_Chain_7__c, Function_Supply_Chain_8__c,
						Function_Finance_1__c, Function_Finance_2__c, Function_Finance_3__c, Function_Finance_4__c,
						Function_Finance_5__c, Function_Finance_6__c, Function_Finance_7__c, Function_Finance_8__c,
						Function_HR_1__c, Function_HR_2__c, Function_HR_3__c, Function_HR_4__c,
						Function_HR_5__c, Function_HR_6__c, Function_HR_7__c, Function_HR_8__c,
						Function_Procurement_1__c, Function_Procurement_2__c, Function_Procurement_3__c, Function_Procurement_4__c,
						Function_Procurement_5__c, Function_Procurement_6__c, Function_Procurement_7__c, Function_Procurement_8__c,
						Function_CokeOne_1__c, Function_CokeOne_2__c, Function_CokeOne_3__c, Function_CokeOne_4__c,
						Function_CokeOne_5__c, Function_CokeOne_6__c, Function_CokeOne_7__c, Function_CokeOne_8__c,
						Function_Other_1__c, Function_Other_2__c, Function_Other_3__c, Function_Other_4__c,
						Function_Other_5__c, Function_Other_6__c, Function_Other_7__c, Function_Other_8__c,
						ELT_1__c, ELT_2__c, ELT_3__c, ELT_4__c, ELT_5__c, ELT_6__c, ELT_7__c, ELT_8__c,
						Info_Copy_1__c, Info_Copy_2__c, Info_Copy_3__c, Info_Copy_4__c, Info_Copy_5__c,
						Info_Copy_6__c, Info_Copy_7__c, Info_Copy_8__c, Info_Copy_9__c, Info_Copy_10__c,
						BOD__c
			from COA__c 
			where   PrimaryCOACategory__c     =: rfa.SecondCOACategory__c 
				AND PrimaryCOASubCategory__c  =: rfa.SecondCOASubCategory__c
				AND PrimaryCOASubCategory2__c =: rfa.SecondCOASubCategory2__c
				AND PrimaryCOASubCategory3__c = null	
			];
			system.debug('----- SecondCOASubCategory__c != null && SecondCOASubCategory2__c != null: ' + coaList);
					
			//thouth level: process by each COA rule
			processCOARules(rfa, coaList, isBOD);			
							
		} else if(rfa.SecondCOASubCategory__c != null) {
			//STEP 1: query COA object to get the COA rules for each RFA record					
			List<COA__c> coaList = [
						Select Id, Name,
						PrimaryCOACategory__c, PrimaryCOASubCategory__c, PrimaryCOASubCategory2__c, PrimaryCOASubCategory3__c,
						Threshold_Type__c, Record_Type_List__c, Left_Bracket__c, Left_Sign__c, Right_Sign__c, Right_Bracket__c, 
						Function_Commercial_1__c, Function_Commercial_2__c, Function_Commercial_3__c, Function_Commercial_4__c,
						Function_Commercial_5__c, Function_Commercial_6__c, Function_Commercial_7__c, Function_Commercial_8__c,
						Function_Supply_Chain_1__c, Function_Supply_Chain_2__c, Function_Supply_Chain_3__c, Function_Supply_Chain_4__c,
						Function_Supply_Chain_5__c, Function_Supply_Chain_6__c, Function_Supply_Chain_7__c, Function_Supply_Chain_8__c,
						Function_Finance_1__c, Function_Finance_2__c, Function_Finance_3__c, Function_Finance_4__c,
						Function_Finance_5__c, Function_Finance_6__c, Function_Finance_7__c, Function_Finance_8__c,
						Function_HR_1__c, Function_HR_2__c, Function_HR_3__c, Function_HR_4__c,
						Function_HR_5__c, Function_HR_6__c, Function_HR_7__c, Function_HR_8__c,
						Function_Procurement_1__c, Function_Procurement_2__c, Function_Procurement_3__c, Function_Procurement_4__c,
						Function_Procurement_5__c, Function_Procurement_6__c, Function_Procurement_7__c, Function_Procurement_8__c,
						Function_CokeOne_1__c, Function_CokeOne_2__c, Function_CokeOne_3__c, Function_CokeOne_4__c,
						Function_CokeOne_5__c, Function_CokeOne_6__c, Function_CokeOne_7__c, Function_CokeOne_8__c,
						Function_Other_1__c, Function_Other_2__c, Function_Other_3__c, Function_Other_4__c,
						Function_Other_5__c, Function_Other_6__c, Function_Other_7__c, Function_Other_8__c,
						ELT_1__c, ELT_2__c, ELT_3__c, ELT_4__c, ELT_5__c, ELT_6__c, ELT_7__c, ELT_8__c,
						Info_Copy_1__c, Info_Copy_2__c, Info_Copy_3__c, Info_Copy_4__c, Info_Copy_5__c,
						Info_Copy_6__c, Info_Copy_7__c, Info_Copy_8__c, Info_Copy_9__c, Info_Copy_10__c,
						BOD__c
			from COA__c 
			where   PrimaryCOACategory__c     =: rfa.SecondCOACategory__c 
				AND PrimaryCOASubCategory__c  =: rfa.SecondCOASubCategory__c
				AND PrimaryCOASubCategory2__c = null
				AND PrimaryCOASubCategory3__c = null	
			];
			system.debug('----- SecondCOASubCategory__c != null : ' + coaList);
					
			//thouth level: process by each COA rule
			processCOARules(rfa, coaList, isBOD);
					
		} else {
			//STEP 1: query COA object to get the COA rules for each RFA record					
			List<COA__c> coaList = [
						Select Id, Name,
						PrimaryCOACategory__c, PrimaryCOASubCategory__c, PrimaryCOASubCategory2__c, PrimaryCOASubCategory3__c,
						Threshold_Type__c, Record_Type_List__c, Left_Bracket__c, Left_Sign__c, Right_Sign__c, Right_Bracket__c, 
						Function_Commercial_1__c, Function_Commercial_2__c, Function_Commercial_3__c, Function_Commercial_4__c,
						Function_Commercial_5__c, Function_Commercial_6__c, Function_Commercial_7__c, Function_Commercial_8__c,
						Function_Supply_Chain_1__c, Function_Supply_Chain_2__c, Function_Supply_Chain_3__c, Function_Supply_Chain_4__c,
						Function_Supply_Chain_5__c, Function_Supply_Chain_6__c, Function_Supply_Chain_7__c, Function_Supply_Chain_8__c,
						Function_Finance_1__c, Function_Finance_2__c, Function_Finance_3__c, Function_Finance_4__c,
						Function_Finance_5__c, Function_Finance_6__c, Function_Finance_7__c, Function_Finance_8__c,
						Function_HR_1__c, Function_HR_2__c, Function_HR_3__c, Function_HR_4__c,
						Function_HR_5__c, Function_HR_6__c, Function_HR_7__c, Function_HR_8__c,
						Function_Procurement_1__c, Function_Procurement_2__c, Function_Procurement_3__c, Function_Procurement_4__c,
						Function_Procurement_5__c, Function_Procurement_6__c, Function_Procurement_7__c, Function_Procurement_8__c,
						Function_CokeOne_1__c, Function_CokeOne_2__c, Function_CokeOne_3__c, Function_CokeOne_4__c,
						Function_CokeOne_5__c, Function_CokeOne_6__c, Function_CokeOne_7__c, Function_CokeOne_8__c,
						Function_Other_1__c, Function_Other_2__c, Function_Other_3__c, Function_Other_4__c,
						Function_Other_5__c, Function_Other_6__c, Function_Other_7__c, Function_Other_8__c,
						ELT_1__c, ELT_2__c, ELT_3__c, ELT_4__c, ELT_5__c, ELT_6__c, ELT_7__c, ELT_8__c,
						Info_Copy_1__c, Info_Copy_2__c, Info_Copy_3__c, Info_Copy_4__c, Info_Copy_5__c,
						Info_Copy_6__c, Info_Copy_7__c, Info_Copy_8__c, Info_Copy_9__c, Info_Copy_10__c,
						BOD__c
			from COA__c 
			where   PrimaryCOACategory__c     =: rfa.SecondCOACategory__c 
				AND PrimaryCOASubCategory__c  = null
				AND PrimaryCOASubCategory2__c = null
				AND PrimaryCOASubCategory3__c = null			
			
			
			];
			system.debug('----- rfa.SecondCOACategory__c != null : ' + coaList);
					
			//thouth level: process by each COA rule
			processCOARules(rfa, coaList, isBOD);
					
		}//end of if-else(category);				
	}	
	
	//Third COA Category     ThirdCOACategory__c	Picklist on RFA__c
	public void processThirdCOACategory(RFA__c rfa, Boolean isBOD) {
		//thrid level: process by each COA sub category
		if(rfa.ThirdCOASubCategory3__c != null) {
			//STEP 1: 				
			List<COA__c> coaList = [
						Select Id, Name,
						PrimaryCOACategory__c, PrimaryCOASubCategory__c, PrimaryCOASubCategory2__c, PrimaryCOASubCategory3__c,
						Threshold_Type__c, Record_Type_List__c, Left_Bracket__c, Left_Sign__c, Right_Sign__c, Right_Bracket__c, 
						Function_Commercial_1__c, Function_Commercial_2__c, Function_Commercial_3__c, Function_Commercial_4__c,
						Function_Commercial_5__c, Function_Commercial_6__c, Function_Commercial_7__c, Function_Commercial_8__c,
						Function_Supply_Chain_1__c, Function_Supply_Chain_2__c, Function_Supply_Chain_3__c, Function_Supply_Chain_4__c,
						Function_Supply_Chain_5__c, Function_Supply_Chain_6__c, Function_Supply_Chain_7__c, Function_Supply_Chain_8__c,
						Function_Finance_1__c, Function_Finance_2__c, Function_Finance_3__c, Function_Finance_4__c,
						Function_Finance_5__c, Function_Finance_6__c, Function_Finance_7__c, Function_Finance_8__c,
						Function_HR_1__c, Function_HR_2__c, Function_HR_3__c, Function_HR_4__c,
						Function_HR_5__c, Function_HR_6__c, Function_HR_7__c, Function_HR_8__c,
						Function_Procurement_1__c, Function_Procurement_2__c, Function_Procurement_3__c, Function_Procurement_4__c,
						Function_Procurement_5__c, Function_Procurement_6__c, Function_Procurement_7__c, Function_Procurement_8__c,
						Function_CokeOne_1__c, Function_CokeOne_2__c, Function_CokeOne_3__c, Function_CokeOne_4__c,
						Function_CokeOne_5__c, Function_CokeOne_6__c, Function_CokeOne_7__c, Function_CokeOne_8__c,
						Function_Other_1__c, Function_Other_2__c, Function_Other_3__c, Function_Other_4__c,
						Function_Other_5__c, Function_Other_6__c, Function_Other_7__c, Function_Other_8__c,
						ELT_1__c, ELT_2__c, ELT_3__c, ELT_4__c, ELT_5__c, ELT_6__c, ELT_7__c, ELT_8__c,
						Info_Copy_1__c, Info_Copy_2__c, Info_Copy_3__c, Info_Copy_4__c, Info_Copy_5__c,
						Info_Copy_6__c, Info_Copy_7__c, Info_Copy_8__c, Info_Copy_9__c, Info_Copy_10__c,
						BOD__c
			from COA__c 
			where   PrimaryCOACategory__c     =: rfa.ThirdCOACategory__c
				AND PrimaryCOASubCategory__c  =: rfa.ThirdCOASubCategory__c
				AND PrimaryCOASubCategory2__c =: rfa.ThirdCOASubCategory2__c
				AND PrimaryCOASubCategory3__c =: rfa.ThirdCOASubCategory3__c
			];
			system.debug('----- ThirdCOASubCategory__c != null && ThirdCOASubCategory2__c != null && ThirdCOASubCategory3__c != null: ' 
						+ coaList);
					
			//thouth level: process by each COA rule
			processCOARules(rfa, coaList, isBOD);	
												
		} else if(rfa.ThirdCOASubCategory2__c != null) {
			//STEP 1: 				
			List<COA__c> coaList = [
						Select Id, Name,
						PrimaryCOACategory__c, PrimaryCOASubCategory__c, PrimaryCOASubCategory2__c, PrimaryCOASubCategory3__c,
						Threshold_Type__c, Record_Type_List__c, Left_Bracket__c, Left_Sign__c, Right_Sign__c, Right_Bracket__c, 
						Function_Commercial_1__c, Function_Commercial_2__c, Function_Commercial_3__c, Function_Commercial_4__c,
						Function_Commercial_5__c, Function_Commercial_6__c, Function_Commercial_7__c, Function_Commercial_8__c,
						Function_Supply_Chain_1__c, Function_Supply_Chain_2__c, Function_Supply_Chain_3__c, Function_Supply_Chain_4__c,
						Function_Supply_Chain_5__c, Function_Supply_Chain_6__c, Function_Supply_Chain_7__c, Function_Supply_Chain_8__c,
						Function_Finance_1__c, Function_Finance_2__c, Function_Finance_3__c, Function_Finance_4__c,
						Function_Finance_5__c, Function_Finance_6__c, Function_Finance_7__c, Function_Finance_8__c,
						Function_HR_1__c, Function_HR_2__c, Function_HR_3__c, Function_HR_4__c,
						Function_HR_5__c, Function_HR_6__c, Function_HR_7__c, Function_HR_8__c,
						Function_Procurement_1__c, Function_Procurement_2__c, Function_Procurement_3__c, Function_Procurement_4__c,
						Function_Procurement_5__c, Function_Procurement_6__c, Function_Procurement_7__c, Function_Procurement_8__c,
						Function_CokeOne_1__c, Function_CokeOne_2__c, Function_CokeOne_3__c, Function_CokeOne_4__c,
						Function_CokeOne_5__c, Function_CokeOne_6__c, Function_CokeOne_7__c, Function_CokeOne_8__c,
						Function_Other_1__c, Function_Other_2__c, Function_Other_3__c, Function_Other_4__c,
						Function_Other_5__c, Function_Other_6__c, Function_Other_7__c, Function_Other_8__c,
						ELT_1__c, ELT_2__c, ELT_3__c, ELT_4__c, ELT_5__c, ELT_6__c, ELT_7__c, ELT_8__c,
						Info_Copy_1__c, Info_Copy_2__c, Info_Copy_3__c, Info_Copy_4__c, Info_Copy_5__c,
						Info_Copy_6__c, Info_Copy_7__c, Info_Copy_8__c, Info_Copy_9__c, Info_Copy_10__c,
						BOD__c
			from COA__c 
			where   PrimaryCOACategory__c     =: rfa.ThirdCOACategory__c 
				AND PrimaryCOASubCategory__c  =: rfa.ThirdCOASubCategory__c
				AND PrimaryCOASubCategory2__c =: rfa.ThirdCOASubCategory2__c
				AND PrimaryCOASubCategory3__c = null
				
			];
			system.debug('----- ThirdCOASubCategory__c != null && ThirdCOASubCategory2__c != null: ' + coaList);
					
			//thouth level: process by each COA rule
			processCOARules(rfa, coaList, isBOD);			
							
		} else if(rfa.ThirdCOASubCategory__c != null) {
			//STEP 1: query COA object to get the COA rules for each RFA record					
			List<COA__c> coaList = [
						Select Id, Name,
						PrimaryCOACategory__c, PrimaryCOASubCategory__c, PrimaryCOASubCategory2__c, PrimaryCOASubCategory3__c,
						Threshold_Type__c, Record_Type_List__c, Left_Bracket__c, Left_Sign__c, Right_Sign__c, Right_Bracket__c, 
						Function_Commercial_1__c, Function_Commercial_2__c, Function_Commercial_3__c, Function_Commercial_4__c,
						Function_Commercial_5__c, Function_Commercial_6__c, Function_Commercial_7__c, Function_Commercial_8__c,
						Function_Supply_Chain_1__c, Function_Supply_Chain_2__c, Function_Supply_Chain_3__c, Function_Supply_Chain_4__c,
						Function_Supply_Chain_5__c, Function_Supply_Chain_6__c, Function_Supply_Chain_7__c, Function_Supply_Chain_8__c,
						Function_Finance_1__c, Function_Finance_2__c, Function_Finance_3__c, Function_Finance_4__c,
						Function_Finance_5__c, Function_Finance_6__c, Function_Finance_7__c, Function_Finance_8__c,
						Function_HR_1__c, Function_HR_2__c, Function_HR_3__c, Function_HR_4__c,
						Function_HR_5__c, Function_HR_6__c, Function_HR_7__c, Function_HR_8__c,
						Function_Procurement_1__c, Function_Procurement_2__c, Function_Procurement_3__c, Function_Procurement_4__c,
						Function_Procurement_5__c, Function_Procurement_6__c, Function_Procurement_7__c, Function_Procurement_8__c,
						Function_CokeOne_1__c, Function_CokeOne_2__c, Function_CokeOne_3__c, Function_CokeOne_4__c,
						Function_CokeOne_5__c, Function_CokeOne_6__c, Function_CokeOne_7__c, Function_CokeOne_8__c,
						Function_Other_1__c, Function_Other_2__c, Function_Other_3__c, Function_Other_4__c,
						Function_Other_5__c, Function_Other_6__c, Function_Other_7__c, Function_Other_8__c,
						ELT_1__c, ELT_2__c, ELT_3__c, ELT_4__c, ELT_5__c, ELT_6__c, ELT_7__c, ELT_8__c,
						Info_Copy_1__c, Info_Copy_2__c, Info_Copy_3__c, Info_Copy_4__c, Info_Copy_5__c,
						Info_Copy_6__c, Info_Copy_7__c, Info_Copy_8__c, Info_Copy_9__c, Info_Copy_10__c,
						BOD__c
			from COA__c 
			where   PrimaryCOACategory__c     =: rfa.ThirdCOACategory__c 
				AND PrimaryCOASubCategory__c  =: rfa.ThirdCOASubCategory__c
				AND PrimaryCOASubCategory2__c = null
				AND PrimaryCOASubCategory3__c = null					
				
			];
			system.debug('----- ThirdCOASubCategory__c != null : ' + coaList);
					
			//thouth level: process by each COA rule
			processCOARules(rfa, coaList, isBOD);
					
		} else {
			//STEP 1: query COA object to get the COA rules for each RFA record					
			List<COA__c> coaList = [
						Select Id, Name,
						PrimaryCOACategory__c, PrimaryCOASubCategory__c, PrimaryCOASubCategory2__c, PrimaryCOASubCategory3__c,
						Threshold_Type__c, Record_Type_List__c, Left_Bracket__c, Left_Sign__c, Right_Sign__c, Right_Bracket__c, 
						Function_Commercial_1__c, Function_Commercial_2__c, Function_Commercial_3__c, Function_Commercial_4__c,
						Function_Commercial_5__c, Function_Commercial_6__c, Function_Commercial_7__c, Function_Commercial_8__c,
						Function_Supply_Chain_1__c, Function_Supply_Chain_2__c, Function_Supply_Chain_3__c, Function_Supply_Chain_4__c,
						Function_Supply_Chain_5__c, Function_Supply_Chain_6__c, Function_Supply_Chain_7__c, Function_Supply_Chain_8__c,
						Function_Finance_1__c, Function_Finance_2__c, Function_Finance_3__c, Function_Finance_4__c,
						Function_Finance_5__c, Function_Finance_6__c, Function_Finance_7__c, Function_Finance_8__c,
						Function_HR_1__c, Function_HR_2__c, Function_HR_3__c, Function_HR_4__c,
						Function_HR_5__c, Function_HR_6__c, Function_HR_7__c, Function_HR_8__c,
						Function_Procurement_1__c, Function_Procurement_2__c, Function_Procurement_3__c, Function_Procurement_4__c,
						Function_Procurement_5__c, Function_Procurement_6__c, Function_Procurement_7__c, Function_Procurement_8__c,
						Function_CokeOne_1__c, Function_CokeOne_2__c, Function_CokeOne_3__c, Function_CokeOne_4__c,
						Function_CokeOne_5__c, Function_CokeOne_6__c, Function_CokeOne_7__c, Function_CokeOne_8__c,
						Function_Other_1__c, Function_Other_2__c, Function_Other_3__c, Function_Other_4__c,
						Function_Other_5__c, Function_Other_6__c, Function_Other_7__c, Function_Other_8__c,
						ELT_1__c, ELT_2__c, ELT_3__c, ELT_4__c, ELT_5__c, ELT_6__c, ELT_7__c, ELT_8__c,
						Info_Copy_1__c, Info_Copy_2__c, Info_Copy_3__c, Info_Copy_4__c, Info_Copy_5__c,
						Info_Copy_6__c, Info_Copy_7__c, Info_Copy_8__c, Info_Copy_9__c, Info_Copy_10__c,
						BOD__c
			from COA__c 
			where   PrimaryCOACategory__c     =: rfa.ThirdCOACategory__c 
				AND PrimaryCOASubCategory__c  = null
				AND PrimaryCOASubCategory2__c = null
				AND PrimaryCOASubCategory3__c = null			
			
			];
			system.debug('----- ThirdCOASubCategory__c != null : ' + coaList);
					
			//thouth level: process by each COA rule
			processCOARules(rfa, coaList, isBOD);
					
		}//end of if-else(category);				
	}		
	
	/////// COA Rules processing
	
	public void processCOARules(RFA__c rfa, COA__c coa) {
		system.debug('------ In processCOARules(): BOD: ' + coa.BOD__c);
		if(coa.BOD__c == true) {
			rfa.BoardSubItem__c = 'Board';
		}			
	}
	
	
	//thouth level: process by each COA rule 
	//process different Threshold_Type__c of COA
	public void processCOARules(RFA__c rfa, List<COA__c> coaList, Boolean isBOD) {
		system.debug('-------- In processCOARules:  RFA__c: ' + rfa + ' COA List: ' + coaList + ' isBOD: ' + isBOD);
		if(coaList != null && coaList.size() > 0) {
			
			//process BOD field in COA or Not
			//if(isBOD) {
			//	for(COA__c coa : coaList) {
			//		if(coa.BOD__c == true) {
			//			rfa.BoardSubItem__c = 'Board';
			//		}
			//	}										
			//} else {//no BOD process			
						
			for(COA__c coa : coaList) {
				
				//process ETL first to avoid duplicate
				//process ELT(Executive Leadership Team)
				///processETLField(coa, rfa);					
								
				//fifth level: process by each Threshold type in COA rule
				//Type 1:
				if(coa.Threshold_Type__c == RFAConstants.Threshold_Type_All
					//'All'
				) {
					system.debug('------- coa.Threshold_Type__c == \'All\') ');
					
					if(isBOD) {
						processCOARules(rfa, coa);
					} else {
						processETLField(coa, rfa);	
						processFunctionAreaFiels(rfa, coa);
						processInfoCopyField(coa, rfa);
					}
				}														
				//end of process Threshold_Type__c == 'All';
							
				//Type 2:			
				if(coa.Threshold_Type__c == RFAConstants.Threshold_Type_Value
					//'Value'
				) {
					system.debug('------- coa.Threshold_Type__c == \'Value\') ');
					//Ⅶ-B-1-a will use 'Estimated Costs per Person' for Entertainment Record Type
					if(rfa.RecordTypeId == entertainmentRTId && coa.Name == 'Ⅶ-B-1-a') {
						processThresholdValueEntertainmentRT(rfa, coa, isBOD);
					} else {
						processThresholdValue(rfa, coa, isBOD);
					}
					
					//end of if-else left sign / righ sign										
				}//end of if Threshold_Type__c == 'Value';
				
				//Type 3:			
				if(coa.Threshold_Type__c == RFAConstants.Threshold_Type_ValueWithRT
					//'Value with Record Type'
				) {
					system.debug('------- coa.Threshold_Type__c == \'Value with Record Type\') ');
					system.debug('------- RecordTypeId: ' + rfa.RecordTypeId);
					if(
						(coa.Record_Type_List__c == 'Small Project' 
							|| coa.Record_Type_List__c == 'Medium Project' )
						&& 
						(rfa.RecordTypeId == smallRTId  //'01210000000QsJB' 
							|| rfa.RecordTypeId == mediumRTId //'01210000000QsJ9'
							)
					) {
									
						processThresholdValue(rfa, coa, isBOD);	
									
					} else if(coa.Record_Type_List__c == 'Capital Project' 
						&& rfa.RecordTypeId == capitalRTId
						//'01210000000QsJ6'
						) {
									
						processThresholdValue(rfa, coa, isBOD);											
					}
				}							
														
				//process ELT(Executive Leadership Team)
				//processETLField(coa);		
				
				//processInfoCopyField(coa, rfa);	
																																									
			}//end of for(COA__c coa : coaList) ; / no BOD process
			
			//}//end of if-else(isBOD);	
			
		}//end of if();
						
	}
	
	//Threshold_Type__c == 'Value'
	public void processThresholdValue(RFA__c rfa, COA__c coa, Boolean isBOD) {
		
		Integer leftsign  = RFAUtility.GreaterThanOrEqualTo(coa.Left_Sign__c);
		Integer rightsign = RFAUtility.LessThanOrEqualTo(coa.Right_Sign__c);
		
		system.debug('---- Left Sign: ' + coa.Left_Sign__c + '   Left Bracket: ' + coa.Left_Bracket__c 
			+ '  Right Sign: ' + coa.Right_Sign__c + '  Right Bracket: ' + coa.Right_Bracket__c);
		system.debug('------ leftsign: ' + leftsign + '  rightsign: ' + rightsign);
										
		if(leftsign == 1 && rightsign == 3) {
			if(rfa.RequestAmountFunctionalCurrency__c > coa.Left_Bracket__c 
				&& rfa.RequestAmountFunctionalCurrency__c < coa.Right_Bracket__c) {
				
				if(isBOD) {
					system.debug('----- In BOD: leftsign == 1 && rightsign == 3');
					processCOARules(rfa, coa);
				} else {
					processETLField(coa, rfa);							
					processFunctionAreaFiels(rfa, coa);
					processInfoCopyField(coa, rfa);
				}
				
			}
		} else if(leftsign == 1 && rightsign == 4) {
									
			if(rfa.RequestAmountFunctionalCurrency__c  > coa.Left_Bracket__c
				&& rfa.RequestAmountFunctionalCurrency__c <= coa.Right_Bracket__c) {
				
				if(isBOD) {
					system.debug('----- In BOD: leftsign == 1 && rightsign == 4');
					processCOARules(rfa, coa);
				} else {
					processETLField(coa, rfa);							
					processFunctionAreaFiels(rfa, coa);
					processInfoCopyField(coa, rfa);
				}
				
			}																		
		} else if(leftsign == 2 && rightsign == 3) {
									
			if(rfa.RequestAmountFunctionalCurrency__c  >= coa.Left_Bracket__c
				&& rfa.RequestAmountFunctionalCurrency__c < coa.Right_Bracket__c) {
				
				if(isBOD) {
					system.debug('----- In BOD: leftsign == 2 && rightsign == 3');
					processCOARules(rfa, coa);
				} else {
					processETLField(coa, rfa);							
					processFunctionAreaFiels(rfa, coa);
					processInfoCopyField(coa, rfa);
				}
				
			}																		
		} else if(leftsign == 2 && rightsign == 4) {
									
			if(rfa.RequestAmountFunctionalCurrency__c >= coa.Left_Bracket__c 
				&& rfa.RequestAmountFunctionalCurrency__c <= coa.Right_Bracket__c) {
				
				if(isBOD) {
					system.debug('----- In BOD: leftsign == 2 && rightsign == 4');
					processCOARules(rfa, coa);
				} else {
					processETLField(coa, rfa);						
					processFunctionAreaFiels(rfa, coa);
					processInfoCopyField(coa, rfa);
				}
			}																		
		} else if(coa.Right_Sign__c == null && coa.Right_Bracket__c == null && leftsign == 1) {
			if(rfa.RequestAmountFunctionalCurrency__c > coa.Left_Bracket__c) {		
				
				if(isBOD) {
					system.debug('----- In BOD: leftsign == null && rightsign == 1');
					processCOARules(rfa, coa);
				} else {
					processETLField(coa, rfa);									
					processFunctionAreaFiels(rfa, coa);
					processInfoCopyField(coa, rfa);
				}
				
			}			
		} else if(coa.Right_Sign__c == null && coa.Right_Bracket__c == null && leftsign == 2) {
			if(rfa.RequestAmountFunctionalCurrency__c >= coa.Left_Bracket__c) {	
				
				if(isBOD) {
					system.debug('----- In BOD: leftsign == 2 && rightsign == null');
					processCOARules(rfa, coa);
				} else {
					processETLField(coa, rfa);										
					processFunctionAreaFiels(rfa, coa);
					processInfoCopyField(coa, rfa);
				}
				
			}			
		}		
	}
	
	
	//Threshold_Type__c == 'Value' and RecordType = Entertainment and COA No. = Ⅶ-B-1-a
	public void processThresholdValueEntertainmentRT(RFA__c rfa, COA__c coa, Boolean isBOD) {
		
		Integer leftsign  = RFAUtility.GreaterThanOrEqualTo(coa.Left_Sign__c);
		Integer rightsign = RFAUtility.LessThanOrEqualTo(coa.Right_Sign__c);
		
		system.debug('---- Left Sign: ' + coa.Left_Sign__c + '   Left Bracket: ' + coa.Left_Bracket__c 
			+ '  Right Sign: ' + coa.Right_Sign__c + '  Right Bracket: ' + coa.Right_Bracket__c);
		system.debug('------ leftsign: ' + leftsign + '  rightsign: ' + rightsign);
										
		if(leftsign == 1 && rightsign == 3) {
			if(rfa.EstimatedCosts_PerPerson__c > coa.Left_Bracket__c 
				&& rfa.EstimatedCosts_PerPerson__c < coa.Right_Bracket__c) {
				
				if(isBOD) {
					system.debug('----- In BOD: leftsign == 1 && rightsign == 3');
					processCOARules(rfa, coa);
				} else {
					processETLField(coa, rfa);							
					processFunctionAreaFiels(rfa, coa);
					processInfoCopyField(coa, rfa);
				}
				
			}
		} else if(leftsign == 1 && rightsign == 4) {
									
			if(rfa.EstimatedCosts_PerPerson__c  > coa.Left_Bracket__c
				&& rfa.EstimatedCosts_PerPerson__c <= coa.Right_Bracket__c) {
				
				if(isBOD) {
					system.debug('----- In BOD: leftsign == 1 && rightsign == 4');
					processCOARules(rfa, coa);
				} else {
					processETLField(coa, rfa);							
					processFunctionAreaFiels(rfa, coa);
					processInfoCopyField(coa, rfa);
				}
				
			}																		
		} else if(leftsign == 2 && rightsign == 3) {
									
			if(rfa.EstimatedCosts_PerPerson__c  >= coa.Left_Bracket__c
				&& rfa.EstimatedCosts_PerPerson__c < coa.Right_Bracket__c) {
				
				if(isBOD) {
					system.debug('----- In BOD: leftsign == 2 && rightsign == 3');
					processCOARules(rfa, coa);
				} else {
					processETLField(coa, rfa);							
					processFunctionAreaFiels(rfa, coa);
					processInfoCopyField(coa, rfa);
				}
				
			}																		
		} else if(leftsign == 2 && rightsign == 4) {
									
			if(rfa.EstimatedCosts_PerPerson__c >= coa.Left_Bracket__c 
				&& rfa.EstimatedCosts_PerPerson__c <= coa.Right_Bracket__c) {
				
				if(isBOD) {
					system.debug('----- In BOD: leftsign == 2 && rightsign == 4');
					processCOARules(rfa, coa);
				} else {
					processETLField(coa, rfa);						
					processFunctionAreaFiels(rfa, coa);
					processInfoCopyField(coa, rfa);
				}
			}																		
		} else if(coa.Right_Sign__c == null && coa.Right_Bracket__c == null && leftsign == 1) {
			if(rfa.EstimatedCosts_PerPerson__c > coa.Left_Bracket__c) {		
				
				if(isBOD) {
					system.debug('----- In BOD: leftsign == null && rightsign == 1');
					processCOARules(rfa, coa);
				} else {
					processETLField(coa, rfa);									
					processFunctionAreaFiels(rfa, coa);
					processInfoCopyField(coa, rfa);
				}
				
			}			
		} else if(coa.Right_Sign__c == null && coa.Right_Bracket__c == null && leftsign == 2) {
			if(rfa.EstimatedCosts_PerPerson__c >= coa.Left_Bracket__c) {	
				
				if(isBOD) {
					system.debug('----- In BOD: leftsign == 2 && rightsign == null');
					processCOARules(rfa, coa);
				} else {
					processETLField(coa, rfa);										
					processFunctionAreaFiels(rfa, coa);
					processInfoCopyField(coa, rfa);
				}
				
			}			
		}		
	}	
	
	
	
	
	
	
	
	//Only one Cost Center for one RFA, all COA rules must have the same Function
	public void processFunctionAreaFiels(RFA__c rfa, COA__c coa) {
		system.debug('-------- In processFunctionAreaFiels(RFA__c rfa, COA__c coa) / rfa.Cost_Center_Function__c: ' + rfa.Cost_Center_Function__c);
		if(rfa.Cost_Center_Function__c == 'Commercial') {
			
			if(coa.Function_Commercial_1__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Commercial_1__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Commercial_1__c);
					//GroupNoList.add( coa.Function_Commercial_1__c );																		
				} else {
					AcronymList.add( coa.Function_Commercial_1__c );
				}
			}								
			if(coa.Function_Commercial_2__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Commercial_2__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Commercial_2__c);
					//GroupNoList.add( coa.Function_Commercial_2__c );
				} else {
					AcronymList.add( coa.Function_Commercial_2__c );
				}
			}								
			if(coa.Function_Commercial_3__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Commercial_3__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Commercial_3__c);
					//GroupNoList.add( coa.Function_Commercial_3__c );
				} else {
					AcronymList.add( coa.Function_Commercial_3__c );
				}
			}								
			if(coa.Function_Commercial_4__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Commercial_4__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Commercial_4__c);
					//GroupNoList.add( coa.Function_Commercial_4__c );
				} else {
					AcronymList.add( coa.Function_Commercial_4__c );
				}
			}	
			
			
			if(coa.Function_Commercial_5__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Commercial_5__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Commercial_5__c);																
				} else {
					AcronymList.add( coa.Function_Commercial_5__c );
				}
			}								
			if(coa.Function_Commercial_6__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Commercial_6__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Commercial_6__c);
				} else {
					AcronymList.add( coa.Function_Commercial_6__c );
				}
			}								
			if(coa.Function_Commercial_7__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Commercial_7__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Commercial_7__c);
				} else {
					AcronymList.add( coa.Function_Commercial_7__c );
				}
			}								
			if(coa.Function_Commercial_8__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Commercial_8__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Commercial_8__c);
				} else {
					AcronymList.add( coa.Function_Commercial_8__c );
				}
			}				
			
																																	
								
		}//end of Commercial;		
		else if(rfa.Cost_Center_Function__c == 'Supply Chain') {
											
			if(coa.Function_Supply_Chain_1__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Supply_Chain_1__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Supply_Chain_1__c);
					//GroupNoList.add( coa.Function_Supply_Chain_1__c );
				} else {
					AcronymList.add( coa.Function_Supply_Chain_1__c );
				}
			}								
			if(coa.Function_Supply_Chain_2__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Supply_Chain_2__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Supply_Chain_2__c);
					//GroupNoList.add( coa.Function_Supply_Chain_2__c );
				} else {
					AcronymList.add( coa.Function_Supply_Chain_2__c );
				}
			}								
			if(coa.Function_Supply_Chain_3__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Supply_Chain_3__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Supply_Chain_3__c);
					//GroupNoList.add( coa.Function_Supply_Chain_3__c );
				} else {
					AcronymList.add( coa.Function_Supply_Chain_3__c );
				}
			}								
			if(coa.Function_Supply_Chain_4__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Supply_Chain_4__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Supply_Chain_4__c);
					//GroupNoList.add( coa.Function_Supply_Chain_4__c );
				} else {
					AcronymList.add( coa.Function_Supply_Chain_4__c );
				}
			}	
			
			if(coa.Function_Supply_Chain_5__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Supply_Chain_5__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Supply_Chain_5__c);
				} else {
					AcronymList.add( coa.Function_Supply_Chain_5__c );
				}
			}								
			if(coa.Function_Supply_Chain_6__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Supply_Chain_6__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Supply_Chain_6__c);
				} else {
					AcronymList.add( coa.Function_Supply_Chain_6__c );
				}
			}								
			if(coa.Function_Supply_Chain_7__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Supply_Chain_7__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Supply_Chain_7__c);
				} else {
					AcronymList.add( coa.Function_Supply_Chain_7__c );
				}
			}								
			if(coa.Function_Supply_Chain_8__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Supply_Chain_8__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Supply_Chain_8__c);
				} else {
					AcronymList.add( coa.Function_Supply_Chain_8__c );
				}
			}				
			
																	
		}//end of Supply Chain;
		else if(rfa.Cost_Center_Function__c == 'Finance') {		
									
			if(coa.Function_Finance_1__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Finance_1__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Finance_1__c);
					//GroupNoList.add( coa.Function_Finance_1__c );
					system.debug('------ coa.Function_Finance_1__c: Group: ' + coa.Function_Finance_1__c);
				} else {
					AcronymList.add( coa.Function_Finance_1__c );
					system.debug('------ coa.Function_Finance_1__c: User: ' + coa.Function_Finance_1__c);
				}
			}								
			if(coa.Function_Finance_2__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Finance_2__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Finance_2__c);
					//GroupNoList.add( coa.Function_Finance_2__c );
					system.debug('------ coa.Function_Finance_2__c: Group: ' + coa.Function_Finance_2__c);
				} else {
					AcronymList.add( coa.Function_Finance_2__c );
					system.debug('------ coa.Function_Finance_2__c: User: ' + coa.Function_Finance_2__c);
				}
			}									
			if(coa.Function_Finance_3__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Finance_3__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Finance_3__c);
					//GroupNoList.add( coa.Function_Finance_3__c );
					system.debug('------ coa.Function_Finance_3__c: Group: ' + coa.Function_Finance_3__c);
				} else {
					AcronymList.add( coa.Function_Finance_3__c );
					system.debug('------ coa.Function_Finance_3__c: User: ' + coa.Function_Finance_3__c);
				}
			}									
			if(coa.Function_Finance_4__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Finance_4__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Finance_4__c);
					//GroupNoList.add( coa.Function_Finance_4__c );
					system.debug('------ coa.Function_Finance_4__c: Group: ' + coa.Function_Finance_4__c);
				} else {
					AcronymList.add( coa.Function_Finance_4__c );
					system.debug('------ coa.Function_Finance_4__c: User: ' + coa.Function_Finance_4__c);
				}
			}		
			
			
			if(coa.Function_Finance_5__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Finance_5__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Finance_5__c);
				} else {
					AcronymList.add( coa.Function_Finance_5__c );
				}
			}								
			if(coa.Function_Finance_6__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Finance_6__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Finance_6__c);
				} else {
					AcronymList.add( coa.Function_Finance_6__c );
				}
			}									
			if(coa.Function_Finance_7__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Finance_7__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Finance_7__c);
				} else {
					AcronymList.add( coa.Function_Finance_7__c );
				}
			}									
			if(coa.Function_Finance_8__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Finance_8__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Finance_8__c);
				} else {
					AcronymList.add( coa.Function_Finance_8__c );
				}
			}				
										
								
		}//end of Finance;
		else if(rfa.Cost_Center_Function__c == 'HR') {
			
			if(coa.Function_HR_1__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_HR_1__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_HR_1__c);
					//GroupNoList.add( coa.Function_HR_1__c );
				} else {
					AcronymList.add( coa.Function_HR_1__c );
				}
			}								
			if(coa.Function_HR_2__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_HR_2__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_HR_2__c);
					//GroupNoList.add( coa.Function_HR_2__c );
				} else {
					AcronymList.add( coa.Function_HR_2__c );
				}
			}									
			if(coa.Function_HR_3__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_HR_3__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_HR_3__c);
					//GroupNoList.add( coa.Function_HR_3__c );
				} else {
					AcronymList.add( coa.Function_HR_3__c );
				}
			}									
			if(coa.Function_HR_4__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_HR_4__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_HR_4__c);
					//GroupNoList.add( coa.Function_HR_4__c );
				} else {
					AcronymList.add( coa.Function_HR_4__c );
				}
			}		
			
			if(coa.Function_HR_5__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_HR_5__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_HR_5__c);
				} else {
					AcronymList.add( coa.Function_HR_5__c );
				}
			}								
			if(coa.Function_HR_6__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_HR_6__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_HR_6__c);
				} else {
					AcronymList.add( coa.Function_HR_6__c );
				}
			}									
			if(coa.Function_HR_7__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_HR_7__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_HR_7__c);
				} else {
					AcronymList.add( coa.Function_HR_7__c );
				}
			}									
			if(coa.Function_HR_8__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_HR_8__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_HR_8__c);
				} else {
					AcronymList.add( coa.Function_HR_8__c );
				}
			}				
			
										
								
		}//end of HR;			
		else if(rfa.Cost_Center_Function__c == 'Procurement') {
			
			if(coa.Function_Procurement_1__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Procurement_1__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Procurement_1__c);
					//GroupNoList.add( coa.Function_Procurement_1__c );
				} else {
					AcronymList.add( coa.Function_Procurement_1__c );
				}
			}	
			if(coa.Function_Procurement_2__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Procurement_2__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Procurement_2__c);
					//GroupNoList.add( coa.Function_Procurement_2__c );
				} else {
					AcronymList.add( coa.Function_Procurement_2__c );
				}
			}	
			if(coa.Function_Procurement_3__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Procurement_3__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Procurement_3__c);
					//GroupNoList.add( coa.Function_Procurement_3__c );
				} else {
					AcronymList.add( coa.Function_Procurement_3__c );
				}
			}									
			if(coa.Function_Procurement_4__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Procurement_4__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Procurement_4__c);
					//GroupNoList.add( coa.Function_Procurement_4__c );
				} else {
					AcronymList.add( coa.Function_Procurement_4__c );
				}
			}	
			
			if(coa.Function_Procurement_5__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Procurement_5__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Procurement_5__c);
				} else {
					AcronymList.add( coa.Function_Procurement_5__c );
				}
			}	
			if(coa.Function_Procurement_6__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Procurement_6__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Procurement_6__c);
				} else {
					AcronymList.add( coa.Function_Procurement_6__c );
				}
			}	
			if(coa.Function_Procurement_7__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Procurement_7__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Procurement_7__c);
				} else {
					AcronymList.add( coa.Function_Procurement_7__c );
				}
			}									
			if(coa.Function_Procurement_8__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Procurement_8__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Procurement_8__c);
				} else {
					AcronymList.add( coa.Function_Procurement_8__c );
				}
			}				
			
			
											
		}//end of Procurement;	
		
		else if(rfa.Cost_Center_Function__c == 'CokeOne') {
			
			if(coa.Function_CokeOne_1__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_CokeOne_1__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_CokeOne_1__c);
					//GroupNoList.add( coa.Function_Procurement_1__c );
				} else {
					AcronymList.add( coa.Function_CokeOne_1__c );
				}
			}	
			if(coa.Function_CokeOne_2__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_CokeOne_2__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_CokeOne_2__c);
					//GroupNoList.add( coa.Function_Procurement_2__c );
				} else {
					AcronymList.add( coa.Function_CokeOne_2__c );
				}
			}	
			if(coa.Function_CokeOne_3__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_CokeOne_3__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_CokeOne_3__c);
					//GroupNoList.add( coa.Function_Procurement_3__c );
				} else {
					AcronymList.add( coa.Function_CokeOne_3__c );
				}
			}									
			if(coa.Function_CokeOne_4__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_CokeOne_4__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_CokeOne_4__c);
					//GroupNoList.add( coa.Function_Procurement_4__c );
				} else {
					AcronymList.add( coa.Function_CokeOne_4__c );
				}
			}	
			
			if(coa.Function_CokeOne_5__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_CokeOne_5__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_CokeOne_5__c);
				} else {
					AcronymList.add( coa.Function_CokeOne_5__c );
				}
			}	
			if(coa.Function_CokeOne_6__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_CokeOne_6__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_CokeOne_6__c);
				} else {
					AcronymList.add( coa.Function_CokeOne_6__c );
				}
			}	
			if(coa.Function_CokeOne_7__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_CokeOne_7__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_CokeOne_7__c);
				} else {
					AcronymList.add( coa.Function_CokeOne_7__c );
				}
			}									
			if(coa.Function_CokeOne_8__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_CokeOne_8__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_CokeOne_8__c);
				} else {
					AcronymList.add( coa.Function_CokeOne_8__c );
				}
			}				
			
			
											
		}//end of CokeOne;			
		
													
		else if((
			rfa.Cost_Center_Function__c == 'IT'  || 
			rfa.Cost_Center_Function__c == 'PAC' ||
			rfa.Cost_Center_Function__c == 'BI'  ||
			rfa.Cost_Center_Function__c == 'Legal' 
			)) {//Other
				
			if(coa.Function_Other_1__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Other_1__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Other_1__c);
					//GroupNoList.add( coa.Function_Other_1__c );
				} else {
					AcronymList.add( coa.Function_Other_1__c );
				}
			}
			if(coa.Function_Other_2__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Other_2__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Other_2__c);
					//GroupNoList.add( coa.Function_Other_2__c );
				} else {
					AcronymList.add( coa.Function_Other_2__c );
				}
			}								
			if(coa.Function_Other_3__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Other_3__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Other_3__c);
					//GroupNoList.add( coa.Function_Other_3__c );
				} else {
					AcronymList.add( coa.Function_Other_3__c );
				}
			}								
			if(coa.Function_Other_4__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Other_4__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Other_4__c);
					//GroupNoList.add( coa.Function_Other_4__c );
				} else {
					AcronymList.add( coa.Function_Other_4__c );
				}
			}
			
			if(coa.Function_Other_5__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Other_5__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Other_5__c);
				} else {
					AcronymList.add( coa.Function_Other_5__c );
				}
			}
			if(coa.Function_Other_6__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Other_6__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Other_6__c);
				} else {
					AcronymList.add( coa.Function_Other_6__c );
				}
			}								
			if(coa.Function_Other_7__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Other_7__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Other_7__c);
				} else {
					AcronymList.add( coa.Function_Other_7__c );
				}
			}								
			if(coa.Function_Other_8__c != null) {
				if(RFAUtility.GroupOrUser(coa.Function_Other_8__c)) {
					processGroupFilter(rfa.Cost_Center_Function__c, coa.Function_Other_8__c);
				} else {
					AcronymList.add( coa.Function_Other_8__c );
				}
			}			
			
																				
		}	
						
				
	}//end of Other;
	
	
	public void processGroupFilter(String Function, String GroupNo) {
		if(GroupNo == RFAConstants.Group1) {
			if(Function != 'Other') {
				AcronymList.add( Gr1FunctionToAcronym.get(Function) );
			} else {
				AcronymList.add('CITO');
				AcronymList.add('CBIO');
				AcronymList.add('CPACO');
				AcronymList.add('CLO');
			}
		} else {
			//GroupNoList.add
			//FunctionToGroup.put(Function, GroupNo);
			if(GroupNo == RFAConstants.Group5) {
				Group5List.add(GroupNo); //Group 5 need Location filter
			} else {
				Group2To4List.add(GroupNo);
			}
			//GroupNoList.add(GroupNo);
		}
	}
	
	//process ELT(Executive Leadership Team) fiels
	//can process Gr.1 and end user
	public void processETLField(COA__c coa, RFA__c rfa) {
		if(coa.ELT_1__c != null) {
			processETLField_Step1(rfa.Cost_Center_Function__c, coa.ELT_1__c);
			//ELTList.add( coa.ELT_1__c );
			/*
			if(RFAUtility.GroupOrUser(coa.ELT_1__c)) {
				GroupNoList.add( coa.ELT_1__c );
				system.debug('------ coa.ELT_1__c: Group: ' + coa.ELT_1__c);
			} else {
				AcronymList.add( coa.ELT_1__c );
				system.debug('------ coa.ELT_1__c: User: ' + coa.ELT_1__c);
			}*/
		}			
		if(coa.ELT_2__c != null) {
			//ELTList.add( coa.ELT_2__c );
			processETLField_Step1(rfa.Cost_Center_Function__c, coa.ELT_2__c);
		}			
		if(coa.ELT_3__c != null) {
			//ELTList.add( coa.ELT_3__c );
			processETLField_Step1(rfa.Cost_Center_Function__c, coa.ELT_3__c);
		}														
		if(coa.ELT_4__c != null) {
			//ELTList.add( coa.ELT_4__c );
			processETLField_Step1(rfa.Cost_Center_Function__c, coa.ELT_4__c);
		}		

		if(coa.ELT_5__c != null) {
			processETLField_Step1(rfa.Cost_Center_Function__c, coa.ELT_5__c);
		}			
		if(coa.ELT_6__c != null) {
			processETLField_Step1(rfa.Cost_Center_Function__c, coa.ELT_6__c);
		}														
		if(coa.ELT_7__c != null) {
			processETLField_Step1(rfa.Cost_Center_Function__c, coa.ELT_7__c);
		}			
		if(coa.ELT_8__c != null) {
			processETLField_Step1(rfa.Cost_Center_Function__c, coa.ELT_8__c);
		}			
		
		
			
	}//end of processETLField(COA__c coa);
	
	public void processETLField_Step1(String Function, String ELT_Field) {
		if(ELT_Field == RFAConstants.Group1) {
			//Group 1: select by functions		
			if(Function != 'Other') {
				ELTList.add( Gr1FunctionToAcronym.get(Function) );
			} else {
				ELTList.add('CITO');
				ELTList.add('CBIO');
				ELTList.add('CPACO');
				ELTList.add('CLO');											
			}			
		} else {
				ELTList.add(ELT_Field);
		}		
	}

	public void processInfoCopyField(COA__c coa, RFA__c rfa) {
		
		if(coa.Info_Copy_1__c != null) {
			if(coa.Info_Copy_1__c != 'ELT' && coa.Info_Copy_1__c != 'BOD') {
				processInfoCopyField_Step1(rfa.Cost_Center_Function__c, coa.Info_Copy_1__c);
			} else if(coa.Info_Copy_1__c == 'ELT') {
				processInfoCopyField_ELT(coa.Info_Copy_1__c);
			}
		}			
		if(coa.Info_Copy_2__c != null) {
			if(coa.Info_Copy_2__c != 'ELT' && coa.Info_Copy_2__c != 'BOD') {
				processInfoCopyField_Step1(rfa.Cost_Center_Function__c, coa.Info_Copy_2__c);
			} else if(coa.Info_Copy_2__c == 'ELT') {
				processInfoCopyField_ELT(coa.Info_Copy_2__c);
			}
		}	
				
		if(coa.Info_Copy_3__c != null) {
			if(coa.Info_Copy_3__c != 'ELT' && coa.Info_Copy_3__c != 'BOD') {
				processInfoCopyField_Step1(rfa.Cost_Center_Function__c, coa.Info_Copy_3__c);
			} else if(coa.Info_Copy_3__c == 'ELT') {
				processInfoCopyField_ELT(coa.Info_Copy_3__c);
			}
		}														
		if(coa.Info_Copy_4__c != null) {
			if(coa.Info_Copy_4__c != 'ELT' && coa.Info_Copy_4__c != 'BOD') {
				processInfoCopyField_Step1(rfa.Cost_Center_Function__c, coa.Info_Copy_4__c);
			} else if(coa.Info_Copy_4__c == 'ELT') {
				processInfoCopyField_ELT(coa.Info_Copy_4__c);
			}
		}		
		

		if(coa.Info_Copy_5__c != null) {
			if(coa.Info_Copy_5__c != 'ELT' && coa.Info_Copy_5__c != 'BOD') {
				processInfoCopyField_Step1(rfa.Cost_Center_Function__c, coa.Info_Copy_5__c);
			} else if(coa.Info_Copy_5__c == 'ELT') {
				processInfoCopyField_ELT(coa.Info_Copy_5__c);
			}
		}			
		if(coa.Info_Copy_6__c != null) {
			if(coa.Info_Copy_6__c != 'ELT' && coa.Info_Copy_6__c != 'BOD') {
				processInfoCopyField_Step1(rfa.Cost_Center_Function__c, coa.Info_Copy_6__c);
			} else if(coa.Info_Copy_6__c == 'ELT') {
				processInfoCopyField_ELT(coa.Info_Copy_6__c);
			}
		}					
		if(coa.Info_Copy_7__c != null) {
			if(coa.Info_Copy_7__c != 'ELT' && coa.Info_Copy_7__c != 'BOD') {
				processInfoCopyField_Step1(rfa.Cost_Center_Function__c, coa.Info_Copy_7__c);
			} else if(coa.Info_Copy_7__c == 'ELT') {
				processInfoCopyField_ELT(coa.Info_Copy_7__c);
			}
		}														
		if(coa.Info_Copy_8__c != null) {
			if(coa.Info_Copy_8__c != 'ELT' && coa.Info_Copy_8__c != 'BOD') {
				processInfoCopyField_Step1(rfa.Cost_Center_Function__c, coa.Info_Copy_8__c);
			} else if(coa.Info_Copy_8__c == 'ELT') {
				processInfoCopyField_ELT(coa.Info_Copy_8__c);
			}
		}	
		if(coa.Info_Copy_9__c != null) {
			if(coa.Info_Copy_9__c != 'ELT' && coa.Info_Copy_9__c != 'BOD') {
				processInfoCopyField_Step1(rfa.Cost_Center_Function__c, coa.Info_Copy_9__c);
			} else if(coa.Info_Copy_9__c == 'ELT') {
				processInfoCopyField_ELT(coa.Info_Copy_9__c);
			}
		}														
		if(coa.Info_Copy_10__c != null) {
			if(coa.Info_Copy_10__c != 'ELT' && coa.Info_Copy_10__c != 'BOD') {
				processInfoCopyField_Step1(rfa.Cost_Center_Function__c, coa.Info_Copy_10__c);
			} else if(coa.Info_Copy_10__c == 'ELT') {
				processInfoCopyField_ELT(coa.Info_Copy_10__c);
			}
		}			
		
		
	}//end of processETLField(COA__c coa);	
	
	public void processInfoCopyField_Step1(String Function, String Info_Copy_Field) {
		if(Info_Copy_Field == RFAConstants.Group1) {
			//Group 1: select by functions		
			if(Function != 'Other') {
				String strUser = Gr1FunctionToAcronym.get(Function);
				if(!ifContains(strUser, AcronymList) && !ifContains(strUser, ELTList)) {
					InfoCopyList.add(strUser);
				}
			} else {
				if(!ifContains('CITO', AcronymList) && !ifContains('CITO', ELTList)) {
					InfoCopyList.add('CITO');
				}
				if(!ifContains('CBIO', AcronymList) && !ifContains('CBIO', ELTList)) {
					InfoCopyList.add('CBIO');
				}
				if(!ifContains('CPACO', AcronymList) && !ifContains('CPACO', ELTList)) {
					InfoCopyList.add('CPACO');
				}
				if(!ifContains('CLO', AcronymList) && !ifContains('CLO', ELTList)) {
					InfoCopyList.add('CLO');
				}												
			}			
		} else {
				if(!ifContains(Info_Copy_Field, AcronymList)) {
					InfoCopyList.add(Info_Copy_Field);
				}
		}
	}
	
	public void processInfoCopyField_ELT(String Info_Copy_Field) {
		for(integer i = 0; i < Gr1AcronymList.size(); i++) {
			if(!ifContains(Gr1AcronymList[i], AcronymList) && !ifContains(Gr1AcronymList[i], ELTList)) {
					InfoCopyList.add( Gr1AcronymList[i] );
			}	
		}
	}	
	
	//if str is in the list, return true
	public Boolean ifContains(String strToDecide, List<String> strList) {		
		if(strList != null && strList.size() > 0) {
			for(integer i = 0; i < strList.size(); i++) {
				if(strList[i] == strToDecide) {
					return true;
				}
			}
		}
		return false;
	}
	
	//申請者をデフォルトでPPOCに設定する
	//called by RFA_RFATrigger: After Insert
	public void addDefaultPPOC(List<RFA__c> rfaList) {	
		List<RFAUserRole__c> listPPOCToInsert = new List<RFAUserRole__c>();
		Id ppocRTId 
			= RFAConstants.getRecordType(
				RFAConstants.RTLabel_RFAUserRole_PPOC, 
				RFAConstants.Obj_RFAUserRole_APIName
			);
		
		for(RFA__c rfa : rfaList) {
			RFAUserRole__c ppoc = new RFAUserRole__c();
			ppoc.UserName__c = rfa.CreatedById;
			ppoc.RFA__c = rfa.Id;						
			ppoc.RecordTypeId = ppocRTId;
			listPPOCToInsert.add(ppoc);			
		}
		
		if(listPPOCToInsert != null && listPPOCToInsert.size() > 0) {
			insert listPPOCToInsert;
		}
	}

}