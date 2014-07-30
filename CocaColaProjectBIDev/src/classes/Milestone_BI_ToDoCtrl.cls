public class Milestone_BI_ToDoCtrl {
	//入力フィールド定義
	public String inputTag {get;set;}	
	public String hiddenId {get;set;}
	public String inputChk {get;set;}
	public Milestone_ToDo_Tag__c inputObj {get;set;}
	
	//一覧リスト定義
	public List<Milestone_ToDo_Tag__c> todoList {get;set;}
	public Map<String, ProjectRelationClass> proRelMap {get;set;}
	public Map<Id, String> todoTagMap {get;set;}
	public Map<Id, String> todoTagParamMap {get;set;}
	
	//ログインユーザ
	public String loginUserId {get;set;}
	
	//インスタンス
	public Milestone_BI_ToDoCtrl(){
		loginUserId = UserInfo.getUserId();
		doGetData();
	}
	
	//対象データを取得編集し、画面上に表示する。
	public void doGetData(){
		//一覧で使う集合変数を初期化
		todoList = new List<Milestone_ToDo_Tag__c>();
		inputObj = new Milestone_ToDo_Tag__c();
		todoTagMap = new Map<Id, String>();
		todoTagParamMap = new Map<Id, String>();
		proRelMap = new Map<String, ProjectRelationClass>();
		
		//ログインユーザからプロジェクトチームに所属されたプロジェクトIDのデータを取得
		for(Milestone_Permission__c p : [SELECT Project__c FROM Milestone_Permission__c WHERE UserName__c =:loginUserId]){
			proRelMap.put(p.Project__c, new ProjectRelationClass());
		}
		
		//プロジェクトのデータを取得し、マッピングする。
		for(Milestone1_Project__c p : [SELECT Id, Name, Function__c FROM Milestone1_Project__c WHERE Id IN : proRelMap.keyset()]){
			proRelMap.get(p.Id).proObj = p;
		}
		
		//自分が所有する全てのToDoデータを取得
		for(Milestone_ToDo_Tag__c t : [Select Id, Note__c, Due_Date__c, ToDo__c, Function__c, Project__c From Milestone_ToDo_Tag__c WHERE OwnerId =:loginUserId ORDER BY Project__c]){
			//プロジェクトIDが存在有無によってプロジェクトToDoか一般ToDiかを判定しマッピング、
			if(t.Project__c != null){
				system.debug('***************' + proRelMap.get(t.Project__c));
				proRelMap.get(t.Project__c).childTodoList.add(t);
			} else {
				todoList.add(t);
			}
			//画面上で使用するマッピング初期化
			todoTagMap.put(t.Id, '');
			todoTagParamMap.put(t.Id, '');
		}
		//ToDoが持っている全てのTagを取得する。
		for(Milestone_ToDo_Tag__Tag tagObj : [select id, Name, Type, ItemId, TagDefinitionId From Milestone_ToDo_Tag__Tag Where ItemId IN : todoTagMap.keyset()]){
			editLinkTagData(tagObj.itemId, tagObj.TagDefinitionId, tagObj.Name, todoTagMap, todoTagParamMap);
		}
	}
	
	//ToDo検索リンクを編集する。
	public void editLinkTagData(String itemId, String tagId, String tagName, Map<Id, String> mapping, Map<Id, String> paramMapping){
		String tags = '<a href=\"../search/TagSearchResults?tIdList=' + tagId.substring(0,15) + '&tagsSearch=' + tagName + '&lsc=-10&\" >' + tagName + '</a>';
		//if(!mapping.containsKey(itemId)){
		//	mapping.put(itemId, '');
		//	paramMapping.put(itemId, '');
		//}
		String temp = mapping.get(itemId);
		temp = (temp.length()>0) ? temp+','+tags : tags;
		mapping.put(itemId, temp);
		
		String paramTemp = paramMapping.get(itemId);
		paramTemp = (paramTemp.length() > 0) ? paramTemp + ',' + tagName : tagName;
		paramMapping.put(itemId, paramTemp);
		
	}
	
	//データを保存するメソッド
	public Pagereference doSave(){
		system.debug('************Project : ' + inputObj.Project__c);
		system.debug('************ToDo__c : ' + inputObj.ToDo__c);
		//必須チェックProject　又はToDo
		if(inputObj.Project__c == null && (inputObj.ToDo__c == null || inputObj.ToDo__c == '')
		   || (inputObj.ToDo__c == null || inputObj.ToDo__c == '')){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[Name] or [Project] is Required'));//system.Label.Custom_Milestone_PreTaskComplete_err));
            return null;
		}
		
		//編集の場合（HiddenIdが存在）、前のデータ削除後、挿入
		if(hiddenId != null && hiddenId.length() > 0){
			system.debug('**************UPDATE');
			delete [Select Id, Note__c, Due_Date__c, ToDo__c, Function__c, Project__c From Milestone_ToDo_Tag__c WHERE Id =:hiddenId];
		}
		insert inputObj;
		
		//Tagデータが存在する場合、コンマ区切りでTagオブジェクトにデータ挿入
		List<Milestone_ToDo_Tag__Tag> taskTagList = new List<Milestone_ToDo_Tag__Tag>();
		if(inputTag != null && inputTag.length() > 0){
			for(String str : inputTag.split(',')){
				Milestone_ToDo_Tag__Tag todoTag = new Milestone_ToDo_Tag__Tag(ItemId=inputObj.Id, Name=str, Type='Personal');
				taskTagList.add(todoTag);
			}
		}
		if(taskTagList.size() > 0) {
			delete [Select id From Milestone_ToDo_Tag__Tag where ItemId=:hiddenId];
			insert taskTagList;
		}
		//データリロード
		doGetData();
		return null;
	}
	
	//データを削除するメソッド
	public Pagereference doDel(){
		//Targetデータを削除、もしIDが存在しない場合、エラー処理
		if(hiddenId != null && hiddenId.length() > 0){
			delete [Select Id From Milestone_ToDo_Tag__c WHERE Id =:hiddenId];
			delete [Select id From Milestone_ToDo_Tag__Tag where ItemId=:hiddenId];
		} else {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select  to delete Target'));//system.Label.Custom_Milestone_PreTaskComplete_err));
            return null;
		}
		//データリロード
		doGetData();
		return null;
	}
	
	//画面上で使用するラッパークラス（プロジェクトに関連つけのToDoデータ）
	class ProjectRelationClass {
		public Milestone1_Project__c proObj {get;set;}
		public List<Milestone_ToDo_Tag__c> childTodoList {get;set;}
		public ProjectRelationClass(){
			proObj = new Milestone1_Project__c();
			childTodoList = new List<Milestone_ToDo_Tag__c>();
		}
	}
}