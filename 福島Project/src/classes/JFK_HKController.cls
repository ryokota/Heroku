/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_HKController
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/10/01 Create
 ******************************************************************************/
public class JFK_HKController {
    public string jigyoshoMei       { get; set; }
    public string telNo             { get; set; }
    public string tanto_1st         { get; set; }
    public string tanto_2nd         { get; set; }
    public boolean[] isRender {
        get {
            return arIsRender;      
        }
    }

    @TestVisible public string jigyoshoTRId     { get; set; }

    public boolean[] arIsRender = new boolean[] {true, true, true, true, true, true, true, true, true, true, true, true, true, true, true};

    // 募集情報（画面表示用）
    public JFK_Bosyu__c         bosyu       { get; set; }
    // 事業所TR情報（画面表示用）
    public JFK_JigyosyoTR__c    jigyosyoTR  { get; set; }

    private string tanto;

    private list<JFK_CommonTR__c> lstHK = new list<JFK_CommonTR__c>();

    private list<wrapper> lstWrapper1_1 = new list<wrapper>();
    private list<wrapper> lstWrapper1_2 = new list<wrapper>();
    private list<wrapper> lstWrapper2_1 = new list<wrapper>();
    private list<wrapper> lstWrapper2_2 = new list<wrapper>();
    private list<wrapper> lstWrapper2_3 = new list<wrapper>();
    private list<wrapper> lstWrapper2_4 = new list<wrapper>();
    private list<wrapper> lstWrapper2_5 = new list<wrapper>();
    private list<wrapper> lstWrapper2_6 = new list<wrapper>();
    private list<wrapper> lstWrapper3_1 = new list<wrapper>();
    private list<wrapper> lstWrapper3_2 = new list<wrapper>();
    private list<wrapper> lstWrapper3_3 = new list<wrapper>();
    private list<wrapper> lstWrapper3_4 = new list<wrapper>();
    private list<wrapper> lstWrapper3_5 = new list<wrapper>();
    private list<wrapper> lstWrapper3_6 = new list<wrapper>();
    private list<wrapper> lstWrapper3_7 = new list<wrapper>();
                        
