/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_HDController
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/09/25 Create
 ******************************************************************************/
public class JFK_MDController {
    private string jijyosyoTR_Nendo_Kai;
    
    @TestVisible private list<JFK_CommonTR__c> lstMd = new list<JFK_CommonTR__c>(); 
    @TestVisible private JFK_CommonTR__c mdRecord = new JFK_CommonTR__c(); 
    private list<boolean> lstdoRender = new list<boolean>();  
    
    /*
     * Constructor
     */
    public JFK_MDController() {
        jijyosyoTR_Nendo_Kai = Apexpages.currentPage().getParameters().get('jigyoshoTRParentId');

        // Render flag初期化
        if (lstdoRender.size() == 0) {
            for (integer i = 0; i < 10; i++) {
                lstdoRender.add(false);
            }
        }
        
        lstMd = JFK_cmnSOQL.getCommonTR_MD(jijyosyoTR_Nendo_Kai);
    }
    
    /*
     * getMD
     * 引数   ：
     * 戻り値  ： MDのレコード
     * 概要   ： 空のMDレコード
     */
     public JFK_CommonTR__c getMD() {
        return mdRecord;
     }

    /*
     * tableMD
     * 引数   ：
     * 戻り値  ：list<JFK_CommonTR__c>
     * 概要   ： 対象の登録済レコード
     */
    public list<JFK_CommonTR__c> tableMD {
        get {
            return lstMd;
        }
    } 
    
    /*
     * showItems
     * 引数   ： なし
     * 戻り値  ： なし
     * 概要   ：
     */
     public void showItems() {
        if (mdRecord.MD_Group__c == null ) {
            lstdoRender.clear();
            for (integer i = 0; i < 10; i++) {
                lstdoRender.add(false);
            }
            return;
        }
        
        list<JFK_CommonTR__c> lstMD = JFK_cmnSOQL.getCommonTR_MD(jijyosyoTR_Nendo_Kai, mdRecord.MD_Group__c);

        if (lstMD.size() == 0) {
            mdRecord.MD_CenterTantosya__c = UserInfo.getUserId();
        } else {
            mdRecord = lstMD[0];
        }

        lstdoRender.clear();

        if (mdRecord.MD_Group__c == JFK_cmnConstant.MD_GroupName_Renrakusaki) {
            for (integer i = 0; i < 10; i++) {
                if (i <= 4) {
                    lstdoRender.add(true);
                } else {
                    lstdoRender.add(false);
                }
            }
        } else if (mdRecord.MD_Group__c == JFK_cmnConstant.MD_GroupName_Ininjo) {
            for (integer i = 0; i < 10; i++) {
                if (i <= 1 || i == 4 || i == 5) {
                    lstdoRender.add(true);
                } else {
                    lstdoRender.add(false);
                }
            }
        } else if (mdRecord.MD_Group__c == JFK_cmnConstant.MD_GroupName_ShikyuTeishi) {
            for (integer i = 0; i < 10; i++) {
                if (i <= 1 || i == 6 || i == 7) {
                    lstdoRender.add(true);
                } else {
                    lstdoRender.add(false);
                }
            }
        } else if (mdRecord.MD_Group__c == JFK_cmnConstant.MD_GroupName_JigyonushiTsugo) {
            for (integer i = 0; i < 10; i++) {
                if (i <= 1 || i == 8) {
                    lstdoRender.add(true);
                } else {
                    lstdoRender.add(false);
                }
            }
        } else if (mdRecord.MD_Group__c == JFK_cmnConstant.MD_GroupName_Shukkosya) {
            for (integer i = 0; i < 10; i++) {
                if (i <= 1 || i == 8 || i == 9) {
                    lstdoRender.add(true);
                } else {
                    lstdoRender.add(false);
                }
            }
        } else if (mdRecord.MD_Group__c == JFK_cmnConstant.MD_GroupName_Sonota) {
            for (integer i = 0; i < 10; i++) {
                if (i <= 1) {
                    lstdoRender.add(true);
                } else {
                    lstdoRender.add(false);
                }
            }
        }
     }

    /*
     * doRender
     * 引数   ：
     * 戻り値  ： list<boolean>
     * 概要   ：
     */
     public list<boolean> doRender {
         get {
            return lstdoRender;
         }
     }               
    
