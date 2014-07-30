/*
 * Class Name: RFA_AP02_Shareutil 
 * Author: Accenture
 * Date: 02-06-2012
 * Project Name: Coke-RFA
 * Requirement Description: This is the Utility Class to Give access to the users to teh RFA share based on various conditions.
 *
 * Update by Jia Hu on 2013/10/25
 */

public class RFA_AP02_Shareutil {
       
    // for RFA create
    public List<RFA__Share> rfaShareListInsert = new List<RFA__Share>();
    public List<RFA__Share> rfaShareList;
    
    public List<RFA__Share> rfaShareListDelete = new List<RFA__Share>();
    public Static Map<String, String> rfaSharingReason = new Map<String, String>();
    
    public Map<String,String> rfaSharingReasonStaticList 
    	= rfaSharingReasonUtil.listAllRFASharingReason();
    
    public static Map<String, RecordType> approverRecordTypeMap 
    	= RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());
    
    /* RFA Create Methods******************************/
    //called by Class: RFA_AP05_RFATrigger / RFA record owner is replaced by workflow when created
    public void rfaCreate(Map<Id, Id> UseridsMap) // Id for RFAIds, Id for UserId   
    {
        rfaShareListInsert = new List<RFA__Share>();
        
        for(Id rfaId: UseridsMap.keySet())
        {
                RFA__Share rfaShare = new RFA__Share();
                rfaShare.AccessLevel ='Edit';
                rfaShare.parentid = rfaId;
                rfaShare.RowCause = Schema.RFA__Share.RowCause.KORequestor__c;
                rfaShare.UserOrGroupId = UseridsMap.get(rfaId);
                rfaShareListInsert.add(rfaShare);       
        }
        
        system.debug('\n for KO requestor' + rfaShareListInsert);
        
        if(rfaShareListInsert.size()>0)
        {
            insert rfaShareListInsert;
        }                
    }   
    
    /************************Profit center permission at rfa creation****************************************/
    // Added by Ashwani for FR1.86 - rfaList in the parameter below
    // Id RFA Ids, Id for ProfitCenterID, String for LevelofRFA
    // Usage:
    // RFA_RFATrigger(RFA_AP05_RFATrigger)  ---> RFA_AP05_RFATrigger(processRFAProfitCenterShare) : after insert && after update
    /*
    	updated by Jia Hu on 2013/11/05   level__c on Profit Center and Profit Center Role is removed
    */
    public void profitCenterAtRfaCreateShare(Map<Id, Map<Id, String>> UseridsMap) 
    {
    	system.debug('-------- profitCenterAtRfaCreateShare(Map<Id, Map<Id, String>> UseridsMap) : ' + UseridsMap);
        //system.debug(UseridsMap+'%%%%%%%%%%%%%%%%%%%%%%%%%');
        rfaShareListInsert = new List<RFA__Share>();
        Map<Id, List<ProfitCenterUserRole__c>> profitCenterMap = new Map<Id, List<ProfitCenterUserRole__c>>();
        Map<Id,String> rfaRecordTypeMap = new Map<Id,String>(); // rfa Id, RecordTypeName
        Set<id> ProfitCenterids = new Set<Id>();
        Map<Id,RFA__c> rfaMap = new Map<Id, RFA__c>(); //Added by Ashwani for FR1.86
            
        for(Id rfaId: UseridsMap.keySet() )
        {
            for(Id profitCenterId: UseridsMap.get(rfaId).keySet())
            {
                ProfitCenterids.add(profitCenterId);
            }
        }
        
        for(RFA__C rfaRec:[
        	Select RecordType.Name, id, 
        	PrimaryCOACategory__c,
        	PrimaryCOASubCategory__c,
        	PrimaryCOASubCategory2__c,
        	PrimaryCOASubCategory3__c
        	 
        	from rfa__c where Id IN: UserIdsMap.keyset()])
        {
            rfaRecordTypeMap.put(rfaRec.Id, rfaRec.RecordType.Name);
            rfaMap.put(rfaRec.Id, rfaRec);       
        }
        
        for(ProfitCenter__c profitCenter: [
        	Select Id, 
        	(Select id, UserName__c, 
        		//Level__c, 
        		Usertype__c 
        		from Profit_Center_Associated_Users__r where UserName__r.IsActive = true 
        		//order by level__c
        	),
        	name from ProfitCenter__c where Id IN:ProfitCenterids LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows()) ])
        {
            if (!profitCenter.Profit_Center_Associated_Users__r.IsEmpty())
                profitCenterMap.put(profitCenter.Id, profitCenter.Profit_Center_Associated_Users__r);
        }
        
        if(!profitCenterMap.IsEmpty())
        {
            for(Id rfaId: UseridsMap.keySet())
            {
                for(Id profitCenterId : UseridsMap.get(rfaId).keySet())
                {                    
                    //System.debug(rfaLevel + '@@@@'+profitCenterId + '#############' + rfaId);
                    
                    if(profitCenterMap.get(profitCenterId) <> null)
                    {
                        for(ProfitCenterUserRole__c profitCenterUserRole: profitCenterMap.get(profitCenterId) )
                        {
                        	//system.debug('rfaLevel' + rfaLevel);
                            RFA__Share rfaShare = new RFA__Share();
                            rfaShare.parentid = rfaId;

                                    //PC_USERTYPE_Viewer=Label.RFA_CL066: Viewer - All
                                    //else 
                                    if(profitCenterUserRole.UserType__c == RFAConstants.ProfitCenterUserRole_UserType_Viewer
                                    	//RFAGlobalConstants.PC_USERTYPE_Viewer
                                    )
                                    {
                                        rfaShare.RowCause=Schema.RFA__Share.RowCause.PCReviewer__c;
                                        rfaShare.AccessLevel = 'Read';
                                    }
                                    //PC_USERTYPE_RFCViewer=Label.RFA_CL067: Viewer - Capital Only
                                    else if(profitCenterUserRole.UserType__c == RFAConstants.ProfitCenterUserRole_UserType_Capital
                                    	//RFAGlobalConstants.PC_USERTYPE_RFCViewer
                                    )
                                    {
                                    	//Capital only is definied as any record type except General Request!!!
                                    	//RFA_CL122: General Request
                                        If(rfaRecordTypeMap.get(rfaId) != 
                                        	RFAConstants.RECORDTYPE_General_PROJECT_REQUEST
                                        	//label.RFA_CL122
                                        	)
                                        {
                                            rfaShare.RowCause=Schema.RFA__Share.RowCause.PCReviewer__c;
                                            rfaShare.AccessLevel = 'Read';
                                            rfaShare.UserOrGroupId = profitCenterUserRole.UserName__c;
                                            rfaShareListInsert.add(rfaShare);
                                        }
                                    
                                    }
                                    if(profitCenterUserRole.UserType__c != RFAConstants.ProfitCenterUserRole_UserType_Capital
                                    	//RFAGlobalConstants.PC_USERTYPE_RFCViewer
                                    )
                                    {
                                        rfaShare.UserOrGroupId=profitCenterUserRole.UserName__c;
                                        rfaShareListInsert.add(rfaShare);
                                    }
                        }
                    }
                }
            
            }
        }
        if(!rfaShareListInsert.IsEmpty())
        {
            system.debug('\n ------- profitCenterAtRfaCreateShare(Map<Id, Map<Id, String>> UseridsMap) ---- Custom Apex Sharing:--'+ rfaShareListInsert);
            insert rfaShareListInsert;
        }
    } 
    
    
    /**********************This method is not yet final. Will use in batch process****/
    public void profitCenteruserRoleInsert(Map<Id, Map<Id, String>> userRoleIds)   // profitId, UserId, UserTypeRole
    {
        rfaShareListInsert = new List<RFA__Share>();
        Map<Id, List<Rfa__c>> profitCenterRFAMap = new Map<Id, List<Rfa__c>>();
        for(ProfitCenter__C profitCenter: [
        	Select Id, Name,
        		(Select id,ProfitCenterNumber__c from RFA__r) 
        	from ProfitCenter__c where Id IN :userRoleIds.keyset() 
        	LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows()) ])
        {
            profitCenterRFAMap.put(profitCenter.Id, profitCenter.RFA__r );
        }
        for(Id profitCenterId: userRoleIds.keyset())
        {
            for(Id userId: (userRoleIds.get(profitCenterId)).keySet())
            {
                for(Rfa__c rfa: profitCenterRFAMap.get(profitCenterId))
                {
                        RFA__Share rfaShare = new RFA__Share();
                        rfaShare.parentid = rfa.Id;
                        //if((userRoleIds.get(profitCenterId)).get(userId) == RFAGlobalConstants.PC_USERTYPE_LC)
                        //{
                       //     rfaShare.RowCause = 'Location Coordinator Access';
                       //     rfaShare.AccessLevel = 'Edit';
                       // }
                       // else 
                        if((userRoleIds.get(profitCenterId)).get(userId) == 'Viewer')
                        {
                            rfaShare.RowCause = 'Profit Center Reviewer Access';
                            rfaShare.AccessLevel = 'Read';
                        }
                        rfaShare.UserOrGroupId = userId;
                        rfaShareListInsert.add(rfaShare);
                }
            
            }
        
        }
        if(!rfaShareListInsert.IsEmpty())
        {
            system.debug('\n ------- profitCenteruserRoleInsert(Map<Id, Map<Id, String>> userRoleIds) --- Custom Apex Sharing:--'+ rfaShareListInsert);
            insert rfaShareListInsert;
        }
    
    }
    
    /**********************This method is not yet final. Will use in batch process Ends here****/
    
    // rfaId, UserId, Role--InfoUser,Approvers
    //called by RUR_RFAUserRoleTrigger on RFAUserRole__c 
    public void rfaApproversShareInsert(Map<String, Map<Id,String>> UseridsMap) 
    {
        System.debug('\n -------- In rfaApproversShareInsert:  User Id Map : ' + UseridsMap);
        rfaShareListInsert = new List<RFA__Share>();
        for(String rfa: UserIdsMap.KeySet())
        {           
            for(Id rfaUserRole : UseridsMap.get(rfa).KeySet())
            {
                RFA__Share rfaShare = new RFA__Share();               
                rfaShare.parentid = rfa;
                if(UseridsMap.get(rfa).get(rfaUserRole) == Schema.RFA__Share.RowCause.Approver__c)
                {
                    rfaShare.AccessLevel = 'Read';
                    rfaShare.RowCause = Schema.RFA__Share.RowCause.Approver__c;
                }               
                //else if(UseridsMap.get(rfa).get(rfaUserRole) == Schema.RFA__Share.RowCause.Authors__c)
                //{
                //    rfaShare.AccessLevel = 'Read';
                //    rfaShare.RowCause = Schema.RFA__Share.RowCause.Authors__c;
                //}
                else if(UseridsMap.get(rfa).get(rfaUserRole) == Schema.RFA__Share.RowCause.KORequestor__c)
                {
                    rfaShare.AccessLevel = 'Edit';
                    rfaShare.RowCause = Schema.RFA__Share.RowCause.KORequestor__c;
                }
                else if(UseridsMap.get(rfa).get(rfaUserRole) == Schema.RFA__Share.RowCause.Reviewer__c)
                {
                    rfaShare.AccessLevel = 'Read';
                    rfaShare.RowCause = Schema.RFA__Share.RowCause.Reviewer__c;
                }
                
                
                rfaShare.UserOrGroupId=rfaUserRole;
                rfaShareListInsert.add(rfaShare);           
                
            }
        }
        
        if(!rfaShareListInsert.IsEmpty())
        {
            system.debug('\n ---- rfaApproversShareInsert(Map<String, Map<Id,String>> UseridsMap) --- Custom Apex Sharing:--'+ rfaShareListInsert);
            insert rfaShareListInsert;
        }
    
    }
    
    
    public void processAfterDeleteUserRole(List<RFAUserRole__c> userRoles)
    {       
        for(RFAUserRole__c deletedUserRole : userRoles)
        {
            ////??? no logic here ??? question by Jia Hu
        }
    }
    
    // Need to correct the logic
    // usersForDeletion<RFA ID, <User Id of deleted RFA_User_Role, Share Row Cause Value>>
    // changedUserRoles: set of deleted RFA_User_Role IDs
    public void rfaShareDeletion(Map<String, Map<Id, String>> usersForDeletion, Set<String> changedUserRoles)
    {
        // Retreive List of RFA records with list of child RFA_User_Roles__r                               
        RFA__c[] rfaRecords = [Select Id,
                            	(Select UserName__c, Agent1__c, Agent2__c, Agent3__c, RecordTypeId, RecordType.Name 
                            	FROM RFA_User_Roles__r where Id NOT IN: changedUserRoles
                            	)
                               FROM RFA__c Where Id IN: usersForDeletion.keySet() 
                               LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())
                             ];                              
        
        // Iterate through each RFA record retreived
        for(RFA__c rfa : rfaRecords)
        {
            Map<Id, String> userRoleMap = usersForDeletion.get(rfa.Id); // store map of User Ids which were deleted, Row Cause value per RFA Id
            Map<Id, String> associatedUsers = new Map<Id, String>(); // container for all current RFA associated users
            List<RFAUserRole__c> associatedUserRoles = rfa.RFA_User_Roles__r; // list of RFA child RFA_User_Roles__r records
            
            // logic to filter the delete list if another RFA_User_Roles record exists with the user as the same type.
            for(RFAUserRole__c userRole : associatedUserRoles)
            {
                if(userRole.UserName__c <> null && userRole.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id)
                {
                    associatedUsers.put(userRole.UserName__c,Schema.RFA__Share.RowCause.Approver__c);   
                }else if(userRole.UserName__c <> null && 
                        (
                         //userRole.RecordTypeId == approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id || 
                         userRole.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id)
                        )
                {
                    associatedUsers.put(userRole.UserName__c,Schema.RFA__Share.RowCause.KORequestor__c);
                }else if(userRole.UserName__c <> null && userRole.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id)
                {
                    associatedUsers.put(userRole.UserName__c,Schema.RFA__Share.RowCause.Reviewer__c);   
                }       
                if(userRole.Agent1__c <> null)
                {
                    if (userRole.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id)
                        associatedUsers.put(userRole.Agent1__c,Schema.RFA__Share.RowCause.Approver__c); 
                        
                    else if (userRole.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id)
                        associatedUsers.put(userRole.UserName__c,Schema.RFA__Share.RowCause.Reviewer__c);
                }
                if(userRole.Agent2__c <> null)
                {
                    if (userRole.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id)
                        associatedUsers.put(userRole.Agent2__c,Schema.RFA__Share.RowCause.Approver__c); 
                        
                    else if (userRole.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id)
                        associatedUsers.put(userRole.UserName__c,Schema.RFA__Share.RowCause.Reviewer__c);
                }
                if(userRole.Agent3__c <> null)
                {
                    if (userRole.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id)
                        associatedUsers.put(userRole.Agent3__c,Schema.RFA__Share.RowCause.Approver__c); 
                        
                    else if (userRole.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id)
                        associatedUsers.put(userRole.UserName__c,Schema.RFA__Share.RowCause.Reviewer__c);
                }
                    
            }
            
            // validate that the user to be delete from RFA__Share is not mapped to the same role in an existing RFA_User_Roles record and should have access removed
            // if the user is mapped to the same role on an existing RFA_User_Roles record, exclude the user from being deleted on the RFA__Share table.
            for(String userId : userRoleMap.keySet())
            {
                if(associatedUsers.containsKey(userId))
                {
                    if(userRoleMap.get(userId) == associatedUsers.get(userId))
                        userRoleMap.remove(userId); 
                }
            }
            usersForDeletion.put(rfa.Id, userRoleMap);
        }
        
        System.debug('\n *********************Map value for user for deletion after iteration'+usersForDeletion);
        
        deleteRFAShare(usersForDeletion);                               
    }
    
    
    
    /* @Method <This method validates other existing userroles before deleting and finally deletes the sharing record once the validation is passed.>
       @param <Map<Id, Map<Id, String>>> 
       @return <None>
    */ 
    public void deleteRFAShare(Map<String, Map<Id, String>> usersForDeletion)
    {
        List<RFA__Share> shareForDelete = new List<RFA__Share>();
        RFA__Share[] shareRecords = [
        	Select UserOrGroupId, AccessLevel, RowCause, ParentId 
        	FROM RFA__Share where parentId IN : usersForDeletion.keySet() 
        	LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())
        	];
        
        for(String rfa : usersForDeletion.keySet())
        {
            for(String user : usersForDeletion.get(rfa).keySet())
            {
                for(RFA__Share shareRec : shareRecords)
                {
                    if(shareRec.Parentid == rfa && shareRec.UserOrGroupId == user && shareRec.RowCause == usersForDeletion.get(rfa).get(user))
                    {
                        shareForDelete.add(shareRec);
                    }
                }   
            }
        }
        
        if(!shareForDelete.isEmpty()) delete shareForDelete;
    }
