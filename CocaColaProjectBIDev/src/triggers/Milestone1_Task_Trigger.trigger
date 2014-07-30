trigger Milestone1_Task_Trigger on Milestone1_Task__c ( before insert, before update,after insert,after update ) {
	//Milestone1_Task__c newObj = null;
	//if(trigger.new != null) newObj = trigger.new[0];
	if(trigger.isBefore) {
		Milestone1_Task_Trigger_Utility.handleTaskBeforeTrigger(trigger.new);
		for(Milestone1_Task__c newObj : trigger.new){
			//OverAll PickList 対応 2014.2.25 Start
			String tempTaskStage = (newObj.Task_Stage__c == null) ? '' : newObj.Task_Stage__c;
			if(newObj.Complete__c == true){
				newObj.OverAll_PickList_Status__c = 'Complete';
			} else if(newObj.Days_Late_Formula__c > 0 && newObj.Blocked__c == true){
				newObj.OverAll_PickList_Status__c = (tempTaskStage.length() > 0) ? 'Late & Blocked ' + tempTaskStage : 'Late & Blocked';
			} else if(newObj.Days_Late_Formula__c > 0){
				newObj.OverAll_PickList_Status__c = (tempTaskStage.length() > 0) ? 'Late ' + tempTaskStage : 'Late';
			} else if(newObj.Blocked__c == true){
				newObj.OverAll_PickList_Status__c = (tempTaskStage.length() > 0) ? 'Blocked ' + tempTaskStage : 'Blocked';
			} else {
				newObj.OverAll_PickList_Status__c = (tempTaskStage.length() > 0) ? 'Open ' + tempTaskStage : 'Open';
			}
			//OverAll PickList 対応 2014.2.25 End
		}
		
	}
	
	if(trigger.isAfter) {
		if(Trigger.isUpdate){
	        //shift Dates of successor Tasks if Task Due Date is shifted
	        Milestone1_Task_Trigger_Utility.checkSuccessorDependencies(trigger.oldMap, trigger.newMap);
		}
		Milestone1_Task_Trigger_Utility.handleTaskAfterTrigger(trigger.new,trigger.old);
	} 

}