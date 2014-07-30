/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_cmnSOQL
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/09/22 Create
 ******************************************************************************/
public class JFK_cmnSOQL {
    /*
     * getBosyu
     * 引数   ： なし
     * 戻り値  ： 募集マスタ(年度・回)のリスト
     * 概要   ：
     */
    public static list<JFK_Bosyu__c> getBosyu_Nendo() {
        JFK_Bosyu__c[] lstBosyu = 
                        [SELECT BosyuNendo__c
                            FROM JFK_Bosyu__c 
                            WHERE BosyuNendo__c != null 
                            ORDER BY BosyuNendo__c
                        ];
                
        return lstBosyu;
    }

    /*
     * getBosyu_Kai
     * 引数   ： 年度
     * 戻り値  ： 募集マスタ(年度・回)のリスト
     * 概要   ：
     */
    public static list<JFK_Bosyu__c> getBosyu_Kai(integer nendo) {
        JFK_Bosyu__c[] lstKai = 
                        [SELECT BosyuKai__c
                            FROM JFK_Bosyu__c 
                            WHERE BosyuNendo__c = :nendo
                            ORDER BY BosyuKai__c
                        ];
        return lstKai;
    }

    /*
     * getBosyu_Kai
     * 引数   ： なし
     * 戻り値  ： 募集マスタ(年度・回)のリスト
     * 概要   ：
     */
    public static list<JFK_Bosyu__c> getBosyu_Kai() {
        JFK_Bosyu__c[] lstKai = 
                        [SELECT BosyuKai__c
                            FROM JFK_Bosyu__c 
                            WHERE BosyuKai__c != null
                            ORDER BY BosyuKai__c
                        ];
        return lstKai;
    }

    /*
     * getBosyu_Jiki
     * 引数   ： 年度
     *         回
     * 戻り値  ： 募集マスタ(支給時期)のリスト
     * 概要   ：
     */
    public static list<JFK_Bosyu__c> getBosyu_Jiki(integer nendo, integer kai) {
        JFK_Bosyu__c[] lstJiki = 
                        [SELECT ShikyuJiki_Sushiki__c
                            FROM JFK_Bosyu__c 
                            WHERE Bosyu__r.BosyuNendo__c = :nendo
                            AND Bosyu__r.BosyuKai__c = :kai
                            AND KoyoKBN__c = null  // 支給時期情報のみ取得するため、雇用条件情報レコードを除外
                            ORDER BY ShikyuJiki_Sushiki__c
                        ];
        return lstJiki;
    }

    /*
     * getBosyu_Jiki
     * 引数   ： なし
     * 戻り値  ： 募集マスタ(支給時期)のリスト
     * 概要   ：
     */
    public static list<JFK_Bosyu__c> getBosyu_Jiki() {
        list<JFK_Bosyu__c> lstJiki = 
                        [SELECT ShikyuJiki_Sushiki__c
                            FROM JFK_Bosyu__c 
                            WHERE ShikyuJiki_Sushiki__c != null
                            ORDER BY ShikyuJiki_Sushiki__c
                        ];
        return lstJiki;
    }

    /*
     * getBosyu_1Rec
     * 引数   ： 年度
     *       回
     *       支給時期
     * 戻り値  ： 募集マスタ(支給時期)
     * 概要   ：
     */
    public static JFK_Bosyu__c getBosyu_1Rec(integer nendo, integer kai, string jiki) {
        list<JFK_Bosyu__c> bosyu = 
                        [SELECT 
                            id
                            , Name
                            , Bosyu__r.BosyuNendo__c
                            , Bosyu__r.BosyuKai__c
                            , Bosyu__r.KoyoKaishiSaihayaBi__c
                            , ShikyuJiki_Sushiki__c
                            , ShikyuKaishiBi__c
                            , ShikyuShimeBi__c
                            , NenMe__c
                            , KaiMe__c
                            FROM    JFK_Bosyu__c
                            WHERE   bosyu__r.BosyuNendo__c = :nendo
                            AND     bosyu__r.BosyuKai__c = :kai
                            AND     ShikyuJiki_Sushiki__c = :jiki
                        ];
        
        if (bosyu.size() > 0) {
            return bosyu[0];
        } else {
            return null;
        }
    }

    /*
     * getAccount4Update
     * 引数   ： AccountId
     * 戻り値  ： Account(事業所)リスト
     * 概要   ：
     */
    public static list<Account> getAccount4Update(string AccountId) {
        list<Account> act = 
                        [SELECT 
                              id
                            , Name
                            , HoseiShido_Aitesaki_Busyo__c
                            , HoseiShido_Aitesaki_TantosyaMei__c
                            , HoseiShido_Aitesaki_Renrakusaki__c
                            , HoseiShido_Aitesaki_IninjoAri__c
                            , HoseiShido_Aitesaki_Jimusyo_TantosyaMei__c
                            , HoseiShido_Aitesaki_Renrakusaki2__c
                            FROM    Account
                            WHERE   Id = :AccountId
                            FOR UPDATE
                        ];
            
        return act;
    }

