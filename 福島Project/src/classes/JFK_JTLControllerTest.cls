/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_jtlControllerTest
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/10/25 Create
 ******************************************************************************/
@isTest
public class JFK_JTLControllerTest {
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
        list<JFK_CommonTR__c> lstJTL = new list<JFK_CommonTR__c>();
        list<JFK_CommonTR__c> lstGS = new list<JFK_CommonTR__c>();
        
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

        // CommonTR(JTL)
        createData.createJTL(lstJTL);
        insert(lstJTL);
        
        // CommonTR(GS)
        createData.createGS(lstGS);
        insert(lstGS);
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
        JFK_JTLController jtl = new JFK_JTLController();

        jtl.getJTL();

        list<JFK_CommonTR__c> a = jtl.tableJTL;
        
        boolean[] b = jtl.renderItems;

        jtl.close();
        
        jtl.showItems();

        jtl.JTLRecord.JTL_Kaden_Juryo__c = '架電';
        jtl.showItems();

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
        JFK_jtlController jtl = new JFK_jtlController();
        
        jtl.jigyosyoTRId = lstJigyosyoTR_Jiki[0].Id;

        jtl.JTLRecord.JijyosyoTR_ShikyuJiki__c = jtl.jigyosyoTRId;
        jtl.JTLRecord.JTL_Hizuke__c = date.valueOf('2013-01-03');
        jtl.JTLRecord.JTL_Kaden_Juryo__c = '架電';


        JFK_CommonTR__c jtl2 = new JFK_CommonTR__c(
              Name = 'JTL_Test2'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備2'
            , JTL_Kaden_Juryo__c = '架電2'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-02-02')
            , JijyosyoTR_ShikyuJiki__c = lstJigyosyoTR_Jiki[0].Id
        );
        jtl.lstJTL.add(jtl2);
        JFK_CommonTR__c jtl3 = new JFK_CommonTR__c(
              Name = 'JTL_Test3'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備3'
            , JTL_Kaden_Juryo__c = '架電3'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-03-04')
            , JijyosyoTR_ShikyuJiki__c = lstJigyosyoTR_Jiki[0].Id
        );
        jtl.lstJTL.add(jtl3);
        insert(jtl.lstJTL);
        
        pageReference ret = jtl.save();

        //System.assertEquals(lstjtl.size(), 1);

