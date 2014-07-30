/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_JTLController
 *  概要        : 実績報告業務における架電／受領記録画面
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/10/13 Create
 ******************************************************************************/
public class JFK_JTLController {
    @TestVisible private string jigyosyoTRId;
    @TestVisible private list<JFK_CommonTR__c> lstJTL = new list<JFK_CommonTR__c>(); 
    @TestVisible private JFK_CommonTR__c JTLRecord = new JFK_CommonTR__c(); 
    
    public JFK_CommonTR__c JFKCommon{get;set;}
    private boolean isShowMessage = true;
    private boolean[] renderItem = new boolean[3]; 
    
    /*  
     * Constructor
     */
    public JFK_JTLController() {
        jigyosyoTRId = Apexpages.currentPage().getParameters().get('jigyoshoTRId');
        JFKCommon = getJFKCommon(jigyosyoTRId);
        for (integer i = 0; i < 3; i++) {
            renderItem[i] = true;
        }
    }
    
    public JFK_CommonTR__c getJFKCommon(string jigyosyoTRId){
        list<JFK_CommonTR__c> lstCommon =
             [SELECT GS_JigyoshoCD__c,GS_ShikyuJiki__c,GS_JigyosyoMei__c,
                JijyosyoTR_ShikyuJiki__r.Account__r.DaihyousyaYakusyokuShimei__c,
                JijyosyoTR_ShikyuJiki__r.Account__r.YubinBango_Shinsei__c,
                JijyosyoTR_ShikyuJiki__r.Account__r.Address_Shinsei__c,
                JijyosyoTR_ShikyuJiki__r.Account__r.Phone,
                JijyosyoTR_ShikyuJiki__r.Account__r.HoseiShido_Aitesaki_Busyo__c,
                JijyosyoTR_ShikyuJiki__r.Account__r.HoseiShido_Aitesaki_TantosyaMei__c,
                JijyosyoTR_ShikyuJiki__r.Account__r.HoseiShido_Aitesaki_Renrakusaki__c,
                JijyosyoTR_ShikyuJiki__r.Account__r.HoseiShido_Aitesaki_IninjoAri__c,
                JijyosyoTR_ShikyuJiki__r.Account__r.HoseiShido_Aitesaki_Jimusyo_TantosyaMei__c,
                JijyosyoTR_ShikyuJiki__r.Account__r.HoseiShido_Aitesaki_Renrakusaki2__c
                FROM JFK_CommonTR__c 
                WHERE JijyosyoTR_ShikyuJiki__c = :jigyosyoTRId
                AND RodosyaTR__c = null
                AND RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_GS
            ];
        
        if (lstCommon.size() == 0) {
            return null;
        } else {
            return lstCommon[0];
        }
    }
    
    /*
     * getJTL
     * 引数 ：
     * 戻り値： JFK_CommonTR__c
     * 概要 ： 新規登録用フィールド情報
     */
     public JFK_CommonTR__c getJTL() {
        JTLRecord.JTL_Tantosya__c = UserInfo.getUserId();
        return JTLRecord;
     }

    /*
     * tableJTL
     * 引数 ：
     * 戻り値： list<JFK_CommonTR__c>
     * 概要 ： 既に登録済レコード用テーブル
     */
    public list<JFK_CommonTR__c> tableJTL {
        get {
            lstJTL = JFK_cmnSOQL.getCommonTR_JTL(jigyosyoTRId);
            return lstJTL;
        }
    } 
    
    /*
     * showItems
     * 引数 ：
     * 戻り値：
     * 概要 ： 新規入力時、架電／受領によって表示するフィールドを制御
     */
     public void showItems() {
        for (integer i = 0; i < 3; i++) {
            if (i == 2) {
                if (JTLRecord.JTL_Kaden_Juryo__c == '架電') {
                    renderItem[i] = true;
                } else {
                    renderItem[i] = false;
                }
            } else {
                renderItem[i] = true;
            }
        }
     }

    /*
     * renderItem
     * 引数 ：
     * 戻り値： boolean[]
     * 概要 ： 新規入力時、架電／受領によって表示するフィールドを制御（showItemsメソッドの結果がベース情報となる。）
     */
     public boolean[] renderItems {
        get {
            return renderItem;
        }
     }

