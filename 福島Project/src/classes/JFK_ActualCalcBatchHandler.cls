/***********************************************************************************************************
 *  支給額計算を行うバッチ処理で必要な部品を揃えるクラス。
 *  定義したメソッド：1．金額の桁を1000円未満の場合切り捨て処理
 *              2.通常の開始日から６ヶ月後の年月日を求める処理
 *              3.開始日から締日までの日数を求める処理
 *              4.労働者TRと労働者を取得（労働者の支給開始日を更新するため）
 *              5.労働者TRから「新規雇用」の人数を取得
 *              6.事業所TR（支給時期）のIDをキーとして基準単価を取得してマッピングする処理
 *              7.基準単価のマップキーを生成する
 *              8.人工制限の人数を取得する。
 *              9.事業所で雇った労働者での支給開始日を設定する
 *              10.対象の労働者を基に前の労働者らのソートを掛ける
 *
 *  作成者 : 株式会社パソナテキーラ   キム
 *  作成日 : 2013/10/23
 *  変更履歴 : 
***********************************************************************************************************/
public class JFK_ActualCalcBatchHandler {
    //コンスタント変数定義
    public static final String KOYOKEITAI_FULL = 'フルタイム';
    public static final String KOYOKEITAI_HALF = '短時間労働者';
    public static final String JIGYOSYO_KBN_1 = '①';
    public static final String JIGYOSYO_KBN_2 = '②';
    public static final String JIGYOSYO_KBN_3 = '③';
    public static final String JIGYOSYO_KBN_4 = '④';
    public static final String JIGYOSYO_KBN_NOT1 = '①以外';
    public static final String KOYO_SHINKI_KBN = '新規雇用';
    public static final String KOYO_SAI_KBN = '再雇用';
    public static final String KETTEIHOHO_KETTEIBI = '支給決定日';
    public static final String KETTEIHOHO_MITATU ='未達解消次第';
    public static final Integer KOYORITU = 4;
    /**
    *   1.金額の桁を1000円未満の場合切り捨て処理
    *   @param 対象の金額
    *   @return 切り捨てた金額
    */
    public static integer getAmountTruncation(Decimal target){
        return Integer.valueOf(target.setScale(-3, System.Roundingmode.DOWN));
    }
    
    /**
    *   2.通常の開始日から６ヶ月後の年月日を求める処理
    *   @param 対象の年月日
    *   @return ６ヶ月後の年月日
    */
    public static Date getCalcHalfYear(Date target){
        return target.addMonths(6) - 1;
    }
    
    /**
    *   3.開始日から締日までの日数を求める処理
    *   @param 開始日、締日
    *   @return 日数
    */
    public static integer getCalcDays(Date startDate, Date dueDate){
        return startDate.daysBetween(dueDate) + 1;
    }
    
