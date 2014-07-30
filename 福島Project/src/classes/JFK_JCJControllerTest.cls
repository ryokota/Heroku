/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス		: JFK_JCJControllerTest
 *  概要        	: 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/11/07 Create
 ******************************************************************************/
@isTest
private class JFK_JCJControllerTest {

    /*
     * checkCompleteメソッドテスト（１次担当者）
     */
    static testMethod void checkCompleteTest1() {
        test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        //ページに引き渡すためのパラメータを設定
        PageReference p = Page.JFK_JCJ;
        Test.setCurrentPage(p);

        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_JigyosyoTR__c jigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE BosyuJoho_ShikyuJiki__c != null];
        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

        JFK_JCJController contJFK_JCJ = new JFK_JCJController();
        contJFK_JCJ.save();

        JFK_JCJController contJFK_JCJ2 = new JFK_JCJController(25, 1, '1-1', act.Id);

        test.stopTest();
    }

    /*
     * checkCompleteメソッドテスト（2次担当者）
     */
    static testMethod void checkCompleteTest2() {
		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
		
        test.startTest();
        
        //初期データ作成
        createData.init();
        
        //ページに引き渡すためのパラメータを設定
        PageReference p = Page.JFK_JCJ;
        Test.setCurrentPage(p);

        p.getParameters().put('tanto','2');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_JigyosyoTR__c jigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE BosyuJoho_ShikyuJiki__c != null];
        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

        JFK_JCJController contJFK_JCJ = new JFK_JCJController();
        contJFK_JCJ.save();

        test.stopTest();
    }

    /*
     * checkCompleteメソッドテスト（return値=falseパターン）
     */
    static testMethod void checkCompleteTest3() {
		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
		
        test.startTest();
        
        //初期データ作成
        createData.init();
        
        //ページに引き渡すためのパラメータを設定
        PageReference p = Page.JFK_JCJ;
        Test.setCurrentPage(p);

		//１次担当者
        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_JigyosyoTR__c jigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE BosyuJoho_ShikyuJiki__c != null];
        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

		list<JFK_CheckSheetTR__c> lstchkSheet = [SELECT id, Hantei_1st__c, Hantei_2nd__c FROM JFK_CheckSheetTR__c WHERE RodosyaTR__c = null];
		integer i = 0;
		for (JFK_CheckSheetTR__c chkSheet : lstchkSheet) {
			if (i == 1 ) {
				chkSheet.Hantei_1st__c = null;
			}
			i++;
		}
		update(lstchkSheet);
		
        JFK_JCJController contJFK_JCJ = new JFK_JCJController();
        contJFK_JCJ.save();
		
		i = 0;
		for (JFK_CheckSheetTR__c chkSheet : lstchkSheet) {
			if (i == 0 ) {
				chkSheet.Hantei_1st__c = null;
			}
			i++;
		}
		update(lstchkSheet);
		
        contJFK_JCJ = new JFK_JCJController();
        contJFK_JCJ.save();

		// ２次担当者
        p.getParameters().put('tanto','2');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        p.getParameters().put('jigyosyoid', act.Id);

        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

		i = 0;
		for (JFK_CheckSheetTR__c chkSheet : lstchkSheet) {
			if (i == 1 ) {
				chkSheet.Hantei_2nd__c = null;
			}
			i++;
		}
		update(lstchkSheet);
		
        contJFK_JCJ = new JFK_JCJController();
        contJFK_JCJ.save();
		
		i = 0;
		for (JFK_CheckSheetTR__c chkSheet : lstchkSheet) {
			if (i == 0 ) {
				chkSheet.Hantei_2nd__c = null;
			}
			i++;
		}
		update(lstchkSheet);
		
        contJFK_JCJ = new JFK_JCJController();
        contJFK_JCJ.save();

        test.stopTest();
    }

    /*
     * CommonTRが存在しないパターンテスト
     */
    static testMethod void noCommonTRTest() {
        test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        PageReference p = Page.JFK_JCJ;
        Test.setCurrentPage(p);

        //ページに引き渡すためのパラメータを設定
		//１次担当者
        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_JigyosyoTR__c jigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE BosyuJoho_ShikyuJiki__c != null];
        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

		// HD/MD/HM/GS削除
		list<JFK_CommonTR__c> cmn = [SELECT Id FROM JFK_CommonTR__c 
									 WHERE RecordKBN__c = 'HD' 
									 OR RecordKBN__c = 'MD' 
									 OR RecordKBN__c = 'HM'
									 OR RecordKBN__c = 'GS'
									];
		delete(cmn);
		
        JFK_JCJController contJFK_JCJ = new JFK_JCJController();

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
        PageReference p = Page.JFK_JCJ;
        Test.setCurrentPage(p);
        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_JigyosyoTR__c jigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE BosyuJoho_ShikyuJiki__c != null];
        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

        JFK_JCJController contJFK_JCJ = new JFK_JCJController();
        
        JFK_CheckSheetTR__c chkSheet = [SELECT Id FROM JFK_CheckSheetTR__c WHERE RodosyaTR__c = null limit 1];
        
        string strId = JFK_JCJController.showHDScreen(1, 1, 1, 'NG', 25, 1, '1-1', string.ValueOf(act.Id), string.ValueOf(chkSheet.Id), '1');
        strId = JFK_JCJController.showHDScreen(1, 1, 1, 'OK', 25, 1, '1-1', string.ValueOf(act.Id), string.ValueOf(chkSheet.Id), '1');
        strId = JFK_JCJController.showHDScreen(1, 1, 1, 'NG', 25, 1, '1-1', string.ValueOf(act.Id), string.ValueOf(chkSheet.Id), '2');
        strId = JFK_JCJController.showHDScreen(1, 1, 1, 'OK', 25, 1, '1-1', string.ValueOf(act.Id), string.ValueOf(chkSheet.Id), '2');
		
		// チェックシートが存在しない時のテスト
        strId = JFK_JCJController.showHDScreen(1, 1, 1, 'NG', 25, 1, '1-1', string.ValueOf(act.Id), '', '1');

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
        
        //チェックシートテンプレート(JCJ)：カスタム設定作成
        createData.init2();
        
        PageReference p = Page.JFK_JCJ;
        Test.setCurrentPage(p);

        //ページに引き渡すためのパラメータを設定
		//１次担当者
        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_JigyosyoTR__c jigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE BosyuJoho_ShikyuJiki__c != null];
        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

		// HD/MD/HM/GS削除
		list<JFK_CommonTR__c> cmn = [SELECT Id FROM JFK_CommonTR__c 
									 WHERE RecordKBN__c = 'HD' 
									 OR RecordKBN__c = 'MD' 
									 OR RecordKBN__c = 'HM'
									 OR RecordKBN__c = 'GS'
									];
		delete(cmn);
		
        list<JFK_CheckSheetTR__c> lstChkSheet = [SELECT Id FROM JFK_CheckSheetTR__c WHERE RodosyaTR__c = null];
		delete(lstChkSheet);

        JFK_JCJController contJFK_JCJ = new JFK_JCJController();

        test.stopTest();
    }

    /*
     * その他メソッドテスト
     */
    static testMethod void otherMethodsTest() {
        test.startTest();

		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        
        //初期データ作成
        createData.init();
        
 		// GS削除
		list<JFK_CommonTR__c> cmn = [SELECT Id FROM JFK_CommonTR__c 
									 WHERE RecordKBN__c = 'GS' 
									];
		delete(cmn);
 
        PageReference p = Page.JFK_JCJ;
        Test.setCurrentPage(p);

        //ページに引き渡すためのパラメータを設定
		//１次担当者
        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_JigyosyoTR__c jigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE BosyuJoho_ShikyuJiki__c != null];
        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

        JFK_JCJController contJFK_JCJ = new JFK_JCJController();
		
        contJFK_JCJ.save();
        contJFK_JCJ.passback();
