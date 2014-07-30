/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_HDController
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/10/01 Create
 ******************************************************************************/
public class JFK_HDController {
    @TestVisible private string checkSheetName;
    @TestVisible private string tanto;
    private string checkSheetId;

    private list<JFK_CommonTR__c> lstHD = new list<JFK_CommonTR__c>();
    private list<JFK_CheckSheetTR__c> lstCheckSheetRecord = new list<JFK_CheckSheetTR__c>();

    private JFK_CommonTR__c hdRecord = new JFK_CommonTR__c();
    @TestVisible private JFK_CheckSheetTR__c checkSheetRecord = new JFK_CheckSheetTR__c();

    /*
     * Constructor
     */
    public JFK_HDController() {
        checkSheetName = Apexpages.currentPage().getParameters().get('sheetName');
        checkSheetId = Apexpages.currentPage().getParameters().get('checkSheetId');
        tanto = Apexpages.currentPage().getParameters().get('tanto');

        lstHD = JFK_cmnSOQL.getCommonTR_HD(checkSheetId);
        if (lstHD.size() > 0) {
            hdRecord = lstHD[0];
        }
            
        lstCheckSheetRecord = JFK_cmnSOQL.getCheckSheetTR_CheckSheetId(checkSheetId);
        if (lstCheckSheetRecord.size() > 0) {
            checkSheetRecord = lstCheckSheetRecord[0];
        }
    }
 
    /*
     * hd
     * 引数   ：
     * 戻り値  ： JFK_CommonTR__c(HD)
     * 概要   ： （１次／２次）担当者のユーザーIdを取得して返す。
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
     * checkSheet
     * 引数   ：
     * 戻り値  ： JFK_CheckSheetTR__c
     * 概要   ： チェックシート(１レコード)を返す。
     */
     public JFK_CheckSheetTR__c checkSheet {
        get {
                return checkSheetRecord;
            }
     }

    /*
     * checkSheetCategory
     * 引数   ： 
     * 戻り値  ： チェックシートのカテゴリ名
     * 概要   ： チェックシートのカテゴリ名を返す。
     */
     public string checkSheetCategory {
        get {
            return rtnCategoryName();
        }
     }

    /*
     * rtnCategoryName
     * 引数   ： なし
     * 戻り値  ： チェックシートのカテゴリ名
     * 概要   ： チェックシートのカテゴリ名をカスタムラベルから取得する。
     */
     private string rtnCategoryName() {
        if (checkSheetName == 'JCJ') {
            if (checkSheetRecord.CategoryNo__c == 1) {
                return System.Label.JFK_JCJ_Category001;
            } else if (checkSheetRecord.CategoryNo__c == 2) {
                return System.Label.JFK_JCJ_Category002;
            } else if (checkSheetRecord.CategoryNo__c == 3) {
                return System.Label.JFK_JCJ_Category003;
            } else if (checkSheetRecord.CategoryNo__c == 4) {
                return System.Label.JFK_JCJ_Category004;
            } else if (checkSheetRecord.CategoryNo__c == 5) {
                return System.Label.JFK_JCJ_Category005;
            }
        } else if (checkSheetName == 'JCR1') {
            if (checkSheetRecord.CategoryNo__c == 1) {
                return System.Label.JFK_JCR_1_Category001;
            } else if (checkSheetRecord.CategoryNo__c == 2) {
                return System.Label.JFK_JCR_1_Category002;
            } else if (checkSheetRecord.CategoryNo__c == 3) {
                return System.Label.JFK_JCR_1_Category003;
            } else if (checkSheetRecord.CategoryNo__c == 4) {
                return System.Label.JFK_JCR_1_Category004;
            } else if (checkSheetRecord.CategoryNo__c == 5) {
                return System.Label.JFK_JCR_1_Category005;
            } else if (checkSheetRecord.CategoryNo__c == 6) {
                return System.Label.JFK_JCR_1_Category006;
            }
/*
        } else if (checkSheetName == 'JCR2') {
            if (checkSheetRecord.CategoryNo__c == 1) {
                return System.Label.JFK_JCR_2_Category001;
            } else if (checkSheetRecord.CategoryNo__c == 2) {
                return System.Label.JFK_JCR_2_Category002;
            } else if (checkSheetRecord.CategoryNo__c == 3) {
                return System.Label.JFK_JCR_2_Category003;
            } else if (checkSheetRecord.CategoryNo__c == 4) {
                return System.Label.JFK_JCR_2_Category004;
            } else if (checkSheetRecord.CategoryNo__c == 5) {
                return System.Label.JFK_JCR_2_Category005;
            } else if (checkSheetRecord.CategoryNo__c == 6) {
                return System.Label.JFK_JCR_2_Category006;
            }
*/
        } else if (checkSheetName == 'JCR3') {
            if (checkSheetRecord.CategoryNo__c == 1) {
                return System.Label.JFK_JCR_3_Category001;
            } else if (checkSheetRecord.CategoryNo__c == 2) {
                return System.Label.JFK_JCR_3_Category002;
            } else if (checkSheetRecord.CategoryNo__c == 3) {
                return System.Label.JFK_JCR_3_Category003;
            } else if (checkSheetRecord.CategoryNo__c == 4) {
                return System.Label.JFK_JCR_3_Category004;
            } else if (checkSheetRecord.CategoryNo__c == 5) {
                return System.Label.JFK_JCR_3_Category005;
            } else if (checkSheetRecord.CategoryNo__c == 6) {
                return System.Label.JFK_JCR_3_Category006;
            } else if (checkSheetRecord.CategoryNo__c == 7) {
                return System.Label.JFK_JCR_3_Category007;
            }
        }
        return '';
     }
     
