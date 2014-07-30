/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_JCR_1Controller
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/10/07 Create
 ******************************************************************************/
public class JFK_JCR_1Controller {
    // urlパラメータ from JFK__JCJ
    public  string tanto { get; set; }
    private string nendo;
    private string kai;
    private string jiki;
    private string jigyosyoid;

    // 現在のページのurl
    private string currentURL;

    // 画面表示情報用Check Sheet Map
    private map<string, JFK_CheckSheetM_JCR_1__c>   mapCheckSheetTemplate = new map<string, JFK_CheckSheetM_JCR_1__c>();    // 新規作成用（カスタム設定から情報取得）
    private map<string, JFK_CheckSheetTR__c>        mapCheckSheetTR       = new map<string, JFK_CheckSheetTR__c>();         // 既存用（審査シートレコードから情報取得）

    // Check Sheetトランザクション List (Original:前回更新分)
    private list<JFK_CheckSheetTR__c> lstcheckSheetOriginal = new list<JFK_CheckSheetTR__c>();
    
    // Check Sheetトランザクション List（今回更新分）
    private list<JFK_CheckSheetTR__c>   lstCheckSheetTR1    = new list<JFK_CheckSheetTR__c>();
    private list<JFK_CheckSheetTR__c>   lstCheckSheetTR2    = new list<JFK_CheckSheetTR__c>();
    private list<JFK_CheckSheetTR__c>   lstCheckSheetTR3    = new list<JFK_CheckSheetTR__c>();

    // 汎用マスタ List（チェックシート名を保持）
    private list<JFK_CommonM__c>        lstcommonM_CheckSheet; 

    // Total Page数
    private final integer pageNumbers = 3;

    // カテゴリ別のアイテム（行）数を保持
    private integer[] itemNumberEachCategory = new integer[]{0, 0, 0};

    // 一時保存フラグ
    private boolean isSaveTemp = false;
    // 差し戻しフラグ
    private boolean isPassback = false;

    // １次・２次審査担当者ID
    private string[] tantosyaID = new string[2];
    private string[] tantosyaName = new string[2];

    // １次・２次審査完了日
    private date[] kanryoDate = new date[2];
    // １次・２次審査Status
    private string[] status = new string[2];
    
    // GS 書類審査完了日
    public date shoruiShinsaKanryoDate      { get; set; }
    // GSのステータス
    public string               totalStatus { get; set; }

    // 募集情報（画面表示用）
    public JFK_Bosyu__c         bosyu       { get; set; }

    // 事業所TR情報（画面表示用）
    public JFK_JigyosyoTR__c    jigyosyoTR  { get; set; }

    // 労働者TRId
    public string rodosyaTRid               { get; set; }

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
    public string               rodosyaCD           { get; set; }
    public string               koyoKeitaiSearch    { get; set; }
     
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
    public boolean              isRisyoku           { get; set; }
    public boolean              isKoyoKeitaiHenko   { get; set; }
    public boolean              isKetsuBan          { get; set; }
    public boolean              isMukyuKekkin       { get; set; }
    public boolean              showTaisyogaiRodosya{ get; set; }
	
	// 雇用形態Idセット
    private list<Id>            lstKoyokeitaiId = new list<Id>();

    /* Contact(労働者)情報 */
    private Contact rodosya = new Contact();
    public Contact rodosyaInfo  {
        get {
            return rodosya;
        }
        set {
            rodosya = value;
        }
    }

    /*
     * Constructor
     */
    public JFK_JCR_1Controller() {
        // 現在のURL取得。修正申請直前だと余計なViewStateが付いてしまうため。
        currentURL = ApexPages.currentPage().getHeaders().get('Host') + ApexPages.currentPage().getUrl();

        // urlパラメータ(from JFK_Menu_JCRページ)を取得
        getUrtParam();

        if (nendo != null && kai != null && jiki != null && jigyosyoid != null && rodosyaTRid != null) {
            // 初期処理
            init(nendo, kai, jiki, jigyosyoid, rodosyaTRid);

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
        }
        
        if (lstcheckSheetOriginal == null || lstcheckSheetOriginal.size() < 6) {
            showTaisyogaiRodosya = false;
        } else {
        	// 支給決定日以後の離職か？ 
            if (lstcheckSheetOriginal[5].Hantei_1st__c == null || lstcheckSheetOriginal[5].Hantei_1st__c == 'OK') {
                showTaisyogaiRodosya = false;
            } else {
                showTaisyogaiRodosya = true;
            }
        }
    }