//        contJFK_JCJ.updateApplication();
//        contJFK_JCJ.approveApplication();
//        contJFK_JCJ.rejectApplication();
        contJFK_JCJ.close();
//        contJFK_JCJ.deleteHD();
//        contJFK_JCJ.resetScreen();
        contJFK_JCJ.dummy();
        string[] strTantosya = contJFK_JCJ.tantosya;
        string strTantoTimes = contJFK_JCJ.tantoTimes;
        contJFK_JCJ.tantoTimes = strTantoTimes;
        string strKbn = contJFK_JCJ.areaKBN;
        string strArea = contJFK_JCJ.areaName;
        list<JFK_JCJController.wrapper> lstCheck = contJFK_JCJ.CheckSheet1;
        lstCheck = contJFK_JCJ.CheckSheet2;
        lstCheck = contJFK_JCJ.CheckSheet3;
//        contJFK_JCJ.previousSection();
//        contJFK_JCJ.nextSection();
//        boolean isRenderUpdateApplicationButton = contJFK_JCJ.isRenderUpdateApplicationButton;
//        boolean isBoss = contJFK_JCJ.isBoss;
        boolean isDisableButton = contJFK_JCJ.isDisableButton;
		boolean blnRender = contJFK_JCJ.render1stPart;
		blnRender = contJFK_JCJ.render2ndPart;
		boolean blnBack = contJFK_JCJ.passback;
        List<SelectOption> okNg = contJFK_JCJ.getOkNg();
        list<JFK_JCJController.wrapper4rodosya> a = contJFK_JCJ.lstRodosyaTRWrap;
        JFK_CommonTR__c hd = contJFK_JCJ.hd;
        contJFK_JCJ.doCalc();

        JFK_RodosyaTR__c rodosyaTR = [SELECT Id FROM JFK_RodosyaTR__c limit 1];	
        JFK_JCJController.wrapper4rodosya wrap4 = new JFK_JCJController.wrapper4rodosya(rodosyaTR);

        JFK_CheckSheetTR__c chkSheet = [SELECT Id FROM JFK_CheckSheetTR__c WHERE RodosyaTR__c = null limit 1];
        JFK_JCJController.wrapper wrap = new JFK_JCJController.wrapper(chkSheet);

        boolean isExistHD = contJFK_JCJ.isExistHD;
        boolean isExistHM = contJFK_JCJ.isExistHM;
        boolean isExistMD = contJFK_JCJ.isExistMD;

		//２次担当者
 		// GS削除
		cmn = [SELECT Id FROM JFK_CommonTR__c WHERE RecordKBN__c = 'GS'];
		delete(cmn);

        p.getParameters().put('tanto','2');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        p.getParameters().put('jigyosyoid', act.Id);
        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

        contJFK_JCJ = new JFK_JCJController();

        contJFK_JCJ.save();
        contJFK_JCJ.passback();
