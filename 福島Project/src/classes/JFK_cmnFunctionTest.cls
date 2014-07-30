/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_cmnFunctionTest
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2014/01/07 Create
 ******************************************************************************/
@isTest
public class JFK_cmnFunctionTest {
    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : assembleShikyuJikiテスト
     */
    static testMethod void assembleShikyuJikiTest() {
        Test.startTest();

        string strJiki = JFK_cmnFunction.assembleShikyuJiki(1,1);
        System.assertEquals(strJiki, '1年目6ヶ月後');

        strJiki = JFK_cmnFunction.assembleShikyuJiki(1,2);
        System.assertEquals(strJiki, '1年目1年後');

        Test.stopTest();
    }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : upsertCheckSheetTRテスト
     */
    static testMethod void upsertCheckSheetTRTest() {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        list<JFK_CheckSheetTR__c> lstchksheetTR = [select id, name, seqno__c, no__c, CategoryNo__c from JFK_CheckSheetTR__c];
        JFK_CheckSheetTR__c chksheetTR = lstchksheetTR[0];
        string checkSheetId = JFK_cmnFunction.upsertCheckSheetTR(lstchksheetTR, chksheetTR);
        System.assertNotEquals(checkSheetId, null);

        chksheetTR = new JFK_CheckSheetTR__c(name='AAA', CategoryNo__c=1, no__c=1, seqno__c=1);
        checkSheetId = JFK_cmnFunction.upsertCheckSheetTR(null, chksheetTR);
        System.assertNotEquals(checkSheetId, null);
        
        Test.stopTest();
    }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : setValue2CheckSheetテスト
     */
    static testMethod void setValue2CheckSheetTest() {
        Test.startTest();

        JFK_CheckSheetTR__c chksheetTR = new JFK_CheckSheetTR__c
                                        (
                                              name                          = 'AAA'
                                            , CategoryNo__c                 = 1
                                            , no__c                         = 1
                                            , seqno__c                      = 1
                                            , NoForShow__c                  = 1
                                            , P_HoseiZumi_1st__c            = true
                                            , P_HoseiZumi_2nd__c            = true
                                            , CheckKomoku__c                = 'a'
                                            , CheckNaiyo__c                 = 'a'
                                            , ShowTextBox__c                = true
                                            , PasonaHoseiKa__c              = true
                                            , JigyosyoTR__c                 = null
                                            , CheckSheetName__c             = null
                                            , Ninzu__c                      = 1
                                            , Zokusei__c                    = 'a'
                                            , Hantei_1st__c                 = 'a'
                                            , Hantei_2nd__c                 = 'a'
                                            , Hantei_Checkbox_1st__c        = true
                                            , Hantei_Checkbox_2nd__c        = true
                                            , ActionAfterJudgement__c       = 'a'
                                            , ShowHanteiCheckBox__c         = true
                                            , Biko__c                       = 'a'
                                            , RodosyaTR__c                  = null
                                            , HoseiKanryoBi__c              = date.valueOf('2013-01-01')
                                            , Hosoku__c                     = 'a'
                                        );

        JFK_CheckSheetTR__c checkSheet = JFK_cmnFunction.setValue2CheckSheet(chksheetTR, 1, 1, 1);
        
        System.assertNotEquals(checkSheet, null);

        Test.stopTest();
    }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : getRodosyaInfoFromGSTestテスト
     */
    static testMethod void getRodosyaInfoFromGSTest()
    {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        string[]    tantosyaID      = new string[2];
        string[]    tantosyaName    = new string[2];
        date[]      kanryoDate      = new date[2];
        string[]    status          = new string[2];
        string      totalStatus;
        date        shoruiShinsaKanryoDate;
        
        list<JFK_RodoSyaTR__c> lstRodosyaTR     = [select id, JigyosyoTR_ShikyuJiki__r.id from JFK_RodoSyaTR__c where JigyosyoTR_ShikyuJiki__c != null limit 1]; 
        
        list<JFK_CommonTR__c> lstGS_temp = [select id from JFK_CommonTR__c];
        delete lstGS_temp;

        Profile p = [select id from profile limit 1];
        User u1 = new User(alias = 'standt', email='standarduser@testorg.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1' + Math.random() * 10000 + '@testorg.com');
        
        User u2 = new User(alias = 'standt', email='standarduser@testorg.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser2' + Math.random() * 10000 + '@testorg.com');

        insert u1; insert u2;

        JFK_CommonTR__c gs = new JFK_CommonTR__c
                                                (   
                                                     JigyosyoTR_YearTime__c                 = null
                                                    ,JijyosyoTR_ShikyuJiki__c               = lstRodosyaTR[0].JigyosyoTR_ShikyuJiki__r.id
                                                    ,RodosyaTR__c                           = lstRodosyaTR[0].id
                                                    ,GS_FirstTantosya__c                    = u1.id
                                                    ,GS_SecondTantosya__c                   = u2.id
                                                    ,GS_JissekiSyoruiShinsa_KanryoBi_1st__c = date.valueOf('2013-01-01')
                                                    ,GS_JissekiSyoruiShinsa_KanryoBi_2nd__c = date.valueOf('2013-01-02')
                                                    ,GS_FirstTantosya_Status__c             = 'OK'
                                                    ,GS_SecondTantosya_Status__c            = 'NG'
                                                    ,GS_JissekiSyoruiShinsa_KanryoBi__c     = date.valueOf('2013-01-03')
                                                );
        insert gs;

        list<JFK_RodoSyaTR__c> lstRodosyaTR2 = new list<JFK_RodoSyaTR__c>();
        lstRodosyaTR2 = [select id, JigyosyoTR_ShikyuJiki__c
                            , (select GS_FirstTantosya__c, GS_SecondTantosya__c
                                    , GS_FirstTantosya__r.Name, GS_SecondTantosya__r.Name
                                    , GS_JissekiSyoruiShinsa_KanryoBi_1st__c
                                    , GS_JissekiSyoruiShinsa_KanryoBi_2nd__c, GS_FirstTantosya_Status__c
                                    , GS_SecondTantosya_Status__c, GS_JissekiSyoruiShinsa_KanryoBi__c
                                    , GS_Status__c 
                                from RodosyaTRs2__r
                               ) 
                         from JFK_RodoSyaTR__c
                         where id = :lstRodosyaTR[0].id
                         ];
                                        

        JFK_RodoSyaTR__c RodosyaTR = JFK_cmnFunction.getRodosyaInfoFromGS(
                                                                    lstRodosyaTR2, tantosyaID, tantosyaName, kanryoDate, status
                                                                  , totalStatus, shoruiShinsaKanryoDate);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : chkCompleteTestテスト
     */
    static testMethod void chkCompleteTest()
    {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        list<JFK_CheckSheetTR__c> lstCheckSheet = [select id, ShowTextBox__c, Hantei_1st__c, Hantei_2nd__c from JFK_CheckSheetTR__c limit 1];
        boolean result = JFK_cmnFunction.chkComplete(lstCheckSheet, '1');
        result = JFK_cmnFunction.chkComplete(lstCheckSheet, '2');

        lstCheckSheet[0].Hantei_1st__c = 'NG';
        lstCheckSheet[0].Hantei_2nd__c = 'NG';
        update lstCheckSheet;
        
        result = JFK_cmnFunction.chkComplete(lstCheckSheet, '1');
        result = JFK_cmnFunction.chkComplete(lstCheckSheet, '2');

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : insertGSテスト
     */
    static testMethod void insertGSTest()
    {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c limit 1];
        JFK_RodoSyaTR__c rodosyaTR = [select id from JFK_RodoSyaTR__c limit 1];
        
        JFK_CommonTR__c gs = new JFK_CommonTR__c();
        
        JFK_cmnFunction.insertGS(jigyosyoTR, rodosyaTR, 'http://google.com', '1', false, false, false, false, gs);
        JFK_cmnFunction.insertGS(jigyosyoTR, rodosyaTR, 'http://google.com', '2', false, false, false, false, gs);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : updateGSテスト
     */
    static testMethod void updateGSTest()
    {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c limit 1];
        JFK_RodoSyaTR__c rodosyaTR = [select id from JFK_RodoSyaTR__c limit 1];
        list<JFK_CommonTR__c> gs = [select id, GS_CheckSheetURL1__c, GS_CheckSheetURL2__c from JFK_CommonTR__c where RecordKBN__c = 'GS' limit 1];
        
        JFK_cmnFunction.updateGS(gs, 'http://google.com', jigyosyoTR, rodosyaTR, false, false, '1', false);
        JFK_cmnFunction.updateGS(gs, 'http://google.com', jigyosyoTR, rodosyaTR, false, false, '2', false);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : upsertCheckSheetテスト
     */
    static testMethod void upsertCheckSheetTest()
    {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        list<JFK_CheckSheetTR__c> lstCheckSheet = [select id, CategoryNo__c, No__c, SEQNo__c, ShowTextBox__c, Hantei_1st__c, Hantei_2nd__c from JFK_CheckSheetTR__c limit 1];
        boolean result = JFK_cmnFunction.upsertCheckSheet(1, lstCheckSheet, lstCheckSheet);

        list<JFK_CheckSheetTR__c> lstCheckSheet2 = lstCheckSheet.deepClone();
        lstCheckSheet2[0].SEQNo__c = 2;
        
        result = JFK_cmnFunction.upsertCheckSheet(1, lstCheckSheet, lstCheckSheet2);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : getOkNgテスト
     */
    static testMethod void getOkNgTest()
    {
        Test.startTest();

        list<SelectOption> lstOption = JFK_cmnFunction.getOkNg();
        System.assertNotEquals(lstOption, null);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : getAriNashiテスト
     */
    static testMethod void getAriNashiTest()
    {
        Test.startTest();

        list<SelectOption> lstOption = JFK_cmnFunction.getAriNashi();
        System.assertNotEquals(lstOption, null);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : setValues2GSテスト
     */
    static testMethod void setValues2GSTest()
    {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        list<JFK_CommonTR__c> lstGS_temp = [select id from JFK_CommonTR__c];
        delete lstGS_temp;

        list<JFK_RodoSyaTR__c> lstRodosyaTR     = [select id, JigyosyoTR_ShikyuJiki__r.id from JFK_RodoSyaTR__c where JigyosyoTR_ShikyuJiki__c != null limit 1]; 

        JFK_CommonTR__c gs = new JFK_CommonTR__c
                                                (   
                                                     JigyosyoTR_YearTime__c     = null
                                                    ,JijyosyoTR_ShikyuJiki__c   = lstRodosyaTR[0].JigyosyoTR_ShikyuJiki__r.id
                                                    ,RodosyaTR__c               = lstRodosyaTR[0].id
                                                );
        insert gs;

        boolean result = JFK_cmnFunction.setValues2GS(gs, true, true, '1', false);
        
        gs.GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c = null;
        update gs;
        result = JFK_cmnFunction.setValues2GS(gs, true, false, '1', false);

        gs.GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c = date.valueOf('2014-01-01');
        update gs;
        result = JFK_cmnFunction.setValues2GS(gs, true, true, '1', false);

        result = JFK_cmnFunction.setValues2GS(gs, true, false, '1', false);

        result = JFK_cmnFunction.setValues2GS(gs, true, true, '2', false);

        gs.GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c = null;
        update gs;
        result = JFK_cmnFunction.setValues2GS(gs, true, false, '2', false);
        
        gs.GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c = date.valueOf('2014-01-01');
        update gs;
        result = JFK_cmnFunction.setValues2GS(gs, true, true, '2', false);

        result = JFK_cmnFunction.setValues2GS(gs, true, false, '2', false);

        result = JFK_cmnFunction.setValues2GS(gs, true, false, '2', true);

        //System.assertNotEquals(lstOption, null);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : updateGSテスト2
     */
    static testMethod void updateGSTest2()
    {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c limit 1];
        JFK_RodoSyaTR__c rodosyaTR = [select id from JFK_RodoSyaTR__c limit 1];
        list<JFK_CommonTR__c> gs = new list<JFK_CommonTR__c>();
        Database.saveResult[] lsr;
        
        boolean result = JFK_cmnFunction.updateGS(jigyosyoTR, rodosyaTR, 'http://google.com', '1', true, true, true, false, lsr, gs);

        list<JFK_RodoSyaTR__c> lstRodosyaTR     = [select id, JigyosyoTR_ShikyuJiki__r.id from JFK_RodoSyaTR__c where JigyosyoTR_ShikyuJiki__c != null limit 1]; 
        JFK_CommonTR__c gs2 = new JFK_CommonTR__c
                                (   
                                     JigyosyoTR_YearTime__c     = null
                                    ,JijyosyoTR_ShikyuJiki__c   = lstRodosyaTR[0].JigyosyoTR_ShikyuJiki__r.id
                                    ,RodosyaTR__c               = lstRodosyaTR[0].id
                                );
        insert gs2;
        gs.clear();
        gs.add(gs2);
        result = JFK_cmnFunction.updateGS(jigyosyoTR, rodosyaTR, 'http://google.com', '1', true, true, true, false, lsr, gs);


        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : updateRodosyaTRテスト
     */
    static testMethod void updateRodosyaTRTest()
    {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        JFK_RodoSyaTR__c rodosyaTR = [select id, Biko__c from JFK_RodoSyaTR__c limit 1];
        Database.saveResult[] lsr;
        
        JFK_cmnFunction.updateRodosyaTR(rodosyaTR, true, lsr);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : createSelectOption_CommonMテスト
     */
    static testMethod void createSelectOption_CommonMTest()
    {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        list<JFK_CommonM__c> lstcmnM = [select id, Name from JFK_CommonM__c limit 1];
        
        list<SelectOption> lstOption = JFK_cmnFunction.createSelectOption_CommonM(lstcmnM);
        System.assertNotEquals(lstOption, null);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : Passbackテスト
     */
    static testMethod void PassbackTest()
    {
        Test.startTest();

        list<string> status = new list<string>();
        status.add('完了'); status.add('完了');
        string tanto = '1';
        integer i = 1;
        id[] tantosyaID = new id[2];
        date[] kanryoDate = new date[2];

        boolean result = JFK_cmnFunction.passback(status, tanto, i, tantosyaID, kanryoDate);
        
        tanto = '2';
        result = JFK_cmnFunction.passback(status, tanto, i, tantosyaID, kanryoDate);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : checkError_JCRテスト
     */
    static testMethod void checkError_JCRTest()
    {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        list<JFK_CommonTR__c> lstCommonTR = [select id from JFK_CommonTR__c];
        delete lstCommonTR;
        list<JFK_CheckSheetTR__c> lstCheckSheet = [select id from JFK_CheckSheetTR__c];
        delete lstCheckSheet;

        Contact Rodosya = [select id, Name, RisyokuBi__c, RisyokuRiyu__c, KoyoKeitai__c, KoyoKeitai_HenkoBi__c from Contact limit 1];
        JFK_Bosyu__c Bosyu = [select id, Name, NenMe__c, KaiMe__c, ShikyuJiki_Sushiki__c, ShikyuShimeBi__c, ShikyuKaishiBi__c 
                                from JFK_Bosyu__c 
                                where NenMe__c = 1
                                and   KaiMe__c = 1
                                limit 1];
        JFK_RodoSyaTR__c RodosyaTR = [select id, Name, JigyosyoTR_ShikyuJiki__c from JFK_RodoSyaTR__c limit 1];
        JFK_JigyosyoTR__c JigyosyoTR = [select id, Name, Nendo_Kai_Jigyosyo__r.ShikyuKetteiDate__c from JFK_JigyosyoTR__c where id = :RodosyaTR.JigyosyoTR_ShikyuJiki__c limit 1];
        
        Rodosya.RisyokuBi__c = null;
        Rodosya.RisyokuRiyu__c = null;
        update Rodosya;

        boolean result = JFK_cmnFunction.checkError_JCR(true, true, Rodosya, Bosyu, JigyosyoTR, 'フルタイム', true, RodosyaTR);

        Rodosya.RisyokuBi__c = date.valueOf('2013-01-01');
        update Rodosya;
        jigyosyoTR.Nendo_Kai_Jigyosyo__r.ShikyuKetteiDate__c = date.valueOf('2014-01-01');
        update jigyosyoTR;
        
        result = JFK_cmnFunction.checkError_JCR(true, true, Rodosya, Bosyu, JigyosyoTR, 'フルタイム', true, RodosyaTR);

        Bosyu = [select id, Name, NenMe__c, KaiMe__c, ShikyuJiki_Sushiki__c, ShikyuShimeBi__c, ShikyuKaishiBi__c 
                        from JFK_Bosyu__c 
                        where ShikyuJiki_Sushiki__c != '1-1'
                        limit 1];
        bosyu.ShikyuKaishiBi__c = date.valueOf('2014-01-01');
        update Bosyu;
        result = JFK_cmnFunction.checkError_JCR(true, true, Rodosya, Bosyu, JigyosyoTR, 'フルタイム', true, RodosyaTR);
        
        JFK_CommonM__c cmnM = [select id from JFK_CommonM__c where Name = 'フルタイム' limit 1];
        Rodosya.KoyoKeitai__c = cmnM.id;
        rodosya.KoyoKeitai_HenkoBi__c = null;
        
        update Rodosya;
        result = JFK_cmnFunction.checkError_JCR(true, true, Rodosya, Bosyu, JigyosyoTR, cmnM.id, true, RodosyaTR);

        Rodosya.KoyoKeitai_HenkoBi__c = date.valueOf('2013-01-01');
        update Rodosya;
        result = JFK_cmnFunction.checkError_JCR(true, true, Rodosya, Bosyu, JigyosyoTR, cmnM.id, true, RodosyaTR);

//      System.assertNotEquals(lstOption, null);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : assembleAreaKBNテスト
     */
    static testMethod void assembleAreaKBNTest()
    {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        JFK_JigyosyoTR__c JigyosyoTR = [select id, Name, Nendo_Kai_Jigyosyo__r.Area__c from JFK_JigyosyoTR__c where Area__c = null limit 1];
        string result = JFK_cmnFunction.assembleAreaKBN(JigyosyoTR);

        JigyosyoTR = [select id, Name, Nendo_Kai_Jigyosyo__r.Area__c from JFK_JigyosyoTR__c where Area__c != null limit 1];
        result = JFK_cmnFunction.assembleAreaKBN(JigyosyoTR);

//      System.assertNotEquals(lstOption, null);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : assembleAreaNameテスト
     */
    static testMethod void assembleAreaNameTest()
    {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        JFK_JigyosyoTR__c JigyosyoTR = [select id, Name, Nendo_Kai_Jigyosyo__r.Area__c from JFK_JigyosyoTR__c where Area__c = null limit 1];
        string result = JFK_cmnFunction.assembleAreaName(JigyosyoTR);

        JigyosyoTR = [select id, Name, Nendo_Kai_Jigyosyo__r.Area__c from JFK_JigyosyoTR__c where Area__c != null limit 1];
        result = JFK_cmnFunction.assembleAreaName(JigyosyoTR);

//      System.assertNotEquals(lstOption, null);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : isDisableButtonテスト
     */
    static testMethod void isDisableButtonTest()
    {
        Test.startTest();
        
        string[] status = new string[2];
        status[0] = '完了'; status[1] = '完了';
        id[] tantosyaID = new id[2];
        date[] kanryoDate = new date[2];
        
        boolean result = JFK_cmnFunction.isDisableButton(status, '1', 1, tantosyaID, kanryoDate);
        result = JFK_cmnFunction.isDisableButton(status, '2', 1, tantosyaID, kanryoDate);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : render1stPartテスト
     */
    static testMethod void render1stPartTest()
    {
        Test.startTest();
        
        string[] status = new string[2];
        status[0] = '完了'; status[1] = '完了';
        id[] tantosyaID = new id[2];
        date[] kanryoDate = new date[2];
        
        boolean result = JFK_cmnFunction.render1stPart(status, '1', 1, tantosyaID, kanryoDate);
        result = JFK_cmnFunction.render1stPart(status, '2', 1, tantosyaID, kanryoDate);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : render2ndPartテスト
     */
    static testMethod void render2ndPartTest()
    {
        Test.startTest();
        
        string[] status = new string[2];
        status[0] = '完了'; status[1] = '完了';
        id[] tantosyaID = new id[2];
        date[] kanryoDate = new date[2];
        
        boolean result = JFK_cmnFunction.render2ndPart(status, '1', 1, tantosyaID, kanryoDate);
        result = JFK_cmnFunction.render2ndPart(status, '2', 1, tantosyaID, kanryoDate);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : checkRenderTantosyaテスト
     */
    static testMethod void checkRenderTantosyaTest()
    {
        Test.startTest();
        
        id[] tantosyaID = new id[2];
        date[] kanryoDate = new date[2];
        
        boolean result = JFK_cmnFunction.checkRenderTantosya(0, tantosyaID, kanryoDate);
        result = JFK_cmnFunction.checkRenderTantosya(1, tantosyaID, kanryoDate);

        kanryoDate[0] = date.valueOf('2014-01-01');
        kanryoDate[1] = date.valueOf('2014-01-01');
        result = JFK_cmnFunction.checkRenderTantosya(1, tantosyaID, kanryoDate);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : getTantosyaNameテスト
     */
    static testMethod void getTantosyaNameTest()
    {
        Test.startTest();
        
        string[] tantosyaName = new string[2];
        
        string[] result = JFK_cmnFunction.getTantosyaName(tantosyaName);

        Test.stopTest();
     }

    /*
     * 引数   ：
     * 戻り値  ：
     * 概要   : deleteHDテスト
     */
    static testMethod void deleteHDTest()
    {
        Test.startTest();

        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        JFK_CheckSheetTR__c CheckSheetTR = [select id from JFK_CheckSheetTR__c limit 1];
        JFK_cmnFunction.deleteHD(CheckSheetTR.id);

        Test.stopTest();
     }
}