/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_HMController
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/10/01 Create
 ******************************************************************************/
public class JFK_HMController {
        @TestVisible private string jigyosyoTRId;
        @TestVisible private JFK_CommonTR__c hmRecord;
        @TestVisible private list<JFK_CommonTR__c> lstHM = new list<JFK_CommonTR__c>();

        /*
         * Constructor
         */
        public JFK_HMController() {
            jigyosyoTRId = Apexpages.currentPage().getParameters().get('jigyoshoTRId');
            lstHM = JFK_cmnSOQL.getCommonTR_HM(jigyosyoTRId);
        }
 
    /*
     * hm
     * 引数   ：
     * 戻り値  ： JFK_CommonTR__c
     * 概要   ： 新規レコード用プロパティ
     */
     public JFK_CommonTR__c hm {
        get {
            hmRecord = new JFK_CommonTR__c();
            
            hmRecord.HM_Tantosya__c = UserInfo.getUserId();
            return hmRecord;
         }
     }
     
    /*
     * lsthmRec
     * 引数   ：
     * 戻り値  ： list<JFK_CommonTR__c>
     * 概要   ： 既存レコード用プロパティ
     */
     public list<JFK_CommonTR__c> lsthmRec {
        get {
            lstHM = JFK_cmnSOQL.getCommonTR_HM(jigyosyoTRId);
            return lstHM;
         }
     }

    /*
     * doDelete
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 選択されたレコードの削除
     */
    public pageReference doDelete() {
        try {
            string Id = Apexpages.currentPage().getParameters().get('id');
            
            list<JFK_CommonTR__c> lstCommon = JFK_cmnSOQL.getCommonTR_4Update(Id);
            delete(lstCommon);

            return null; 
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
     * 概要   ： レコードの保存
     */
     public pageReference save() {
         try {
            if (checkError()) {
                return null;
            }

            // 既存分更新
            list<JFK_CommonTR__c> hm = JFK_cmnSOQL.getCommonTR_HM4Update(jigyosyoTRId);
            Database.saveResult[] lsr;
            if (hm.size() > 0) {
                lsr = Database.update(lstHM);
            }                        

            // 新規登録分更新
            Database.saveResult sr;
            if (hmRecord.HM_TaioBi__c != null) {
                hmRecord.RecordTypeId = JFK_cmdUtilities.getRecordTypeId(JFK_cmnConstant.RECORD_TYPE_HM_JISSEKI);
                hmRecord.RecordKBN__c = JFK_cmnConstant.COMMON_MANAGE_INFO_HM;
                hmRecord.Name = JFK_cmnConstant.COMMON_MANAGE_INFO_HM + '_' + string.valueOf(dateTime.now());
                hmRecord.JijyosyoTR_ShikyuJiki__c = jigyosyoTRId;

                sr = Database.insert(hmRecord);
            }
                 
            if (sr != null && sr.getErrors().size() == 0) {
                string recId = sr.getId();
                list<JFK_CommonTR__c> lstCommonTR = JFK_cmnSOQL.getCommonTR_1Rec(recId);

                if (lstCommonTR.size() > 0) {
                    lstCommonTR[0].Name = JFK_cmnConstant.COMMON_MANAGE_INFO_HM + '_' 
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuNendo__c) + '.'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuKai__c) + '_'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Area_Kubun__c) + '.'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.SeiriNO__c) + '_'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.NenMe__c) + '-'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.KaiMe__c) + '('
                                        + lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Account__r.Name + ')';
                    //Nameフィールド作成
                    sr = Database.update(lstCommonTR[0]);
                }
            }                       

            return new PageReference('javascript:window.close()');
/*
            PageReference pageRef = new PageReference('/apex/JFK_HM'); 
            pageRef.setRedirect(true);
            return pageRef; 
*/
         } catch (Exception e) {
            if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
             return null;
         }
     }               
 
     /*
     * checkError
     * 引数   ： なし
     * 戻り値  ： true:エラーあり   false:エラーなし
     * 概要   ： エラーチェック
     */
     public boolean checkError() {
        boolean existError = false;

        if (hmRecord.HM_HoseiMemo__c != null) {
            if (hmRecord.HM_TaioBi__c == null || hmRecord.HM_Aitesaki__c == null) {
                // 対応日
                if (hmRecord.HM_TaioBi__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.JFK_Error008));
                    existError = true;
                }
                // 相手先
                if (hmRecord.HM_Aitesaki__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.JFK_Error009));
                    existError = true;
                }
            }
        }

        integer i = 1;      
        for (JFK_CommonTR__c hm : lstHM) {
            // 対応日
            if (hm.HM_TaioBi__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.JFK_Error010 + '(' + i + '行目)'));
                existError = true;
            }
            
            // 相手先
            if (hm.HM_Aitesaki__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.JFK_Error011 + '(' + i + '行目)'));
                existError = true;
            }
            
            i++;
        }

        return existError;
    }
 
    public void dummy() {
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
}