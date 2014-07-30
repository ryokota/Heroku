/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_Menu_JCJController
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/09/11 Create
 ******************************************************************************/
public class JFK_Menu_JCJController {
    public string nendo4Search                      { get; set; }
    public string kai4Search                        { get; set; }
    public string jiki4Search                       { get; set; }
    public string area4Search                       { get; set; }
    public string jigyosyoMei4Search                { get; set; }
    public string seiriNo4Search                    { get; set; }
    // 報告書未提出事業所の検索区分
    public boolean isNotApplication                 { get; set; }
    
    @TestVisible private ApexPages.StandardSetController setController {get; set;}
    //チェックボックスで選択されたオブジェクトのIDの集合（ページングしても維持され続ける）
    @TestVisible private Set<Id> EntireSelectedIds {get; set;}
    private list<wrapper> lstWrapper;
    
    private list<JFK_JigyosyoTR__c> listJigyoshoTR = new List<JFK_JigyosyoTR__c>();

    private integer intnendo4Search;
    private integer intKai4Search;

    private boolean isShowMessage = true;
        
    /*
     * Constructor
     */
    public JFK_Menu_JCJController() {
        this.EntireSelectedIds = new Set<Id>();
    }

    /*
     * showMessage
     * 引数   ：
     * 戻り値  ： メッセージを表示する時true
     * 概要   ：
     */
     public boolean showMessage {
        get {
            return isShowMessage;
        }
     }
    
    /*
     * nendos4Search
     * 引数   ：
     * 戻り値  ： List<SelectOption>
     * 概要   ： 募集年度用SelectOption
     */
    public List<SelectOption> nendos4Search {
        get {
            JFK_Bosyu__c[] lstNendo = JFK_cmnSOQL.getBosyu_Nendo();
			
			return JFK_cmdUtilities.createSelectOption(lstNendo, 'BosyuNendo__c');    
        }
    }
    
    /*
     * kais4Search
     * 引数   ：
     * 戻り値  ： List<SelectOption>
     * 概要   ： 募集回用SelectOption
     */
    public List<SelectOption> kais4Search {
        get {
            JFK_Bosyu__c[] lstKai = JFK_cmnSOQL.getBosyu_Kai();
        
			return JFK_cmdUtilities.createSelectOption(lstKai, 'BosyuKai__c');    
        }
    }
    
    /*
     * jikis4Search
     * 引数   ：
     * 戻り値  ： List<SelectOption>
     * 概要   ： 支給時期用SelectOption
     */
    public List<SelectOption> jikis4Search {
        get {
            JFK_Bosyu__c[]  lstJiki = JFK_cmnSOQL.getBosyu_Jiki();

			return JFK_cmdUtilities.createSelectOption(lstJiki, 'ShikyuJiki_Sushiki__c');    
        }
    }

    /*
     * areas4Search
     * 引数   ：
     * 戻り値  ： List<SelectOption>
     * 概要   ： エリア用SelectOption
     */
    public List<SelectOption> areas4Search {
        get {
            JFK_CommonM__c[] lstArea = JFK_cmnSOQL.getCommonM(JFK_cmnConstant.COMMON_M_AREA);                               
            
            List<SelectOption> options = new List<SelectOption>();
    
            options.add(new SelectOption('', ''));
            for (JFK_CommonM__c area : lstArea) {
                options.add(new SelectOption(string.valueOf(area.Code__c + ':' + area.Name), string.valueOf(area.Code__c + ':' + area.Name)));
            }
            return options;
        }
    }

