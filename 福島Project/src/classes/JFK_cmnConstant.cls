/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_cmnConstant
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/09/24 Create
 ******************************************************************************/
public class JFK_cmnConstant {
    // 管理情報（帳票）種類
    public final static String COMMON_MANAGE_INFO_GS = 'GS';
    public final static String COMMON_MANAGE_INFO_HD = 'HD';
    public final static String COMMON_MANAGE_INFO_HM = 'HM';
    public final static String COMMON_MANAGE_INFO_MD = 'MD';
    public final static String COMMON_MANAGE_INFO_YS = 'YS';
    public final static String COMMON_MANAGE_INFO_JTL = 'JTL';
    public final static String COMMON_MANAGE_INFO_PTMK = 'PTMK';
    
    // RecordType Name
    public final static String RECORD_TYPE_GS_JISSEKI = 'GS_業務進捗管理表（実績報告）';
    public final static String RECORD_TYPE_HD_JISSEKI = 'HD_補正内容DB（実績報告）';
    public final static String RECORD_TYPE_HM_JISSEKI = 'HM_補正指導メモ（実績報告）';
    public final static String RECORD_TYPE_PTMK_JISSEKI = 'PTMK_１ヶ月超の欠勤あり（実績報告）';
    public final static String RECORD_TYPE_MD = 'MD_申送り事項DB';
    public final static String RECORD_TYPE_YS = 'YS_雇入れ日前勤務実績あり';
    public final static String RECORD_TYPE_JTL = 'JTL_実績報告督促リスト';
    
    // 汎用Mの分類名
    public final static String COMMON_M_AREA = 'エリア区分';
    public final static String COMMON_M_CHECK_SHEET = '審査シート';
    
    // 汎用Mの分類内の名称
    public final static String COMMON_M_CHECK_SHEET_JCJ = 'JCJ';
    public final static String COMMON_M_CHECK_SHEET_JCR_1st = 'JCR';
    public final static String COMMON_M_CHECK_SHEET_JCR_2nd = 'JCR（２回目以降用）';
    public final static String COMMON_M_CHECK_SHEET_JCR_Supplementary = 'JCR（補充労働者用）';

    // 汎用TR MDのグループ名
    public final static String MD_GroupName_Renrakusaki = '連絡先の指定';
    public final static String MD_GroupName_Ininjo = '委任状の提出';
    public final static String MD_GroupName_ShikyuTeishi = '支給停止中';
    public final static String MD_GroupName_JigyonushiTsugo = '事業主都合の離職あり（当該労働者の補充不可）';
    public final static String MD_GroupName_Shukkosya = '出向者の発生';
    public final static String MD_GroupName_Sonota = 'その他';

    // Exception Message
    public final static String ExceptionMsg_CustomValidation = 'FIELD_CUSTOM_VALIDATION_EXCEPTION';
    
    // 処理ステータス
    public final static String OPERATION_STATUS_SHINSAICHU_1st  = '1次審査中';
    public final static String OPERATION_STATUS_SHINSAICHU_2nd  = '2次審査中';
    public final static String OPERATION_STATUS_SASHIMODOSHI    = '差し戻し中';
    public final static String OPERATION_STATUS_CHECK_ZUMI      = 'チェック済';
    public final static String OPERATION_STATUS_KANRYO_1st      = '1次審査完了';
    public final static String OPERATION_STATUS_KANRYO_2nd      = '2次審査完了';
    public final static String OPERATION_STATUS_SYUSEI_SINSEI   = '修正申請中';
    public final static String OPERATION_STATUS_SINSEI_SYONIN   = '申請承認';
    public final static String OPERATION_STATUS_SINSEI_REJECT   = '申請却下';
    public final static String OPERATION_STATUS_TOKUSASHI       = '特差し中';
    
    // 離職理由
    public final static String RISYOKU_RIYU_JIGYONUSHI          = '事業主都合';
    public final static String RISYOKU_RIYU_JIKOTSUGO           = '自己都合';
    
    // 雇用関連
    public final static String KOYO_SYURUI                      = '雇用種類';
    public final static String KOYO_KUBUN                       = '雇用区分';
    public final static String KOYO_KEITAI                      = '雇用形態';
    
    // 雇用区分
    public final static String KOYO_FULLTIME                    = 'フルタイム';
    public final static String KOYO_TANJIKAN                    = '短時間労働者';
    
    // 雇用形態
    public final static String KOYO_SHINKI_KOYO                 = '新規雇用';
    public final static String KOYO_SAI_KOYO                    = '再雇用';
}