    /**
    *   4.労働者TRと労働者を取得（労働者の支給開始日を更新するため）
    *   @param 事業所TR（支給時期）ID
    *   @return 労働者TR
    */
    public static List<JFK_RodoSyaTR__c> getRodosyaTRData(string accountTRId){
        List<JFK_RodoSyaTR__c> resultList = [SELECT Id,
                                                    JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.ShikyuKetteiDate__c, //支給決定日
                                                    //JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.Shikyu_Torikeshi__c,   //支給取消
                                                    JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.JigyoKBN__r.Name,    //事業所区分
                                                    JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.KoyoKaishiSaihayaBi__c,    //募集回基点日
                                                    JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.ShikyuKaishiSaihayaBi__c,  //県庁指定日
                                                    JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.ShinseiKikanSaisyuBi__c,   //申請期間最終日
                                                    JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.ShikyuKaishiBi_Kettei__c,  //支給開始日決定方法
                                                    JigyosyoTR_ShikyuJiki__c,               //事業所TR（支給時期）
                                                    //Zenki_KoyoKeitai__r.Name,             //前期雇用形態
                                                    //Henko_Koyokeitai__r.Name,             //変更雇用形態
                                                    //Koyokeitai_HenkokaishiBi__c,          //雇用形態変更開始日
                                                    KikannaiRisyoku__c,                     //期間内離職有
                                                    Rodosya__r.Id,                          //労働者のID
                                                    //Rodosya__r.Name,                      //労働者名
                                                    Rodosya__r.RodosyaNO__c,                //労働者の雇用番号
                                                    //Rodosya__r.Ketsuban__c,                   //労働者の欠番
                                                    Rodosya__r.KoyoKBN__r.Name,             //労働者の雇用区分
                                                    Rodosya__r.KoyoKeiyaku_KaishiBi__c,     //労働者の雇用契約開始日
                                                    //Rodosya__r.HojuMoto_Rodosya__c,           //補充元労働者
                                                    Rodosya__r.RisyokuBi__c,                //離職日
                                                    Rodosya__r.KoyoKeitai__r.Name           //労働者の雇用形態
                                            FROM JFK_RodoSyaTR__c 
                                            WHERE JigyosyoTR_ShikyuJiki__c = :accountTRId and NenMe__c = 1 and KaiMe__c = 1 and Rodosya__r.Ketsuban__c = false and Rodosya__r.HojuMoto_Rodosya__c = null
                                            //ソート条件：1.雇用開始日が古い, 2.フルタイムの対象労働者, 3.労働者番号が若い
                                            ORDER BY Rodosya__r.KoyoKeiyaku_KaishiBi__c, Rodosya__r.KoyoKBN__r.sortBango__c, Rodosya__r.KoyoKeitai__r.sortBango__c, Rodosya__r.RodosyaNO__c];
        return resultList;
    }
    
    /**
    *   5.事業所TR（支給時期）のIDをキーとして基準単価を取得してマッピングする処理
    *       Key     雇用区分        雇用形態        事業所区分
    *       -----------------------------------------
    *        1      新規雇用        フル          全て  
    *        2      新規雇用        短時間     全て  
    *        3      再雇用     フル          ①   
    *        4      再雇用     フル          ①以外
    *        5      再雇用     短時間     ①
    *        6      再雇用     短時間     ①以外
    *   @param 事業所TR（支給時期）のID
    *   @return 募集Mの単価マップ
    */
    public static Map<Integer, JFK_Bosyu__c> getBosyuMasterTanka(String accountTRId){
        Map<Integer, JFK_Bosyu__c> bosyuMap = new Map<Integer, JFK_Bosyu__c>();
        List<JFK_Bosyu__c> tempList = [SELECT JyoseiTanka_1stYear__c,           //１年目単価
                                              JyoseiTanka_2nsYear__c,           //２年目単価
                                              SyoseiTanka_3rdYear__c,           //３年目単価
                                              KoyoKBN__r.Name,                  //雇用区分
                                              KoyoKeitai__r.Name,               //雇用形態
                                              JigyosyoKBN__r.Name               //事業所区分
                                        FROM JFK_Bosyu__c 
                                        WHERE JyoseiTanka_1stYear__c != null 
                                        AND JyoseiTanka_2nsYear__c != null 
                                        AND SyoseiTanka_3rdYear__c != null 
                                        AND Bosyu__c = : [SELECT  BosyuJoho_ShikyuJiki__r.bosyu__c FROM JFK_JigyosyoTR__c WHERE id  =:accountTRId limit 1].BosyuJoho_ShikyuJiki__r.bosyu__c];
        for(JFK_Bosyu__c obj : tempList){
            bosyuMap.put(getCreateBosyuMasterKey(obj.KoyoKBN__r.Name, obj.KoyoKeitai__r.Name, obj.JigyosyoKBN__r.Name), obj);
        }
        return bosyuMap;
    }
    
