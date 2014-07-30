@isTest
private class Test_TimeCardCheck {

	private static void testdata(){

		date testOffJTstartDate = system.today();
		date testOffJTendDate = system.today().addMonths(3);
		date testOJTstartDate = system.today().addDays(1).addMonths(3);
		date testOJTendDate = system.today().addDays(1).addMonths(6);
		//integer dataCount = testOffJTstartDate.daysBetween(testOJTendDate);

    	staff_SFO__c testStaffData = new staff_SFO__c(Name = 'テスト訓練生1',
    												  purestaffcode__c = '9999999',
    												  OffJTstart__c = testOffJTstartDate,
    												  OffJTend__c = testOffJTendDate,
    												  OJTstart__c = testOJTstartDate,
    												  OJTend__c = testOJTendDate,
    												  trainingterm__c = '第1期',
    												  phone1__c = '012-3456-7890',
    												  phone2__c = '012-3456-7890',
    												  jobobjective__c = '営業・市場調査コース'
    												  );

		insert testStaffData;

		/*検証*/
		//List<staff_SFO__c> testStaffDataList = [SELECT id FROM staff_SFO__c WHERE Name = 'テスト訓練生1'];

		//system.assertEquals(testStaffDataList.size(), dataCount);

	}

    static testMethod void testUpdate() {

    	//勤怠入力ページ設定
		PageReference pageRef = Page.TimeCardCheck;
		Test.setCurrentPage(pageRef);

		test.startTest();

		testdata();

		TimeCardCheckController tccc = new TimeCardCheckController();

		tccc.getHours();
		tccc.getMinutes();
		tccc.getSFOteamList();

    	tccc.timeCard.Syukkin_Date__c = system.today().addDays(5);
    	tccc.staff.trainingterm__c = '第1期';
    	tccc.teamValue = 'HP作成_A';

    	tccc.doSearch();

		/*検証*/
		date searchDays = system.today().addDays(5);
		string searchTrainingTerm = '第1期';
		string searchTeamValue = 'HP作成_A';
		List<timecard_SFO__c> testTimeCardList = [SELECT id FROM timecard_SFO__c WHERE Syukkin_Date__c =:searchDays AND staff__r.trainingterm__c =:searchTrainingTerm AND staff__r.team__r.name =:searchTeamValue];

		system.assertEquals(testTimeCardList.size(), tccc.tcwList.size());

    	tccc.save();

		test.stopTest();

    }

	static testMethod void testUpdate2() {

    	//勤怠入力ページ設定
		PageReference pageRef = Page.TimeCardCheck;
		Test.setCurrentPage(pageRef);

		testdata();

		TimeCardCheckController tccc = new TimeCardCheckController();

		tccc.getHours();
		tccc.getMinutes();
		tccc.getSFOteamList();
    	tccc.timeCard.Syukkin_Date__c = system.today().addDays(5);
    	tccc.staff.trainingterm__c = '第1期';

    	tccc.doSearch();

		/*検証*/
		date searchDays = system.today().addDays(5);
		string searchTrainingTerm = '第1期';
		List<timecard_SFO__c> testTimeCardList = [SELECT id FROM timecard_SFO__c WHERE Syukkin_Date__c =:searchDays AND staff__r.trainingterm__c =:searchTrainingTerm];

		system.assertEquals(testTimeCardList.size(), tccc.tcwList.size());


    	tccc.save();

	}




}