    /*
     * Constructor
     */
    public JFK_HKController() {
        jigyoshoTRId = Apexpages.currentPage().getParameters().get('jigyoshoTRId');
        tanto = Apexpages.currentPage().getParameters().get('tanto');

        list<JFK_JigyosyoTR__c> lstJigyosyoTR = [
            SELECT
                  Id
                , Name
                , Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuNendo__c
                , Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuKai__c
                , BosyuJoho_ShikyuJiki__r.ShikyuJiki_Sushiki__c
                , BosyuJoho_ShikyuJiki__r.Nenme__c
                , BosyuJoho_ShikyuJiki__r.Kaime__c
                , Nendo_Kai_Jigyosyo__r.Account__r.Id
            FROM JFK_JigyosyoTR__c
            WHERE Id = :jigyoshoTRId
        ];

        if (lstJigyosyoTR.size() > 0) {
            jigyosyoTR = lstJigyosyoTR[0];

            // 募集情報
            bosyu = JFK_cmnSOQL.getBosyu_1Rec(integer.valueOf(jigyosyoTR.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuNendo__c)
                                            , integer.valueOf(jigyosyoTR.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuKai__c)
                                            , jigyosyoTR.BosyuJoho_ShikyuJiki__r.ShikyuJiki_Sushiki__c);
            // 事業所TR情報 with GS
            jigyosyoTR = JFK_cmnSOQL.getJigyosyoTR_1Rec_withGS(
                              integer.valueOf(jigyosyoTR.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuNendo__c)
                            , integer.valueOf(jigyosyoTR.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuKai__c)
                            , integer.valueOf(jigyosyoTR.BosyuJoho_ShikyuJiki__r.Nenme__c)
                            , integer.valueOf(jigyosyoTR.BosyuJoho_ShikyuJiki__r.KaiMe__c)
                            , string.valueOf(jigyosyoTR.Nendo_Kai_Jigyosyo__r.Account__r.Id));
        }
        
        // HKに表示するHDの情報取得
        lstHK = JFK_cmnSOQL.getCommonTR_HK(jigyoshoTRId);

        if (lstHK == null || lstHK.size() == 0) {
            // 該当データなしメッセージ
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.JFK_Info003));
        } else {
            jigyoshoMei = lstHK[0].CheckSheetTR__r.JigyosyoTR__r.Nendo_Kai_Jigyosyo__r.Account__r.Name;
            telNo = lstHK[0].CheckSheetTR__r.JigyosyoTR__r.Nendo_Kai_Jigyosyo__r.Account__r.Phone;
            tanto_1st = lstHK[lstHK.size() - 1].HD_Tantosya1__r.Name;
            tanto_2nd = lstHK[lstHK.size() - 1].HD_Tantosya2__r.Name;
        }

        if (lstHKWrapper1_1().size() == 0) {
            arIsRender[0] = false;
        }
        
        if (lstHKWrapper1_2().size() == 0) {
            arIsRender[1] = false;
        }

        if (lstHKWrapper2_1().size() == 0) {
            arIsRender[2] = false;
        }

        if (lstHKWrapper2_2().size() == 0) {
            arIsRender[3] = false;
        }

        if (lstHKWrapper2_3().size() == 0) {
            arIsRender[4] = false;
        }

        if (lstHKWrapper2_4().size() == 0) {
            arIsRender[5] = false;
        }

        if (lstHKWrapper2_5().size() == 0) {
            arIsRender[6] = false;
        }

        if (lstHKWrapper2_6().size() == 0) {
            arIsRender[7] = false;
        }

        if (lstHKWrapper3_1().size() == 0) {
            arIsRender[8] = false;
        }

        if (lstHKWrapper3_2().size() == 0) {
            arIsRender[9] = false;
        }

        if (lstHKWrapper3_3().size() == 0) {
            arIsRender[10] = false;
        }

        if (lstHKWrapper3_4().size() == 0) {
            arIsRender[11] = false;
        }

        if (lstHKWrapper3_5().size() == 0) {
            arIsRender[12] = false;
        }

        if (lstHKWrapper3_6().size() == 0) {
            arIsRender[13] = false;
        }

        if (lstHKWrapper3_7().size() == 0) {
            arIsRender[14] = false;
        }
    }

    /*
     * areaKBN
     * 引数   ：
     * 戻り値  ： エリア区分
     * 概要   ： 事業所TRのエリア区分を返す。
     */
    public string areaKBN {
        get {
            if (jigyosyoTR == null || string.valueOf(jigyosyoTR).length() == 0 ) {
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
     * 概要   ： 事業所TRの事業所名を返す。
     */
    public string areaName {
        get {
            if (jigyosyoTR == null ||  string.valueOf(jigyosyoTR).length() == 0 ) {
                return '';
            } else {
                return jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c.mid(2, jigyosyoTR.Nendo_Kai_Jigyosyo__r.Area__c.length() - 2);
            }
        }
    }

    /*
     * is1stTanto
     * 引数   ：
     * 戻り値 ： true:１次担当者   false:２次担当者
     * 概要   ：
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
     * lstWrapperSection1
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection1_1 {
        get {
            lstHKWrapper1_1();
            return lstWrapper1_1;
         }
     }

    /*
     * lstWrapperSection1_2
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection1_2 {
        get {
            lstHKWrapper1_2();
            return lstWrapper1_2;
        }
     }

    /*
     * lstWrapperSection2_1
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection2_1 {
        get {
            lstHKWrapper2_1();
            return lstWrapper2_1;
        }
     }

    /*
     * lstWrapperSection2_2
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection2_2 {
        get {
            lstHKWrapper2_2();
            return lstWrapper2_2;
        }
     }

    /*
     * lstWrapperSection2_3
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection2_3 {
        get {
            lstHKWrapper2_3();
            return lstWrapper2_3;
        }
     }

    /*
     * lstWrapperSection2_4
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection2_4 {
        get {
            lstHKWrapper2_4();
            return lstWrapper2_4;
        }
     }

    /*
     * lstWrapperSection2_5
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection2_5 {
        get {
            lstHKWrapper2_5();
            return lstWrapper2_5;
        }
     }

    /*
     * lstWrapperSection2_6
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection2_6 {
        get {
            lstHKWrapper2_6();
            return lstWrapper2_6;
        }
     }


    /*
     * lstWrapperSection3_1
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection3_1 {
        get {
            lstHKWrapper3_1();
            return lstWrapper3_1;
        }
     }

    /*
     * lstWrapperSection3_2
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection3_2 {
        get {
            lstHKWrapper3_2();
            return lstWrapper3_2;
        }
     }

    /*
     * lstWrapperSection3_3
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection3_3 {
        get {
            lstHKWrapper3_3();
            return lstWrapper3_3;
        }
     }

    /*
     * lstWrapperSection3_4
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection3_4 {
        get {
            lstHKWrapper3_4();
            return lstWrapper3_4;
        }
     }

    /*
     * lstWrapperSection3_5
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection3_5 {
        get {
            lstHKWrapper3_5();
            return lstWrapper3_5;
        }
     }

    /*
     * lstWrapperSection3_6
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection3_6 {
        get {
            lstHKWrapper3_6();
            return lstWrapper3_6;
        }
     }

    /*
     * lstWrapperSection3_7
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
     public list<wrapper> lstWrapperSection3_7 {
        get {
            lstHKWrapper3_7();
            return lstWrapper3_7;
        }
     }

    /*
     * lstHKWrapper1_1
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper1_1() {
        lstWrapper1_1.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CategoryNo__c == 1 && hk.RodosyaTR__c == null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);

                wrap.syubetsu = System.Label.JFK_JCJ_Category001;
                lstWrapper1_1.add(wrap);
            }
        }

        return lstWrapper1_1;
    }   

    /*
     * lstHKWrapper1_2
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper1_2() {
        lstWrapper1_2.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CategoryNo__c == 2 && hk.RodosyaTR__c == null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCJ_Category001;
                lstWrapper1_2.add(wrap);
            }
        }

        return lstWrapper1_2;
    }   

    /*
     * lstHKWrapper2_1
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper2_1() {
        lstWrapper2_1.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CheckSheetName__r.Name == 'JCR' && hk.CheckSheetTR__r.CategoryNo__c == 1 && hk.RodosyaTR__c != null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCR_1_Category001;
                lstWrapper2_1.add(wrap);
            }
        }

        return lstWrapper2_1;
    }   

    /*
     * lstHKWrapper2_2
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper2_2() {
        lstWrapper2_2.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CheckSheetName__r.Name == 'JCR' && hk.CheckSheetTR__r.CategoryNo__c == 2 && hk.RodosyaTR__c != null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCR_1_Category002;
                lstWrapper2_2.add(wrap);
            }
        }

        return lstWrapper2_2;
    }   

    /*
     * lstHKWrapper2_3
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper2_3() {
        lstWrapper2_3.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CheckSheetName__r.Name == 'JCR' && hk.CheckSheetTR__r.CategoryNo__c == 3 && hk.RodosyaTR__c != null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCR_1_Category003;
                lstWrapper2_3.add(wrap);
            }
        }

        return lstWrapper2_3;
    }   

    /*
     * lstHKWrapper2_4
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper2_4() {
        lstWrapper2_4.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CheckSheetName__r.Name == 'JCR' && hk.CheckSheetTR__r.CategoryNo__c == 4 && hk.RodosyaTR__c != null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCR_1_Category004;
                lstWrapper2_4.add(wrap);
            }
        }

        return lstWrapper2_4;
    }   

    /*
     * lstHKWrapper2_5
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper2_5() {
        lstWrapper2_5.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CheckSheetName__r.Name == 'JCR' && hk.CheckSheetTR__r.CategoryNo__c == 5 && hk.RodosyaTR__c != null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCR_1_Category005;
                lstWrapper2_5.add(wrap);
            }
        }

        return lstWrapper2_5;
    }   

    /*
     * lstHKWrapper2_6
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper2_6() {
        lstWrapper2_6.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CheckSheetName__r.Name == 'JCR' && hk.CheckSheetTR__r.CategoryNo__c == 6 && hk.RodosyaTR__c != null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCR_1_Category006;
                lstWrapper2_6.add(wrap);
            }
        }

        return lstWrapper2_6;
    }   

    /*
     * lstHKWrapper3_1
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper3_1() {
        lstWrapper3_1.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CheckSheetName__r.Name == 'JCR（補充労働者用）' && hk.CheckSheetTR__r.CategoryNo__c == 1 && hk.RodosyaTR__c != null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCR_3_Category001;
                lstWrapper3_1.add(wrap);
            }
        }

        return lstWrapper3_1;
    }   

    /*
     * lstHKWrapper3_2
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper3_2() {
        lstWrapper3_2.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CheckSheetName__r.Name == 'JCR（補充労働者用）' && hk.CheckSheetTR__r.CategoryNo__c == 2 && hk.RodosyaTR__c != null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCR_3_Category002;
                lstWrapper3_2.add(wrap);
            }
        }

        return lstWrapper3_2;
    }   

    /*
     * lstHKWrapper3_3
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper3_3() {
        lstWrapper3_3.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CheckSheetName__r.Name == 'JCR（補充労働者用）' && hk.CheckSheetTR__r.CategoryNo__c == 3 && hk.RodosyaTR__c != null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCR_3_Category003;
                lstWrapper3_3.add(wrap);
            }
        }

        return lstWrapper3_3;
    }   

    /*
     * lstHKWrapper3_4
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper3_4() {
        lstWrapper3_4.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CheckSheetName__r.Name == 'JCR（補充労働者用）' && hk.CheckSheetTR__r.CategoryNo__c == 4 && hk.RodosyaTR__c != null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCR_3_Category004;
                lstWrapper3_4.add(wrap);
            }
        }

        return lstWrapper3_4;
    }   

    /*
     * lstHKWrapper3_5
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper3_5() {
        lstWrapper3_5.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CheckSheetName__r.Name == 'JCR（補充労働者用）' && hk.CheckSheetTR__r.CategoryNo__c == 5 && hk.RodosyaTR__c != null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCR_3_Category005;
                lstWrapper3_5.add(wrap);
            }
        }

        return lstWrapper3_5;
    }   

    /*
     * lstHKWrapper3_6
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper3_6() {
        lstWrapper3_6.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CheckSheetName__r.Name == 'JCR（補充労働者用）' && hk.CheckSheetTR__r.CategoryNo__c == 6 && hk.RodosyaTR__c != null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCR_3_Category006;
                lstWrapper3_6.add(wrap);
            }
        }

        return lstWrapper3_6;
    }   

    /*
     * lstHKWrapper3_7
     * 引数   ：
     * 戻り値  ： list<wrapper>
     * 概要   ： 画面のセクションごとの内容を返す。
     */
    private list<wrapper> lstHKWrapper3_7() {
        lstWrapper3_7.clear();
        for (JFK_CommonTR__c hk : lstHK) {
            if (hk.CheckSheetTR__r.CheckSheetName__r.Name == 'JCR（補充労働者用）' && hk.CheckSheetTR__r.CategoryNo__c == 7 && hk.RodosyaTR__c != null) {
                wrapper wrap = new wrapper();
                storeValue2Wrapper(wrap, hk);
                    
                wrap.syubetsu = System.Label.JFK_JCR_3_Category007;
                lstWrapper3_7.add(wrap);
            }
        }

        return lstWrapper3_7;
    }   

    /*
     * storeValue2Wrapper
     * 引数   ： wrapper
     *       JFK_CommonTR__c(HK)
     * 戻り値  ： なし
     * 概要   ： HKの内容をラッパーに設定
     */
     public void storeValue2Wrapper(wrapper wrap, JFK_CommonTR__c hk) {
        wrap.hk = hk;
        wrap.hoseizumi_1st = hk.HD_HoseiZumi_1st__c;
        wrap.hoseizumi_2nd = hk.HD_HoseiZumi_2nd__c;
     }
     
    /*
     * save
     * 引数   ： なし
     * 戻り値  ：pageReference
     * 概要   ：HK及びチェックシートTR更新処理
     */
     public pageReference save() {
         try {
            Database.saveResult[] lsr;
            Savepoint sp;
            
            if (checkError()) {
                return null;
            }
            
            map<string, wrapper> mapWrapper = new map<string, wrapper>();
            list<JFK_CommonTR__c> lstHK = new list<JFK_CommonTR__c>(); 

            setValue2ListHK(lstWrapper1_1, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper1_2, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper2_1, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper2_2, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper2_3, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper2_4, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper2_5, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper2_6, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper3_1, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper3_2, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper3_3, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper3_4, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper3_5, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper3_6, mapWrapper, lstHK);
            setValue2ListHK(lstWrapper3_7, mapWrapper, lstHK);

            sp = Database.setSavepoint();

            // HK(HD)更新
            lsr = Database.update(lstHK);
            if (!JFK_cmdUtilities.chkSaveResult(lsr)) {
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,system.label.JFK_Error007));
                return null;                            
            }
                    
            // チェックシートのID取得                 
            set<string> setCheckListId = mapWrapper.keySet();

            list<JFK_CheckSheetTR__c> lstCheckSheet = new list<JFK_CheckSheetTR__c>();
            lstCheckSheet = [SELECT Id, Name, HoseiKanryoBi__c, P_HoseiZumi_1st__c, P_HoseiZumi_2nd__c
                                , (SELECT HD_HoseiZumi_1st__c, HD_HoseiZumi_2nd__c FROM CheckSheetTRs__r) 
                                FROM JFK_CheckSheetTR__c WHERE Id IN :setCheckListId];
            
            // チェックシートの補正完了日更新
            for (JFK_CheckSheetTR__c chk : lstCheckSheet) {
                for (JFK_CommonTR__c hk : chk.CheckSheetTRs__r) {
                    if (hk.HD_HoseiZumi_1st__c) {
                        chk.P_HoseiZumi_1st__c = true;
                    } else {
                        chk.P_HoseiZumi_1st__c = false;
                    }
                    if (hk.HD_HoseiZumi_2nd__c) {
                        chk.P_HoseiZumi_2nd__c = true;
                    } else {
                        chk.P_HoseiZumi_2nd__c = false;
                    }
                    if (hk.HD_HoseiZumi_1st__c || hk.HD_HoseiZumi_2nd__c) {
                        chk.HoseiKanryoBi__c = date.today();
                    } else {
                        chk.HoseiKanryoBi__c = null;
                    }
                }
            }

            // チェックシートTR更新
            lsr = Database.update(lstCheckSheet);
            if (!JFK_cmdUtilities.chkSaveResult(lsr)) {
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,system.label.JFK_Error007));
                return null;                            
            }

            return new PageReference('javascript:window.close()');

         } catch (Exception e) {
            if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
             return null;
         }
     }               
 
    /*
     * setValue2ListHK
     * 引数   ： list<wrapper>
     *       map<string, wrapper>
     *       list<JFK_CommonTR__c>
     * 戻り値  ： なし
     * 概要   ： HK（リスト）に情報設定
     */
    public void setValue2ListHK(list<wrapper> lstWrapper, map<string, wrapper> mapWrapper, list<JFK_CommonTR__c> lstHK) {
        for (wrapper wrap : lstWrapper) {
            if (tanto == '1') {
                mapWrapper.put(wrap.hk.CheckSheetTR__r.Id, wrap);
                JFK_CommonTR__c hk = wrap.hk;
                hk.HD_HoseiZumi_1st__c = wrap.hoseizumi_1st;
                hk.HD_Tantosya1__c = UserInfo.getUserId();
                lstHK.add(hk);
            } else if  (tanto == '2') {
                mapWrapper.put(wrap.hk.CheckSheetTR__r.Id, wrap);
                JFK_CommonTR__c hk = wrap.hk;
                hk.HD_HoseiZumi_2nd__c = wrap.hoseizumi_2nd;
                hk.HD_Tantosya2__c = UserInfo.getUserId();
                lstHK.add(hk);
            }
        }                        
    }

    /*
     * checkError
     * 引数   ： なし
     * 戻り値  ： true:エラーあり   false:エラーなし 
     * 概要   ： lstWrapper(各セクション別)のエラーチェック
     */
     public boolean checkError() {
         try {
                boolean[] arError = new boolean[15];
                
                arError[0] = checkWrapper(lstWrapper1_1,'1-1');
                arError[2] = checkWrapper(lstWrapper1_2,'1-2');
                arError[2] = checkWrapper(lstWrapper2_1,'2-1');
                arError[3] = checkWrapper(lstWrapper2_2,'2-2');
                arError[4] = checkWrapper(lstWrapper2_3,'2-3');
                arError[5] = checkWrapper(lstWrapper2_4,'2-4');
                arError[6] = checkWrapper(lstWrapper2_5,'2-5');
                arError[7] = checkWrapper(lstWrapper2_6,'2-6');
                arError[8] = checkWrapper(lstWrapper3_1,'3-1');
                arError[9] = checkWrapper(lstWrapper3_2,'2-2');
                arError[10] = checkWrapper(lstWrapper3_3,'3-3');
                arError[11] = checkWrapper(lstWrapper3_4,'3-4');
                arError[12] = checkWrapper(lstWrapper3_5,'3-5');
                arError[13] = checkWrapper(lstWrapper3_6,'3-6');
                arError[14] = checkWrapper(lstWrapper3_7,'3-7');

                for (boolean isError : arError) {
                    if (isError) {
                        return true;
                    }
                }

                return false;
         } catch (Exception e) {
            if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return false;
         }
     }               

    /*
     * checkWrapper
     * 引数   ： list<wrapper>
     * 戻り値  ： true:エラーあり   false:エラーなし
     * 概要   ： HDのステータスチェック
     */
      public boolean checkWrapper(list<wrapper> lstWrapper, string p_category) {
         try {
            boolean isError = false;
            for (integer i = 0; i < lstWrapper.size(); i++) {
                if (lstWrapper[i].hk.HD_Status__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, Label.JFK_Error022 + '(' + p_category + ' ' + (i + 1) + '行目)'));
                    isError = true;
                }               
            }
            
            return isError;
         } catch (Exception e) {
            if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            }
            return true;
         }
      }
      
    /*
     * close
     * 引数   ： なし
     * 戻り値  ： pageReference
     * 概要   ： ページを閉じる。
     */
      public pageReference close() {
          return new PageReference('javascript:window.close()');
      } 

    /*
     * wrapper
     * 引数 ：
     * 戻り値：
     * 概要 ：
     */
    public class wrapper {
        public JFK_CommonTR__c hk       { get; set; }
        public string syubetsu          { get; set; }
        public boolean hoseizumi_1st    { get; set; }
        public boolean hoseizumi_2nd    { get; set; }
    }
}