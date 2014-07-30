/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス		: JFK_JCR_SupplementaryController
 *  概要        	: 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/10/09 Create
 ******************************************************************************/
public class JFK_JCR_SupplementaryController {
    // urlパラメータ from JFK_JCJ
    public  string tanto        { get; set; }
    private string nendo;
    private string kai;
    private string jiki;
    private string jigyosyoid;
    public  string rodosyaTRid  { get; set; }
    
    // 現在のページのurl
    private string currentURL;

    // 画面表示情報用Check Sheet Map
    private map<string, JFK_CheckSheetM_JCR_Supplementary__c>   mapCheckSheetTemplate = new map<string, JFK_CheckSheetM_JCR_Supplementary__c>();    // 新規作成用（カスタム設定から情報取得）
    private map<string, JFK_CheckSheetTR__c>                    mapCheckSheetTR       = new map<string, JFK_CheckSheetTR__c>();                     // 既存用（審査シートレコードから情報取得）

    // Check Sheetトランザクション List (Original:前回更新分)
    private list<JFK_CheckSheetTR__c> lstcheckSheetOriginal = new list<JFK_CheckSheetTR__c>();
    
    // Check Sheetトランザクション List（今回更新分）
    private list<JFK_CheckSheetTR__c>   lstCheckSheetTR1    = new list<JFK_CheckSheetTR__c>();
    private list<JFK_CheckSheetTR__c>   lstCheckSheetTR2    = new list<JFK_CheckSheetTR__c>();
    private list<JFK_CheckSheetTR__c>   lstCheckSheetTR3    = new list<JFK_CheckSheetTR__c>();
    private list<JFK_CheckSheetTR__c>   lstCheckSheetTR4    = new list<JFK_CheckSheetTR__c>();

    // 汎用マスタ List（チェックシート名を保持）
    private list<JFK_CommonM__c>        lstcommonM_CheckSheet; 

    // Total Page数
    private final integer pageNumbers = 4;

    // カテゴリ別のアイテム（行）数を保持
    private integer[] itemNumberEachCategory = new integer[]{0, 0, 0, 0};

    // 一時保存フラグ
    private boolean isSaveTemp = false;
    // 差し戻しフラグ
    private boolean isPassback = false;

    // １次・２次審査担当者
    private id[] tantosyaID = new id[2];
    private string[] tantosyaName = new string[2];
    // １次・２次審査完了日
    private date[] kanryoDate = new date[2];
    // １次・２次審査Status
    private string[] status = new string[2];

    // GS 書類審査完了日
    public date   shoruiShinsaKanryoDate    { get; set; }
    // GSのステータス
    public string   totalStatus             { get; set; }
    // 募集情報（画面表示用）
    public JFK_Bosyu__c bosyu               { get; set; }

    // 事業所TR情報（画面表示用）
    public JFK_JigyosyoTR__c    jigyosyoTR  { get; set; }

    // 労働者TR情報（画面表示用）
    private JFK_RodoSyaTR__c    rodosya2 = new JFK_RodoSyaTR__c();
    public  JFK_RodoSyaTR__c    rodosyaTR   {
        get {
            return rodosya2;
        }
        set {
            rodosya2 = value;
        }
    }

    /* MD情報有無 */
    public boolean              isExistMD           { get; set; }
    /* HD情報有無 */
    public boolean              isExistHD           { get; set; }
    /* HM情報有無 */
    public boolean              isExistHM           { get; set; }
    /* PTMK情報有無 */
    public boolean              isExistPTMK         { get; set; }
    /* YS情報有無 */
    public boolean              isExistYS           { get; set; }

    // 労働者のイレギュラー情報
    public boolean              isShimei            { get; set; }
    public boolean              isKoyoKubun         { get; set; }
    public boolean              isKoyoKeitai        { get; set; }
    public boolean              isKoyoSyurui        { get; set; }
    public boolean              isRisyoku           { get; set; }
    public boolean              isKoyoKeitaiHenko   { get; set; }
    public boolean              isKetsuBan          { get; set; }
    public boolean              isMukyuKekkin       { get; set; }
    public boolean              isKoyoKeiyaku_KaishiBi{ get; set; }
    public boolean              showTaisyogaiRodosya{ get; set; }
    public boolean              isHojuRodosyaInfo   { get; set; }

    private list<Id>            lstKoyokeitaiId = new list<Id>();
    
    /* Contact(補充労働者)情報 */
    private Contact rodosya = new Contact();
    public Contact hojuRodosya  { 
        get {
            return rodosya;
        }
        set {
            rodosya = value;
        }
    }
    
    /* Contact(補充元労働者)情報 */
    private Contact motoRodosya = new Contact();
    public Contact hojumotoRodosya  { 
        get {
            return motoRodosya;
        }
        set {
            motoRodosya = value;
        }
    }

    /* 補充労働者からContactを作成するための情報 */
    private string risyokuRodosyaId;
    
    public string risyokusyaSearch 		{ get; set; }
    public string koyoSyuruiSearch 		{ get; set; }
    public string koyoKubunSearch  		{ get; set; }
    public string koyoKeitaiSearch 		{ get; set; }
    public string koyoKeitaiHenkoSearch { get; set; }

    public string lastName { get; set; }
    
    private list<SelectOption> koyoKeitaisOption;   
    private list<SelectOption> koyoKubunsOption;    

    private JFK_RodosyaTR__c rodosyaTR2 = new JFK_RodosyaTR__c();

    private string createRodosyaTRId;
    public string createdRodosyaTRId    { 
        get {
            return createRodosyaTRId;
        }
        set {
            createRodosyaTRId = value;
        }
    }

    private boolean isFromHD = false;
    
    /*
     * Constructor
     */
    public JFK_JCR_SupplementaryController() {
        // 現在のURL取得。修正申請直前だと余計なViewStateが付いてしまうため。
        currentURL = ApexPages.currentPage().getHeaders().get('Host') + ApexPages.currentPage().getUrl();

        // urlパラメータ(from JFK_Menu_JCJページ)を取得
        getUrtParam();

        if (nendo != null && kai != null && jiki != null && jigyosyoid != null) {
            // 初期処理
            init(nendo, kai, jiki, jigyosyoid, rodosyaTRid);
        }
    }

    /*
     * Constructor2
     */
    public JFK_JCR_SupplementaryController(integer p_nendo, integer p_kai, string p_jiki, string p_jigyosyoId, string rodosyaTRId) {
        // 初期処理
        init(string.valueOf(p_nendo), string.valueOf(p_kai), p_jiki, p_jigyosyoid, rodosyaTRId);
    }

      /*
     * getUrtParam
     * 引数   ： なし
     * 戻り値 ： なし
     * 概要   ： urlパラメータを変数に設定
     */
    public void getUrtParam() {
        // urlパラメータ(from JFK_Menu_JCRページ)を取得
        tanto = Apexpages.currentPage().getParameters().get('tanto');
        nendo = Apexpages.currentPage().getParameters().get('nendo');
        kai = Apexpages.currentPage().getParameters().get('kai');
        jiki = Apexpages.currentPage().getParameters().get('jiki');
        jigyosyoid = Apexpages.currentPage().getParameters().get('jigyosyoid');
        rodosyaTRid = Apexpages.currentPage().getParameters().get('rodosyaTRid');
    }
  
