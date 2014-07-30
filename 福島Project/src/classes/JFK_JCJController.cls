/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      	: JFK_JCJController
 *  概要        	: 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/09/11 Create
 ******************************************************************************/
public class JFK_JCJController {
    // urlパラメータ from JFK_Menu_JCJページ
    public  string tanto { get; set; }
    private string nendo;
    private string kai;
    private string jiki;
    private string jigyosyoid;
    
    private string currentURL;

    /* 画面表示情報用Check Sheet Map */
    // 新規作成用（カスタム設定から情報取得）
    private map<string, JFK_CheckSheetM_JCJ__c> mapCheckSheetTemplate = new map<string, JFK_CheckSheetM_JCJ__c>();
    // 既存用（審査シートレコードから情報取得）
    private map<string, JFK_CheckSheetTR__c>    mapCheckSheetTR       = new map<string, JFK_CheckSheetTR__c>();     

    // Check Sheetトランザクション List (Original:前回更新分)
    private list<JFK_CheckSheetTR__c>           lstcheckSheetOriginal = new list<JFK_CheckSheetTR__c>();
    
    // Check Sheetトランザクション List（今回更新分）
    private list<JFK_CheckSheetTR__c>           lstCheckSheetTR1    = new list<JFK_CheckSheetTR__c>();
    private list<JFK_CheckSheetTR__c>           lstCheckSheetTR2    = new list<JFK_CheckSheetTR__c>();
    private list<JFK_CheckSheetTR__c>           lstCheckSheetTR3    = new list<JFK_CheckSheetTR__c>();

    // Total Page数
    private final integer pageNumbers = 3;
    // カテゴリ別アイテム数
    private integer[] itemNumberEachCategory = new integer[]{0, 0, 0};
    //現在のセクションページ
    private integer currentSectionPage = 1;  
    // 一時保存フラグ
    private boolean isSaveTemp = false;
    // 差し戻しフラグ
    private boolean isPassback = false;

    // 審査担当者ID
    private string[] tantosyaID     = new string[2];
    private string[] tantosyaName   = new string[2];

    // 1次担当者と2次担当者の書類審査の状況Status
    private string[] status         = new string[2];
    // 各審査完了日
    private date[] kanryoDate       = new date[2];

    // 書類審査の状況Status(From GS)
    public string               totalStatus             { get; set; }
    // 書類審査完了日(From GS)
    public date                 shoruiShinsaKanryoDate  { get; set; }
    
    // 募集情報（画面表示用）
    public JFK_Bosyu__c         bosyu                   { get; set; }
    // 事業所TR情報（画面表示用）
    public JFK_JigyosyoTR__c    jigyosyoTR              { get; set; }
    
    /* 労働者一覧情報 */
    private string jigyosyoTRId;

    public integer              totalRodosyaSu          { get; set; }
    public integer              inProgressRodosyaSu     { get; set; }
    public integer              completedRodosyaSu      { get; set; }
    private ApexPages.StandardSetController setController { get; set; }

    private list<JFK_RodosyaTR__c>  lstRodosyaTR        = new list<JFK_RodosyaTR__c>();
    private list<JFK_RodosyaTR__c>  lstRodosyaTR4Screen = new list<JFK_RodosyaTR__c>();

    private list<wrapper4rodosya>   lstWrapper          = new list<wrapper4rodosya>();

    /* 汎用マスタ List */
    private list<JFK_CommonM__c>    lstcommonM_CheckSheet; 

    /* HD情報　*/
    public boolean                  isExistHD           { get; set; }
    private list<JFK_CommonTR__c>   lstHD               = new list<JFK_CommonTR__c>();
    private JFK_CommonTR__c         hdRecord            = new JFK_CommonTR__c();
    
    /* HM情報　*/
    public boolean                  isExistHM           { get; set; }
    private list<JFK_CommonTR__c>   lstHM               = new list<JFK_CommonTR__c>();
        
    /* MD情報 */
    public boolean                  isExistMD           { get; set; }

