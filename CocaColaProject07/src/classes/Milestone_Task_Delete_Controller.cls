global class Milestone_Task_Delete_Controller {
	private final static String TYPE_MILESTONE = 'milestone';
	private final static String TYPE_TASK = 'task';
	webservice static boolean deleteConfirm(String strId, String strType ) { 
        system.debug('strId : ' + strId + '     strType : ' + strType);
        String profileId = Userinfo.getProfileId();
        String loginUserId = Userinfo.getUserId();
        //システム管理者
		Integer adminSize = [SELECT count() FROM Profile WHERE Id = :profileId AND (Name = 'システム管理者' OR Name = 'System Administrator')];
        
        if(strType == TYPE_MILESTONE){
        	//PMの場合
        	Integer mpSize  = [SELECT count() FROM Milestone_Permission__c 
								WHERE Project__c = :[SELECT Project__c FROM Milestone1_Milestone__c WHERE Id =:strId].Project__c 
								AND UserName__c = :loginUserId
								AND (ProjectRole__c = :system.Label.Custom_Milestone_Role_PM_Jp OR ProjectRole__c = :system.Label.Custom_Milestone_Role_PM_En)];
        	
        	//所有者リスト
        	//Integer ownerSize = [SELECT count() FROM Milestone1_Project__c 
        	//						WHERE Id = :[SELECT Project__c FROM Milestone1_Milestone__c WHERE Id =:strId].Project__c 
        	//					 	AND OwnerId = :loginUserId];
        	Integer ownerSize = [SELECT count() FROM Milestone1_Milestone__c WHERE Id =:strId AND OwnerId = :loginUserId];
        	if(mpSize != 0 || ownerSize != 0 || adminSize != 0){
        		delete [SELECT id FROM Milestone1_Milestone__c WHERE id =:strId];
	        	return true;
        	}
        } else if(strType == TYPE_TASK){
        	Integer mpSize  = [SELECT count() FROM Milestone_Permission__c 
        									WHERE Project__c = :[SELECT ProjectId__c FROM Milestone1_Task__c WHERE Id =:strId].ProjectId__c 
        									AND UserName__c = :loginUserId
        									AND (ProjectRole__c = :system.Label.Custom_Milestone_Role_PM_Jp OR ProjectRole__c = :system.Label.Custom_Milestone_Role_PM_En)];
        	
        	//所有者リスト
        	//Integer ownerSize = [SELECT count() FROM Milestone1_Project__c 
        	//						WHERE Id = :[SELECT ProjectId__c FROM Milestone1_Task__c WHERE Id =:strId].ProjectId__c 
        	//					 	AND OwnerId = :loginUserId];
        	Integer ownerSize = [SELECT count() FROM Milestone1_Task__c WHERE Id = :strId AND Project_Milestone__r.OwnerId = : loginUserId];
    		if(mpSize != 0 || ownerSize != 0 || adminSize != 0){
    			//2013.12.26 追加作業 start
    			//delete [SELECT id FROM Milestone1_Task__c WHERE id =:strId];
	        	Milestone1_Task__c deleteTask = [SELECT id, Complete__c, Project_Milestone__c FROM Milestone1_Task__c WHERE id =:strId];
	        	
	        	//タスクが削除された場合、同一マイルストーンの他のタスクの「完了チェック」データを判定
	        	Milestone1_Milestone__c dummyMilestone = [SELECT id, Complete__c, (Select id, Complete__c  From Project_Tasks__r) FROM Milestone1_Milestone__c WHERE Id = :deleteTask.Project_Milestone__c];
	        	boolean isOtherTask = false;
	        	boolean isAllComplete = true;
	        	for(Milestone1_Task__c mt : dummyMilestone.Project_Tasks__r){
	        		isOtherTask = true;
	        		if(mt.Complete__c == false) {
	        			isAllComplete = false;
	        			break;
	        		}
	        	}
	        	delete deleteTask;
	        	if(isOtherTask && isAllComplete){
	        		dummyMilestone.Complete__c = true;
	        		update dummyMilestone;
	        	}
	        	//2013.12.26  追加作業 end
	        	return true;
	        }
        }
        return false; 
    }

}