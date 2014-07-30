trigger Milestone1_Milestone_Trigger on Milestone1_Milestone__c (before insert, before update, before delete,
																 after insert, after update, after delete) {
	//kim start
	Milestone1_Milestone__c newObj = null;
	Milestone1_Milestone__c oldObj = null;
	if(Trigger.old != null) oldObj = Trigger.old[0];
	if(Trigger.new != null) newObj = Trigger.new[0];
	if(Trigger.isbefore){
		//権限
		List<String> userRoleList = new List<String>();
		userRoleList.add(system.Label.Custom_Milestone_Role_PM_Jp);
		userRoleList.add(system.Label.Custom_Milestone_Role_PM_En);
		userRoleList.add(system.Label.Custom_Milestone_Role_Staff_Jp);
		userRoleList.add(system.Label.Custom_Milestone_Role_Staff_En);
		if(Trigger.isDelete){
			// kim edit start
			Integer cnt = Milestone1_Milestone_Trigger_Utility.getRoleCheck(oldObj.Project__c, userRoleList);
			if(cnt == 0) oldObj.addError(system.Label.Custom_Milestone_err_del);
			//kim edit end
			Milestone1_Milestone_Trigger_Utility.handleMilestoneDeleteTrigger(trigger.oldMap);
		} 
		else if(Trigger.isUpdate){
			// kim edit start
			Integer cnt = Milestone1_Milestone_Trigger_Utility.getRoleCheck(newObj.Project__c, userRoleList);
			if(cnt == 0) newObj.addError(system.Label.Custom_Milestone_err_edit);
			if(oldObj.Complete__c != newObj.Complete__c && newObj.Complete__c == true){
				newObj.CompletedDate__c = System.today();
			}
			//kim edit end
			//prevent manual reparenting of Milestones
			Milestone1_Milestone_Trigger_Utility.checkMilestoneManualReparent(trigger.oldMap, trigger.newMap);
		} 
		else {
			system.debug('***************************userRoleList : '+userRoleList);
			//kim edit start
			Integer cnt = Milestone1_Milestone_Trigger_Utility.getRoleCheck(newObj.Project__c, userRoleList);
			if(newObj.Milestone_Leader__c == null) newObj.Milestone_Leader__c = newObj.OwnerId;
			system.debug('***************************cnt : '+cnt);
			if(cnt == 0) newObj.addError(system.Label.Custom_Milestone_err_create);
			//kim edit end
			//insert
			Milestone1_Milestone_Trigger_Utility.handleMilestoneBeforeTrigger(trigger.new, trigger.newMap);
		}
	} 
	else {
		if(Trigger.isDelete){
			Milestone1_Milestone_Trigger_Utility.handleMilestoneAfterTrigger(trigger.oldMap);
		} 
        else if(Trigger.isUpdate){
            Milestone1_Milestone_Trigger_Utility.handleMilestoneAfterTrigger(trigger.newMap);
            //shift Deadline of successor Milestones if Milestone Deadline is shifted
            Milestone1_Milestone_Trigger_Utility.checkSuccessorDependencies(trigger.oldMap, trigger.newMap);
            //shift children Milestone dates if Milestone dates are shifted
            Milestone1_Milestone_Trigger_Utility.checkChildDependencies(trigger.oldMap, trigger.newMap);
            //shift Task dates if Milestone dates are shifted
            Milestone1_Milestone_Trigger_Utility.checkTaskDependencies(trigger.oldMap, trigger.newMap);
        } 
		else {
			//projectShareからMilestoneShareにチームメンバーを追加する。
			Milestone1_Milestone_Trigger_Utility.handleMilestoneAfterTrigger(trigger.newMap);
			//kim edit start
			List<Milestone1_Milestone__Share> insertShareList = new List<Milestone1_Milestone__Share>();
			for(Milestone1_Project__Share projectShare : [SELECT UserOrGroupId, AccessLevel FROM Milestone1_Project__Share WHERE ParentId =:newObj.Project__c AND AccessLevel != 'All']){
				if(projectShare.UserOrGroupId != newObj.OwnerId){
					Milestone1_Milestone__Share mileShare = new Milestone1_Milestone__Share();
					mileShare.UserOrGroupId = projectShare.UserOrGroupId;
					mileShare.AccessLevel	= projectShare.AccessLevel;
					mileShare.ParentId		= newObj.Id;
					insertShareList.add(mileShare);
				}
			}
			if(insertShareList.size() > 0) insert insertShareList;
			//kim edit end
		}
	}
	
}