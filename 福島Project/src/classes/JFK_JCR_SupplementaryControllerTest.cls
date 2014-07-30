/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス		: JFK_JCR_SupplementaryControllerTest
 *  概要		: 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *   2013/12/25 Create
 ******************************************************************************/
@isTest
public class JFK_JCR_SupplementaryControllerTest {
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
        PageReference p = Page.JFK_JCR_Supplementary;
        Test.setCurrentPage(p);

        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_RodoSyaTR__c rodosyaTR = [SELECT Id FROM JFK_RodosyaTR__c limit 1];
        p.getParameters().put('rodosyaTRId', rodosyaTR.Id);

        JFK_JCR_SupplementaryController contJFK_JCR1 = new JFK_JCR_SupplementaryController();
		
		// saveメソッド
        contJFK_JCR1.save();

		// ２つ目のコンストラクタ
        JFK_JCR_SupplementaryController contJFK_JCR2 = new JFK_JCR_SupplementaryController(25, 1, '1-1', act.Id, rodosyaTR.Id);

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
        PageReference p = Page.JFK_JCR_Supplementary;
        Test.setCurrentPage(p);

        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');

        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_RodoSyaTR__c rodosyaTR = [SELECT Id FROM JFK_RodosyaTR__c limit 1];
        p.getParameters().put('rodosyaTRId', rodosyaTR.Id);

        JFK_JCR_SupplementaryController contJFK_JCR1 = new JFK_JCR_SupplementaryController();

		Contact rodosya = contJFK_JCR1.hojuRodosya;
		contJFK_JCR1.hojuRodosya = rodosya;
		rodosya = contJFK_JCR1.hojumotoRodosya;
		contJFK_JCR1.hojumotoRodosya = rodosya;
		string strCreatedRodosyaTRId = contJFK_JCR1.createdRodosyaTRId;
		contJFK_JCR1.createdRodosyaTRId = strCreatedRodosyaTRId;
		
		contJFK_JCR1.getHojumotoInfo();
		
		contJFK_JCR1.passback();
		
		contJFK_JCR1.close();

//		contJFK_JCR1.deleteHD();
		
		contJFK_JCR1.dummy();
		
		string strtantoTimes = contJFK_JCR1.tantoTimes;
		contJFK_JCR1.tantoTimes = strtantoTimes;

		string[] strTantosya = contJFK_JCR1.tantosya;

		string strAreaKbn = contJFK_JCR1.areaKBN;

		string strAreaName = contJFK_JCR1.areaName;

		list<JFK_JCR_SupplementaryController.wrapper> lstCheckSheet = contJFK_JCR1.CheckSheet1;
		lstCheckSheet = contJFK_JCR1.CheckSheet2;
		lstCheckSheet = contJFK_JCR1.CheckSheet3;
		lstCheckSheet = contJFK_JCR1.CheckSheet4;

		list<JFK_CheckSheetTR__c> lstCheckSheetTR = [SELECT Id FROM JFK_CheckSheetTR__c];
		contJFK_JCR1.setValues2Wrapper(lstCheckSheetTR);
		
		boolean blnisDisableButton = contJFK_JCR1.isDisableButton;

		boolean blnrender1stPart = contJFK_JCR1.render1stPart;
        boolean blnrender2ndPart = contJFK_JCR1.render2ndPart;

		boolean blnPassback = contJFK_JCR1.passback;

		list<SelectOption> lstOkNg = contJFK_JCR1.getOkNg();

		list<SelectOption> lstAriNashi = contJFK_JCR1.AriNashi;

		System.currentPageReference().getParameters().put('param', 'true');
		contJFK_JCR1.checkShimei();
		System.currentPageReference().getParameters().put('param', 'false');
		contJFK_JCR1.checkShimei();
		
		System.currentPageReference().getParameters().put('param', 'true');
		contJFK_JCR1.checkKoyoKubun();
		System.currentPageReference().getParameters().put('param', 'false');
		contJFK_JCR1.checkKoyoKubun();

		System.currentPageReference().getParameters().put('param', 'true');
		contJFK_JCR1.checkKoyokeitai();
		System.currentPageReference().getParameters().put('param', 'false');
		contJFK_JCR1.checkKoyokeitai();
		
		System.currentPageReference().getParameters().put('param', 'true');
		contJFK_JCR1.checkKoyoSyurui();
		System.currentPageReference().getParameters().put('param', 'false');
		contJFK_JCR1.checkKoyoSyurui();
		