    /*
     * Constructor
     */
    public JFK_JCJController() {
        // 現在のURL取得。修正申請直前だと余計なViewStateが付いてしまうため。
        currentURL = ApexPages.currentPage().getHeaders().get('Host') + ApexPages.currentPage().getUrl();

        // urlパラメータ(From JFK_Menu_JCJページ)を取得
        tanto           = Apexpages.currentPage().getParameters().get('tanto');
        nendo           = Apexpages.currentPage().getParameters().get('nendo');
        kai             = Apexpages.currentPage().getParameters().get('kai');
        jiki            = Apexpages.currentPage().getParameters().get('jiki');
        jigyosyoid      = Apexpages.currentPage().getParameters().get('jigyosyoid');
        jigyosyoTRId    = Apexpages.currentPage().getParameters().get('jigyosyoTRid');

        /* 初期処理 */
        if (nendo != null && kai != null && jiki != null && jigyosyoid != null) {
            // 初期処理
            init(nendo, kai, jiki, jigyosyoid);

            /* 労働者一覧関連 */
            // 該当の労働者情報取得（JCJ画面の最下部に労働者の一覧(JCR用)を表示する。（表示対象労働者：就業者、離職が支給開始日以降の労働者、欠番以外）
            lstRodosyaTR =  JFK_cmnSOQL.getRodosyaTR_withGS(jigyosyoTRId);

            if (lstRodosyaTR.size() > 0) {
                // Extract Maching Records
                setController = new ApexPages.StandardSetController(lstRodosyaTR);
        
                setController.setPageSize(10000); //一度に10000件まで表示（事実上、常に該当事業所の全労働者が表示されるとこになる。）
                lstrodosyaTR4Screen = (list<JFK_RodosyaTR__c>)setController.getRecords();
            }
            
            /* 該当のMD存在確認 */
            if (JFK_cmnSOQL.getCommonTR_Cnt_Jisseki_YearTime(JFK_cmnConstant.COMMON_MANAGE_INFO_MD, jigyosyoTR.Nendo_Kai_Jigyosyo__r.Id) > 0) {
                isExistMD = true;
            } else {
                isExistMD = false;
            }

            /* 該当のHD存在確認 */
            if (JFK_cmnSOQL.getCommonTR_Cnt_Jisseki_SikyuJiki(JFK_cmnConstant.COMMON_MANAGE_INFO_HD, jigyosyoTR.Id) > 0) {
                isExistHD = true;
            } else {
                isExistHD = false;
            }

            /* 該当のHM存在確認 */
            if (JFK_cmnSOQL.getCommonTR_Cnt_Jisseki_SikyuJiki(JFK_cmnConstant.COMMON_MANAGE_INFO_HM, jigyosyoTR.Id) > 0) {
                isExistHM = true;
            } else {
                isExistHM = false;
            }
        }
    }