    /*
     * getJigyosyoTR_1Rec_withGS
     * 引数   ： 年度
     *       回
     *       〇年目
     *       〇回目
     *       事業所Id
     * 戻り値  ： 事業所TRレコード
     * 概要   ：
     */
    public static JFK_JigyosyoTR__c getJigyosyoTR_1Rec_withGS(integer nendo, integer kai, integer nenMe, integer kaiMe, string jigyosyoid) {
        JFK_JigyosyoTR__c jigyosyoTR =      
                        [SELECT
                              Id
                            , Name
                            , Biko__c
                            , Nendo_Kai_Jigyosyo__r.Id
                            , Nendo_Kai_Jigyosyo__r.JigyoshoCD__c
                            , Nendo_Kai_Jigyosyo__r.Area__c
                            , Nendo_Kai_Jigyosyo__r.JigyoKBN__c
                            , Nendo_Kai_Jigyosyo__r.JigyoKBN__r.Name
                            , Nendo_Kai_Jigyosyo__r.ShikyuKetteiDate__c
                            , Nendo_Kai_Jigyosyo__r.ShikyuKetteiNO__c 
            
                            , Nendo_Kai_Jigyosyo__r.Account__r.Id
                            , Nendo_Kai_Jigyosyo__r.Account__r.Name
                            , Nendo_Kai_Jigyosyo__r.Account__r.Phone
                            , Nendo_Kai_Jigyosyo__r.Account__r.KoyoHokenTekiyoJigyosyoNO__c
                            , Nendo_Kai_Jigyosyo__r.Account__r.DaihyousyaYakusyokuShimei__c
                            , Nendo_Kai_Jigyosyo__r.Account__r.Address_Shinsei__c
                            , Nendo_Kai_Jigyosyo__r.Account__r.Address_Taisyo__c
                            , Nendo_Kai_Jigyosyo__r.Account__r.HoseiShido_Aitesaki_Busyo__c
                            , Nendo_Kai_Jigyosyo__r.Account__r.HoseiShido_Aitesaki_TantosyaMei__c
                            , Nendo_Kai_Jigyosyo__r.Account__r.HoseiShido_Aitesaki_Renrakusaki__c
                            , Nendo_Kai_Jigyosyo__r.Account__r.HoseiShido_Aitesaki_IninjoAri__c
                            , Nendo_Kai_Jigyosyo__r.Account__r.HoseiShido_Aitesaki_Jimusyo_TantosyaMei__c
                            , Nendo_Kai_Jigyosyo__r.Account__r.HoseiShido_Aitesaki_Renrakusaki2__c
                            , (
                                SELECT 
                                      GS_FirstTantosya__c 
                                    , GS_SecondTantosya__c 
                                    , GS_FirstTantosya__r.Name 
                                    , GS_SecondTantosya__r.Name
                                    , GS_JissekiSyoruiShinsa_ChakusyuBi__c 
                                    , GS_JissekiHoseiShido_JisshiBi__c
                                    , GS_JissekiSyoruiShinsa_KanryoBi__c 
                                    , GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c
                                    , GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c
                                    , GS_JissekiSyoruiShinsa_KanryoBi_1st__c
                                    , GS_JissekiSyoruiShinsa_KanryoBi_2nd__c
                                    , GS_FirstTantosya_Status__c
                                    , GS_SecondTantosya_Status__c
                                    , GS_Status__c
                                    FROM JigyosyoTR_Time__r  // GS 
                                    WHERE RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_GS
                                    AND   RodosyaTR__c = NULL
                               )
                              ,(
                                SELECT
                                      Id
                                    , Name
                                      FROM JigyosyoTR__r  //ChecckSheetTR
                                      WHERE RodosyaTR__r.Id = null
                              )
                                FROM JFK_JigyosyoTR__c
                                WHERE   Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuNendo__c = :nendo
                                AND     Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuKai__c = :kai
                                AND     BosyuJoho_ShikyuJiki__r.NenMe__c = :nenMe
                                AND     BosyuJoho_ShikyuJiki__r.KaiMe__c = :kaiMe
                                AND     Nendo_Kai_Jigyosyo__r.Account__r.id = :jigyosyoid
                                LIMIT 1
                            ];

                return jigyosyoTR;
    }   

    /*
     * getRodosyaTR_withGS
     * 引数   ： 事業所Id
     * 戻り値  ： 労働者TRリスト
     * 概要   ：       
     */
    public static list<JFK_RodosyaTR__c> getRodosyaTR_withGS(string jigyosyoTRId) {
        JFK_RodosyaTR__c ShikyuKaishiInfo = 
                            [SELECT JigyosyoTR_ShikyuJiki__r.BosyuJoho_ShikyuJiki__r.ShikyuKaishiBi__c 
                                FROM JFK_RodosyaTR__c
                                WHERE JigyosyoTR_ShikyuJiki__r.Id = :jigyosyoTRId
                                LIMIT 1
                            ];
        date shikyuKaishiBi = ShikyuKaishiInfo.JigyosyoTR_ShikyuJiki__r.BosyuJoho_ShikyuJiki__r.ShikyuKaishiBi__c;

        list<JFK_RodosyaTR__c> lstRodosyaTR =      
                            [SELECT
                                  Id
                                , Name
                                , Biko__c
                                , HojuRodosyaFLG__c
                                , Rodosya__r.Id
                                , Rodosya__r.Name
                                , Rodosya__r.Furigana__c
                                , Rodosya__r.YatoiIre_Nengappi__c
                                , Rodosya__r.KoyoKBN__c
                                , Rodosya__r.KoyoKeiyaku_KaishiBi__c
                                , Rodosya__r.KoyoKeiyaku_SyuryoBi__c
                                , Rodosya__r.KoyoSyurui__c
                                , Rodosya__r.Address__c
                                , Rodosya__r.KoyoKeitai__c
                                , Rodosya__r.RodosyaCD__c
                                , Rodosya__r.RodosyaNO__c
                                , Rodosya__r.Account.Id
                                , Rodosya__r.Account.Name
                                , Rodosya__r.HojuMoto_Rodosya__c
                                , JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuNendo__c
                                , JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuKai__c
                                , JigyosyoTR_ShikyuJiki__r.BosyuJoho_ShikyuJiki__r.ShikyuJiki_Sushiki__c
                                , JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Area_Name__c
                                , JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.SeiriNO__c
                                , (
                                     SELECT 
                                          GS_FirstTantosya__c 
                                        , GS_SecondTantosya__c 
                                        , GS_FirstTantosya__r.Name 
                                        , GS_SecondTantosya__r.Name 
                                        , GS_FirstTantosya_Status__c
                                        , GS_SecondTantosya_Status__c 
                                        , GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c 
                                        , GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c 
                                        , GS_JissekiSyoruiShinsa_ChakusyuBi__c 
                                        , GS_JissekiHoseiShido_JisshiBi__c
                                        , GS_JissekiSyoruiShinsa_KanryoBi_1st__c 
                                        , GS_JissekiSyoruiShinsa_KanryoBi_2nd__c 
                                        , GS_JissekiSyoruiShinsa_KanryoBi__c
                                        , GS_Status__c
                                      FROM RodosyaTRs2__r
                                      WHERE RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_GS
                                      AND   RodosyaTR__c != NULL
                                  )
                              FROM JFK_RodosyaTR__c
                              WHERE JigyosyoTR_ShikyuJiki__r.Id = :jigyosyoTRId
                              AND (Rodosya__r.RisyokuBi__c = null OR Rodosya__r.RisyokuBi__c >= :shikyuKaishiBi)
                              AND (Rodosya__r.KetsuBan__c = false OR Rodosya__r.KetsuBan__c = null) 
                              ORDER BY Rodosya__r.RodosyaCD__c
                        ];

        return lstRodosyaTR;
    }
    
