/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_cmnFunctionTest
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2014/01/09 Create
 ******************************************************************************/
@isTest
public class JFK_cmnSOQLTest {
    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getBosyu_Nendoテスト
     */
    static testMethod void getBosyu_NendoTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		list<JFK_Bosyu__c> lstResult = JFK_cmnSOQL.getBosyu_Nendo();
		System.assertNotEquals(lstResult, null);
		
        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getBosyu_Kaiテスト
     */
    static testMethod void getBosyu_KaiTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		list<JFK_Bosyu__c> lstResult = JFK_cmnSOQL.getBosyu_Kai(25);
		System.assertNotEquals(lstResult, null);
		
        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getBosyu_Kaiテスト2
     */
    static testMethod void getBosyu_KaiTest2() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		list<JFK_Bosyu__c> lstResult = JFK_cmnSOQL.getBosyu_Kai();
		System.assertNotEquals(lstResult, null);
		
        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getBosyu_Jikiテスト
     */
    static testMethod void getBosyu_JikiTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		list<JFK_Bosyu__c> lstResult = JFK_cmnSOQL.getBosyu_Jiki(25, 1);
		System.assertNotEquals(lstResult, null);
		
        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getBosyu_Jikiテスト2
     */
    static testMethod void getBosyu_JikiTest2() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		list<JFK_Bosyu__c> lstResult = JFK_cmnSOQL.getBosyu_Jiki();
		System.assertNotEquals(lstResult, null);
		
        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getBosyu_1Recテスト
     */
    static testMethod void getBosyu_1RecTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_Bosyu__c Result = JFK_cmnSOQL.getBosyu_1Rec(25, 1, '1-1');
		System.assertNotEquals(Result, null);
		
		Result = JFK_cmnSOQL.getBosyu_1Rec(99, 99, '1-1');
		System.assertEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getAccount4Updateテスト
     */
    static testMethod void getAccount4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		Account act = [select id from Account limit 1];

		list<Account> lstResult = JFK_cmnSOQL.getAccount4Update(act.id);
		System.assertNotEquals(lstResult, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getJigyosyoTR_1RecWithGSテスト
     */
    static testMethod void getJigyosyoTR_1RecWithGSTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		Account act = [select id from Account limit 1];

		JFK_JigyosyoTR__c Result = JFK_cmnSOQL.getJigyosyoTR_1Rec_withGS(25, 1, 1, 1, string.valueOf(act.id));
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getRodosyaTR_withGSテスト
     */
    static testMethod void getRodosyaTR_withGSTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null order by name limit 1];

