/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_HMControllerTest
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/10/25 Create
 ******************************************************************************/
@isTest
public class JFK_HMControllerTest {
    /*
     * initTest
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    static testMethod void initTest() {
        list<JFK_Bosyu__c> lstBosyuM_NendoKai = new list<JFK_Bosyu__c>();
        list<JFK_Bosyu__c> lstBosyuM_Jiki = new list<JFK_Bosyu__c>();
        list<JFK_CommonM__c> lstCommonM = new list<JFK_CommonM__c>();
        list<Account> lstJigyosyo = new list<Account>();
        list<Contact> lstRodosya = new list<Contact>();
        list<JFK_JigyosyoTR__c> lstJigyosyoTR_NendoKai = new list<JFK_JigyosyoTR__c>();
        list<JFK_JigyosyoTR__c> lstJigyosyoTR_Jiki = new list<JFK_JigyosyoTR__c>();
        list<JFK_CommonTR__c> lstHM = new list<JFK_CommonTR__c>();
    
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        
        // CommonM
        createData.createCommonM(lstCommonM);
        insert(lstCommonM);
        
        // BosyuM（年度・回）
        createData.createBosyuM_NendoKai(lstBosyuM_NendoKai);
        insert(lstBosyuM_NendoKai);
        
        // BosyuM（時期）
        createData.createBosyuM_Jiki(lstBosyuM_Jiki);
        insert(lstBosyuM_Jiki);

        // Account
        createData.createJigyosyo(lstJigyosyo);
        insert(lstJigyosyo);
        
        // Contact
        createData.createRodosya(lstrodosya);
        insert(lstrodosya);

        // JigyosyoTR_NendoKai
        createData.createJigyosyoTR_NendoKai(lstJigyosyoTR_NendoKai);
        insert(lstJigyosyoTR_NendoKai);

        // JigyosyoTR_Jiki
        createData.createJigyosyoTR_Jiki(lstJigyosyoTR_Jiki);
        insert(lstJigyosyoTR_Jiki);

        // CommonTR(HM)
        createData.createHM(lstHM);
        insert(lstHM);
    }

    /*
     * initTest
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    public static testMethod void propertyTest()
    {
        Test.startTest();

        initTest();     
        list<JFK_JigyosyoTR__c> lstJigyosyoTR_Jiki = [select id from JFK_JigyosyoTR__c where name = 'JigyosyoTR_Jiki_Test'];

        JFK_HMController hm = new JFK_HMController();

        JFK_CommonTR__c retHm = hm.hm;
        System.assertEquals(retHm.HM_Tantosya__c, UserInfo.getUserId());
        
        hm.jigyosyoTRId = lstJigyosyoTR_Jiki[0].Id;
        list<JFK_CommonTR__c> retlstHm = hm.LsthmRec;
        System.assertEquals(retlstHm.size(), 1);

        hm.dummy();
        hm.close();

        Test.stopTest();
    }

    /*
     * deleteTest
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    public static testMethod void deleteTest()
    {
        Test.startTest();

        initTest();     
        list<JFK_CommonTR__c> lstHm = [Select id from JFK_CommonTR__c where Name = 'HM_Test'];

        JFK_HMController hm = new JFK_HMController();
        
        ApexPages.currentPage().getParameters().put('id', lstHm[0].Id);
        pageReference ret = hm.doDelete();

        lstHm = [Select id from JFK_CommonTR__c where Name = 'HM_Test'];
        System.assertEquals(lstHm.size(), 0);
        
        Test.stopTest();
    }

    /*
     * SaveTest1
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    public static testMethod void saveTest1()
    {
        Test.startTest();

        initTest();     
        list<JFK_JigyosyoTR__c> lstJigyosyoTR_Jiki = [select id from JFK_JigyosyoTR__c where name = 'JigyosyoTR_Jiki_Test'];
        list<JFK_CommonTR__c> lstHm = [Select id, HM_TaioBi__c, HM_Aitesaki__c from JFK_CommonTR__c where RecordKBN__c = 'HM'];

        JFK_HMController hm = new JFK_HMController();
        JFK_CommonTR__c retHm = hm.hm;
        list<JFK_CommonTR__c> retlstHm = hm.lsthmRec;
        
        hm.jigyosyoTRId = lstJigyosyoTR_Jiki[0].Id;

        pageReference ret = hm.save();

        System.assertEquals(lstHm.size(), 1);

        Test.stopTest();
    }

    /*
     * SaveTest2
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    public static testMethod void saveTest2()
    {
        Test.startTest();

        initTest();     
        list<JFK_JigyosyoTR__c> lstJigyosyoTR_Jiki = [select id from JFK_JigyosyoTR__c where name = 'JigyosyoTR_Jiki_Test'];
        list<JFK_CommonTR__c> lstHm = [Select id, HM_TaioBi__c, HM_Aitesaki__c from JFK_CommonTR__c where RecordKBN__c = 'HM'];
        delete(lstHm);
        
        JFK_HMController hm = new JFK_HMController();

        hm.hmRecord = new JFK_CommonTR__c();
        hm.hmRecord.JijyosyoTR_ShikyuJiki__c = lstJigyosyoTR_Jiki[0].Id;
        hm.hmRecord.Name = 'HM_Test2';
        hm.hmRecord.RecordKBN__c = 'HM';
        hm.hmRecord.HM_HoseiMemo__c = 'Memo';
        hm.hmRecord.HM_TaioBi__c = date.valueOf('2012-03-03');
        hm.hmRecord.HM_Aitesaki__c = '佐藤さん';

        pageReference ret = hm.save();

        System.assertEquals(lstHm.size(), 1);

        Test.stopTest();
    }

    /*
     * ExceptionTest1
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    public static testMethod void ExceptionTest1()
    {
        Test.startTest();

        JFK_HMController hm = new JFK_HMController();
        hm.save();

        Test.stopTest();
    }

    /*
     * ExceptionTest2
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    public static testMethod void ExceptionTest2()
    {
        Test.startTest();

        Apexpages.currentPage().getParameters().put('id','XXX');
        JFK_HMController hm = new JFK_HMController();
        hm.doDelete();

        Test.stopTest();
    }
}