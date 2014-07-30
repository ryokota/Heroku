/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_Menu_GSController
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/11/11 Create
 ******************************************************************************/
public class JFK_Menu_GSController {
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
    
    
    
    public list<JFK_CommonTR__c> listJFKCommonTR = new List<JFK_CommonTR__c>();
    public list<JFK_Menu_GSDto> listJFKCommonTRGS = new list<JFK_Menu_GSDto>();
    public JFK_CommonTR__c jfkCommonTR{get;set;}
    private integer intnendo4Search;
    private integer intKai4Search;

    private boolean isShowMessage = true;
        
    /*
     * Constructor
     */
    public JFK_Menu_GSController() {
        jfkCommonTR = new JFK_CommonTR__c();
        saveDisable = true;
        ikkatuDisable = true;
        ikkatuInputDisable = true;
        ikkatuSelectDisable = true;
        displayOut = 'block';
        displayIn = 'none';
        remindDMHassouBosu = 0;
        remindDMHassouZan = 0;
        remindDMHassouKanryo = 0;
        houkokusyoruiJuryoBosu = 0;
        houkokusyoruiJuryoZan = 0;
        houkokusyoruiJuryoKanryo = 0;
        shinsaTyakuSyuBosu = 0;
        shinsaTyakuSyuZan = 0;
        shinsaTyakuSyuKanryo = 0;
        shinsaKanryoBosu = 0;
        shinsaKanryoZan = 0;
        shinsaKanryoKanryo = 0;
        denshiDataHikiwatashiBosu = 0;
        denshiDataHikiwatashiZan = 0;
        denshiDataHikiwatashiKanryo = 0;
        hassyutushijiUkebiBosu = 0;
        hassyutushijiUkebiZan = 0;
        hassyutushijiUkebiKanryo = 0;
        tuutisyoHikiwatashibiBosu = 0;
        tuutisyoHikiwatashibiZan = 0;
        tuutisyoHikiwatashibiKanryo = 0;
        tuutisyoJuryobiBosu = 0;
        tuutisyoJuryobiZan = 0;
        tuutisyoJuryobiKanryo = 0;
        tuutisyoHassoubiBosu = 0;
        tuutisyoHassoubiZan = 0;
        tuutisyoHassoubiKanryo = 0;
        houkokusyoHikiwatashibiBosu = 0;
        houkokusyoHikiwatashibiZan = 0;
        houkokusyoHikiwatashibiKanryo = 0;
        displayCheck = true;
    }

