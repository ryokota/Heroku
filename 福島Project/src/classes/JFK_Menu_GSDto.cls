public class JFK_Menu_GSDto {
    
    /**GS画面出力用のクラス*/
    public JFK_CommonTR__c listJFKCommonTR{get;set;}
    public boolean checkFlag{get;set;}
  
    public JFK_Menu_GSDto(JFK_CommonTR__c commonTR,boolean flag){
        listJFKCommonTR = commonTR;
        //rownumber = rownum;
        checkFlag = flag;
    }
    
}