		System.currentPageReference().getParameters().put('param', 'true');
		contJFK_JCR1.checkHojurodosyaInfo();
		System.currentPageReference().getParameters().put('param', 'false');
		contJFK_JCR1.checkHojurodosyaInfo();
				
		System.currentPageReference().getParameters().put('param', 'true');
		contJFK_JCR1.checkKoyokeitaiHenko();
		System.currentPageReference().getParameters().put('param', 'false');
		contJFK_JCR1.checkKoyokeitaiHenko();
				
		System.currentPageReference().getParameters().put('param', 'true');
		contJFK_JCR1.checkRisyoku();
		System.currentPageReference().getParameters().put('param', 'false');
		contJFK_JCR1.checkRisyoku();
				
		System.currentPageReference().getParameters().put('param', 'true');
		contJFK_JCR1.checkKoyoKeiyaku_KaishiBi();
		System.currentPageReference().getParameters().put('param', 'false');
		contJFK_JCR1.checkKoyoKeiyaku_KaishiBi();
				
		System.currentPageReference().getParameters().put('param', 'true');
		contJFK_JCR1.checkMukyuKekkin();
		System.currentPageReference().getParameters().put('param', 'false');
		contJFK_JCR1.checkMukyuKekkin();

		contJFK_JCR1.checkRisyokuBi();
		
		System.currentPageReference().getParameters().put('param', rodosyaTR.Id);
		contJFK_JCR1.setCreatedRodosyaId();
		
		list<SelectOption> lstrisyokusyasSearch = contJFK_JCR1.risyokusyasSearch;
		
		list<SelectOption> lstkoyoSyuruisSearch = contJFK_JCR1.koyoSyuruisSearch;
		
		list<SelectOption> lstgetKoyoKubunsSearch = contJFK_JCR1.getKoyoKubunsSearch();
		
		list<SelectOption> lstgetKoyoKeitaisSearch = contJFK_JCR1.getKoyoKeitaisSearch();
		
		list<SelectOption> lstkoyoKeitaisHenkoSearch = contJFK_JCR1.koyoKeitaisHenkoSearch;
		
        JFK_CheckSheetTR__c chkSheet = [SELECT Id FROM JFK_CheckSheetTR__c limit 1];
		
		JFK_JCR_SupplementaryController.wrapper wrap = new JFK_JCR_SupplementaryController.wrapper(chkSheet);
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

        contJFK_JCR1 = new JFK_JCR_SupplementaryController();

		blnisDisableButton = contJFK_JCR1.isDisableButton;

        
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
        PageReference p = Page.JFK_JCR_Supplementary;
        Test.setCurrentPage(p);
        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_RodoSyaTR__c rodosyaTR = [SELECT Id, JigyosyoTR_ShikyuJiki__r.Id FROM JFK_RodosyaTR__c limit 1];
        p.getParameters().put('rodosyaTRId', rodosyaTR.Id);

