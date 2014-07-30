trigger Milestone_Permission_Trigger on Milestone_Permission__c (before insert, before update, before delete, 
																after delete, after insert, after update) {
	if(Trigger.isBefore){
		//プロジェクトチームを追加時のチェック
		/*
		if(Trigger.isInsert){
			Milestone_Permission_Trigger_Handler.isCheckUserPM(trigger.new);
		} else if(Trigger.isUpdate){
			Milestone_Permission_Trigger_Handler.isCheckUserPM(trigger.new);
		} else if(Trigger.isDelete){
			Milestone_Permission_Trigger_Handler.isCheckUserPM(trigger.old);
		}
		*/
		if(Trigger.isInsert || Trigger.isUpdate){
			Milestone_Permission_Trigger_Handler.isCheckUserPM(trigger.new);
			for(Milestone_Permission__c c : trigger.new){
				c.UniqueId__c = String.valueOf(c.Project__c) + String.valueOf(c.UserName__c);
			}
		} else if(Trigger.isDelete){
			Milestone_Permission_Trigger_Handler.isCheckUserPM(trigger.old);
		}
	} else {
		if(Trigger.isInsert){
	        Milestone_Permission_Trigger_Handler.insertMilestonePermission(trigger.new);
	    } else if(Trigger.isUpdate){
	        Milestone_Permission_Trigger_Handler.updateMilestonePermission(trigger.old, trigger.new);
	    } else if(Trigger.isDelete){
	        Milestone_Permission_Trigger_Handler.deleteMilestonePermission(trigger.old);
	    }
	}
}