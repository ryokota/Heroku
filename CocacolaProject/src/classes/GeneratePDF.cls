public with sharing class GeneratePDF {
 
public GeneratePDF(ApexPages.StandardController controller) {
 
RFA__c RFA = (RFA__c)controller.getRecord();
 
String RFAName = RFA.Name;
 
//ファイル名を"Account_[取引先番号].pdf"にする
String fileName = 'RFA_' + RFAName + '.pdf';
 
Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + fileName);
 
}
}