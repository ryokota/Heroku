global with sharing class JFK_ShikyuTeishiBi_Settei_Batch implements Database.Batchable<sObject>, Database.Stateful {

    /***********************************************************************
     * 変数定義
     */
    private String Id;// 事業所TR（支給時期）.Id
    private String BosyuKaiId;// 募集M（募集回）.Id
    private String JigyoSyoBosyuKaiId;// 事業所TR（募集回）.Id

    private Decimal hitsuyoNinkuSu=0;// 助成金支給に必要な人工数

    private Date ShikyuKikan_KaishiBi;// 支給対象期間 開始日
    private Date ShikyuKikan_ShimeBi;//支給対象期間 締日
    
    private JFK_JigyosyoTR__c ShikyuJiki;//当期に相当する事業所TR（支給時期）
    private JFK_JigyosyoTR__c ShikyuJikiZenki;//前期に相当する事業所TR（支給時期）
    
    private Map<String, JFK_Bosyu__c> BosyuTankaMap;// 助成金単価
    
        
    private Map<String, Id> WorkRecordTypeMap;// 支給停止ワークのレコードタイプIdMap
    private Map<String, Id> CommonRecordTypeMap;// 汎用TRのレコードタイプIdMap
    private Map<String, Id> RodoSyaZenkiMap;// 前期に相当する労働者TR（支給時期）のIdMap
    
    /***********************************************************************
     * 定数定義
     */
    // 雇用区分
    public static final String KOYO_SHINKI_KBN = '新規雇用';
    public static final String KOYO_SAI_KBN = '再雇用';
    // 雇用形態
    public static final String KOYOKEITAI_FULL = 'フルタイム';
    public static final String KOYOKEITAI_HALF = '短時間労働者';
    // 事業所区分
    public static final String JIGYOSHO_KBN_1 = '①';
    public static final String JIGYOSHO_KBN_2 = '②';
    public static final String JIGYOSHO_KBN_3 = '③';
    public static final String JIGYOSHO_KBN_4 = '④';
    public static final String JIGYOSHO_KBN_ANOTHER_1 = '①以外';

    // 募集M（レコードタイプ）
    public static final String BOSYU_RT_KAI='BosyuYoryo_YearTimes';// 募集回
    public static final String BOSYU_RT_JIKI='BosyuYoryo_ShikyuJiki';// 支給時期
    public static final String BOSYU_RT_TANKA='BosyuYoryo_ShikyugakuSansyutu';// 助成対象期単価
    // 事業所TR（レコードタイプ）
    public static final String JIGYOSYO_TR_RT_KAI='JigyoshoShikyu_YearTimes';
    public static final String JIGYOSYO_TR_RT_JIKI='JigyoshoShikyu_Shikyujiki';
    // 汎用TR（レコードタイプ）停止パターン
    public static final String COMMON_TR_RT_PATTERN_A='PTMKST_ShikyuTeishiKikan_A';// A停止パターン
    public static final String COMMON_TR_RT_PATTERN_B='PTMK_1kagetsuMukyuKekkin';// B停止パターン
    // 支給停止ワーク（レコードタイプ）
    public static final String WORK_RT_RANK='Ranking';// 優先順位判定
    public static final String WORK_RT_TEISHIBI='Setting';// 支給停止日設定
    public static final String WORK_RT_TIMING='Timing';// 支給条件変更タイミング

    /***********************************************************************
     * 処理呼び出し
     */
    public JFK_ShikyuTeishiBi_Settei_Batch (String Id){
        this.Id = Id;
    }
    
    /***********************************************************************
     * 開始処理
     */
    global Database.querylocator start(Database.BatchableContext BC){
    
        // 初期処理
        init();
        // 助成金単価Map作成
        setBosyuTankaMap();
        // 支給停止ワークのレコードタイプMap取得→WorkRecordTypeMap
        setWorkRecordTypeMap();
        // 汎用TR（支給停止情報）のレコードタイプMap取得→CommonRecordTypeMap
        setCommonRecordTypeMap();
        
        // 処理対象データの作成
        setTimingWork();
        
        // 前期に該当する労働者TR取得→RodoSyaZenkiMap
        getRodoSyaZenkiMap();
            
        // 4.処理データ取得
        return Database.getQueryLocator('');
    }
    
    /***********************************************************************
     * 主処理
     */
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        for(sObject s : scope){
            JFK_ShikyuTeishiWork__c work =(JFK_ShikyuTeishiWork__c) s;
            
            // 5.離職による変更
            if(true){
                // 5.1.人工チェック
                // 5.2.再雇用率チェック
                // 5.2.1.新規雇用者の離職の場合
                // 5.2.2.再雇用者の離職の場合
                // 5.3.離職者の停止日設定は不要(?)
            }
            // 6.雇用形態変更による変更
            else if(true){
                // 6.1.人工チェック
                // -人工数が不足する場合、猶予期間後停止
                // --猶予期間中に、補充労働者雇用があれば停止しない
                // --猶予期間中に、補充労働者雇用が無ければ、停止開始日：雇用形態変更日の翌月翌日
            }
            // 7.補充労働者雇用による変更
            else if(true){
                // 7.1.人工チェック
                // 7.1.1.OKの場合、停止解除（優先順位4名）
            }
        }
    }
    
    /***********************************************************************
     * 終了処理
     */
    global void finish(Database.BatchableContext BC){
        
        // 8.処理結果の反映
        
        // 9.ワークデータ削除
        
        sendFinishMail();// 終了通知
    }
    
    /**
     * 初期処理として必要なデータを取得する
     */
    private void init(){
    
        JFK_JigyosyoTR__c tr=[
            SELECT Id 
                 , BosyuJoho_ShikyuJiki__r.Bosyu__r.Id
                 , BosyuJoho_ShikyuJiki__r.ShikyuKaishiBi__c
                 , BosyuJoho_ShikyuJiki__r.ShikyuShimeBi__c
                 , Nendo_Kai_Jigyosyo__r.Id
                 , JigyoKBN__r.Name
              FROM JFK_JigyosyoTR__c
             WHERE Id=:this.Id
        ];
        
        this.BosyuKaiId=tr.BosyuJoho_ShikyuJiki__r.Bosyu__r.Id;// 募集M（募集回）.Id
        this.ShikyuKikan_KaishiBi=tr.BosyuJoho_ShikyuJiki__r.ShikyuKaishiBi__c;// 期間開始日
        this.ShikyuKikan_ShimeBi=tr.BosyuJoho_ShikyuJiki__r.ShikyuShimeBi__c;// 期間締日
        this.JigyoSyoBosyuKaiId=tr.Nendo_Kai_Jigyosyo__r.Id;// 事業所TR（募集回）.Id
        this.hitsuyoNinkuSu=getHitsuyoNinkuSu(tr.JigyoKBN__r.Name);// 人工数取得
    }
    
    
    /**
     * 支給停止が起き得る日付を抽出
     */
    private void setTimingWork(){
        
         List<JFK_ShikyuTeishiWork__c> changeList = new List<JFK_ShikyuTeishiWork__c>();
         
        // 1.期間内：離職者抽出 //
        List<JFK_RodoSyaTR__c> cRisyoku=[
            SELECT Id
                 , Rodosya__r.Id
                 , Rodosya__r.RisyokuBi__c
                 , Rodosya__r.RodosyaNO__c
              FROM JFK_RodoSyaTR__c
             WHERE Rodosya__r.RisyokuBi__c >= :this.ShikyuKikan_KaishiBi
               AND Rodosya__r.RisyokuBi__c <= :this.ShikyuKikan_ShimeBi
               AND JigyosyoTR_ShikyuJiki__r.Id = :this.Id
        ];
        for(JFK_RodoSyaTR__c c : cRisyoku){
            changeList.add(
                new JFK_ShikyuTeishiWork__c( 
                    RecordTypeId=WorkRecordTypeMap.get(WORK_RT_TIMING), 
                    ChangeDate__c=c.Rodosya__r.RisyokuBi__c.addDays(1), 
                    RodosyaNO__c=c.Rodosya__r.RodosyaNO__c, 
                    Contact__c=c.Rodosya__r.Id,
                    JigyosyoTR_ShikyuJiki__c=this.Id,
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
             WHERE Rodosya__r.KoyoKeitai_HenkoBi__c >= :this.ShikyuKikan_KaishiBi
               AND Rodosya__r.KoyoKeitai_HenkoBi__c <= :this.ShikyuKikan_ShimeBi
               AND JigyosyoTR_ShikyuJiki__r.Id = :this.Id
        ];
        for(JFK_RodoSyaTR__c c: cHenko){
            changeList.add(
                new JFK_ShikyuTeishiWork__c( 
                    RecordTypeId=WorkRecordTypeMap.get(WORK_RT_TIMING), 
                    ChangeDate__c=c.Rodosya__r.KoyoKeitai_HenkoBi__c, 
                    RodosyaNO__c=c.Rodosya__r.RodosyaNO__c, 
                    Contact__c=c.Rodosya__r.Id,
                    JigyosyoTR_ShikyuJiki__c=this.Id,
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
             WHERE Rodosya__r.Syikyu_KaishiBi__c >= :this.ShikyuKikan_KaishiBi
               AND Rodosya__r.Syikyu_KaishiBi__c <= :this.ShikyuKikan_ShimeBi
               AND Rodosya__r.HojuMoto_Rodosya__c <> ''
               AND JigyosyoTR_ShikyuJiki__r.Id = :this.Id
        ];
        for(JFK_RodoSyaTR__c c: cHojyu){
            changeList.add(
                new JFK_ShikyuTeishiWork__c( 
                    RecordTypeId=WorkRecordTypeMap.get(WORK_RT_TIMING), 
                    ChangeDate__c=c.Rodosya__r.Syikyu_KaishiBi__c, 
                    RodosyaNO__c=c.Rodosya__r.RodosyaNO__c, 
                    Contact__c=c.Rodosya__r.Id,
                    JigyosyoTR_ShikyuJiki__c=this.Id,
                    RodosyaTR__c=c.Id,
                    Sort__c=3 
                )
            );
        }
        
        if(changeList.size()>0){
            insert changeList ;
        }
    }
    /** 
     * 前期に相当する労働者TRを取得する（Map形式）RodoSyaZenkiMap
     */
    private void getRodoSyaZenkiMap(){
    
        List<JFK_JigyosyoTR__c> JigyosyoTRList=[
            SELECT Id
                 , Name
                 , BosyuNendo__c
                 , BosyuKai__c
                 , NenMe__c
                 , KaiMe__c
              FROM JFK_JigyosyoTR__c
             WHERE Nendo_Kai_Jigyosyo__r.Id=:this.JigyoSyoBosyuKaiId
          ORDER BY NenMe__c DESC, KaiMe__c DESC
        ];
        boolean chk=false;
        JFK_JigyosyoTR__c ZenShikyuJikiJigyoshoTR =new JFK_JigyosyoTR__c();
        for(JFK_JigyosyoTR__c j : JigyosyoTRList){
            if(chk){
                ZenShikyuJikiJigyoshoTR=j;
                break;
            }
            if (j.Id==this.Id){
                chk=true;
            }
        }
        List<JFK_RodoSyaTR__c> rodoSyaTRList=[
            SELECT Id
                 , Name
                 , Rodosya__r.Id
              FROM JFK_RodoSyaTR__c
             WHERE JigyosyoTR_ShikyuJiki__r.Id=:ZenShikyuJikiJigyoshoTR.Id
        ];
        RodoSyaZenkiMap= new Map<String, String>();
        for(JFK_RodoSyaTR__c r : rodoSyaTRList){
            RodoSyaZenkiMap.put(r.Rodosya__r.Id, r.Id);
        }
    }
    
    /**
     * 事業所区分から助成必要人工数を決定
     */
    private Decimal getHitsuyoNinkuSu(String jigyoKbn){
        
        if(jigyoKbn==null){
            return 10000;
        }else if(jigyoKbn==JIGYOSHO_KBN_1){
            return 1;
        }else if(jigyoKbn==JIGYOSHO_KBN_2){
            return 1;
        }else if(jigyoKbn==JIGYOSHO_KBN_3){
            return 1;
        }else if(jigyoKbn==JIGYOSHO_KBN_4){
            return 3;
        }
        return 10000;
    }
    
    /**
     * 雇用形態/雇用区分/事業所区分ごとの単価をMap化して保持
     */
    private void setBosyuTankaMap(){
        
        List<JFK_Bosyu__c> bosyuList=[
            SELECT Id
                 , JyoseiTanka_1stYear__c
                 , JyoseiTanka_2nsYear__c
                 , SyoseiTanka_3rdYear__c
                 , KoyoKeitai__r.Name
                 , KoyoKBN__r.Name
                 , JigyosyoKBN__r.Name
              FROM JFK_Bosyu__c
             WHERE Bosyu__r.Id=:this.BosyuKaiId
               AND RecordType.DeveloperName=:BOSYU_RT_TANKA
        ];
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
     * 支給計算ワークオブジェクトのレコードタイプ情報を取得する
     */
    private void setWorkRecordTypeMap(){
        
        List<RecordType> details=[
            SELECT Id,Name,DeveloperName
              FROM RecordType
             WHERE IsActive=true
               AND SobjectType='JFK_ShikyuTeishiWork__c'
        ];
        WorkRecordTypeMap= new Map<String, Id>();
        for(RecordType r : details){
            WorkRecordTypeMap.put(r.DeveloperName, r.Id);
        }
    }
    
    /**
     * 汎用TRオブジェクトのレコードタイプ情報を取得する
     */
    private void setCommonRecordTypeMap(){
        
        String[] pattern=new String[]{COMMON_TR_RT_PATTERN_A, COMMON_TR_RT_PATTERN_B};
        List<RecordType> details=[
            SELECT Id,Name,DeveloperName
              FROM RecordType
             WHERE IsActive=true
               AND SobjectType='JFK_CommonTR__c'
               AND DeveloperName in :pattern
        ];
        CommonRecordTypeMap= new Map<String, Id>();
        for(RecordType r : details){
            CommonRecordTypeMap.put(r.DeveloperName, r.Id);
        }
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