/*
	updated by Jia Hu on 2013/10/25
*/
//UserType__c	Picklist: Viewer - All, Viewer - Capital Only, Coordinator
trigger PUR_ProfitCenterUserRoleTrigger on ProfitCenterUserRole__c (
	before insert, after insert, 
	before update, after update, 
	before delete, after delete) {

   /*~~~~Start of Initialization~~~~*/
   RFA_AP01_ProfitCenterUserRole pcUsrRole = new RFA_AP01_ProfitCenterUserRole ();
   
   // User query to fetch profile Name for logged In user to bypass the custom validation
   User usr = [
   		Select Profile.Name, id 
   		from User where id =: UserInfo.getUserId() Limit 1
   		]; 
   
   //Japanese Issue		
   String UserNameProfile = usr.Profile.Name;
   
   /*~~~~End of Initialization~~~~*/
	/*   
   	if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
   		//need to refine??!!
   		//Map<Id, Set<Id>> ProfitCenterMappingUserIds = new Map<Id, Set<Id>>();
   		Set<Id> profitCenterIds = new Set<Id>();
   		Set<Id> memberIDs = new Set<Id>();
		for(ProfitCenterUserRole__c pcur : Trigger.New) {
			if(pcur.UserName__c != null) {		
				profitCenterIds.add(pcur.ProfitCenter__c);		
				memberIDs.add(pcur.UserName__c);
			}
		}   		
		//ProfitCenterUserRole__c					
   	}
   	*/
   
   //Before trigger removed by Jia Hu on 2013/12/07   
   /****************************Trigger Before action block starts here**********************************************/
   /*
   if(Trigger.IsBefore)
    {     
        ////////////Trigger before insert block starts here//////////////
        if(Trigger.IsInsert)
        {
        	// Bypass for System Admin profile
            if( !RFAConstants.isRFAAdmin(UserNameProfile)      	
            ) {          
              	//class RFA_AP01_ProfitCenterUserRole  	
                pcUsrRole.processRecords(Trigger.New, 'Trigger.New');               
                // calling the custom validation for permission access to udpate the records     
            }               
        }
        ///////////Trigger before insert block Ends here//////////
        
        //////////Trigger before update block starts here//////////////
        if(Trigger.isUpdate)
        {
            // Bypass for System Admin profile
            if( !RFAConstants.isRFAAdmin(UserNameProfile)
            	  // UserNameProfile != Label.RFA_CL053 
            	//&& UserNameProfile != Label.RFA_CL052 
            	//&& UserNameProfile != Label.RFA_CL054 
            	//&& UserNameProfile != Label.RFA_CL055
            	//&& UserNameProfile != 'システム管理者'
            ) 
            {
            	//class RFA_AP01_ProfitCenterUserRole
            	// calling the custom validation for permission access to udpate the records
                pcUsrRole.processRecords(Trigger.Old, 'Trigger.Update'); 
                // calling the custom validation for permission access to udpate the records
                pcUsrRole.processRecords(Trigger.New, 'Trigger.New');                             
            }
        }
        ////////////Trigger before update block ends here///////////
        
        ////////////Trigger before delete block starts here/////////////
        
        if(Trigger.IsDelete)
        {
        	// Bypass for System Admin profile
            if(   !RFAConstants.isRFAAdmin(UserNameProfile)
             //UserNameProfile != Label.RFA_CL053 
            //	&& UserNameProfile != Label.RFA_CL052 
            //	&& UserNameProfile != Label.RFA_CL054 
            	//&& UserNameProfile != Label.RFA_CL055
            //	&& UserNameProfile != 'システム管理者'
            ) {  
              	//class RFA_AP01_ProfitCenterUserRole
            	// calling the custom validation for permission access to udpate the records
                pcUsrRole.processRecords(Trigger.Old, 'Trigger.Old'); 
            }
                          
        }
        ///////////Trigger before delete block ends here//////////////
    }
    */
    
    /****************************Trigger Before action block ends here**********************************************/
    
    /****************************Trigger After action block starts here**********************************************/
    if(Trigger.IsAfter)
    {
        /**********************************Trigger after insert block starts here***************************/
        if(Trigger.IsInsert)
        {
        	//removed by Jia Hu on 2013/11/01
			//remove MinLevel part, use NeedRecalculation__c part       	
           pcUsrRole.updateProfitCenterForMinLevelRecords(Trigger.New); 
                    
        }
    /**********************************Trigger after insert block ends here***************************/
        
        /**********************************Trigger after update block starts here***************************/
        
        if(Trigger.IsUpdate)
        {
           pcUsrRole.updateProfitCenterForMinLevelRecords(Trigger.new);
           
        }
                /**********************************Trigger after update block ends here***************************/
        if(Trigger.IsDelete)
        {
            pcUsrRole.updateProfitCenterForMinLevelRecords(Trigger.old);
        }       
    
    }
        /****************************Trigger After action block ends here**********************************************/
       

}