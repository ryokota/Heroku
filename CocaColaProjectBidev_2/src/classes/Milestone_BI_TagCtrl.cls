public class Milestone_BI_TagCtrl {
	public String PROJECT_KIND {get {return 'Project';}set;}
	public String MILESTONE_KIND  {get {return 'Milestone';}set;}
	public String TASK_KIND {get {return 'Task';}set;}
	public String TODO_KIND {get {return 'ToDo';}set;}
	public Milestone_BI_TagCtrl selfReference {get;set;}
	public List<String> projectIds {get;set;}
	public List<String> taskIds {get;set;}
	public List<String> toDoIds {get;set;}
	public List<Milestone1_Project__c> pList {get;set;}
	public Map<Id, List<Milestone1_Task__c>> taskMap {get;set;}		//key : milestoneId
	public Map<Id, List<Milestone_ToDo_Tag__c>> toDoMap {get;set;}  //key : taskId
	public Map<Id, Integer> taskListCntMap {get;set;}
	public Map<Id, Integer> toDoListCntMap {get;set;}
	public Map<Id, String> taskTagsMap {get;set;}
	public Map<Id, String> todoTagsMap {get;set;}
	public Map<Id, String> paramTaskMap {get;set;}
	public Map<Id, String> paramTodoMap {get;set;}
	
	public String inputName {get;set;}
	public String inputTag {get;set;}
	public String inputNote {get;set;}
	public String hiddenId {get;set;}
	public String hiddenKind {get;set;}
	
	
	public Milestone_BI_TagCtrl(){
		doData();
	}
	
	//初期データ取得
	public void doData(){
		//初期インスタンス
		projectIds = new List<String>();
		taskIds = new List<String>();
		toDoIds = new List<String>();
		pList = new List<Milestone1_Project__c>();
		taskMap = new Map<Id, List<Milestone1_Task__c>>();
		toDoMap = new Map<Id, List<Milestone_ToDo_Tag__c>>();
		taskListCntMap = new Map<Id, Integer>();
		todoListCntMap = new Map<Id, Integer>();
		taskTagsMap = new Map<Id, String>();
		todoTagsMap = new Map<Id, String>();
		paramTaskMap = new Map<Id, String>();
		paramTodoMap = new Map<Id, String>();
		taskMap = new Map<Id, List<Milestone1_Task__c>>();
		//ProjectとMilestoneのデータを取得して格納する。
		pList = [Select Name, Id, Function__c 
				 From Milestone1_Project__c 
				 where RecordTypeId=:system.label.Project_RecordType_BI 
				 AND (Status__c ='Planning' or Status__c='Active')
				 ORDER BY Function__c];
		for(Milestone1_Project__c p : pList){
			String tempId = String.valueOf(p.Id).substring(0,15);
			projectIds.add(tempId);
			//MilestoneID分の空インスタンスを作る
			taskMap.put(p.Id, new List<Milestone1_Task__c>());
		}
		//MilestoneのIDをキーとしてタスクのデータを取得して格納する。
		for(Milestone1_Task__c t : [Select id, Name,ProjectId__c From Milestone1_Task__c Where ProjectId__c IN :projectIds]){
			taskIds.add(t.Id);
			taskMap.get(t.ProjectId__c).add(t);
			//TaskID分のToDoとTaskTagを空インスタンスを作る
			toDoMap.put(t.Id, new List<Milestone_ToDo_Tag__c>());
			taskTagsMap.put(t.Id, '');
			paramTaskMap.put(t.Id, '');
		}
		for(Milestone1_Task__Tag t : [select id, Name, Type, ItemId, TagDefinitionId From Milestone1_Task__Tag Where ItemId IN : taskIds]){
			editLinkTagData(t.itemId, t.TagDefinitionId, t.Name, taskTagsMap, paramTaskMap);
		}
		//タスクのIDをキーとしてタスクのデータを取得して格納する。
		for(Milestone_ToDo_Tag__c g : [Select Id, Note__c, ToDo__c, Task__c From Milestone_ToDo_Tag__c WHERE Task__c IN :taskIds]){
			toDoIds.add(g.Id);
			toDoMap.get(g.Task__c).add(g);
			//TodoID文のToDoTagの空インスタンスを作る
			todoTagsMap.put(g.Id, '');
			paramTodoMap.put(g.Id, '');
		}
		for(Milestone_ToDo_Tag__Tag t : [select id, Name, Type, ItemId, TagDefinitionId From Milestone_ToDo_Tag__Tag Where ItemId IN : toDoIds]){
			editLinkTagData(t.itemId, t.TagDefinitionId, t.Name, todoTagsMap, paramTodoMap);
		}
		for(Id key : taskMap.keyset()){
			taskListCntMap.put(key, taskMap.get(key).size());
		}
		for(Id key : toDoMap.keyset()){
			toDoListCntMap.put(key, toDoMap.get(key).size());
		}
		//selfReference = this;
	}
	
	public void editLinkTagData(String itemId, String tagId, String tagName, Map<Id, String> mapping, Map<Id, String> paramMapping){
		String tags = '<a href=\"../search/TagSearchResults?tIdList=' + tagId.substring(0,15) + '&tagsSearch=' + tagName + '&lsc=-10&\" >' + tagName + '</a>';
		if(!mapping.containsKey(itemId)){
			mapping.put(itemId, '');
			paramMapping.put(itemId, '');
		}
		String temp = mapping.get(itemId);
		String paramTemp = paramMapping.get(itemId);
		temp = (temp.length()>0) ? temp+','+tags : tags;
		mapping.put(itemId, temp);
		
		paramTemp = (paramTemp.length() > 0) ? paramTemp + ',' + tagName : tagName;
		paramMapping.put(itemId, paramTemp);
		
	}
	
	public Pagereference doEdit(){
		if(inputName == null || inputName.length() == 0){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'name is Required(名前は必須です。)'));//system.Label.Custom_Milestone_PreTaskComplete_err));
            return null;
		}
		if(hiddenKind == TASK_KIND){
			//Tag挿入
			List<Milestone1_Task__Tag> taskTagList = new List<Milestone1_Task__Tag>();
			if(inputTag != null && inputTag.length() > 0){
				
				for(String str : inputTag.split(',')){
					Milestone1_Task__Tag taskTag = new Milestone1_Task__Tag(ItemId=hiddenId, Name=str, Type='Public');
					taskTagList.add(taskTag);
				}
				
			}
			if(taskTagList.size() > 0) {
				delete [Select id From Milestone1_Task__Tag where ItemId=:hiddenId];
				insert taskTagList;
			}
		} else {
			List<Milestone_ToDo_Tag__Tag> todoTagList = new List<Milestone_ToDo_Tag__Tag>();
			if(inputTag != null && inputTag.length() > 0){
				for(String str : inputTag.split(',')){
					Milestone_ToDo_Tag__Tag todoTag = new Milestone_ToDo_Tag__Tag(ItemId=hiddenId, Name=str, Type='Public');
					todoTagList.add(todoTag);
				}
			}
			if(todoTagList.size() > 0){
				delete [Select id From Milestone_ToDo_Tag__Tag where ItemId=:hiddenId];
				insert todoTagList;
			}
			Milestone_ToDo_Tag__c upsertToDo = [Select Id, Note__c, ToDo__c, Task__c From Milestone_ToDo_Tag__c WHERE Id =:hiddenId];
			upsertToDo.Note__c = inputNote;
			upsertToDo.ToDo__c = inputName;
			upsert upsertToDo;
		}
		doData();
		return null;
	}
	public Pagereference doDel(){
		if(hiddenId != null && hiddenId.length() > 0){
			if(hiddenKind == 'Task'){
				delete [Select Id From Milestone1_Task__Tag WHERE ItemId =:hiddenId];
			} else {
				delete [Select Id From Milestone_ToDo_Tag__c WHERE Id =:hiddenId];
				delete [Select id From Milestone_ToDo_Tag__Tag where ItemId=:hiddenId];
			}
			
		}
		doData();
		return null;
	}

}