    /*
     * getRodosyaTR_withGS_1Rec
     * 引数   ： 労働者TR.Iid
     * 戻り値  ： 労働者TRリスト
     * 概要   ：
     */
    public static list<JFK_RodosyaTR__c> getRodosyaTR_withGS_1Rec(string rodosyaTRId) {
        list<JFK_RodosyaTR__c> lstRodosyaTR =      
                        [SELECT
                              Id
                            , Name
                            , Biko__c
                            , Rodosya__r.Id
                            , Rodosya__r.Name
                            , Rodosya__r.Furigana__c
                            , Rodosya__r.YatoiIre_Nengappi__c
                            , Rodosya__r.KoyoKBN__c
                            , Rodosya__r.KoyoKeiyaku_KaishiBi__c
                            , Rodosya__r.KoyoKeiyaku_SyuryoBi__c
                            , Rodosya__r.KoyoSyurui__c
                            , Rodosya__r.Address__c
                            , Rodosya__r.KoyoKeitai__c
                            , Rodosya__r.KoyoKeitai__r.Name
                            , Rodosya__r.RodosyaCD__c
                            , Rodosya__r.RodosyaNO__c
                            , Rodosya__r.Account.Id
                            , Rodosya__r.Account.Name
                            , Rodosya__r.HojuMoto_Rodosya__c
                            , Rodosya__r.HojuMoto_Rodosya__r.Name
                            , Rodosya__r.KoyoKBN__r.Name
                            , Rodosya__r.RisyokuBi__c
                            , JigyosyoTR_ShikyuJiki__c
                            , JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuNendo__c
                            , JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.BosyuKai__c
                            , JigyosyoTR_ShikyuJiki__r.BosyuJoho_ShikyuJiki__r.ShikyuJiki_Sushiki__c
                            , JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Area_Name__c
                            , JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.SeiriNO__c
                            , JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.JigyoshoCD__c
                            , (
                                 SELECT 
                                      GS_FirstTantosya__c 
                                    , GS_SecondTantosya__c 
                                    , GS_FirstTantosya__r.Name 
                                    , GS_SecondTantosya__r.Name 
                                    , GS_FirstTantosya_Status__c
                                    , GS_SecondTantosya_Status__c 
                                    , GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c 
                                    , GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c 
                                    , GS_JissekiSyoruiShinsa_ChakusyuBi__c 
                                    , GS_JissekiHoseiShido_JisshiBi__c
                                    , GS_JissekiSyoruiShinsa_KanryoBi_1st__c 
                                    , GS_JissekiSyoruiShinsa_KanryoBi_2nd__c 
                                    , GS_JissekiSyoruiShinsa_KanryoBi__c
                                    , GS_Status__c
                                  FROM RodosyaTRs2__r
                                  WHERE RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_GS
                                  AND   RodosyaTR__c != NULL
                                  
                              )
                          FROM JFK_RodosyaTR__c
                          WHERE JFK_RodosyaTR__c.Id = :rodosyaTRId
                    ];

        return lstRodosyaTR;
    }

    /*
     * getCommonTR
     * 引数   ： 労働者TR.Id
     * 戻り値  ： 汎用TR(PTMK)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR(string rodosyaTRId) {
        list<JFK_CommonTR__c> lstCommonTR =      
                    [SELECT
                              Id
                            , Name 
                            , PTMK_KekkinnBi_From__c
                            , PTMK_KekkinnBi_To__c
                          FROM JFK_CommonTR__c
                          WHERE RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_PTMK
                          AND RodosyaTR__c = :rodosyaTRId
                    ];
    
        return lstCommonTR;
    }

    /*
     * getPTMKinShikyuJiki
     * 引数   ： 労働者TR.Id
     *       支給開始日
     *       支給締日
     * 戻り値  ： 汎用TR(PTMK)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getPTMKinShikyuJiki(string rodosyaTRId, date ShikyuKaishiBi, date ShikyuShimeBi) {
        list<JFK_CommonTR__c> lstCommonTR =      
                    [SELECT
                              Id
                            , Name 
                            , PTMK_KekkinnBi_From__c
                            , PTMK_KekkinnBi_To__c
                          FROM JFK_CommonTR__c
                          WHERE RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_PTMK
                          AND RodosyaTR__c = :rodosyaTRId
                          AND PTMK_KekkinnBi_From__c >= :ShikyuKaishiBi
                          AND PTMK_KekkinnBi_To__c <= :ShikyuShimeBi
                    ];
    
        return lstCommonTR;
    }

    /*
     * getCheckSheetTR
     * 引数   ： 事業所TR.Id
     * 戻り値  ： チェックシートTRリスト(JCJ)
     * 概要   ：
     */
    public static list<JFK_CheckSheetTR__c> getCheckSheetTR(string jigyosyoTRId) {
        list<JFK_CheckSheetTR__c> lstChekSheetTR = 
                    [SELECT 
                          Id
                        , SEQNo__c
                        , No__c
                        , NoForShow__c
                        , CategoryNo__c
                        , CheckNaiyo__c
                        , PasonaHoseiKa__c
                        , JigyosyoTR__c
                        , JigyosyoMei__c
                        , CheckKomoku__c
                        , CheckSheetName__c
                        , Zokusei__c
                        , P_HoseiZumi_1st__c
                        , Hantei_1st__c
                        , P_HoseiZumi_2nd__c
                        , Hantei_2nd__c
                        , HoseiKanryoBi__c
                        , Ninzu__c
                        , Biko__c
                        , RodosyaTR__c
                        , RodosyaMei__c
                        , ActionAfterJudgement__c
                        , Hantei_Checkbox_1st__c
                        , Hantei_Checkbox_2nd__c
                        , ShowHanteiCheckBox__c
                        FROM JFK_CheckSheetTR__c
                        WHERE JigyosyoTR__c = :jigyosyoTRId
                        AND   RodosyaTR__r.Id = null
                        ORDER BY CategoryNo__c, No__c
                    ];
            
            return lstChekSheetTR;
    }   

    /*
     * getCheckSheetTR_JCR1
     * 引数   ： 事業所TR.Id
     *       労働者TR.Id
     * 戻り値  ： チェックシートTRリスト(JCR)
     * 概要   ：
     */
    public static list<JFK_CheckSheetTR__c> getCheckSheetTR_JCR1(string jigyosyoTRId, string rodosyaTRId) {
        list<JFK_CheckSheetTR__c> lstChekSheetTR = 
                    [SELECT 
                          Id
                        , SEQNo__c
                        , No__c
                        , NoForShow__c
                        , CategoryNo__c
                        , CheckNaiyo__c
                        , PasonaHoseiKa__c
                        , JigyosyoTR__c
                        , JigyosyoMei__c
                        , CheckKomoku__c
                        , CheckSheetName__c
                        , Zokusei__c
                        , P_HoseiZumi_1st__c
                        , Hantei_1st__c
                        , P_HoseiZumi_2nd__c
                        , Hantei_2nd__c
                        , HoseiKanryoBi__c
                        , Ninzu__c
                        , Biko__c
                        , RodosyaTR__c
                        , RodosyaMei__c
                        , ActionAfterJudgement__c
                        , Hantei_Checkbox_1st__c
                        , Hantei_Checkbox_2nd__c
                        , ShowHanteiCheckBox__c
                        , ShowTextBox__c
                        FROM JFK_CheckSheetTR__c
                        WHERE JigyosyoTR__r.Id = :jigyosyoTRId
                        AND RodosyaTR__r.Id = :rodosyaTRId
                        ORDER BY CategoryNo__c, No__c
                    ];
            
            return lstChekSheetTR;
    }   

