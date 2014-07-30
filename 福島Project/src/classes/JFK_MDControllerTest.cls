/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス		: JFK_MDControllerTest
 *  概要		: 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *   2013/12/28 Create
 ******************************************************************************/
@isTest
public class JFK_MDControllerTest {
    /*
     * Constructorテスト
     */
    static testMethod void ConstructorTest() {
        test.startTest();
        
		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        //ページに引き渡すためのパラメータを設定
        JFK_JigyosyoTR__c JigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE Nendo_Kai_Jigyosyo__c = null limit 1];
        System.currentPageReference().getParameters().put('jigyoshoTRParentId', JigyosyoTR.Id);

        JFK_MDController contMD = new JFK_MDController();

        test.stopTest();
    }

    /*
     * Get/Set Property&Method テスト
     */
    static testMethod void getSetTest() {
        test.startTest();
        
		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        //ページに引き渡すためのパラメータを設定
        JFK_JigyosyoTR__c JigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE Nendo_Kai_Jigyosyo__c = null limit 1];
        System.currentPageReference().getParameters().put('jigyoshoTRParentId', JigyosyoTR.Id);

        JFK_MDController contMD = new JFK_MDController();
        
        contMD.getMD();
        
        list<boolean> lstdoRender = contMD.doRender;
        
        list<JFK_CommonTR__c> lsttableMD = contMD.tableMD;
        
        test.stopTest();
    }

    /*
     * showItems テスト
     */
    static testMethod void showItemsTest() {
        test.startTest();
        
		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        //ページに引き渡すためのパラメータを設定
        JFK_JigyosyoTR__c JigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE Nendo_Kai_Jigyosyo__c = null limit 1];
        System.currentPageReference().getParameters().put('jigyoshoTRParentId', JigyosyoTR.Id);

        JFK_MDController contMD = new JFK_MDController();
        
		contMD.showItems();

        contMD.mdRecord.MD_Group__c ='連絡先の指定';
		contMD.showItems();
        
		list<JFK_CommonTR__c> lstMD = [select id from JFK_CommonTR__c where RecordKBN__c = 'MD'];
		delete(lstMD);        
		contMD.showItems();
        
        contMD.mdRecord.MD_Group__c = JFK_cmnConstant.MD_GroupName_Ininjo;
		contMD.showItems();

        contMD.mdRecord.MD_Group__c = JFK_cmnConstant.MD_GroupName_ShikyuTeishi;
		contMD.showItems();

        contMD.mdRecord.MD_Group__c = JFK_cmnConstant.MD_GroupName_JigyonushiTsugo;
		contMD.showItems();

        contMD.mdRecord.MD_Group__c = JFK_cmnConstant.MD_GroupName_Shukkosya;
		contMD.showItems();

        contMD.mdRecord.MD_Group__c = JFK_cmnConstant.MD_GroupName_Sonota;
		contMD.showItems();

        test.stopTest();
    }

    /*
     * doRenderTable テスト
     */
    static testMethod void doRenderTableTest() {
        test.startTest();
        
		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        //ページに引き渡すためのパラメータを設定
        JFK_JigyosyoTR__c JigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE Nendo_Kai_Jigyosyo__c = null limit 1];
        System.currentPageReference().getParameters().put('jigyoshoTRParentId', JigyosyoTR.Id);

        JFK_MDController contMD = new JFK_MDController();

		JFK_CommonTR__c md = new JFK_CommonTR__c(Name = 'MD_Test1', RecordKBN__c = 'MD', JigyosyoTR_YearTime__c = jigyosyoTR.Id, MD_Group__c = JFK_cmnConstant.MD_GroupName_Renrakusaki);
		contMD.lstMd.add(md);
		md = new JFK_CommonTR__c(Name = 'MD_Test2', RecordKBN__c = 'MD', JigyosyoTR_YearTime__c = jigyosyoTR.Id, MD_Group__c = JFK_cmnConstant.MD_GroupName_Ininjo);
		contMD.lstMd.add(md);
		md = new JFK_CommonTR__c(Name = 'MD_Test3', RecordKBN__c = 'MD', JigyosyoTR_YearTime__c = jigyosyoTR.Id, MD_Group__c = JFK_cmnConstant.MD_GroupName_ShikyuTeishi);
		contMD.lstMd.add(md);
		md = new JFK_CommonTR__c(Name = 'MD_Test4', RecordKBN__c = 'MD', JigyosyoTR_YearTime__c = jigyosyoTR.Id, MD_Group__c = JFK_cmnConstant.MD_GroupName_JigyonushiTsugo);
		contMD.lstMd.add(md);
		md = new JFK_CommonTR__c(Name = 'MD_Test5', RecordKBN__c = 'MD', JigyosyoTR_YearTime__c = jigyosyoTR.Id, MD_Group__c = JFK_cmnConstant.MD_GroupName_Shukkosya);
		contMD.lstMd.add(md);
		md = new JFK_CommonTR__c(Name = 'MD_Test6', RecordKBN__c = 'MD', JigyosyoTR_YearTime__c = jigyosyoTR.Id, MD_Group__c = JFK_cmnConstant.MD_GroupName_Sonota);
		contMD.lstMd.add(md);
		
		list<boolean> lstdoRenderTable = contMD.doRenderTable;

        test.stopTest();
    }

    /*
     * doDelete テスト
     */
    static testMethod void doDeleteTest() {
        test.startTest();
        
		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        //ページに引き渡すためのパラメータを設定
		list<JFK_CommonTR__c> lstMD = [select id from JFK_CommonTR__c where RecordKBN__c = 'MD'];
        System.currentPageReference().getParameters().put('id', lstMD[0].Id);

        JFK_MDController contMD = new JFK_MDController();
        
		contMD.doDelete();
       
        test.stopTest();
    }

    /*
     * save テスト
     */
    static testMethod void saveTest() {
        test.startTest();
        
		//テストデータ作成クラス
		JFK_CreateData4Test createData = new JFK_CreateData4Test(); 
        //初期データ作成
        createData.init();
        
        JFK_MDController contMD = new JFK_MDController();
        
		contMD.save();

        JFK_JigyosyoTR__c JigyosyoTR = [SELECT Id FROM JFK_JigyosyoTR__c WHERE Nendo_Kai_Jigyosyo__c = null limit 1];
		contMD.mdRecord = new JFK_CommonTR__c(Name = 'MD_Test1', RecordKBN__c = 'MD', JigyosyoTR_YearTime__c = jigyosyoTR.Id, MD_Group__c = JFK_cmnConstant.MD_GroupName_Renrakusaki);

		contMD.save();
		
		contMD.close();
       
        test.stopTest();
    }
}