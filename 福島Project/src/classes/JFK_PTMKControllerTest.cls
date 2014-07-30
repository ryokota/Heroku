/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_PTMKControllerTest
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/10/30 Create
 ******************************************************************************/
@isTest
public class JFK_PTMKControllerTest {
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

        JFK_PTMKController PTMK = new JFK_PTMKController();
        
        JFK_CommonTR__c retPTMK = PTMK.PTMK;
        System.assertNotEquals(retPTMK, null);
        
        list<JFK_CommonTR__c> a = PTMK.lstPTMKRec;
        
        pageReference b = PTMK.doDelete();
        
        ptmk.ptmkRecord.PTMK_KekkinnBi_From__c = date.valueOf('2013-01-01');
        ptmk.ptmkRecord.PTMK_KekkinnBi_To__c = date.valueOf('2014-01-01');
        pageReference c = PTMK.save();

        ptmk.ptmkRecord.PTMK_KekkinnBi_From__c = date.valueOf('2013-01-01');
        ptmk.ptmkRecord.PTMK_KekkinnBi_To__c = null;
        c = PTMK.save();

        ptmk.ptmkRecord.PTMK_KekkinnBi_From__c = null;
        ptmk.ptmkRecord.PTMK_KekkinnBi_To__c = date.valueOf('2013-01-01');
        c = PTMK.save();

        ptmk.ptmkRecord.PTMK_KekkinnBi_From__c = date.valueOf('2013-01-01');
        ptmk.ptmkRecord.PTMK_KekkinnBi_To__c = date.valueOf('2013-01-01');
        c = PTMK.save();


        list<JFK_CommonTR__c> lstPtmk = new list<JFK_CommonTR__c>();
        JFK_CommonTR__c p = new JFK_CommonTR__c();
        p.PTMK_KekkinnBi_From__c = date.valueOf('2013-01-01');
        p.PTMK_KekkinnBi_To__c = date.valueOf('2013-01-01');
        lstPtmk.add(p);
        ptmk.lstPtmk = lstPtmk;
        c = PTMK.save();


        lstPtmk.clear(); 
        p = new JFK_CommonTR__c();
        p.PTMK_KekkinnBi_From__c = date.valueOf('2013-01-01');
        p.PTMK_KekkinnBi_To__c = null;
        lstPtmk.add(p);
        ptmk.lstPtmk = lstPtmk;
        c = PTMK.save();

        lstPtmk.clear(); 
        p = new JFK_CommonTR__c();
        p.PTMK_KekkinnBi_From__c = null;
        p.PTMK_KekkinnBi_To__c = date.valueOf('2013-01-01');
        lstPtmk.add(p);
        ptmk.lstPtmk = lstPtmk;
        c = PTMK.save();

        lstPtmk.clear(); 
        p = new JFK_CommonTR__c();
        p.PTMK_KekkinnBi_From__c = date.valueOf('2013-01-01');
        p.PTMK_KekkinnBi_To__c = date.valueOf('2013-01-01');
        lstPtmk.add(p);
        ptmk.lstPtmk = lstPtmk;
        c = PTMK.save();

        PTMK.dummy();
        
        PTMK.close();

        Test.stopTest();
    }
}