/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_Menu_JCJControllerTest
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/11/07 Create
 ******************************************************************************/
@isTest
private class JFK_Menu_JCJControllerTest {

    /*
        検索ボタン押下時のテスト
    */
    static testMethod void doSearchTest() {
        test.startTest();
        
        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        
        //初期データ作成
        createData.init();
        list<JFK_JigyosyoTR__c> lstJigyosyoTR = [SELECT Id, Nendo_Kai_Jigyosyo__c, Nendo_Kai_Jigyosyo__r.Area__c FROM JFK_JigyosyoTR__c WHERE Nendo_Kai_Jigyosyo__c != null];
        
        JFK_Menu_JCJController menuJFK = new JFK_Menu_JCJController();
        
        List<SelectOption> resultsNendo = menuJFK.nendos4Search;
        List<SelectOption> resultsKai = menuJFK.kais4Search;
        List<SelectOption> resultsJiki = menuJFK.jikis4Search;
        List<SelectOption> resultsArea = menuJFK.areas4Search;
        menuJFK.area4Search = '県北';
        menuJFK.kai4Search = '1';
        menuJFK.jiki4Search = '1';
        menuJFK.nendo4Search = '25';
        menuJFK.jigyosyoMei4Search = '須藤システム株式会社';
        menuJFK.seiriNo4Search = '123';

        boolean blnShowMessage = menuJFK.showMessage;
        
//        menuJFK.updateGS();
        menuJFK.doSearch();
        menuJFK.showFirstPage();
        menuJFK.showPreviousPage();
        menuJFK.showNextPage();
        menuJFK.showLastPage();

        string pageNumber = menuJFK.PageNumber;
        boolean firstBtnDisable = menuJFK.firstBtnDisable;
        boolean lastBtnDisable = menuJFK.lastBtnDisable;
        boolean isBoss = menuJFK.isBoss;
        menuJFK.tokusashi();
        menuJFK.dummy();
        
        for (JFK_JigyosyoTR__c jTR : lstJigyosyoTR) {
            menuJFK.EntireSelectedIds.add(jTR.Id);
        }
        
        menuJFK.tokusashi();
        
        list<JFK_Menu_JCJController.wrapper> wrap = menuJFK.lstJigyoshoTR;
        
        JFK_Menu_JCJController.wrapper wrapper = new JFK_Menu_JCJController.wrapper(lstJigyosyoTR[0]);
        JFK_JigyosyoTR__c wjTR = wrapper.jigyoshoTR;
        JFK_CommonTR__c wgs = wrapper.gs;
        boolean blnIsSelected = wrapper.isSelected;
        string warea = wrapper.area;
        
        // setControllerがnullの場合
        menuJFK.setController = null;
        
        firstBtnDisable = menuJFK.firstBtnDisable;
        lastBtnDisable = menuJFK.lastBtnDisable;
        
        menuJFK = new JFK_Menu_JCJController();
        
        list<JFK_Bosyu__c> lstBosyu = new list<JFK_Bosyu__c>();
        JFK_Bosyu__c a = new JFK_Bosyu__c(
              Name = '25年度第2回'
            , BosyuNendo__c = 25
            , BosyuKai__c = 2
        );
        lstBosyu.add(a);        
        JFK_Bosyu__c b = new JFK_Bosyu__c(
              Name = '26年度第2回'
            , BosyuNendo__c = 26
            , BosyuKai__c = 2
        );
        lstBosyu.add(b);        
        insert(lstBosyu);
        
        lstBosyu.clear();
        lstBosyu = [select id from JFK_Bosyu__c where Name = '25年度第2回'];
        JFK_Bosyu__c c = new JFK_Bosyu__c(
              Name = '1-1'
            , Bosyu__c = lstBosyu[0].Id
            , NenMe__c = 1
            , KaiMe__c = 1
        );
        
        insert(c);
        
        List<SelectOption> lstNendos4Search = menuJFK.nendos4Search;
        List<SelectOption> lstKais4Search = menuJFK.kais4Search;
        List<SelectOption> lstJikis4Search = menuJFK.jikis4Search;

        menuJFK.area4Search = null;
        menuJFK.kai4Search = null;
        menuJFK.jiki4Search = null;
        menuJFK.nendo4Search = null;
        menuJFK.jigyosyoMei4Search = null;
        menuJFK.seiriNo4Search = null;

        menuJFK.doSearch();
        List<JFK_Menu_JCJController.wrapper> lstJTR = menuJFK.lstJigyoshoTR;
        
        test.stopTest();
        //system.assertNotEquals(menuJFK.listJigyoshoTR.size, 0);
    }

    /*
        actionFunctionのテスト
     */
    static testMethod void actionFunctionTest() {
        test.startTest();
        
        //テストデータ作成クラス
        JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        //ページに引き渡すためのパラメータを設定
        PageReference p = Page.JFK_JCJ;

        JFK_Menu_JCJController contJFK_JCJ = new JFK_Menu_JCJController();

        System.currentPageReference().getParameters().put('param', 'true');
        contJFK_JCJ.doSearch();
        
        test.stopTest();
        //system.assertNotEquals(menuJFK.listJigyoshoTR.size, 0);
    }
}