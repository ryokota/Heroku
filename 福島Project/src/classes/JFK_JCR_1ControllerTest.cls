/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス		: JFK_JCR_1ControllerTest
 *  概要		: 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *   2013/12/24 Create
 ******************************************************************************/
@isTest
public class JFK_JCR_1ControllerTest {
    /*
     * saveメソッドテスト
     */
    static testMethod void checkCompleteTest1() {
        test.startTest();
        
		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        //ページに引き渡すためのパラメータを設定
        PageReference p = Page.JFK_JCR_1;
        Test.setCurrentPage(p);

        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_RodoSyaTR__c rodosyaTR = [SELECT Id FROM JFK_RodosyaTR__c limit 1];
        p.getParameters().put('rodosyaTRId', rodosyaTR.Id);

        JFK_JCR_1Controller contJFK_JCR1 = new JFK_JCR_1Controller();
		
		// saveメソッド
        contJFK_JCR1.save();

		// ２つ目のコンストラクタ
        JFK_JCR_1Controller contJFK_JCR2 = new JFK_JCR_1Controller(25, 1, '1-1', act.Id, rodosyaTR.Id);

        test.stopTest();
    }

    /*
     * Property&簡単なメソッド関連テスト
     */
    static testMethod void propertyAndSimpleMethodTest() {
        test.startTest();

 		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        //ページに引き渡すためのパラメータを設定
        PageReference p = Page.JFK_JCR_1;
        Test.setCurrentPage(p);

        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');

        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_RodoSyaTR__c rodosyaTR = [SELECT Id FROM JFK_RodosyaTR__c limit 1];
        p.getParameters().put('rodosyaTRId', rodosyaTR.Id);

        JFK_JCR_1Controller contJFK_JCR1 = new JFK_JCR_1Controller();

		string strTanto = contJFK_JCR1.tanto;
		contJFK_JCR1.tanto = strTanto;
		date dteKanryoDate = contJFK_JCR1.shoruiShinsaKanryoDate;
		string strTotalStatus = contJFK_JCR1.totalStatus;
		JFK_Bosyu__c bosyu = contJFK_JCR1.bosyu;
		JFK_JigyosyoTR__c jigyoTR = contJFK_JCR1.jigyosyoTR;
		string rodosyaTRid = contJFK_JCR1.rodosyaTRid;
		JFK_RodoSyaTR__c objRodosyaTR = contJFK_JCR1.rodosyaTR;
		contJFK_JCR1.rodosyaTR = contJFK_JCR1.rodosyaTR;
		string strrodosyaCD = contJFK_JCR1.rodosyaCD;
		string strkoyoKeitaiSearch = contJFK_JCR1.koyoKeitaiSearch;
		boolean blnisExistMD = contJFK_JCR1.isExistMD;
		boolean blnisExistHD = contJFK_JCR1.isExistHD;
		boolean blnisExistHM = contJFK_JCR1.isExistHM;
		boolean blnisExistPTMK = contJFK_JCR1.isExistPTMK;
		boolean blnisExistYS = contJFK_JCR1.isExistYS;
		boolean	blnisRisyoku = contJFK_JCR1.isRisyoku;
		boolean	blnisKoyoKeitaiHenko = contJFK_JCR1.isKoyoKeitaiHenko;
		boolean blnisKetsuBan = contJFK_JCR1.isKetsuBan;
		boolean blnisMukyuKekkin = contJFK_JCR1.isMukyuKekkin;
		boolean	blnshowTaisyogaiRodosya = contJFK_JCR1.showTaisyogaiRodosya;

		Contact cont = contJFK_JCR1.rodosyaInfo;
		contJFK_JCR1.rodosyaInfo = cont;
		
		contJFK_JCR1.passback();
		
		contJFK_JCR1.saveTaisyogaiRodosya();
		
		contJFK_JCR1.close();
		
//		contJFK_JCR1.deleteHD();
		
		contJFK_JCR1.dummy();
		
		string strtantoTimes = contJFK_JCR1.tantoTimes;
		contJFK_JCR1.tantoTimes = strtantoTimes;
		
		string[] strTantosya = contJFK_JCR1.tantosya;

		string strAreaKbn = contJFK_JCR1.areaKBN;

		string strAreaName = contJFK_JCR1.areaName;

		list<JFK_JCR_1Controller.wrapper> lstCheckSheet = contJFK_JCR1.CheckSheet1;
		lstCheckSheet = contJFK_JCR1.CheckSheet2;
		lstCheckSheet = contJFK_JCR1.CheckSheet3;

		boolean blnisDisableButton = contJFK_JCR1.isDisableButton;
		boolean blnPassback = contJFK_JCR1.passback;
		list<SelectOption> lstOkNg = contJFK_JCR1.OkNg;
		list<SelectOption> lstAriNashi = contJFK_JCR1.AriNashi;
		
		System.currentPageReference().getParameters().put('param', 'true');
		contJFK_JCR1.checkRisyoku();
		System.currentPageReference().getParameters().put('param', 'false');
		contJFK_JCR1.checkRisyoku();
		
		System.currentPageReference().getParameters().put('param', 'true');
		contJFK_JCR1.checkKoyokeitaiHenko();
		System.currentPageReference().getParameters().put('param', 'false');
		contJFK_JCR1.checkKoyokeitaiHenko();

		System.currentPageReference().getParameters().put('param', 'true');
		contJFK_JCR1.checkMukyuKekkin();
		System.currentPageReference().getParameters().put('param', 'false');
		contJFK_JCR1.checkMukyuKekkin();
		
		contJFK_JCR1.checkRisyokuBi();		
		
		System.currentPageReference().getParameters().put('param', 'true');
		contJFK_JCR1.checkTaisyogaiRodosya();
		System.currentPageReference().getParameters().put('param', 'false');
		contJFK_JCR1.checkTaisyogaiRodosya();
		
        JFK_CheckSheetTR__c chkSheet = [SELECT Id FROM JFK_CheckSheetTR__c limit 1];
		
		JFK_JCR_1Controller.wrapper wrap = new JFK_JCR_1Controller.wrapper(chkSheet);
		chkSheet = wrap.CheckSheet;
		wrap.CheckSheet = chkSheet;
		
        p.getParameters().put('tanto','2');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');

        act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        rodosyaTR = [SELECT Id FROM JFK_RodosyaTR__c limit 1];
        p.getParameters().put('rodosyaTRId', rodosyaTR.Id);

        contJFK_JCR1 = new JFK_JCR_1Controller();

		blnisDisableButton = contJFK_JCR1.isDisableButton;

		boolean blnrender1stPart = contJFK_JCR1.render1stPart;
        boolean blnrender2ndPart = contJFK_JCR1.render2ndPart;
        
        test.stopTest();
    }