    /**
    *   6.基準単価のマップキーを生成する
    *   @param 雇用区分、雇用形態、事業所区分
    *   @return 生成されたキー
    */
    public static Integer getCreateBosyuMasterKey(String koyoKBN, String koyoKeitai, String jigyosyoKBN){
        Integer result;
        //新規雇用の場合
        if(koyoKBN == KOYO_SHINKI_KBN){
            if(koyoKeitai == KOYOKEITAI_FULL) {         //フルタイム
                result = 1;
            } else if(koyoKeitai == KOYOKEITAI_HALF){   //短時間
                result = 2;
            }
        //再雇用の場合
        } else if(koyoKBN == KOYO_SAI_KBN){
            if(koyoKeitai == KOYOKEITAI_FULL){          //フルタイム
                if(jigyosyoKBN == JIGYOSYO_KBN_1){      //事業所区分①
                    result = 3;
                } else {                                //事業所区分①以外
                    result = 4;
                }
            } else if(koyoKeitai == KOYOKEITAI_HALF){   //短時間
                if(jigyosyoKBN == JIGYOSYO_KBN_1){      //事業所区分①
                    result = 5;
                } else {                                //事業所区分①以外
                    result = 6;
                }
            }
        }
        return result;
    }
    
    /**
    *   7.人工制限の人数を取得する。
    *   @param 事業所区分
    *   @return 該当人工
    */
    public static Integer getNinkuLimit(String jigyosyoKBN){
        Integer result;
        if(jigyosyoKBN == JIGYOSYO_KBN_4){
            result = 3;
        } else {
            result = 1;
        }
        return result;
    }
    