    /*
     * is1stTanto
     * 引数   ：
     * 戻り値  ： true:１次担当者   false:２次担当者
     * 概要   ： １次担当者の時trueを返す。
     */
     public boolean is1stTanto {
        get {
            if (tanto == '1') {
                return true;
            } else {
                return false;
            }
         }
     }

    /*
     * save
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： HD保存処理
     */
     public pageReference save() {
         try {
            if (checkError()) {
                return null;
            }

            // RecordTypeId取得
            hdRecord.RecordTypeId = JFK_cmdUtilities.getRecordTypeId(JFK_cmnConstant.RECORD_TYPE_HD_JISSEKI);
            hdRecord.RecordKBN__c = JFK_cmnConstant.COMMON_MANAGE_INFO_HD;
            hdRecord.Name = JFK_cmnConstant.COMMON_MANAGE_INFO_HD + '_' + string.valueOf(dateTime.now().format());
            hdRecord.CheckSheetTR__c = checkSheetId;
            
            // チェックシートIdに該当する事業所TR, 労働者TRの取得
            list<JFK_CheckSheetTR__c> lstcheckSheetTR = [SELECT JigyosyoTR__c, RodosyaTR__c FROM JFK_CheckSheetTR__c WHERE Id = :checkSheetId];
            hdRecord.JijyosyoTR_ShikyuJiki__c = lstcheckSheetTR[0].JigyosyoTR__c;
            hdRecord.RodosyaTR__c = lstcheckSheetTR[0].RodosyaTR__c;
                        
            list<JFK_CommonTR__c> hd = JFK_cmnSOQL.getCommonTR_HD4Update(checkSheetId);

            Database.saveResult sr;
            if (hd.size() == 0) {
                sr = Database.insert(hdRecord);
            } else {
                sr = Database.update(hdRecord);
            }                        
/*
            if (sr != null && sr.getErrors().size() == 0) {
                string recId = sr.getId();
                list<JFK_CommonTR__c> lstCommonTR = JFK_cmnSOQL.getCommonTR_1Rec(recId);

                if (lstCommonTR.size() > 0) {
                    lstCommonTR[0].Name = JFK_cmnConstant.COMMON_MANAGE_INFO_HD + '_' 
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuNendo__c) + '.'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuKai__c) + '_'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Area_Kubun__c) + '.'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.SeiriNO__c) + '_'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.NenMe__c) + '-'
                                        + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.KaiMe__c) + '('
                                        + lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Account__r.Name + ') '
                                        + lstCommonTR[0].CheckSheetTR__r.CategoryNo__c + '-'
                                        + lstCommonTR[0].CheckSheetTR__r.No__c;
                                        if (lstCommonTR[0].RodosyaTR__r.Rodosya__r.Name != null) {
                                            lstCommonTR[0].Name += ' (' + lstCommonTR[0].RodosyaTR__r.Rodosya__r.Name + ')';    
                                        }
                    //Nameフィールド作成
                    sr = Database.update(lstCommonTR[0]);
                }
            }
*/          
            return new PageReference('javascript:window.close()');
                        
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
     * 戻り値 ： true:エラーあり   false:エラーなし
     * 概要 ：
     */
    public boolean checkError() {
        try {
            // ステータス
            if (hd.HD_Status__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.JFK_Error022));
                return true;
            }
            
            // 補正事項
            if (tanto == '1') {
                if (hd.HD_HoseiJiko_1st__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.JFK_Error020));
                    return true;
                }
              } else { 
                if (hd.HD_HoseiJiko_2nd__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.JFK_Error020));
                    return true;
                }
            }
        
            return false;
         } catch (Exception e) {
            if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
             return null;
         }
    }
      
    /*
     * close
     * 引数   ： なし
     * 戻り値 ：pageReference
     * 概要   ： ページを閉じる。
     */
      public pageReference close() {
          return new PageReference('javascript:window.close()');
      }               
}