    /*
     * showHDScreen
     * 引数   ：categoryNo : チェックシートのカテゴリNo.
     *      No          : チェックシートのNo.
     *      seqNo       : チェックシートのSEQNo.
     *      hantei      : チェック結果(OK/NG)
     *      nendo       : 募集年度
     *      kai         : 募集回
     *      jiki        : 支給時期
     *      jigyosyoId  : 事業所Id
     *      checkSheetId: チェックシートId
     *      tanto       : '1':1次担当者, '2':2次担当者
     *      jigyosyoTRId: 事業所Id
     *      rodosyaTRid : 労働者Id
     * 戻り値  ： チェックシートId
     * 概要   ： チェックシート(JCR)でNGが選択され、かつ、まだチェックシート(JCR)レコードが作成されていない時、JCRレコードを（チェックシート内の内容に応じた件数分）作成し、チェックシートIdを返す
     */
    @RemoteAction
    public static string showHDScreen(integer categoryNo, integer No, integer seqNo, string hantei, integer nendo, integer kai
                                    , string jiki, string jigyosyoId, string checkSheetId, string tanto
                                    , string jigyosyoTRId, string rodosyaTRId) {
        try {
            JFK_JCR_SupplementaryController JCR3 = new JFK_JCR_SupplementaryController(nendo, kai, jiki, jigyosyoId, rodosyaTRId);

            // JCR（補充労働者用）シートの判定が'NG'の時、HD画面を表示する。（HD情報登録のため、事前にチェックシートレコードも作成しておく。）
            string chdckSheetId = JCR3.upsertJCR3(categoryNo, No, seqNo, tanto, JCR3, rodosyaTRId);
            
            string createdRodosyaTRId = null;
            if (rodosyaTRId == null || rodosyaTRId == '') {
                list<JFK_JigyosyoTR__c> lstJigyosyoTR = JFK_cmnSOQL.getJigyosyoTR(jigyosyoTRId);
                
                if (lstJigyosyoTR.size() > 0) {
                    createdRodosyaTRId = JCR3.saveTemp2(jigyosyoId, jiki, lstJigyosyoTR[0]);
                }
            } else {
                createdRodosyaTRId = rodosyaTRId;
            }
                            
            return chdckSheetId + ',' + createdRodosyaTRId;

         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }
    
    /*
     * upsertJCR3
     * 引数 ：p_categoryNo : チェックシートのカテゴリNo.
     *      p_No        : チェックシートのNo.
     *      p_SEQNo     : チェックシートのSEQNo.
     *      tanto       : １次担当者、２次担当者
     *      JCR3        : showScreenで作成したJFK_JCJControllerのインスタンス
     *      rodosyaTRid : 労働者Id
     * 戻り値  ：  チェックシートId
     * 概要   ： チェックシート(JCR（補充労働者用）)でNGが選択された行のチェックシート(JCR（補充労働者用）)レコードを作成し、チェックシートIdを返す
     */
    private string upsertJCR3(integer p_categoryNo, integer p_No, integer p_SEQNo, string tanto, JFK_JCR_SupplementaryController JCR3, string rodosyaTRId) {
        try {
            JFK_CheckSheetTR__c checkTR = new JFK_CheckSheetTR__c();
            list<JFK_CheckSheetTR__c> lstCheckTR = new list<JFK_CheckSheetTR__c>(); 

            // 労働者TRIdが未確定の時は、チェックシートTRを検索しない。(労働者TRIdがnullの時、事業所のチェックシート情報を拾ってしまう。)            
            if (rodosyaTRId != null && rodosyaTRId != '') {
                lstCheckTR = JFK_cmnSOQL.getCheckSheet_JCR4Update(rodosyaTRId, p_SEQNo);          
            }

            if (lstCheckTR == null || lstCheckTR.size() == 0) {
                checkTR = JCR3.setCheckSheetValues(p_categoryNo, p_No, p_SeqNo);
            } else {
                checkTR = lstCheckTR[0];
            }

            return JFK_cmnFunction.upsertCheckSheetTR(lstCheckTR, checkTR);

         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }

    /*
     * init
     * 引数 ： nendo       : 募集年度
     *      kai         : 募集回
     *      jiki        : 支給時期
     *      jigyosyoId  : 事業所Id
     *      rodosyaTRid : 労働者Id
     * 戻り値  ： なし
     * 概要   ： 募集、事業所、GS及びチェックシート（既に存在する場合のみ）情報を取得する。
     */
    private void init(string nendo, string kai, string jiki, string jigyosyoId, string rodosyaTRId) {
        try {
            // 募集情報
            bosyu = JFK_cmnSOQL.getBosyu_1Rec(integer.valueOf(nendo), integer.valueOf(kai), jiki);

            // 事業所TR情報 with GS
            jigyosyoTR = new JFK_JigyosyoTR__c();
            jigyosyoTR = JFK_cmnSOQL.getJigyosyoTR_1Rec_withGS(integer.valueOf(nendo), integer.valueOf(kai), integer.valueOf(bosyu.NenMe__c), integer.valueOf(bosyu.KaiMe__c), jigyosyoid);
            
            /* 補充労働者審査の初回の時、労働者TR自体が存在しないので、下記処理をスキップ */
            if (rodosyaTRid != null && rodosyaTRid.length() > 0) { 
                // 労働者TR情報
                list<JFK_RodoSyaTR__c> lstRodosyaTR = new list<JFK_RodoSyaTR__c>();
                lstRodosyaTR = JFK_cmnSOQL.getRodosyaTR_withGS_1Rec(rodosyaTRId); 
            
                if (lstRodosyaTR.size() == 0) return;

                // GSから担当者及び完了有無情報 取得
                rodosyaTR = JFK_cmnFunction.getRodosyaInfoFromGS(lstRodosyaTR, tantosyaID, tantosyaName, kanryoDate, status);
                for (JFK_CommonTR__c gs : rodosyaTR.RodosyaTRs2__r) {
	                totalStatus             = gs.GS_Status__c;
	                shoruiShinsaKanryoDate  = gs.GS_JissekiSyoruiShinsa_KanryoBi__c;
	            }
                
                // 労働者チェックシート（既に作成済レコードがある場合に抽出される。）
                lstcheckSheetOriginal = JFK_cmnSOQL.getCheckSheetTR_JCR1(jigyosyoTR.Id, rodosyaTR.Id);

                // 登録済労働者情報取得
                list<Contact> lstHojuRodosya = JFK_cmnSOQL.getRodosyaInfo(rodosyaTR.Rodosya__r.Id); 
                if (lstHojuRodosya.size() > 0) {
                    rodosya = lstHojuRodosya[0];
                    lastName = rodosya.LastName; 
                }
            }
            
            // 汎用マスタから'JCR3'のid取得
            lstcommonM_CheckSheet = JFK_cmnSOQL.getCommonM_1Rec(JFK_cmnConstant.COMMON_M_CHECK_SHEET, JFK_cmnConstant.COMMON_M_CHECK_SHEET_JCR_Supplementary);

            // 初めて審査する場合と既に審査したした実績がある場合の処理振り分け(チェックシートレコード有無の確認)
            if (lstcheckSheetOriginal.size() == 0) {
                // 初回の場合は、テンプレート（カスタム設定）から画面を生成
                getCheckSheetTemplate();
            } else {
                // ２回目以降は、チェックシートレコードから画面を生成
                getCheckSheetTR();
            }

            /* MD情報有無確認 */
            if (JFK_cmnSOQL.getCommonTR_Cnt_Jisseki_YearTime(JFK_cmnConstant.COMMON_MANAGE_INFO_MD, jigyosyoTR.Nendo_Kai_Jigyosyo__r.Id) > 0) {
                isExistMD = true;
            } else {
                isExistMD = false;
            }

            /* HD情報有無確認 */
            if (JFK_cmnSOQL.getCommonTR_Cnt_Jisseki_SikyuJiki(JFK_cmnConstant.COMMON_MANAGE_INFO_HD, jigyosyoTR.Id) > 0) {
                isExistHD = true;
            } else {
                isExistHD = false;
            }

            /* HM情報有無確認 */
            if (JFK_cmnSOQL.getCommonTR_Cnt_Jisseki_SikyuJiki(JFK_cmnConstant.COMMON_MANAGE_INFO_HM, jigyosyoTR.Id) > 0) {
                isExistHM = true;
            } else {
                isExistHM = false;
            }
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
         }
    }
    
    /*
     * getCheckSheetTemplate
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ： カスタム設定からチェックシートの内容を読み込み、リストに保存しておく。
     */
    private void getCheckSheetTemplate() {
        try {
            // カスタム設定(JFK_CheckSheetM_JCR_Supplementary__c)から全ての情報を取得
            Map<string, JFK_CheckSheetM_JCR_Supplementary__c> mcs = JFK_CheckSheetM_JCR_Supplementary__c.getAll();
    
            // Map(カスタム設定(JFK_CheckSheetM_JCR_Supplementary__c))からValue項目のみををListに格納
            JFK_CheckSheetM_JCR_Supplementary__c[] chkSheets = mcs.values();

            // List(カスタム設定(JFK_CheckSheetM_JCR_Supplementary__c))を基にカテゴリNo.＋No.をキーとしたMapを作成
            for (JFK_CheckSheetM_JCR_Supplementary__c chkSheet : chkSheets) {
                mapCheckSheetTemplate.put(Integer.valueOf(chkSheet.CategoryNo__c) + '-' + Integer.valueOf(chkSheet.No__c), chkSheet);

                if (chkSheet.CategoryNo__c == 1) { itemNumberEachCategory[0]++; } 
                else if (chkSheet.CategoryNo__c == 2) { itemNumberEachCategory[1]++; } 
                else if (chkSheet.CategoryNo__c == 3) { itemNumberEachCategory[2]++; }
                else if (chkSheet.CategoryNo__c == 4) { itemNumberEachCategory[3]++; }                  
            }
            
            integer seqNo = 1;
            for (integer i = 1; i < pageNumbers + 1; i++) {
                if (i == 1) {
                    for (integer j = 1; j < itemNumberEachCategory[0] + 1; j++) {
                        lstCheckSheetTR1.add(setCheckSheetValues(i, j, seqNo++));
                    }
                } else if (i == 2) {
                    for (integer j = 1; j < itemNumberEachCategory[1] + 1; j++) {        
                        lstCheckSheetTR2.add(setCheckSheetValues(i, j, seqNo++));
                    }
                } else if (i == 3) {
                    for (integer j = 1; j < itemNumberEachCategory[2] + 1; j++) {        
                        lstCheckSheetTR3.add(setCheckSheetValues(i, j, seqNo++));
                    }
                } else if (i == 4) {
                    for (integer j = 1; j < itemNumberEachCategory[3] + 1; j++) {        
                        lstCheckSheetTR4.add(setCheckSheetValues(i, j, seqNo++));
                    }
                }   
            }
        } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
        }
    }
    
    /*
     * getCheckSheetTR
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ： チェックシートTR(JFK_CheckSheetTR__c)からチェックシートの内容を読み込み、リストに保存しておく。
     */
    private void getCheckSheetTR() {
        try {
            // カテゴリNo.＋ No.をキーとしたCheckSeet Mapを作成
            for (JFK_CheckSheetTR__c chkSheet : lstcheckSheetOriginal) {
                mapCheckSheetTR.put(Integer.valueOf(chkSheet.CategoryNo__c) + '-' + Integer.valueOf(chkSheet.No__c), chkSheet);
                
                if (chkSheet.CategoryNo__c == 1) { itemNumberEachCategory[0]++; } 
                else if (chkSheet.CategoryNo__c == 2) { itemNumberEachCategory[1]++; } 
                else if (chkSheet.CategoryNo__c == 3) { itemNumberEachCategory[2]++; } 
                else if (chkSheet.CategoryNo__c == 4) { itemNumberEachCategory[3]++; }                  
            }
    
            integer seqNo = 1;
            for (integer i = 1; i < pageNumbers + 1; i++) {
                if (i == 1) {
                    for (integer j = 1; j < itemNumberEachCategory[0] + 1; j++) {
                        lstCheckSheetTR1.add(setCheckSheetValues(i, j, seqNo++));
                    }
                    if (lstCheckSheetTR1[0].Hantei_1st__c == 'OK') {
                        isShimei = true;
                    } else {
                        isShimei = false;
                    }
                    if (lstCheckSheetTR1[3].Hantei_1st__c == 'OK') {
                        isKoyokubun = true;
                    } else {
                        isKoyokubun = false;
                    }
                    if (lstCheckSheetTR1[5].Hantei_1st__c == 'OK') {
                        isKoyoKeitai = true;
                    } else {
                        isKoyoKeitai = false;
                    }
                    if (lstCheckSheetTR1[7].Hantei_1st__c == 'OK') {
                        isKoyokeiyaku_KaishiBi = true;
                    } else {
                        isKoyokeiyaku_KaishiBi = false;
                    }
                } else if (i == 2) {
                    for (integer j = 1; j < itemNumberEachCategory[1] + 1; j++) {        
                        lstCheckSheetTR2.add(setCheckSheetValues(i, j, seqNo++));
                    }
                } else if (i == 3) {
                    for (integer j = 1; j < itemNumberEachCategory[2] + 1; j++) {        
                        lstCheckSheetTR3.add(setCheckSheetValues(i, j, seqNo++));
                    }
                    if (lstCheckSheetTR3[0].Hantei_1st__c == 'OK') {
                        isKoyoSyurui = true;
                    } else {
                        isKoyoSyurui = false;
                    }
                    if (lstCheckSheetTR3[2].Hantei_1st__c == 'OK') {
                        isHojuRodosyaInfo = true;
                    } else {
                        isHojuRodosyaInfo = false;
                    }
                } else if (i == 4) {
                    for (integer j = 1; j < itemNumberEachCategory[3] + 1; j++) {        
                        lstCheckSheetTR4.add(setCheckSheetValues(i, j, seqNo++));
                    }
                    if (lstCheckSheetTR4[0].Hantei_1st__c == 'NG') {
                        isRisyoku = true;
                    } else {
                        isRisyoku = false;
                    }
                    if (lstCheckSheetTR4[3].Hantei_1st__c == 'NG') {
                        isKoyoKeitaiHenko = true;
                    } else {
                        isKoyoKeitaiHenko = false;
                    }
                    if (lstCheckSheetTR4[7].Hantei_1st__c == 'NG') {
                        isMukyuKekkin = true;
                    } else {
                        isMukyuKekkin = false;
                    }
                }   
            }
        } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
        }
    }