    /*
     * doDelete
     * 引数 ：
     * 戻り値： pageReference
     * 概要 ： 登録済レコードの削除
     */
    public pageReference doDelete() {
        try {
            string JTLId = Apexpages.currentPage().getParameters().get('id');

            Savepoint sp = Database.setSavepoint();
            
            // JTLレコード削除
            list<JFK_CommonTR__c> lstJTL = JFK_cmnSOQL.getCommonTR_4Update(JTLId);
            Database.deleteResult[] ldr = Database.delete(lstJTL);
            
            // GS(架電情報)更新
            list<JFK_CommonTR__c> lstCommonTR = JFK_cmnSOQL.getCommonTR_GS4Update(jigyosyoTRId);
            updateKadenDate(lstCommonTR);

            Database.saveResult[] lsr = Database.update(lstCommonTR);
            if (!JFK_cmdUtilities.chkSaveResult(lsr)) {
                Database.rollback(sp);
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
     * save
     * 引数 ：
     * 戻り値： pageReference
     * 概要 ： 更新処理
     */
     public pageReference save() {
        list<JFK_CommonTR__c> lstCommonTR;
        list<Database.saveResult> lsr = new list<Database.saveResult>();
        Database.saveResult sr;
        Savepoint sp; 
        try {
            // エラーチェック
            if (checkError()) {
                return null;
            }

            sp = Database.setSavepoint();
            
            // 1. JTL更新（新規レコード分）
            if (JTLRecord.JTL_Hizuke__c != null && JTLRecord.JTL_Kaden_Juryo__c != null) {
                JTLRecord.RecordTypeId = JFK_cmdUtilities.getRecordTypeId(JFK_cmnConstant.RECORD_TYPE_JTL);
                JTLRecord.RecordKBN__c = JFK_cmnConstant.COMMON_MANAGE_INFO_JTL;
                JTLRecord.Name = JFK_cmnConstant.COMMON_MANAGE_INFO_JTL + '_' + string.valueOf(dateTime.now());
                JTLRecord.JijyosyoTR_ShikyuJiki__c = jigyosyoTRId;
                // Insert       
                sr = Database.insert(JTLRecord);
                // JTLの更新に失敗したらロールバック
                list<Database.saveResult> lsr2 = new list<Database.saveResult>(); 
                lsr2.add(sr);
                if (!JFK_cmdUtilities.chkSaveResult(lsr2)) {
                    Database.rollback(sp);
                }

                //JTLのNameフィールド作成
                if (sr != null && sr.getErrors().size() == 0) {
                    string recId = sr.getId();
                    lstCommonTR = JFK_cmnSOQL.getCommonTR_1Rec(recId);
    
                    if (lstCommonTR.size() > 0) {
                        lstCommonTR[0].Name = JFK_cmnConstant.COMMON_MANAGE_INFO_JTL + '_' 
                                            + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuNendo__c) + '.'
                                            + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuKai__c) + '_'
                                            + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Area_Kubun__c) + '.'
                                            + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.SeiriNO__c) + '_'
                                            + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.NenMe__c) + '-'
                                            + string.valueOf(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.KaiMe__c) + '('
                                            + lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Account__r.Name + ')';
                        // 更新
                        sr = Database.update(lstCommonTR[0]);
                        lsr2.clear() ; lsr2.add(sr);
                        // JTLの更新に失敗したらロールバック
                        if (!JFK_cmdUtilities.chkSaveResult(lsr2)) {
                            Database.rollback(sp);
                        }
                    }
                }
            }
            
            // JTL更新（既存レコード分）
            if (lstJTL.size() > 0) {
                // 2. 既存レコード更新
                lsr = Database.update(lstJTL);
                // JTLの更新に失敗したらロールバック
                if (lsr != null || !JFK_cmdUtilities.chkSaveResult(lsr)) {
                    Database.rollback(sp);
                }
            }