    /*
     * getCheckSheetTR_CheckSheetId
     * 引数   ： チェックシートTRId
     * 戻り値  ： チェックシートTR（リスト）
     * 概要   ：
     */
    public static list<JFK_CheckSheetTR__c> getCheckSheetTR_CheckSheetId(string checkSheetId) {
        list<JFK_CheckSheetTR__c> lstChekSheetTR = 
                    [SELECT 
                          Id
                        , SEQNo__c
                        , No__c
                        , NoForShow__c
                        , CategoryNo__c
                        , CheckNaiyo__c
                        , PasonaHoseiKa__c
                        , JigyosyoTR__c
                        , JigyosyoMei__c
                        , CheckKomoku__c
                        , CheckSheetName__c
                        , Zokusei__c
                        , P_HoseiZumi_1st__c
                        , Hantei_1st__c
                        , P_HoseiZumi_2nd__c
                        , Hantei_2nd__c
                        , HoseiKanryoBi__c
                        , Ninzu__c
                        , Biko__c
                        , RodosyaTR__c
                        , RodosyaMei__c
                        , ActionAfterJudgement__c
                        , Hantei_Checkbox_1st__c
                        , Hantei_Checkbox_2nd__c
                        , ShowHanteiCheckBox__c
                        FROM JFK_CheckSheetTR__c
                        WHERE id = :checkSheetId
                    ];
            
            return lstChekSheetTR;
    }   

    /*
     * getCommonM_1Rec
     * 引数   ： 分類名称
     *        Name
     * 戻り値  ： 汎用Mリスト
     * 概要   ：
     */
    public static list<JFK_CommonM__c> getCommonM_1Rec(string BunruiMeisyo, string p_Name) {
        list<JFK_CommonM__c> lstcommonM_CheckSheet = 
                    [SELECT id 
                        FROM JFK_CommonM__c
                        WHERE BunruiMeisyo__c = :BunruiMeisyo
                        AND   Name = :p_Name
                    ];
        
        return lstcommonM_CheckSheet;
    }
    
    /*
     * getCommonTR_1Rec
     * 引数   ： 汎用TR.Id
     * 戻り値  ：汎用TRリスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_1Rec(string recId) {
        list<JFK_CommonTR__c> lstCommonTR = 
                    [SELECT 
                          Id
                        , Name 
                        , JigyosyoTR_YearTime__r.BosyuNendo__c
                        , JigyosyoTR_YearTime__r.BosyuKai__c
                        , JigyosyoTR_YearTime__r.Area_Kubun__c
                        , JigyosyoTR_YearTime__r.SeiriNO__c
                        , JigyosyoTR_YearTime__r.Account__r.Name
                        , JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuNendo__c
                        , JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuKai__c
                        , JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Area_Kubun__c
                        , JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.SeiriNO__c
                        , JijyosyoTR_ShikyuJiki__r.NenMe__c
                        , JijyosyoTR_ShikyuJiki__r.KaiMe__c
                        , JijyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Account__r.Name
                        , RodosyaTR__r.BosyuNendo__c
                        , RodosyaTR__r.BosyuKai__c
                        , RodosyaTR__r.NenMe__c
                        , RodosyaTR__r.KaiMe__c
                        , RodosyaTR__r.JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Area_Kubun__c
                        , RodosyaTR__r.JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.SeiriNO__c
                        , RodosyaTR__r.JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Account__r.Name
                        , RodosyaTR__r.Rodosya__r.Name
                        , CheckSheetTR__r.CategoryNo__c
                        , CheckSheetTR__r.No__c
                        FROM JFK_CommonTR__c
                        WHERE Id = :recId
                    ];
        
        return lstCommonTR;
    }
    
    /*
     * getCommonM
     * 引数   ： 分類名称
     * 戻り値  ： 汎用Mリスト
     * 概要   ：
     */
    public static list<JFK_CommonM__c> getCommonM(string BunruiMeisyo) {
        JFK_CommonM__c[] lstCommonM = 
                    [SELECT Id, Code__c, Name
                        FROM JFK_CommonM__c 
                        WHERE BunruiMeisyo__c = :BunruiMeisyo
                        ORDER BY Code__c
                    ];

        return lstCommonM;
    }