//        contJFK_JCJ.updateApplication();
//        contJFK_JCJ.approveApplication();
//        contJFK_JCJ.rejectApplication();
        contJFK_JCJ.close();
//        contJFK_JCJ.deleteHD();
//        contJFK_JCJ.resetScreen();
        contJFK_JCJ.dummy();
        strTantosya = contJFK_JCJ.tantosya;
        strTantoTimes = contJFK_JCJ.tantoTimes;
        contJFK_JCJ.tantoTimes = strTantoTimes;
        strKbn = contJFK_JCJ.areaKBN;
        strArea = contJFK_JCJ.areaName;
        lstCheck = contJFK_JCJ.CheckSheet1;
        lstCheck = contJFK_JCJ.CheckSheet2;
        lstCheck = contJFK_JCJ.CheckSheet3;
//        contJFK_JCJ.previousSection();
//        contJFK_JCJ.nextSection();
//        isRenderUpdateApplicationButton = contJFK_JCJ.isRenderUpdateApplicationButton;
//        isBoss = contJFK_JCJ.isBoss;
        isDisableButton = contJFK_JCJ.isDisableButton;
		blnRender = contJFK_JCJ.render1stPart;
		blnRender = contJFK_JCJ.render2ndPart;
		blnBack = contJFK_JCJ.passback;
        okNg = contJFK_JCJ.getOkNg();
        a = contJFK_JCJ.lstRodosyaTRWrap;
        hd = contJFK_JCJ.hd;
        contJFK_JCJ.doCalc();

        isExistHD = contJFK_JCJ.isExistHD;
        isExistHM = contJFK_JCJ.isExistHM;
        isExistMD = contJFK_JCJ.isExistMD;
        
        test.stopTest();
    }
    
    static testMethod void TestisRenderUpdateApplicationButton() {
        test.startTest();
        
		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        PageReference p = Page.JFK_JCJ;
        Test.setCurrentPage(p);

		list<JFK_CommonTR__c> lstCmn = [SELECT Id FROM JFK_CommonTR__c WHERE RecordKBN__c = 'GS'];
        for (JFK_CommonTR__c a : lstCmn) {
        	a.GS_FirstTantosya_Status__c = '1次審査完了';
        	a.GS_SecondTantosya_Status__c = '2次審査完了';
        }
        update(lstCmn);

        //ページに引き渡すためのパラメータを設定
		//１次担当者
        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_JigyosyoTR__c jigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE BosyuJoho_ShikyuJiki__c != null];
        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

        JFK_JCJController contJFK_JCJ = new JFK_JCJController();

