/*  
 *  Author           : Pasona-Tquila
 *  Version History  : 1.0
 *  Creation         : 2013/12/10                                
 */
public with sharing class RFAUtility {
	
	/*
	 ***************** COA ****************
	 */
	/*
		Group No. or Acronym Number
	*/
	public static Boolean GroupOrUser(String str) {
		if(str == RFAConstants.Group1
			//'Gr.1'
			) {
			return true;
		} else if(str == RFAConstants.Group2) {
			return true;
		} else if(str == RFAConstants.Group3) {
			return true;
		} else if(str == RFAConstants.Group4) {
			return true;
		} else if(str == RFAConstants.Group5) {
			return true;
		} else if(str == RFAConstants.Group6) {
			return true;
		}		
		return false;
	}
	
	//for left bracket
	public static Integer GreaterThanOrEqualTo(String str) {
		if(str == '>') {
			return 1;
		} else if (str == '>=') {
			return 2;
		}
		return 0;
	}

	//for right bracket
	public static Integer LessThanOrEqualTo(String str) {
		if(str == '<') {
			return 3;
		} else if (str == '<=') {
			return 4;
		}
		return 0;		
	}	

	/*
	 ***************** RFA ****************
	 */	

    /**
     *  isNotRequestorWithEditOnRFA(Set<Id> RFA) method
     *  Checks if logged in user is a user with edit access to an RFA ignoring Requestor type
     *  @return Map<Id, Boolean> RFA id, Boolean true = is user with write access and not requestor. else, false
     */
    //Moved from global class RFA_WS07_CheckRFAUser 
    public static Map<Id, Boolean> ignoreRequestorWithEditOnRFA(Set<Id> rfaIds)
    {
		Set<Id> rfaIsLC = new Set<Id>(); // used to store unique RFA Ids which logged in user has edit access to and is not a requestor.
		Map<Id, Boolean> toReturn = new Map<Id, Boolean>(); // will be the Map which is returned at the end of this method
		
		//RFA_CL076: KORequestor
		String requestorRowCause = RFAConstants.RowCause_Requestor; //Label.RFA_CL076 + '__c'; // KORequestor__c

    	for (RFA__Share rfaLCUser: [
    		Select id, ParentId from RFA__Share where 
    			RowCause !=: requestorRowCause 
    			AND UserOrGroupId =: UserInfo.getUserId() 
    			AND ParentId IN : rfaIds 
    			AND AccessLevel = 'Edit']
    		)
    	{
    		rfaIsLC.add(rfaLCUser.ParentId);
    	}
    	
    	// build Map<Id, Boolean> toReturn
    	for (Id rfaId: rfaIds)
		{
			if (rfaIsLC.contains(rfaId)) {
				toReturn.put(rfaId, true);
			} else {
				toReturn.put(rfaId, false);
			}
		}        
        return toReturn;
    }
    
}