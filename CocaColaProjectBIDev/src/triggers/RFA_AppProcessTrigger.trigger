/*   
 *  Trigger          : RFA_AppProcessTrigger 
 *  Author           : Accenture
 *  Version History  : 2.0
 *  Creation         : 5/31/2012
 *  Assumptions      : N/A
 *  Description      : Trigger contains business logic to process RFA for its different Stages/level
 *
 *  updated by Jia Hu on 2013/10/25  
 *  only used for updating RFA status                                 
 */
trigger RFA_AppProcessTrigger on ApprovalProcess__c (after insert, after update) {
   
    List<RFA__c> rfaUpdateList = new List<RFA__c>();   
    
    //removed by Jia Hu   not really used here
    //RFA_AP03_ApprovalProcessHelper processhelper = new RFA_AP03_ApprovalProcessHelper();
    
    //set up the RFA stage based on the Approval Prcess Status
    for(ApprovalProcess__c appProcess : Trigger.new)
    {
        system.debug(appProcess.Status__c + ' appProcess.Status__c');
        
        //PROCESS_COMPLETED = label.RFA_CL069: Completed
        if(appProcess.Status__c == RFAConstants.ApprovalProcess_Completed
        	//RFAConstants.ApprovalProcess_Completed
        	//RFAGlobalConstants.PROCESS_COMPLETED 
        	)
        {
        	//removed by Jia Hu on 2013/12/02                    
             //RFA__c rfaUpdate = new RFA__c(Id = appProcess.RFA__c);
             //use Post-Circulation to stand for Approval Process completed on RFA record: need to change ??!!
             //RFA_POST_CIRCULATION_STAGE = Label.RFA_CL039: Post-Circulation
             //rfaUpdate.Stage__c = RFAGlobalConstants.RFA_POST_CIRCULATION_STAGE; 
             //rfaUpdateList.add(rfaUpdate);           
        }
        else if(appProcess.Status__c == RFAConstants.ApprovalProcess_In_Progress
        	//RFAConstants.ApprovalProcess_In_Progress
        	//RFAGlobalConstants.PROCESS_IN_PROGRESS
        	) 
        //PROCESS_IN_PROGRESS = Label.RFA_CL068: In Progress
        {        	
             RFA__c rfaUpdate = new RFA__c(Id = appProcess.RFA__c);
             //RFA_CIRCULATION_STAGE = Label.RFA_CL041: Circulation
             rfaUpdate.Stage__c = RFAConstants.RFA_STATUS_CIRCULATION;
             	//RFAConstants.RFA_STATUS_CIRCULATION;
             	//RFAGlobalConstants.RFA_CIRCULATION_STAGE; 
             rfaUpdateList.add(rfaUpdate);         
        }
        System.debug('\n rfa update list : ' + rfaUpdateList);
    }
			    
    if(!rfaUpdateList.isEmpty())
    {			
        try{           	
             update rfaUpdateList;                 
           } catch(DMLException dme)
           {
           		Trigger.new[0].addError(dme.getMessage());
           }                 
    }

}