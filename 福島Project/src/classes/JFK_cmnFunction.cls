/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_cmnFunction
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/10/08 Create
 ******************************************************************************/
public class JFK_cmnFunction {
    /*
     * assembleShikyuJiki
     * 引数 ： integer nenme
     *        integer jiki
     * 戻り値： string
     * 概要 ：
     */
    public static string assembleShikyuJiki(integer nenme, integer jiki) {
        string strJiki = '';
        if (jiki == 1) {
            strJiki = '6ヶ月後';
        } else {
            strJiki = '1年後';
        }
        
        return string.valueOf(nenme) + '年目' + strJiki;
    }

    /*
     * upsertCheckSheetTR
     * 引数 ： 
     * 戻り値：CheckSheetTRのId 
     * 概要 ：
     */
    public static string upsertCheckSheetTR(list<JFK_CheckSheetTR__c> lstCheckTR, JFK_CheckSheetTR__c checkTR) {
        Database.saveResult sr;
        if (lstCheckTR == null || lstCheckTR.size() == 0) {
            sr = Database.insert(checkTR);
        } else {
            sr = Database.update(checkTR);
        }
            
        list<Database.saveResult> lstSr = new list<Database.saveResult>();
        lstSr.add(sr);

        if (JFK_cmdUtilities.chkSaveResult(lstSr)) {
            return sr.getId();
        } else {
            return null;
        }
    }

    /*
     * setValue2CheckSheet
     * 引数 ： 
     * 戻り値： 
     * 概要 ：
     */
    public static JFK_CheckSheetTR__c setValue2CheckSheet(JFK_CheckSheetTR__c checkSheetTR, integer categoryNo, integer no, integer seqNo) {
        JFK_CheckSheetTR__c checkSheet = new JFK_CheckSheetTR__c();
         
        checkSheet.Id = checkSheetTR.Id;
        checkSheet.CategoryNo__c = categoryNo;
        checkSheet.No__c = no;
        checkSheet.SEQNo__c = seqNo;
        checkSheet.NoForShow__c = checkSheetTR.NoForShow__c;
        checkSheet.CheckKomoku__c = checkSheetTR.CheckKomoku__c;
        checkSheet.CheckNaiyo__c = checkSheetTR.CheckNaiyo__c;
        checkSheet.Zokusei__c = checkSheetTR.Zokusei__c;
        checkSheet.PasonaHoseiKa__c = checkSheetTR.PasonaHoseiKa__c;

        checkSheet.P_HoseiZumi_1st__c = checkSheetTR.P_HoseiZumi_1st__c;
        checkSheet.P_HoseiZumi_2nd__c = checkSheetTR.P_HoseiZumi_2nd__c;
        checkSheet.Ninzu__c = checkSheetTR.Ninzu__c;
        checkSheet.Hantei_1st__c = checkSheetTR.Hantei_1st__c;
        checkSheet.Hantei_2nd__c = checkSheetTR.Hantei_2nd__c;
        checkSheet.Biko__c = checkSheetTR.Biko__c;
        checkSheet.HoseiKanryoBi__c = checkSheetTR.HoseiKanryoBi__c;
        checkSheet.ActionAfterJudgement__c = checkSheetTR.ActionAfterJudgement__c;
        checkSheet.ShowHanteiCheckBox__c = checkSheetTR.ShowHanteiCheckBox__c;
        checkSheet.ShowTextBox__c = checkSheetTR.ShowTextBox__c;

        return checkSheet;
    }   