            // GS(架電情報)更新
            lstCommonTR = JFK_cmnSOQL.getCommonTR_GS4Update(lstCommonTR[0].JijyosyoTR_ShikyuJiki__r.Id);
            if (lstCommonTR.size() > 0) {
                if (JTLRecord.JTL_Kaden_Juryo__c == '受領') {
                    lstCommonTR[0].GS_JissekiHokokusyo_JuryoBi__c = JTLRecord.JTL_Hizuke__c;
                } else {
                    // 架電
                    updateKadenDate(lstCommonTR);
                }
                // GS更新
                sr = Database.update(lstCommonTR[0]);
                // GSの更新に失敗したらロールバック
                if (lsr == null || lsr.size() == 0) {
                    lsr.clear() ; lsr.add(sr);
                }
                if (!JFK_cmdUtilities.chkSaveResult(lsr)) {
                    Database.rollback(sp);
                }
            } else {
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,Label.JFK_Error021));
                return null;
            }

            return new PageReference('javascript:window.close()');
                        
        } catch (Exception e) {
            Database.rollback(sp);
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
        }
     }               
 
    /*
     * updateKadenDate
     * 引数 ： list<JFK_CommonTR__c>
     * 戻り値：
     * 概要 ： GS(架電情報)更新
     */
     private void updateKadenDate(list<JFK_CommonTR__c> lstCommonTR) {
         try {
            lstJTL = JFK_cmnSOQL.getCommonTR_JTL(jigyosyoTRId);
            integer i = 1;

            for (JFK_CommonTR__c jtl : lstJTL) {
                if (i == 1) { lstCommonTR[0].GS_Miteisyutsusya_1stTokusokuJissiBi__c = jtl.JTL_Hizuke__c; }  
                else if (i == 2)  { lstCommonTR[0].GS_Miteisyutsusya_2ndTokusokuJissiBi__c = jtl.JTL_Hizuke__c; }
                else if (i == 3)  { lstCommonTR[0].GS_Miteisyutsusya_3rdTokusokuJissiBi__c = jtl.JTL_Hizuke__c; }
                else if (i == 4)  { lstCommonTR[0].GS_Miteisyutsusya_4thTokusokuJissiBi__c = jtl.JTL_Hizuke__c; }
                else if (i == 5)  { lstCommonTR[0].GS_Miteisyutsusya_5thTokusokuJissiBi__c = jtl.JTL_Hizuke__c; } 
                else if (i == 6)  { lstCommonTR[0].GS_Miteisyutsusya_6thTokusokuJissiBi__c = jtl.JTL_Hizuke__c; }
                else if (i == 7)  { lstCommonTR[0].GS_Miteisyutsusya_6thTokusokuJissiBi__c = jtl.JTL_Hizuke__c; }
                else if (i == 8)  { lstCommonTR[0].GS_Miteisyutsusya_7thTokusokuJissiBi__c = jtl.JTL_Hizuke__c; }
                else if (i == 9)  { lstCommonTR[0].GS_Miteisyutsusya_9thTokusokuJissiBi__c = jtl.JTL_Hizuke__c; }
                else if (i == 10) { lstCommonTR[0].GS_Miteisyutsusya_10thTokusokuJissiBi__c = jtl.JTL_Hizuke__c; }
                
                i++;
            }
            
            if (i < 11 ) {
                for (integer j = i; j < 11; j++) {
                    if (j == 1) { lstCommonTR[0].GS_Miteisyutsusya_1stTokusokuJissiBi__c = null; }  
                    else if (j == 2)  { lstCommonTR[0].GS_Miteisyutsusya_2ndTokusokuJissiBi__c = null; }
                    else if (j == 3)  { lstCommonTR[0].GS_Miteisyutsusya_3rdTokusokuJissiBi__c = null; }
                    else if (j == 4)  { lstCommonTR[0].GS_Miteisyutsusya_4thTokusokuJissiBi__c = null; }
                    else if (j == 5)  { lstCommonTR[0].GS_Miteisyutsusya_5thTokusokuJissiBi__c = null; } 
                    else if (j == 6)  { lstCommonTR[0].GS_Miteisyutsusya_6thTokusokuJissiBi__c = null; }
                    else if (j == 7)  { lstCommonTR[0].GS_Miteisyutsusya_6thTokusokuJissiBi__c = null; }
                    else if (j == 8)  { lstCommonTR[0].GS_Miteisyutsusya_7thTokusokuJissiBi__c = null; }
                    else if (j == 9)  { lstCommonTR[0].GS_Miteisyutsusya_9thTokusokuJissiBi__c = null; }
                    else if (j == 10) { lstCommonTR[0].GS_Miteisyutsusya_10thTokusokuJissiBi__c = null; }
                }
            }
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
         }
     }
     
    /*
     * checkError
     * 引数 ：
     * 戻り値： boolean
     * 概要 ： エラーチェック
     */
     private boolean checkError() {
        boolean existError = false;
        
        if (JTLRecord.JTL_Hizuke__c == null && JTLRecord.JTL_KadenNaiyo__c != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.JFK_Error012));
            existError = true;
        }

        integer i = 1;
        integer kadenCnt = 0;
        for (JFK_CommonTR__c jtl : lstJTL) {
            // 日付
            if (jtl.JTL_Hizuke__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.JFK_Error013 + '(' + i + '行目)'));
                existError = true;
            }
            
            if (jtl.JTL_Kaden_Juryo__c == '架電') {
                kadenCnt++;
            }
            
            i++;
        }
        
        // １０件以上登録不可
        if (kadenCnt > 10) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.JFK_Error014));
            existError = true;
        }
        
        return existError;
    }

    /*
     * close
     * 引数 ：
     * 戻り値： pageReference
     * 概要 ： 画面閉じる
     */
    public pageReference close() {
        return new PageReference('javascript:window.close()');
    } 
}