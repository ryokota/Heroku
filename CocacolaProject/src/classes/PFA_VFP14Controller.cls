public with sharing class PFA_VFP14Controller {
    //RFA
    public RFA__c rfa{get;set;}
    public string test {get;set;}
    public string testName {get;set;}
    /*
    *コンストラクタ
    */
    public PFA_VFP14Controller(ApexPages.StandardController controller)
    {
        this.rfa = (RFA__c)controller.getRecord();
        testName = kaigyo(rfa.Name,1);
        test = rfa.ReturnReason__c;
        /*rfa.Name = kaigyo(rfa.Name,1);
        rfa.ReturnReason__c = kaigyo(rfa.ReturnReason__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);
        rfa.Admin_Comment__c = kaigyo(rfa.Admin_Comment__c,1);*/
    }
    
	private String kaigyo(String value, Integer posLength ){
		if(value == null || value.length() <= posLength) return value;
			String rtnValue = value.substring(0, posLength ) + '<WBR/>';
		for(Integer i = posLength; i < value.length(); i++){ 
			if(Math.mod(i, posLength ) == 0){ 
				if(value.length() > i + posLength){ 
					rtnValue += value.substring(i, i + posLength ) + '<WBR/>';
				}else{
					rtnValue += value.substring(i,value.length());
				}
					//kaigyoCount[col]++;
			}
		} 
		return rtnValue;
	}
}