    /*
     * getCommonTR_MD
     * 引数   ： 事業所TR(年度・回).Id
     * 戻り値  ： 汎用Mリスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_MD(string jijyosyoTR_Nendo_Kai) {
        list<JFK_CommonTR__c> lstCommonM = 
                [SELECT
                      Id
                    , MD_Group__c
                    , MD_CenterTantosya__c
                    , MD_IninKengen__c
                    , MD_KakuninBi__c
                    , MD_ShikyuTeishi_KaishiBI__c
                    , MD_JigyoshoTantosya__c
                    , MD_SyukkoKaishiBi__c
                    , MD_TaisyoRodosyaShimei__c
                    , MD_DairiNin__c
                    , MD_TeishiRiyu__c
                    , MD_RenrakuSaki__c
                FROM JFK_CommonTR__c
                WHERE JigyosyoTR_YearTime__c = :jijyosyoTR_Nendo_Kai
                AND   RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_MD
                ORDER BY MD_Group__c
                ];

        return lstCommonM;
    }

    /*
     * getCommonTR_MD
     * 引数   ： 事業所TR(年度・回).Id
     *        MDグループ
     * 戻り値  ： 汎用TRリスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_MD(string jijyosyoTR_Nendo_Kai, string MD_Group) {
        list<JFK_CommonTR__c> lstCommonM = 
                [SELECT
                      MD_Group__c
                    , MD_CenterTantosya__c
                    , MD_IninKengen__c
                    , MD_KakuninBi__c
                    , MD_ShikyuTeishi_KaishiBI__c
                    , MD_JigyoshoTantosya__c
                    , MD_SyukkoKaishiBi__c
                    , MD_TaisyoRodosyaShimei__c
                    , MD_DairiNin__c
                    , MD_TeishiRiyu__c
                    , MD_RenrakuSaki__c
                FROM JFK_CommonTR__c
                WHERE JigyosyoTR_YearTime__c = :jijyosyoTR_Nendo_Kai
                AND   RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_MD
                AND   MD_Group__c = :MD_Group
                ];

        return lstCommonM;
    }

    /*
     * getCommonTR_MD4Update
     * 引数   ： 事業所TR(年度・回).Id
     *        MDグループ
     * 戻り値  ： 汎用TRリスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_MD4Update(string jijyosyoTR_Nendo_Kai, string MD_Group) {
        list<JFK_CommonTR__c> lstMD = 
                [SELECT id
                    FROM JFK_CommonTR__c
                    WHERE JigyosyoTR_YearTime__c = :jijyosyoTR_Nendo_Kai
                    AND   RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_MD
                    AND   MD_Group__c = :MD_Group
                    FOR UPDATE
                ];
            
        return lstMD;
    }

    /*
     * getCommonTR_MD4Update
     * 引数   ： レコード区分
     *       事業所TR(支給時期).Id
     * 戻り値  ：汎用TR(MD)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_4Update_JTL(string recordKBN, string jigyosyoTR) {
        list<JFK_CommonTR__c> lstJTL = 
                [SELECT
                      Id
                    , Name  
                    , JTL_Kaden_Juryo__c
                    , JTL_Hizuke__c
                    , JTL_KadenNaiyo__c
                    , JTL_Tantosya__c
                    FROM JFK_CommonTR__c
                    WHERE RecordKBN__c = :recordKBN
                    AND JijyosyoTR_ShikyuJiki__c = :jigyosyoTR
                    FOR UPDATE
                ];
            
        return lstJTL;
    }

    /*
     * getCommonTR_MD4Update
     * 引数   ： 汎用TR.Id
     * 戻り値  ： 汎用TRリスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_4Update(string recId) {
        list<JFK_CommonTR__c> lstMD = 
                [SELECT id
                    FROM JFK_CommonTR__c
                    WHERE Id = :recId
                    FOR UPDATE
                ];
            
        return lstMD;
    }
    
    /*
     * getCommonTR_JTL
     * 引数   ： 事業所TR（支給時期）.Id
     * 戻り値  ： 汎用TRリスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_JTL(string jijyosyoTRId) {
        list<JFK_CommonTR__c> lstCommonTR = 
                [SELECT
                      Id
                    , Name  
                    , JTL_Kaden_Juryo__c
                    , JTL_Hizuke__c
                    , JTL_KadenNaiyo__c
                    , JTL_Tantosya__c
                FROM JFK_CommonTR__c
                WHERE JijyosyoTR_ShikyuJiki__c = :jijyosyoTRId
                AND   RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_JTL
                ORDER BY JTL_Hizuke__c, JTL_Kaden_Juryo__c 
                ];

        return lstCommonTR;
    }

    /*
     * getCommonTR_GS4Update
     * 引数   ： 事業所TR(支給時期).Id
     * 戻り値  ： 汎用TR(GS)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_GS4Update(string jijyosyoTR_ShikyuJiki) {
        list<JFK_CommonTR__c> lstCommonTR = 
                [SELECT   id
                        , GS_JissekiSyoruiShinsa_ChakusyuBi__c 
                        , GS_JissekiHoseiShido_JisshiBi__c
                        , GS_JissekiSyoruiShinsa_KanryoBi__c 
                        , GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c
                        , GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c
                        , GS_JissekiSyoruiShinsa_KanryoBi_1st__c
                        , GS_JissekiSyoruiShinsa_KanryoBi_2nd__c
                        , GS_CheckSheetURL1__c
                        , GS_CheckSheetURL2__c
                        , GS_Miteisyutsusya_1stTokusokuJissiBi__c
                        , GS_Miteisyutsusya_2ndTokusokuJissiBi__c
                        , GS_Miteisyutsusya_3rdTokusokuJissiBi__c
                        , GS_Miteisyutsusya_4thTokusokuJissiBi__c
                        , GS_Miteisyutsusya_5thTokusokuJissiBi__c
                        , GS_Miteisyutsusya_6thTokusokuJissiBi__c
                        , GS_Miteisyutsusya_7thTokusokuJissiBi__c
                        , GS_Miteisyutsusya_8thTokusokuJissiBi__c
                        , GS_Miteisyutsusya_9thTokusokuJissiBi__c
                        , GS_Miteisyutsusya_10thTokusokuJissiBi__c
                    FROM JFK_CommonTR__c
                    WHERE JijyosyoTR_ShikyuJiki__c = :jijyosyoTR_ShikyuJiki
                    AND   RodosyaTR__c = null
                    AND   RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_GS
                    FOR UPDATE
                ];
            
        return lstCommonTR;
    }

    /*
     * getCommonTR_GS4Update
     * 引数   ： 事業所TR(支給時期).Idセット
     * 戻り値  ： 汎用TR(GS)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_GS4Update(set<Id> jijyosyoTR_ShikyuJiki) {
        list<JFK_CommonTR__c> lstCommonTR = 
                [SELECT Id FROM JFK_CommonTR__c 
                           WHERE JijyosyoTR_ShikyuJiki__c IN :jijyosyoTR_ShikyuJiki
                           AND   RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_GS
                           AND   RodosyaTR__c = NULL
                           FOR UPDATE
                ];
        
        return lstCommonTR;
    }   

    /*
     * getJigyosyoTR
     * 引数   ： 事業所TR(支給時期).Idセット
     * 戻り値  ： 事業所TRリスト
     */
    public static list<JFK_JigyosyoTR__c> getJigyosyoTR(set<Id> jijyosyoTR_ShikyuJiki) {
        list<JFK_JigyosyoTR__c> lstJigyosyoTR = 
                [SELECT (SELECT Id FROM JigyosyoTR_ShikyuJikis__r) 
                        FROM JFK_JigyosyoTR__c 
                        WHERE Id IN :jijyosyoTR_ShikyuJiki
                ];

        return lstJigyosyoTR;
    }
    
