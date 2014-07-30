global with sharing class JFK_SetTeishibi_Batch implements Database.Batchable<sObject>, Database.Stateful {

    private String jigyosyoTrId;// 処理対象となる事業所TRのId
    private Decimal hitsuyoNinkuSu=0;// 必要な人工数
    private String KoyoKbn;// 雇用区分
    private Date Shikyutaisyo_ShimeBi;//支給対象締日
    
    private JFK_JigyosyoTR__c ZenShikyuJikiJigyoshoTR;//前期に相当する事業所TR(支給時期)
    
    private Map<String, Id> rtMap;
    private Map<String, JFK_Bosyu__c> BosyuTankaMap;
    private Map<String, String> ZenShikyuJikiRodosyaTRMap;
    private String ATeishiRecordTypeId;//汎用TR.支給停止A
    private String BTeishiRecordTypeId;//汎用TR.支給停止B
    
    
    public static final String KOYOKEITAI_FULL = 'フルタイム';
    public static final String KOYOKEITAI_HALF = '短時間労働者';
    public static final String KOYO_SHINKI_KBN = '新規雇用';
    public static final String KOYO_SAI_KBN = '再雇用';
    public static final String BOSYU_RECORDTYPE_TANKA = '助成対象期単価';
    
    public static final String JIGYOSHO_KBN_1 = '①';
    public static final String JIGYOSHO_KBN_2 = '②';
    public static final String JIGYOSHO_KBN_3 = '③';
    public static final String JIGYOSHO_KBN_4 = '④';
    public static final String JIGYOSHO_KBN_ANOTHER_1 = '①以外';

    /**
     * バッチ生成
     */
    public JFK_SetTeishibi_Batch(String Id){
        this.jigyosyoTrId=Id;
    }

    /***********************************************************************
     * 初期処理
     */
    global Database.querylocator start(Database.BatchableContext BC){
    
        system.debug('Debug::start');
        JFK_JigyosyoTR__c jigyosyoTr=[
            SELECT Id 
                 , BosyuJoho_ShikyuJiki__r.ShikyuKaishiBi__c
                 , BosyuJoho_ShikyuJiki__r.ShikyuShimeBi__c
                 , JigyoKBN__r.Name
                 , BosyuJoho_YearTime__r.Id
                 , BosyuJoho_ShikyuJiki__r.Bosyu__r.Id
                 , Nendo_Kai_Jigyosyo__r.Id
                 , Shikyutaisyo_ShimeBi__c
              FROM JFK_JigyosyoTR__c
             WHERE Id=:this.jigyosyoTrId
        ];
        // 雇用区分
        this.KoyoKbn=jigyosyoTr.JigyoKBN__r.Name;
        this.Shikyutaisyo_ShimeBi=jigyosyoTr.Shikyutaisyo_ShimeBi__c;
        // 必要な人工数を取得
        getHitsuyoNinku(jigyosyoTr.JigyoKBN__r.Name);
        // 助成金単価を取得
        getJyoseiTanka(jigyosyoTr.BosyuJoho_ShikyuJiki__r.Bosyu__r.Id);
        
        rtMap = new Map<String, Id>();
        List<RecordType> RecordTypeList=[
            SELECT Id,Name,DeveloperName
              FROM RecordType
             WHERE IsActive=true
               AND SobjectType='JFK_ShikyuTeishiWork__c'
        ];
        for(RecordType r : RecordTypeList){
            rtMap.put(r.DeveloperName, r.Id);
        }
        
        // Aパターンレコードタイプの抽出
        this.ATeishiRecordTypeId= [
            SELECT Id
              FROM RecordType
             WHERE DeveloperName='PTMKST_ShikyuTeishiKikan_A'
        ].Id;
        // Bパターンレコードタイプの抽出
        this.BTeishiRecordTypeId= [
            SELECT Id
              FROM RecordType
             WHERE DeveloperName='PTMK_1kagetsuMukyuKekkin'
        ].Id;
        
        List<JFK_ShikyuTeishiWork__c> changeList = new List<JFK_ShikyuTeishiWork__c>();
        
        // 1.期間内：離職者抽出 //
        List<JFK_RodoSyaTR__c> cRisyoku=[
            SELECT Id
                 , Rodosya__r.Id
                 , Rodosya__r.RisyokuBi__c
                 , Rodosya__r.RodosyaNO__c
              FROM JFK_RodoSyaTR__c
             WHERE Rodosya__r.RisyokuBi__c >= :jigyosyoTr.BosyuJoho_ShikyuJiki__r.ShikyuKaishiBi__c
               AND Rodosya__r.RisyokuBi__c <= :jigyosyoTr.BosyuJoho_ShikyuJiki__r.ShikyuShimeBi__c
               AND JigyosyoTR_ShikyuJiki__r.Id = :jigyosyoTr.Id
        ];
        for(JFK_RodoSyaTR__c c : cRisyoku){
            changeList.add(
                new JFK_ShikyuTeishiWork__c( 
                    RecordTypeId=rtMap.get('Timing'), 
                    ChangeDate__c=c.Rodosya__r.RisyokuBi__c.addDays(1), 
                    RodosyaNO__c=c.Rodosya__r.RodosyaNO__c, 
                    Contact__c=c.Rodosya__r.Id,
                    JigyosyoTR_ShikyuJiki__c=jigyosyoTr.Id,
                    RodosyaTR__c=c.Id,
                    Sort__c=1 
                )
            );
        }
        
        // 2.期間内：雇用形態変更者抽出 //
        List<JFK_RodoSyaTR__c> cHenko=[
            SELECT Id
                 , Rodosya__r.Id
                 , Rodosya__r.KoyoKeitai_HenkoBi__c
                 , Rodosya__r.RodosyaNO__c
              FROM JFK_RodoSyaTR__c
             WHERE Rodosya__r.KoyoKeitai_HenkoBi__c >= :jigyosyoTr.BosyuJoho_ShikyuJiki__r.ShikyuKaishiBi__c
               AND Rodosya__r.KoyoKeitai_HenkoBi__c <= :jigyosyoTr.BosyuJoho_ShikyuJiki__r.ShikyuShimeBi__c
               AND JigyosyoTR_ShikyuJiki__r.Id = :jigyosyoTr.Id
        ];
        for(JFK_RodoSyaTR__c c: cHenko){
            changeList.add(
                new JFK_ShikyuTeishiWork__c( 
                    RecordTypeId=rtMap.get('Timing'), 
                    ChangeDate__c=c.Rodosya__r.KoyoKeitai_HenkoBi__c, 
                    RodosyaNO__c=c.Rodosya__r.RodosyaNO__c, 
                    Contact__c=c.Rodosya__r.Id,
                    JigyosyoTR_ShikyuJiki__c=jigyosyoTr.Id,
                    RodosyaTR__c=c.Id,
                    Sort__c=2 
                )
            );
        }
        
        // 3.期間内：補充労働者雇用の抽出 //
        List<JFK_RodoSyaTR__c> cHojyu=[
            SELECT Id
                 , Rodosya__r.Id
                 , Rodosya__r.Syikyu_KaishiBi__c
                 , Rodosya__r.RodosyaNO__c
              FROM JFK_RodoSyaTR__c
             WHERE Rodosya__r.Syikyu_KaishiBi__c >= :jigyosyoTr.BosyuJoho_ShikyuJiki__r.ShikyuKaishiBi__c
               AND Rodosya__r.Syikyu_KaishiBi__c <= :jigyosyoTr.BosyuJoho_ShikyuJiki__r.ShikyuShimeBi__c
               AND Rodosya__r.HojuMoto_Rodosya__c <> ''
               AND JigyosyoTR_ShikyuJiki__r.Id = :jigyosyoTr.Id
        ];
        for(JFK_RodoSyaTR__c c: cHojyu){
            changeList.add(
                new JFK_ShikyuTeishiWork__c( 
                    RecordTypeId=rtMap.get('Timing'), 
                    ChangeDate__c=c.Rodosya__r.Syikyu_KaishiBi__c, 
                    RodosyaNO__c=c.Rodosya__r.RodosyaNO__c, 
                    Contact__c=c.Rodosya__r.Id,
                    JigyosyoTR_ShikyuJiki__c=jigyosyoTr.Id,
                    RodosyaTR__c=c.Id,
                    Sort__c=3 
                )
            );
        }
        if(changeList.size()>0){
            insert changeList ;
        }
        
        // 事業所TR(時期)から前の時期データを取得
        List<JFK_JigyosyoTR__c> JigyosyoTRList=[
            SELECT Id, Name, BosyuNendo__c, BosyuKai__c, NenMe__c, KaiMe__c
              FROM JFK_JigyosyoTR__c
             WHERE Nendo_Kai_Jigyosyo__r.Id=:jigyosyoTr.Nendo_Kai_Jigyosyo__r.Id
          ORDER BY NenMe__c DESC, KaiMe__c DESC
        ];
        boolean chk=false;
        ZenShikyuJikiJigyoshoTR =new JFK_JigyosyoTR__c();
        for(JFK_JigyosyoTR__c j : JigyosyoTRList){
            if(chk){
                ZenShikyuJikiJigyoshoTR=j;
                break;
            }
            if (j.Id==this.jigyosyoTrId ){
                chk=true;
            }
        }
        List<JFK_RodoSyaTR__c> rodoSyaTRList=[
            SELECT Id, Name, Rodosya__r.Id
              FROM JFK_RodoSyaTR__c
             WHERE JigyosyoTR_ShikyuJiki__r.Id=:ZenShikyuJikiJigyoshoTR.Id
        ];
        ZenShikyuJikiRodosyaTRMap = new Map<String, String>();
        for(JFK_RodoSyaTR__c r : rodoSyaTRList){
            ZenShikyuJikiRodosyaTRMap.put(r.Rodosya__r.Id, r.Id);
        }

        // 4.処理データ取得
        return Database.getQueryLocator('SELECT Id, Name, ChangeDate__c, RodosyaNO__c, JigyosyoTR_ShikyuJiki__r.Id, Contact__r.Id, Contact__r.KoyoKBN__r.Name, Sort__c, RodosyaTR__c FROM JFK_ShikyuTeishiWork__c WHERE JigyosyoTR_ShikyuJiki__c =\''+ this.jigyosyoTrId +'\' ORDER BY ChangeDate__c, Sort__c, RodosyaNO__c');
    }
    
    /***********************************************************************
     * メイン処理
     */
    global void execute(Database.BatchableContext BC, List<sObject> scope){
    
        system.debug('Debug::execute');
        for(sObject s : scope){
            JFK_ShikyuTeishiWork__c work =(JFK_ShikyuTeishiWork__c) s;
            
            Date changeDate = work.ChangeDate__c;
            
            // 5.離職の場合
            if(work.Sort__c==1){
                // 5.1.人工チェック
                methodRisyokuNinkuCheck( changeDate );
                
                // 5.2.再雇用率チェック
                if(work.Contact__r.KoyoKBN__r.Name==KOYO_SHINKI_KBN){
                    // 5.2.1 新規雇用者の場合
                    methodRisyokuSaiKoyoCheckShinki( work, changeDate );
                }
                else if(work.Contact__r.KoyoKBN__r.Name==KOYO_SAI_KBN){
                    // 5.2.2 再雇用者の場合
                    methodRisyokuSaiKoyoCheckSai( changeDate );
                }
                // 5.3.離職者の停止日設定
                // 当人停止 停止日[changeDate]
                methodRisyokuSyaTeishi( work, changeDate );
            }

            // 6.雇用形態変更の場合
            else if(work.Sort__c==2){
                // 人工チェック
                Decimal ninku = getNinku(changeDate);
            }

            // 7.補充労働者雇用の場合
            else if(work.Sort__c==3){
                // 人工チェック
                Decimal ninku = getNinku(changeDate);
                
                if(ninku >= hitsuyoNinkuSu){
                    // 人工を満たしている
                    // TODO:再雇用率チェック
                }else{
                    // 人工が不足している
                }
            }
        }
    }
    
    /***********************************************************************
     * 終了処理
     */
    global void finish(Database.BatchableContext BC){
    
        system.debug('Debug::finish');
        sendFinishMail();
        // 8.処理結果の反映
    }
    
    /**
     * 5.1.離職による人工チェック
     */
    private void methodRisyokuNinkuCheck( Date changeDate ){
        
        Date rYuyoLimit = getYokugetsu(changeDate);
        Decimal ninku = getNinku(changeDate);

        if(ninku >= hitsuyoNinkuSu){
            // OK
        }else{
            // 必要人工数に不足が発生する場合、猶予期間を持って停止する
            // ただし離職日から1ヶ月の猶予期間内での補充労働者雇用が発生したタイミングで人工チェックを行う。
            
            List<JFK_ShikyuTeishiWork__c> yuyoList =[
                SELECT ChangeDate__c
                  FROM JFK_ShikyuTeishiWork__c 
                 WHERE ChangeDate__c > :changeDate
                   AND ChangeDate__c <= :rYuyoLimit
                   AND Sort__c = 3
            ];
            boolean rYuyoChk = true;
            for(JFK_ShikyuTeishiWork__c yuyo : yuyoList){
                Decimal yuyoNinku = getNinku(changeDate);
                if(yuyoNinku >= hitsuyoNinkuSu){
                    // OK
                    rYuyoChk = false;
                    break;
                }
            }
            if(rYuyoChk){
                // TODO.全員停止 停止日[rYuyoLimit]
            }
        }
    }
    /**
     * 5.2.1.離職による再雇用率チェック(新規雇用者の場合)
     */
    private void methodRisyokuSaiKoyoCheckShinki(JFK_ShikyuTeishiWork__c work, Date changeDate){
    
        Date rYuyoLimit = getYokugetsu(changeDate);
        // 離職者が補充元労働者となっている補充労働者が猶予期間内に雇用している場合、停止開始日を設定しない
        JFK_RodoSyaTR__c[] rodosyaTrs =[
            SELECT Id
              FROM JFK_RodoSyaTR__c
             WHERE JigyosyoTR_ShikyuJiki__r.Id = :this.jigyosyoTrId
               AND Rodosya__r.HojuMoto_Rodosya__r.Id = :work.Contact__r.Id
               AND Rodosya__r.KoyoKeiyaku_KaishiBi__c <= :rYuyoLimit
        ];
        if(rodosyaTrs.size()>0){
            // 停止開始日を設定しない
        }else{
            // TODO.優先順位を確認し停止対象判定
            Decimal maxShikyuSaikoyo = getSaikoyoMax(changeDate);
            
            // 再雇用者をワークに登録
            List<JFK_ShikyuTeishiWork__c> works = createSaikoyoWork(changeDate);
            // 無効になる再雇用者抽出
            setStopSaikoyoList(changeDate, maxShikyuSaikoyo);
            //_/_/_/_/_/_/_/_/_/_/_/_/_/_/
            // 当処理で利用したワークを削除する
            if(works.size()>0){
                //TODO:
                //delete works;
            }
        }
    }
    /**
     * 5.2.2.離職による再雇用率チェック(再雇用者の場合)
     */
    private void methodRisyokuSaiKoyoCheckSai(Date changeDate){
        // パターンA停止者から1名停止解除
        List<JFK_CommonTR__c> stoppedList= [
            SELECT Id
                 , RodosyaTR__r.Name
                 , RodosyaTR__r.Rodosya__r.Name
              FROM JFK_CommonTR__c
             WHERE PTMKST_ShikyuTeishi_KaishiBi__c != null
               AND PTMKST_ShikyuTeishi_SyuryoBi__c != null
               AND RodosyaTR__r.JigyosyoTR_ShikyuJiki__r.Id = :jigyosyoTrId
               AND (RodosyaTR__r.Rodosya__r.RisyokuBi__c = null OR RodosyaTR__r.Rodosya__r.RisyokuBi__c >= :changeDate)
        ];
        
        List<JFK_ShikyuTeishiWork__c> workList = new List<JFK_ShikyuTeishiWork__c>();
        
        for(JFK_CommonTR__c c : stoppedList){
        
        }
    }
    
    /**
     * 5.3.離職者の支給停止処理
     */
    private void methodRisyokuSyaTeishi(JFK_ShikyuTeishiWork__c work, Date changeDate){
    
        JFK_CommonTR__c cmn = new JFK_CommonTR__c();
        cmn.Name='停止期間(離職者)';
        cmn.RecordTypeId=this.ATeishiRecordTypeId;
        cmn.PTMKST_ShikyuTeishi_KaishiBi__c=changeDate;
        cmn.PTMKST_ShikyuTeishi_SyuryoBi__c=this.Shikyutaisyo_ShimeBi;
        cmn.RodosyaTR__c=work.RodosyaTR__c;
        
        insert cmn;
    }
    
    /**
     * 停止対象となる労働者を取得する
     */
    private void setStopSaikoyoList(Date baseDate, Decimal maxShikyuSaikoyo){
        
        List<JFK_ShikyuTeishiWork__c> workList =[
            SELECT Id, RodosyaTR__c
              FROM JFK_ShikyuTeishiWork__c
             WHERE RecordTypeId=:rtMap.get('Ranking')
          ORDER BY ShikyuYoteiKingaku__c DESC
                 , ZanNissu_1stYear__c DESC
                 , ZanNissu_2ndYear__c DESC
                 , ZanNissu_3rdYear__c DESC
                 , RodosyaNoFormula__c
        ];
        List<JFK_CommonTR__c> stopList=new List<JFK_CommonTR__c>();
        Decimal counter=0;
        for(JFK_ShikyuTeishiWork__c w : workList){
            counter += 1;
            if(maxShikyuSaikoyo >= counter){
                system.debug('Debug::OK=:'+w.Id);
                //_/_OK/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
            }else{
                system.debug('Debug::NG=:'+w.Id);
                //_/_NG/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
                // 停止開始日の設定
                // 停止日以降にパターンB停止がある場合、パターンBの停止開始日を停止日とする
                List<JFK_CommonTR__c> pBList=[
                    SELECT Id, PTMK_KekkinnBi_From__c, PTMK_KekkinnBi_To__c
                      FROM JFK_CommonTR__c
                     WHERE RecordTypeId=:this.BTeishiRecordTypeId
                       AND RodosyaTR__c=:w.RodosyaTR__c
                       AND PTMK_KekkinnBi_From__c >= :baseDate
                ];
                if( pBList.size() > 0 ){
                    if( true ){
                        // パターンBがある場合、B停止開始日前日までのA停止を作成
                        JFK_CommonTR__c cmn = new JFK_CommonTR__c();
                        cmn.Name='停止期間';
                        cmn.RecordTypeId=this.ATeishiRecordTypeId;
                        cmn.PTMKST_ShikyuTeishi_KaishiBi__c=baseDate;
                        cmn.PTMKST_ShikyuTeishi_SyuryoBi__c=pBList[0].PTMK_KekkinnBi_From__c.addDays(-1);
                        cmn.RodosyaTR__c=w.RodosyaTR__c;
                        stopList.add(cmn);
                    }
                    if( pBList[0].PTMK_KekkinnBi_To__c <= this.Shikyutaisyo_ShimeBi ){
                        // パターンB終了後にパターンA停止の期間がある場合、A停止を作成
                        JFK_CommonTR__c cmn = new JFK_CommonTR__c();
                        cmn.Name='停止期間';
                        cmn.RecordTypeId=this.ATeishiRecordTypeId;
                        cmn.PTMKST_ShikyuTeishi_KaishiBi__c=pBList[0].PTMK_KekkinnBi_From__c.addDays(1);
                        cmn.PTMKST_ShikyuTeishi_SyuryoBi__c=this.Shikyutaisyo_ShimeBi;
                        cmn.RodosyaTR__c=w.RodosyaTR__c;
                        stopList.add(cmn);
                    }
                }
                else{
                    // パターンBの停止がない場合、締日までのA停止を作成
                    JFK_CommonTR__c cmn = new JFK_CommonTR__c();
                    cmn.Name='停止期間';
                    cmn.RecordTypeId=this.ATeishiRecordTypeId;
                    cmn.PTMKST_ShikyuTeishi_KaishiBi__c=baseDate;
                    cmn.PTMKST_ShikyuTeishi_SyuryoBi__c=this.Shikyutaisyo_ShimeBi;
                    cmn.RodosyaTR__c=w.RodosyaTR__c;
                    stopList.add(cmn);
                }
            }
        }
        insert stopList;
    }
    
    /**
     * 再雇用者情報をワークに作成
     */
    private List<JFK_ShikyuTeishiWork__c> createSaikoyoWork(Date baseDate){
    
        List<JFK_RodoSyaTR__c> RodoSyaTRList=[
            SELECT Id
                 , Rodosya__r.Id
                 , JigyosyoTR_ShikyuJiki__r.BosyuJoho_ShikyuJiki__r.ShikyuShimeBi__c
                 , JigyosyoTR_ShikyuJiki__r.Id
                 , Zenki_KoyoKeitai__r.Name
                 , Henko_KoyoKeitai__r.Name
                 , KoyoKeitai_HenkoKaishiBi__c
                 , Rodosya__r.KoyoKBN__r.Name
                 , Rodosya__r.Syikyu_KaishiBi__c
                 , JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.JigyoKBN__r.Name
              FROM JFK_RodoSyaTR__c
             WHERE JigyosyoTR_ShikyuJiki__c=:this.jigyosyoTrId
               AND Rodosya__r.KoyoKBN__r.Name=:KOYO_SAI_KBN 
        ];
        List<JFK_ShikyuTeishiWork__c> workList = new List<JFK_ShikyuTeishiWork__c>();
        
        for(JFK_RodoSyaTR__c r : RodoSyaTRList){
        
            String BosyuKbn='';
            if(r.KoyoKeitai_HenkoKaishiBi__c == null){
                BosyuKbn=r.Zenki_KoyoKeitai__r.Name;
            }
            else if(r.KoyoKeitai_HenkoKaishiBi__c > baseDate){
                BosyuKbn=r.Zenki_KoyoKeitai__r.Name;
            }
            else{
                BosyuKbn=r.Henko_KoyoKeitai__r.Name;
            }
            
            JFK_ShikyuTeishiWork__c w = new JFK_ShikyuTeishiWork__c();
            w.RecordTypeId=rtMap.get('Ranking');// レコードタイプ
            w.Contact__c=r.Rodosya__r.Id;// 取引先責任者
            w.ShikyuKikanKaishiBi__c=r.Rodosya__r.Syikyu_KaishiBi__c;// 支給期間開始日
            w.ShikyuKikanSyuryoBi__c=r.JigyosyoTR_ShikyuJiki__r.BosyuJoho_ShikyuJiki__r.ShikyuShimeBi__c;// 支給期間終了日
            w.RodosyaTR__c=r.Id;
            w.Zenki_RodosyaTR__c=ZenShikyuJikiRodosyaTRMap.get(r.Rodosya__r.Id);// 前期労働者TR
            w.JigyosyoTR_ShikyuJiki__c=r.JigyosyoTR_ShikyuJiki__r.Id;// 事業所TR（支給時期）
            w.BosyuM_JyoseiTanka__c=BosyuTankaMap.get(BosyuKbn + r.Rodosya__r.KoyoKBN__r.Name + r.JigyosyoTR_ShikyuJiki__r.Nendo_Kai_Jigyosyo__r.JigyoKBN__r.Name).Id;// 募集M助成単価

            // 停止日数の反映
            w.TeishiNissu__c=0;// TODO.停止日数

            w.ShikyuYoteiHanteiBi__c=baseDate;
            
            workList.add(w);
        }
        system.debug('Debug::20131114:workList.size()='+workList.size());
        if(workList.size()>0){
            insert workList;
        }
        //update workList;
        return workList;
    }
    
    /**
     * 助成単価Mapを取得
     */
    private void getJyoseiTanka(String Id){
    
        List<JFK_Bosyu__c> bosyuList = [
            SELECT Id, JyoseiTanka_1stYear__c, JyoseiTanka_2nsYear__c, SyoseiTanka_3rdYear__c
                 , KoyoKeitai__r.Name
                 , KoyoKBN__r.Name
                 , JigyosyoKBN__r.Name
              FROM JFK_Bosyu__c
             WHERE Bosyu__r.Id=:Id
               AND recordtype.name=:BOSYU_RECORDTYPE_TANKA
        ];
        
        // 雇用形態(フルタイム,短時間労働者)
        // 雇用区分(新規雇用,再雇用)
        // 事業所区分(,①,②,③,④,①以外)
        BosyuTankaMap = new Map<String, JFK_Bosyu__c>();
        for(JFK_Bosyu__c b : bosyuList){

            // 事業所区分=①
            if(b.JigyosyoKBN__r.Name==JIGYOSHO_KBN_1){
                BosyuTankaMap.put(b.KoyoKeitai__r.Name+b.KoyoKBN__r.Name+JIGYOSHO_KBN_1, b);
            }
            // 事業所区分=②
            else if(b.JigyosyoKBN__r.Name==JIGYOSHO_KBN_2){
                BosyuTankaMap.put(b.KoyoKeitai__r.Name+b.KoyoKBN__r.Name+JIGYOSHO_KBN_2, b);
            }
            // 事業所区分=③
            else if(b.JigyosyoKBN__r.Name==JIGYOSHO_KBN_3){
                BosyuTankaMap.put(b.KoyoKeitai__r.Name+b.KoyoKBN__r.Name+JIGYOSHO_KBN_3, b);
            }
            // 事業所区分=④
            else if(b.JigyosyoKBN__r.Name==JIGYOSHO_KBN_4){
                BosyuTankaMap.put(b.KoyoKeitai__r.Name+b.KoyoKBN__r.Name+JIGYOSHO_KBN_4, b);
            }
            // 事業所区分=①以外
            else if(b.JigyosyoKBN__r.Name==JIGYOSHO_KBN_ANOTHER_1){
                BosyuTankaMap.put(b.KoyoKeitai__r.Name+b.KoyoKBN__r.Name+JIGYOSHO_KBN_2, b);
                BosyuTankaMap.put(b.KoyoKeitai__r.Name+b.KoyoKBN__r.Name+JIGYOSHO_KBN_3, b);
                BosyuTankaMap.put(b.KoyoKeitai__r.Name+b.KoyoKBN__r.Name+JIGYOSHO_KBN_4, b);
            }
            // 事業所区分=''
            else{
                BosyuTankaMap.put(b.KoyoKeitai__r.Name+b.KoyoKBN__r.Name+JIGYOSHO_KBN_1, b);
                BosyuTankaMap.put(b.KoyoKeitai__r.Name+b.KoyoKBN__r.Name+JIGYOSHO_KBN_2, b);
                BosyuTankaMap.put(b.KoyoKeitai__r.Name+b.KoyoKBN__r.Name+JIGYOSHO_KBN_3, b);
                BosyuTankaMap.put(b.KoyoKeitai__r.Name+b.KoyoKBN__r.Name+JIGYOSHO_KBN_4, b);
            }
        }
    }
    
    /**
     * 支給可能な再雇用者数の最大数を取得する
     */
    private Decimal getSaikoyoMax(Date baseDate){
    
        List<JFK_RodoSyaTR__c> RodoSyaTRList=[
            SELECT Id, Rodosya__r.RisyokuBi__c, Rodosya__r.KoyoKeiyaku_KaishiBi__c
              FROM JFK_RodoSyaTR__c
             WHERE JigyosyoTR_ShikyuJiki__c=:this.jigyosyoTrId
               AND JFK_RodoSyaTR__c.Rodosya__r.KoyoKBN__r.Name = :KOYO_SHINKI_KBN 
        ];
        
        Integer countSinkiKoyo=0;
        for(JFK_RodoSyaTR__c r : RodoSyaTRList){
            
            if(r.Rodosya__r.RisyokuBi__c == null){
                //OK
            }else if(r.Rodosya__r.RisyokuBi__c < baseDate){
                continue;//NG
            }else{
                //OK
            }
            if(r.Rodosya__r.KoyoKeiyaku_KaishiBi__c == null){
                continue;//NG
            }else if(r.Rodosya__r.KoyoKeiyaku_KaishiBi__c < baseDate){
                //OK
            }else{
                continue;//NG
            }
            countSinkiKoyo = countSinkiKoyo+1;
        }
        system.debug('Debug::新規雇用有効人数'+countSinkiKoyo);
        return countSinkiKoyo * 4;//新規雇用者数*4が再雇用者最大数
    }
    
    /**
     * 事業所区分ごとの必要人工数を取得する
     */
    private void getHitsuyoNinku(String jigyoKbn){
        Decimal Hitsuyo = 0;
        if(jigyoKbn==null){
            Hitsuyo=10000;
        }else if(jigyoKbn==JIGYOSHO_KBN_1){
            Hitsuyo=1;
        }else if(jigyoKbn==JIGYOSHO_KBN_2){
            Hitsuyo=1;
        }else if(jigyoKbn==JIGYOSHO_KBN_3){
            Hitsuyo=1;
        }else if(jigyoKbn==JIGYOSHO_KBN_4){
            Hitsuyo=3;
        }else{
            Hitsuyo=10000;
        }
        this.hitsuyoNinkuSu=Hitsuyo;
    }
    
    /**
     * baseDate時点での人工数を取得する
     */
    private Decimal getNinku(Date baseDate){
        
        List<JFK_RodoSyaTR__c> rodoSyaList= [
            SELECT Id, 
                   Zenki_KoyoKeitai__c, 
                   Zenki_KoyoKeitai__r.Name, 
                   Henko_KoyoKeitai__c, 
                   Henko_KoyoKeitai__r.Name, 
                   KoyoKeitai_HenkoKaishiBi__c,
                   Rodosya__r.RisyokuBi__c,
                   Rodosya__r.Syikyu_KaishiBi__c
              FROM JFK_RodoSyaTR__c
             WHERE JigyosyoTR_ShikyuJiki__c = :this.jigyosyoTrId
        ];
        
        Integer fullCount=0;
        Integer halfCount=0;
        for(JFK_RodoSyaTR__c c : rodoSyaList){
            
            // system.debug('Debug::20131112:Id_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/');
            // system.debug('Debug::20131112:Id='+Id);
            // system.debug('Debug::20131112:baseDate='+baseDate);
            // system.debug('Debug::20131112:Zenki_KoyoKeitai__c='+c.Zenki_KoyoKeitai__c);
            // system.debug('Debug::20131112:Henko_KoyoKeitai__c='+c.Henko_KoyoKeitai__c);
            // system.debug('Debug::20131112:KoyoKeitai_HenkoKaishiBi__c='+c.KoyoKeitai_HenkoKaishiBi__c);
            // system.debug('Debug::20131112:RisyokuBi__c='+c.Rodosya__r.RisyokuBi__c);
            // system.debug('Debug::20131112:Syikyu_KaishiBi__c='+c.Rodosya__r.Syikyu_KaishiBi__c);
            
            // フルタイム/短時間労働者
            
            // if (離職してない)
            if(c.Rodosya__r.RisyokuBi__c == null){
                // if (既に雇用形態変更している)
                if(c.KoyoKeitai_HenkoKaishiBi__c <> null && c.KoyoKeitai_HenkoKaishiBi__c <= baseDate){
                    // if(支給開始日を過ぎている)
                    if(c.Rodosya__r.Syikyu_KaishiBi__c <= baseDate){
                        if(c.Henko_KoyoKeitai__r.name==null){
                            
                        }else if(c.Henko_KoyoKeitai__r.name==KOYOKEITAI_FULL){
                            fullCount = fullCount+1;
                        }else if(c.Henko_KoyoKeitai__r.name==KOYOKEITAI_HALF){
                            halfCount = halfCount+1;
                        }
                    }
                }else{
                    // if(支給開始日を過ぎている)
                    if(c.Rodosya__r.Syikyu_KaishiBi__c <= baseDate){
                        if(c.Zenki_KoyoKeitai__r.name==null){
                            // 対象外
                        }else if(c.Zenki_KoyoKeitai__r.name==KOYOKEITAI_FULL){
                            fullCount = fullCount+1;
                        }else if(c.Zenki_KoyoKeitai__r.name==KOYOKEITAI_HALF){
                            halfCount = halfCount+1;
                        }
                    }
                }
                
            // else if (既に離職)
            }else if(c.Rodosya__r.RisyokuBi__c < baseDate){
                // 対象外
            // else if (離職予定)
            }else if(c.Rodosya__r.RisyokuBi__c >= baseDate){
                // if (既に変更している)
                if(c.KoyoKeitai_HenkoKaishiBi__c <= baseDate){
                    if(c.Henko_KoyoKeitai__r.name==null){
                            
                    }else if(c.Henko_KoyoKeitai__r.name==KOYOKEITAI_FULL){
                        fullCount = fullCount+1;
                    }else if(c.Henko_KoyoKeitai__r.name==KOYOKEITAI_HALF){
                        halfCount = halfCount+1;
                    }
                }else{
                    if(c.Zenki_KoyoKeitai__r.name==null){
                            
                    }else if(c.Zenki_KoyoKeitai__r.name==KOYOKEITAI_FULL){
                        fullCount = fullCount+1;
                    }else if(c.Zenki_KoyoKeitai__r.name==KOYOKEITAI_HALF){
                        halfCount = halfCount+1;
                    }
                }
            }
        }// for end
        system.debug('Debug::人工計算結果=['+( fullCount + (halfCount*0.5) )+']');
        return ( fullCount + (halfCount*0.5) );
    }
    
    /**
     * 翌月日付を取得する
     */
    private Date getYokugetsu(Date baseDate){
        return baseDate.addMonths(1);
    }
    
    /**
     * 完了メール送信
     */
    private void sendFinishMail(){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'yshinohara@pasonatquila.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('バッチ処理完了');
        mail.setPlainTextBody('バッチ処理が完了しました。\n' + system.now().format());
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}