    /*
     * showMessage
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
     public boolean getshowMessage(){
        return isShowMessage;
     }
    
    /*
     * getnendos4Search
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public List<SelectOption> getnendos4Search() {
        JFK_Bosyu__c[] lstNendo = JFK_cmnSOQL.getBosyu_Nendo();
    
        List<SelectOption> options = new List<SelectOption>();
    
        options.add(new SelectOption('', ''));
        for (JFK_Bosyu__c bosyu : lstNendo) {
            boolean isExists = false;
            for (integer i = 0; i < options.size(); i++) {
                if (options[i].getValue() == string.valueOf(bosyu.BosyuNendo__c)) {
                    isExists = true;
                }
            }
            if (!isExists) {
                options.add(new SelectOption(string.valueOf(bosyu.BosyuNendo__c), string.valueOf(bosyu.BosyuNendo__c)));
            }
        }
        return options;
    }
    
    /*
     * getkais4Search
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public List<SelectOption> getkais4Search() {
        JFK_Bosyu__c[] lstKai = JFK_cmnSOQL.getBosyu_Kai();
        
        List<SelectOption> options = new List<SelectOption>();
    
        options.add(new SelectOption('', ''));
        for (JFK_Bosyu__c bosyu : lstKai) {
            boolean isExists = false;
            for (integer i = 0; i < options.size(); i++) {
                if (options[i].getValue() == string.valueOf(bosyu.BosyuKai__c)) {
                    isExists = true;
                }
            }
            if (!isExists) {
                options.add(new SelectOption(string.valueOf(bosyu.BosyuKai__c), string.valueOf(bosyu.BosyuKai__c)));
            }
        }
        return options;
    }
    
    /*
     * getjikis4Search
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public List<SelectOption> getjikis4Search() {
        JFK_Bosyu__c[]  lstJiki = JFK_cmnSOQL.getBosyu_Jiki();

        List<SelectOption> options = new List<SelectOption>();
    
        options.add(new SelectOption('', ''));
        for (JFK_Bosyu__c bosyu : lstJiki) {
            boolean isExists = false;
            for (integer i = 0; i < options.size(); i++) {
                if (options[i].getValue() == string.valueOf(bosyu.ShikyuJiki_Sushiki__c)) {
                    isExists = true;
                }
            }
            if (!isExists) {
                options.add(new SelectOption(string.valueOf(bosyu.ShikyuJiki_Sushiki__c), string.valueOf(bosyu.ShikyuJiki_Sushiki__c)));
            }
        }
        return options;
    }
    
    /*
     * gethidukeIkkatuList
     * 引数 ：
     * 戻り値：
     * 概要 ：ベタでステータスの値を入力
     */
    public List<SelectOption> gethidukesIkkatuList() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',''));
        options.add(new SelectOption('01','リマインドDM発送日'));
        options.add(new SelectOption('02','報告書類受領日'));
        options.add(new SelectOption('03','審査着手日'));
        options.add(new SelectOption('04','審査完了日'));
        options.add(new SelectOption('05','電子データ引渡日'));
        options.add(new SelectOption('06','発出指示受け日'));
        options.add(new SelectOption('07','通知書引渡日'));
        options.add(new SelectOption('08','通知書受領日'));
        options.add(new SelectOption('09','通知書発送日'));
        options.add(new SelectOption('10','報告書類引渡日'));
        return options;
    }
    
    /*
     * getstatus4Search
     * 引数 ：
     * 戻り値：
     * 概要 ：ベタでステータスの値を入力
     */
    public List<SelectOption> getstatues4Search() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',''));
        options.add(new SelectOption('00','未着手'));
        options.add(new SelectOption('01','リマインドDM発送済み'));
        options.add(new SelectOption('02','報告書類提出督促中'));
        options.add(new SelectOption('03','報告書受領済み'));
        options.add(new SelectOption('04','審査中'));
        options.add(new SelectOption('05','審査完了'));
        options.add(new SelectOption('06','審査データ納品済み'));
        options.add(new SelectOption('07','県庁発出指示受け済み'));
        options.add(new SelectOption('08','通知書引渡し済み'));
        options.add(new SelectOption('09','通知書受領済み'));
        options.add(new SelectOption('10','通知書発送済み'));
        options.add(new SelectOption('11','審査書類納品済み'));
        options.add(new SelectOption('12','【完了】'));
        return options;
    }
    
    /*
     * getareas4Search
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public List<SelectOption> getareas4Search() {
        JFK_CommonM__c[] lstArea = JFK_cmnSOQL.getCommonM(JFK_cmnConstant.COMMON_M_AREA);                               
            
        List<SelectOption> options = new List<SelectOption>();
    
        options.add(new SelectOption('', ''));
        for (JFK_CommonM__c area : lstArea) {
            options.add(new SelectOption(string.valueOf(area.Code__c + ':' + area.Name), string.valueOf(area.Code__c + ':' + area.Name)));
        }
        return options;
    }

    /*
     * doSearch
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public PageReference doSearch() {
        
        try {
            // エラーチェック
/*
            if (checkError()) {
                return null;
            }
*/
            searchData();
            summaryData();
            
            return null;
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }
    
    /*
     * doChange
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public PageReference doChange() {
        //日付一括変更用
        date ikkatuChangeDate = jfkCommonTR.GS_DateIkkatuNyuryoku__c;
        integer rownumber = 0;
        if(ikkatuChangeDate != null){
            
            if (hidukeIkkatuValue == '01'){
                for(JFK_CommonTR__c commonTR:(List<JFK_CommonTR__c>)setController.getRecords()){
                    if(listJFKCommonTRGS[rownumber].checkFlag){
                        commonTR.GS_RemindDM_HassoBi__c = ikkatuChangeDate;
                        listJFKCommonTRGS.add(new JFK_Menu_GSDto(commonTR,false));  
                    }
                    rownumber += 1;
                }
            }else if(hidukeIkkatuValue == '02'){
                for(JFK_CommonTR__c commonTR:(List<JFK_CommonTR__c>)setController.getRecords()){
                    if(listJFKCommonTRGS[rownumber].checkFlag){
                        commonTR.GS_JissekiHokokusyo_JuryoBi__c = ikkatuChangeDate;
                        listJFKCommonTRGS.add(new JFK_Menu_GSDto(commonTR,false));
                    }
                    rownumber += 1; 
                }
            }else if(hidukeIkkatuValue == '03'){
                for(JFK_CommonTR__c commonTR:(List<JFK_CommonTR__c>)setController.getRecords()){
                    if(listJFKCommonTRGS[rownumber].checkFlag){
                        commonTR.GS_JissekiSyoruiShinsa_ChakusyuBi__c = ikkatuChangeDate;
                        listJFKCommonTRGS.add(new JFK_Menu_GSDto(commonTR,false));  
                    }
                    rownumber += 1; 
                }
            }else if(hidukeIkkatuValue == '04'){
                for(JFK_CommonTR__c commonTR:(List<JFK_CommonTR__c>)setController.getRecords()){
                    if(listJFKCommonTRGS[rownumber].checkFlag){
                        commonTR.GS_JissekiSyoruiShinsa_KanryoBi__c = ikkatuChangeDate;
                        listJFKCommonTRGS.add(new JFK_Menu_GSDto(commonTR,false));
                    }
                    rownumber += 1; 
                }
            }else if(hidukeIkkatuValue == '05'){
                for(JFK_CommonTR__c commonTR:(List<JFK_CommonTR__c>)setController.getRecords()){
                    if(listJFKCommonTRGS[rownumber].checkFlag){
                        commonTR.GS_JissekigakuData_HikiwatashiBi__c = ikkatuChangeDate;
                        listJFKCommonTRGS.add(new JFK_Menu_GSDto(commonTR,false));
                    }
                    rownumber += 1; 
                }
            }else if(hidukeIkkatuValue == '06'){
                for(JFK_CommonTR__c commonTR:(List<JFK_CommonTR__c>)setController.getRecords()){
                    if(listJFKCommonTRGS[rownumber].checkFlag){
                        commonTR.GS_HasshutuShiji_Ukebi__c = ikkatuChangeDate;
                        listJFKCommonTRGS.add(new JFK_Menu_GSDto(commonTR,false));
                    }
                    rownumber += 1; 
                }
            }else if(hidukeIkkatuValue == '07'){
                for(JFK_CommonTR__c commonTR:(List<JFK_CommonTR__c>)setController.getRecords()){
                    if(listJFKCommonTRGS[rownumber].checkFlag){
                        commonTR.GS_ShikyugauTsuchisho_HikiwatashiBi__c = ikkatuChangeDate;
                        listJFKCommonTRGS.add(new JFK_Menu_GSDto(commonTR,false));
                    }
                    rownumber += 1; 
                }
            }else if(hidukeIkkatuValue == '08'){
                for(JFK_CommonTR__c commonTR:(List<JFK_CommonTR__c>)setController.getRecords()){
                    if(listJFKCommonTRGS[rownumber].checkFlag){
                        commonTR.GS_ShikyugakuTsuchisho_JuryoBi__c = ikkatuChangeDate;
                        listJFKCommonTRGS.add(new JFK_Menu_GSDto(commonTR,false));
                    }
                    rownumber += 1; 
                }
            }else if(hidukeIkkatuValue == '09'){
                for(JFK_CommonTR__c commonTR:(List<JFK_CommonTR__c>)setController.getRecords()){
                    if(listJFKCommonTRGS[rownumber].checkFlag){
                        commonTR.GS_ShikyugakuTsuchisho_HassoBi__c = ikkatuChangeDate;
                        listJFKCommonTRGS.add(new JFK_Menu_GSDto(commonTR,false));
                    }
                    rownumber += 1; 
                }
            }else if(hidukeIkkatuValue == '10'){
                for(JFK_CommonTR__c commonTR:(List<JFK_CommonTR__c>)setController.getRecords()){
                    if(listJFKCommonTRGS[rownumber].checkFlag){
                        commonTR.GS_JissekiHokokuSyorui_HikiwatashiBi__c = ikkatuChangeDate;
                        listJFKCommonTRGS.add(new JFK_Menu_GSDto(commonTR,false));  
                    }
                    rownumber += 1; 
                }
            }
            
            //データ保存
            update (List<JFK_CommonTR__c>)setController.getRecords();
            //再検索
            searchData();
            summaryData();
        }

        return null;
    }
    
    /*
     * doSave
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public PageReference doSave() {
        
        update (List<JFK_CommonTR__c>)setController.getRecords();
        /*
        for(JFK_CommonTR__c commonTR:(List<JFK_CommonTR__c>)setController.getRecords()){
            commonTR.GS_JissekiHokokuSyorui_HikiwatashiBi__c = ikkatuChangeDate;
            listJFKCommonTRGS.add(new JFK_Menu_GSDto(commonTR,false));
        }*/
        //再検索
        searchData();
        summaryData();
        
        return null;
    }
    
    

    //ページング前のリフレッシュ
    /*
     * refreshBeforePaging
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
    private void refreshBeforePaging() {
        //updateEntireSelectedIds();
    }
    
    /*
     * PageNumber
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
    public string PageNumber {
        get {
            if (setController == null || listJFKCommonTR.size() == 0) {
                return '';
            } else {
                return string.valueOf(setController.getPageNumber());
            }
        }
    }
        
    /*
     * firstBtnDisable
     * 引数 ：
     * 戻り値：
     * 概要 ： 
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
            return false;
        }
    }       

    /*
     * lastBtnDisable
     * 引数 ：
     * 戻り値：
     * 概要 ： 
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
            return false;
        }
    }       

    /*
     * showFirstPage
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
    public  PageReference showFirstPage() {

        try {
            if (setController != null) {            
                refreshBeforePaging();
                setController.first();
                listJFKCommonTR = (List<JFK_CommonTR__c>)setController.getRecords();
            }
            
            return null;
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }

    /*
     * showPreviousPage
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
    public  PageReference showPreviousPage() {

        try {
            if (setController != null && setController.getHasPrevious()) {          
                refreshBeforePaging();
                setController.previous();
                listJFKCommonTR = (List<JFK_CommonTR__c>)setController.getRecords();
            }
            
            return null;
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }

    /*
     * showNextPage
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
    public  PageReference showNextPage() {

        try {
            if (setController != null && setController.getHasNext()) {
                refreshBeforePaging();
                setController.next();
                listJFKCommonTR = (List<JFK_CommonTR__c>)setController.getRecords();
            }
            
            return null;
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }

    /*
     * showLastPage
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
    public  PageReference showLastPage() {

        try {
            if (setController != null) {            
                refreshBeforePaging();
                setController.last();
                listJFKCommonTR = (List<JFK_CommonTR__c>)setController.getRecords();
            }
            
            return null;
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
        }
    }
    /*
     * JigyoshoTR
     * 引数 ：
     * 戻り値：
     * 概要 ： ラッパーリストを画面に返す
     */
    public List<JFK_Menu_GSDto> getlistJFKCommonTRGS() {
        try {
            if (setController != null) {
                listJFKCommonTRGS.clear();
                //integer rownum = -1;
                for (JFK_CommonTR__c commonTR : listJFKCommonTR) {
                        //rownum += 1;
                        listJFKCommonTRGS.add(new JFK_Menu_GSDto(commonTR,false));
                    }
                }
                
                return listJFKCommonTRGS;
            } catch (Exception e) {
                if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
        }
    }
    
    private void searchData(){
        JFK_Menu_GSDao gsDao = new JFK_Menu_GSDao();        
            integer recCnt = 0;
            recCnt = gsDao.getCommonTRDataCount(nendo4Search,kai4Search,area4Search,seiriNo4Search,
                                                jiki4Search,jigyosyoMei4Search,rodosyaMei4Search,
                                                status4Search);
            
            // 最大件数を超える時、処理中止
            if (recCnt > Limits.getLimitQueryLocatorRows()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.JFK_Info002));
                return;
            }
                                
            // 該当データ取得
            setController = new ApexPages.StandardSetController(gsDao.getCommonTRData(nendo4Search,kai4Search,area4Search,seiriNo4Search,
                                                                                      jiki4Search,jigyosyoMei4Search,rodosyaMei4Search,
                                                                                      status4Search));
            setController.setPageSize(10); //一度に10件まで表示
            listJFKCommonTR = (List<JFK_CommonTR__c>)setController.getRecords();

            if (listJFKCommonTR.size() == 0) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,System.Label.JFK_Info003));
            }else{
                saveDisable = false;
                ikkatuDisable = false;
                ikkatuInputDisable = false;
                ikkatuSelectDisable = false;
                displayOut = 'block';
                displayIn = 'none';
            }        

    }
    
    
    private void summaryData() {
        JFK_Menu_GSDao gsDao = new JFK_Menu_GSDao();
        string gsJigyoshoCDbefore = '';

        remindDMHassouBosu = 0;
        remindDMHassouZan = 0;
        remindDMHassouKanryo = 0;
        houkokusyoruiJuryoBosu = 0;
        houkokusyoruiJuryoZan = 0;
        houkokusyoruiJuryoKanryo = 0;
        shinsaTyakuSyuBosu = 0;
        shinsaTyakuSyuZan = 0;
        shinsaTyakuSyuKanryo = 0;
        shinsaKanryoBosu = 0;
        shinsaKanryoZan = 0;
        shinsaKanryoKanryo = 0;
        denshiDataHikiwatashiBosu = 0;
        denshiDataHikiwatashiZan = 0;
        denshiDataHikiwatashiKanryo = 0;
        hassyutushijiUkebiBosu = 0;
        hassyutushijiUkebiZan = 0;
        hassyutushijiUkebiKanryo = 0;
        tuutisyoHikiwatashibiBosu = 0;
        tuutisyoHikiwatashibiZan = 0;
        tuutisyoHikiwatashibiKanryo = 0;
        tuutisyoJuryobiBosu = 0;
        tuutisyoJuryobiZan = 0;
        tuutisyoJuryobiKanryo = 0;
        tuutisyoHassoubiBosu = 0;
        tuutisyoHassoubiZan = 0;
        tuutisyoHassoubiKanryo = 0;
        houkokusyoHikiwatashibiBosu = 0;
        houkokusyoHikiwatashibiZan = 0;
        houkokusyoHikiwatashibiKanryo = 0;

        if(nendo4Search != null && kai4Search != null && jiki4Search != null){

            for(JFK_CommonTR__c jfkCommonSummary: gsDao.getCommonTRSummaryData(nendo4Search, kai4Search, jiki4Search)){
                //母数計算
                if(gsJigyoshoCDbefore != jfkCommonSummary.GS_JigyoshoCD__c){
                    //過去の値を保持
                    gsJigyoshoCDbefore = jfkCommonSummary.GS_JigyoshoCD__c;

                    remindDMHassouBosu += 1;
                    
                    if(jfkCommonSummary.GS_RemindDM_HassoBi__c != null ){
                        houkokusyoruiJuryoBosu += 1;
                        remindDMHassouKanryo += 1;
                    }
                    
                    if(jfkCommonSummary.GS_JissekiHokokusyo_JuryoBi__c != null ){
                        shinsaTyakuSyuBosu += 1;
                        houkokusyoruiJuryoKanryo += 1;
                    }
                    if(jfkCommonSummary.GS_JissekiSyoruiShinsa_ChakusyuBi__c != null ){
                        shinsaKanryoBosu += 1;
                        shinsaTyakuSyuKanryo += 1;                  
                    }
                    if(jfkCommonSummary.GS_JissekiSyoruiShinsa_KanryoBi__c != null ){
                        denshiDataHikiwatashiBosu += 1;
                        shinsaKanryoKanryo += 1;    
                    }
                    if(jfkCommonSummary.GS_JissekigakuData_HikiwatashiBi__c != null ){
                        hassyutushijiUkebiBosu += 1;
                        denshiDataHikiwatashiKanryo += 1;
                                            }
                    if(jfkCommonSummary.GS_HasshutuShiji_Ukebi__c != null ){
                        tuutisyoHikiwatashibiBosu += 1;
                        hassyutushijiUkebiKanryo += 1;
                    }
                    if(jfkCommonSummary.GS_ShikyugauTsuchisho_HikiwatashiBi__c != null ){
                        tuutisyoJuryobiBosu += 1;
                        tuutisyoHikiwatashibiKanryo += 1;
                    }
                    if(jfkCommonSummary.GS_ShikyugakuTsuchisho_JuryoBi__c != null ){
                        tuutisyoHassoubiBosu += 1;
                        tuutisyoJuryobiKanryo += 1;
                    }                   
                    if(jfkCommonSummary.GS_ShikyugakuTsuchisho_HassoBi__c != null ){
                        houkokusyoHikiwatashibiBosu += 1;
                        tuutisyoHassoubiKanryo += 1;
                    }                   
                    if(jfkCommonSummary.GS_JissekiHokokuSyorui_HikiwatashiBi__c != null ){
                        houkokusyoHikiwatashibiKanryo += 1;
                    }                   
                    
                }
                
            }
            
            //残数計算
            remindDMHassouZan = remindDMHassouBosu - remindDMHassouKanryo;
            houkokusyoruiJuryoZan = houkokusyoruiJuryoBosu - houkokusyoruiJuryoKanryo;
            shinsaTyakuSyuZan = shinsaTyakuSyuBosu - shinsaTyakuSyuKanryo;
            shinsaKanryoZan = shinsaKanryoBosu - shinsaKanryoKanryo;
            denshiDataHikiwatashiZan = denshiDataHikiwatashiBosu - denshiDataHikiwatashiKanryo;
            hassyutushijiUkebiZan = hassyutushijiUkebiBosu - hassyutushijiUkebiKanryo;
            tuutisyoHikiwatashibiZan = tuutisyoHikiwatashibiBosu - tuutisyoHikiwatashibiKanryo;
            tuutisyoJuryobiZan = tuutisyoJuryobiBosu - tuutisyoJuryobiKanryo;
            tuutisyoHassoubiZan = tuutisyoHassoubiBosu - tuutisyoHassoubiKanryo;
            houkokusyoHikiwatashibiZan = houkokusyoHikiwatashibiBosu - houkokusyoHikiwatashibiKanryo;

        }

        

    }
}