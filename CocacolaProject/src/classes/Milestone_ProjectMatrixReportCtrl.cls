public class Milestone_ProjectMatrixReportCtrl {
	private final String OBJECT_NAME = 'Milestone1_Project__c';
	private final String FIELD_PROJECT_TYPE = 'Project_Type__c';
	private final String FIELD_SUBFUNC_TYPE = 'Sub_Function__c';
	private final String FIELD_STATUS_TYPE = 'Project_Status__c';
	
	public Map<String, List<Milestone1_Project__c>> matrix {get;set;}	//マトリックスデータマップ
	public List<String> projectTypeList {get;set;}			//ヘッダー名用
	//public List<String> subFunctionList {get;set;}
	public Map<String, String> projectTypeMap {get;set;}
	public Map<String, String> subFunctionMap {get;set;}
	
	public Milestone_ProjectMatrixReportCtrl(){
		matrix 			= new Map<String, List<Milestone1_Project__c>>();
		projectTypeList 	= new List<String>();
		//subFunctionList = new List<String>();
		projectTypeMap = getMapTypePicklistValue(this.OBJECT_NAME, this.FIELD_PROJECT_TYPE);
		
		//functionとSubFunctionの項目連動のため、修正
		//subFunctionMap = getMapTypePicklistValue(this.OBJECT_NAME, this.FIELD_SUBFUNC_TYPE);
		subFunctionMap = new Map<String, String>();
		subFunctionMap.put('Controller\'s Group', '0');
		subFunctionMap.put('BP&A', '1');
		subFunctionMap.put('Commercial Finance', '2');
		subFunctionMap.put('Supply Chain Finance', '3');
		subFunctionMap.put('M&A', '4');
		subFunctionMap.put('Finance Integration', '5');
		subFunctionMap.put('Investor Relations', '6');
		subFunctionMap.put('Internal Audit', '7');
		subFunctionMap.put('Corporate Administrator', '8');
		getMatrixData();
	}
	
	public void getMatrixData(){
		//マトリックスを空を生成
		for(String col : projectTypeMap.values()){
			for(String row : subFunctionMap.values()){
				matrix.put(row+col, new List<Milestone1_Project__c>());
			}
		}
		//データ取得
		List<Milestone1_Project__c> result = [SELECT Id, 
													 Name, 
													 Project_Type__c, 
													 Function__c, 
													 Sub_Function__c, 
													 Project_Status__c 
											  FROM Milestone1_Project__c 
											  WHERE Project_Type__c != null AND Sub_Function__c != null AND Function__c='Finance'];
		for(Milestone1_Project__c pro : result){
			String colsNo = projectTypeMap.get(pro.Project_Type__c);
			String rowsNo = subFunctionMap.get(pro.Sub_Function__c);
			//if(!matrix.containsKey(rowsNo+colsNo)){
			//	matrix.put(rowsNo+colsNo, new List<Milestone1_Project__c>());
			//}
			matrix.get(rowsNo+colsNo).add(pro);
		}
	}
	
	//SObjectを利用してPickListValueを取得するメソッド
	//Param　：　ObjectAPI名、FieldAPI名
	private List<Schema.PicklistEntry> pickListEntryVal(String ObjectApi_name,String Field_name){ 
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//オブジェクト名を入れてSObject取得
		Sobject Object_name = targetType.newSObject();
		Schema.sObjectType sobject_type = Object_name.getSObjectType(); //SObjectタイプ取得
		Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe取得
		Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //sobjectのFieldsを取得
		List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //picklist values取得
		return pick_list_values;
	}
	
	//MapタイプでField　PickListValueを取得
	public Map<String, String> getMapTypePicklistValue(String ObjectApi_name,String Field_name){ 
		Map<String, String> listPickvals = new Map<String, String>();
		Integer cnt = 0;
		for(Schema.PicklistEntry a : this.pickListEntryVal(ObjectApi_name, Field_name)){
			//ヘッダー名のソートのため
			if(Field_name == this.FIELD_PROJECT_TYPE){
				projectTypeList.add(a.getValue());
			}
			listPickvals.put(a.getValue(), ''+cnt);
			cnt++;
		}
		return listPickvals;
		
	}
	
	//ListタイプでField　PickListValueを取得
	public List<String> getListTypePicklistValue(String ObjectApi_name, String Field_name){ 
		List<String> listPickvals = new List<String>();
		for(Schema.PicklistEntry a : this.pickListEntryVal(ObjectApi_name, Field_name)){
			listPickvals.add(a.getValue());
		}
		return listPickvals;
	}
	
	/*
	public String getHtmlConvert(){
		String html = '<table>';
		html += '<tr><td></td>';
		for(String strCols : projectTypeMap.keyset()){
			html += '<td>' + strCols + '</td>';
		}
		html += '</tr>';
		for(String strRows : subFunctionMap.keyset()){
			html += '<tr>';
			html += '<td>' + strRows + '</td>';
			for(String strCol : projectTypeMap.keyset()){
				String col = projectTypeMap.get(strCol);
				String row = subFunctionMap.get(strRows);
				
				system.debug('colrow : ' + col+row);
				html += '<td>';
				system.debug('matrix.get(row+col)' + matrix.get(row+col));
				if(matrix.containsKey(row+col)){
					for(Milestone1_Project__c detail : matrix.get(row+col)){
						system.debug('detail : ' + detail);
						html += '<div style=\"background-color:' + detail.Project_Status__c + '\">' + detail.Name + '</div>';
						//html += detail.Name + '<br/>';
					}
				}
				
				html += '</td>';
			}
			html += '</tr>';
		}
		html += '</table>';
		
		return html;
		
	}
	*/
	
	//Project TypeのFilter　Option
	public String selectedTypeValue {get;set;}
	public List<SelectOption> getFilterProjectType(){
		List<SelectOption> result = new List<SelectOption>();
		result.add(new SelectOption('ALL','ALL'));
		for(String str : projectTypeList){
			result.add(new SelectOption(str, str));
		}
		return result;
	}
	
	//Project　StatusのFilter　Option
	public String selectedStatusValue{get;set;}
	public List<SelectOption> getFilterStatus(){
		List<SelectOption> result = new List<SelectOption>();
		result.add(new SelectOption('ALL', 'ALL'));
		for(String str : getListTypePicklistValue(this.OBJECT_NAME, this.FIELD_STATUS_TYPE)){
			result.add(new SelectOption(str, str));
		}
		return result;
	}
	
}