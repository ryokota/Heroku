public class Milestone1_ToDoTagComponentCtrl {
	
	public String taskId {get;set;}
	public Milestone_BI_TagCtrl selfReference  {get;set;}
	public Milestone_ToDo_Tag__c inTag {get;set;}
	public String inputTag {get;set;}
	
	public Milestone1_ToDoTagComponentCtrl(){
		inTag = new Milestone_ToDo_Tag__c();
	}
	public Pagereference addSave(){
		if (inTag.Task__c == null){
			system.debug('***************inTag.Task__c : '+inTag.Task__c);
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'error。'));//system.Label.Custom_Milestone_PreTaskComplete_err));
		}
		insert inTag;
		if(inputTag != null && inputTag.length() > 0){
			List<Milestone_ToDo_Tag__Tag> tagList = new List<Milestone_ToDo_Tag__Tag>();
			for(String str : inputTag.split(',')){
				Milestone_ToDo_Tag__Tag tagObj = new Milestone_ToDo_Tag__Tag(ItemId=inTag.Id, Name=str, Type='Public');
				tagList.add(tagObj);
				
			}
			if(tagList.size() > 0) {
				insert tagList;
				//for(Milestone_ToDo_Tag__Tag t : tagList){
				//	selfReference.editLinkTagData(t.itemId, t.TagDefinitionId, t.Name, selfReference.todoTagsMap, selfReference.paramTodoMap);
				//}
			}
			
		}
		//List<Milestone_ToDo_Tag__c> tempList = new List<Milestone_ToDo_Tag__c>();
		//tempList.add(inTag);
		//selfReference.toDoMap.put(inTag.Task__c, tempList);
		//for(Milestone_ToDo_Tag__Tag t : [Select ItemId, TagDefinitionId, Name From Milestone_ToDo_Tag__Tag Where ItemId= :inTag.Id]){
		//	selfReference.editLinkTagData(t.itemId, t.TagDefinitionId, t.Name, selfReference.todoTagsMap, selfReference.paramTodoMap);
		//}
		
		return null;
	}
}