//        boolean blnIsRender = contJFK_JCJ.isRenderUpdateApplicationButton;

		//２次担当者
        p.getParameters().put('tanto','2');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        p.getParameters().put('jigyosyoid', act.Id);
        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

        contJFK_JCJ = new JFK_JCJController();

//        blnIsRender = contJFK_JCJ.isRenderUpdateApplicationButton;
 
        test.stopTest();
    }    

    static testMethod void TestisBoss() {
        test.startTest();
        
		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        PageReference p = Page.JFK_JCJ;
        Test.setCurrentPage(p);

		list<JFK_CommonTR__c> lstCmn = [SELECT Id FROM JFK_CommonTR__c WHERE RecordKBN__c = 'GS'];
        for (JFK_CommonTR__c a : lstCmn) {
        	a.GS_FirstTantosya_Status__c = '修正申請中';
        	a.GS_SecondTantosya_Status__c = '修正申請中';
        	a.GS_JissekiSyoruiShinsa_KanryoBi_1st__c = date.valueOf('2013-01-01');
        	a.GS_JissekiSyoruiShinsa_KanryoBi_2nd__c = date.valueOf('2013-01-01');
        }
        update(lstCmn);

        //ページに引き渡すためのパラメータを設定
		//１次担当者
        p.getParameters().put('tanto','1');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_JigyosyoTR__c jigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE BosyuJoho_ShikyuJiki__c != null];
        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

        JFK_JCJController contJFK_JCJ = new JFK_JCJController();

//        boolean blnIsRender = contJFK_JCJ.isBoss;

		//２次担当者
        p.getParameters().put('tanto','2');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        p.getParameters().put('jigyosyoid', act.Id);
        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

        contJFK_JCJ = new JFK_JCJController();

//        blnIsRender = contJFK_JCJ.isBoss;
 
        test.stopTest();
    }    

    static testMethod void TestException() {
        test.startTest();
        
		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();

        PageReference p = Page.JFK_JCJ;
        Test.setCurrentPage(p);

        //ページに引き渡すためのパラメータを設定
		//１次担当者
        p.getParameters().put('tanto','9999999');
        p.getParameters().put('nendo','25');
        p.getParameters().put('kai','1');
        p.getParameters().put('jiki','1-1');
        
        Account act = [SELECT Id FROM Account Limit 1];
        p.getParameters().put('jigyosyoid', act.Id);

        JFK_JigyosyoTR__c jigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE BosyuJoho_ShikyuJiki__c != null];
        p.getParameters().put('jigyosyoTRId', jigyosyoTR.Id);

        JFK_JCJController contJFK_JCJ = new JFK_JCJController();
        
        contJFK_JCJ.save();
        
        test.stopTest();
    }    
}