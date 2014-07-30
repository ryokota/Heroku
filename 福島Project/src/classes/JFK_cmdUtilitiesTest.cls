/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_cmdUtilitiesTest
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2014/01/07 Create
 ******************************************************************************/
@isTest
public class JFK_cmdUtilitiesTest {
    /*
     * getRecordTypeIdTest
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    static testMethod void getRecordTypeIdTest() {
        Test.startTest();

		string strRecordType = JFK_cmdUtilities.getRecordTypeId('Test Record Type');

        Test.stopTest();
	}

    /*
     * chkSaveResultTest
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    static testMethod void chkSaveResultTest() {
        Test.startTest();

		Account act = new Account(Name='Test', KoyoHokenTekiyoJigyosyoNO__c='123');

		Database.saveResult sr = Database.insert(act); 
		Database.saveResult[] lsr = new Database.saveResult[1];
		lsr[0] = sr;
		boolean isSuccess = JFK_cmdUtilities.chkSaveResult(lsr);

		try {		
			act = [select id from Account limit 1];
			sr = Database.insert(act, false); 
			lsr.clear();
			lsr = new Database.saveResult[1];
			lsr[0] = sr;
		} catch (Exception e) {
			isSuccess = JFK_cmdUtilities.chkSaveResult(lsr);
		}
		
        Test.stopTest();
	}
}