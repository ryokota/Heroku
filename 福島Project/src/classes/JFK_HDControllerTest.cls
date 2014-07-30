/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_HDControllerTest
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/10/28 Create
 ******************************************************************************/
@isTest
public  class JFK_HDControllerTest {
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
     * propertyTest
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    public static testMethod void propertyTest()
    {
        Test.startTest();

        initTest();     

//      list<JFK_JigyosyoTR__c> lstJigyosyoTR_Jiki = [select id from JFK_JigyosyoTR__c where name = 'JigyosyoTR_Jiki_Test'];

        JFK_HDController hd = new JFK_HDController();
        
        hd.tanto = '1';
        JFK_CommonTR__c retHd = hd.hd;
        System.assertEquals(retHd.HD_Tantosya1__c, UserInfo.getUserId());
        
        hd.tanto = '2';
        retHd = hd.hd;
        System.assertEquals(retHd.HD_Tantosya2__c, UserInfo.getUserId());

        JFK_CheckSheetTR__c retlstHd = hd.checkSheet;

        hd.checkSheetName = 'JCJ';
        hd.checkSheetRecord.CategoryNo__c = 1;
        string ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 2;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 3;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 4;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 5;
        ret = hd.checkSheetCategory;

        hd.checkSheetName = 'JCR1';
        hd.checkSheetRecord.CategoryNo__c = 1;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 2;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 3;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 4;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 5;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 6;
        ret = hd.checkSheetCategory;

        hd.checkSheetName = 'JCR3';
        hd.checkSheetRecord.CategoryNo__c = 1;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 2;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 3;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 4;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 5;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 6;
        ret = hd.checkSheetCategory;
        hd.checkSheetRecord.CategoryNo__c = 7;
        ret = hd.checkSheetCategory;

        System.assertNotEquals(ret, null);

        hd.tanto = '1';
        boolean a = hd.is1stTanto;
        hd.tanto = '2';
        a = hd.is1stTanto;


        hd.close();

        Test.stopTest();
    }

    /*
     * checkErrorTest
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    public static testMethod void checkErrorTest()
    {
        Test.startTest();

        initTest();     

        JFK_HDController hd = new JFK_HDController();

        boolean a = hd.checkError();
        //System.assertEquals(a, false);

        hd.hd.HD_Status__c ='A';
        hd.tanto = '1';
        a = hd.checkError();
        System.assertEquals(a, true);
        
        hd.tanto = '2';
        a = hd.checkError();
        System.assertEquals(a, true);

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

        JFK_HDController hd = new JFK_HDController();

        hd.hd.HD_Status__c ='A';
        hd.tanto = '1';
        hd.hd.HD_HoseiJiko_1st__c = 'AAAA';
        pageReference b = hd.save();
//        System.assertEquals(a, true);
        
        Test.stopTest();
    }

    /*
     * SaveTest2
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
/*
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
*/
    /*
     * ExceptionTest1
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
/*  
    public static testMethod void ExceptionTest1()
    {
        Test.startTest();

        JFK_HMController hm = new JFK_HMController();
        hm.save();

        Test.stopTest();
    }
*/
    /*
     * ExceptionTest2
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
/*
    public static testMethod void ExceptionTest2()
    {
        Test.startTest();

        Apexpages.currentPage().getParameters().put('id','XXX');
        JFK_HMController hm = new JFK_HMController();
        hm.doDelete();

        Test.stopTest();
    }
*/
}