    /*
     * getCommonTR_GS4Update
     * 引数   ： 労働者TR.Idセット
     * 戻り値  ： 汎用TR(GS)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_Rodosya4Update(set<Id> rodosyaTRId) {
        list<JFK_CommonTR__c> lstGs_Rodosya = 
                [SELECT Id FROM JFK_CommonTR__c 
                        WHERE RodosyaTR__c IN :rodosyaTRId
                        AND   RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_GS
                        FOR UPDATE
                ];
            
        return lstGs_Rodosya;
    }
    
    /*
     * getCommonTR_Rodosya_GS4Update
     * 引数   ： 労働者TR.Id
     * 戻り値  ： 汎用TR(GS)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_Rodosya_GS4Update(string rodosyaTRId) {
        list<JFK_CommonTR__c> lstCommonTR = 
                [SELECT   id
                        , GS_JissekiSyoruiShinsa_ChakusyuBi__c 
                        , GS_JissekiHoseiShido_JisshiBi__c
                        , GS_JissekiSyoruiShinsa_KanryoBi__c 
                        , GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c
                        , GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c
                        , GS_JissekiSyoruiShinsa_KanryoBi_1st__c
                        , GS_JissekiSyoruiShinsa_KanryoBi_2nd__c
                    FROM JFK_CommonTR__c
                    WHERE RodosyaTR__r.Id = :rodosyaTRId
                    AND   RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_GS
                    FOR UPDATE
                ];
            
        return lstCommonTR;
    }

    /*
     * getCommonTR_YS
     * 引数   ： 労働者TR.Id
     * 戻り値  ： 汎用TR(YS)リスト
     * 概要 ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_YS(string rodosyaTRId) {
        list<JFK_CommonTR__c> lstYS = 
                [SELECT   id
                        , RodosyaTR__c
                        , YS_SyukkinBo__c
                        , YS_ChinginDaicho__c
                        , YS_Nyuryokusya__c
                        , YS_Biko__c
                        , RodosyaTR__r.Rodosya__r.Name
                    FROM JFK_CommonTR__c
                    WHERE RodosyaTR__c = :rodosyaTRId
                ];
            
        return lstYS;
    }

    /*
     * getCommonTR_YS4Update
     * 引数   ： 労働者TR.Id
     * 戻り値  ： 汎用TR(YS)リスト
     * 戻り値：
     * 概要 ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_YS4Update(string rodosyaTRId) {
        list<JFK_CommonTR__c> lstYS = 
                [SELECT   id
                        , RodosyaTR__c
                        , YS_SyukkinBo__c
                        , YS_ChinginDaicho__c
                        , YS_Nyuryokusya__c
                        , YS_Biko__c
                    FROM JFK_CommonTR__c
                    WHERE RodosyaTR__c = :rodosyaTRId
                    FOR UPDATE
                ];
            
        return lstYS;
    }

    /*
     * getCommonTR_HD
     * 引数   ： チェックシートId
     * 戻り値  ： 汎用TR(HD)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_HD(string checkSheetId) {
        list<JFK_CommonTR__c> lstCommonTR = 
                [SELECT
                      Id
                    , Name
                    , RecordTypeId
                    , HD_Tantosya1__c
                    , HD_Tantosya2__c
                    , HD_HoseiJiko_1st__c
                    , HD_HoseiJiko_2nd__c
                    , HD_Status__c
                    , CheckSheetTR__r.Id
                    , CheckSheetTR__r.CheckKomoku__c
                    FROM JFK_CommonTR__c
                    WHERE CheckSheetTR__c = :checkSheetId
                    AND RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_HD
                ];

        return lstCommonTR;
    }

    /*
     * getCommonTR_HD4Update
     * 引数   ： チェックシートId
     * 戻り値  ： 汎用TR(HD)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_HD4Update(string checkSheetId) {
        list<JFK_CommonTR__c> lstCommonTR = 
            [SELECT
                  Id
                FROM JFK_CommonTR__c
                WHERE CheckSheetTR__c = :checkSheetId
                AND RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_HD
                FOR UPDATE
            ];

        return lstCommonTR;
    }

    /*
     * getCommonTR_HK
     * 引数   ： 事業所TR(支給時期).Id
     * 戻り値  ： 汎用TR(HD)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_HK(string jigyoshoTRId) {
        list<JFK_CommonTR__c> lstCommonTR = 
            [SELECT
                  Id
                , Name
                , RecordTypeId
                , RodosyaTR__c
                , HD_Tantosya1__c
                , HD_Tantosya1__r.Name
                , HD_Tantosya2__c
                , HD_Tantosya2__r.Name
                , HD_HoseiJiko_1st__c
                , HD_HoseiJiko_2nd__c
                , HD_HoseiZumi_1st__c
                , HD_HoseiZumi_2nd__c
                , HD_Status__c
                , CheckSheetTR__r.Id
                , CheckSheetTR__r.CategoryNo__c
                , CheckSheetTR__r.CheckKomoku__c
                , CheckSheetTR__r.CheckNaiyo__c
                , CheckSheetTR__r.PasonaHoseiKa__c
                , CheckSheetTR__r.RodosyaMei__c
                , CheckSheetTR__r.CheckSheetName__r.Name
                , CheckSheetTR__r.JigyosyoTR__r.Nendo_Kai_Jigyosyo__r.Account__r.Name
                , CheckSheetTR__r.JigyosyoTR__r.Nendo_Kai_Jigyosyo__r.Account__r.Phone
                FROM JFK_CommonTR__c
                WHERE JijyosyoTR_ShikyuJiki__r.Id = :jigyoshoTRId
                AND RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_HD
                ORDER BY CheckSheetTR__r.CategoryNo__c, CheckSheetTR__r.No__c, CheckSheetTR__r.CheckKomoku__c, CheckSheetTR__r.CheckNaiyo__c,CheckSheetTR__r.RodosyaMei__c 
//              ORDER BY RodosyaTR__c, CheckSheetTR__r.CategoryNo__c, CheckSheetTR__r.No__c, CheckSheetTR__r.CheckKomoku__c, CheckSheetTR__r.CheckNaiyo__c 
            ];

        return lstCommonTR;
    }

    /*
     * getCommonTR_HM
     * 引数   ： 事業所TR(支給時期).Id
     * 戻り値  ： 汎用TR(HM)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_HM(string jigyoshoTRId) {
        list<JFK_CommonTR__c> lstCommonTR = 
            [SELECT
                  Id
                , Name
                , RecordTypeId
                , HM_Tantosya__c
                , HM_TaioBi__c
                , HM_HoseiMemo__c
                , HM_Aitesaki__c
                FROM JFK_CommonTR__c
                WHERE JijyosyoTR_ShikyuJiki__c = :jigyoshoTRId
                AND RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_HM
                ORDER BY HM_TaioBi__c 
            ];

        return lstCommonTR;
    }

    /*
     * getCommonTR_PTMK
     * 引数   ： 事業所TR(支給時期).Id
     * 戻り値  ： 汎用TR(PTMK)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_PTMK(string rodosyaTRId) {
        list<JFK_CommonTR__c> lstCommonTR = 
            [SELECT
                  Id
                , Name
                , RodosyaTR__c
                , RecordTypeId
                , PTMK_KekkinnBi_From__c
                , PTMK_KekkinnBi_To__c
                FROM JFK_CommonTR__c
                WHERE RodosyaTR__c = :rodosyaTRId
                AND RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_PTMK
                ORDER BY PTMK_KekkinnBi_From__c 
            ];

        return lstCommonTR;
    }

    /*
     * getCommonTR_HM4Update
     * 引数   ： 事業所TR(支給時期).Id
     * 戻り値  ： 汎用TR(HM)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_HM4Update(string jigyoshoTRId) {
        list<JFK_CommonTR__c> lstCommonTR = 
            [SELECT
                  Id
                FROM JFK_CommonTR__c
                WHERE JijyosyoTR_ShikyuJiki__c = :jigyoshoTRId
                AND RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_HM
                FOR UPDATE 
            ];

        return lstCommonTR;
    }

    /*
     * getCommonTR_PTMK4Update
     * 引数   ： 労働者TR.Id
     * 戻り値  ： 汎用TR(PTMK)リスト
     * 概要   ：
     */
    public static list<JFK_CommonTR__c> getCommonTR_PTMK4Update(string rodosyaTRId) {
        list<JFK_CommonTR__c> lstCommonTR = 
            [SELECT
                  Id
                FROM JFK_CommonTR__c
                WHERE RodosyaTR__c = :rodosyaTRId
                AND RecordKBN__c = :JFK_cmnConstant.COMMON_MANAGE_INFO_PTMK
                FOR UPDATE 
            ];

        return lstCommonTR;
    }

