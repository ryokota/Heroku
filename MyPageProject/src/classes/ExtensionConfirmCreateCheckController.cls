public with sharing class ExtensionConfirmCreateCheckController {

    public ExtensionConfirmCreateCheckController(ApexPages.StandardController stdController) {
        
        
        
    }
    
    public pageReference back() {
        
        return new PageReference('http://www.yahoo.co.jp/');
        
    }

}