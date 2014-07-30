/*
	Created by Jia Hu on 2013/11/29
	Reference: RFA_RF1_50_LocationCoordinator_V2
	Controller of VF page: RFA_Button_ApproverList
*/
public with sharing class RFA_VFC_ApproverListController {
	
	private integer counter = 0;  //keeps track of the offset
    private integer list_size = 100; //sets the page size or number of rows
    public integer total_size; //used to show user the total size of the list
    
  	public List<ProfitCenterUserRole__c> LocationCoordinators { 
  		get {return sortList(LocationCoordinators);} 
  		set; }		

  	public List<RFAUserRole__c> Approvers { 
  		get {return sortList(Approvers);} 
  		set; } 
  		
  	public String sortBy { get; set; }
  	public String sortDir { get; set; }
  	
  	// instance of RFA__c
    public RFA__c rfaObj{ get; set;}
    
    public RFA_VFC_ApproverListController(ApexPages.StandardController controller) {
    	this.rfaObj = (RFA__c)controller.getRecord();
        
        /*
        if(rfaObj.Id <> null) {
        	this.rfaObj = [
        		Select ProfitCenterNumber__c,ProfitCenterName__c,ProfitCenterNumber__r.name
                FROM RFA__c 
                WHERE Id =: rfaObj.id
            ];
        }*/
        
		//Approver: 01210000000QsJj
		Id approverRTId = RFAConstants.getRecordType(
			RFAConstants.RTLabel_RFAUserRole_Approver, 
			RFAConstants.Obj_RFAUserRole_APIName
			);
			
		//total_size = [select count() from RFAUserRole__c where RFA__c =: rfaObj.Id And RecordTypeId =: approverRTId 
			//'01210000000QsJj'
		//	];
		
		//LocationCoordinators = [
		Approvers = [
			Select UserName__c, 
				UserName__r.Name, UserName__r.Lastname, UserName__r.Firstname, 
				UserName__r.COA_Acronym__c, UserName__r.COA_Group__c,
				UserName__r.L2_Function_E__c, UserName__r.L3_Function_E__c, UserName__r.L4_Function_E__c,
				RecordType.Name, RecordTypeId, 
				ApprovalRecommendation__c, ApprovalComments__c,
				ApprovalOrder__c, Approver_Source__c, AgentsAssigned__c
			from RFAUserRole__c where RFA__c =: rfaObj.Id And RecordTypeId =: approverRTId 
			//'01210000000QsJj'
			order by ApprovalOrder__c ASC, UserName__r.Name ASC
			];
		
		if(Approvers != null && Approvers.size() > 0) {
			total_size = Approvers.size();
		} else {
			total_size = 0;
		}
		
		  
    }
	    
   	public PageReference empty() { return null; }

  
  	// The sorting function works on all SObjects sorting on all fields
  	public List<SObject> sortList(List<SObject> cleanList)
  	{
  		if (sortBy == null) { return cleanList; }
    	List<SObject> resultList = new List<SObject>();
    	Map<Object, List<SObject>> objectMap = new Map<Object, List<SObject>>();
    	for (SObject item : cleanList) {
      		if (objectMap.get(item.get(sortBy)) == null) {
        		objectMap.put(item.get(sortBy), new List<SObject>());
      	}
      	objectMap.get(item.get(sortBy)).add(item);
    	}
    	List<Object> keys = new List<Object>(objectMap.keySet());
    	keys.sort();
    	for(Object key : keys) {
      		resultList.addAll(objectMap.get(key));
    	}
    	cleanList.clear();
    if (sortDir == 'ASC') {
      for (SObject item : resultList) {
        cleanList.add(item);
      }
    } else {
      for (Integer i = resultList.size()-1; i >= 0; i--) {
        cleanList.add(resultList[i]);
      }
    }
  
    return cleanList;
  }   
  
    public PageReference Beginning() { //user clicked beginning
      counter = 0; 
      return null;
   }
 
   public PageReference Previous() { //user clicked previous button
      counter -= list_size; 
      return null;
   }
 
   public PageReference Next() { //user clicked next button
      counter += list_size; 
      return null;
   }
 
   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      return null;
   }
 
   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }
 
   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }
 
   public Integer getTotal_size() {
      return total_size;
   }
 
   public Integer getPageNumber() {
      return counter/list_size + 1;
   }
 
   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }

}