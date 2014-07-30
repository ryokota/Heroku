public class Groupfor3RE{
// Data class

    public class Data {
        public String entity { get; set; } 
        public String chan { get; set; }     
        public Integer tre { get; set; }
        public String tar { get; set; }        
        public Integer rr { get; set; }
        public Integer fte { get; set; }
        public String vert { get; set; }
        public String terr { get; set; }              
        public Integer rrr { get; set; }
        public String tier { get; set; }
        public Date time1 { get; set; }






        public Data(String entity,  String chan, Integer tre, String tar, Integer rr, Integer fte, 
                    String vert, String terr,  Integer rrr,  String tier, Date time1) {
            this.entity = entity;
            this.chan = chan;
            this.tre = tre;
            this.tar = tar;
            this.rr = rr;
            this.fte = fte;
            this.vert = vert;            
            this.terr = terr;            
            this.rrr = rrr;
            this.tier = tier;
            this.time1 = time1;


        }
    }
    public List<Data> getChartData1(){
    List<AggregateResult> arList = [SELECT  Account_Management_Type__c Type, 
                                    Sales_Channel__c Channel,
                                    AVG(X3RE__c) cThreeRE ,
                                    Target_Industry_from_account__c Target,
                                    AVG(Total_RR_Converted_to_USD__c)cRR, 
                                    MAX(FTE__c) cFTE,
                                    Territory_Vertical__c Vertical,
                                    Territory_from_account__c Territory, 
                                    AVG(Referenceable_Recurring_Revenue_R_RR__c) cRRR,  
                                    Tier__c Tier,
                                    Date__c Day

                                    from X3RE_Snapshot_Data__c

                                    group by  Account_Management_Type__c, Sales_Channel__c,  Target_Industry_from_account__c, 
                                    Territory_Vertical__c  , Territory_from_account__c ,  Tier__c, Date__c];

    List<Data> dataList = new List<Data>();
    for (AggregateResult ar : arList){       
        String Type = String.valueOf(ar.get('Type'));
        String Channel = String.valueOf(ar.get('Channel'));       
        Integer cThree_RE = Integer.valueOf(ar.get('cThreeRE'));        
        String Target = String.valueOf(ar.get('Target'));        
        Integer cRR = Integer.valueOf(ar.get('cRR')); 
        Integer cFTE = Integer.valueOf(ar.get('cFTE'));
        String Vertical = String.valueOf(ar.get('Vertical'));
        String Territory = String.valueOf(ar.get('Territory'));        
        Integer cRRR = Integer.valueOf(ar.get('cRRR'));   
        String Tier = String.valueOf(ar.get('Tier'));        
        Date Day = Date.valueOf(ar.get('Day'));


        dataList.add(new Data( Type, Channel, cThree_RE, Target, cRR, cFTE, Vertical,  
                               Territory,  cRRR,  Tier,  Day));
}



return dataList;

}

}