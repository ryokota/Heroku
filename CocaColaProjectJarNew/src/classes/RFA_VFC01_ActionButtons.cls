/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VFC01_ActionButtons extends RFA_Util_SecurityMatrix
 *  Author           : Accenture
 *  Version History  : 2.0
 *  Creation         : 05/15/2012
 *  Assumptions      : N/A
 *  Description      : Controller Class for the RFA_VFP01_ActionButtons visualforce page. This class will determine the button Label for the Send to 
                       Circulation Button and also the Button Rendering logic based on Logged in User's Role on the RFA
                       The class extends the RFA_Util_SecurityMatrix class to check the Logged in User's access level and permission on RFA.                  
 * Change History    : Method performAction() and innerClass ErrorDisplay have been depricated and moved to other class (Applied On 7/18/2012)  
   
 * Updated by Jia Hu on 2013/11/01
 * Unnecessary levels removed               
 * Previous Level removed 
 * Coordinator removed, considering using Final Approval   
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
//Controller of Page: RFA_VFP08_ActionButtonTop/RFA_VFP09_ActionButtonBottom
global class RFA_VFC01_ActionButtons extends RFA_Util_SecurityMatrix{
 /*~~~~Intializing Variables~~~~*/
	//class: RFA_AP07_PageButtonWrapper 
    public List<RFA_AP07_PageButtonWrapper>     pageButtonList {get; private set;}
    public RFA__c                               rfaObj {get; private set;}
    public String                               labelClicked {get; set;}  
    public boolean                              displaypushCirculationButton {get; private set;}
    public boolean                              displayOverridePopup {get; private set;}
    public boolean                              displayCompletionMemo {get; private set;}
    public boolean                              displayCompleteRFA {get; private set;}
    public boolean                              displayRecomButton {get; private set;}
    public boolean                              displayNotesAndAttachment {get; private set;} //added by Ashwani for FR1.70
    
    //added by Jia Hu on 2013/12/02
    public boolean								displayRequesterClose {get; private set;}
    
    //level removed by Jia Hu on 2013/11/29
    //private String                              currentLevel;
    //private String                              previousLevel;
    //private String                              nextLevel;
    
    private UserAccess                          uAccess;  //from Apex: RFA_Util_SecurityMatrix
    Set<Id> UserAccessSet 						= new Set<Id>();
    
    public static Map<String, String> stagemap = new Map<String, String>();     
    
    // RFA_CL001: CCEJ  RFA_CL002: Business Unit  RFA_CL003: Group
    // RFA_CL004: Corporate  RFA_CL005: Executive RFA_CL006: Senior Executive
    /*
    private static Map<String, String> nextLevelMap = new Map<String, String>{
    	System.Label.RFA_CL001 => System.Label.RFA_CL001 //need to confirm
          //System.Label.RFA_CL001 => System.Label.RFA_CL002,
          //System.Label.RFA_CL002 => System.Label.RFA_CL003,
          //System.Label.RFA_CL003 => System.Label.RFA_CL004,
          //System.Label.RFA_CL004 => System.Label.RFA_CL005,
          //System.Label.RFA_CL005 => System.Label.RFA_CL006
    };
    */
    
    /*~~~~End of Variable Intialization~~~~*/
    
           
    //Constructor for the Class
    //Start of Contructor
    public RFA_VFC01_ActionButtons(ApexPages.StandardController controller) 
    {
        super(controller);
        this.rfaObj = (RFA__c)controller.getRecord();
        this.pageButtonList = new List<RFA_AP07_PageButtonWrapper>();
               
        if(rfaObj.Id <> null)
        {
            for(RFA__Share rfs:[
            	select UserorGroupid, accesslevel 
            	from RFA__Share 
            	where parentid =: rfaobj.Id and (accesslevel = 'Edit' or accesslevel = 'All')
            ])
            {
            	if(rfs <> null) {UserAccessSet.add(rfs.UserorGroupid);}
            }
            
            if(UserAccessSet.size() > 0 
            	&& UserAccessSet.contains(UserInfo.getUserId()) 
            	|| (
            		RFAConstants.isRFAAdmin(UserInfo.getProfileId()) 
            		//RFAConstants.isRFAAdmin(strProfileName)
            		) 
            ){  
            	displayNotesAndAttachment = true;
            }
            
            //query RFA           
            rfaObj = getRFADetails(rfaObj);
            
            //next level/previous level removed by Jia Hu on 2013/11/29
            //RFA_CL001: CCEJ
            //if(rfaObj.Level__c.contains(System.Label.RFA_CL001))
            //{
            //    System.debug('######## Inside key operations if condition block ########');
            //    currentLevel = System.Label.RFA_CL001;
            //    nextLevel = nextLevelMap.get(currentLevel); 
            //}
            
            //removed by Jia Hu on 2013/11/01
            /*
            else if(rfaObj.Level__c.contains(System.Label.RFA_CL002))
            {
                currentLevel = System.Label.RFA_CL002;
                nextLevel = nextLevelMap.get(currentLevel);
            }
            else if(rfaObj.Level__c.contains(System.Label.RFA_CL003))
            {
                currentLevel = System.Label.RFA_CL003;
                nextLevel = nextLevelMap.get(currentLevel);
            }
            else if(rfaObj.Level__c.contains(System.Label.RFA_CL004))
            {
                currentLevel = System.Label.RFA_CL004; 
                nextLevel = nextLevelMap.get(currentLevel);
            }
            else if(rfaObj.Level__c.contains(System.Label.RFA_CL005) && !rfaObj.Level__c.contains(System.Label.RFA_CL006))
            {
                currentLevel = System.Label.RFA_CL005; 
                nextLevel = nextLevelMap.get(currentLevel);
            }
            else if(rfaObj.Level__c.contains(System.Label.RFA_CL006))
            {
                currentLevel = System.Label.RFA_CL006;  
                nextLevel = nextLevelMap.get(currentLevel);
            }
            */
            
            /*
            	removed by Jia Hu on 2013/11/07
            */
            //if(rfaObj.PreviousLevel__c <> null)
            //{
            	//RFA_CL001: CCEJ
                //if(rfaObj.PreviousLevel__c.contains(System.Label.RFA_CL001))
                //{
                    //System.debug('######## Inside key operations if condition block ########');
                    //previousLevel = System.Label.RFA_CL001;
                    //nextLevel = nextLevelMap.get(currentLevel); 
                //}
                
                //removed by Jia Hu on 2013/11/01
                /*
                else if(rfaObj.PreviousLevel__c.contains(System.Label.RFA_CL002))
                {
                    previousLevel = System.Label.RFA_CL002;
                    //nextLevel = nextLevelMap.get(currentLevel);
                }
                else if(rfaObj.PreviousLevel__c.contains(System.Label.RFA_CL003))
                {
                    previousLevel = System.Label.RFA_CL003;
                    //nextLevel = nextLevelMap.get(currentLevel);
                }
                else if(rfaObj.PreviousLevel__c.contains(System.Label.RFA_CL004))
                {
                    previousLevel = System.Label.RFA_CL004; 
                    //nextLevel = nextLevelMap.get(currentLevel);
                }
                else if(rfaObj.PreviousLevel__c.contains(System.Label.RFA_CL005) && !rfaObj.Level__c.contains(System.Label.RFA_CL006))
                {
                    previousLevel = System.Label.RFA_CL005; 
                    //nextLevel = nextLevelMap.get(currentLevel);
                }
                else if(rfaObj.PreviousLevel__c.contains(System.Label.RFA_CL006))
                {
                    previousLevel = System.Label.RFA_CL006;  
                    //nextLevel = nextLevelMap.get(currentLevel);
                }
                */
                
            //}//edn of if(rfaObj.PreviousLevel__c <> null) 
            
            //class RFA_Util_SecurityMatrix
            uAccess = getRFAUserAccess();
            system.debug('-------- getRFAUserAccess() In RFA_VFC01_ActionButtons: ' + uAccess);
            actionGate();
            
            system.debug('------- + displayRequesterClose: ' + displayRequesterClose + ' --- User Access : ' + uAccess);
        }
    }
    
    public RFA__c getRFADetails(RFA__c rfaObj)
    {
         return [
         	SELECT Comments__c, 
         	//ControlNumber__c, 
         	DataClassification__c, 
         	//LevelStage__c, 
         	//Level__c,
         	//LocalReferenceNumber__c,
         	Name, OwnerId,
            //PreviousLevel__c, 
            ProfitCenterName__c, ProfitCenterNumberName__c, ProfitCenterNumber__c,
            RecordTypeId, RequestAmountFunctionalCurrency__c,
            //RequestAmountUSD__c,
            Stage__c //, 
            //WACC__c 
            FROM RFA__c 
            WHERE Id = : rfaObj.Id LIMIT 1
         ];  
    }
       
    public pageReference actionGate()
    {      
        System.debug('\n User Access from the security matrix : ' + uAccess);
        //System.debug('\n Is local coordinator : ' + uAccess.isLocalCoordinator());
        System.debug('\n IS Approver : ' + uAccess.isApprover());
        System.debug('\n IS Agent : '  + uAccess.isAgent());
        System.debug('\n IS Admin : ' + uAccess.isAdmin());
        System.debug('\n IS Requester : ' + uAccess.isRequester());
        //System.debug('\n Current level of the RFA : ' + currentLevel);
        //System.debug('\n Next level of the RFA : ' + nextlevel);
        //System.debug('\n Previous level of the RFA : ' + previousLevel);
        
        // reset all boolean variables for the display of button
        this.displaypushCirculationButton = false;
        this.displayOverridePopup = false;
        this.displayCompletionMemo = false;
        this.displayCompleteRFA = false;
        this.displayRecomButton = false;
        this.displayRequesterClose = false; //added by Jia Hu on 2013/12/02
        
        //
    	//controlling Buttons displayed on the VF page
        //****************** RFA IN DRAFT STAGE ***************************
        //RFA_STAGE_DRAFT = Label.RFA_CL083; //Draft
        if(rfaObj.Stage__c == RFAConstants.RFA_STATUS_DRAFT
        	//RFAGlobalConstants.RFA_STAGE_DRAFT
        )
        {
        	//added by Jia Hu on 2013/11/29
        	if(uAccess.isRequester()) {
        		displaypushCirculationButton = true;
        		displayRequesterClose = true;
        	}
        	
        	//not just remove the button, should move the process to Circulation !!??
        	//removed by Jia Hu on 2013/11/29
            //if( uAccess.isLocalCoordinator() || uAccess.isAdmin() || uAccess.isRequester() )
            	//revised by Jia Hu on 2013/10/24 
            //	pageButtonList.add(new RFA_AP07_PageButtonWrapper('Send to Coordinator', '_top', true, true));
                //pageButtonList.add(new RFA_AP07_PageButtonWrapper('Send to' + ' ' +currentLevel+ ' '+ 'Coordinator', '_top', true, true));
            
            //if( uAccess.isLocalCoordinator() || uAccess.isAdmin() )                    
            if( uAccess.isAdmin() 
            	//|| uAccess.isApprover()  //noly for Admin
              )    
                this.displayOverridePopup = true;
                //this.displayRequesterClose = false; //removed then OK??!!
        }
        
        //Pre-Circulation stage is removed by Jia Hu on 2013/11/29
        /*       
        // **************** RFA IN PRE-CIRCULATION STAGE *****************
        //RFA_PRE_CIRCULATION_STAGE = Label.RFA_CL038; //Pre-Circulation
        else if(rfaObj.Stage__c == RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE)
        {
            if(uAccess.isLocalCoordinator() || uAccess.isAdmin())
            {
                this.displaypushCirculationButton = true;
                this.displayCompleteRFA = true;
                this.displayOverridePopup = true;
            }               
        }
        */
        
        // **************** RFA IN CIRCULATION STAGE *********************
        //RFA_CIRCULATION_STAGE = Label.RFA_CL041; //Circulation
        else if(rfaObj.Stage__c == RFAConstants.RFA_STATUS_CIRCULATION
        	//RFAGlobalConstants.RFA_CIRCULATION_STAGE
        	)
        {
        	//system.debug('-------- rfaObj.Stage__c == RFAGlobalConstants.RFA_CIRCULATION_STAGE ');
            if(
                //uAccess.isApprover() 
            	//|| 
            	uAccess.isAdmin()
              )
            //if(uAccess.isLocalCoordinator() || uAccess.isAdmin())
            {
            	system.debug('------ RFA_CIRCULATION_STAGE Stage: ' + rfaObj.Stage__c + '  User Access: ' + uAccess);
                this.displaypushCirculationButton = false;
                //this.displayCompleteRFA = true;
                this.displayOverridePopup = true;   
                this.displayCompletionMemo = false;     
                this.displayCompleteRFA = false;      
                this.displayRequesterClose = false; //added by Jia Hu on 2013/12/02          
            }
            /* don't need this?
            if(uAccess.isApprover() 
            	//|| uAccess.isAdmin()
              )
            //if(uAccess.isLocalCoordinator() || uAccess.isAdmin())
            {
            	system.debug('------ RFA_CIRCULATION_STAGE Stage: ' + rfaObj.Stage__c + '  User Access: ' + uAccess);
                this.displaypushCirculationButton = false;
                //this.displayCompleteRFA = true;
                this.displayOverridePopup = false;   
                this.displayCompletionMemo = false;     
                this.displayCompleteRFA = false;      
                this.displayRequesterClose = false; //added by Jia Hu on 2013/12/02          
            }  */          
            
            if(uAccess.isApprover() || uAccess.isAgent()) {
            	this.displayRecomButton = true;
            	this.displayRequesterClose = false;
            }    
        }
        
        /* POST-CIRCULATION STAGE removed by Jia Hu on 2013/11/29
        // *************** RFA IN POST-CIRCULATION STAGE ******************
        //RFA_POST_CIRCULATION_STAGE = Label.RFA_CL039; //Post-Circulation
        else if(rfaObj.Stage__c == RFAGlobalConstants.RFA_POST_CIRCULATION_STAGE)
        {
            if(uAccess.isLocalCoordinator() || uAccess.isAdmin())
            {
                this.displayOverridePopup = true;
                this.displayCompleteRFA = true;
                this.displayCompletionMemo = false;
                this.displayRecomButton = false;
                this.displaypushCirculationButton = false;
                
                //removed by Jia Hu on 2013/11/01   don't need 'send to next level' logic
                //if(nextLevel <> null)pageButtonList.add(new RFA_AP07_PageButtonWrapper('Send to Coordinator', '_top', true, true));
                //if(nextLevel <> null)pageButtonList.add(new RFA_AP07_PageButtonWrapper('Send to' + ' ' +nextLevel + ' '+ 'Coordinator', '_top', true, true));
            }   
        } */
        
        // *************** RFA IS APPROVED OR REJECTED OR CLOSED *********
        else if(rfaObj.Stage__c == RFAConstants.RFA_STATUS_APPROVED
        		//RFAGlobalConstants.RFA_STAGE_APPROVED 
        	|| rfaObj.Stage__c == RFAConstants.RFA_STATUS_REJECTED
        		//RFAGlobalConstants.RFA_STAGE_REJECTED 
        	|| rfaObj.Stage__c == RFAConstants.RFA_STATUS_CLOSED
        		//RFAGlobalConstants.RFA_STAGE_CLOSED
        	)
        {
        	system.debug('----- Stage: ' + rfaObj.Stage__c);
        	//system.debug('----- isLocalCoordinator(): ' + uAccess.isLocalCoordinator() 
        	//	+ ' ' + Userinfo.getLanguage() + ' ' + Userinfo.getProfileId() + ' ' + Userinfo.getUserName());
        		
            //if(uAccess.isLocalCoordinator() || uAccess.isAdmin())
            if(uAccess.isAdmin())
            {
                //this.displayOverridePopup = true; //removed by Jia Hu on 2013/12/03
                this.displayCompleteRFA = false;  
                this.displayCompletionMemo = false; //true -> false 
                this.displayRecomButton = false;    
                this.displaypushCirculationButton = false;   
                this.displayRequesterClose = false;           
            }       
        }
        
        /* PENDING BOARD REVIEW and CAPITAL MANAGEMENT HOLD removed by Jia Hu on 2013/11/29
        // ************** RFA IS IN PENDING BOARD REVIEW *****************                     
        if(rfaObj.Level__c == RFAGlobalConstants.PENDING_BOARD_REVIEW)
        {
            if(uAccess.isAdmin())
            {
                
                this.displayRecomButton = false; 
                this.displayOverridePopup = true;
                if(rfaObj.Stage__c == RFAGlobalConstants.RFA_STAGE_APPROVED 
                	|| rfaObj.Stage__c == RFAGlobalConstants.RFA_STAGE_REJECTED 
                	|| rfaObj.Stage__c == RFAGlobalConstants.RFA_STAGE_CLOSED
                  )
                {
                    this.displayCompleteRFA  = false;
                    this.displayCompletionMemo = true;  
                }
                else
                {
                    this.displayCompleteRFA  = true;
                    this.displayCompletionMemo = false;  
                
                }
                this.displaypushCirculationButton = false;
            }
                
        }
        // ************** RFA IN CAPITAL MANAGEMENT HOLD ****************
        else if(rfaObj.Level__c == RFAGlobalConstants.CAPITAL_MGMT_HOLD)
        {
            if(uAccess.isAdmin() || uAccess.isLocalCoordinator())
            {
                this.displayOverridePopup = true;               
                this.displayRecomButton = false;                 
                this.displayCompletionMemo = false;  
                this.displayCompleteRFA  = false;   
                this.displaypushCirculationButton = false;      
            }
        } 
        */
        
        // **************** RFA IN RETURN TO SENDER **********************
        //else if(rfaObj.Level__c == RFAGlobalConstants.RETURN_TO_SENDER)
        //updated by Jia Hu on 2013/11/29 same with RFA_STAGE_DRAFT?
        else if(rfaObj.Stage__c == RFAConstants.RFA_STATUS_ReturnToRequester
        	//RFAGlobalConstants.RETURN_TO_SENDER
        	)
        {
        	//if(uAccess.isLocalCoordinator() || uAccess.isAdmin() || uAccess.isRequester())
            //if(uAccess.isAdmin() || uAccess.isRequester()) {
            //    pageButtonList.add(new RFA_AP07_PageButtonWrapper('Send to Coordinator', '_top', true, true));
                //pageButtonList.add(new RFA_AP07_PageButtonWrapper('Send to' + ' ' +previousLevel+ ' '+ 'Coordinator', '_top', true, true));
        	//}
            
            //if(uAccess.isLocalCoordinator() || uAccess.isAdmin()) {
            if(
            	//uAccess.isLocalCoordinator() || 
            	uAccess.isAdmin()) {
                this.displayOverridePopup = true;   
                this.displayRequesterClose = false;
            }
            //added by Jia Hu on 2013/11/29
            if(uAccess.isRequester()) {
        		displaypushCirculationButton = true;
        		displayRequesterClose = true; //added by Jia Hu on 2013/12/02
        	}
                
        }         
        
        System.debug('\n ******************Page Button List :'+pageButtonList);
        return null;          
    }
    
    public Integer pageButtonListSize{
        get{
            return pageButtonList.size();
        }
        private set;
    }
  

}