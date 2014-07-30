trigger Milestone1_Project_Trigger on Milestone1_Project__c (before update, before delete, before insert, after insert ) {
    if(Trigger.isBefore){
    	if( Trigger.isUpdate ){
	    	//TODO can we delete this?
	        Milestone1_Project_Trigger_Utility.handleProjectUpdateTrigger(trigger.new);
	    } 
	    else if( Trigger.isDelete ) {
	    	//cascades through milestones
	        Milestone1_Project_Trigger_Utility.handleProjectDeleteTrigger(trigger.old);
	    }
	    else if( Trigger.isInsert ) {
	    	User objUser = [SELECT Id FROM User WHERE Name='RFA System'];
	    	trigger.new[0].OwnerId = objUser.Id;
	    	//checks for duplicate names
	        Milestone1_Project_Trigger_Utility.handleProjectInsertTrigger( trigger.new );
	    }
    } else {
    	if(Trigger.isInsert){
    		
    		Milestone_Permission__c editOwner = new Milestone_Permission__c();
    		editOwner.Project__c = trigger.new[0].id;
    		editOwner.UserName__c = UserInfo.getUserId();
    		editOwner.ProjectRole__c = system.Label.Custom_Milestone_Role_PM;
    		insert editOwner;
    	}
    }
    

}