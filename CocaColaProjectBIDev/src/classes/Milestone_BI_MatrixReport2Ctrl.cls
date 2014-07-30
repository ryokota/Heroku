public class Milestone_BI_MatrixReport2Ctrl {

	private final Integer MILESTONE_MAX_CNT = 29;
	public String currentId {get;set;}
	public List<Status_Indicator_Detail__c> indicatorList {get;set;}
	public List<Milestone1_Milestone__c> milestoneList {get;set;}
	public List<Milestone_Permission__c> teamsName {get;set;}
	public List<ViewInfoWrapper> viewList {get;set;}
	public Integer totalPage {get;set;}
	
	public Milestone_BI_MatrixReport2Ctrl(){
		currentId = ApexPages.currentPage().getParameters().get('Id');
		//dummy
		//currentId = 'a0eN000000046PwIAI';
		indicatorList = new List<Status_Indicator_Detail__c>();
		milestoneList = new List<Milestone1_Milestone__c>();
		teamsName = new List<Milestone_Permission__c>();
		
		getResultData();
		String strUsersName = getTeamUsersName(teamsName);
		viewList = new List<ViewInfoWrapper>();
		
		system.debug('totalPage : ' + totalPage);
		//for(Integer i=0; i<totalPage; i++){
		integer pageCnt = 1;
		if(indicatorList.size() > 0) {
			String projectName 		= indicatorList.get(0).project__r.Name;
			String projectStatus 	= indicatorList.get(0).Project__r.Project_Status__c;
			String sponsor 			= indicatorList.get(0).Project__r.Project_Sponsor__c == null ? '' : indicatorList.get(0).Project__r.Project_Sponsor__r.Name;
			String leader 			= indicatorList.get(0).Project__r.Project_Leader__c == null ? '' : indicatorList.get(0).Project__r.Project_Leader__r.Name;
			String transformation 	= '';
			String projectMembers 	= addLineFeed(cutTextValue(strUsersName,220), 50);
			String lastTwoWeeks 	= indicatorList.get(0).Accomplishments_This_Period__c == null ? '' : indicatorList.get(0).Accomplishments_This_Period__c;
			String plannedButNotAccomplished = indicatorList.get(0).Planned_But_Not_Accomplished__c == null ? '' : indicatorList.get(0).Planned_But_Not_Accomplished__c;
			String nextTwoWeeks 	= indicatorList.get(0).Planned_For_The_Next_Period__c == null ? '' : indicatorList.get(0).Planned_For_The_Next_Period__c;
			String issuesTeamAdd 	= '';
			String issuesforEscalation =  '';
			
			ViewInfoWrapper vw = new ViewInfoWrapper();
			vw.currentPage = pageCnt;
			vw.header = true;
			vw.projectName = projectName;
			vw.projectStatus = projectStatus;
			vw.bgColor = getBgColor(projectStatus);
			vw.projectSponsor = sponsor;
			vw.projectLeader = leader;
			vw.projectMembers = projectMembers;
			vw.transformation = cutTextValue(transformation,220).replaceAll('(\\W)','$1<wbr/>');
			vw.lastTwoWeeks = cutTextValue(lastTwoWeeks,280).replaceAll('(\\W)','$1<wbr/>');
			vw.plannedButNotAccomplished = cutTextValue(plannedButNotAccomplished,280).replaceAll('(\\W)','$1<wbr/>');
			vw.nextTwoWeeks = cutTextValue(nextTwoWeeks,280).replaceAll('(\\W)','$1<wbr/>');
			vw.issuesTeamAdd = cutTextValue('issuesTeamAdd',168).replaceAll('(\\W)','$1<wbr/>');
			vw.issuesforEscalation = cutTextValue('issuesforEscalation', 168).replaceAll('(\\W)','$1<wbr/>');
			viewList.add(vw);
		}
		//Page件数を取得
		totalPage = pageCount(milestoneList.size(), MILESTONE_MAX_CNT);
		for(Integer i=0; i<totalPage; i++){
			pageCnt++;
			
			ViewInfoWrapper vw = new ViewInfoWrapper();
			vw.currentPage = pageCnt;
			for(integer j=(i*MILESTONE_MAX_CNT); j<(i+1) * MILESTONE_MAX_CNT; j++){
				vw.header = false;
				if(milestoneList.size() < j+1) {
					vw.miList.add(new ViewDetailWrapper());
				}
				else {
					ViewDetailWrapper vdw = new ViewDetailWrapper();
					vdw.milestoneName = cutTextValue(milestoneList.get(j).Name, 18);
					vdw.deadLine = milestoneList.get(j).Deadline__c;
					vdw.completedDate = milestoneList.get(j).CompletedDate__c;
					vw.miList.add(vdw);
				}
			}
			viewList.add(vw);
		}
		if(totalPage != 0) totalPage = totalPage + 1;
	}
	
	//PDF データ取得
	public void getResultData(){
		indicatorList = [SELECT Id, 
								Name, 
								Project__c, 
								project__r.Name,
								Project__r.Project_Status__c, 
								Project__r.Project_Leader__c, 
								Project__r.Project_Leader__r.Name, 
								Project__r.Project_Sponsor__c, 
								Project__r.Project_Sponsor__r.Name,
								Control__c,  
								Status_Date__c, 
								Customer_Obligations__c, 
								Customer_Satisfaction__c, 
								Employee_Satisfaction__c, 
								Executive_Engagement__c, 
								Governance__c, 
								Project_Budget__c, 
								Project_Schedule__c, 
								Project_Scope__c, 
								Accomplishments_This_Period__c,
								Planned_But_Not_Accomplished__c, 
								Planned_For_The_Next_Period__c, 
								Summary_Project_Status__c 
						FROM Status_Indicator_Detail__c WHERE Id = :currentId];
		if(indicatorList.size() > 0) {
			milestoneList = [SELECT Id,
								Name,
								Deadline__c,
								CompletedDate__c
							FROM Milestone1_Milestone__c WHERE Project__c = :indicatorList.get(0).Project__c ORDER BY Name];
			teamsName = [SELECT UserName__r.Name, UserName__c  
						FROM Milestone_Permission__c WHERE Project__c = :indicatorList.get(0).Project__c];
		}
		
	}
	
	//Milestoneのサイズを計算して総ページを求める
	private Integer pageCount(Integer size, Integer MaxCnt){
		Integer cnt = size / MaxCnt;
		if(math.mod(size, MaxCnt) != 0){
			cnt++;
		}
		return cnt;
	}
	
	//指定した最大文字列長さまでの文字列を編集して返す
	//val:対象文字列、cnt:指定長さ
	private String cutTextValue(String val, Integer len) {
    	String reVal = '';
    	if (val != null && val.length() != 0) {
    		if (val.length() > len) {
    			reVal = val.substring(0, len) + '...';
    		} else {
    			reVal = val;
    		}
    	}
    	return reVal;
    }
	
	/*
	private String test(String line, integer maxByte){
		Integer sum = 0;
		//全体のバイト数
		Integer bigSum = 0;
		//インデックス
		Integer index = 0;
		String convertStr = '';
		for(Integer i = 0 ; i < line.length(); i++){
        //一文字取得
        String one = line.substring(i, (i+1) ) ;
        //一文字バイト数計算
        Integer oneSize = Blob.valueOf(line).size();
        //合計
        sum += oneSize;
	    bigSum += oneSize;
	        //MAXを超えた場合
	        if(sum > maxByte){
	                //クリア
	                sum = 0;
	                convertStr += line.substring(index, (i+1) )  + '\n';
	                index = i+1;
	        }
		}
		return convertStr;
	}
	*/
	
	private String getBgColor(String status){
		String bgColor = '#BBBBBB';
		if(status == 'Green'){
			bgColor='#00AA00';
		} else if(status == 'Yellow'){
			bgColor='#FFFF22';
		} else if(status == 'Red'){
			bgColor='#FF0000';
		}
		return bgColor;
	}
	
	//改行するメソッド
	private String addLineFeed(String val, Integer cnt){
		String result = '';
		if(val == null || val.length() == 0) return result;
		if(val.length() < cnt) return val;
		integer quotient = val.length() / cnt;
		integer remainder = math.mod(val.length(), cnt);
		integer subIndex = 0;
		for(integer i=0; i<quotient; i++){
			result += val.substring(i*cnt, cnt*(i+1)) + '\n';
		}
		if(remainder != 0) result += val.substring(cnt * (quotient));
		return result;
	}
	
	//ユーザごとにコンマ区切りをつける
	private String getTeamUsersName(List<Milestone_Permission__c> pram){
		String result = '';
		for(Milestone_Permission__c m : pram){
			result += m.UserName__r.Name + ',';
		}
		if(result.length()>0){
			result = result.substring(0, result.lastIndexOf(','));
		}
		return result;
	}
	
	//PDF画面上で利用するラッパークラス
	class ViewInfoWrapper{
		public boolean header {get;set;}
		public String bgColor {get;set;}
		public Integer currentPage {get;set;}
		public String projectName {get;set;}
		public String projectStatus {get;set;}
		public String projectSponsor {get;set;}
		public String projectLeader {get;set;}
		public String projectMembers {get;set;}
		
		public String transformation {get;set;}
		public String lastTwoWeeks {get;set;}
		public String plannedButNotAccomplished {get;set;}
		public String nextTwoWeeks {get;set;} 
		public String issuesTeamAdd {get;set;}
		public String issuesforEscalation {get;set;} 
		public List<ViewDetailWrapper> miList {get;set;}
		public ViewInfoWrapper(){
			miList = new List<ViewDetailWrapper>();
		}
	}
	
	class ViewDetailWrapper{
		public String milestoneName {get;set;}
		public Date deadLine {get;set;}
		public Date completedDate {get;set;}
		public String keyUpcoming {get;set;}
	}
}