    /*
     * CommonTR関連テスト
     */
    static testMethod void commonTRTest() {
        test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

		// HD/MD/HM/GS削除
		list<JFK_CommonTR__c> cmn = [SELECT Id FROM JFK_CommonTR__c 
									 WHERE RecordKBN__c = 'HD' 
									 OR RecordKBN__c = 'MD' 
									 OR RecordKBN__c = 'HM'
									 OR RecordKBN__c = 'GS'
									];
		delete(cmn);

        //ページに引き渡すためのパラメータを設定
        PageReference p = Page.JFK_JCR_1;
        Test.setCurrentPage(p);

        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');

        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_RodoSyaTR__c rodosyaTR = [SELECT Id FROM JFK_RodosyaTR__c limit 1];
        p.getParameters().put('rodosyaTRId', rodosyaTR.Id);

        JFK_JCR_1Controller contJFK_JCR1 = new JFK_JCR_1Controller();

        test.stopTest();
    }

    /*
     * チェックシートTRが存在しないパターンテスト
     */
    static testMethod void noCheckSheetTRTest() {
        test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        //チェックシートテンプレート(JCR1)：カスタム設定作成
        createData.init3();
        
        PageReference p = Page.JFK_JCR_1;
        Test.setCurrentPage(p);

        //ページに引き渡すためのパラメータを設定
		//１次担当者
        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_RodoSyaTR__c rodosyaTR = [SELECT Id FROM JFK_RodosyaTR__c limit 1];
        p.getParameters().put('rodosyaTRId', rodosyaTR.Id);

		// HD/MD/HM/GS削除
		list<JFK_CommonTR__c> cmn = [SELECT Id FROM JFK_CommonTR__c 
									 WHERE RecordKBN__c = 'HD' 
									 OR RecordKBN__c = 'MD' 
									 OR RecordKBN__c = 'HM'
									 OR RecordKBN__c = 'GS'
									];
		delete(cmn);
		
        list<JFK_CheckSheetTR__c> chkSheet = [SELECT Id FROM JFK_CheckSheetTR__c];
        delete(chkSheet);
        
        JFK_JCR_1Controller contJFK_JCR1 = new JFK_JCR_1Controller();

		// RemoteAction call
        string strId = JFK_JCR_1Controller.showHDScreen(1, 1, 1, 'NG', 25, 1, '1-1', string.ValueOf(act.Id), null, '1', string.ValueOf(rodosyaTR.Id));

        test.stopTest();
    }

    /*
     * RemoteActionテスト
     */
    static testMethod void RemoteActionTest() {
        test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        //ページに引き渡すためのパラメータを設定
        PageReference p = Page.JFK_JCR_1;
        Test.setCurrentPage(p);
        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_RodoSyaTR__c rodosyaTR = [SELECT Id FROM JFK_RodosyaTR__c limit 1];
        p.getParameters().put('rodosyaTRId', rodosyaTR.Id);

        JFK_JCR_1Controller contJFK_JCR1 = new JFK_JCR_1Controller();
        
        JFK_CheckSheetTR__c chkSheet = [SELECT Id FROM JFK_CheckSheetTR__c WHERE RodosyaTR__c != null limit 1];
        
        string strId = JFK_JCR_1Controller.showHDScreen(1, 1, 1, 'NG', 25, 1, '1-1', string.ValueOf(act.Id), string.ValueOf(chkSheet.Id), '1', string.ValueOf(rodosyaTR.Id));
        strId = JFK_JCR_1Controller.showHDScreen(1, 1, 1, 'OK', 25, 1, '1-1', string.ValueOf(act.Id), string.ValueOf(chkSheet.Id), '1', string.ValueOf(rodosyaTR.Id));
        strId = JFK_JCR_1Controller.showHDScreen(1, 1, 1, 'NG', 25, 1, '1-1', string.ValueOf(act.Id), string.ValueOf(chkSheet.Id), '2', string.ValueOf(rodosyaTR.Id));
        strId = JFK_JCR_1Controller.showHDScreen(1, 1, 1, 'OK', 25, 1, '1-1', string.ValueOf(act.Id), string.ValueOf(chkSheet.Id), '2', string.ValueOf(rodosyaTR.Id));
		
		// チェックシートが存在しない時のテスト
        strId = JFK_JCR_1Controller.showHDScreen(1, 1, 1, 'NG', 25, 1, '1-1', string.ValueOf(act.Id), '', '1', string.ValueOf(rodosyaTR.Id));

        test.stopTest();
    }
}