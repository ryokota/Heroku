/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_cmnConstantTest
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2014/01/07 Create
 ******************************************************************************/
@isTest
public class JFK_cmnConstantTest {
    /*
     * 引数 	：
     * 戻り値	：
     * 概要 	:
     */
    static testMethod void ConstantTest() {
        Test.startTest();

		string strConstant;
		
		strConstant = JFK_cmnConstant.COMMON_MANAGE_INFO_GS;
	    strConstant = JFK_cmnConstant.COMMON_MANAGE_INFO_HD;
	    strConstant = JFK_cmnConstant.COMMON_MANAGE_INFO_HM;
	    strConstant = JFK_cmnConstant.COMMON_MANAGE_INFO_MD;
	    strConstant = JFK_cmnConstant.COMMON_MANAGE_INFO_YS;
	    strConstant = JFK_cmnConstant.COMMON_MANAGE_INFO_JTL;
	    strConstant = JFK_cmnConstant.COMMON_MANAGE_INFO_PTMK;
	    strConstant = JFK_cmnConstant.RECORD_TYPE_GS_JISSEKI;
	    strConstant = JFK_cmnConstant.RECORD_TYPE_HD_JISSEKI;
	    strConstant = JFK_cmnConstant.RECORD_TYPE_HM_JISSEKI;
	    strConstant = JFK_cmnConstant.RECORD_TYPE_PTMK_JISSEKI;
	    strConstant = JFK_cmnConstant.RECORD_TYPE_MD;
	    strConstant = JFK_cmnConstant.RECORD_TYPE_YS;
	    strConstant = JFK_cmnConstant.RECORD_TYPE_JTL;
	    strConstant = JFK_cmnConstant.COMMON_M_AREA;
	    strConstant = JFK_cmnConstant.COMMON_M_CHECK_SHEET;
	    strConstant = JFK_cmnConstant.COMMON_M_CHECK_SHEET_JCJ;
	    strConstant = JFK_cmnConstant.COMMON_M_CHECK_SHEET_JCR_1st;
	    strConstant = JFK_cmnConstant.COMMON_M_CHECK_SHEET_JCR_2nd;
	    strConstant = JFK_cmnConstant.COMMON_M_CHECK_SHEET_JCR_Supplementary;
	    strConstant = JFK_cmnConstant.MD_GroupName_Renrakusaki;
	    strConstant = JFK_cmnConstant.MD_GroupName_Ininjo;
	    strConstant = JFK_cmnConstant.MD_GroupName_ShikyuTeishi;
	    strConstant = JFK_cmnConstant.MD_GroupName_JigyonushiTsugo;
	    strConstant = JFK_cmnConstant.MD_GroupName_Shukkosya;
	    strConstant = JFK_cmnConstant.MD_GroupName_Sonota;
	    strConstant = JFK_cmnConstant.ExceptionMsg_CustomValidation;
	    strConstant = JFK_cmnConstant.OPERATION_STATUS_SHINSAICHU_1st;
	    strConstant = JFK_cmnConstant.OPERATION_STATUS_SHINSAICHU_2nd;
	    strConstant = JFK_cmnConstant.OPERATION_STATUS_SASHIMODOSHI;
	    strConstant = JFK_cmnConstant.OPERATION_STATUS_CHECK_ZUMI;
	    strConstant = JFK_cmnConstant.OPERATION_STATUS_KANRYO_1st;
	    strConstant = JFK_cmnConstant.OPERATION_STATUS_KANRYO_2nd;
	    strConstant = JFK_cmnConstant.OPERATION_STATUS_SYUSEI_SINSEI;
	    strConstant = JFK_cmnConstant.OPERATION_STATUS_SINSEI_SYONIN;
	    strConstant = JFK_cmnConstant.OPERATION_STATUS_SINSEI_REJECT;
	    strConstant = JFK_cmnConstant.OPERATION_STATUS_TOKUSASHI;
	    strConstant = JFK_cmnConstant.RISYOKU_RIYU_JIGYONUSHI;
	    strConstant = JFK_cmnConstant.RISYOKU_RIYU_JIKOTSUGO;
	    strConstant = JFK_cmnConstant.KOYO_SYURUI;
	    strConstant = JFK_cmnConstant.KOYO_KUBUN;
	    strConstant = JFK_cmnConstant.KOYO_KEITAI;
	    strConstant = JFK_cmnConstant.KOYO_FULLTIME;
	    strConstant = JFK_cmnConstant.KOYO_TANJIKAN;
	    strConstant = JFK_cmnConstant.KOYO_SHINKI_KOYO;
	    strConstant = JFK_cmnConstant.KOYO_SAI_KOYO;

        Test.stopTest();
	}
}