    /*
     * getRodosyaInfoFromGS
     * 引数 ： list<JFK_RodoSyaTR__c> lstRodosyaTR
              string[] tantosyaID
              string[] tantosyaName
              date[] kanryoDate
              string[] status
              string totalStatus
              date shoruiShinsaKanryoDate
     * 戻り値： JFK_RodoSyaTR__c
     * 概要 ：
     */
    public static JFK_RodoSyaTR__c getRodosyaInfoFromGS(list<JFK_RodoSyaTR__c> lstRodosyaTR, string[] tantosyaID, string[] tantosyaName
                                                      , date[] kanryoDate, string[] status)
     {
            // GSから担当者及び完了有無情報 取得
            for (JFK_RodoSyaTR__c a : lstRodosyaTR) {     
                for (JFK_CommonTR__c gs : a.RodosyaTRs2__r) {
                    tantosyaID[0] = gs.GS_FirstTantosya__c;
                    tantosyaID[1] = gs.GS_SecondTantosya__c;
                    tantosyaName[0] = gs.GS_FirstTantosya__r.Name;
                    tantosyaName[1] = gs.GS_SecondTantosya__r.Name;
                    kanryoDate[0] = gs.GS_JissekiSyoruiShinsa_KanryoBi_1st__c;
                    kanryoDate[1] = gs.GS_JissekiSyoruiShinsa_KanryoBi_2nd__c;
                    status[0] = gs.GS_FirstTantosya_Status__c;
                    status[1] = gs.GS_SecondTantosya_Status__c;
                }
            }

            return lstrodosyaTR[0]; 
     }
    
