/***********************************************************************************************************
 *  支給額計算を行うクラスである。
 *  対象労働者の雇用条件による単価を基にそれぞれの基準に満たされる計算を行う。
 *  Targetオブジェクト : 募集M（JFK_Bosyu__c）
 *                  事業所TR（JFK_JigyosyoTR__c）
 *                  労働者TR（JFK_RodoSyaTR__c）
 *                  労働者（Contact）
 *                  汎用M（JFK_CommonM__c）
 *                  汎用TR（JFK_CommonTR__c）
 *  Updateオブジェクト：労働者TR（JFK_RodoSyaTR__c）
 *                  汎用TR（JFK_CommonTR__c）
 *  作成者 : 株式会社パソナテキーラ   キム
 *  作成日 : 2013/10/22
 *  変更履歴 : 
***********************************************************************************************************/
global class JFK_ActualCalcBatch implements Database.Batchable<sObject>,Database.Stateful{
    
    
    public String query = '';
    public String accountTRId = '';
    public Map<Id, String> commonMasterIdMap;               //汎用MのデータをIDでマッピング
    public Map<String, Id> commonMasterNameMap;             //汎用MのデータをNameでマッピング
    public Map<Integer, JFK_Bosyu__c> tankaMap;             //単価
    public List<Contact> resultContactList;                 //更新対象の労働者(支給開始日)
    public List<JFK_RodoSyaTR__c> resultRodoSyaList;        //更新対象の労働者TR
    
    global JFK_ActualCalcBatch(String accountTRId){
        
        system.debug('************************BATCH_CONSTRUCTOR');
        this.accountTRId = accountTRId;
        //汎用Mをマッピングして置く（ステータスの値が別のオブジェクトになっているため）
        this.commonMasterIdMap = new Map<Id, String>();
        this.commonMasterNameMap = new Map<String, Id>();
        for(JFK_CommonM__c com : [SELECT Id, Name FROM JFK_CommonM__c]){
            this.commonMasterIdMap.put(com.Id, com.Name);
            this.commonMasterNameMap.put(com.Name, com.Id);
        }
        
        //単価を取得して置く
        tankaMap = JFK_ActualCalcBatchHandler.getBosyuMasterTanka(accountTRId);
        //支給開始日を設定する。
        JFK_ActualCalcBatchHandler.doCreateShikyuKaishBi(accountTRId);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('************************BATCH_START');
        //Rodosya__r.HojuMoto_Rodosya__r.RisyokuBi__c           //労働者の補充元労働者の離職日
        this.query = 'SELECT Id, '
                            //参照フィルード
                   + '      KoyoKeitai_HenkoAri_1stYear__c, '       //1年目雇用形態変更有
                   + '      KoyoKeitai_HenkoAri_2nsYear__c, '       //2年目雇用形態変更有
                   + '      KoyoKeitai_HenkoAri_3rdYear__c, '       //3年目雇用形態変更有
                   + '      JigyosyoTR_ShikyuJiki__c,       '       //事業所TR（支給時期）
                   + '      Rodosya__c,                     '       //労働者
                   + '      KoyoKeitai_HenkoKaishiBi__c,    '       //雇用形態変更開始日
                            //更新対象フィルード
                   + '      YoteiShikyuDays_1stYear__c,     '       //1年目予定支給日数
                   + '      YoteiShikyuKingaku_1stYear__c,  '       //1年目予定支給金額
                   + '      YoteiZanDays_1stYear__c,        '       //1年目予定残日数
                   + '      YoteiNokoriKingaku_1stYear__c,  '       //1年目予定残金額
                   + '      KyushiDays_1stYear__c,          '       //1年目休止日数
                   + '      TeishiDays_1stYear__c,          '       //1年目停止日数
                   + '      JissekiShikyuKingaku_1stYear__c,'       //1年目実績支給金額
                   + '      ShikyuDays_1stYear__c,          '       //1年目支給日数
                   + '      ZanDays_1stYear__c,             '       //1年目残日数
                   + '      NokoriKingaku_1stYear__c,       '       //1年目残金額
                   + '      YoteiShikyuDays_2nsYear__c,     '       //2年目予定支給日数
                   + '      YoteiShikyuKingaku_2nsYear__c,  '       //2年目予定支給金額
                   + '      YoteiNokoriKingaku_2nsYear__c,  '       //2年目予定残金額
                   + '      KyushiDays_2nsYear__c,          '       //2年目休止日数
                   + '      TeishiDays_2nsYear__c,          '       //2年目停止日数
                   + '      JissekiShikyuKingaku_2nsYear__c,'       //2年目実績支給金額
                   + '      ShikyuDays_2nsYear__c,          '       //2年目支給日数
                   + '      YoteiZanDays_2nsYear__c,        '       //2年目残予定日数
                   + '      ZanDays_2nsYear__c,             '       //2年目残日数
                   + '      NokoriKingaku_2nsYear__c,       '       //2年目残金額
                   + '      YoteiShikyuDays_3rdYear__c,     '       //3年目予定支給日数
                   + '      YoteiShikyuKingaku_3rdYear__c,  '       //3年目予定支給金額
                   + '      YoteiNokoriKingaku_3rdYear__c,  '       //3年目予定残金額
                   + '      KyushiDays_3rdYear__c,          '       //3年目休止日数
                   + '      TeishiDays_3rdYear__c,          '       //3年目停止日数
                   + '      JissekiShikyuKingaku_3rdYear__c,'       //3年目実績支給金額
                   + '      ShikyuDays_3rdYear__c,          '       //3年目支給日数
                   + '      YoteiZanDays_3rdYear__c,        '       //3年目残予定日数
                   + '      ZanDays_3rdYear__c,             '       //3年目残日数
                   + '      NokoriKingaku_3rdYear__c        '       //3年目残金額
                   + 'FROM JFK_RodoSyaTR__c WHERE JigyosyoTR_ShikyuJiki__c = \'' + this.accountTRId +'\'';
        
        
        return Database.getQueryLocator(this.query);
    }
    global void execute(Database.BatchableContext BC, List<SObject> actualList){
        system.debug('************************BATCH_EXECUTE');
    }
    global void finish(Database.BatchableContext BC){
        system.debug('************************BATCH_FINISH');
    }
    /*
    class TempClassWrapper{
        public String rodosyaID {get;set;}              //労働者ID
        public Date shikyuKetteiBi {get;set;}           //支給決定日
        public boolean shikyuTorikeshiFlg {get;set;}    //支給取消
        public Date koyoKaishiSaihayaBi {get;set;}      //募集回基点日
        public Date shikyuKaishiSaihayaBi {get;set;}    //県庁指定日
        public Date shinseiKikanSaisyuBi {get;set;}     //申請期間最終日
        public String zenkiKoyoKeitai {get;set;}        //前期雇用形態
        public String henkoKoyoKeitai {get;set;}        //変更雇用形態
        public Date koyoKeitaiHenkokaishbi {get;set;}   //雇用形態変更開始日
        public boolean kikannaiRisyoku {get;set;}       //期間内離職有
        //public boolean ketsuban {get;set;}                //労働者の欠番
        public String koyoKBN {get;set;}                //労働者の雇用区分
        public Date koyoKeiyakuKaishiBi {get;set;}      //労働者の雇用契約開始日
        public String koyoKeitai {get;set;}             //労働者の雇用形態
        public Date risyokuBi {get;set;}                //離職日
    }
    */
}