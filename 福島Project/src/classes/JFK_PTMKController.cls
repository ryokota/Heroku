/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_PTMKController
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/10/12 Create
 ******************************************************************************/
public class JFK_PTMKController {
        @TestVisible private string rodosyaTRId;

        @TestVisible private list<JFK_CommonTR__c> lstPTMK = new list<JFK_CommonTR__c>();
        @TestVisible private    JFK_CommonTR__c ptmkRecord;

        /*
         * Constructor
         */
        public JFK_PTMKController() {
            rodosyaTRId = Apexpages.currentPage().getParameters().get('rodosyaTRId');
                    
            lstPTMK = JFK_cmnSOQL.getCommonTR_PTMK(rodosyaTRId);
        }
 
    /*
     * ptmk
     * 引数   ：
     * 戻り値  ： JFK_CommonTR__c
     * 概要   ： 空レコード作成
     */
     public JFK_CommonTR__c ptmk {
        get {
            ptmkRecord = new JFK_CommonTR__c();
            
            ptmkRecord.PTMK_Tantosya__c = UserInfo.getUserId();
            return ptmkRecord;
         }
     }
     
    /*
     * lstPTMKRec
     * 引数   ：
     * 戻り値  ： list<JFK_CommonTR__c>
     * 概要   ： 該当の登録済みレコードのリスト
     */
     public list<JFK_CommonTR__c> lstPTMKRec {
        get {
            return lstPTMK;
         }
     }

    /*
     * doDelete
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 登録済レコードの削除
     */
    public pageReference doDelete() {
        try {
            string Id = Apexpages.currentPage().getParameters().get('id');
            
            list<JFK_CommonTR__c> lstCommon = JFK_cmnSOQL.getCommonTR_4Update(Id);
            delete(lstCommon);

//          return null; 
            PageReference pageRef = new PageReference('/apex/JFK_PTMK?rodosyaTRId=' + rodosyaTRId); 
            pageRef.setRedirect(true);
            return pageRef; 

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
         try {
            if (checkError()) {
                return null;
            }

            // 既存分更新
            list<JFK_CommonTR__c> hm = JFK_cmnSOQL.getCommonTR_PTMK4Update(rodosyaTRId);
            if (hm.size() > 0) {
                Database.saveResult[] lsr;
                lsr = Database.update(lstPTMK);
            }                        

            // 新規登録分更新
            Database.saveResult sr;

            if (ptmkRecord.PTMK_KekkinnBi_From__c != null) {
                ptmkRecord.RecordTypeId = JFK_cmdUtilities.getRecordTypeId(JFK_cmnConstant.RECORD_TYPE_PTMK_JISSEKI);
                ptmkRecord.RecordKBN__c = JFK_cmnConstant.COMMON_MANAGE_INFO_PTMK;
                ptmkRecord.Name = JFK_cmnConstant.COMMON_MANAGE_INFO_PTMK + '_' + dateTime.Now().format();
//              system.debug('ptmkRecord.Name : ' + ptmkRecord.Name);
//              system.debug('rodosyaTRId : ' + rodosyaTRId);
                ptmkRecord.RodosyaTR__c = rodosyaTRId;

                sr = Database.insert(ptmkRecord);
            }
            if (sr != null && sr.getErrors().size() == 0) {
                string recId = sr.getId();
                list<JFK_CommonTR__c> lstCommonTR = JFK_cmnSOQL.getCommonTR_1Rec(recId);

                if (lstCommonTR.size() > 0) {
                    lstCommonTR[0].Name = JFK_cmnConstant.COMMON_MANAGE_INFO_PTMK + '_' 
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
/*
            PageReference pageRef = new PageReference('/apex/JFK_PTMK?rodosyaTRId=' + rodosyaTRId); 
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
     * 戻り値  ： エラーありはtrue
     * 概要   ： エラー処理
     */
     public boolean checkError() {
        boolean existError = false;

        if (ptmkRecord.PTMK_KekkinnBi_From__c != null) {
            if (ptmkRecord.PTMK_KekkinnBi_To__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.JFK_Error016));
                existError = true;
            }
        }           

        if (ptmkRecord.PTMK_KekkinnBi_From__c == null) {
            if (ptmkRecord.PTMK_KekkinnBi_To__c != null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.JFK_Error017));
                existError = true;
            }
        }           

        if (ptmkRecord.PTMK_KekkinnBi_From__c != null && ptmkRecord.PTMK_KekkinnBi_To__c != null) {
            if (ptmkRecord.PTMK_KekkinnBi_To__c < ptmkRecord.PTMK_KekkinnBi_From__c.addMonths(1)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.JFK_Error018));
                existError = true;
            }
        }           

        integer i = 1;      
        for (JFK_CommonTR__c ptmkRecord : lstPTMK) {
            if (ptmkRecord.PTMK_KekkinnBi_From__c != null) {
                if (ptmkRecord.PTMK_KekkinnBi_To__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.JFK_Error016 + '(' + i + '行目)'));
                    existError = true;
                }
            }           
    
            if (ptmkRecord.PTMK_KekkinnBi_From__c == null) {
                if (ptmkRecord.PTMK_KekkinnBi_To__c != null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.JFK_Error017 + '(' + i + '行目)'));
                    existError = true;
                }
            }           
    
            if (ptmkRecord.PTMK_KekkinnBi_From__c != null && ptmkRecord.PTMK_KekkinnBi_To__c != null) {
                if (ptmkRecord.PTMK_KekkinnBi_To__c < ptmkRecord.PTMK_KekkinnBi_From__c.addMonths(1)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.JFK_Error018 + '(' + i + '行目)'));
                    existError = true;
                }
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
     * 概要   ： ページ閉じる。
     */
      public pageReference close() {
          return new PageReference('javascript:window.close()');
      }               
}