/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_HKControllerTest
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/11/04 Create
 ******************************************************************************/
@isTest
public class JFK_HKControllerTest {
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
        list<JFK_RodoSyaTR__c> lstRodosyaTR = new list<JFK_RodosyaTR__c>();
        list<JFK_CommonTR__c> lstHM = new list<JFK_CommonTR__c>();
        list<JFK_CommonTR__c> lstHD = new list<JFK_CommonTR__c>();
        list<JFK_CheckSheetTR__c> lstcheckSheet = new list<JFK_CheckSheetTR__c>();
    
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

        // RodosyaTR
        createData.createRodosyaTR(lstRodosyaTR);
        insert(lstRodosyaTR);

        // CommonTR(HM)
        createData.createHM(lstHM);
        insert(lstHM);

        list<JFK_JigyosyoTR__c> JigyosyoTR_Jiki = [select id from JFK_JigyosyoTR__c where Name = 'JigyosyoTR_Jiki_Test'];       
        JFK_CommonM__c cmnM = [select id from JFK_CommonM__c where Name = 'JCJ' limit 1];

        createData.createCheckSheet(lstcheckSheet, 'a', 1, 1, 1, JigyosyoTR_Jiki, cmnM);
        createData.createCheckSheet(lstcheckSheet, 'c', 2, 1, 3, JigyosyoTR_Jiki, cmnM);

        JFK_RodoSyaTR__c rodosyaTR = [select id from JFK_RodoSyaTR__c limit 1];     
        cmnM = [select id from JFK_CommonM__c where Name = 'JCR' limit 1];
        
        createData.createCheckSheet2(lstcheckSheet, 'a1', 1, 1, 1, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'b1', 2, 1, 2, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'c1', 2, 1, 3, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'd1', 2, 2, 4, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'e1', 2, 3, 5, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'f1', 2, 4, 6, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'g1', 2, 5, 7, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'h1', 2, 6, 8, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'i1', 3, 1, 9, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'j1', 3, 2, 10, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'k1', 3, 3, 11, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'l1', 3, 4, 12, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'm1', 3, 5, 13, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'n1', 3, 6, 14, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'o1', 3, 7, 15, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'p1', 4, 1, 1, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'q1', 5, 1, 1, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'r1', 6, 1, 1, JigyosyoTR_Jiki, rodosyaTR, cmnM);

        cmnM = [select id from JFK_CommonM__c where Name = 'JCR（補充労働者用）' limit 1];
        
        createData.createCheckSheet3(lstcheckSheet, 'a11', 1, 1, 1, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'b11', 1, 2, 2, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'c11', 2, 1, 3, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'd11', 2, 2, 4, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'e11', 2, 3, 5, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'f11', 2, 4, 6, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'g11', 2, 5, 7, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet2(lstcheckSheet, 'h11', 2, 6, 8, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'i11', 3, 1, 9, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'j11', 3, 2, 10, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'k11', 3, 3, 11, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'l11', 3, 4, 12, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'm11', 3, 5, 13, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'n11', 3, 6, 14, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'o11', 3, 7, 15, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'p11', 4, 1, 1, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'q11', 5, 1, 1, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 'r11', 6, 1, 1, JigyosyoTR_Jiki, rodosyaTR, cmnM);
        createData.createCheckSheet3(lstcheckSheet, 's11', 7, 1, 1, JigyosyoTR_Jiki, rodosyaTR, cmnM);

        insert(lstcheckSheet);

        JFK_CheckSheetTR__c chk = [SELECT id from JFK_CheckSheetTR__c where name = 'a' limit 1];
        createData.createHD(lstHD, chk, JigyosyoTR_Jiki);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 'c' limit 1];
        createData.createHD(lstHD, chk, JigyosyoTR_Jiki);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 'a1' limit 1];
        createData.createHD2(lstHD, chk, JigyosyoTR_Jiki, rodosyaTR);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 'b1' limit 1];
        createData.createHD2(lstHD, chk, JigyosyoTR_Jiki, rodosyaTR);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 'i1' limit 1];
        createData.createHD2(lstHD, chk, JigyosyoTR_Jiki, rodosyaTR);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 'p1' limit 1];
        createData.createHD2(lstHD, chk, JigyosyoTR_Jiki, rodosyaTR);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 'q1' limit 1];
        createData.createHD2(lstHD, chk, JigyosyoTR_Jiki, rodosyaTR);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 'r1' limit 1];
        createData.createHD2(lstHD, chk, JigyosyoTR_Jiki, rodosyaTR);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 'a11' limit 1];
        createData.createHD2(lstHD, chk, JigyosyoTR_Jiki, rodosyaTR);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 'c11' limit 1];
        createData.createHD2(lstHD, chk, JigyosyoTR_Jiki, rodosyaTR);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 'i11' limit 1];
        createData.createHD2(lstHD, chk, JigyosyoTR_Jiki, rodosyaTR);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 'p11' limit 1];
        createData.createHD2(lstHD, chk, JigyosyoTR_Jiki, rodosyaTR);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 'q11' limit 1];
        createData.createHD2(lstHD, chk, JigyosyoTR_Jiki, rodosyaTR);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 'r11' limit 1];
        createData.createHD2(lstHD, chk, JigyosyoTR_Jiki, rodosyaTR);

        chk = [SELECT id from JFK_CheckSheetTR__c where name = 's11' limit 1];
        createData.createHD2(lstHD, chk, JigyosyoTR_Jiki, rodosyaTR);


        insert(lstHD);
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
        
        JFK_JigyosyoTR__c jiTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null limit 1];
        Apexpages.currentPage().getParameters().put('jigyoshoTRId', jiTR.Id);
        JFK_HKController hk = new JFK_HKController();
        
        boolean[] arRender = hk.isRender;
        
        string area = hk.areaName;
        
        boolean is1st = hk.is1stTanto;
        
        list<JFK_HKController.wrapper> wrap = hk.lstWrapperSection1_1;
        wrap = hk.lstWrapperSection1_2;
        wrap = hk.lstWrapperSection2_1;
        wrap = hk.lstWrapperSection2_2;
        wrap = hk.lstWrapperSection2_3;
        wrap = hk.lstWrapperSection2_4;
        wrap = hk.lstWrapperSection2_5;
        wrap = hk.lstWrapperSection2_6;
        wrap = hk.lstWrapperSection3_1;
        wrap = hk.lstWrapperSection3_2;
        wrap = hk.lstWrapperSection3_3;
        wrap = hk.lstWrapperSection3_4;
        wrap = hk.lstWrapperSection3_5;
        wrap = hk.lstWrapperSection3_6;
        wrap = hk.lstWrapperSection3_7;
    
        hk.save();  
    
        hk.close();

        hk = new JFK_HKController();

        Test.stopTest();
    }

    /*
     * 
     * 引数 ：
     * 戻り値：
     * 概要 :
     */
    public static testMethod void noDataTest()
    {
        Test.startTest();

        JFK_HKController hk = new JFK_HKController();

        Test.stopTest();
    }
}