    /*
     * getCommonTR_Cnt_Jisseki_YearTime
     * 引数   ： レコード区分
     *       事業所TR(年度・回).Id
     * 戻り値  ： 件数
     * 概要   ：
     */
    public static integer getCommonTR_Cnt_Jisseki_YearTime(string recordKBN, string jigyosyoTRId) {
        integer recCnt = 
            [SELECT COUNT()
                FROM JFK_CommonTR__c
                WHERE RecordKBN__c = :recordKBN
                AND JigyosyoTR_YearTime__c = :jigyosyoTRId
            ];
        
        return recCnt;
    }

    /*
     * getCommonTR_Cnt_Jisseki_SikyuJiki
     * 引数   ： レコード区分
     *       事業所TR(支給時期).Id
     * 戻り値  ： 件数
     * 概要   ：
     */
    public static integer getCommonTR_Cnt_Jisseki_SikyuJiki(string recordKBN, string jigyosyoTRId) {
        integer recCnt = 
            [SELECT COUNT()
                FROM JFK_CommonTR__c
                WHERE RecordKBN__c = :recordKBN
                AND JijyosyoTR_ShikyuJiki__c = :jigyosyoTRId
            ];
        
        return recCnt;
    }

    /*
     * getRodosyaTR_Cnt_Jisseki_SikyuJiki
     * 引数   ： 事業所TR(支給時期).Id
     * 戻り値  ： 件数
     * 概要   ：
     */
    public static integer getRodosyaTR_Cnt_Jisseki_SikyuJiki(string jigyosyoTRId) {
        integer recCnt = 
            [SELECT COUNT()
                FROM JFK_RodosyaTR__c
                WHERE JigyosyoTR_ShikyuJiki__r.Id = :jigyosyoTRId
                AND Rodosya__r.RisyokuBi__c = null
            ];

        return recCnt;
    }
        
    /*
     * getCheckSheet_1Rec4Update
     * 引数   ： 事業所TR(支給時期).Id
     *       SEQNo
     * 戻り値  ： チェックシートリスト
     * 概要   ：
     */
    public static list<JFK_CheckSheetTR__c> getCheckSheet_1Rec4Update(string jigyoshoTRId, integer SEQNo) {
        list<JFK_CheckSheetTR__c> lstCheckSheetTR = 
            [SELECT 
                Id
                FROM JFK_CheckSheetTR__c
                WHERE JigyosyoTR__r.id = :jigyoshoTRId
                AND RodosyaTR__c = null
                AND SEQNo__c = :SEQNo
                FOR UPDATE
            ];
            
            return lstCheckSheetTR;
    }
    
    /*
     * getCheckSheet4Update
     * 引数   ： 事業所TR(支給時期).Id
     * 戻り値  ： チェックシートリスト
     * 概要   ：
     */
    public static list<JFK_CheckSheetTR__c> getCheckSheet4Update(string jigyoshoTRId) {
        list<JFK_CheckSheetTR__c> lstCheckSheetTR = 
            [SELECT 
                  Id
                , Name
                , SEQNo__c
                , P_HoseiZumi_1st__c
                , Hantei_1st__c
                , P_HoseiZumi_2nd__c
                , Hantei_2nd__c
                , HoseiKanryoBi__c
                FROM JFK_CheckSheetTR__c
                WHERE JigyosyoTR__r.id = :jigyoshoTRId
                AND   RodosyaTR__c = null
                FOR UPDATE
            ];
        return lstCheckSheetTR;
    }

    /*
     * getCheckSheet_JCR4Update
     * 引数   ： 事業所TR(支給時期).Id
     * 戻り値  ： チェックシートリスト
     * 概要 ：
     */
    public static list<JFK_CheckSheetTR__c> getCheckSheet_JCR4Update(string rodosyaTRId) {
        list<JFK_CheckSheetTR__c> lstCheckSheetTR = 
            [SELECT 
                  Id
                , SEQNo__c
                , P_HoseiZumi_1st__c
                , Hantei_1st__c
                , P_HoseiZumi_2nd__c
                , Hantei_2nd__c
                , HoseiKanryoBi__c
                FROM JFK_CheckSheetTR__c
                WHERE RodosyaTR__r.id = :rodosyaTRId
                FOR UPDATE
            ];
        return lstCheckSheetTR;
    }

    /*
     * getCheckSheet_JCR4Update
     * 引数   ： 労働者Id
     *       SEQNo.
     * 戻り値  ： チェックシートリスト
     * 概要   ：
     */
    public static list<JFK_CheckSheetTR__c> getCheckSheet_JCR4Update(string rodosyaTRId, integer SEQNo) {
        list<JFK_CheckSheetTR__c> lstCheckSheetTR = 
            [SELECT 
                Id
                FROM JFK_CheckSheetTR__c
                WHERE RodosyaTR__r.id = :rodosyaTRId
                AND SEQNo__c = :SEQNo
                FOR UPDATE
            ];
            
            return lstCheckSheetTR;
    }

    /*
     * getRisyokusya
     * 引数   ： 事業所Id
     *       支給開始日
     *       支給締日
     * 戻り値  ： 離職者リスト
     * 概要   ：
     */
    public static list<Contact> getRisyokusya(string jigyosyoId, date kaishiBi, date shimeBi) {
        list<Contact> lstRisyokusya = 
            [SELECT 
                Id
                , Name 
                FROM Contact 
                WHERE AccountId = :jigyosyoId 
                AND (Ketsuban__c = false OR Ketsuban__c = null)
                AND (RisyokuBi__c >= :kaishiBi AND RisyokuBi__c <= :shimeBi)
                AND RisyokuRiyu__c = :JFK_cmnConstant.RISYOKU_RIYU_JIKOTSUGO];
        
        return lstRisyokusya;
    }
    
