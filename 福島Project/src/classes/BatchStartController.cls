public with sharing class BatchStartController {

    public PageReference start() {
    
        JFK_SetTeishibi_Batch b=new JFK_SetTeishibi_Batch('a0DN0000001Blxe');//1回
        //JFK_SetTeishibi_Batch b=new JFK_SetTeishibi_Batch('a0DN0000001Blxf');//2回
        
        Database.executeBatch(b, 1);
    
        return null;
    }

}