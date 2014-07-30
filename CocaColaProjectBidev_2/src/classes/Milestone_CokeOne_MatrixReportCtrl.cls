public class Milestone_CokeOne_MatrixReportCtrl {
	
	public Map<String, List<Milestone1_Milestone__c>> matrixMap {get;set;}
	public Map<String, String> projectMap {get;set;}	//プロジェクト名
	public Map<String, String> statusMap {get;set;}		//プロジェクトステータス
	public List<String> statusList {get;set;}
	public List<Milestone1_Milestone__c> milestoneList {get;set;}
	public Milestone_CokeOne_MatrixReportCtrl(){
		statusList = new String[]{'Green', 'Yellow', 'Red', 'Gray'};
		//データ取得
		getTargetData();
		//初期設定
		statusMap = new Map<String, String>();
		statusMap.put('Green', '0');
		statusMap.put('Yellow', '1');
		statusMap.put('Red', '2');
		statusMap.put('Gray', '3');
		
		projectMap = new Map<String, String>();
		integer idx = 0;
		for(Milestone1_Milestone__c mm : milestoneList){
			if(!projectMap.containsKey(mm.Project__r.Name)){
				projectMap.put(mm.Project__r.Name, ''+idx);
				idx++;
			}
		}
		
		editMapping();
	}
	
	//初期データ取得
	public void getTargetData(){
		system.debug('***************** getTargetData Start');
		milestoneList = [SELECT Project__c, 
							  Project__r.Name, 
							  Id, 
							  Name, 
							  Milestone_Status__c 
						From Milestone1_Milestone__c 
						WHERE RecordTypeId =:system.Label.Milestone_RecordType_CokeOne 
						AND Project__r.Status__c = 'Active' 
						ORDER BY Project__c, Milestone_Status__c];
	}
	
	//マトリックスデータ編集メソッド
	public void editMapping(){
		system.debug('***************** editMapping Start');
		matrixMap = new Map<String, List<Milestone1_Milestone__c>>();
		//マトリックス初期化
		for(String col : projectMap.values()){
			for(String row : statusMap.values()){
				matrixMap.put(row+col, new List<Milestone1_Milestone__c>());
			}
		}
		
		//マトリックスにデータマッピング
		for(Milestone1_Milestone__c mm : milestoneList){
			String colNo = projectMap.get(mm.Project__r.Name);
			String rowNo = statusMap.get(mm.Milestone_Status__c == null ? 'Gray' : mm.Milestone_Status__c);
			matrixMap.get(rowNo+colNo).add(mm);
		}
	}
	
	//Project TypeのFilter　Option
	public String selectedStatusValue {get;set;}
	public List<SelectOption> getFilterStatus(){
		List<SelectOption> result = new List<SelectOption>();
		result.add(new SelectOption('ALL','ALL'));
		result.add(new SelectOption('Green', 'Green'));
		result.add(new SelectOption('Yellow', 'Yellow'));
		result.add(new SelectOption('Red', 'Red'));
		result.add(new SelectOption('Gray', 'Gray'));
		return result;
	}

}