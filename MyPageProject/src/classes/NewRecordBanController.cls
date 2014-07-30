public with sharing class NewRecordBanController {

    public String staffContractPrefixKey    { get; set; }
    public String ExtensionConfirmPrefixKey { get; set; }
    
    public NewRecordBanController(ApexPages.StandardController stdController) {
        
        this.staffContractPrefixKey    = getKeyPrefix('StaffContract__c');
        this.ExtensionConfirmPrefixKey = getKeyPrefix('ExtensionConfirm__c');
    }
    
    private String getKeyPrefix(String objName) {
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sObjType = gd.get(objName);
        return sObjType.getDescribe().getKeyPrefix();
        
    }

}