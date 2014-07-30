public class Milestone_BI_ToDoCtrl {
	//Filter条件
	private final String ALL_VALUE = 'ALL';
	private final String COMPLETE_VALUE = 'COMPLETED';
	private final String INCOMPLETE_VALUE = 'INCOMPLETED';
	public String selectedValue {get;set;}
	//入力フィールド定義
	public String inputTag {get;set;}	
	public String hiddenId {get;set;}
	public boolean inputChk {get;set;}
	public Milestone_ToDo_Tag__c inputObj {get;set;}
	
	//一覧リスト定義
	public List<Milestone_ToDo_Tag__c> notProjectTodoList {get;set;}
	public List<Milestone_ToDo_Tag__c> projectTodoList {get;set;}
	public Map<String, ProjectRelationClass> proRelMap {get;set;}
	public Map<Id, String> todoTagMap {get;set;}
	public Map<Id, String> todoTagParamMap {get;set;}
	
	//ログインユーザ
	public String loginUserId {get;set;}
	
	//インスタンス
	public Milestone_BI_ToDoCtrl(){
		loginUserId = UserInfo.getUserId();
		selectedValue = INCOMPLETE_VALUE;
		doGetData(selectedValue);
	}
	
	//対象データを取得編集し、画面上に表示する。
	public void doGetData(String param){
		system.debug('************************doGetData Run');
		//一覧で使う集合変数を初期化
		notProjectTodoList = new List<Milestone_ToDo_Tag__c>();
		projectTodoList = new List<Milestone_ToDo_Tag__c>();
		inputObj = new Milestone_ToDo_Tag__c();
		todoTagMap = new Map<Id, String>();
		todoTagParamMap = new Map<Id, String>();
		proRelMap = new Map<String, ProjectRelationClass>();
		
		List<String> projectIdList = new List<String>();
		/*
		//ログインユーザからプロジェクトチームに所属されたプロジェクトIDのデータを取得
		for(Milestone_Permission__c p : [SELECT Project__c FROM Milestone_Permission__c WHERE UserName__c =:loginUserId]){
			//proRelMap.put(p.Project__c, new ProjectRelationClass());
			projectIdList.add(p.Project__c);
		}
		
		//プロジェクトのデータを取得し、マッピングする。
		for(Milestone1_Project__c p : [SELECT Id, Name, Function__c FROM Milestone1_Project__c 
										WHERE Id IN : projectIdList AND (Status__c ='Planning' or Status__c='Active')
				 						ORDER BY Function__c]){
			if(!proRelMap.containsKey(p.Id)){
				proRelMap.put(p.Id, new ProjectRelationClass());
			}
			proRelMap.get(p.Id).proObj = p;
		}
		*/
		//所有者のToDoデータを取得
		projectTodoList = [Select Id, Note__c, Due_Date__c, ToDo__c, Completed__c, Function__c, Project__c, Project__r.Status__c From Milestone_ToDo_Tag__c WHERE OwnerId =:loginUserId ORDER BY Project__c];
		if(param == COMPLETE_VALUE){
			projectTodoList = [Select Id, Note__c, Due_Date__c, ToDo__c, Completed__c, Function__c, Project__c, Project__r.Status__c From Milestone_ToDo_Tag__c WHERE OwnerId =:loginUserId AND Completed__c = true ORDER BY Project__c];
		} else if(param == INCOMPLETE_VALUE){
			projectTodoList = [Select Id, Note__c, Due_Date__c, ToDo__c, Completed__c, Function__c, Project__c, Project__r.Status__c From Milestone_ToDo_Tag__c WHERE OwnerId =:loginUserId AND Completed__c = false ORDER BY Project__c];
		}
		//ProjectIdを抽出
		for(Milestone_ToDo_Tag__c projectId : projectTodoList){
			if(projectId.Project__c != null) projectIdList.add(projectId.Project__c);
		}
		
		//Project情報取得
		for(Milestone1_Project__c p : [SELECT Id, Name, Function__c FROM Milestone1_Project__c 
										WHERE Id IN : projectIdList AND (Status__c ='Planning' or Status__c='Active')
				 						ORDER BY Function__c]){
			if(!proRelMap.containsKey(p.Id)){
				proRelMap.put(p.Id, new ProjectRelationClass());
			}
			proRelMap.get(p.Id).proObj = p;
		}
		//自分が所有する全てのToDoデータを取得
		for(Milestone_ToDo_Tag__c t : projectTodoList){
			//プロジェクトIDが存在有無によってプロジェクトToDoか一般ToDiかを判定しマッピング、
			if(t.Project__c != null){
				if(t.Project__r.Status__c =='Planning' || t.Project__r.Status__c =='Active'){
					system.debug('***************' + proRelMap.get(t.Project__c));
					proRelMap.get(t.Project__c).childTodoList.add(t);
				}
			} else {
				notProjectTodoList.add(t);
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
		system.debug('********************save run');
		system.debug('************Project : ' + inputObj.Project__c);
		system.debug('************ToDo__c : ' + inputObj.ToDo__c);
		//必須チェックProject　又はToDo
		if(inputChk && (inputObj.Project__c == null || inputObj.ToDo__c == null || inputObj.ToDo__c == '')
		   || (!inputChk && (inputObj.ToDo__c == null || inputObj.ToDo__c == ''))){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Milestone_ToDo_Err02));//system.Label.Custom_Milestone_PreTaskComplete_err));
            return null;
		}
		
		//プロジェクトメンバーチェック
		if(inputObj.Project__c != null){
			integer cnt = [SELECT count() FROM Milestone_Permission__c WHERE UserName__c =:loginUserId AND Project__c = :inputObj.Project__c];
			if(cnt == 0){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Milestone_ToDo_Err03));//system.Label.Custom_Milestone_PreTaskComplete_err));
            	return null;
			}
			integer projectCnt = [SELECT count() FROM Milestone1_Project__c WHERE Id =:inputObj.Project__c AND Status__c !='Planning' AND Status__c !='Active'];
			if(projectCnt != 0){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Milestone_ToDo_Err04));//system.Label.Custom_Milestone_PreTaskComplete_err));
            	return null;
			}
		}
		
		
		//編集の場合（HiddenIdが存在）、前のデータ削除後、挿入
		if(hiddenId != null && hiddenId.length() > 0){
			system.debug('**************UPDATE');
			delete [Select Id, Note__c, Due_Date__c, ToDo__c, Completed__c, Function__c, Project__c From Milestone_ToDo_Tag__c WHERE Id =:hiddenId];
		}
		system.debug('inputObj ProjectId' + inputObj.Project__c);
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
		doGetData(selectedValue);
		return null;
	}
	
	//データを削除するメソッド
	public Pagereference doDel(){
		//Targetデータを削除、もしIDが存在しない場合、エラー処理
		if(hiddenId != null && hiddenId.length() > 0){
			delete [Select Id From Milestone_ToDo_Tag__c WHERE Id =:hiddenId];
			delete [Select id From Milestone_ToDo_Tag__Tag where ItemId=:hiddenId];
		} else {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Milestone_ToDo_Err01));//system.Label.Custom_Milestone_PreTaskComplete_err));
            return null;
		}
		//データリロード
		doGetData(selectedValue);
		return null;
	}
	
	public List<SelectOption> getFilterStatus(){
		List<SelectOption> result = new List<SelectOption>();
		result.add(new SelectOption(ALL_VALUE,ALL_VALUE));
		result.add(new SelectOption(COMPLETE_VALUE, COMPLETE_VALUE));
		result.add(new SelectOption(INCOMPLETE_VALUE, INCOMPLETE_VALUE));
		return result;
	}
	
	public Pagereference onChangeEventAction(){
		system.debug('selectedValue : ' + selectedValue);
		doGetData(selectedValue);
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