    /*
     * getHojumotosya
     * 引数   ：  事業所Id
     * 戻り値  ： 補充元労働者リスト
     * 概要   ：
     */
    public static list<Contact> getHojumotosya(string jigyosyoId) {
        list<Contact> lstHojuZumiRodosya = 
            [SELECT HojuMoto_Rodosya__c FROM Contact WHERE AccountID = :jigyosyoId];

        set<Id> setHojuZumi = new set<Id>(); 
        for (Contact HojuZumi : lstHojuZumiRodosya) {
            setHojuZumi.add(HojuZumi.HojuMoto_Rodosya__c);
        }
        
        list<Contact> lstHojumotosya = 
            [SELECT Id
                    , Name
                    , HojuMoto_Rodosya__c 
                    FROM Contact 
                    WHERE AccountId = :jigyosyoId 
                    AND HojuMoto_Rodosya__c NOT IN :setHojuZumi];

        return lstHojumotosya;
    }   

    /*
     * getRisyokusyaInJigyosyo
     * 引数   ：  事業所Id
     * 戻り値  ： 労働者リスト
     * 概要 ：
     */
    public static list<Contact> getRisyokusyaInJigyosyo(string jigyosyoId) {
        list<Contact> lstRodosya = 
            [SELECT 
                Id
                , Name 
                FROM Contact 
                WHERE AccountId = :jigyosyoId 
                ORDER BY RodosyaNO__c
            ];
            
        return lstRodosya;
    }

    /*
     * getRodosyaInfo
     * 引数   ：  事業所Id
     * 戻り値  ： 労働者リスト
     * 概要   ：
     */
    public static list<Contact> getRodosyaInfo(string rodosyaId) {
        list<Contact> lstRodosya = 
            [SELECT 
                    Id
                    , Name
                    , LastName 
                    , FirstName
                    , HojuMoto_Rodosya__c
                    , KoyoKBN__c
                    , KoyoKBN__r.Name
                    , KoyoKeitai__c
                    , Koyokeitai__r.Name
                    , KoyoSyurui__c
                    , KoyoSyurui__r.Name
                    , KoyoKeiyaku_KaishiBi__c
                    , KoyoKeiyaku_SyuryoBi__c
                    , YatoiIre_Nengappi__c
                    , Address__c
                    , Koyokeitai_HenkoBi__c
                    , RisyokuBi__c
                    , RisyokuRiyu__c
                    , Birthdate
                FROM Contact WHERE Id = :rodosyaId];

        return lstRodosya;
    }
    
    /*
     * getRodosyaMaxNo
     * 引数   ：  事業所Id
     * 戻り値  ： 労働者リスト
     * 概要   ：
     */
    public static list<Contact> getRodosyaMaxNo(string jigyosyoId) {
        list<Contact> lstRodosyaMaxNo = 
            [SELECT Id
                    , Name
                    , RodosyaNO__c 
                    FROM Contact 
                    WHERE AccountId = :jigyosyoId 
                    ORDER BY RodosyaNO__c DESC
                    LIMIT 1];

        return lstRodosyaMaxNo;
    }   

    /*
     * getRodosyaInRodosyaTR
     * 引数   ：  労働者Id
     * 戻り値  ： 労働者リスト
     * 概要 ：
     */
    public static list<Contact> getRodosyaInRodosyaTR(Id rodosyaTRId) {
        list<Contact> lstRodosya = 
            [SELECT RodosyaNO__c
                FROM Contact
                WHERE Id IN (SELECT Rodosya__c FROM JFK_RodosyaTR__c
                             WHERE Id = :rodosyaTRId)
            ];
            
        return lstRodosya;
    }

    /*
     * getRodosyaInRodosyaTR4Update
     * 引数   ：  労働者Id
     * 戻り値  ： 労働者リスト
     * 概要 ：
     */
    public static Contact getRodosyaInRodosyaTR4Update(Id rodosyaTRId) {
            Contact rodosya = 
                [SELECT LastName, FirstName, HojuMoto_Rodosya__c, KoyoSyurui__c, KoyoKBN__c, KoyoKeitai__c
                        , KoyoKeitai_HenkoBi__c, RisyokuBi__c, RisyokuRiyu__c, Address__c, RodosyaNO__c
                    FROM Contact
                    WHERE Id IN (SELECT Rodosya__c FROM JFK_RodosyaTR__c
                                 WHERE Id = :rodosyaTRid)
                    LIMIT 1
                    FOR UPDATE
                ];
            
        return rodosya;
    }

    /*
     * getJigyosyoTR
     * 引数  	：  事業所TRId
     * 戻り値	：  事業所TRリスト
     * 概要 	：
     */
    public static list<JFK_JigyosyoTR__c> getJigyosyoTR(string jigyoshoTRId) {
        list<JFK_JigyosyoTR__c> lstJigyosyoTR = 
            [SELECT
					Id
					, Name
					, Nendo_Kai_Jigyosyo__r.JigyoshoCD__c
                    FROM JFK_JigyosyoTR__c 
                    WHERE Id = :jigyoshoTRId 
            ];

        return lstJigyosyoTR;
    }   

    /*
     * getJigyosyoTR4Update
     * 引数   ：  事業所TRId
     * 戻り値  ：  事業所TRリスト
     * 概要 ：
     */
    public static list<JFK_JigyosyoTR__c> getJigyosyoTR4Update(string jigyoshoTRId) {
        list<JFK_JigyosyoTR__c> lstJigyosyoTR = 
            [SELECT Id
                    , Name
                    , Biko__c
                    FROM JFK_JigyosyoTR__c 
                    WHERE Id = :jigyoshoTRId 
                    FOR UPDATE];

        return lstJigyosyoTR;
    }   

    /*
     * getRodosyaTR4Update
     * 引数   ：  労働者TRId
     * 戻り値  ：  労働者TRリスト
     * 概要 ：
     */
    public static list<JFK_RodosyaTR__c> getRodosyaTR4Update(string rodosyaTRId) {
        list<JFK_RodosyaTR__c> lstRodosyaTR = 
            [SELECT Id
                    , Name
                    , Biko__c
                    FROM JFK_RodosyaTR__c 
                    WHERE Id = :rodosyaTRId 
                    FOR UPDATE];

        return lstRodosyaTR;
    }   

    /*
     * getRodosya4Update
     * 引数   ：  労働者Id
     * 戻り値	：  労働者
     * 概要 	：
     */
    public static Contact getRodosya4Update(Id rodosyaId) {
        Contact rodosya = 
            [SELECT Name, KoyoKeitai_HenkoBi__c, RisyokuBi__c, RisyokuRiyu__c
                    FROM Contact
                    WHERE Id = :rodosyaId 
                    FOR UPDATE];

        return rodosya;
    }   
}