        JFK_JigyosyoTR__c jiryosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE Id = :rodosyaTR.JigyosyoTR_ShikyuJiki__r.Id limit 1];
        JFK_JCR_SupplementaryController contJFK_JCR1 = new JFK_JCR_SupplementaryController();
        
        JFK_CheckSheetTR__c chkSheet = [SELECT Id FROM JFK_CheckSheetTR__c WHERE RodosyaTR__c != null limit 1];
        
        string strId = JFK_JCR_SupplementaryController.showHDScreen(1, 1, 1, 'NG', 25, 1, '1-1', string.ValueOf(act.Id), string.ValueOf(chkSheet.Id), '1', string.ValueOf(jiryosyoTR.Id), string.ValueOf(rodosyaTR.Id));
        strId = JFK_JCR_SupplementaryController.showHDScreen(1, 1, 1, 'OK', 25, 1, '1-1', string.ValueOf(act.Id), string.ValueOf(chkSheet.Id), '1', string.ValueOf(jiryosyoTR.Id), string.ValueOf(rodosyaTR.Id));
		// 労働者が存在していない場合
        strId = JFK_JCR_SupplementaryController.showHDScreen(1, 1, 1, 'NG', 25, 1, '1-1', string.ValueOf(act.Id), string.ValueOf(chkSheet.Id), '2', string.ValueOf(jiryosyoTR.Id), null);
        strId = JFK_JCR_SupplementaryController.showHDScreen(1, 1, 1, 'OK', 25, 1, '1-1', string.ValueOf(act.Id), string.ValueOf(chkSheet.Id), '2', string.ValueOf(jiryosyoTR.Id), null);
		
		// チェックシートが存在しない時のテスト
		// HD/MD/HM/GS削除
		list<JFK_CommonTR__c> cmn = [SELECT Id FROM JFK_CommonTR__c 
									 WHERE RecordKBN__c = 'HD' 
									 OR RecordKBN__c = 'MD' 
									 OR RecordKBN__c = 'HM'
									 OR RecordKBN__c = 'GS'
									];
		delete(cmn);

		list<JFK_CheckSheetTR__c> lstCheckSheet = [SELECT Id FROM JFK_CheckSheetTR__c];
		delete(lstCheckSheet);

        strId = JFK_JCR_SupplementaryController.showHDScreen(1, 1, 1, 'NG', 25, 1, '1-1', string.ValueOf(act.Id), '', '1', string.ValueOf(jiryosyoTR.Id), string.ValueOf(rodosyaTR.Id));

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
        
        //チェックシートテンプレート(JCR_補充者用)：カスタム設定作成
        createData.init4();
        
        PageReference p = Page.JFK_JCR_Supplementary;
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
        
        JFK_JCR_SupplementaryController contJFK_JCR1 = new JFK_JCR_SupplementaryController();

		// RemoteAction call
        string strId = JFK_JCR_1Controller.showHDScreen(1, 1, 1, 'NG', 25, 1, '1-1', string.ValueOf(act.Id), null, '1', string.ValueOf(rodosyaTR.Id));

        test.stopTest();
    }

    /*
     * チェックシートTRが存在する（すべて判定NG)パターンテスト
     */
    static testMethod void getCheckSheetTRFalsePaterTest() {
        test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 

		//事業者Mテストデータ
		List<Account> jigyosyoMList = new List<Account>();
		//事業者TRテストデータ
		List<JFK_JigyosyoTR__c> jigyosyoTRList = new List<JFK_JigyosyoTR__c>();
		//労働者TRテストデータ
		List<JFK_RodoSyaTR__c> rodoSyaTRList = new List<JFK_RodoSyaTR__c>();
		//労働者Mテストデータ
		List<Contact> rodoSyaMList = new List<Contact>();
		//募集Mテストデータ
		List<JFK_Bosyu__c> bosyuList = new List<JFK_Bosyu__c>();
		//汎用Mのリスト
		List<JFK_CommonM__c> commonMList = new List<JFK_CommonM__c>();
		//汎用TRのリスト
		List<JFK_CommonTR__c> commonTRList = new List<JFK_CommonTR__c>();
		//審査シートのリストデータ
		List<JFK_CheckSheetTR__c> chkList = new List<JFK_CheckSheetTR__c>();
		
		//事業所M
		jigyosyoMList.add(createData.createJigyosyoData());
		List<Database.saveresult> srJigyosyoM = Database.insert(jigyosyoMList);

		//汎用M
		commonMList = createData.createCommonMList();
		List<Database.saveresult> srCommonM = Database.insert(commonMList);

		//募集M
		// 年度・回(25年度 １回)
		bosyuList.add(createData.createBosyuM_NendoKaiData());
		List<Database.saveresult> srBosyuMNendoKai = Database.insert(bosyuList);
		bosyuList.remove(0);

		// 支給時期(1-1)
		bosyuList.add(createData.createBosyuM_JikiData(srBosyuMNendoKai[0].getId()));
		List<Database.saveresult> srBosyuMJikiData = Database.insert(bosyuList);

		//労働者M
		rodoSyaMList.add(createData.createContactData1(srJigyosyoM[0].GetID(),srCommonM[7].GetID(),srCommonM[9].GetID(),srCommonM[11].GetID()));
		List<Database.saveresult> srRodoSyaM1 = Database.insert(rodoSyaMList);
		
		rodoSyaMList.remove(0);
		
		// 補充労働者
		rodoSyaMList.add(createData.createContactData2(srJigyosyoM[0].GetID(),srRodoSyaM1[0].GetID(),srCommonM[8].GetID(),srCommonM[10].GetID(),srCommonM[12].GetID()));
		List<Database.saveresult> srRodoSyaM2 = Database.insert(rodoSyaMList);

		//事業所TR
		jigyosyoTRList.add(createData.createJigyosyoTR_NendoKaiData(srJigyosyoM[0].GetId(),srCommonM[13].GetID(),srBosyuMNendoKai[0].GetID()));
		List<Database.saveresult> srJigyosyoTRNendoKai = Database.insert(jigyosyoTRList);

		jigyosyoTRList.remove(0);
		
		jigyosyoTRList.add(createData.createJigyosyoTR_JikiData(srJigyosyoM[0].GetId(),srCommonM[14].GetID(),srJigyosyoTRNendoKai[0].GetID(),srBosyuMJikiData[0].GetID()));
		List<Database.saveresult> srJigyosyoTRJiki = Database.insert(jigyosyoTRList);

		//労働者TR
		rodoSyaTRList.add(createData.createRodosyaTRData(srRodoSyaM2[0].GetID(),srJigyosyoTRJiki[0].GetID(),srCommonM[9].GetID()));
		List<Database.saveresult> srRodosyaTR = Database.insert(rodoSyaTRList);
		
        //チェックシートテンプレート(JCR_補充者用)：カスタム設定作成
        createData.init4();
        
        PageReference p = Page.JFK_JCR_Supplementary;
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
		
		list<JFK_CheckSheetTR__c> lstCheckSheet = [select id from JFK_CheckSheetTR__c];
		delete(lstCheckSheet);
		
		//審査シート(労働者用)
		chkList.add(createCheckSheetData('審査シートテスト2',1,1,1,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',1,2,2,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',1,3,3,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',1,4,4,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',1,5,5,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',1,6,6,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',1,7,7,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',1,8,8,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',2,1,9,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',3,1,10,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',3,2,11,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',3,3,12,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',4,1,13,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',4,2,14,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',4,3,15,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',4,4,16,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',4,5,17,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',4,6,18,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',4,7,19,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));
		chkList.add(createCheckSheetData('審査シートテスト2',4,8,20,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),rodosyaTR.Id,'NG','NG'));

		List<Database.saveresult> srChkList = Database.insert(chkList);
		
        JFK_JCR_SupplementaryController contJFK_JCR1 = new JFK_JCR_SupplementaryController();

        test.stopTest();
    }

    /*
     * 労働者に労働者NOが存在しないパターンテスト
     */
    static testMethod void noRodosyaNOTest() {
        test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        PageReference p = Page.JFK_JCR_Supplementary;
        Test.setCurrentPage(p);

        //ページに引き渡すためのパラメータを設定
		//１次担当者
        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_RodosyaTR__c rodosyaTR = [SELECT Id FROM JFK_RodosyaTR__c Limit 1];
        p.getParameters().put('rodosyaTRId', rodosyaTR.Id);

        JFK_JCR_SupplementaryController contJFK_JCR1 = new JFK_JCR_SupplementaryController();

		contJFK_JCR1.lastName = null;
		contJFK_JCR1.hojuRodosya.FirstName = null;
		contJFK_JCR1.risyokusyaSearch = null;
		contJFK_JCR1.koyoSyuruiSearch = null;
		contJFK_JCR1.koyoKubunSearch = null;
		contJFK_JCR1.koyoKeitaiSearch = null;
		contJFK_JCR1.hojuRodosya.Address__c = null;
		
		contJFK_JCR1.save();

        test.stopTest();
    }

    /*
     * createCheckSheetData
     * 引数 ：
     * 戻り値：
     * 概要 ： 審査シートのテストデータを作成する
     */
	private static JFK_CheckSheetTR__c createCheckSheetData(string SheetName
													, integer cat_no
													, integer no
													, integer seq_no
													, Id cmnM
													, Id jigyosyoTR
													, Id rodosyaTR
													, string hantei1
													, string hantei2) {
							
        JFK_CheckSheetTR__c chk1 = new JFK_CheckSheetTR__c(
              Name = SheetName
            , CheckSheetName__c = cmnM
            , CategoryNo__c = cat_no
            , No__c = no
            , SEQNo__c = seq_no
            , JigyosyoTR__c = jigyosyoTR
            , RodosyaTR__c = rodosyaTR
            , NoForShow__c = 1
            , CheckKomoku__c = 'AAA'
			, Hantei_1st__c = hantei1
			, Hantei_2nd__c = hantei2
        );
        
        return chk1;
    }
}