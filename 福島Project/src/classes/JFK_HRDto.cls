public with sharing class JFK_HRDto {
    /**GS画面出力用のクラス*/
    public JFK_CommonTR__c listJFKCommonTR{get;set;}
    public boolean checkFlag{get;set;}
  
    public JFK_HRDto(JFK_CommonTR__c commonTR,boolean flag){
        listJFKCommonTR = commonTR;
        //rownumber = rownum;
        checkFlag = flag;
    }
}