    /*
     * Constructor2
     */
    public JFK_JCR_1Controller(integer p_nendo, integer p_kai, string p_jiki, string p_jigyosyoId, string rodosyaTRid) {
        // 初期処理
        init(string.valueOf(p_nendo), string.valueOf(p_kai), p_jiki, p_jigyosyoid, rodosyaTRid);
    }

    /*
     * getUrtParam
     * 引数   ：
     * 戻り値  ： なし
     * 概要   ： urlパラメータ(from JFK_Menu_JCRページ)を取得
     */
    public void getUrtParam() {
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
     *      rodosyaTRid : 労働者Id
     * 戻り値  ： チェックシートId
     * 概要   ： チェックシート(JCR)でNGが選択され、かつ、まだチェックシート(JCR)レコードが作成されていない時、JCRレコードを（チェックシート内の内容に応じた件数分）作成し、チェックシートIdを返す
     */
    @RemoteAction
    public static string showHDScreen(integer categoryNo, integer No, integer seqNo, string hantei, integer nendo, integer kai
                                    , string jiki, string jigyosyoId, string checkSheetId, string tanto, string rodosyaTRid) {
        try {
            JFK_JCR_1Controller JCR1 = new JFK_JCR_1Controller(nendo, kai, jiki, jigyosyoId, rodosyaTRid);

            if (checkSheetId.length() == 0) {
                // JCR_1シートの判定が'NG'の時、HD画面を表示する。（HD情報登録のため、事前にチェックシートレコードも作成しておく。）
                string recordId = JCR1.upsertJCR1(categoryNo, No, seqNo, tanto, JCR1, rodosyaTRid);

                // チェックシート一時保存処理
                JCR1.saveTemp();

                return recordId;
            } else {
                return checkSheetId;          
            }
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }
    
    /*
     * upsertJCR1
     * 引数 ：p_categoryNo : チェックシートのカテゴリNo.
     *      p_No        : チェックシートのNo.
     *      p_SEQNo     : チェックシートのSEQNo.
     *      JCR1        : showScreenで作成したJFK_JCJControllerのインスタンス
     *      rodosyaTRid : 労働者Id
     * 戻り値  ：  チェックシートId
     * 概要   ： チェックシート(JCR1)でNGが選択された行のチェックシート(JCR)レコードを作成し、チェックシートIdを返す
     */
    private string upsertJCR1(integer p_categoryNo, integer p_No, integer p_SEQNo, string tanto, JFK_JCR_1Controller JCR1, string rodosyaTRid) {
        try {   
            JFK_CheckSheetTR__c checkTR = new JFK_CheckSheetTR__c();

            list<JFK_CheckSheetTR__c> lstCheckTR = JFK_cmnSOQL.getCheckSheet_JCR4Update(rodosyaTRid, p_SEQNo);          
            if (lstCheckTR.size() == 0) {
                checkTR = JCR1.setCheckSheetValues(p_categoryNo, p_No, p_SeqNo);
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
     * 戻り値  ： なし
     * 概要   ： 募集、事業所、GS及びチェックシート（既に存在する場合のみ）情報を取得する。
     */
    private void init(string nendo, string kai, string jiki, string jigyosyoId, string rodosyaTRid) {
        try {
            // 募集情報
            bosyu = JFK_cmnSOQL.getBosyu_1Rec(integer.valueOf(nendo), integer.valueOf(kai), jiki);

            // 事業所TR情報 with GS
            jigyosyoTR = JFK_cmnSOQL.getJigyosyoTR_1Rec_withGS(integer.valueOf(nendo), integer.valueOf(kai), integer.valueOf(bosyu.NenMe__c), integer.valueOf(bosyu.KaiMe__c), jigyosyoid);

            // 労働者TR情報
            list<JFK_RodoSyaTR__c> lstRodosyaTR = new list<JFK_RodoSyaTR__c>();
            lstRodosyaTR = JFK_cmnSOQL.getRodosyaTR_withGS_1Rec(rodosyaTRid);

            if (lstRodosyaTR.size() == 0) return;

            // 労働者コードは必須項目のため、あり得ないはずだが、万一労働者コードがnullの時、画面上部の労働者コード欄が潰れてしまうため、nullの場合、空白を設定設定するロジックを追加。
            if (lstRodosyaTR[0].Rodosya__r.RodosyaCD__c == null) {
                rodosyaCD = ' ';
            } else {
                rodosyaCD = lstRodosyaTR[0].Rodosya__r.RodosyaCD__c;
            }

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
            rodosya = lstHojuRodosya[0];

            // 汎用マスタから'JCR1'のid取得
            lstcommonM_CheckSheet = JFK_cmnSOQL.getCommonM_1Rec(JFK_cmnConstant.COMMON_M_CHECK_SHEET, JFK_cmnConstant.COMMON_M_CHECK_SHEET_JCR_1st);

            // 初めて審査する場合と既に審査したした実績がある場合の処理振り分け(チェックシートレコード有無の確認)
            if (lstcheckSheetOriginal.size() == 0) {
                // 初回の場合は、テンプレート（カスタム設定）から画面を生成
                getCheckSheetTemplate();
            } else {
                // ２回目以降は、チェックシートレコードから画面を生成
                getCheckSheetTR();
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
     * 概要   ： カスタム設定(JFK_CheckSheetM_JCJ__c)からチェックシートの内容を読み込み、リストに保存しておく。
     */
    private void getCheckSheetTemplate() {
        try {
            // カスタム設定(JFK_CheckSheetM_JCR_1__c)から全ての情報を取得
            Map<string, JFK_CheckSheetM_JCR_1__c> mcs = JFK_CheckSheetM_JCR_1__c.getAll();
    
            // Map(カスタム設定(JFK_CheckSheetM_JCR_1__c))からValue項目のみををListに格納
            JFK_CheckSheetM_JCR_1__c[] chkSheets = mcs.values();

            // List(カスタム設定(JFK_CheckSheetM_JCR_1__c))を基にカテゴリNo.＋No.をキーとしたMapを作成
            for (JFK_CheckSheetM_JCR_1__c chkSheet : chkSheets) {
                mapCheckSheetTemplate.put(Integer.valueOf(chkSheet.CategoryNo__c) + '-' + Integer.valueOf(chkSheet.No__c), chkSheet);

                if (chkSheet.CategoryNo__c == 1) { itemNumberEachCategory[0]++; }   
                else if (chkSheet.CategoryNo__c == 2) { itemNumberEachCategory[1]++; }  
                else if (chkSheet.CategoryNo__c == 3) { itemNumberEachCategory[2]++; } 
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
            }
                
            integer seqNo = 1;
            for (integer i = 1; i < pageNumbers + 1; i++) {
                if (i == 1) {
                    for (integer j = 1; j < itemNumberEachCategory[0] + 1; j++) {
                        lstCheckSheetTR1.add(setCheckSheetValues(i, j, seqNo++));
                    }
                    if (lstCheckSheetTR1[5].Hantei_1st__c == 'OK') {
                        showTaisyogaiRodosya = true;
                    }
                } else if (i == 2) {
                    for (integer j = 1; j < itemNumberEachCategory[1] + 1; j++) {        
                        lstCheckSheetTR2.add(setCheckSheetValues(i, j, seqNo++));
                    }
                } else if (i == 3) {
                    for (integer j = 1; j < itemNumberEachCategory[2] + 1; j++) {        
                        lstCheckSheetTR3.add(setCheckSheetValues(i, j, seqNo++));
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
        JFK_CheckSheetM_JCR_1__c checkSheetTemplate = mapCheckSheetTemplate.get(string.valueOf(categoryNo) + '-' + string.valueOf(no));
        JFK_CheckSheetTR__c checkSheetTR = mapCheckSheetTR.get(string.valueOf(categoryNo) + '-' + string.valueOf(no));
    
        JFK_CheckSheetTR__c JCR1 = new JFK_CheckSheetTR__c ();
 
        try {
            JCR1.Name = JFK_cmnConstant.COMMON_M_CHECK_SHEET_JCR_1st + '_' + string.valueOf(dateTime.now().format());
            JCR1.CheckSheetName__c = lstcommonM_CheckSheet[0].id;
            JCR1.JigyosyoTR__c = jigyosyoTR.id;
            JCR1.RodosyaTR__c = rodosyaTR.id;
            JCR1.CategoryNo__c = categoryNo;
            JCR1.No__c = no;
            JCR1.SEQNo__c = seqNo;

            if (checkSheetTR == null) {
                string koyoKaishiBi = rodosyaTR.Rodosya__r.KoyoKeiyaku_KaishiBi__c == null ? '' : string.valueOf(rodosyaTR.Rodosya__r.KoyoKeiyaku_KaishiBi__c);
                string koyoSyuryoBi = rodosyaTR.Rodosya__r.KoyoKeiyaku_SyuryoBi__c == null ? '' : string.valueOf(rodosyaTR.Rodosya__r.KoyoKeiyaku_SyuryoBi__c);

                // 初回審査のため、チェックシートレコードが存在しない時
                JCR1.NoForShow__c = checkSheetTemplate.NoForShow__c;
                JCR1.CheckKomoku__c = checkSheetTemplate.CheckKomoku__c;
                if (categoryNo == 1) {
                    if (no == 1) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, string.valueOf(rodosyaTR.Rodosya__r.Name));
                    } else if (no == 2) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, string.valueOf(rodosyaTR.Rodosya__r.KoyoKBN__r.Name));
                    } else if (no == 3) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, string.valueOf(rodosyaTR.Rodosya__r.KoyoKeitai__r.Name));
                    } else if (no == 4) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 5) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 6) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, string.valueOf(jigyosyoTR.Nendo_Kai_Jigyosyo__r.ShikyuKetteiDate__c));
                    }
                } else if (categoryNo == 2) {
                    if (no == 1) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 2) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }
                } else if (categoryNo == 3) {
                    if (no == 1) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 2) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 3) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 4) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 5) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 6) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 7) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 8) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 9) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    } else if (no == 10) {
                        JCR1.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }
                } else {
                    JCR1.CheckNaiyo__c = checkSheetTemplate.CheckNaiyo__c;
                }
                
                JCR1.Zokusei__c = checkSheetTemplate.Zokusei__c;
                JCR1.PasonaHoseiKa__c = checkSheetTemplate.PasonaHoseiKa__c;
                JCR1.ActionAfterJudgement__c = checkSheetTemplate.ActionAfterJudgement__c;
                JCR1.ShowHanteiCheckBox__c = checkSheetTemplate.ShowHanteiCheckBox__c;
                JCR1.ShowTextBox__c = checkSheetTemplate.ShowTextBox__c;
            } else {
                // 既にチェックシートレコードが存在する時
                JCR1 = JFK_cmnFunction.setValue2CheckSheet(checkSheetTR, categoryNo, no, seqNo);
                JCR1.Biko__c = rodosyaTR.Biko__c;

                if (rodosya.KoyoKeitai_HenkoBi__c != null) {
                    isKoyoKeitaiHenko = true;
                }

                if (rodosya.RisyokuBi__c != null) {
                    isRisyoku = true;
                }
            }
            
            return JCR1;
            
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }

    /*
     * AssembleCheckNaiyo
     * 引数   ：JFK_CheckSheetM_JCR_1__c
     *       checkValue
     * 戻り値  ： チェック内容
     * 概要   ： チェック内容を組み立てる。
     */
    private string AssembleCheckNaiyo(JFK_CheckSheetM_JCR_1__c checkSheetTemplate, string checkValue) {
        return (checkSheetTemplate.CheckNaiyo__c == null ? '' : checkSheetTemplate.CheckNaiyo__c)
                + (checkValue == '' ? '' : '　「'  )
                + checkValue
                + (checkValue == '' ? '' : '」　')
                + (checkSheetTemplate.CheckNaiyo_After__c == null ? '' : checkSheetTemplate.CheckNaiyo_After__c);
    }
    
    /*
     * checkComplete
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ： 全てのチェック項目にOK/NGが入力されたか確認
     */
    public boolean checkComplete() {
        try {
            if (showTaisyogaiRodosya) {
                if (!JFK_cmnFunction.chkComplete(lstCheckSheetTR1, tanto)) return false;
            } else {
                if (!JFK_cmnFunction.chkComplete(lstCheckSheetTR1, tanto)) return false;
                if (!JFK_cmnFunction.chkComplete(lstCheckSheetTR2, tanto)) return false;
                
                if (tanto == '2') {
                    if (!JFK_cmnFunction.chkComplete(lstCheckSheetTR3, tanto)) return false;
                }
            }
            
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
     * saveTaisyogaiRodosya
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 対象外労働者の時の保存処理
     */
    public pageReference saveTaisyogaiRodosya() {
        showTaisyogaiRodosya = true;

        // 保存処理
        save();

        showTaisyogaiRodosya = false;

        return null;
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

        try {
            // エラーチェック
            showTaisyogaiRodosya = showTaisyogaiRodosya == null ? false : showTaisyogaiRodosya;
            if (!showTaisyogaiRodosya) {
                if (checkError()) {
                    return null;
                }
            }
                        
            // 完了チェック
            isComplete = checkComplete();
            if (!isComplete && !isSaveTemp) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,System.Label.JFK_Error006));
                return null;
            }
            
            list<JFK_CheckSheetTR__c> checkSheetBeforeUpsert = JFK_cmnSOQL.getCheckSheet_JCR4Update(rodosyaTR.id);
            
            sp = Database.setSavepoint();

            // チェックシート更新
            JFK_cmnFunction.upsertCheckSheet(itemNumberEachCategory[0], checkSheetBeforeUpsert, lstCheckSheetTR1, lsr);
            lsr.clear();
            JFK_cmnFunction.upsertCheckSheet(itemNumberEachCategory[1], checkSheetBeforeUpsert, lstCheckSheetTR2, lsr);
            lsr.clear();
            JFK_cmnFunction.upsertCheckSheet(itemNumberEachCategory[2], checkSheetBeforeUpsert, lstCheckSheetTR3, lsr);

            // GS更新
            JFK_cmnFunction.updateGS(jigyosyoTR, rodosyaTR, currentURL, tanto, isSuccess4GS, isComplete, isSaveTemp, isPassBack
                                   , lsr, lstGs4Upsert);
			
            if (!isSuccess4GS) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.JFK_Error007));
                Database.rollback(sp);
                return null;
            }

			// Contact更新
            Contact rodosya = JFK_cmnSOQL.getRodosya4Update(rodosyaTR.Rodosya__r.Id);

            isKoyoKeitaiHenko = isKoyoKeitaiHenko == null ? false : isKoyoKeitaiHenko;
            if (isKoyoKeitaiHenko) {
                rodosya.KoyoKeitai_HenkoBi__c = rodosyaInfo.KoyoKeitai_HenkoBi__c;
            } else {
                rodosya.KoyoKeitai_HenkoBi__c = null;
            } 
                    
            isRisyoku = isRisyoku == null ? false : isRisyoku;
            if (isRisyoku) {
                rodosya.RisyokuBi__c = rodosyaInfo.RisyokuBi__c;
                rodosya.RisyokuRiyu__c = rodosyaInfo.RisyokuRiyu__c; 
            } else {
                rodosya.RisyokuBi__c = null;
                rodosya.RisyokuRiyu__c = null; 
            } 
              
            sr = database.update(rodosya);

            // 労働者TR（支給時期）更新
            list<JFK_RodosyaTR__c> lstRodosyaTR = JFK_cmnSOQL.getRodosyaTR4Update(rodosyaTR.id);
            if (lstRodosyaTR.size() > 0) {
                lstRodosyaTR[0].Biko__c = rodosyaTR.Biko__c;
                
                lsr.clear();
                lsr = Database.update(lstRodosyaTR); 
            }
            
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
     * checkError
     * 引数   ： なし
     * 戻り値  ： boolean
     * 概要   ： エラーチェック処理
     */
    public boolean checkError() {
        try {
            return JFK_cmnFunction.checkError_JCR(isKoyoKeitaiHenko, isRisyoku, rodosya, bosyu, jigyosyoTR, koyoKeitaiSearch, isMukyuKekkin, rodosyaTR);
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return true;
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
     * tantosya
     * 引数   ：
     * 戻り値  ： 担当者名（１次、２次）
     * 概要   ： 担当者名（１次、２次）取得
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
    public list<SelectOption> OkNg {
        get {
            return JFK_cmnFunction.getOkNg();
        }        
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
     * checkRisyoku
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ： 離職者の時True
     */
    public void checkRisyoku() {
        string prmRisyoku = System.currentPageReference().getParameters().get('param');

        if (boolean.valueOf(prmRisyoku)) {
            isRisyoku = true;
        } else {
            isRisyoku = false;
        }
    }

    /*
     * checkKoyokeitaiHenko
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ： 雇用形態変更の時True
     */
    public void checkKoyokeitaiHenko() {
        string prmKoyokeitaiHenko = System.currentPageReference().getParameters().get('param');
        if (boolean.valueOf(prmKoyokeitaiHenko)) { 
            list<SelectOption> lstKoyokeitai = koyoKeitaisSearch;
            for (id koyoKeitaiId : lstKoyokeitaiId) {
            	//雇用形態が変更されるのだから、変更後の雇用形態が設定される。
                if (rodosya.KoyoKeitai__c != koyoKeitaiId) {    
                    koyokeitaiSearch = koyoKeitaiId;
                    break;
                }
            }

            isKoyoKeitaiHenko = true;

        } else {
            isKoyoKeitaiHenko = false;
        }
    }

    /*
     * checkMukyuKekkin
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ： 無給欠勤者の時True
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
     * 概要   ： 離職者の時、isketsuBanがTrue
     */
    public void checkRisyokuBi() {
        date risyokuBi = rodosyaInfo.RisyokuBi__c;

        if (risyokuBi < jigyosyoTR.Nendo_Kai_Jigyosyo__r.ShikyuKetteiDate__c) {
            isKetsuBan = true;
        } else {
            isKetsuBan = false;
        }       
    }

    /*
     * checkTaisyogaiRodosya
     * 引数   ： なし
     * 戻り値	： なし
     * 概要   ：
     */
    public void checkTaisyogaiRodosya() {
        string prmTaisyogaiRodosya = System.currentPageReference().getParameters().get('param');
        if (boolean.valueOf(prmTaisyogaiRodosya)) {
            showTaisyogaiRodosya = false;
        } else {
            showTaisyogaiRodosya = true;
        }
    }

    /*
     * koyoKeitaisSearch
     * 引数   ： なし
     * 戻り値	： なし
     * 概要   ：
     */
    public list<SelectOption> koyoKeitaisSearch {
        get {
            list<JFK_CommonM__c> lstCommonM = JFK_cmnSOQL.getCommonM(JFK_cmnConstant.KOYO_KEITAI);
            list<SelectOption> options = new List<SelectOption>();
            
            options.add(new SelectOption('', ''));
            for (JFK_CommonM__c item : lstCommonM) {
                if (item.Name == 'フルタイム') {
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
        public wrapper(JFK_CheckSheetTR__c p_chkSheetTR) {
            CheckSheet = p_chkSheetTR;
        }
    }
}