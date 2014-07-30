/**
*	タスクの標準画面に挿入したタスクCCのカスタム画面を制御するクラスである。
*
*	作成日　：　2013.12.4	Kim
*	修正履歴　：
*/
public class Milestone_CC_ListController {
	public List<ListWrapperClass> ccList {get;set;}		//CCに追加するリスト
	
	public Milestone_CC_ListController(ApexPages.StandardController stc){
		
		ccList = new List<ListWrapperClass>();
		integer idx = 0;
		for(Milestone_TaskCC__c cc : [SELECT Name FROM Milestone_TaskCC__c WHERE Task_Id__c = :stc.getId()]){
			ListWrapperClass lws = new ListWrapperClass();
			//最初のみタイトルを設定
			if(idx == 0) {
				lws.title_name = system.Label.CC_title_UserName;
				lws.user_name = cc.Name;
			} else {
				lws.title_name = '';
				lws.user_name = cc.Name;
			}
			ccList.add(lws);
			idx++;
		}
		//取得したデータがない場合、タイトルのみ設定する。
		if(ccList.size() == 0) {
			ListWrapperClass lws = new ListWrapperClass();
			lws.title_name = system.Label.CC_title_UserName;
			lws.user_name = '';
			ccList.add(lws);
		}
	}
	
	//画面上で表示するタイトルとユーザ名を設定するラッパークラス
	class ListWrapperClass {
		public String title_name {get;set;}
		public String user_name {get;set;}
	}
}