/* RFA Create Methods End here******************************/

/* RFA Update Methods******************************/
    
    //called by RFA_AP05_RFATrigger class from RFA_RFATriger: before update && after update
    // If RFA Profit Center Changes
    // Id RFA Ids, Id for ProfitCenterID  
    public void rfaProfitCenterUpdateDeleteOldProfitCenter(Map<Id, Id> UseridsMap)  
    {
    	system.debug(' ---------- rfaProfitCenterUpdateDeleteOldProfitCenter(Map<Id, Id> UseridsMap) : ' + UseridsMap);
        rfaShareListInsert = new List<RFA__Share>();
        rfaShareListDelete = new List<RFA__Share>();
        Map<Id, List<ProfitCenterUserRole__c>> profitCenterMap = new Map<Id, List<ProfitCenterUserRole__c>>();
        Set<id> ProfitCenterids = new Set<Id>();
        Map<Id, List<RFA__Share>> rfaShareOldMap = new map<Id, List<RFA__Share>>();
        
        List<String> rowCauseList = new List<String>();
        rowCauseList.add('PCReviewer__c');
        //rowCauseList.add('PCLocationCoordinator__c');
        
        for(RFA__c rfa: [
        	Select id, name,ProfitCenterNumber__c, 
        		(Select id, parentId, AccessLevel from Shares where rowcause IN: rowCauseList) 
        	from RFA__c where Id IN : UseridsMap.keySet() 
        	LIMIT : (limits.getLimitQueryRows() - limits.getQueryRows())
        	]
           )
        {
            rfaShareOldMap.put(rfa.Id, rfa.Shares);
        }
        
        for(Id rfaId: UseridsMap.keySet())
        {       
            for(RFA__Share rfaShareRecord : rfaShareOldMap.get(rfaId))
            {
                RFA__Share rfaShareOldRecord = new Rfa__Share(id = rfaShareRecord.id);
                rfaShareListDelete.add(rfaShareOldRecord);                
            }
        }
        
        if(rfaShareListDelete.size() > 0)
        {
            delete rfaShareListDelete;
        }
    }

}