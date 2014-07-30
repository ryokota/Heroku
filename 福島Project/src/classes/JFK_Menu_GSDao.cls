public class JFK_Menu_GSDao {
    
    //汎用TRデータ取得
    public Database.QueryLocator getCommonTRData(integer nendo4Search,
                                                 integer kai4Search,
                                                 string area4Search,
                                                 string seiriNo4Search,
                                                 string jiki4Search,
                                                 string jigyosyoMei4Search,
                                                 string rodosyaMei4Search,
                                                 string status4Search){
        
        string commonTRSOQL = '';
        string gs = 'GS';
        //汎用TR用のSOQL文章作成
        commonTRSOQL  ='SELECT GS_FirstTantosya__r.Name,        ';
        commonTRSOQL +='GS_SecondTantosya__r.Name,              '; 
        commonTRSOQL +='GS_Status__c,                           ';
        commonTRSOQL +='GS_RemindDM_HassoBi__c,                 ';
        commonTRSOQL +='GS_JissekiHokokusyo_JuryoBi__c,         ';
        commonTRSOQL +='GS_JissekiSyoruiShinsa_ChakusyuBi__c,   ';
        commonTRSOQL +='GS_JissekiSyoruiShinsa_KanryoBi__c,     ';
        commonTRSOQL +='GS_JissekigakuData_HikiwatashiBi__c,    ';
        commonTRSOQL +='GS_JissekiHokokuSyorui_HikiwatashiBi__c,';
        commonTRSOQL +='GS_ShikyugauTsuchisho_HikiwatashiBi__c, ';
        commonTRSOQL +='GS_ShikyugakuTsuchisho_JuryoBi__c,      ';
        commonTRSOQL +='GS_ShikyugakuTsuchisho_HassoBi__c,      ';
        commonTRSOQL +='GS_JigyosyoMei__c,                      ';
        commonTRSOQL +='GS_HasshutuShiji_Ukebi__c,              ';
        commonTRSOQL +='GS_Bikou__c,                            ';
        commonTRSOQL +='GS_Shikyu_Torikeshi__c,                 ';
        commonTRSOQL +='GS_Shikyu_Syuryo__c,                    ';
        commonTRSOQL +='GS_JigyoshoCD__c,                       ';
        commonTRSOQL +='GS_ShikyuJiki__c,                       ';
        commonTRSOQL +='JijyosyoTR_ShikyuJiki__r.id,            ';
        commonTRSOQL +='GS_RodoshaShimei__c,                    ';
        commonTRSOQL +='JijyosyoTR_ShikyuJiki__r.Account__r.id, ';
        commonTRSOQL +='GS_Shikyu_Joutai__c,                    ';
        commonTRSOQL +='GS_Seiri_No__c                          ';  
        commonTRSOQL +='FROM JFK_CommonTR__c                    ';
        
        //初期条件:労働者TRがNULL
        commonTRSOQL +='WHERE RodosyaTR__c = NULL               ';
        commonTRSOQL +='AND JijyosyoTR_ShikyuJiki__c != NULL    ';
        commonTRSOQL +='AND RecordKBN__c = :gs                  ';
        

        
        commonTRSOQL += makeWhere(nendo4Search,kai4Search,area4Search,seiriNo4Search,
                                                jiki4Search,jigyosyoMei4Search,rodosyaMei4Search,status4Search);
                                                    
        //結果のリストを返す
        return Database.getQueryLocator(commonTRSOQL);
        
    }
    
    public integer getCommonTRDataCount(integer nendo4Search,
                                        integer kai4Search,
                                        string area4Search,
                                        string seiriNo4Search,
                                        string jiki4Search,
                                        string jigyosyoMei4Search,
                                        string rodosyaMei4Search,
                                        string status4Search){

        // 該当件数チェック
        string strSOQL = 'SELECT'
                        + '  COUNT()'
                        + ' FROM JFK_CommonTR__c'
                        + ' WHERE RodosyaTR__c != null';
        strSOQL += makeWhere(nendo4Search,kai4Search,area4Search,seiriNo4Search,
                              jiki4Search,jigyosyoMei4Search,rodosyaMei4Search,status4Search);
            
        return Database.countQuery(strSOQL);
    }
    
    private string makeWhere(integer nendo4Search,
                             integer kai4Search,
                             string area4Search,
                             string seiriNo4Search,
                             string jiki4Search,
                             string jigyosyoMei4Search,
                             string rodosyaMei4Search,
                             string status4Search){
        
        //Where句作成用
        string whereString = '';
        //汎用TR用のSOQL文章 AND句作成
        if (nendo4Search != null){
            whereString += ' AND GS_Boshu_Nendo__c = :nendo4Search ';
        }
        
        if (kai4Search != null){
            whereString += ' AND GS_Boshu_Kai__c = :kai4Search ';
        }
        if (area4Search != null){
            whereString += ' AND GS_Area_Kubun__c = :area4Search ';
        }
        if (seiriNo4Search != ''){
            whereString += ' AND GS_Seiri_No__c = :seiriNo4Search ';
        }
        if (jiki4Search != null){
            whereString += ' AND GS_ShikyuJiki__c =:jiki4Search ';
        }
        if (jigyosyoMei4Search != ''){
            whereString += ' AND GS_JigyosyoMei__c Like \'%'+ jigyosyoMei4Search + '%\'';
        }
        if (rodosyaMei4Search != ''){
            whereString += ' AND GS_RodoshaShimei__c Like \'%'+ rodosyaMei4Search + '%\'';
        }
        if (status4Search != null){
            whereString += ' AND GS_Status__c = :status4Search ';
        }
        return whereString;
    }
    
    //汎用TRデータ取得
    public List<JFK_CommonTR__c> getCommonTRSummaryData(integer nendo4Search,
                                                        integer kai4Search,
                                                        string jiki4Search){

        return [SELECT GS_RemindDM_HassoBi__c,                                                          
                GS_JissekiHokokusyo_JuryoBi__c,
                GS_JissekiSyoruiShinsa_ChakusyuBi__c,   
                GS_JissekiSyoruiShinsa_KanryoBi__c,     
                GS_JissekigakuData_HikiwatashiBi__c,    
                GS_JissekiHokokuSyorui_HikiwatashiBi__c,
                GS_ShikyugauTsuchisho_HikiwatashiBi__c, 
                GS_ShikyugakuTsuchisho_JuryoBi__c,      
                GS_ShikyugakuTsuchisho_HassoBi__c,      
                GS_HasshutuShiji_Ukebi__c,
                GS_JigyoshoCD__c,
                GS_Boshu_Nendo__c,
                GS_Boshu_Kai__c,
                GS_ShikyuJiki__c
                FROM
                JFK_CommonTR__c                     
                WHERE                                           
                GS_Boshu_Nendo__c = :nendo4Search               
                AND GS_Boshu_Kai__c = :kai4Search               
                AND GS_ShikyuJiki__c = :jiki4Search     ];      
    }
}