    /*
     * doRenderTable
     * 引数   ：
     * 戻り値  ： list<boolean>
     * 概要   ：
     */
    public list<boolean> doRenderTable {
        get {
            boolean[] lstRender = new boolean[12];

            for (integer i = 0; i < 12; i++) {
                lstRender[i] = false;
            }
            for (JFK_CommonTR__c md :lstMd) {
                if (md.MD_Group__c == JFK_cmnConstant.MD_GroupName_Renrakusaki) {
                    lstRender[0] = true;
                    lstRender[1] = true;
                    lstRender[2] = true;
                    lstRender[3] = true;
                    lstRender[4] = true;
                } else if (md.MD_Group__c == JFK_cmnConstant.MD_GroupName_Ininjo) {
                    lstRender[0] = true;
                    lstRender[1] = true;
                    lstRender[4] = true;
                    lstRender[5] = true;
                } else if (md.MD_Group__c == JFK_cmnConstant.MD_GroupName_ShikyuTeishi) {
                    lstRender[0] = true;
                    lstRender[1] = true;
                    lstRender[6] = true;
                    lstRender[7] = true;
                } else if (md.MD_Group__c == JFK_cmnConstant.MD_GroupName_JigyonushiTsugo) {
                    lstRender[0] = true;
                    lstRender[1] = true;
                    lstRender[8] = true;
                } else if (md.MD_Group__c == JFK_cmnConstant.MD_GroupName_Shukkosya) {
                    lstRender[0] = true;
                    lstRender[1] = true;
                    lstRender[8] = true;
                    lstRender[9] = true;
                } else if (md.MD_Group__c == JFK_cmnConstant.MD_GroupName_Sonota) {
                    lstRender[0] = true;
                    lstRender[1] = true;
                }
            }       
            return lstRender;
        }
    }
    
    /*
     * doDelete
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： 削除処理
     */
    public pageReference doDelete() {
        try {
            string mdId = Apexpages.currentPage().getParameters().get('id');
            
            list<JFK_CommonTR__c> lstMD = JFK_cmnSOQL.getCommonTR_4Update(mdId);
            delete(lstMD);
            
            PageReference pageRef = new PageReference('/apex/JFK_MD_Popup?jigyoshoTRParentId=' + jijyosyoTR_Nendo_Kai); 
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
            // エラーチェック
            if (checkError()) {
                return null;
            }
            mdRecord.RecordTypeId = JFK_cmdUtilities.getRecordTypeId(JFK_cmnConstant.RECORD_TYPE_MD);
            mdRecord.RecordKBN__c = JFK_cmnConstant.COMMON_MANAGE_INFO_MD;
            mdRecord.Name = JFK_cmnConstant.COMMON_MANAGE_INFO_MD + '_' + string.valueOf(dateTime.now());
            mdRecord.JigyosyoTR_YearTime__c = jijyosyoTR_Nendo_Kai;

            list<JFK_CommonTR__c> lstMD = JFK_cmnSOQL.getCommonTR_MD4Update(jijyosyoTR_Nendo_Kai, mdRecord.MD_Group__c);

            Database.saveResult sr;
            if (lstMD.size() == 0) {
                sr = Database.insert(mdRecord);
            } else {
                mdRecord.id = lstMD[0].id;
                sr = Database.update(mdRecord);
            }

            if (sr != null && sr.getErrors().size() == 0) {
                string recId = sr.getId();
                list<JFK_CommonTR__c> lstCommonTR = JFK_cmnSOQL.getCommonTR_1Rec(recId);

                if (lstCommonTR.size() > 0) {
                    lstCommonTR[0].Name = JFK_cmnConstant.COMMON_MANAGE_INFO_MD + '_' 
                                        + string.valueOf(lstCommonTR[0].JigyosyoTR_YearTime__r.BosyuNendo__c) + '.'
                                        + string.valueOf(lstCommonTR[0].JigyosyoTR_YearTime__r.BosyuKai__c) + '_'
                                        + string.valueOf(lstCommonTR[0].JigyosyoTR_YearTime__r.Area_Kubun__c) + '.'
                                        + string.valueOf(lstCommonTR[0].JigyosyoTR_YearTime__r.SeiriNO__c) + '('
                                        + lstCommonTR[0].JigyosyoTR_YearTime__r.Account__r.Name + ')';
                    //Nameフィールド作成
                    sr = Database.update(lstCommonTR[0]);
                }
            }                       
            //return null;  
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
     * 引数   ： なし
     * 戻り値  ： エラーあり:true
     * 概要   ： エラー処理
     */
     private boolean checkError() {
        boolean existError = false;

        // Group
        if (mdRecord.MD_Group__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.JFK_Error015));
            existError = true;
        }
        
        return existError;
    }

    /*
     * close
     * 引数   ：
     * 戻り値  ： pageReference
     * 概要   ： ページを閉じる。
     */
    public pageReference close() {
        return new PageReference('javascript:window.close()');
    } 
}