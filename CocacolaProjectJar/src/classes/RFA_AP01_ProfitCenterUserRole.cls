/*   
 *  Class            : RFA_AP01_ProfitCenterUserRole
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 31/05/2012
 *  Assumptions      : N/A
 *  Description      : To - Do
 *
 *  updated by Jia Hu on 2013/11/01
 *  unnecessary levels are removed                                   
 */
//called by PUR_ProfitCenterUserRoleTrigger on ProfitCenterUserRole__c
//VF page: RFA_VFP10_ProfitCenterRecalculation 
//extensions="RFA_VFC10_ProfitCenterRecalculation" action="{!callRecalculationMethod}"
//will recuculate the sharing on the Profit Center
//NeedRecalculation__c is used 
public class RFA_AP01_ProfitCenterUserRole
{
    /**
     * Constructor
     */
    public RFA_AP01_ProfitCenterUserRole()
    {
    }
    
    /*~~~~Start of Initialization~~~~*/
    public Map<Id , ProfitCenterUserRole__c > ProfitCenterErrorStatus = new Map<Id, ProfitCenterUserRole__c >();
    public Map<Id, List<ProfitCenterUserRole__c>> profitCenterMap = new Map<Id, List<ProfitCenterUserRole__c>>();
    public Set<Id> profitCenterIds = new Set<Id>(); 
    /*~~~~End of Initialization~~~~*/
    
    /**
     *  processRecords method
     *  @param profitCenterUserRoleList, processItem( Trigger.new,Trigger.old)
     *  @return Database.Querylocator
     */
     //removed by Jia Hu on 2013/12/07
    //only Admin Profiles and Coordinator can insert/update/delete Profit Center Users 
    /*
    public void processRecords(list<ProfitCenterUserRole__c> profitCenterUserRoleList, String processItem)
    {         
        for(ProfitCenterUserRole__c profitCenterUserRole : profitCenterUserRoleList)
        {
               profitCenterIds.add(profitCenterUserRole.ProfitCenter__C); 
        }
        //PC_USERTYPE_LC=Label.RFA_CL065: Coordinator
        for(ProfitCenter__c profitCenter: [
        	Select Id, 
        		(Select id, UserName__c,
        			//Level__c,
        			Usertype__c 
        			from Profit_Center_Associated_Users__r 
        			where UserType__c =: RFAGlobalConstants.PC_USERTYPE_LC 
        				and UserName__c =: UserInfo.getUserId() 
        			//order by level__c desc 
        			limit 1
        		)
        	, name 
        	from ProfitCenter__c where Id IN:profitCenterIds ]
        	)
         {
         	if(!profitCenter.Profit_Center_Associated_Users__r.IsEmpty())
            	profitCenterMap.put(profitCenter.Id, profitCenter.Profit_Center_Associated_Users__r);            
         
         }
         
         
         for(ProfitCenterUserRole__c profitCenterUserRole : profitCenterUserRoleList)
         {
             Boolean allowAccess = false;
             if(!profitCenterMap.IsEmpty())
             {
             	for(ProfitCenterUserRole__c tempMap : profitCenterMap.get(profitCenterUserRole.profitCenter__c) )
              	{
                    
                    if (processItem =='Trigger.New'  || processItem =='Trigger.Update')
                    {
                            if(tempMap.UserName__C == UserInfo.getUserId() )
                            {
                                   allowAccess = True;
                            }
                            
                            if((tempMap.UserName__C == UserInfo.getUserId() 
                           		&& tempMap.UserType__c != RFAGlobalConstants.PC_USERTYPE_LC) )
                            {
                                if(processItem == 'Trigger.New')
                            	{
                            		profitCenterUserRole.addError(RFAGlobalConstants.INSUFFICIENT_PERMISSION);
                            	}
                            	else if(processItem == 'Trigger.Update')
                            	{
                            		ProfitCenterUserRole__c pcur = (ProfitCenterUserRole__c)Trigger.newMap.get(profitCenterUserRole.Id);
                                   	pcur.addError(RFAGlobalConstants.INSUFFICIENT_PERMISSION);
                            	}
                                                                                                   
                            }                                                         
                    
                    }
            
                    else if(processItem =='Trigger.Old' )
                    {
                             if(tempMap.UserName__C == UserInfo.getUserId()  )
                             {
                                       allowAccess = True;                                
                             }
                             
                    }
              	}
                }
                
                //consider to move this part?!
                if(allowAccess == false)
                {
                	if(processItem == 'Trigger.Update')
                	{
                		  ProfitCenterUserRole__c pcur 
                		  	= (ProfitCenterUserRole__c)Trigger.newMap.get(profitCenterUserRole.Id);
                          pcur.addError(RFAGlobalConstants.INSUFFICIENT_EDIT_PERMISSION);
                          //'You can only edit users in Levels below yours for this Profit Center'; 
                	}
                   	else
                   	{	//User is not part of this Profit Center.
                   		profitCenterUserRole.addError(RFAGlobalConstants.EXCEPTION_NOT_PART_OF_PC);
                   	}                    
                }            
         }                 
    }//end of processRecords;
    */
    
	//only used for updating NeedRecalculation__c on Profit Center
    public void updateProfitCenterForMinLevelRecords(list<ProfitCenterUserRole__c> profitCenterUserRoleList)
    {
        //~~~~Start of Initialization~~~~        
        List<profitCenter__c> profitCenterList = new List<ProfitCenter__c>();
        Set<Id> profitCenterIds = new Set<Id>();
        Map<Id, ProfitCenterUserRole__c> profitCenterMap = new Map<Id, ProfitCenterUserRole__c>();
        //~~~~End of Initialization~~~~
        
        //********fetching all the profit center Ids
        for(ProfitCenterUserRole__c profitCenterUserRole: profitCenterUserRoleList)
        {
               profitCenterIds.add(profitCenterUserRole.ProfitCenter__C);
        }
                
        //*****************Add Min level and Recalculation flag to profit center block starts here*********************        
        /*
        for(ProfitCenter__C profitCenter:[
        	Select id //, 
        		//MinLevel__C,
        		//(Select id, UserName__c, 
        		//Level__c, 
        		//Usertype__c from Profit_Center_Associated_Users__r 
        		//where Usertype__c =: RFAGlobalConstants.PC_USERTYPE_LC //Coordinator 
        		//order by Level__c ASC 
        		//limit 1
        		//) 
        	from ProfitCenter__C where Id In: profitCenterIds
        	]
           )
        {
        	if(!profitCenter.Profit_Center_Associated_Users__r.IsEmpty()) {
            	profitCenterMap.put(profitCenter.Id,profitCenter.Profit_Center_Associated_Users__r);
        	}
        }*/
			        
        for(Id tempProfitCenterId:profitCenterIds)
	    {
	    	ProfitCenter__c profitCenter = new ProfitCenter__c(id = tempProfitCenterId);
	    			//if(!profitCenterMap.IsEmpty())
	                	//profitCenter.MinLevel__c = profitCenterMap.get(tempProfitCenterId).Level__c;  // update the min level
	    			//else
	    				//profitCenter.MinLevel__c='';
	         profitCenter.NeedRecalculation__c = true;  // update the flag to ture for recalculation the sharing model
	         profitCenterList.add(profitCenter);
	    }
        
        //*****************Add Min level and Recalculation flag to profit center block Ends here*********************
		        
        // Update the profit Center list
        if(profitCenterList.Size() > 0)
        {
            update profitCenterList;
        }
  
    }//end of updateProfitCenterForMinLevelRecords;    
    
    
}