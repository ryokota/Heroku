/**
*   マイルストーンのタスクオブジェクトのユーザをCCに保存するクラス。
*   保存した場合は「マイルストーンタスクCC」に保存し、設定された担当者、所有者、メンバー及びCCの人にメールを送信する。
*
*   作成日　：　2013.12.3 Kim
*   修正履歴　：
*/
public with sharing class Milestone_CC_MultiselectController {
    public Milestone1_Task__c task {get;set;}           //詳細画面から渡してもらったタスク情報
    public SelectOption[] selectedUsers { get; set; }   //選択されたユーザ
    public SelectOption[] allUsers { get; set; }        //選択可能なユーザ
    
    public String currentTaskId {get;set;}
    public String hisDependId {get;set;}
    public Map<String, String> selectedUserMap {get;set;}
    
    //コンストラクタ
    public Milestone_CC_MultiselectController(ApexPages.StandardController stc) {
        this.task = (Milestone1_Task__c)stc.getRecord();                    //タスク詳細画面からもらった情報
        this.hisDependId = task.Pre_Dependency__c;
        selectedUserMap = new Map<String, String>();    //選択されたユーザのMap
        selectedUsers = new List<SelectOption>();                           //選択されたユーザ
        currentTaskId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('*****************' + task);
        system.debug('*****************' + task.ProjectId__c);
        system.debug('***************currentTaskId : ' + currentTaskId);
        
        //タスクIDが存在する場合
        if(task != null && task.Id != null){
            List<Milestone_TaskCC__c> ccUsers = [SELECT Name, User_Id__c FROM Milestone_TaskCC__c WHERE Task_Id__c = :task.Id];
            for( Milestone_TaskCC__c cc : ccUsers ){
                selectedUsers.add(new SelectOption(cc.User_Id__c, cc.Name));    //選択されたユーザリスト
                selectedUserMap.put(cc.User_Id__c, cc.Name);                    //選択されたユーザマップ
            }
        }
        
        //親タスクが存在する場合、親タスクからMilestoneのIDを取得し、設定する。
        if(task.Parent_Task__c != null){
            task.Project_Milestone__c = [SELECT Project_Milestone__c FROM Milestone1_Task__c WHERE Id = :task.Parent_Task__c].Project_Milestone__c;
        }
        
        if(task.Project_Milestone__c != null){
            this.getAllUserTeamList(task.Project_Milestone__c);
        }
    }
    
    //保存ボタンイベント
    public PageReference save() {
        system.debug('task.Project__c ' + task.ProjectId__c );
        //権限チェック
        Integer cnt = [SELECT count() FROM Milestone_Permission__c WHERE Project__c = :task.ProjectId__c AND UserName__c = :UserInfo.getUserId() AND (ProjectRole__c =:system.Label.Custom_Milestone_Role_Info_Jp OR ProjectRole__c = :system.Label.Custom_Milestone_Role_Info_En)];
        if(cnt != 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Custom_Milestone_err_permission));
            return null;
        }
        
        //kim edit start
        //タスクの3階層超過作成をチェック
        //Integer preCnt = [SELECT count() FROM Milestone1_Task__c WHERE Id=:task.Parent_Task__c AND Parent_Parent_Task__c != ''];
        Integer preCnt = [SELECT count() FROM Milestone1_Task__c WHERE Id=:task.Parent_Task__c AND Parent_Level7__c != ''];
        if(preCnt != 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Custom_Milestone_Task_err_three));
            return null;
        }
        //kim edit end
        
        //2013.12.26 追加作業　先行のタスクが完了してるのかどうか判定 start
        system.debug('***************task.Pre_Dependency__c : ' + task.Pre_Dependency__c);
        if(String.valueOf(task.Pre_Dependency__c) != null && String.valueOf(task.Pre_Dependency__c) != '' && currentTaskId != null && String.valueOf(task.Pre_Dependency__c) == hisDependId){
            system.debug('***************if start ');
            Milestone1_Task__c preTask = [SELECT Complete__c FROM Milestone1_Task__c WHERE Id = :task.Pre_Dependency__c];
            system.debug('***************preTask.Complete__c : ' + preTask.Complete__c);
            if(!preTask.Complete__c){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Custom_Milestone_PreTaskComplete_err));
                return null;
            }
        }
        //2013.12.26 end
        Savepoint sp;
        try{
            sp = Database.setSavepoint();
            //2014.1.10 kim 完了チェックボックス制御 Start
            task.Complete__c = false;
            if(task.Task_Stage__c == 'Completed' || task.Task_Stage__c == 'Interruption' ||
               task.Task_Stage__c == '完了' || task.Task_Stage__c == '中断' ){
                task.Complete__c = true;
            }
            //2014.1.10 kim End
            upsert task;    //Task情報更新
            
            //2013.12.26 start
            //タスクが削除された場合、同一マイルストーンの他のタスクの「完了チェック」データを判定
            Milestone1_Milestone__c dummyMilestone = [SELECT id, Complete__c, (Select id, Complete__c  From Project_Tasks__r) FROM Milestone1_Milestone__c WHERE Id = :task.Project_Milestone__c];
            boolean isOtherTask = false;
            boolean isAllComplete = true;
            for(Milestone1_Task__c mt : dummyMilestone.Project_Tasks__r){
                isOtherTask = true;
                if(mt.Complete__c == false) {
                    isAllComplete = false;
                    break;
                }
            }
            if(isOtherTask && isAllComplete){
                dummyMilestone.Complete__c = true;
                update dummyMilestone;
            }
            //2013.12.26 End
            
            //変更の場合、同じTaskIDを持つレコードを探して削除する。
            delete [SELECT Id FROM Milestone_TaskCC__c WHERE Task_Id__c = :task.Id];
            
            List<String> targetUserList = new List<String>();   //送信するユーザリスト
            List<Milestone_TaskCC__c> insertUsers = new List<Milestone_TaskCC__c>();
            //選択された情報をCCオブジェクトに格納して保存する
            for (SelectOption op : selectedUsers) {
                Milestone_TaskCC__c cc = new Milestone_TaskCC__c();
                cc.Name         = op.getLabel();
                cc.User_Id__c   = op.getValue();
                cc.Task_Id__c   = task.Id;
                insertUsers.add(cc);
                //選択されたユーザIDをリストに追加
                //if(cc.User_Id__c != UserInfo.getUserId()) targetUserList.add(op.getValue());
                targetUserList.add(op.getValue());
            }
            if (insertUsers.size() > 0) {
                insert insertUsers;
            }
            //送信メールユーザを格納する。
            if(task.Accountable_Owner__c != null)   targetUserList.add(task.Accountable_Owner__c);
            if(task.Assigned_To__c != null)         targetUserList.add(task.Assigned_To__c);
            //if(task.Members__c != null)           targetUserList.add(task.Members__c);
            
            //メール送信
            if(targetUserList.size() > 0){
                
                String title = '';
                
                String body = '';
                //各ユーザのE-Mailを取得
                List<String> toAddressEmail = new List<String>();
                List<String> toAddressUserNm = new List<String>();
                for(User sUser : [SELECT Email, Id, Name FROM User WHERE Id =:targetUserList]){
                	toAddressEmail.add(sUser.Email);
                	toAddressuserNm.add(sUser.Name);
                }
                //プロジェクト名やマイルストーン名を取得するため
                Milestone1_Task__c searchTask = [Select Name, Start_Date__c, Due_Date__c, Project_Milestone__r.Project__r.Name, Project_Milestone__r.Name, Description__c, Overall_Status__c, Progress__c, Task_Stage__c, Task_Status__c, Accountable_Owner__c,  Accountable_Owner__r.Name, Assigned_To__c,  Assigned_To__r.Name, Priority__c, Next_Dependency__c, Pre_Dependency__c, Next_Dependency__r.Name, Pre_Dependency__r.Name From Milestone1_Task__c WHERE Id = :task.Id];
                
                //メールのタイトル
                title += '件名：Task : {' + searchTask.Project_Milestone__r.Project__r.Name + '} - {' + searchTask.Project_Milestone__r.Name + '} - {' + searchTask.Name + '}';
                
                //メール内容
                String description = searchTask.Description__c == null ? '' : searchTask.Description__c;
                String start_date = searchTask.Start_Date__c == null ? '' : searchTask.Start_Date__c.format();
                String due_date = searchTask.Due_Date__c == null ? '' : searchTask.Due_Date__c.format();
                String accountable = searchTask.Accountable_Owner__c == null ? '' : searchTask.Accountable_Owner__r.Name;
                String assigned = searchTask.Assigned_To__c == null ? '' : searchTask.Assigned_To__r.Name;
                String nextTaskName = searchTask.Next_Dependency__c == null ? '' : searchTask.Next_Dependency__r.Name;
                String preTaskName = searchTask.Pre_Dependency__c == null ? '' : searchTask.Pre_Dependency__r.Name;
                String overall = searchTask.Overall_Status__c == null ? '' : searchTask.Overall_Status__c;
                String taskStage = searchTask.Task_Stage__c == null ? '' : searchTask.Task_Stage__c;
                String taskStatus = searchTask.Task_Status__c == null ? '' : searchTask.Task_Status__c;
                String Priority =  searchTask.Priority__c == null ? '' : searchTask.Priority__c;
                
                body += 'プロジェクト名 / Project Name : ' + searchTask.Project_Milestone__r.Project__r.Name + '<BR/>';
                body += 'マイルストーン名 / Milestone Name : ' + searchTask.Project_Milestone__r.Name + '<BR/>';
                body += 'タスク名 / Task Name : ' + searchTask.Name + '<BR/><BR/>';
                body += '責任者 / Accountable : ' + accountable + '<BR/>';
                body += '担当者 / Assigned To : ' + assigned + '<BR/><BR/>';
                body += '開始日 / Started Date : ' +  start_date + '<BR/>';
                body += '期限日 / Due Date : ' +  due_date + '<BR/><BR/>';
                
                body += '全体の状況 / Overall Status : ' + overall + '<BR/>';
                body += '進捗率  / Progress : ' + searchTask.Progress__c + '<BR/>';
                body += 'タスクステージ / Task Stage : ' + taskStage + '<BR/>';
                body += 'タスクステータス / Task Status : ' + taskStatus + '<BR/>';
                body += '優先順 / Priority : ' + Priority + '<BR/><BR/>';
                body += '説明 / Description : ' +  description + '<BR/><BR/>';
                body += '先行タスク / PreTask : ' + preTaskName + '<BR/>';
                body += '後続タスク / NextTask : ' + nextTaskName + '<BR/><BR/>';
                integer idx = 0;
                for(String userNm : toAddressUserNm){
                	if(idx == 0) body += 'CC : ' + userNm + '<BR/>';
                	else body += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + userNm + '<BR/>';
                	idx++;
                }
                body += '<BR/>';
                body += '下記のリンクをクリックしてタスクをご確認ください。<BR/>';
                body += 'Click this link to open the task. <BR/>';
                
                String strURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + task.id;
                body += '<a href = "' + strURL + '"> ' + strURL + '</a>';
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toAddressEmail);
                mail.setSubject(title);
                mail.setHtmlBody(body);
                //カスタムラベルから制御０：送信、１：送信しない
                if(system.Label.CC_MilestoneTask_SendMail_Flg == '0'){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    task.Last_Email_Received__c =  Datetime.now();
                    upsert task;
                }
            }
            
        } catch(DMLException e){
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        
        //Taskの詳細画面に遷移
        return new PageReference('/' + task.Id);
    }
    
    //非同期でCCユーザリストを取得
    public void userTeamList(){
        system.debug('******************userTeamList');
        this.getAllUserTeamList(task.Project_Milestone__c);
    }
    
    private void getAllUserTeamList(String mileStoneId){
        Milestone1_Milestone__c mileObj = [SELECT Project__r.Id FROM Milestone1_Milestone__c WHERE ID =:mileStoneId];
        String tempId = mileObj.Project__r.Id;
        List<Milestone_Permission__c> teamUserList = [Select UserName__r.Name, UserName__c From Milestone_Permission__c WHERE Project__c = :tempId];
        
        allUsers = new List<SelectOption>();
        for (Milestone_Permission__c teamUser : teamUserList){
            //選択されたユーザを除いて選択可能なユーザを設定
            if(!selectedUserMap.containsKey(teamUser.UserName__c)){
                allUsers.add(new SelectOption(teamUser.UserName__c, teamUser.UserName__r.Name));
            }
        }
    }
    
}