    /*
     * doSearch
     * 引数   ： なし
     * 戻り値  ： PageReference
     * 概要   ： 検索処理
     */
    public PageReference doSearch() {
        try {
            // Initiate Wrapper & Set
            lstWrapper = new List<wrapper>();
            EntireSelectedIds.clear();
        
            // 該当件数チェック
            string strSOQL = 'SELECT'
                            + '  COUNT()'
                            + ' FROM JFK_JigyosyoTR__c'
                            + ' WHERE Nendo_Kai_Jigyosyo__c != null';
            strSOQL +=  createCriteria();
            
            integer recCnt = Database.countQuery(strSOQL);
            
            // 該当データが存在しない時、処理中止
            if (recCnt == 0) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,System.Label.JFK_Info003));
                return null;
            }        

            // 最大件数を超える時、処理中止
            if (recCnt > Limits.getLimitQueryLocatorRows()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.JFK_Info002));
                return null;
            }
                                
            // 該当データ取得
            strSOQL = 'SELECT'
                            + '  id'
                            + ', Name'
                            + ', BosyuJoho_ShikyuJiki__r.Bosyu__r.BosyuNendo__c'
                            + ', BosyuJoho_ShikyuJiki__r.Bosyu__r.BosyuKai__c'
                            + ', BosyuJoho_ShikyuJiki__r.ShikyuJiki_Sushiki__c'
                            + ', Nendo_Kai_Jigyosyo__r.SeiriNO__c'
                            + ', Nendo_Kai_Jigyosyo__r.Area__c'
                            + ', Nendo_Kai_Jigyosyo__r.JigyoshoCD__c'
                            + ', Nendo_Kai_Jigyosyo__r.Account__r.Name'
                            + ', Nendo_Kai_Jigyosyo__r.Account__r.Address_Shinsei__c'
                            + ', Nendo_Kai_Jigyosyo__r.Account__r.KoyoHokenTekiyoJigyosyoNO__c'
                            + ', ('
                            + '     SELECT' 
                            + '               GS_FirstTantosya__c' 
                            + '             , GS_SecondTantosya__c' 
                            + '             , GS_FirstTantosya__r.Name' 
                            + '             , GS_SecondTantosya__r.Name' 
                            + '             , GS_FirstTantosya_Status__c'
                            + '             , GS_SecondTantosya_Status__c' 
                            + '             , GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c' 
                            + '             , GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c' 
                            + '             , GS_JissekiSyoruiShinsa_ChakusyuBi__c' 
                            + '             , GS_JissekiHoseiShido_JisshiBi__c' 
                            + '             , GS_JissekiSyoruiShinsa_KanryoBi_1st__c' 
                            + '             , GS_JissekiSyoruiShinsa_KanryoBi_2nd__c' 
                            + '             , GS_JissekiSyoruiShinsa_KanryoBi__c'
                            + '             , GS_JissekiHokokusyo_JuryoBi__c'
                            + '             FROM JigyosyoTR_Time__r '
                            + '             WHERE RecordKBN__c = \'' + String.escapeSingleQuotes(JFK_cmnConstant.COMMON_MANAGE_INFO_GS) + '\''
                            + '             AND   RodosyaTR__c = NULL'
                            + ' )'
                            + ' FROM JFK_JigyosyoTR__c'
                            + ' WHERE Nendo_Kai_Jigyosyo__c != null';
            strSOQL +=  createCriteria();
            strSOQL += ' ORDER BY BosyuJoho_ShikyuJiki__r.Bosyu__r.BosyuNendo__c'
                    +  ',BosyuJoho_ShikyuJiki__r.Bosyu__r.BosyuKai__c'
                    +  ',BosyuJoho_ShikyuJiki__r.ShikyuJiki_Sushiki__c'
                    +  ',Nendo_Kai_Jigyosyo__r.Area__c'
                    +  ',Nendo_Kai_Jigyosyo__r.SeiriNO__c';

            // Extract Maching Records
            setController = new ApexPages.StandardSetController(Database.getQueryLocator(strSOQL));
            setController.setPageSize(15); //一度に15件まで表示
            listJigyoshoTR = (List<JFK_JigyosyoTR__c>)setController.getRecords();

            return null;
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }

    /*
     * createCriteria
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ： 検索条件のSOQLを組み立てる
     */
     private string createCriteria() {
        try {
            string strSOQL = '';
            
            if (nendo4Search != null) {
                intnendo4Search = integer.valueOf(nendo4Search);
                strSOQL += ' And BosyuJoho_ShikyuJiki__r.Bosyu__r.BosyuNendo__c = :intnendo4Search';
            }
    
            if (kai4Search != null) {
                intKai4Search = integer.valueOf(kai4Search);
                strSOQL += ' And BosyuJoho_ShikyuJiki__r.Bosyu__r.BosyuKai__c = :intKai4Search';
            }
            
            if (jiki4Search != null) {
                strSOQL += ' And BosyuJoho_ShikyuJiki__r.ShikyuJiki_Sushiki__c = :jiki4Search';
            }
            
            if (area4Search != null) {
                strSOQL += ' And Nendo_Kai_Jigyosyo__r.Area__c = :area4Search';
            }
    
            if (seiriNo4Search.length() > 0) {
                strSOQL += ' And Nendo_Kai_Jigyosyo__r.SeiriNO__c = :SeiriNo4Search';        
            }

            if (jigyosyoMei4Search.length() > 0) {
                strSOQL += ' And Nendo_Kai_Jigyosyo__r.Account__r.Name Like \'%' + String.escapeSingleQuotes(jigyosyoMei4Search) + '%\'';        
            }
            
            return strSOQL;
            
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
     }

    /*
     * JigyoshoTR
     * 引数   ：
     * 戻り値  ： List<wrapper>
     * 概要   ： ラッパーリストを画面に返す
     */
    public List<wrapper> lstJigyoshoTR {
        get {
            if (setController != null) {
                lstWrapper.clear();
                
                for (JFK_JigyosyoTR__c jigyoshoTR : listJigyoshoTR) {
                    wrapper wrap = new wrapper(jigyoshoTR);
                        
                    for (JFK_CommonTR__c commonTR : jigyoshoTR.JigyosyoTR_Time__r) {
                        wrap.gs = commonTR;
                    }
    
                    if (this.EntireSelectedIds.contains(jigyoshoTR.Id)) {
                        wrap.IsSelected = true;
                    }

                    lstWrapper.add(wrap);
                }
            }
                
            return lstWrapper;
        }
    }

    //現在の画面の選択or非選択内容をEntireSelectedIdsに反映（ページング等の画面遷移時に実施）
    /*
     * updateEntireSelectedIds
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ： 特差の時のチェックボックス管理
     */
    private void updateEntireSelectedIds() {
        if (this.lstWrapper != null) {
            for (wrapper w : this.lstWrapper) {
                if (w.IsSelected) {
                    EntireSelectedIds.add(w.jigyoshoTR.Id);
                } else {
                    EntireSelectedIds.remove(w.jigyoshoTR.Id);
                }
            }
        }
    }

    /*
     * refreshBeforePaging
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ： ページング前のリフレッシュ
     */
    private void refreshBeforePaging() {
        updateEntireSelectedIds();
    }
    
    /*
     * PageNumber
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
    public string PageNumber {
        get {
            if (setController == null || listJigyoshoTR.size() == 0) {
                return '';
            } else {
                return string.valueOf(setController.getPageNumber());
            }
        }
    }
        
    /*
     * firstBtnDisable
     * 引数   ：
     * 戻り値  ： 先頭ボタンが使用可能な時true
     * 概要   ： 
     */
    public boolean firstBtnDisable {
        get {
            if (setController == null) {
                return true;
            } else {
                if (setController.getHasPrevious()) {
                    return false;
                } else {
                    return true;
                }
            }
        }
    }       

    /*
     * lastBtnDisable
     * 引数   ：
     * 戻り値  ： 最終ボタンが使用可能な時true
     * 概要   ： 
     */
    public boolean lastBtnDisable {
        get {
            if (setController == null) {
                return true;
            } else {
                if (setController.getHasNext()) {
                    return false;
                } else {
                    return true;
                }
            }
        }
    }       

    /*
     * showFirstPage
     * 引数   ： なし
     * 戻り値  ： PageReference
     * 概要   ： 先頭ページを表示する。
     */
    public  PageReference showFirstPage() {
        if (setController != null) {            
            refreshBeforePaging();
            setController.first();
            listJigyoshoTR = (List<JFK_JigyosyoTR__c>)setController.getRecords();
        }
        
        return null;
    }

    /*
     * showPreviousPage
     * 引数   ： なし
     * 戻り値  ： PageReference
     * 概要   ： 前ページを表示する。
     */
    public  PageReference showPreviousPage() {
        if (setController != null && setController.getHasPrevious()) {          
            refreshBeforePaging();
            setController.previous();
            listJigyoshoTR = (List<JFK_JigyosyoTR__c>)setController.getRecords();
        }
        
        return null;
    }

    /*
     * showNextPage
     * 引数   ： なし
     * 戻り値  ： PageReference
     * 概要   ：次ページを表示する。
     */
    public  PageReference showNextPage() {
        if (setController != null && setController.getHasNext()) {
            refreshBeforePaging();
            setController.next();
            listJigyoshoTR = (List<JFK_JigyosyoTR__c>)setController.getRecords();
        }
        
        return null;
    }

    /*
     * showLastPage
     * 引数   ： なし
     * 戻り値  ： PageReference
     * 概要   ：最終ページを表示する。
     */
    public  PageReference showLastPage() {
        if (setController != null) {            
            refreshBeforePaging();
            setController.last();
            listJigyoshoTR = (List<JFK_JigyosyoTR__c>)setController.getRecords();
        }
        
        return null;
    }

    /*
     * isBoss
     * 引数   ：
     * 戻り値  ： 担当マネージャーの時true
     * 概要   ：
     */
    public boolean isBoss {
        get {
            // ログインしているユーザーのプロファイルを取得
            list<profile> lstProfile = [select name from profile where id in (Select profileId from User Where Id = :UserInfo.getUserId())];

            // カスタム設定(JFK_ManagerProfileName__c)から全ての情報を取得
            Map<string, JFK_ManagerProfileName__c> mcs = JFK_ManagerProfileName__c.getAll();
            // Map(カスタム設定(JFK_CheckSheetM_JCJ__c))からValue項目のみををListに格納
            JFK_ManagerProfileName__c[] chkSheets = mcs.values();
            
            // !!!!【未実装】ログインしているユーザーのプロファイルがカスタム設定内に存在すれば、マネージャー権限とする。!!!!
            if (string.valueOf(lstProfile[0].name).contains('System Admin')) {
                return true;
            } else {
                return false;
            }
        }
    }

    /*
     * tokusashi
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ： 特別差し戻し処理
     */
      public void tokusashi() {
        Savepoint sp = Database.setSavepoint();
        Database.saveResult[] lsr;
        try {
            refreshBeforePaging();

			// GS(事業所)更新
            list<JFK_CommonTR__c> lstGs = JFK_cmnSOQL.getCommonTR_GS4Update(EntireSelectedIds);

            for (JFK_CommonTR__c gs : lstGs) {
                gs.GS_JissekiSyoruiShinsa_KanryoBi_1st__c = null;
                gs.GS_FirstTantosya_Status__c = JFK_cmnConstant.OPERATION_STATUS_TOKUSASHI;
            }
            
            lsr = Database.update(lstGs);
            
			// GS(労働者)更新
            list<JFK_JigyosyoTR__c> lstJigyosyoTR = JFK_cmnSOQL.getJigyosyoTR(EntireSelectedIds);               
            
            set<Id> setRodosya = new set<Id>();
            for (JFK_JigyosyoTR__c jtr : lstJigyosyoTR) {
                for (JFK_RodoSyaTR__c rtr : jtr.JigyosyoTR_ShikyuJikis__r) {
                    setRodosya.add(rtr.Id);
                }
            }

            list<JFK_CommonTR__c> lstGs_Rodosya = JFK_cmnSOQL.getCommonTR_Rodosya4Update(setRodosya);

            lsr = Database.update(lstGs_Rodosya);
         } catch (DmlException e) {
            if (!JFK_cmdUtilities.chkSaveResult(lsr)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.JFK_Error007));
                Database.rollback(sp);
            }
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                Database.rollback(sp);
            }
         }
      }

    public void dummy() {
    } 
   
    /*
     * wrapper
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public class wrapper {
        public JFK_JigyosyoTR__c jigyoshoTR { get; set; }
        public JFK_CommonTR__c gs           { get; set; }
        public boolean isSelected           { get; set; }
        public string area { 
            get {
                if (jigyoshoTR.Nendo_Kai_Jigyosyo__r.Area__c == null) return '';
                
                return jigyoshoTR.Nendo_Kai_Jigyosyo__r.Area__c.mid(2, jigyoshoTR.Nendo_Kai_Jigyosyo__r.Area__c.length() - 2);
            } 
        }
        
        public wrapper(JFK_JigyosyoTR__c p_jigyoshoTR) {
            jigyoshoTR = p_jigyoshoTR;
            
            isSelected = false;
        }
    }
}