    /*
     * setCheckSheetValues
     * 引数 ： categoryNo  : チェックシートのカテゴリNo.
     *       No         : チェックシートのNo.
     *       SEQNo      : チェックシートのSEQNo.
     * 戻り値  ： JFK_CheckSheetTR__c
     * 概要   ： チェックシートのテンプレートまたはトランザクションを基にチェックシートの各行（各レコード）の文言等を設定する。
     */
    public JFK_CheckSheetTR__c setCheckSheetValues(integer categoryNo, integer no, integer seqNo) {
        JFK_CheckSheetM_JCR_Supplementary__c checkSheetTemplate = mapCheckSheetTemplate.get(string.valueOf(categoryNo) + '-' + string.valueOf(no));
        JFK_CheckSheetTR__c checkSheetTR = mapCheckSheetTR.get(string.valueOf(categoryNo) + '-' + string.valueOf(no));
    
        JFK_CheckSheetTR__c JCR3 = new JFK_CheckSheetTR__c();
 
        try {
            JCR3.Name = JFK_cmnConstant.COMMON_M_CHECK_SHEET_JCR_Supplementary + '_' + string.valueOf(dateTime.now().format());

            JCR3.CheckSheetName__c = lstcommonM_CheckSheet[0].id;
            JCR3.JigyosyoTR__c = jigyosyoTR.id;

            /* 補充労働者審査の初回の時、労働者TR自体が存在しないので、下記処理をスキップ */
            if (rodosyaTRid != null && rodosyaTRid.length() > 0) { 
                JCR3.RodosyaTR__c = rodosyaTR.id;
            }

            JCR3.CategoryNo__c = categoryNo;
            JCR3.No__c = no;
            JCR3.SEQNo__c = seqNo;

            if (checkSheetTR == null) {
                string koyoKaishiBi = rodosyaTR.Rodosya__r.KoyoKeiyaku_KaishiBi__c == null ? '' : string.valueOf(rodosyaTR.Rodosya__r.KoyoKeiyaku_KaishiBi__c);
                string koyoSyuryoBi = rodosyaTR.Rodosya__r.KoyoKeiyaku_SyuryoBi__c == null ? '' : string.valueOf(rodosyaTR.Rodosya__r.KoyoKeiyaku_SyuryoBi__c);

                // 初回審査のため、チェックシートレコードが存在しない時
                JCR3.NoForShow__c = checkSheetTemplate.NoForShow__c;
                JCR3.CheckKomoku__c = checkSheetTemplate.CheckKomoku__c;
                if (categoryNo == 1) {
                    if (no == 1) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 2) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 3) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 4) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 5) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 6) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 7) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 8) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 9) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 10) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }
                } else if (categoryNo == 2) {
                    if (no == 1) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 2) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }
                } else if (categoryNo == 3) {
                    if (no == 1) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 2) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 3) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 4) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 5) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 6) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 7) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }
                } else if (categoryNo == 4) {
                    if (no == 1) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 2) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 3) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 4) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 5) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 6) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 7) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 8) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 9) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }else if (no == 10) {
                        JCR3.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }
                }
                
                JCR3.Zokusei__c = checkSheetTemplate.Zokusei__c;
                JCR3.PasonaHoseiKa__c = checkSheetTemplate.PasonaHoseiKa__c;
                JCR3.ActionAfterJudgement__c = checkSheetTemplate.ActionAfterJudgement__c;
                JCR3.ShowHanteiCheckBox__c = checkSheetTemplate.ShowHanteiCheckBox__c;
                JCR3.ShowTextBox__c = checkSheetTemplate.ShowTextBox__c;
            } else {
                // 既にチェックシートレコードが存在する時
                JCR3 = JFK_cmnFunction.setValue2CheckSheet(checkSheetTR, categoryNo, no, seqNo);
                JCR3.Biko__c = rodosyaTR.Biko__c;

                //　画面の補充元労働者に１次担当者が登録した労働者を初期表示する。
                risyokusyaSearch = rodosya.HojuMoto_Rodosya__c;
                koyoSyuruiSearch = rodosya.KoyoSyurui__c;
                koyoKubunSearch = rodosya.KoyoKBN__c;
                koyoKeitaiSearch = rodosya.KoyoKeitai__c;
            }
            
            return JCR3;
            
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }

    /*
     * AssembleCheckNaiyo
     * 引数   ：JFK_CheckSheetM_JCR_Supplementary__c
     *       checkValue
     * 戻り値  ： チェック内容
     * 概要   ： チェック内容を組み立てる。
     */
    private string AssembleCheckNaiyo(JFK_CheckSheetM_JCR_Supplementary__c checkSheetTemplate, string checkValue) {
        return (checkSheetTemplate.CheckNaiyo__c == null ? '' : checkSheetTemplate.CheckNaiyo__c)
                + (checkValue == '' ? '' : '　「'  )
                + checkValue
                + (checkValue == '' ? '' : '」　')
                + (checkSheetTemplate.CheckNaiyo_After__c == null ? '' : checkSheetTemplate.CheckNaiyo_After__c);
    }
    
    /*
     * getHojumotoInfo
     * 引数   ： なし
     * 戻り値  ：pageReference
     * 概要   ： 雇用区分と雇用形態のリスト作成
     */
    public pageReference getHojumotoInfo() {
        try {
            list<Contact> lstMotoRodosya = JFK_cmnSOQL.getRodosyaInfo(risyokusyaSearch);

            if (lstMotoRodosya.size() > 0) {
                hojuMotoRodosya = lstMotoRodosya[0];
                
                // 雇用区分コンボの内容再生成
                getKoyoKubunsSearch();
                // 雇用形態コンボの内容再生成
                getKoyoKeitaisSearch();
            } else {
                hojuMotoRodosya = null;
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
     * checkComplete
     * 引数   ： なし
     * 戻り値  ： 成功 true
     * 概要   ： 全てのチェック項目にOK/NGが入力されたか確認
     */
    public boolean checkComplete() {
        try {
            if (!JFK_cmnFunction.chkComplete(lstCheckSheetTR1, tanto)) return false;
            if (!JFK_cmnFunction.chkComplete(lstCheckSheetTR2, tanto)) return false;
            if (!JFK_cmnFunction.chkComplete(lstCheckSheetTR3, tanto)) return false;
            if (!JFK_cmnFunction.chkComplete(lstCheckSheetTR4, tanto)) return false;

            return true;
            
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }
    
    /*
     * passback
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 差し戻し処理
     */
    public pageReference passback() {
        isPassback = true;
        
        // 一時保存処理
        saveTemp();
        
        isPassback = false;
        
        return null;
    }

    /*
     * saveTemp
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 一次保存処理
     */
    public pageReference saveTemp() {
        isSaveTemp = true;
        
        // 保存処理
        save();
        
        isSaveTemp = false;

        return null;
    }
    
    /*
     * saveTemp2
     * 引数   ： string : p_jigyosyoId
     *       string : p_jiki
     *       JFK_JigyosyoTR__c : p_jigyosyoTR
     * 戻り値  ： 仮の補充労働者Id
     * 概要   ： 仮の補充労働者を作成する。
     */
    public string saveTemp2(string p_jigyosyoId, string p_jiki, JFK_JigyosyoTR__c p_jigyosyoTR) {
		try {
	        isSaveTemp = true;
	        isFromHD = true;
		
	        // 保存処理
	        save();
	            
	        isSaveTemp = false;
	        isFromHD = false;
	
	        return rodosyaTR2.Id;

         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }

    /*
     * save
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 保存処理
     */
    public pageReference save() {
        list<JFK_CommonTR__c> lstGs4Upsert = new list<JFK_CommonTR__c>();
        list<Database.saveResult> lsr = new list<Database.saveResult>();
        Database.saveResult sr;
        Savepoint sp;

        boolean isComplete = false;
        boolean isSuccess4GS = true;
        string rodosyaId;
        
        try {
            // 一時保存の時は、補充労働者のエラーチェックを行わない。
            if (!isSaveTemp) {
                if (checkError()) return null;
            }
            
            // 完了チェック
            isComplete = checkComplete();
            if (!isComplete && !isSaveTemp) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,System.Label.JFK_Error006));
                return null;
            }
            
            sp = Database.setSavepoint();

            if (isFromHD) {
		        // 仮の補充労働者作成処理
		        rodosyaTR2 =
		        createHojuRodosyaInfo(null, hojuRodosya, jigyosyoid, null, null, null, null, null
		                            , null, null, jigyosyoTR, rodosyaTR, sr, null, jiki
		                            , null, null, null, null);
            } else {
            // 「一時保存」ボタンまたは「チェック済」ボタン押下時のみ実行
                if (rodosyaTRId == null || rodosyaTRId == '') {
                    rodosyaTRId = createdRodosyaTRId;
                }

                rodosyaTR2 =
                createHojuRodosyaInfo(rodosyaTRId, hojuRodosya, jigyosyoid, risyokusyaSearch
                                    , koyoSyuruiSearch, koyoKubunSearch, koyoKeitaiSearch, isKetsuBan
                                    , isKoyokeitaiHenko, isRisyoku, jigyosyoTR, rodosyaTR
                                    , sr, rodosyaId, jiki
                                    , tantosyaID, tantosyaName, kanryoDate, status);
            }
            
            list<JFK_CheckSheetTR__c> checkSheetBeforeUpsert = new list<JFK_CheckSheetTR__c>(); 
            checkSheetBeforeUpsert = JFK_cmnSOQL.getCheckSheet_JCR4Update(rodosyaTR2.Id);
            
            // チェックシートの保存
            for (integer i = 0; i < lstCheckSheetTR1.size(); i++) {
                lstCheckSheetTR1[i].RodosyaTR__c = rodosyaTR2.Id;
            } 
            JFK_cmnFunction.upsertCheckSheet(itemNumberEachCategory[0], checkSheetBeforeUpsert, lstCheckSheetTR1, lsr);

            for (integer i = 0; i < lstCheckSheetTR2.size(); i++) {
                lstCheckSheetTR2[i].RodosyaTR__c = rodosyaTR2.Id;
            } 
            JFK_cmnFunction.upsertCheckSheet(itemNumberEachCategory[1], checkSheetBeforeUpsert, lstCheckSheetTR2, lsr);

            for (integer i = 0; i < lstCheckSheetTR3.size(); i++) {
                lstCheckSheetTR3[i].RodosyaTR__c = rodosyaTR2.Id;
            } 
            JFK_cmnFunction.upsertCheckSheet(itemNumberEachCategory[2], checkSheetBeforeUpsert, lstCheckSheetTR3, lsr);

            for (integer i = 0; i < lstCheckSheetTR4.size(); i++) {
                lstCheckSheetTR4[i].RodosyaTR__c = rodosyaTR2.Id;
            } 
            JFK_cmnFunction.upsertCheckSheet(itemNumberEachCategory[3], checkSheetBeforeUpsert, lstCheckSheetTR4, lsr);

            // GS更新
            JFK_cmnFunction.updateGS(jigyosyoTR, rodosyaTR2, currentURL, tanto, isSuccess4GS, isComplete, isSaveTemp, isPassBack
                                   , lsr, lstGs4Upsert);
                            
            // 更新成功
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.JFK_Info001));

            return null;

         } catch (DmlException e) {
         	if (sr != null) {
	            lsr.clear();     
         		lsr.add(sr);
         	}
            JFK_cmdUtilities.chkSaveResult(lsr);
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.JFK_Error007));
            return null;
         } catch (Exception e) {
            Database.rollback(sp);
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
     }               

    /*
     * createHojuRodosyaInfo
     * 引数 ： 
     * 戻り値：補充労働者情報(労働者TR)
     * 概要 ： 補充労働者情報作成
     */
    public JFK_RodosyaTR__c createHojuRodosyaInfo(string rodosyaTRId, Contact hojuRodosya, string jigyosyoid, string risyokusyaSearch
                                                , string koyoSyuruiSearch, string koyoKubunSearch, string koyoKeitaiSearch
                                                , boolean isKetsuBan, boolean isKoyokeitaiHenko, boolean isRisyoku
                                                , JFK_JigyosyoTR__c jigyosyoTR, JFK_RodosyaTR__c rodosyaTR
                                                , Database.saveResult sr, string rodosyaId, string jiki
                                                , string[] tantosyaID, string[] tantosyaName, date[] kanryoDate, string[] status) {

        list<Contact> lstNewRodosya = JFK_cmnSOQL.getRodosyaInRodosyaTR(rodosyaTRId); 
        if (lstNewRodosya == null || lstNewRodosya.size() == 0) {
            // Contact（補充労働者）作成
            if (lastName == null) {
                lastName = '氏名未登録 補充労働者（処理日時：' + dateTime.now().addhours(9) + '）';
            }
            
            hojuRodosya.LastName = lastName;
            hojuRodosya.AccountId = jigyosyoid;
            hojuRodosya.HojuMoto_Rodosya__c = risyokusyaSearch;
            hojuRodosya.KoyoSyurui__c = koyoSyuruiSearch;
            hojuRodosya.KoyoKBN__c = koyoKubunSearch;
            hojuRodosya.KoyoKeitai__c = koyoKeitaiSearch;
                
            hojuRodosya.Ketsuban__c = isKetsuBan == null ? false : isKetsuBan; 

            // 最大労働者No取得
            list<Contact> lstRodosyaMaxNo = JFK_cmnSOQL.getRodosyaMaxNo(jigyosyoId);
            if (lstRodosyaMaxNo.size() > 0) {
                hojuRodosya.RodosyaNO__c = lstRodosyaMaxNo[0].RodosyaNO__c + 1; 
                hojuRodosya.RodosyaCD__c = jigyosyoTR.Nendo_Kai_Jigyosyo__r.JigyoshoCD__c + '.' + string.valueOf(lstRodosyaMaxNo[0].RodosyaNO__c + 1);
            }
            sr = database.insert(hojuRodosya);
                
            // 労働者Id取得
            rodosyaId = sr.getId();
            // 労働者TR（支給時期）作成
            JFK_RodosyaTR__c rodosyaTR2 = new JFK_RodosyaTR__c(); 
            rodosyaTR2.Name = hojuRodosya.RodosyaCD__c + '_' + jiki;
            rodosyaTR2.JigyosyoTR_ShikyuJiki__c = jigyosyoTR.Id;
            rodosyaTR2.Rodosya__c = rodosyaId;
            rodosyaTR2.Biko__c = rodosyaTR.Biko__c;
            rodosyaTR2.HojuRodosyaFLG__c = true;
                    
            sr = Database.insert(rodosyaTR2);
    
            return rodosyaTR2; 
        } else {
            Contact rodosya = JFK_cmnSOQL.getRodosyaInRodosyaTR4Update(rodosyaTRId);

            rodosya.LastName = lastName;
            rodosya.FirstName = hojuRodosya.FirstName;
            rodosya.AccountId = jigyosyoid;
                        
            list<JFK_RodosyaTR__c> lstNewRodosyaTR = new list<JFK_RodosyaTR__c>(); 
            // 最大労働者No取得
            list<Contact> lstRodosyaMaxNo = new list<Contact>();
            if (rodosya.RodosyaNO__c == null) {
                lstRodosyaMaxNo = JFK_cmnSOQL.getRodosyaMaxNo(jigyosyoId);
                if (lstRodosyaMaxNo.size() > 0) {
                    rodosya.RodosyaNO__c = lstRodosyaMaxNo[0].RodosyaNO__c + 1; 
                    
                    lstNewRodosyaTR = JFK_cmnSOQL.getRodosyaTR_withGS_1Rec(rodosyaTRId);
                    rodosya.RodosyaCD__c = string.valueOf(lstNewRodosyaTR[0].JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.JigyoshoCD__c) + '.' + 
                                           string.valueOf(lstRodosyaMaxNo[0].RodosyaNO__c + 1);
                }
            }
            rodosya.HojuMoto_Rodosya__c = risyokusyaSearch;
            rodosya.KoyoSyurui__c = koyoSyuruiSearch;
            rodosya.KoyoKBN__c = koyoKubunSearch;
            rodosya.KoyoKeitai__c = koyoKeitaiSearch;
            
            if (isKoyoKeitaiHenko != null && isKoyoKeitaiHenko) {
                rodosya.KoyoKeitai_HenkoBi__c = hojuRodosya.KoyoKeitai_HenkoBi__c;
            } else {
                rodosya.KoyoKeitai_HenkoBi__c = null;
            } 
                
            if (isRisyoku != null && isRisyoku) {
                rodosya.RisyokuBi__c = hojuRodosya.RisyokuBi__c;
                rodosya.RisyokuRiyu__c = hojuRodosya.RisyokuRiyu__c; 
            } else {
                rodosya.RisyokuBi__c = null;
                rodosya.RisyokuRiyu__c = null; 
            } 

            rodosya.Ketsuban__c = isKetsuBan == null ? false : isKetsuBan; 

            sr = database.update(rodosya);

            list<JFK_RodoSyaTR__c> lstRodosyaTR = new list<JFK_RodoSyaTR__c>();
            lstRodosyaTR = JFK_cmnSOQL.getRodosyaTR_withGS_1Rec(rodosyaTRId); 

            if (lstRodosyaTR[0].Name == null) {
                lstRodosyaTR[0].Name = rodosya.RodosyaCD__c + '_' + string.valueOf(lstNewRodosyaTR[0].JigyosyoTR_ShikyuJiki__r.BosyuJoho_ShikyuJiki__r.ShikyuJiki_Sushiki__c);
                lstRodosyaTR[0].JigyosyoTR_ShikyuJiki__c = lstNewRodosyaTR[0].JigyosyoTR_ShikyuJiki__c;
                lstRodosyaTR[0].Rodosya__c = lstNewRodosyaTR[0].Rodosya__r.Id;
                lstRodosyaTR[0].Biko__c = lstNewRodosyaTR[0].Biko__c;
            }

            lstRodosyaTR[0].HojuRodosyaFLG__c = true;
                    
            sr = Database.update(lstRodosyaTR[0]);
            
            JFK_RodosyaTR__c rodosyaTR2 = 
                JFK_cmnFunction.getRodosyaInfoFromGS(lstRodosyaTR, tantosyaID, tantosyaName, kanryoDate, status);

            return rodosyaTR2; 
        }

        return null;
    }

    /*
     * checkError
     * 引数   ： なし
     * 戻り値  ： boolean
     * 概要   ： エラーチェック処理
     */
    private boolean checkError() {
        try {
            boolean isError = false;

            if (lastName == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'姓を入力してください。'));
                isError = true;
            }

            if (hojuRodosya.FirstName == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error024));
                isError = true;
            }

            if (risyokusyaSearch == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error023));
                isError = true;
            }

            if (koyoSyuruiSearch == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error034));
                isError = true;
            }

            if (koyoKubunSearch == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error035));
                isError = true;
            }

            if (koyoKeitaiSearch == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error036));
                isError = true;
            }

            if (hojuRodosya.Address__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error025));
                isError = true;
            }

            // JCR(通常)と共通のエラーチェック 
            isError = JFK_cmnFunction.checkError_JCR(isKoyoKeitaiHenko, isRisyoku, rodosya, bosyu, jigyosyoTR, koyoKeitaiHenkoSearch, isMukyuKekkin, rodosyaTR);

            return isError;
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }

    /*
     * close
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 画面を閉じる
     */
    public pageReference close() {
        return new PageReference('javascript:window.close()');
    }

    public void dummy() {
    } 
    
    /*
     * tantoTimes
     * 引数   ：
     * 戻り値  ： '1' : １次担当者　　'2'　:　２次担当者
     * 概要   ： １次担当者及び２次担当者を返す。
     */
    public string tantoTimes {
        get {
            return tanto;
        }
        set {
            tantoTimes = value;
        }
    }

    /*
     * tantosyaName
     * 引数   ：
     * 戻り値  ： 担当者名（１次、２次）
     * 概要   ： 担当者名（１次、２次取得
     */
    public string[] tantosya {
        get {
            return JFK_cmnFunction.getTantosyaName(tantosyaName);
        }
    }

    /*
     * areaKBN
     * 引数   ：
     * 戻り値  ： エリア区分
     * 概要   ： エリア区分取得
     */
    public string areaKBN {
        get {
            return JFK_cmnFunction.assembleAreaKBN(jigyosyoTR);
        }
    }

    /*
     * areaName
     * 引数   ： 
     * 戻り値  ： エリア名
     * 概要   ： エリア名取得
     */
    public string areaName {
        get {
            return JFK_cmnFunction.assembleAreaName(jigyosyoTR);
        }
    }

    /*
     * getlstCheckSheet1
     * 引数   ：
     * 戻り値  ： チェックシート１の内容
     * 概要   ： チェックシート１の内容取得
     */
    public list<wrapper> CheckSheet1 {
        get {
            return setValues2Wrapper(lstcheckSheetTR1); 
        }
    }

    /*
     * getlstCheckSheet2
     * 引数   ：
     * 戻り値  ： チェックシート２の内容
     * 概要   ： チェックシート２の内容取得
     */
    public list<wrapper> CheckSheet2 {
        get {
            return setValues2Wrapper(lstcheckSheetTR2); 
        }
    }
    
    /*
     * getlstCheckSheet3
     * 引数   ：
     * 戻り値  ： チェックシート３の内容
     * 概要   ： チェックシート３の内容取得
     */
    public list<wrapper> CheckSheet3 {
        get {
            return setValues2Wrapper(lstcheckSheetTR3); 
        }
    }

    /*
     * getlstCheckSheet4
     * 引数   ：
     * 戻り値  ： チェックシート４の内容
     * 概要   ： チェックシート４の内容取得
     */
    public list<wrapper> CheckSheet4 {
        get {
            return setValues2Wrapper(lstcheckSheetTR4); 
        }
    }

    /*
     * setValues2Wrapper
     * 引数   ： lstcheckSheetTR ： チェックシートの内容
     * 戻り値  ： チェックシートの内容(Wrapper)
     * 概要   ： チェックシートの内容をWrapperに保存
     */
    public list<wrapper> setValues2Wrapper(list<JFK_CheckSheetTR__c> lstcheckSheetTR) {
        try {
            list<wrapper> lstcheckWrapper = new list<wrapper>();
    
            for (JFK_CheckSheetTR__c checkSheetTR : lstcheckSheetTR) {
                wrapper clswrap = new wrapper(checkSheetTR);
                lstcheckWrapper.add(clswrap);
            }
            
            return lstcheckWrapper; 
            
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }

    /*
     * isDisableButton
     * 引数   ：
     * 戻り値  ： True : ボタン使用可能   False : ボタン使用不可
     * 概要   ： 「完了」及び「MD」「HK」等のボタン使用可否制御
     */
    public boolean isDisableButton {
        get {
            if (tanto == '1') {
                return JFK_cmnFunction.isDisableButton(status, tanto, 0, tantosyaID, kanryoDate);
            } else {
                return JFK_cmnFunction.isDisableButton(status, tanto, 1, tantosyaID, kanryoDate);
            }
        }
    }

    /*
     * render1stPart
     * 引数   ：
     * 戻り値  ： １次担当者について「完了」「保存」等のボタン使用可否
     * 概要   ： １次担当者について 「完了」「保存」等のボタン使用可否制御
     */
    public boolean render1stPart {
        get {
            return JFK_cmnFunction.render1stPart(status, tanto, 0, tantosyaID, kanryoDate);
        }
    }

    /*
     * render2ndPart
     * 引数   ：
     * 戻り値  ： １次担当者について「完了」「保存」等のボタン使用可否
     * 概要   ： １次担当者について 「完了」「保存」等のボタン使用可否制御
     */
    public boolean render2ndPart {
        get {
            return JFK_cmnFunction.render2ndPart(status, tanto, 1, tantosyaID, kanryoDate);
        }
    }

    /*
     * Passback 
     * 引数   ： 
     * 戻り値  ： 差し戻しボタン使用可否
     * 概要   ： 差し戻しボタン使用可否制御
     */
    public boolean passback {
        get {
            return JFK_cmnFunction.passback(status, tanto, 1, tantosyaID, kanryoDate);
        }
    }

    /*
     * getOkNg
     * 引数   ：
     * 戻り値  ： OK/NGのSelectOption
     * 概要   ： OK/NGのSelectOption設定
     */
    public List<SelectOption> getOkNg() {
        return JFK_cmnFunction.getOkNg();        
    }

    /*
     * AriNashi
     * 引数   ：
     * 戻り値  ： 有/無のSelectOption
     * 概要   ： 有/無のSelectOption設定
     */
    public list<SelectOption> AriNashi {
        get {
            return JFK_cmnFunction.getAriNashi();
        }
    }

     /*
     * checkShimei
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ： 
     */
    public void checkShimei() {
        string prm = System.currentPageReference().getParameters().get('param');

        if (boolean.valueOf(prm)) {
            isShimei = true;
        } else {
            isShimei = false;
        }
    }

    /*
     * checkKoyoKubun
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ：
     */
    public void checkKoyoKubun() {
        string prmKoyokeitai = System.currentPageReference().getParameters().get('param');
        
        if (boolean.valueOf(prmKoyokeitai)) {
            isKoyoKubun = true;
        } else {
            isKoyoKubun = false;
        }
    }

    /*
     * checkKoyokeitai
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ：
     */
    public void checkKoyokeitai() {
        string prmKoyokeitai = System.currentPageReference().getParameters().get('param');
        
        if (boolean.valueOf(prmKoyokeitai)) {
            isKoyoKeitai = true;
        } else {
            isKoyoKeitai = false;
        }
    }

    /*
     * checkKoyoSyurui
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ：
     */
    public void checkKoyoSyurui() {
        string paramValue = System.currentPageReference().getParameters().get('param');
        
        if (boolean.valueOf(paramValue)) {
            isKoyoSyurui = true;
        } else {
            isKoyoSyurui = false;
        }
    }

    /*
     * checkHojuRodosyaInfo
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ：
     */
    public void checkHojurodosyaInfo() {
        string paramValue = System.currentPageReference().getParameters().get('param');
        
        if (boolean.valueOf(paramValue)) {
            isHojuRodosyaInfo = true;
        } else {
            isHojuRodosyaInfo = false;
        }
    }

    /*
     * checkKoyokeitaiHenko
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ：
     */
    public void checkKoyokeitaiHenko() {
        string prmKoyokeitaiHenko = System.currentPageReference().getParameters().get('param');
        if (boolean.valueOf(prmKoyokeitaiHenko)) { 
            isKoyoKeitaiHenko = true;
        } else {
            isKoyoKeitaiHenko = false;
        }
    }

     /*
     * checkRisyoku
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ：
     */
    public void checkRisyoku() {
        string paramValue = System.currentPageReference().getParameters().get('param');
        if (boolean.valueOf(paramValue)) {
            isRisyoku = true;
        } else {
            isRisyoku = false;
        }       
    }

    /*
     * checkKoyoKeiyakun_KaishiBi
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ：
     */
    public void checkKoyoKeiyaku_KaishiBi() {
        string paramValue = System.currentPageReference().getParameters().get('param');
        if (boolean.valueOf(paramValue)) {
            isKoyoKeiyaku_KaishiBi = true;
        } else {
            isKoyoKeiyaku_KaishiBi = false;
        }
    }

    /*
     * checkMukyuKekkin
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ：
     */
    public void checkMukyuKekkin() {
        string prmMukyuKekkin = System.currentPageReference().getParameters().get('param');
        if (boolean.valueOf(prmMukyuKekkin)) {
            isMukyuKekkin = true;
        } else {
            isMukyuKekkin = false;
        }
    }

    /*
     * checkRisyokuBi
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ：
     */
    public void checkRisyokuBi() {
        date risyokuBi = hojuRodosya.RisyokuBi__c;

        // チェックボックスをクリックする前の値が戻ってくるので、パラメータの値が"false"の時、プロパティをtrueにする。
        if (risyokuBi < Bosyu.Bosyu__r.KoyoKaishiSaihayaBi__c) {
            isKetsuBan = true;
        } else {
            isKetsuBan = false;
        }       
    }

     /*
     * setCreatedRodosyaId
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ：
     */
    public void setCreatedRodosyaId() {
        createRodosyaTRId = System.currentPageReference().getParameters().get('param');
        rodosyaTRid = createRodosyaTRId;
    }

    /*
     * risyokusyasSearch
     * 引数   ：
     * 戻り値  ： list<SelectOption>
     * 概要   ：
     */
    public list<SelectOption> risyokusyasSearch {
        get {
            list<Contact> lstRodosya = JFK_cmnSOQL.getRisyokusyaInJigyosyo(jigyosyoId);
            list<SelectOption> options = new List<SelectOption>();

            options.add(new SelectOption('', ''));
            for (Contact rodosya : lstRodosya) {
                options.add(new SelectOption(rodosya.Id, rodosya.Name));
            }
                      
            return options;
        }
    }

    /*
     * koyoSyuruisSearch
     * 引数   ：
     * 戻り値  ： list<SelectOption>
     * 概要   ：
     */
    public list<SelectOption> koyoSyuruisSearch {
        get {
            list<JFK_CommonM__c> lstCommon = JFK_cmnSOQL.getCommonM(JFK_cmnConstant.KOYO_SYURUI);
            return JFK_cmnFunction.createSelectOption_CommonM(lstCommon);
        }
    }

    /*
     * koyoKubunsSearch
     * 引数   ：
     * 戻り値  ： list<SelectOption>
     * 概要   ：
     */
    public list<SelectOption> getKoyoKubunsSearch() {
        list<JFK_CommonM__c> lstCommon = JFK_cmnSOQL.getCommonM(JFK_cmnConstant.KOYO_KUBUN);
        list<SelectOption> lstTemp = new list<SelectOption>(); 

        koyoKubunsOption = JFK_cmnFunction.createSelectOption_CommonM(lstCommon);
                
        if (hojumotoRodosya != null) {
            // 補充元労働者が新規雇用の時、再雇用はリストから外す。
            if (hojumotoRodosya.KoyoKBN__r.Name != null && hojumotoRodosya.KoyoKBN__r.Name == JFK_cmnConstant.KOYO_SHINKI_KOYO) {
                integer j = 0;
                lstTemp = koyoKubunsOption.clone();
                for (SelectOption kbn : koyoKubunsOption) {
                    if (kbn.getLabel() == JFK_cmnConstant.KOYO_SAI_KOYO) {
                        lstTemp.remove(j);
                    }
                    j++;
                }
                koyoKubunsOption = lstTemp.clone();
            }
        }
                
        return koyoKubunsOption;
    }

    /*
     * getKoyoKeitaisSearch
     * 引数   ： 
     * 戻り値  ： list<SelectOption>
     * 概要   ：
     */
    public list<SelectOption> getKoyoKeitaisSearch() {
        list<JFK_CommonM__c> lstCommon = JFK_cmnSOQL.getCommonM(JFK_cmnConstant.KOYO_KEITAI);
        list<SelectOption> lstTemp = new list<SelectOption>(); 

        koyoKeitaisOption = JFK_cmnFunction.createSelectOption_CommonM(lstCommon);
            
        if (hojumotoRodosya != null) {
            // 補充元労働者がフルタイムの時、短時間はリストから外す。
            if (hojumotoRodosya.KoyoKeitai__r.Name != null && hojumotoRodosya.KoyoKeitai__r.Name == JFK_cmnConstant.KOYO_FULLTIME) {
                integer j = 0;
                lstTemp = koyoKeitaisOption.clone();
                for (SelectOption keitai : koyoKeitaisOption) {
                    if (keitai.getLabel() == JFK_cmnConstant.KOYO_TANJIKAN) {
                        lstTemp.remove(j);
                    }
                    j++;
                }
                koyoKeitaisOption = lstTemp.clone();
            }
        }
            
        return koyoKeitaisOption;
    }
    
     /*
     * koyoKeitaisSearch
     * 引数   ：
     * 戻り値  ： list<SelectOption>
     * 概要   ：
     */
    public list<SelectOption> koyoKeitaisHenkoSearch {
        get {
            list<JFK_CommonM__c> lstCommonM = JFK_cmnSOQL.getCommonM(JFK_cmnConstant.KOYO_KEITAI);
            list<SelectOption> options = new List<SelectOption>();
            
            options.add(new SelectOption('', ''));
            for (JFK_CommonM__c item : lstCommonM) {
                if (item.Name == JFK_cmnConstant.KOYO_FULLTIME) {
                    options.add(new SelectOption(item.Id, '短⇒フルへ')); // フルタイム労働者として登録される。
                } else {
                    options.add(new SelectOption(item.Id, 'フル⇒短へ')); // 短時間労働者として登録される。
                }
                lstKoyokeitaiId.add(item.Id);
            }
        
            return options;
        }
    }
 
    /*
     * wrapperクラス
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public class wrapper {
        public JFK_CheckSheetTR__c  CheckSheet { 
            get {
                return CheckSheet;
            }
            set {
                CheckSheet = value;
            } 
        }
        public wrapper(JFK_CheckSheetTR__c p_chSheetTR) {
            CheckSheet = p_chSheetTR;
        }
    }
}