    /*
     * chkComplete
     * 引数 ： list<JFK_CheckSheetTR__c> lstCheckSheet
            string tanto
     * 戻り値： boolean
     * 概要 ：
     */
    public static boolean chkComplete(list<JFK_CheckSheetTR__c> lstCheckSheet, string tanto) {
        try {
            integer i = 0;
            for (JFK_CheckSheetTR__c tr : lstCheckSheet) {
                if (tanto == '1') {
                    if (tr.ShowTextBox__c != true) {
                        if (tr.Hantei_1st__c == null || tr.Hantei_1st__c == 'NG') {
                            return false;
                        }
                    }
                    i++;
                }
                else if (tanto == '2') {
                    if (tr.ShowTextBox__c != true) {
                        if (tr.Hantei_2nd__c == null || tr.Hantei_2nd__c == 'NG') {
                            return false;
                        }
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
     * insertGS
     * 引数 ： JFK_JigyosyoTR__c jigyosyoTR
              JFK_RodosyaTR__c rodosyaTR
              string currentURL
              string tanto
              boolean isSuccess4GS
              boolean isComplete
              boolean isSaveTemp
              boolean isPassBack
              JFK_CommonTR__c gs
     * 戻り値： JFK_CommonTR__c
     * 概要 ：
     */
    public static JFK_CommonTR__c insertGS(JFK_JigyosyoTR__c jigyosyoTR, JFK_RodosyaTR__c rodosyaTR, string currentURL, string tanto
                              , boolean isSuccess4GS, boolean isComplete, boolean isSaveTemp, boolean isPassBack, JFK_CommonTR__c gs) {
        gs.RecordTypeId = JFK_cmdUtilities.getRecordTypeId(JFK_cmnConstant.RECORD_TYPE_GS_JISSEKI);
        gs.RecordKBN__c = JFK_cmnConstant.COMMON_MANAGE_INFO_GS;
        gs.Name = JFK_cmnConstant.COMMON_MANAGE_INFO_GS + '_' + string.valueOf(datetime.now().format());
        gs.JijyosyoTR_ShikyuJiki__c = jigyosyoTR.Id;
        gs.RodosyaTR__c = rodosyaTR.Id;
                
        // GSに情報設定
        if (tanto == '1') {
            gs.GS_CheckSheetURL1__c = currentURL;
        } else {
            gs.GS_CheckSheetURL2__c = currentURL;
        } 

        isSuccess4GS = setValues2GS(gs, isComplete, isSaveTemp, tanto, isPassBack);

        return gs;
    }

    /*
     * updateGS
     * 引数 ： list<JFK_CommonTR__c> lstGs
              string currentURL
              JFK_JigyosyoTR__c jigyosyoTR
              JFK_RodosyaTR__c rodosyaTR
              boolean isComplete
              boolean isSaveTemp
              string tanto
              boolean isPassBack
     * 戻り値： なし
     * 概要 ：
     */
    public static boolean updateGS(list<JFK_CommonTR__c> lstGs, string currentURL, JFK_JigyosyoTR__c jigyosyoTR, JFK_RodosyaTR__c rodosyaTR
                                 , boolean isComplete, boolean isSaveTemp, string tanto, boolean isPassBack) {
        // GSに情報設定
        if (tanto == '1') {
            lstGs[0].GS_CheckSheetURL1__c = currentURL;
        } else {
            lstGs[0].GS_CheckSheetURL2__c = currentURL;
        } 
        lstGs[0].JijyosyoTR_ShikyuJiki__c = jigyosyoTR.Id;
        lstGs[0].RodosyaTR__c = rodosyaTR.Id;

        return JFK_cmnFunction.setValues2GS(lstGs[0], isComplete, isSaveTemp, tanto, isPassBack);
    }

    /*
     * upsertCheckSheet
     * 引数 ： integer itemNumbersOfPage
             list<JFK_CheckSheetTR__c> checkSheetBeforeUpsert
             list<JFK_CheckSheetTR__c> lstCheckSheetTR
             list<Database.saveResult>
     * 戻り値： boolean
     * 概要 ：
     */
    public static boolean upsertCheckSheet(integer itemNumbersOfPage, list<JFK_CheckSheetTR__c> checkSheetBeforeUpsert
                                         , list<JFK_CheckSheetTR__c> lstCheckSheetTR, list<Database.saveResult> lsr) {
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
            lsr = Database.insert(checkSheetTR_insert);
        }
        
        // Update処理
        if (updateCnt > 0) {
            lsr = Database.update(checkSheetTR_update);
        }
            
        return true;
    }

    /*
     * getOkNg
     * 引数 ： なし
     * 戻り値： list<SelectOption>
     * 概要 ：
     */
    public static list<SelectOption> getOkNg() {
        list<SelectOption> options = new list<SelectOption>();
        DescribeFieldResult f = SObjectType.JFK_CheckSheetTR__c.fields.Hantei_1st__c;
        List<PicklistEntry> entries = f.getPicklistValues();
        for (PicklistEntry e : entries) {
            if (e.isActive()) {
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }
        }
        return options;        
    }

    /*
     * getAriNashi
     * 引数 ： なし
     * 戻り値： list<SelectOption>
     * 概要 ：
     */
    public static list<SelectOption> getAriNashi() {
        list<SelectOption> options = new list<SelectOption>();

        options.add(new SelectOption('OK', '無'));
        options.add(new SelectOption('NG', '有'));
        return options;        
    }

    /*
     * setValues2GS
     * 引数 ： JFK_CommonTR__c gs
              boolean isComplete
              boolean isSaveTemp
              string tanto
              boolean isPassBack
     * 戻り値： boolean
     * 概要 ：
     */
      public static boolean setValues2GS(JFK_CommonTR__c gs, boolean isComplete, boolean isSaveTemp, string tanto, boolean isPassBack) {
        try {
            boolean isSuccess = false;

            if (tanto == '1') {
                // 1次担当者の時
                gs.GS_FirstTantosya__c = UserInfo.getUserId();
                if (isComplete) {
                    // 1次が完了した時
                    if (gs.GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c == null) {
                        // 1次が未着手の時 
                        gs.GS_JissekiSyoruiShinsa_ChakusyuBi__c = date.today();
                        gs.GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c = date.today();
                        if (isSaveTemp) {
                            gs.GS_FirstTantosya_Status__c = JFK_cmnConstant.OPERATION_STATUS_SHINSAICHU_1st;
                        } else {
                            gs.GS_JissekiSyoruiShinsa_KanryoBi_1st__c = date.today();
                            gs.GS_FirstTantosya_Status__c = JFK_cmnConstant.OPERATION_STATUS_KANRYO_1st;
                        }
                    } else {
                        // 1次が着手済の時
                        if (isSaveTemp) {
                            gs.GS_FirstTantosya_Status__c = JFK_cmnConstant.OPERATION_STATUS_SHINSAICHU_1st;
                        } else {
                            gs.GS_JissekiSyoruiShinsa_KanryoBi_1st__c = date.today();
                            gs.GS_FirstTantosya_Status__c = JFK_cmnConstant.OPERATION_STATUS_KANRYO_1st;
                        }
                    }
                } else {
                    // 1次が未完了の時
                    if (gs.GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c == null	) {
                        // 1次が未着手の時
                        gs.GS_JissekiSyoruiShinsa_ChakusyuBi__c = date.today();
                        gs.GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c = date.today();
                    }
                    gs.GS_FirstTantosya_Status__c = JFK_cmnConstant.OPERATION_STATUS_SHINSAICHU_1st;
                }
            } else if (tanto == '2') {
                // 2次担当者の時
                gs.GS_SecondTantosya__c = UserInfo.getUserId();
                if (isComplete) {
                    // 2次が完了した時
                    if (gs.GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c == null) {
                        // 2次が未着手の時
                        gs.GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c = date.today();
                        if (isSaveTemp) {
                            gs.GS_SecondTantosya_Status__c = JFK_cmnConstant.OPERATION_STATUS_SHINSAICHU_2nd;
                        } else {
                            gs.GS_JissekiSyoruiShinsa_KanryoBi_2nd__c = date.today();
                            gs.GS_JissekiSyoruiShinsa_KanryoBi__c = date.today();
                            gs.GS_SecondTantosya_Status__c = JFK_cmnConstant.OPERATION_STATUS_KANRYO_2nd;
                        }
                    } else {
                        // 2次が着手済の時
                        if (isSaveTemp) {
                            gs.GS_SecondTantosya_Status__c = JFK_cmnConstant.OPERATION_STATUS_SHINSAICHU_2nd;
                        } else {
                            gs.GS_JissekiSyoruiShinsa_KanryoBi_2nd__c = date.today();
                            gs.GS_JissekiSyoruiShinsa_KanryoBi__c = date.today();
                            gs.GS_SecondTantosya_Status__c = JFK_cmnConstant.OPERATION_STATUS_KANRYO_2nd;
                        }
                    }
                } else {
                    // 2次が未完了の時
                    if (gs.GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c == null) {
                        // 2次が未着手の時
                        gs.GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c = date.today();
                    }
                    gs.GS_SecondTantosya_Status__c = JFK_cmnConstant.OPERATION_STATUS_SHINSAICHU_2nd;
                }
            }
            
            // 差し戻し
            if (isPassback) {
                gs.GS_JissekiSyoruiShinsa_KanryoBi_1st__c = null;
                gs.GS_FirstTantosya_Status__c = JFK_cmnConstant.OPERATION_STATUS_SASHIMODOSHI;
            }
            
            return true;

         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return false;
         }
    }

    /*
     * updateGS
     * 引数 ： 
     * 戻り値：
     * 概要 ：
     */
      public static void updateGS(JFK_JigyosyoTR__c jigyosyoTR, JFK_RodosyaTR__c rodosyaTR, string currentURL, string tanto
                                  , boolean isSuccess4GS, boolean isComplete, boolean isSaveTemp, boolean isPassBack
                                  , Database.saveResult[] lsr, list<JFK_CommonTR__c> lstGs4Upsert) {
        // 対応するGSレコード取得
        list<JFK_CommonTR__c> lstGs = JFK_cmnSOQL.getCommonTR_Rodosya_GS4Update(rodosyaTR.id);
        // GSの更新
        if (lstGs.size() == 0) {
            JFK_CommonTR__c gs = new JFK_CommonTR__c(); 
            JFK_cmnFunction.insertGS(jigyosyoTR, rodosyaTR, currentURL, tanto, isSuccess4GS, isComplete, isSaveTemp, isPassBack, gs);
            lstGs4Upsert.add(gs);

            lsr = Database.insert(lstGs4Upsert);
        } else { 
            JFK_cmnFunction.updateGS(lstGs, currentURL, jigyosyoTR, rodosyaTR, isComplete, isSaveTemp, tanto, isPassBack);
                      
            lsr = Database.update(lstGs);
        }
    }

    /*
     * updateRodosyaTR
     * 引数 ： 
     * 戻り値：
     * 概要 ：
     */
      public static void updateRodosyaTR(JFK_RodosyaTR__c rodosyaTR, boolean isSuccess, Database.saveResult[] lsr)
      {
        // 労働者TR（支給時期）更新
        list<JFK_RodosyaTR__c> lstRodosyaTR = JFK_cmnSOQL.getRodosyaTR4Update(rodosyaTR.id);

        if (lstRodosyaTR.size() > 0) {
            lstRodosyaTR[0].Biko__c = rodosyaTR.Biko__c;
            
            if (lsr != null) {
                lsr.clear();
            }
            lsr = Database.update(lstRodosyaTR); 

            if (!JFK_cmdUtilities.chkSaveResult(lsr)) {
                isSuccess = false;
            }
        }
    }

    /*
     * createSelectOption_CommonM
     * 引数 ： 
     * 戻り値：
     * 概要 ：
     */
      public static list<SelectOption> createSelectOption_CommonM(list<JFK_CommonM__c> lstCommonM) {
        try {
            list<SelectOption> options = new List<SelectOption>();
    
            options.add(new SelectOption('', ''));
            for (JFK_CommonM__c item : lstCommonM) {
                options.add(new SelectOption(item.Id, item.Name));
            }
            
            return options;
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }
    
    /*
     * Passback
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public static boolean passback(string[] status, string tanto, integer i, id[] tantosyaID, date[] kanryoDate) {
        if (tanto == '2' && render2ndPart(status, tanto, i, tantosyaID, kanryoDate)) {
            return true;
        } else {
            return false;
        }
    }

    /*
     * checkError_JCR
     * 引数 ：
     * 戻り値：boolean
     * 概要 ：
     */
    public static boolean checkError_JCR(boolean isKoyoKeitaiHenko, boolean isRisyoku, Contact rodosya, JFK_Bosyu__c bosyu
                                       , JFK_JigyosyoTR__c jigyosyoTR, string koyoKeitaiSearch, boolean isMukyuKekkin, JFK_RodosyaTR__c rodosyaTR) {
        boolean isError = false;
        try {
            isRisyoku = isRisyoku == null ? false : isRisyoku;  
            if (isRisyoku) {
                if (rodosya.RisyokuBi__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error027));
                    isError = true;
                } 
                if (rodosya.RisyokuRiyu__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error028));
                    isError = true;
                }

                if (bosyu.ShikyuJiki_Sushiki__c == '1-1') {
                    // 支給時期1-1    : 支給決定日から当該支給期間締日まで
                    if (rodosya.RisyokuBi__c < jigyosyoTR.Nendo_Kai_Jigyosyo__r.ShikyuKetteiDate__c ||
                        rodosya.RisyokuBi__c > bosyu.ShikyuShimeBi__c) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error037));
                        isError = true;
                    }
                } else {
                    // 支給時期1-1以外 : 当該支給期間開始日から当該支給期間締日まで
                    if (rodosya.RisyokuBi__c < bosyu.ShikyuKaishiBi__c ||
                        rodosya.RisyokuBi__c > bosyu.ShikyuShimeBi__c) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error037));
                        isError = true;
                    }
                }
            }
            
            isKoyoKeitaiHenko = isKoyoKeitaiHenko == null ? false : isKoyoKeitaiHenko;  
            if (isKoyoKeitaiHenko) {
                if(rodosya.KoyoKeitai__c == koyoKeitaiSearch) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error038));
                    isError = true;
                } 
                if(rodosya.KoyoKeitai_HenkoBi__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error026));
                    isError = true;
                } 
                if(rodosya.KoyoKeitai_HenkoBi__c < bosyu.ShikyuKaishiBi__c || rodosya.KoyoKeitai_HenkoBi__c > bosyu.ShikyuShimeBi__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error032));
                    isError = true;
                } 
            }
            
            isMukyuKekkin = isMukyuKekkin == null ? false : isMukyuKekkin;  
            if (isMukyuKekkin) {
                list<JFK_CommonTR__c> lstPtmk = JFK_cmnSOQL.getPTMKinShikyuJiki(rodosyaTR.Id, bosyu.ShikyuKaishiBi__c, bosyu.ShikyuShimeBi__c);
                If (lstPtmk.size() == 0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.JFK_Error039));
                    isError = true;
                }
            }

            return isError;
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return true;
         }
    }

    /*
     * assembleAreaKBN
     * 引数 ： 
     * 戻り値：
     * 概要 ：
     */
    public static string assembleAreaKBN(JFK_JigyosyoTR__c jigyosyoTR) {
        if (jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c == null) {
            return '';
        } else {
            return jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c.left(1);
        }
    }

    /*
     * assembleAreaName
     * 引数 ： 
     * 戻り値：
     * 概要 ：
     */
    public static string assembleAreaName(JFK_JigyosyoTR__c jigyosyoTR) {
        if (jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c == null) {
            return '';
        } else {
            return jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c.mid(2, jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c.length() - 2);
        }
    }

    /*
     * isDisableButton
     * 引数 ： 
     * 戻り値：
     * 概要 ：
     */
    public static boolean isDisableButton(string[] status, string tanto, integer i, id[] tantosyaID, date[] kanryoDate) {
        if (tanto == '1') {
            if (render1stPart(status, tanto, i, tantosyaID, kanryoDate)) {
                return false;
            } else {
                return true;
            }
        } else {
            if (render2ndPart(status, tanto, i, tantosyaID, kanryoDate)) {
                return false;
            } else {
                return true;
            }
        }
    }

    /*
     * render1stPart
     * 引数 ： 
     * 戻り値：
     * 概要 ：
     */
    public static boolean render1stPart(string[] status, string tanto, integer i, id[] tantosyaID, date[] kanryoDate) {
        if (tanto == '1') {
            if (status[0] == JFK_cmnConstant.OPERATION_STATUS_SASHIMODOSHI) {
                return true;
            } else {
                return checkRenderTantosya(i, tantosyaID, kanryoDate);
            }
        } else {
            return false;
        }   
    }

    /*
     * render2ndPart
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public static boolean render2ndPart(string[] status, string tanto, integer i, id[] tantosyaID, date[] kanryoDate) {
        if (tanto =='1') {
            return false;
        } else {
            return checkRenderTantosya(i, tantosyaID, kanryoDate);
        }
    }

    /*
     * checkRenderTantosya
     * 引数 ： 
     * 戻り値：
     * 概要 ：
     */
      public static boolean checkRenderTantosya(integer i, id[] tantosyaId, date[] kanryoDate) {
        try {
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
         } catch (Exception e) {
            if (e.getMessage().contains(JFK_cmnConstant.ExceptionMsg_CustomValidation) == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return null;
         }
    }

    /*
     * getTantosyaName
     * 引数 ： 
     * 戻り値：
     * 概要 ：
     */
      public static string[] getTantosyaName(string[] tantosyaName) {
        if (tantosyaName[0] == null) {
            tantosyaName[0] = '';
        }
        if (tantosyaName[1] == null) {
            tantosyaName[1] = '';
        }

        return tantosyaName;
    }
    
    /*
     * deleteHD
     * 引数 ： 
     * 戻り値：
     * 概要 ：
     */
    public static void deleteHD(id checkSheetId) {
        Database.deleteResult[] lsr;
        list<JFK_CommonTR__c> lstHd = [SELECT ID FROM JFK_CommonTR__c WHERE CheckSheetTR__c = :checkSheetId];
        if (lstHd.size() > 0) {
            lsr = Database.delete(lstHd);
        }
    }   
}