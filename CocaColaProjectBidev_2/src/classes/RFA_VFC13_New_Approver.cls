/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFA_VFC13_New_Approver
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 28/5/2013 
 *  Assumptions      : N/A
 *  Description      : Class to implement the logic on the New Approver Page. 
 *
 *  updated by Jia Hu on 2013/11/06
 *  called from VF page: RFA_VFP13_New_Approver
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
public with sharing class  RFA_VFC13_New_Approver {
    
    public RFAUserRole__c rfaUserObj { get; set; }
    private String oldUsername;
    
    // instantiate new rfa_AP02_ShareUtil
    private RFA_AP02_Shareutil shareUtil=new RFA_AP02_Shareutil();
    
    // Get RecordTypes associated to RFAUser Role
    public static Map<String, RecordType> approverRecordTypeMap = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());
    
    
    public RFA_VFC13_New_Approver(ApexPages.StandardController controller) {

          //Query the record values in case Edit page is opened

          ID  id = ApexPages.currentPage().getParameters().get('id');
          if(ID<>NULL)
              rfaUserObj = [Select UserName__c,RecordTypeId,
              	//Level__c,
              	RFA__c, DoNotSendEmail__c, Notifyuserfirsttime__c, NotifyUsers__c, 
              	ApprovalRecommendation__c, ApprovalComments__c, Agent1__c, Agent2__c, Agent3__c, 
              	Name, ApprovalOrder__c 
              	from RFAUserRole__c where Id =:id] ;
          
          else
              rfaUserObj = (RFAUserRole__c)controller.getRecord();
          
          oldUsername = rfaUserObj.Username__c;
          
          /* GA 5/20/13 : 2013 Q1 Enhancement FR 1.22
           * The following is logic to handle changing RFA Approver/User object record type but this is now commented out.
           * The reason this code is commented out is because Record Type updating should not be supported per object validation rule RUR_VR09_Lock_RecordType.
           
          String pageRecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
          String rfaUserRecordTypeId = rfaUserObj.RecordTypeId;
          
          if (!rfaUserRecordTypeId.contains(pageRecordTypeId))
          {
                system.debug('enter update record type');
                rfaUserObj.RecordTypeId = (Id)pageRecordTypeId;
          }
           
          system.debug('Page Record Type Id: ' + pageRecordTypeId);
          system.debug('rfaUserRecordTypeId:' + rfaUserRecordTypeId);
          
          */
          
          system.debug('constructor: ' + rfaUserObj);
    }
    
    public PageReference dosave()
    {    
        try
        {
            // to handle if the return (Enter) key is pressed or save is clicked before queryAction can be invoked
            if (oldUsername != rfaUserObj.Username__c)
            {
                queryAgents();
            }
        
            upsert rfaUserObj ;
        }
        catch(exception e)
        {
           ApexPages.addMessages(e);
           return null;
        }  

        return new Pagereference('/' + rfaUserObj.get('Id'));
    }
    
    public PageReference doSaveAndNew()
    {
        try
        {
            if (oldUsername != rfaUserObj.Username__c)
            {
                queryAgents();
            }
            
            upsert rfaUserObj;
        }
        catch(exception e)
        {
           ApexPages.addMessages(e);
           return null;
        }  

        // string s = '/' + ('' + rfaUserObj.get('Id')).subString(0, 3) + '/e';
        string s = '/setup/ui/recordtypeselect.jsp?ent='+System.Label.RFA_CL145+'&retURL=%2F'+rfaUserObj.id+'&save_new_url=%2Fa0E%2Fe%3FCF'+System.Label.RFA_CL144+'%3DRFA%2523-0007566%26CF'+System.Label.RFA_CL144+'_lkid%3D'+rfaUserObj.rfa__c+'%26scontrolCaching%3D1%26retURL%3D%252F'+rfaUserObj.rfa__c;
        return new Pagereference(s);
    }
    
    public PageReference queryAgents()
    {
        try
        {
            oldUsername = rfaUserObj.Username__c;
            system.debug('QueryAgent() rfaUserObj.Username__c: ' + rfaUserObj.Username__c);
            User usr = [Select RFA_Agent_1__r.Name, RFA_Agent_2__r.Name , RFA_Agent_3__r.Name From User where Id = :rfaUserObj.Username__c];
            rfaUserObj.Agent1__c = usr.RFA_Agent_1__c;
            rfaUserObj.Agent2__c = usr.RFA_Agent_2__c;
            rfaUserObj.Agent3__c = usr.RFA_Agent_3__c;
            system.debug('User Agents 1  ' +usr.RFA_Agent_1__c);
            system.debug('User Agents 2  ' +usr.RFA_Agent_2__c);
            system.debug('User Agents 3  ' +usr.RFA_Agent_3__c);
        }
        catch(exception e)
        {
           ApexPages.addMessages(e);
        }  

        return null;
    }
    
 
    
}