        Test.stopTest();
    }

    /*
     * juryoTest1
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    public static testMethod void juryoTest1()
    {
        Test.startTest();

        initTest();     
        list<JFK_JigyosyoTR__c> lstJigyosyoTR_Jiki = [select id from JFK_JigyosyoTR__c where name = 'JigyosyoTR_Jiki_Test'];

        JFK_jtlController jtl = new JFK_jtlController();
        
        jtl.jigyosyoTRId = lstJigyosyoTR_Jiki[0].Id;

        jtl.JTLRecord.JijyosyoTR_ShikyuJiki__c = jtl.jigyosyoTRId;
        jtl.JTLRecord.JTL_Hizuke__c = date.valueOf('2013-01-03');
        jtl.JTLRecord.JTL_Kaden_Juryo__c = '受領';


        pageReference ret = jtl.save();

        //System.assertEquals(lstjtl.size(), 1);

        Test.stopTest();
    }

    /*
     * KadenTest1
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    public static testMethod void KadenTest1()
    {
        Test.startTest();

        initTest();     

        list<JFK_JigyosyoTR__c> lstJigyosyoTR_Jiki = [select id from JFK_JigyosyoTR__c where name = 'JigyosyoTR_Jiki_Test'];

        JFK_jtlController jtl = new JFK_jtlController();

        JFK_CommonTR__c jtl1 = new JFK_CommonTR__c(
              Name = 'JTL_Test1'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備'
            , JTL_Kaden_Juryo__c = '架電'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-02-02')
            , JijyosyoTR_ShikyuJiki__c = lstJigyosyoTR_Jiki[0].Id
        );
        jtl.lstJTL.add(jtl1);
        
        JFK_CommonTR__c jtl2 = new JFK_CommonTR__c(
              Name = 'JTL_Test2'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備'
            , JTL_Kaden_Juryo__c = '架電'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-03-04')
            , JijyosyoTR_ShikyuJiki__c = lstJigyosyoTR_Jiki[0].Id
        );
        jtl.lstJTL.add(jtl2);
        
        JFK_CommonTR__c jtl3 = new JFK_CommonTR__c(
              Name = 'JTL_Test3'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備'
            , JTL_Kaden_Juryo__c = '架電'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-03-04')
            , JijyosyoTR_ShikyuJiki__c = lstJigyosyoTR_Jiki[0].Id
        );
        jtl.lstJTL.add(jtl3);

        JFK_CommonTR__c jtl4 = new JFK_CommonTR__c(
              Name = 'JTL_Test4'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備'
            , JTL_Kaden_Juryo__c = '架電'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-03-04')
            , JijyosyoTR_ShikyuJiki__c = lstJigyosyoTR_Jiki[0].Id
        );
        jtl.lstJTL.add(jtl4);

        JFK_CommonTR__c jtl5 = new JFK_CommonTR__c(
              Name = 'JTL_Test5'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備'
            , JTL_Kaden_Juryo__c = '架電'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-03-04')
            , JijyosyoTR_ShikyuJiki__c = lstJigyosyoTR_Jiki[0].Id
        );
        jtl.lstJTL.add(jtl5);

        JFK_CommonTR__c jtl6 = new JFK_CommonTR__c(
              Name = 'JTL_Test6'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備'
            , JTL_Kaden_Juryo__c = '架電'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-03-04')
            , JijyosyoTR_ShikyuJiki__c = lstJigyosyoTR_Jiki[0].Id
        );
        jtl.lstJTL.add(jtl6);

        JFK_CommonTR__c jtl7 = new JFK_CommonTR__c(
              Name = 'JTL_Test7'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備'
            , JTL_Kaden_Juryo__c = '架電'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-03-04')
            , JijyosyoTR_ShikyuJiki__c = lstJigyosyoTR_Jiki[0].Id
        );
        jtl.lstJTL.add(jtl7);

        JFK_CommonTR__c jtl8 = new JFK_CommonTR__c(
              Name = 'JTL_Test8'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備'
            , JTL_Kaden_Juryo__c = '架電'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-03-04')
            , JijyosyoTR_ShikyuJiki__c = lstJigyosyoTR_Jiki[0].Id
        );
        jtl.lstJTL.add(jtl8);

        JFK_CommonTR__c jtl9 = new JFK_CommonTR__c(
              Name = 'JTL_Test9'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備'
            , JTL_Kaden_Juryo__c = '架電'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-03-04')
            , JijyosyoTR_ShikyuJiki__c = lstJigyosyoTR_Jiki[0].Id
        );
        jtl.lstJTL.add(jtl9);

        JFK_CommonTR__c jtl10 = new JFK_CommonTR__c(
              Name = 'JTL_Test10'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備'
            , JTL_Kaden_Juryo__c = '架電'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-03-04')
            , JijyosyoTR_ShikyuJiki__c = lstJigyosyoTR_Jiki[0].Id
        );
        
        jtl.lstJTL.add(jtl10);

        insert(jtl.lstJTL);
        

        jtl.jigyosyoTRId = lstJigyosyoTR_Jiki[0].Id;

        jtl.JTLRecord.JijyosyoTR_ShikyuJiki__c = jtl.jigyosyoTRId;
        jtl.JTLRecord.JTL_Hizuke__c = date.valueOf('2013-01-03');
        jtl.JTLRecord.JTL_Kaden_Juryo__c = '架電';

        pageReference ret = jtl.save();

        //System.assertEquals(lstjtl.size(), 1);

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
        list<JFK_CommonTR__c> lstjtl = [Select id from JFK_CommonTR__c where RecordKBN__c = 'JTL'];
        list<JFK_JigyosyoTR__c> lstJigyosyoTR_Jiki = [select id from JFK_JigyosyoTR__c where name = 'JigyosyoTR_Jiki_Test'];

        JFK_jtlController jtl = new JFK_jtlController();
        
        jtl.jigyosyoTRId = lstJigyosyoTR_Jiki[0].id;
        
        ApexPages.currentPage().getParameters().put('id', lstjtl[0].Id);

        pageReference ret = jtl.doDelete();

        lstjtl = [Select id from JFK_CommonTR__c where RecordKBN__c = 'JTL'];
//        System.assertEquals(lstjtl.size(), 0);
        
        Test.stopTest();
    }

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

        JFK_jtlController jtl = new JFK_jtlController();
        jtl.save();

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
        JFK_jtlController jtl = new JFK_jtlController();
        jtl.doDelete();

        Test.stopTest();
    }
*/
}