		list<JFK_RodosyaTR__c> Result = JFK_cmnSOQL.getRodosyaTR_withGS(jigyosyoTR.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getRodosyaTR_withGS_1Recテスト
     */
    static testMethod void getRodosyaTR_withGS_1RecTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_RodoSyaTR__c rodosyaTR = [select id from JFK_RodoSyaTR__c where JigyosyoTR_ShikyuJiki__c != null order by name limit 1];

		list<JFK_RodosyaTR__c> Result = JFK_cmnSOQL.getRodosyaTR_withGS_1Rec(rodosyaTR.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTRテスト
     */
    static testMethod void getCommonTRTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_RodoSyaTR__c rodosyaTR = [select id from JFK_RodoSyaTR__c where JigyosyoTR_ShikyuJiki__c != null order by name limit 1];

		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR(rodosyaTR.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getPTMKinShikyuJikiテスト
     */
    static testMethod void getPTMKinShikyuJikiTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_RodoSyaTR__c rodosyaTR = [select id from JFK_RodoSyaTR__c where JigyosyoTR_ShikyuJiki__c != null order by name limit 1];

		JFK_CommonTR__c ptmk = new JFK_CommonTR__c
												(
												   RodosyaTR__c = rodosyaTR.Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'PTMK'
												 , PTMK_KekkinnBi_From__c = date.valueOf('2013-01-01')
												 , PTMK_KekkinnBi_To__c = date.valueOf('2013-02-02')
    											);
		insert ptmk;
		System.assertNotEquals(ptmk, null);

		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getPTMKinShikyuJiki(rodosyaTR.id, date.valueOf('1900-01-01'), date.valueOf('2020-01-01'));
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCheckSheetTRテスト
     */
    static testMethod void getCheckSheetTRTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_CheckSheetTR__c checkSheetTR = [select id, JigyosyoTR__c from JFK_CheckSheetTR__c where RodosyaTR__c = null order by name limit 1];
		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where id = :checkSheetTR.JigyosyoTR__c limit 1];
		
		list<JFK_CheckSheetTR__c> Result = JFK_cmnSOQL.getCheckSheetTR(jigyosyoTR.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}
	
    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCheckSheetTR_JCR1テスト
     */
    static testMethod void getCheckSheetTR_JCR1Test() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_CheckSheetTR__c checkSheetTR 	= [select id, JigyosyoTR__c, RodosyaTR__c from JFK_CheckSheetTR__c where RodosyaTR__c != null order by name limit 1];
		JFK_JigyosyoTR__c 	jigyosyoTR 		= [select id from JFK_JigyosyoTR__c where id = :checkSheetTR.JigyosyoTR__c limit 1];
		JFK_RodoSyaTR__c 	rodosyaTR 		= [select id from JFK_RodoSyaTR__c where id = :checkSheetTR.RodosyaTR__c limit 1];
		
		list<JFK_CheckSheetTR__c> Result = JFK_cmnSOQL.getCheckSheetTR_JCR1(jigyosyoTR.id, rodosyaTR.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}
	
    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCheckSheetTR_CheckSheetIdテスト
     */
    static testMethod void getCheckSheetTR_CheckSheetIdTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_CheckSheetTR__c checkSheetTR 	= [select id, JigyosyoTR__c, RodosyaTR__c from JFK_CheckSheetTR__c where RodosyaTR__c != null order by name limit 1];
		
		list<JFK_CheckSheetTR__c> Result = JFK_cmnSOQL.getCheckSheetTR_CheckSheetId(checkSheetTR.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}
	
    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_1Recテスト
     */
    static testMethod void getCommonTR_1RecTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_CommonTR__c cmnTR = [select id from JFK_CommonTR__c where CheckSheetTR__c != null and RodosyaTR__c != null order by name limit 1];
		
		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_1Rec(string.valueOf(cmnTR.id));
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}
	
    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonMテスト
     */
    static testMethod void getCommonMTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_CommonM__c cmnM = [select id, BunruiMeisyo__c from JFK_CommonM__c limit 1];
		
		list<JFK_CommonM__c> Result = JFK_cmnSOQL.getCommonM(cmnM.BunruiMeisyo__c);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonM_1Recテスト
     */
    static testMethod void getCommonM_1RecTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_CommonM__c cmnM = [select id, Name, BunruiMeisyo__c from JFK_CommonM__c limit 1];
		
		list<JFK_CommonM__c> Result = JFK_cmnSOQL.getCommonM_1Rec(cmnM.BunruiMeisyo__c, cmnM.Name);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_MDテスト
     */
    static testMethod void getCommonTR_MDTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_CommonTR__c cmnTR = [select JigyosyoTR_YearTime__c from JFK_CommonTR__c where RecordKBN__c = 'MD' limit 1];
		
		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_MD(cmnTR.JigyosyoTR_YearTime__c);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_MDテスト2
     */
    static testMethod void getCommonTR_MDTest2() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_CommonTR__c cmnTR = [select JigyosyoTR_YearTime__c, MD_Group__c from JFK_CommonTR__c where RecordKBN__c = 'MD' and MD_Group__c != null limit 1];
		
		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_MD(cmnTR.JigyosyoTR_YearTime__c, cmnTR.MD_Group__c);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_MD4Updateテスト
     */
    static testMethod void getCommonTR_MD4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_CommonTR__c cmnTR = [select JigyosyoTR_YearTime__c, MD_Group__c from JFK_CommonTR__c where RecordKBN__c = 'MD' and MD_Group__c != null limit 1];
		
		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_MD4Update(cmnTR.JigyosyoTR_YearTime__c, cmnTR.MD_Group__c);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_4Updateテスト
     */
    static testMethod void getCommonTR_4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_CommonTR__c cmnTR = [select id from JFK_CommonTR__c where RecordKBN__c = 'MD' limit 1];
		
		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_4Update(cmnTR.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_4Update_JTLテスト
     */
    static testMethod void getCommonTR_4Update_JTLTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null order by name limit 1];
		JFK_CommonTR__c jtl = new JFK_CommonTR__c
												(
												   JijyosyoTR_ShikyuJiki__c = jigyosyoTR.Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'JTL'
    											);
		insert jtl;
		
		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_4Update_JTL('JTL', jtl.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_JTLテスト
     */
    static testMethod void getCommonTR_JTLTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null order by name limit 1];
		JFK_CommonTR__c jtl = new JFK_CommonTR__c
												(
												   JijyosyoTR_ShikyuJiki__c = jigyosyoTR.Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'JTL'
    											);
		insert jtl;
		
		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_JTL(jtl.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_GS4Updateテスト
     */
    static testMethod void getCommonTR_GS4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null order by name limit 1];
		JFK_CommonTR__c gs = new JFK_CommonTR__c
												(
												   JijyosyoTR_ShikyuJiki__c = jigyosyoTR.Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'GS'
    											);
		insert gs;
		
		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_GS4Update(gs.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_GS4Update2テスト
     */
    static testMethod void getCommonTR_GS4UpdateTest2() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		list<JFK_JigyosyoTR__c> lstJigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null];
		set<id> setJigyosyoTR = new set<id>();
		for (JFK_JigyosyoTR__c j : lstJigyosyoTR) {
			setJigyosyoTR.add(j.id);
		}
		
		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_GS4Update(setJigyosyoTR);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getJigyosyoTRテスト
     */
    static testMethod void getJigyosyoTRTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		list<JFK_JigyosyoTR__c> lstJigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null];
		set<id> setJigyosyoTR = new set<id>();
		for (JFK_JigyosyoTR__c j : lstJigyosyoTR) {
			setJigyosyoTR.add(j.id);
		}
		