    /**
    *   8.事業所で雇った労働者での支給開始日を設定する
    *       ①「募集回基点日」と「申請期間最終日」の間に労働者の雇用契約開始日が存在かをチェック
    *       ②支給決定日の前日までの期間に離職日が存在かをチェック
    *       ③各労働者ごとに「支給開始日」を設定する。
    *           - 支給開始日決定方法が「支払決定日」の場合での「支給開始日」設定処理
    *           - 支給開始日決定方法が「未達解消次第」の場合での「支給開始日」設定処理
    *       ④人工制限と再雇用率制限のチェックを行い、エラーがなければ各労働者情報を更新
    *           - 支給開始日決定方法が「支払決定日」の場合、人工チェックや再雇用率チェック
    *           - 支給開始日決定方法が「未達解消次第」の場合、人工チェックや再雇用率チェック
    *   @param 事業所TR（支給時期）ID
    */
    public static void doCreateShikyuKaishBi(String accountTRId){
        system.debug('******************支給開始日の処理開始、　パラメータは事務所TR（支給時期） : ' + accountTRId);
        List<Contact> resultContactList = new List<Contact>();  //更新用
        List<JFK_ErrorLog__c> errList = new List<JFK_ErrorLog__c>();    //エラーメッセージList
        String kaishbiKetteiKBN = '';   //支給開始日決定方法
        String jigyoKBN = '';           //事業所区分
        Integer shinKiCnt = 0;          //新規雇用Cnt
        Integer saiCnt = 0;             //再雇用Cnt
        Integer fullCnt = 0;            //フルタイムCnt
        Integer halfCnt = 0;            //短時間Cnt
        Integer ninkuLimit = 0;         //人工制限
        
        //支給開始日を設定するため、対象データを抽出する。もし無ければそのまま処理終了。
        List<JFK_RodoSyaTR__c> tempRodoSyaTRList = getRodosyaTRData(accountTRId);
        if(tempRodosyaTRList.size() == 0) return;
        
        //支給開始日決定方法が「未達解消次第」の処理で遡りチェックのため、使う労働者のリスト。
        List<JFK_RodoSyaTR__c> copyRodoSyaTRList = new List<JFK_RodoSyaTR__c>();
        for(JFK_RodoSyaTR__c rTR : tempRodoSyaTRList){
            Contact con = new Contact(Id = rTR.Rodosya__r.Id);
            Date shikyuKetteiBi = rTR.JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.ShikyuKetteiDate__c;                                       //支給決定日
            jigyoKBN = rTR.JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.JigyoKBN__r.Name;                                                     //事業所区分
            kaishbiKetteiKBN = rTR.JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.ShikyuKaishiBi_Kettei__c;               //支給開始日決定方法
            Date koyoKaishiSaihayaBi = rTR.JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.KoyoKaishiSaihayaBi__c;         //募集回基点日
            Date kencyoShiteibi = rTR.JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.ShikyuKaishiSaihayaBi__c;            //県庁指定日
            Date shinseiKikanSaisyuBi = rTR.JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.BosyuJoho_YearTime__r.ShinseiKikanSaisyuBi__c;       //申請期間最終日
            boolean kikannaiRisyoku = rTR.KikannaiRisyoku__c;                       //期間内離職有
            String koyoKBN = rTR.Rodosya__r.KoyoKBN__r.Name;                        //労働者の雇用区分
            Date koyoKeiyakuKaishiBi = rTR.Rodosya__r.KoyoKeiyaku_KaishiBi__c;      //労働者の雇用契約開始日
            String koyoKeitai = rTR.Rodosya__r.KoyoKeitai__r.Name;                  //労働者の雇用形態
            Date risyokuBi = rTR.Rodosya__r.RisyokuBi__c;                           //離職日
            
            system.debug('支給決定日：' + shikyuKetteiBi + ',事務所区分：' + jigyoKBN + ',支給開始日決定方法：' + kaishbiKetteiKBN + ',募集回基点日：' + koyoKaishiSaihayaBi + ',県庁指定日 :' + kencyoShiteibi + ',申請期間最終日:' + shinseiKikanSaisyuBi + ',雇用区分:' + koyoKBN + ',雇用契約開始日:' + koyoKeiyakuKaishiBi + ',雇用形態:' + koyoKeitai + ',離職日:' + risyokuBi);
            ////////////////////////////////////////////////////////////////////////////
            //1.「募集回基点日」と「申請期間最終日」の間に労働者の雇用契約開始日が存在しないとエラー
            ////////////////////////////////////////////////////////////////////////////
            if(koyoKaishiSaihayaBi > koyoKeiyakuKaishiBi || shinseiKikanSaisyuBi < koyoKeiyakuKaishiBi){
                //JFK_Error101      雇用開始日に問題あり（労働者） 雇用契約開始日が規定期間外です。
                errList.add(new JFK_ErrorLog__c(JigyosyoTR_ShikyuJiki__c = accountTRId, RodosyaTR__c = rTR.Id, Naiyo__c = system.Label.JFK_Error101));
            }
            
            ////////////////////////////////////////////////////////////////////////////
            //2.支給決定日の前日までの期間に離職日が存在する場合エラー
            ////////////////////////////////////////////////////////////////////////////
            if(risyokuBi != null && shikyuKetteiBi > risyokuBi){
                //JFK_Error102      離職日に問題あり（労働者）   支給決定日前日までに離職しています。
                errList.add(new JFK_ErrorLog__c(JigyosyoTR_ShikyuJiki__c = accountTRId, RodosyaTR__c = rTR.Id, Naiyo__c = system.Label.JFK_Error102));
            }
            
            if(errList.size() > 0) continue;    //エラーが発生した場合、次の労働者をチェックする。
            
            //事業所区分が④の場合人工制限は３人工, ④以外は１人工の結果を返す。
            if(ninkuLimit == 0) ninkuLimit = getNinkuLimit(jigyoKBN);
            
            ////////////////////////////////////////////////////////////////////////////
            //3.各労働者ごとに「支給開始日」を設定する。
            ////////////////////////////////////////////////////////////////////////////
            //①支給開始日決定方法が「支払決定日」の場合
            if(kaishbiKetteiKBN == KETTEIHOHO_KETTEIBI){
                system.debug('******************************* 支給開始日決定方法－＞「支払決定日」の場合');
                //支給開始日に支給決定日を設定する
                con.Syikyu_KaishiBi__c = shikyuKetteiBi;
                resultContactList.add(con);
                //雇用区分を数える。（新規雇用と再雇用）
                if(koyoKBN == KOYO_SHINKI_KBN){
                    shinKiCnt += 1;
                } else if(koyoKBN == KOYO_SAI_KBN){
                    saiCnt += 1;
                }
                //雇用形態を数える。（フルタイムと短時間）
                if(koyoKeitai == KOYOKEITAI_FULL){
                    fullCnt += 1;
                }else if(koyoKeitai == KOYOKEITAI_HALF){
                    halfCnt += 1;
                }
                
            //②支給開始日決定方法が「未達解消次第」の場合
            } else if(kaishbiKetteiKBN == KETTEIHOHO_MITATU){
                system.debug('******************************* 支給開始日決定方法－＞「未達解除次第」の場合');
                //更新用の労働者を格納して置く。
                resultContactList.add(con);
                
                //支給開始日を取得(雇用開始日＞県庁指定日)場合、県庁指定日を設定する
                Date kaishibi = (koyoKeiyakuKaishiBi > kencyoShiteibi) ? koyoKeiyakuKaishiBi : kencyoShiteibi;
                //新規と再雇用にどちか与える条件に増加
                if(koyoKBN == KOYO_SHINKI_KBN){
                    shinKiCnt += 1;
                } else{
                    saiCnt += 1;
                }
                //対象労働者を追加し、ソートする。(ソートは要らなくなるため)
                copyRodoSyaTRList.add(rTR);
                //copyRodoSyaTRList = getSortingRodosya(copyRodoSyaTRList, kaishibi);
                
                //雇用形態および再雇用者を初期化
                fullCnt = 0;
                halfCnt = 0;
                Integer innerSaiCnt = 0;
                //対象が新規の雇用区分　又は　雇用率に満たす場合
                if(koyoKBN == KOYO_SHINKI_KBN || (saiCnt <= shinKiCnt * KOYORITU) ){
                    //おおもとの対象労働者まで計算を行う。
                    for(JFK_RodoSyaTR__c copyTR : copyRodoSyaTRList){
                        //再雇用者を数える。
                        if(copyTR.Rodosya__r.KoyoKBN__r.Name == KOYO_SAI_KBN){
                            innerSaiCnt += 1;
                            if(innerSaiCnt <= shinKiCnt * KOYORITU){
                                if(copyTR.Rodosya__r.KoyoKeitai__r.Name == KOYOKEITAI_FULL){
                                    fullCnt += 1;
                                } else {
                                    halfCnt += 1;
                                }
                            }
                        } else {
                            if(copyTR.Rodosya__r.KoyoKeitai__r.Name == KOYOKEITAI_FULL){
                                fullCnt += 1;
                            } else {
                                halfCnt += 1;
                            }
                        }
                        
                        //対象の労働者が再雇用者の場合、再雇用者人数を数えて終了する。
                        //if( rTR.Rodosya__r.Id == copyTR.Rodosya__r.Id) {
                        //  break; //自分自身まで処理を終了後抜ける。
                        //}
                    }// inner for 終了
                    
                    //人工を判定。
                    if( fullCnt + (halfCnt*0.5) >= ninkuLimit){
                        innerSaiCnt = 0;
                        for(JFK_RodoSyaTR__c copyTR : copyRodoSyaTRList){
                            //再雇用者を数える。
                            if(copyTR.Rodosya__r.KoyoKBN__r.Name == KOYO_SAI_KBN){
                                innerSaiCnt += 1;
                                //雇用率に当る再雇用者の支給開始日を設定
                                if(innerSaiCnt <= shinKiCnt * KOYORITU){
                                    //労働者に格納された自分を探し、支給開始日が設定されてない場合、設定し、終了
                                    for(Contact c : resultContactList){
                                        if(copyTR.Rodosya__r.Id == c.Id && c.Syikyu_KaishiBi__c == null){
                                            c.Syikyu_KaishiBi__c = kaishibi;
                                            break;
                                        }
                                    }
                                }
                            //新規の場合
                            } else {
                                //労働者に格納された自分を探し、支給開始日が設定されてない場合、設定し、終了
                                for(Contact c : resultContactList){
                                    if(copyTR.Rodosya__r.Id == c.Id && c.Syikyu_KaishiBi__c == null){
                                        c.Syikyu_KaishiBi__c = kaishibi;
                                        break;
                                    }
                                }
                            }
                        }// inner for 終了
                    }
                }
            }
        }//for End
        
        //エラーが発生した場合、そのまま処理終了。
        if(errList.size() > 0){
            insert errList;
            throw new JFK_ActualValidateException('支給開始日を設定する処理でエラーが発生しました。詳細エラーはエラーログオブジェクトを参照して下さい。');
        }
        
        //////////////////////////////////////////////////////////////////
        //4.人工制限と再雇用率制限のチェックを行い、エラーがなければ各労働者情報を更新
        //////////////////////////////////////////////////////////////////
        //①支給開始日決定方法が「支払決定日」の場合
        if(kaishbiKetteiKBN == KETTEIHOHO_KETTEIBI){
            system.debug('******************************* 全労働者を集計した人工＆再雇用率チェック　－＞「支払決定日」の場合');
            //人工制限のチェックを行う。
            if(fullCnt + (halfCnt*0.5) < ninkuLimit){
                //JFK_Error103      人工制限に問題あり（事業所）  必要人工制限に抵触し、支給決定日に未達が発生しました。
                insert new JFK_ErrorLog__c(JigyosyoTR_ShikyuJiki__c = accountTRId, Naiyo__c = system.Label.JFK_Error103+ ' フルタイム(人)：' + fullCnt + ' 短時間(人)：' + halfCnt);
                throw new JFK_ActualValidateException('支給開始日を設定する処理でエラーが発生しました。詳細エラーはエラーログオブジェクトを参照して下さい。');
            }
            //雇用率チェック（新規雇用＊４人より再雇用者が大きい場合エラー処理）
            if(shinKiCnt * KOYORITU < saiCnt){
                //JFK_Error104      再雇用率制限に問題あり（事業所）    再雇用率制限に抵触し、支給決定日に未達が発生しました。
                insert new JFK_ErrorLog__c(JigyosyoTR_ShikyuJiki__c = accountTRId, Naiyo__c = system.Label.JFK_Error104 + ' 新規雇用：' + shinKiCnt + ' 再雇用:' + saiCnt);
                throw new JFK_ActualValidateException('支給開始日を設定する処理でエラーが発生しました。詳細エラーはエラーログオブジェクトを参照して下さい。');
            }
            update resultContactList;
        //②支給開始日決定方法が「未達解消次第」の場合
        } else if(kaishbiKetteiKBN == KETTEIHOHO_MITATU){
            system.debug('******************************* 全労働者を集計した人工＆再雇用率チェック　－＞「未達解消次第」の場合');
            //フルタイムと短時間を初期化
            fullCnt = 0;
            halfCnt = 0;
            //支給決定日での人工制限のチェックを行い、エラーがなければ労働者の支給開始日更新。
            for(JFK_RodoSyaTR__c rTR : tempRodoSyaTRList){
                //全ての労働者の雇用形態を数える。
                if(rTR.Rodosya__r.KoyoKeitai__r.Name == KOYOKEITAI_FULL){
                    fullCnt += 1;
                } else {
                    halfCnt += 1;
                }
            }
            //人工チェック
            if(fullCnt + (halfCnt*0.5) < ninkuLimit){
                //JFK_Error103
                insert new JFK_ErrorLog__c(JigyosyoTR_ShikyuJiki__c = accountTRId, Naiyo__c = system.Label.JFK_Error103 + ' フルタイム(人)：' + fullCnt + ' 短時間(人)：' + halfCnt);
                throw new JFK_ActualValidateException('支給開始日を設定する処理でエラーが発生しました。詳細エラーはエラーログオブジェクトを参照して下さい。');
            }
            //支給開始日が設定されてない労働者を抽出
            for(Contact cObj : resultContactList){
                if(cObj.Syikyu_KaishiBi__c == null){
                    //JFK_Error104
                    insert new JFK_ErrorLog__c(JigyosyoTR_ShikyuJiki__c = accountTRId, Naiyo__c = system.Label.JFK_Error104 + ' 新規雇用：' + shinKiCnt + ' 再雇用:' + saiCnt);
                    throw new JFK_ActualValidateException('支給開始日を設定する処理でエラーが発生しました。詳細エラーはエラーログオブジェクトを参照して下さい。');
                }
            }
            update resultContactList;
        }
        system.debug('***************正常に労働者ごとの支給開始日が設定されました。');
    }
    
    
    /**
    *   9.対象の労働者を基に前の労働者らのソートを掛ける
    *       対象の労働者の「雇用契約開始日」を基準での前の労働者らの「雇用契約開始日」、「雇用形態」、「労働者No」の並び順
    *   @param 前の労働者ら、対象の労働者の雇用契約開始日
    *   @return ソートされた労働者List
    */
    /*
    public static List<JFK_RodoSyaTR__c> getSortingRodosya(List<JFK_RodoSyaTR__c> copyList, Date startDate){
        system.debug('*****************************************Sort Start');
        List<JFK_RodoSyaTR__c> resultList = new List<JFK_RodoSyaTR__c>();
        List<JFK_ActualSortWrapper> tempList = new List<JFK_ActualSortWrapper>();
        Date tempDate = Date.newInstance(1970,1,1); //開始日初期値
        for(Integer i=0; i<copyList.size(); i++){
            JFK_RodoSyaTR__c curObj = copyList.get(i);
            
            //前の労働者の開始日と今回の労働者の開始日が異なる場合
            if(tempDate != curObj.Rodosya__r.KoyoKeiyaku_KaishiBi__c){
                //労働者番号でのソート
                tempList.sort();
                //短時間の労働者がTempに格納された場合、結果リストに設定
                for(JFK_ActualSortWrapper tempObj : tempList){
                    system.debug('#########? sort : ' + tempObj.obj.Rodosya__r.RodosyaNO__c);
                    resultList.add(tempObj.obj);
                }
                //短期間の格納List初期化
                tempList = new List<JFK_ActualSortWrapper>();
                //次の労働者に設定
                //resultList.add(curObj);
                tempDate = curObj.Rodosya__r.KoyoKeiyaku_KaishiBi__c;
            }
            //雇用形態判定
            if(curObj.Rodosya__r.KoyoKeitai__r.Name == KOYOKEITAI_FULL){
                resultList.add(curObj);
            } else {
                system.debug('#########? sort time : ' + curObj.Rodosya__r.RodosyaNO__c);
                tempList.add(new JFK_ActualSortWrapper(curObj));
            }
            //最後の場合、Tempにあるデータをソートして返す。
            if(i == copyList.size() -1 ){
                //労働者番号でのソート
                tempList.sort();
                //短時間の労働者がTempに格納された場合、結果リストに設定
                for(JFK_ActualSortWrapper tempObj : tempList){
                    system.debug('#########? sort : ' + tempObj.obj.Rodosya__r.RodosyaNO__c);
                    resultList.add(tempObj.obj);
                }
            }
        }// for end
        return resultList;
    }
    */
}