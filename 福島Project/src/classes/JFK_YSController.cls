/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_YSController
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/09/27 Create
 ******************************************************************************/
public class JFK_YSController {
    private string jigyosyoTRId;
    private string rodosyaTRId;
    private boolean isShowMessage = true;

    private JFK_CommonTR__c ysRecord = new JFK_CommonTR__c(); 
    
    /*
     * Constructor
     */
    public JFK_YSController() {
        jigyosyoTRId = Apexpages.currentPage().getParameters().get('jigyosyoTRId');
        rodosyaTRId = Apexpages.currentPage().getParameters().get('rodosyaTRId');

        list<JFK_RodosyaTR__c> lstRodosyaTR = JFK_cmnSOQL.getRodosyaTR_withGS_1Rec(rodosyaTRId);
        if (lstRodosyaTR.size() > 0) {
            rodosyaMei = lstRodosyaTR[0].Rodosya__r.Name;
        }
            
        list<JFK_CommonTR__c> lstYS = JFK_cmnSOQL.getCommonTR_YS(rodosyaTRId);

        if (lstYS.size() == 0) {
            ysRecord.RodosyaTR__c = rodosyaTRId;
            ysRecord.YS_Nyuryokusya__c = UserInfo.getUserId();
        } else {
            ysRecord = lstYS[0];
        }
    }

    /*
     * getYS
     * 引数   ：
     * 戻り値  ： JFK_CommonTR__c
     * 概要   ： 空レコード
     */
     public JFK_CommonTR__c YS {
        get {
            return ysRecord;
        }
     }

    /*
     * rodosyaMei
     * 引数   ：
     * 戻り値  ： 労働者名
     * 概要   ：
     */
     public string rodosyaMei { get; set; }
     
    /*
     * showMessage
     * 引数   ：
     * 戻り値  ： trueの時、メッセージ表示
     * 概要   ：
     */
     public boolean showMessage {
        get {
            return isShowMessage;
        }
     }

    /*
     * save
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 保存処理
     */
     public pageReference save() {
         try {
            // エラーチェック
            /*
            if (checkError()) {
                isShowMessage = false;
                return null;
            }
            */
            
            ysRecord.RecordTypeId = JFK_cmdUtilities.getRecordTypeId(JFK_cmnConstant.RECORD_TYPE_YS);
            ysRecord.RecordKBN__c = JFK_cmnConstant.COMMON_MANAGE_INFO_YS;
            ysRecord.Name = JFK_cmnConstant.COMMON_MANAGE_INFO_YS + '_' + string.valueOf(dateTime.now().format());
            ysRecord.rodosyaTR__c = rodosyaTRId;
            ysRecord.JijyosyoTR_ShikyuJiki__c = jigyosyoTRId;

            list<JFK_CommonTR__c> lstYS = JFK_cmnSOQL.getCommonTR_YS4Update(rodosyaTRId);

            Database.saveResult sr;
            if (lstYS.size() == 0) {
                sr = Database.insert(ysRecord);
            } else {
                ysRecord.id = lstYS[0].id;
                sr = Database.update(ysRecord);
            }

            if (sr.getErrors().size() == 0) {
                string recId = sr.getId();
                list<JFK_CommonTR__c> lstCommonTR = JFK_cmnSOQL.getCommonTR_1Rec(recId);

                if (lstCommonTR.size() > 0) {
                    lstCommonTR[0].Name = JFK_cmnConstant.COMMON_MANAGE_INFO_YS + '_' 
                                        + string.valueOf(lstCommonTR[0].RodosyaTR__r.BosyuNendo__c) + '.'
                                        + string.valueOf(lstCommonTR[0].RodosyaTR__r.BosyuKai__c) + '_'
                                        + string.valueOf(lstCommonTR[0].RodosyaTR__r.JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Area_Kubun__c) + '.'
                                        + string.valueOf(lstCommonTR[0].RodosyaTR__r.JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.SeiriNO__c) + '_'
                                        + string.valueOf(lstCommonTR[0].RodosyaTR__r.NenMe__c) + '-'
                                        + string.valueOf(lstCommonTR[0].RodosyaTR__r.KaiMe__c) + '('
                                        + lstCommonTR[0].RodosyaTR__r.JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Account__r.Name + ' : '
                                        + lstCommonTR[0].RodosyaTR__r.Rodosya__r.Name + ')';

                    //Nameフィールド作成
                    sr = Database.update(lstCommonTR[0]);
                }         
            }
            
            return new PageReference('javascript:window.close()');
                        
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
             return null;
         }
     }               
 
    /*
     * checkError
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
/*
     public boolean checkError() {
        boolean existError = false;

        // Group
        if (ysRecord.MD_Group__c == null) {
            ysRecord.MD_Group__c.addError(System.Label.JFK_Error001);
            existError = true;
        }
        
        return existError;
    }
*/

    /*
     * close
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： ページ閉じる。
     */
    public pageReference close() {
        return new PageReference('javascript:window.close()');
    } 
}