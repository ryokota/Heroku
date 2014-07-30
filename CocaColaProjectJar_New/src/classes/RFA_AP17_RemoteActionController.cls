/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_AP17_RemoteActionController 
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 07/18/2012
 *  Assumptions      : N/A
 *  Description      : This class containes a webservice method to process RFA updates from javascript.
 *
 *	updated by Jia Hu on 2013/11/01
 *	called from Component: RFA_C01_DynamicButton --> function callControllerMethod(labelClicked)   
 *  --> Component: RFA_C07_PageButtonSection                                   
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
global class RFA_AP17_RemoteActionController {
    
    // Inner class. 
    global class ErrorDisplay
    {
        public String errorDetail;        
        public String componentLabel;        
        public String summary;
        
        public ErrorDisplay(String errorDetail, String componentLabel, String summary)
        {
            this.errorDetail = errorDetail;           
            this.componentLabel = componentLabel;            
            this.summary = summary; 
        }   
    }

     /**
      *  @ Description : Webservice method to process RFA updates.
      *  @ param : String, String
      *  @ return : String
      */ 
    webService  static String performAction(String rfaId, String labelClicked)
    {        
        System.debug('\n label clicked by the user::::: ' + labelClicked + '!@@@@@@@RFAID@@@' + rfaId);
        
        //String errMsg = null;
        
        pageReference pref = null;
        
        List<ErrorDisplay> errorList = new List<ErrorDisplay>();
        
        boolean hasPageMessage = false;
        
        String serializedErrorMsg;
        
        //Savepoint sp = Database.setSavepoint
        
        try{
        	RFA__c rfaObjTemp = new RFA__c(Id = rfaId);   
       
		//SEND_TO_PRE_CIRCULATION = Label.RFA_CL085; //Send to Pre-Circulation  
		/*      	        
        if(labelClicked == RFAGlobalConstants.SEND_TO_PRE_CIRCULATION)
        {
        	//RFA_PRE_CIRCULATION_STAGE = Label.RFA_CL038; //Pre-Circulation
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            //update rfaObjTemp;           
        }
        */
        //else if(labelClicked == RFAGlobalConstants.RETURN_TO_SENDER)
        if(labelClicked == RFAConstants.RFA_STATUS_ReturnToRequester
        	//RFAGlobalConstants.RETURN_TO_SENDER
        	)
        {
            rfaObjTemp.Stage__c = RFAConstants.RFA_STATUS_ReturnToRequester;
            	//RFAGlobalConstants.RETURN_TO_SENDER;
            //update rfaObjTemp;
        }
        //else if(labelClicked == 'Send to '+ System.Label.RFA_CL001+' Coordinator') //need to confirm !?
        /*
        else if(labelClicked == 'Send to Coordinator')
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            
            //rfaObjTemp.Level__c = '1. '+System.Label.RFA_CL001;
            rfaObjTemp.Level__c = System.Label.RFA_CL001; //CCEJ
            //update rfaObjTemp;
        }
        */
        else if(labelClicked == RFAConstants.Button_Send_To_Circulation
        	//'Send to Circulastion'
        	)
        {
            rfaObjTemp.Stage__c = RFAConstants.RFA_STATUS_CIRCULATION;
            	//RFAGlobalConstants.RFA_CIRCULATION_STAGE;
        }        
        
        //removed by Jia Hu on 2013/11/01
        /*
        else if(labelClicked == 'Send to '+System.Label.RFA_CL002+' Coordinator')
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            rfaObjTemp.Level__c = '2. '+System.Label.RFA_CL002; //RFA_CL002: Business Unit
            //update rfaObjTemp;
        }
        else if(labelClicked == 'Send to '+System.Label.RFA_CL003+' Coordinator')
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            rfaObjTemp.Level__c = '3. '+System.Label.RFA_CL003; //RFA_CL003: Group
            //update rfaObjTemp;
        }
        else if(labelClicked == 'Send to '+System.Label.RFA_CL004+' Coordinator')
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            rfaObjTemp.Level__c = '4. '+System.Label.RFA_CL004; //RFA_CL004: Corporate
            //update rfaObjTemp;
        }
        else if(labelClicked == 'Send to '+System.Label.RFA_CL005+' Coordinator')
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            rfaObjTemp.Level__c = '5. '+System.Label.RFA_CL005; //RFA_CL005: Executive
            //update rfaObjTemp;
        }
        else if(labelClicked == 'Send to '+System.Label.RFA_CL006+' Coordinator')
        {
            rfaObjTemp.Stage__c = RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE;
            rfaObjTemp.Level__c = '6. '+System.Label.RFA_CL006; //RFA_CL006: Senior Executive
            //update rfaObjTemp;
        }
        */
        
        Database.update(rfaObjTemp);
        		
        } catch(DMLException dme)
        {       	
        	serializedErrorMsg = dme.getDMlMessage(0);	        	
        	return serializedErrorMsg;		
        } 
        
        return serializedErrorMsg;  
    }
    
}