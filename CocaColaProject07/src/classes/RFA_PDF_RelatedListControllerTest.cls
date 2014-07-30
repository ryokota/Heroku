@isTest
private class RFA_PDF_RelatedListControllerTest {

    static testMethod void RelatedListTest1() {
		
	   // 1.画面で操作するオブジェクトを生成
	    RFA__c testRFA = new RFA__c();
	 
	    // 2.標準コントローラを生成
	    //   オブジェクトを渡してインスタンス化する
	    ApexPages.StandardController sc = new ApexPages.StandardController(testRFA);

	    RFA_PDF_RelatedListController cont = new RFA_PDF_RelatedListController(sc);
	    
    }
}