		list<JFK_JigyosyoTR__c> Result = JFK_cmnSOQL.getJigyosyoTR(setJigyosyoTR);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_Rodosya4Updateテスト
     */
    static testMethod void getCommonTR_Rodosya4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		list<JFK_RodoSyaTR__c> lstRodosyaTR = [select id from JFK_RodoSyaTR__c];
		set<id> setRodosyaTR = new set<id>();
		for (JFK_RodoSyaTR__c r : lstRodosyaTR) {
			setRodosyaTR.add(r.id);
		}
		
		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_Rodosya4Update(setRodosyaTR);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_Rodosya_GS4Updateテスト2
     */
    static testMethod void getCommonTR_Rodosya4UpdateTest2() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		list<JFK_RodosyaTR__c> lstRodosyaTR = [select id from JFK_RodosyaTR__c limit 1];
		
		JFK_CommonTR__c gs = new JFK_CommonTR__c
												(
												   RodosyaTR__c = lstRodosyaTR[0].Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'GS'
    											);
		insert gs;

		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_Rodosya_GS4Update(lstRodosyaTR[0].id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_YSテスト
     */
    static testMethod void getCommonTR_YSTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		list<JFK_RodoSyaTR__c> lstRodosyaTR = [select id from JFK_RodosyaTR__c limit 1];
		
		JFK_CommonTR__c ys = new JFK_CommonTR__c
												(
												   RodosyaTR__c = lstRodosyaTR[0].Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'YS'
    											);
		insert ys;

		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_YS(lstRodosyaTR[0].id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_YS4Updateテスト
     */
    static testMethod void getCommonTR_YS4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		list<JFK_RodoSyaTR__c> lstRodosyaTR = [select id from JFK_RodosyaTR__c limit 1];
		
		JFK_CommonTR__c ys = new JFK_CommonTR__c
												(
												   RodosyaTR__c = lstRodosyaTR[0].Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'YS'
    											);
		insert ys;

		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_YS4Update(lstRodosyaTR[0].id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_YS4Updateテスト2
     */
    static testMethod void getCommonTR_YS4UpdateTest2() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		list<JFK_RodoSyaTR__c> lstRodosyaTR = [select id from JFK_RodosyaTR__c limit 1];
		
		JFK_CommonTR__c ys = new JFK_CommonTR__c
												(
												   RodosyaTR__c = lstRodosyaTR[0].Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'YS'
    											);
		insert ys;

		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_YS4Update(lstRodosyaTR[0].id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_HDテスト
     */
    static testMethod void getCommonTR_HDTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_CheckSheetTR__c CheckSheetTR = [select id from JFK_CheckSheetTR__c limit 1];
		
		JFK_CommonTR__c hd = new JFK_CommonTR__c
												(
												   CheckSheetTR__c = CheckSheetTR.Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'HD'
    											);
		insert hd;

		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_HD(CheckSheetTR.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_HD4Updateテスト
     */
    static testMethod void getCommonTR_HD4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_CheckSheetTR__c CheckSheetTR = [select id from JFK_CheckSheetTR__c limit 1];
		
		JFK_CommonTR__c hd = new JFK_CommonTR__c
												(
												   CheckSheetTR__c = CheckSheetTR.Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'HD'
    											);
		insert hd;

		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_HD4Update(CheckSheetTR.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_HKテスト
     */
    static testMethod void getCommonTR_HKTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null limit 1];
		
		JFK_CommonTR__c hd = new JFK_CommonTR__c
												(
												   JijyosyoTR_ShikyuJiki__c = jigyosyoTR.Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'HD'
    											);
		insert hd;

		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_HK(jigyosyoTR.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_HMテスト
     */
    static testMethod void getCommonTR_HMTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null limit 1];
		
		JFK_CommonTR__c hm = new JFK_CommonTR__c
												(
												   JijyosyoTR_ShikyuJiki__c = jigyosyoTR.Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'HM'
    											);
		insert hm;

		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_HM(jigyosyoTR.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_PTMKテスト
     */
    static testMethod void getCommonTR_PTMKTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null limit 1];
		
		JFK_CommonTR__c hm = new JFK_CommonTR__c
												(
												   JijyosyoTR_ShikyuJiki__c = jigyosyoTR.Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'PTMK'
    											);
		insert hm;

		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_PTMK(jigyosyoTR.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_HM4Updateテスト
     */
    static testMethod void getCommonTR_HM4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null limit 1];
		
		JFK_CommonTR__c cmn = new JFK_CommonTR__c
												(
												   JijyosyoTR_ShikyuJiki__c = jigyosyoTR.Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'HM'
    											);
		insert cmn;

		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_HM4Update(jigyosyoTR.id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_PTMK4Updateテスト
     */
    static testMethod void getCommonTR_PTMK4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_RodoSyaTR__c RodosyaTR = [select id from JFK_RodosyaTR__c limit 1];
		
		JFK_CommonTR__c cmn = new JFK_CommonTR__c
												(
												   RodosyaTR__c = RodosyaTR.Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'PTMK'
    											);
		insert cmn;

		list<JFK_CommonTR__c> Result = JFK_cmnSOQL.getCommonTR_PTMK4Update(RodosyaTR.Id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_Cnt_Jisseki_YearTimeテスト
     */
    static testMethod void getCommonTR_Cnt_Jisseki_YearTimeTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_YearTime__c != null limit 1];
		JFK_CommonTR__c cmn = new JFK_CommonTR__c
												(
												   JigyosyoTR_YearTime__c = jigyosyoTR.Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'MD'
    											);
		insert cmn;

		integer result = JFK_cmnSOQL.getCommonTR_Cnt_Jisseki_YearTime('MD', jigyosyoTR.Id);
		System.assertNotEquals(Result, 0);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCommonTR_Cnt_Jisseki_SikyuJikiテスト
     */
    static testMethod void getCommonTR_Cnt_Jisseki_SikyuJikiTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null limit 1];
		JFK_CommonTR__c cmn = new JFK_CommonTR__c
												(
												   JijyosyoTR_ShikyuJiki__c = jigyosyoTR.Id
												 , Name = 'TEST'
												 , RecordKBN__c = 'GS'
    											);
		insert cmn;

		integer result = JFK_cmnSOQL.getCommonTR_Cnt_Jisseki_SikyuJiki('GS', jigyosyoTR.Id);
		System.assertNotEquals(Result, 0);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getRodosyaTR_Cnt_Jisseki_SikyuJikiテスト
     */
    static testMethod void getRodosyaTR_Cnt_Jisseki_SikyuJikiTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null order by Name limit 1];

		integer result = JFK_cmnSOQL.getRodosyaTR_Cnt_Jisseki_SikyuJiki(jigyosyoTR.Id);
		System.assertNotEquals(Result, 0);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCheckSheet_1Rec4Updateテスト
     */
    static testMethod void getCheckSheet_1Rec4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null order by Name limit 1];
		JFK_CheckSheetTR__c chk = new JFK_CheckSheetTR__c
												(
												   JigyosyoTR__c = jigyosyoTR.Id
												 , Name = 'TEST'
												 , SEQNo__c = 1
												 , CategoryNo__c = 1
												 , No__c = 1
    											);
		insert chk;

		list<JFK_CheckSheetTR__c> result = JFK_cmnSOQL.getCheckSheet_1Rec4Update(jigyosyoTR.Id, 1);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCheckSheet4Updateテスト
     */
    static testMethod void getCheckSheet4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null order by Name limit 1];
		JFK_CheckSheetTR__c chk = new JFK_CheckSheetTR__c
												(
												   JigyosyoTR__c = jigyosyoTR.Id
												 , Name = 'TEST'
												 , SEQNo__c = 1
												 , CategoryNo__c = 1
												 , No__c = 1
    											);
		insert chk;

		list<JFK_CheckSheetTR__c> result = JFK_cmnSOQL.getCheckSheet4Update(jigyosyoTR.Id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCheckSheet_JCR4Updateテスト
     */
    static testMethod void getCheckSheet_JCR4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_RodoSyaTR__c rodosyaTR = [select id from JFK_RodoSyaTR__c order by Name limit 1];
		JFK_CheckSheetTR__c chk = new JFK_CheckSheetTR__c
												(
												   RodosyaTR__c = rodosyaTR.Id
												 , Name = 'TEST'
												 , SEQNo__c = 1
												 , CategoryNo__c = 1
												 , No__c = 1
    											);
		insert chk;

		list<JFK_CheckSheetTR__c> result = JFK_cmnSOQL.getCheckSheet_JCR4Update(rodosyaTR.Id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}

    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getCheckSheet_JCR4Updateテスト2
     */
    static testMethod void getCheckSheet_JCR4UpdateTest2() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_RodoSyaTR__c rodosyaTR = [select id from JFK_RodoSyaTR__c order by Name limit 1];
		JFK_CheckSheetTR__c chk = new JFK_CheckSheetTR__c
												(
												   RodosyaTR__c = rodosyaTR.Id
												 , Name = 'TEST'
												 , SEQNo__c = 1
												 , CategoryNo__c = 1
												 , No__c = 1
    											);
		insert chk;

		list<JFK_CheckSheetTR__c> result = JFK_cmnSOQL.getCheckSheet_JCR4Update(rodosyaTR.Id, integer.valueOf(chk.SEQNo__c));
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}
	
    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getRisyokusyaテスト
     */
    static testMethod void getRisyokusyaTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		Account jigyosyo = [select id from Account order by Name limit 1];
		Contact rodosya = [select id, Ketsuban__c, RisyokuBi__c, RisyokuRiyu__c from Contact where AccountId = :jigyosyo.Id order by Name limit 1];
		rodosya.Ketsuban__c = false;
		rodosya.RisyokuBi__c = date.valueOf('2014-01-01');
		rodosya.RisyokuRiyu__c = JFK_cmnConstant.RISYOKU_RIYU_JIKOTSUGO;
		update rodosya;
		
		list<Contact> result = JFK_cmnSOQL.getRisyokusya(jigyosyo.Id, date.valueOf('2013-12-01'), date.valueOf('2014-02-01'));
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}
	
    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getHojumotosyaテスト
     */
    static testMethod void getHojumotosyaTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		Account jigyosyo = [select id from Account order by Name limit 1];
		list<Contact> result = JFK_cmnSOQL.getHojumotosya(jigyosyo.Id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}
	
    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getRisyokusyaInJigyosyoテスト
     */
    static testMethod void getRisyokusyaInJigyosyoTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		Account jigyosyo = [select id from Account order by Name limit 1];
		list<Contact> result = JFK_cmnSOQL.getRisyokusyaInJigyosyo(jigyosyo.Id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}
	
    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getRodosyaInfoテスト
     */
    static testMethod void getRodosyaInfoTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		Account jigyosyo = [select id from Account order by Name limit 1];
		list<Contact> result = JFK_cmnSOQL.getRodosyaInfo(jigyosyo.Id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}
	
    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getJigyosyoTR4Updateテスト
     */
    static testMethod void getJigyosyoTR4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_JigyosyoTR__c jigyosyoTR = [select id from JFK_JigyosyoTR__c order by Name limit 1];
		list<JFK_JigyosyoTR__c> result = JFK_cmnSOQL.getJigyosyoTR4Update(jigyosyoTR.Id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}
	
    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getRodosyaMaxNoテスト
     */
    static testMethod void getRodosyaMaxNoTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		Account jigyosyo = [select id from Account order by Name limit 1];
		list<Contact> result = JFK_cmnSOQL.getRodosyaMaxNo(jigyosyo.Id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}
	
    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	: getRodosyaTR4Updateテスト
     */
    static testMethod void getRodosyaTR4UpdateTest() {
        Test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		JFK_RodoSyaTR__c rodosyaTR = [select id from JFK_RodoSyaTR__c order by Name limit 1];
		list<JFK_RodoSyaTR__c> result = JFK_cmnSOQL.getRodosyaTR4Update(rodosyaTR.Id);
		System.assertNotEquals(Result, null);

        Test.stopTest();
	}
}