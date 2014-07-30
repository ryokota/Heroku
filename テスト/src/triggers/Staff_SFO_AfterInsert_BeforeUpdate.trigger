trigger Staff_SFO_AfterInsert_BeforeUpdate on staff_SFO__c (after insert, before update) {
	List<timecard_SFO__c> timecardList = new List<timecard_SFO__c>();
	Set<Date> holidayList;
	
	Date getHolidayStartDate;
	Date getHolidayEndDate;
	
	for(staff_SFO__c staff:Trigger.new){
		if(getHolidayStartDate == null){
			if(staff.OffJTstart__c != null){
				getHolidayStartDate = staff.OffJTstart__c;
			}
		}else{
			if(staff.OffJTstart__c != null && staff.OffJTstart__c < getHolidayStartDate){
				getHolidayStartDate = staff.OffJTstart__c;
			}
		}
		
		if(getHolidayEndDate == null){
			if(staff.OJTend__c != null){
				getHolidayEndDate = staff.OJTend__c;
			}
		}else{
			if(staff.OJTend__c != null && staff.OJTend__c > getHolidayEndDate){
				getHolidayEndDate = staff.OJTend__c;
			}
		}
	}
	
	if(getHolidayStartDate != null && getHolidayEndDate != null){
		holidayList = Utility.getHolidays(getHolidayStartDate, getHolidayEndDate);
	}
	
	if(Trigger.isInsert){
		for(staff_SFO__c staff : Trigger.new){
			List<timecard_SFO__c> timecardListTemp = new List<timecard_SFO__c>();
			
			Date setDate = staff.OffJTstart__c;
			while(setDate <= staff.OJTend__c){
				system.debug('■出勤日：' + setDate + '　処理開始');
				timecard_SFO__c timecard = new timecard_SFO__c();
				timecard.staff__c = staff.Id;
				timecard.Syukkin_Date__c = setDate;
				if(holidayList.contains(setDate)){
					timecard.Holiday__c = true;
				}
				
				timecardListTemp.add(timecard);
				
				setDate = Date.newInstance(setDate.year(), setDate.month(), setDate.day() + 1);
				system.debug('■処理終了出勤日：' + setDate);
			}
			
			if(timecardListTemp.size() > 0){
				timecardList.addAll(timecardListTemp);
			}
		}
		
		if(timecardList.size() > 0){
			insert timecardList;
		}
	}
}