    /*
     * Constructor2
     */
    public JFK_JCJController(integer p_nendo, integer p_kai, string p_jiki, string p_jigyosyoId) {
        // 初期処理
        init(string.valueOf(p_nendo), string.valueOf(p_kai), p_jiki, p_jigyosyoid);
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
     * 戻り値  ： チェックシートId
     * 概要   ： チェックシート(JCJ)でNGが選択され、かつ、まだチェックシート(JCJ)レコードが作成されていない時、JCJレコードを（チェックシート内の内容に応じた件数分）作成し、チェックシートIdを返す
     */
    @RemoteAction
    public static string showHDScreen(integer categoryNo, integer No, integer seqNo, string hantei, integer nendo, integer kai
                                    , string jiki, string jigyosyoId, string checkSheetId, string tanto) {
        try {
            JFK_JCJController jcj = new JFK_JCJController(nendo, kai, jiki, jigyosyoId);

            if (checkSheetId.length() == 0) {
                // JCJシートの判定が'NG'の時、HD画面を表示する。（HD情報とチェックシートIdを紐付けのため、事前にチェックシートレコード（チェックシート内の内容に応じた件数分）も作成しておく。）
                string recordId = jcj.upsertJCJ(categoryNo, No, seqNo, jcj);
                // チェックシート一時保存処理
                jcj.saveTemp();
    
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
     * upsertJCJ
     * 引数 ：p_categoryNo : チェックシートのカテゴリNo.
     *      p_No        : チェックシートのNo.
     *      p_SEQNo     : チェックシートのSEQNo.
     *      jcj         : showScreenで作成したJFK_JCJControllerのインスタンス
     * 戻り値  ：  チェックシートId
     * 概要   ： チェックシート(JCJ)でNGが選択された行のチェックシート(JCJ)レコードを作成し、チェックシートIdを返す
     */
    private string upsertJCJ(integer p_categoryNo, integer p_No, integer p_SEQNo, JFK_JCJController jcj) {
        try {
            JFK_CheckSheetTR__c checkTR = jcj.setCheckSheetValues(p_categoryNo, p_No, p_SeqNo);

            Database.saveResult sr = Database.insert(checkTR);

            return sr.getId();
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
    private void init(string nendo, string kai, string jiki, string jigyosyoId) {
        try {
            // 募集情報 
            bosyu = JFK_cmnSOQL.getBosyu_1Rec(integer.valueOf(nendo), integer.valueOf(kai), jiki);

            // 事業所TR情報 with GS
            jigyosyoTR = JFK_cmnSOQL.getJigyosyoTR_1Rec_withGS(integer.valueOf(nendo), integer.valueOf(kai), integer.valueOf(bosyu.NenMe__c), integer.valueOf(bosyu.KaiMe__c), jigyosyoid);

            // GSから担当者及び完了有無情報 取得           
            for (JFK_CommonTR__c gs : jigyosyoTR.JigyosyoTR_Time__r) {
                tantosyaID[0]           = gs.GS_FirstTantosya__c;
                tantosyaID[1]           = gs.GS_SecondTantosya__c;
                tantosyaName[0]         = gs.GS_FirstTantosya__r.Name;
                tantosyaName[1]         = gs.GS_SecondTantosya__r.Name;
                kanryoDate[0]           = gs.GS_JissekiSyoruiShinsa_KanryoBi_1st__c;
                kanryoDate[1]           = gs.GS_JissekiSyoruiShinsa_KanryoBi_2nd__c;
                status[0]               = gs.GS_FirstTantosya_Status__c;
                status[1]               = gs.GS_SecondTantosya_Status__c;
                totalStatus             = gs.GS_Status__c;
                shoruiShinsaKanryoDate  = gs.GS_JissekiSyoruiShinsa_KanryoBi__c;
            }

            // 汎用マスタから'JCJ'のid取得
            lstcommonM_CheckSheet = JFK_cmnSOQL.getCommonM_1Rec(JFK_cmnConstant.COMMON_M_CHECK_SHEET, JFK_cmnConstant.COMMON_M_CHECK_SHEET_JCJ);

            // 事業所チェックシート(JCJ)取得（既に作成済レコードがある場合に抽出される。）
            lstcheckSheetOriginal = JFK_cmnSOQL.getCheckSheetTR(jigyosyoTR.id);

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
            // カスタム設定(JFK_CheckSheetM_JCJ__c)から全ての情報を取得
            Map<string, JFK_CheckSheetM_JCJ__c> mcs = JFK_CheckSheetM_JCJ__c.getAll();
    
            // Map(カスタム設定(JFK_CheckSheetM_JCJ__c))からValue項目のみををListに格納
            JFK_CheckSheetM_JCJ__c[] chkSheets = mcs.values();

            for (JFK_CheckSheetM_JCJ__c chkSheet : chkSheets) {
                // List(カスタム設定(JFK_CheckSheetM_JCJ__c))を基にカテゴリNo.＋No.をキーとしたMapを作成
                mapCheckSheetTemplate.put(Integer.valueOf(chkSheet.CategoryNo__c) + '-' + Integer.valueOf(chkSheet.No__c), chkSheet);

                // カテゴリNo.毎のアイテム数をカウント
                if (chkSheet.CategoryNo__c == 1) { itemNumberEachCategory[0]++;  
                } else if (chkSheet.CategoryNo__c == 2) { itemNumberEachCategory[1]++; 
                } else if (chkSheet.CategoryNo__c == 3) { itemNumberEachCategory[2]++; 
                }
            }
                
            // カテゴリNo.別のチェックシートListを作成
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
                    
                    // カテゴリNo.毎のアイテム数をカウント
                    if (chkSheet.CategoryNo__c == 1) { itemNumberEachCategory[0]++; 
                    } else if (chkSheet.CategoryNo__c == 2) { itemNumberEachCategory[1]++; 
                    } else if (chkSheet.CategoryNo__c == 3) { itemNumberEachCategory[2]++; 
                    }
                }
        
                // カテゴリNo.別のチェックシートListを作成
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
     * setCheckSheetValues
     * 引数 ： categoryNo  : チェックシートのカテゴリNo.
     *       No         : チェックシートのNo.
     *       SEQNo      : チェックシートのSEQNo.
     * 戻り値  ： JFK_CheckSheetTR__c
     * 概要   ： チェックシートのテンプレートまたはトランザクションを基にチェックシートの各行（各レコード）の文言等を設定する。
     */
    private JFK_CheckSheetTR__c setCheckSheetValues(integer categoryNo, integer no, integer seqNo) {
        JFK_CheckSheetM_JCJ__c  checkSheetTemplate  = mapCheckSheetTemplate.get(string.valueOf(categoryNo) + '-' + string.valueOf(no));
        JFK_CheckSheetTR__c     checkSheetTR        = mapCheckSheetTR.get(string.valueOf(categoryNo) + '-' + string.valueOf(no));
    
        JFK_CheckSheetTR__c JCJ = new JFK_CheckSheetTR__c();
 
        try {
            JCJ.Name = JFK_cmnConstant.COMMON_M_CHECK_SHEET_JCJ + '_' + string.valueOf(dateTime.now().format());
            JCJ.CheckSheetName__c = lstcommonM_CheckSheet[0].id;
            JCJ.JigyosyoTR__c = jigyosyoTR.id;
            JCJ.CategoryNo__c = categoryNo;
            JCJ.No__c = no;
            JCJ.SEQNo__c = seqNo;

            if (checkSheetTR == null) {
                // 初回審査のため、チェックシートレコードが存在しない時
                JCJ.NoForShow__c = checkSheetTemplate.NoForShow__c;
                JCJ.CheckKomoku__c = checkSheetTemplate.CheckKomoku__c;
                if (categoryNo == 1) {
                    if (no == 1) {
                        JCJ.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, JFK_cmnFunction.assembleShikyuJiki(integer.valueOf(bosyu.NenMe__c), integer.valueOf(bosyu.KaiMe__c)));
                    } else if (no == 2) {
                        JCJ.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, string.valueOf(bosyu.ShikyuShimeBi__c.adddays(1)));
                    } else if (no == 3) {
                        JCJ.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.Address_Taisyo__c);
                    } else if (no == 4) {
                        JCJ.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.Name);
                    } else if (no == 5) {
                        JCJ.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.DaihyousyaYakusyokuShimei__c);
                    } else if (no == 6) {
                        JCJ.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }
                } else if (categoryNo == 2) {
                    if (no == 1) {
                        JCJ.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.Name);
                    } else if (no == 2) {
                        JCJ.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, jigyosyoTR.Nendo_Kai_Jigyosyo__r.JigyoKBN__r.Name);
                    } else if (no == 3) {
                        JCJ.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }
                } else if (categoryNo == 3) {
                    if (no == 1) {
                        JCJ.CheckNaiyo__c = AssembleCheckNaiyo(checkSheetTemplate, '');
                    }
                } else {
                    JCJ.CheckNaiyo__c = checkSheetTemplate.CheckNaiyo__c;
                }
                
                JCJ.Zokusei__c = checkSheetTemplate.Zokusei__c;
                JCJ.PasonaHoseiKa__c = checkSheetTemplate.PasonaHoseiKa__c;
            } else {
                // 既にチェックシートレコードが存在する時
                JCJ.Id = checkSheetTR.Id;
                JCJ.NoForShow__c = checkSheetTR.NoForShow__c;
                JCJ.CheckKomoku__c = checkSheetTR.CheckKomoku__c;
                JCJ.CheckNaiyo__c = checkSheetTR.CheckNaiyo__c;
                JCJ.Zokusei__c = checkSheetTR.Zokusei__c;
                JCJ.PasonaHoseiKa__c = checkSheetTR.PasonaHoseiKa__c;

                JCJ.P_HoseiZumi_1st__c = checkSheetTR.P_HoseiZumi_1st__c;
                JCJ.P_HoseiZumi_2nd__c = checkSheetTR.P_HoseiZumi_2nd__c;
                JCJ.Ninzu__c = checkSheetTR.Ninzu__c;
                JCJ.Hantei_1st__c = checkSheetTR.Hantei_1st__c;
                JCJ.Hantei_2nd__c = checkSheetTR.Hantei_2nd__c;
                JCJ.Biko__c = checkSheetTR.Biko__c;
                JCJ.HoseiKanryoBi__c = checkSheetTR.HoseiKanryoBi__c;
                
                JCJ.Biko__c = jigyosyoTR.Biko__c;
            }
            
            return JCJ;
            
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }

    /*
     * AssembleCheckNaiyo
     * 引数   ： JCJのカスタム設定
     *        動的に設定する値（氏名等）
     * 戻り値  ： チェック内容の文言
     * 概要   ： チェック内容の文言作成
     */
    private string AssembleCheckNaiyo(JFK_CheckSheetM_JCJ__c checkSheetTemplate, string checkValue) {
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
    private boolean checkComplete() {
        try {
            // No.1
            for (JFK_CheckSheetTR__c tr : lstCheckSheetTR1) {
                if (tanto == '1') {
                    if (tr.Hantei_1st__c == null) {
                        return false;
                    }
                }
                else if (tanto == '2') {
                    if (tr.Hantei_2nd__c == null) {
                        return false;
                    }
                }
                else {
                    return false;
                }
            }
            
            // No.2
            for (JFK_CheckSheetTR__c tr : lstCheckSheetTR2) {
                if (tanto == '1') {
                    if (tr.Hantei_1st__c == null) {
                        return false;
                    }
                }
                else if (tanto == '2') {
                    if (tr.Hantei_2nd__c == null) {
                        return false;
                    }
                }
                else {
                    return false;
                }
            }
            
            // No.3
            for (JFK_CheckSheetTR__c tr : lstCheckSheetTR3) {
                if (tanto == '1') {
                    if (tr.HoseiKanryoBi__c == null) {
                        return false;
                    }
                }
                else if (tanto == '2') {
                    if (tr.Hantei_2nd__c == null) {
                        return false;
                    }
                }
                else {
                    return false;
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
     * 概要   ： 一時保存処理
     */
    public pageReference saveTemp() {
        isSaveTemp = true;
        
        // 保存処理
        save();

        isSaveTemp = false;

        return null;
    }

    /*
     * save
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 保存処理
     */
    public pageReference save() {
        boolean isComplete = false;
        Savepoint sp;
        list<Database.saveResult> lsr = new list<Database.saveResult>();
        try {
            if (checkError()) return null;

            // 完了チェック
            isComplete = checkComplete();
            if (!isComplete && !isSaveTemp) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,System.Label.JFK_Error006));
                return null;
            }
            
            list<JFK_CheckSheetTR__c> checkSheetBeforeUpsert = JFK_cmnSOQL.getCheckSheet4Update(jigyosyoTR.id);

            sp = Database.setSavepoint();

            // チェックシートの保存
            upsertCheckSheet(itemNumberEachCategory[0], checkSheetBeforeUpsert, lstCheckSheetTR1, lsr);
            lsr.clear();
            upsertCheckSheet(itemNumberEachCategory[1], checkSheetBeforeUpsert, lstCheckSheetTR2, lsr);
            lsr.clear();
            upsertCheckSheet(itemNumberEachCategory[2], checkSheetBeforeUpsert, lstCheckSheetTR3, lsr);

            list<JFK_CommonTR__c> lstGs4Upsert = new list<JFK_CommonTR__c>();
            boolean isSuccess4GS = true;
            
            list<JFK_CommonTR__c> lstGs = JFK_cmnSOQL.getCommonTR_GS4Update(jigyosyoTR.id);

            // GSの更新
            if (lstGs.size() == 0) {
                // 対応するGSレコード取得（JCJページを使用するタイミングでは、既にレコードができているはずなので、念のための処理）
                JFK_CommonTR__c gs = new JFK_CommonTR__c(); 

                gs.RecordTypeId = JFK_cmdUtilities.getRecordTypeId(JFK_cmnConstant.RECORD_TYPE_GS_JISSEKI);
                gs.RecordKBN__c = JFK_cmnConstant.COMMON_MANAGE_INFO_GS;
                gs.Name = JFK_cmnConstant.COMMON_MANAGE_INFO_GS + '_' + string.valueOf(datetime.now().format());
                gs.JijyosyoTR_ShikyuJiki__c = jigyosyoTR.id;
                    
                // GSに情報設定
                if (tanto == '1') {
                    gs.GS_CheckSheetURL1__c = currentURL;
                } else {
                    gs.GS_CheckSheetURL2__c = currentURL;
                } 
                isSuccess4GS = JFK_cmnFunction.setValues2GS(gs, isComplete, isSaveTemp, tanto, isPassBack);
system.debug('gs : ' + gs);
                lstGs4Upsert.add(gs);

                // GSのName項目のみ再作成
                string recId = lsr[0].getId();
                list<JFK_CommonTR__c> lstCommonTR = JFK_cmnSOQL.getCommonTR_1Rec(recId);
    
                if (lstCommonTR.size() > 0) {
                    lstCommonTR[0].Name = JFK_cmnConstant.COMMON_MANAGE_INFO_GS + '_' 
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuNendo__c) + '.'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuKai__c) + '_'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Area_Kubun__c) + '.'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.SeiriNO__c) + '_'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.NenMe__c) + '-'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.KaiMe__c) + '('
                                        + lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Account__r.Name + ')';
    
                    //Nameフィールド作成
		            lsr.clear();
                    lsr = Database.update(lstCommonTR);
                }
            } else { 
                // GSに情報設定
                if (tanto == '1') {
                    lstGs[0].GS_CheckSheetURL1__c = currentURL;
                } else {
                    lstGs[0].GS_CheckSheetURL2__c = currentURL;
                } 

                isSuccess4GS = JFK_cmnFunction.setValues2GS(lstGs[0], isComplete, isSaveTemp, tanto, isPassBack);
	            if (!isSuccess4GS) {
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.JFK_Error007));
    	            Database.rollback(sp);
        			return null;
        	    }

	            lsr.clear();
                lsr = Database.update(lstGs);
            }
            
	        // Account更新
	        list<Account> act = JFK_cmnSOQL.getAccount4Update(jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.id);
	        if (act != null || act.size() > 0) {
	            act[0].HoseiShido_Aitesaki_Busyo__c = jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.HoseiShido_Aitesaki_Busyo__c;
	            act[0].HoseiShido_Aitesaki_TantosyaMei__c = jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.HoseiShido_Aitesaki_TantosyaMei__c;
	            act[0].HoseiShido_Aitesaki_Renrakusaki__c = jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.HoseiShido_Aitesaki_Renrakusaki__c;
	            act[0].HoseiShido_Aitesaki_IninjoAri__c = jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.HoseiShido_Aitesaki_IninjoAri__c;
	            act[0].HoseiShido_Aitesaki_Jimusyo_TantosyaMei__c = jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.HoseiShido_Aitesaki_Jimusyo_TantosyaMei__c;
	            act[0].HoseiShido_Aitesaki_Busyo__c = jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.HoseiShido_Aitesaki_Busyo__c;
	            act[0].HoseiShido_Aitesaki_Renrakusaki2__c = jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.HoseiShido_Aitesaki_Renrakusaki2__c;
	    
	            lsr.clear();
	            lsr = Database.update(act); 
	        }

	        // 事業所TR（支給時期）更新
	        list<JFK_JigyosyoTR__c> lstJigyosyoTR = JFK_cmnSOQL.getJigyosyoTR4Update(jigyosyoTR.id);
	        if (lstJigyosyoTR.size() > 0) {
	            lstJigyosyoTR[0].Biko__c = jigyosyoTR.Biko__c;
	            
	            lsr.clear();
	            lsr = Database.update(lstJigyosyoTR); 
	        }

            if (isPassback) {
                // 差し戻し
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.JFK_Info004));
            } else {
                // 更新成功
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.JFK_Info001));
            }

            return null;

         } catch (DmlException e) {
            if (!JFK_cmdUtilities.chkSaveResult(lsr)) {
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.JFK_Error007));
            }
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
            boolean isError = false;

            return isError;

         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }
      
    /*
     * upsertCheckSheet
     * 引数   ： itemNumbersOfPage     : JCJのセクション数
     *       checkSheetBeforeUpsert : 更新前のチェックシート内容
     *       lstCheckSheetTR        : 更新後のチェックシート内容
     *       Database.saveResult[]
     * 戻り値  ： なし  
     * 概要   ： チェックシート更新処理
     */
      public void upsertCheckSheet(integer itemNumbersOfPage, list<JFK_CheckSheetTR__c> checkSheetBeforeUpsert
      								, list<JFK_CheckSheetTR__c> lstCheckSheetTR, Database.saveResult[] lsr) {
        list<JFK_CheckSheetTR__c> checkSheetTR_insert = new list<JFK_CheckSheetTR__c>();
        list<JFK_CheckSheetTR__c> checkSheetTR_update = new list<JFK_CheckSheetTR__c>();
        integer insertCnt = 0;
        integer updateCnt = 0;
        boolean isExists = false;

        for (integer i = 0; i < itemNumbersOfPage; i++) {
            isExists = false;
            for (JFK_CheckSheetTR__c c : checkSheetBeforeUpsert) { 
                if (lstCheckSheetTR[i].SEQNo__c == c.SEQNo__c) {
                    lstCheckSheetTR[i].id = c.id;
                    checkSheetTR_update.add(lstCheckSheetTR[i]);
                    updateCnt++;
                    isExists = true;
                }
            }
            if (!isExists) {
                checkSheetTR_insert.add(lstCheckSheetTR[i]);
                insertCnt++;
            }
        }
            
        // Insert処理
        if (insertCnt > 0) {
			lsr.clear();
            lsr = Database.insert(checkSheetTR_insert);
        }
            
        // Update処理
        if (updateCnt > 0) {
			lsr.clear();
            lsr = Database.update(checkSheetTR_update);
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
    
    public void dummy() {}
    
   /*
     * tantosya
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
     * tantoTimes
     * 引数   ：
     * 戻り値  ： '1' : １次担当者　　'2'　:　２次担当者
     * 概要   ：
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
     * areaKBN
     * 引数   ：
     * 戻り値  ： エリア区分
     * 概要   ： エリア区分取得
     */
    public string areaKBN {
        get {
            if (jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c == null) {
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
     * 概要   ： エリア名取得
     */
    public string areaName {
        get {
            if (jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c == null) {
                return '';
            } else {
                return jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c.mid(2, jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c.length() - 2);
            }
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
                if (render1stPart) {
                    return false;
                } else {
                    return true;
                }
            } else {
                if (render2ndPart) {
                    return false;
                } else {
                    return true;
                }
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
            if (tanto == '1') {
                if (status[0] == JFK_cmnConstant.OPERATION_STATUS_SASHIMODOSHI) {
                    return true;
                } else {
                    return chkRender(0);
                }
            } else {
                return false;
            }   
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
            if (tanto =='1') {
                return false;
            } else {
                return chkRender(1);
            }
        }
    }

    /*
     * chkRender
     * 引数   ： i (１次担当者：0,  ２次担当者：1)
     * 戻り値  ： 完了」「保存」等のボタン使用可否
     * 概要   ： 完了」「保存」等のボタン使用可否制御
     */
    private boolean chkRender(integer i) {
        // 1次担当者と2次担当者
        if (kanryoDate[i] == null) {
            // 未完了
            // １次担当者と２次担当者について同一人物が更新（チェック）することは不可。
            if (i == 0) {
                if (UserInfo.getUserId() == tantosyaID[1]) {
                    return false;
                } else {
                    return true;
                }
            } else {
                if (UserInfo.getUserId() == tantosyaID[0]) {
                    return false;
                } else {
                    return true;
                }
            }
        } else {
            // 完了済
            return false;
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
            if (tanto == '2' && render2ndPart) {
                return true;
            } else {
                return false;
            }
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
     * lstRodosyaTRWrap
     * 引数   ：
     * 戻り値  ： wrapper4rodosya（リスト）
     * 概要   ： ラッパーリストを画面に返す
     */
    public list<wrapper4rodosya> lstRodosyaTRWrap {
        get {
            try {
                if (setController == null) {
                    return null;
                } else {
                    lstWrapper.clear();
                    
                    totalRodosyaSu = 0;
                    inProgressRodosyaSu = 0;
                    completedRodosyaSu = 0;

                    for (JFK_RodosyaTR__c c : lstrodosyaTR4Screen) {
                        wrapper4rodosya wrap = new wrapper4rodosya(c);
                        for (JFK_CommonTR__c commonTR : c.RodosyaTRs2__r) {
                            wrap.gs = commonTR;
                            
                            if (commonTR.GS_JissekiSyoruiShinsa_KanryoBi_2nd__c != null) {
                                completedRodosyaSu++;
                            } else if (commonTR.GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c != null) {
                                inProgressRodosyaSu++;
                            }
                        }

                        totalRodosyaSu++;
                        lstWrapper.add(wrap);
                    }
                }

                return lstWrapper;
             } catch (Exception e) {
                if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                }
                return null;
             }
        }
    }
 
    /* HD情報　*/
    /*
     * hd
     * 引数   ： 
     * 戻り値  ： HDレコード
     * 概要   ： HDレコードに担当者IDを設定して戻す。
     */
     public JFK_CommonTR__c hd {
        get {
            if (tanto == '1') {
                if (hdRecord.HD_Tantosya1__c == null) {
                    hdRecord.HD_Tantosya1__c = UserInfo.getUserId();
                }
            } else {
                if (hdRecord.HD_Tantosya2__c == null) {
                    hdRecord.HD_Tantosya2__c = UserInfo.getUserId();
                }
            }
                    
            return hdRecord;
         }
     }
    
    /*
     * doCalc
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ： 支給額計算
     */
     public void doCalc() {
        try{
            //パラメータは事業所TR（支給時期）のID
            JFK_ActualCalcBatchHandler.doCreateShikyuKaishBi(jigyosyoTRId);
        } catch(JFK_ActualValidateException jave){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,jave.getMessage()));
        }
     }

    /*
     * wrapperクラス
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public class wrapper {
        public JFK_CheckSheetTR__c  CheckSheet { get; set; }
        
        public wrapper(JFK_CheckSheetTR__c p_chSheetTR) {
            CheckSheet = p_chSheetTR;
        }
    }

    /*
     * wrapper for 労働者一覧クラス
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public class wrapper4rodosya {
        public JFK_RodosyaTR__c rodosyaTR   { get; set; }
        public JFK_CommonTR__c gs           { get; set; }
        
        public wrapper4rodosya(JFK_RodosyaTR__c p_rodosyaTR) {
            rodosyaTR = p_rodosyaTR;
        }
    }
}