public with sharing class JFK_HRController {
public list<JFK_HRDto> listJFKCommonTRHR = new list<JFK_HRDto>();
    public integer nendo4Search                     { get; set; }
    public integer kai4Search                       { get; set; }
    public string area4Search                       { get; set; }
    public string seiriNo4Search                    { get; set; }
    public string jiki4Search                       { get; set; }
    public string jigyosyoMei4Search                { get; set; }
    public string rodosyaMei4Search                 { get; set; }
    public string status4Search                     { get; set; }
    public string hidukeIkkatuValue                 { get; set; }
    public string displayOut                        { get; set; }
    public string displayIn                         { get; set; }
    public boolean saveDisable                      { get; set; }
    public boolean ikkatuDisable                    { get; set; }
    public boolean ikkatuInputDisable               { get; set; }
    public boolean ikkatuSelectDisable              { get; set; }
    
    //サマリー計算用
    public integer remindDMHassouBosu               { get; set; }
    public integer remindDMHassouZan                { get; set; }
    public integer remindDMHassouKanryo             { get; set; }
    public integer houkokusyoruiJuryoBosu           { get; set; }
    public integer houkokusyoruiJuryoZan            { get; set; }
    public integer houkokusyoruiJuryoKanryo         { get; set; }
    public integer shinsaTyakuSyuBosu               { get; set; }
    public integer shinsaTyakuSyuZan                { get; set; }
    public integer shinsaTyakuSyuKanryo             { get; set; }
    public integer shinsaKanryoBosu                 { get; set; }
    public integer shinsaKanryoZan                  { get; set; }
    public integer shinsaKanryoKanryo               { get; set; }
    public integer denshiDataHikiwatashiBosu        { get; set; }
    public integer denshiDataHikiwatashiZan         { get; set; }
    public integer denshiDataHikiwatashiKanryo      { get; set; }
    public integer hassyutushijiUkebiBosu           { get; set; }
    public integer hassyutushijiUkebiZan            { get; set; }
    public integer hassyutushijiUkebiKanryo         { get; set; }
    public integer tuutisyoHikiwatashibiBosu        { get; set; }
    public integer tuutisyoHikiwatashibiZan         { get; set; }
    public integer tuutisyoHikiwatashibiKanryo      { get; set; }
    public integer tuutisyoJuryobiBosu              { get; set; }
    public integer tuutisyoJuryobiZan               { get; set; }
    public integer tuutisyoJuryobiKanryo            { get; set; }
    public integer tuutisyoHassoubiBosu             { get; set; }
    public integer tuutisyoHassoubiZan              { get; set; }
    public integer tuutisyoHassoubiKanryo           { get; set; }
    public integer houkokusyoHikiwatashibiBosu      { get; set; }
    public integer houkokusyoHikiwatashibiZan       { get; set; }
    public integer houkokusyoHikiwatashibiKanryo    { get; set; }
    
    // 報告書未提出事業所の検索区分
    public boolean isNotApplication                 { get; set; }
    public boolean displayCheck                     { get; set; }
    
    private ApexPages.StandardSetController setController {get; set;}
    //チェックボックスで選択されたオブジェクトのIDの集合（ページングしても維持され続ける）
    private Set<Id> EntireSelectedIds {get; set;}


    /*
     * Constructor
     */
    public JFK_HRController() {
        jigyoshoTRId = Apexpages.currentPage().getParameters().get('jigyoshoTRId');
        tanto = Apexpages.currentPage().getParameters().get('tanto');

        list<JFK_JigyosyoTR__c> lstJigyosyoTR = [
            SELECT
                  Id
                , Name
                , Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuNendo__c
                , Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuKai__c
                , BosyuJoho_ShikyuJiki__r.ShikyuJiki_Sushiki__c
                , BosyuJoho_ShikyuJiki__r.Nenme__c
                , BosyuJoho_ShikyuJiki__r.Kaime__c
                , Nendo_Kai_Jigyosyo__r.Account__r.Id
            FROM JFK_JigyosyoTR__c
            WHERE Id = :jigyoshoTRId
        ];

        if (lstJigyosyoTR.size() > 0) {
            jigyosyoTR = lstJigyosyoTR[0];

            // 募集情報
            bosyu = JFK_cmnSOQL.getBosyu_1Rec(integer.valueOf(jigyosyoTR.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuNendo__c)
                                            , integer.valueOf(jigyosyoTR.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuKai__c)
                                            , jigyosyoTR.BosyuJoho_ShikyuJiki__r.ShikyuJiki_Sushiki__c);
            // 事業所TR情報 with GS
            jigyosyoTR = JFK_cmnSOQL.getJigyosyoTR_1Rec_withGS(
                              integer.valueOf(jigyosyoTR.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuNendo__c)
                            , integer.valueOf(jigyosyoTR.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuKai__c)
                            , integer.valueOf(jigyosyoTR.BosyuJoho_ShikyuJiki__r.Nenme__c)
                            , integer.valueOf(jigyosyoTR.BosyuJoho_ShikyuJiki__r.KaiMe__c)
                            , string.valueOf(jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.Id));
        }
        
        // HKに表示するHDの情報取得
        lstHK = JFK_cmnSOQL.getCommonTR_HK(jigyoshoTRId);

        if (lstHK == null || lstHK.size() == 0) {
            // 該当データなしメッセージ
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.JFK_Info003));
        } else {
            jigyoshoMei = lstHK[0].CheckSheetTR__r.JigyosyoTR__r.Nendo_Kai_Jigyosyo__r.Account__r.Name;
            telNo = lstHK[0].CheckSheetTR__r.JigyosyoTR__r.Nendo_Kai_Jigyosyo__r.Account__r.Phone;
            tanto_1st = lstHK[lstHK.size() - 1].HD_Tantosya1__r.Name;
            tanto_2nd = lstHK[lstHK.size() - 1].HD_Tantosya2__r.Name;
        }


    }

   /*
     * areaKBN
     * 引数   ：
     * 戻り値  ： エリア区分
     * 概要   ： 事業所TRのエリア区分を返す。
     */
    public string areaKBN {
        get {
            if (jigyosyoTR == null || string.valueOf(jigyosyoTR).length() == 0 ) {
                return '';
            } else {
                return jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c.left(1);
            }
        }
    }

    /*
     * areaName
     * 引数   ： 
     * 戻り値  ： エリア名
     * 概要   ： 事業所TRの事業所名を返す。
     */
    public string areaName {
        get {
            if (jigyosyoTR == null ||  string.valueOf(jigyosyoTR).length() == 0 ) {
                return '';
            } else {
                return jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c.mid(2, jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c.length() - 2);
            }
        }
    }

    /*
     * JFKCommonTRHR
     * 引数 ：
     * 戻り値：
     * 概要 ： ラッパーリストを画面に返す
     */
    public List<JFK_Menu_GSDto> getlistJFKCommonTRHR() {
    	return null;
    }

    /*
     * is1stTanto
     * 引数   ：
     * 戻り値 ： true:１次担当者   false:２次担当者
     * 概要   ：
     */
     public boolean is1stTanto {
        get {
            if (tanto == '1') {
                return true;
            } else {
                return false;
            }
        }
     }


    public string jigyoshoTRId     { get; set; }
    public boolean[] arIsRender = new boolean[] {true, true, true, true, true, true, true, true, true, true, true, true, true, true, true};
    // 募集情報（画面表示用）
    public JFK_Bosyu__c         bosyu       { get; set; }
    // 事業所TR情報（画面表示用）
    public JFK_JigyosyoTR__c    jigyosyoTR  { get; set; }

    private string tanto;

    private list<JFK_CommonTR__c> lstHK = new list<JFK_CommonTR__c>();
    public string jigyoshoMei       { get; set; }
    public string telNo             { get; set; }
    public string tanto_1st         { get; set; }
    public string tanto_2nd         { get; set; }
    public boolean[] isRender {
        get {
            return arIsRender;      
        }
    }
    
    /*
     * save
     * 引数   ： なし
     * 戻り値  ：pageReference
     * 概要   ：HK及びチェックシートTR更新処理
     */
     public pageReference save() {
     	return null;
     }
     
    /*
     * close
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： ページを閉じる。
     */
      public pageReference close() {
          return null;
      } 
      
    /*
     * apply
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 2次担当者が本申請を行う。
     */
      public pageReference apply() {
          return null;
      } 
      
    /*
     * cancel
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 承認を取り下げる。
     */
      public pageReference cancel() {
          return null;
      } 
      
    /*
     * approve
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 承認する
     */
      public pageReference approve() {
          return null;
      }      
      
    /*
     * add
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 追加する
     */
      public pageReference add() {
          return null;
      } 
      
    /*
     * saveMoment
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 一時保存する
     */
      public pageReference saveMoment() {
          return null;
      }   
}