/**********************************************************
*  SetupCheck_PicklistValuesGetController
*  オブジェクトの選択リスト値を取得する
*  version： 1.0
*  作成： TDC Hokazono
***********************************************************/
public class SetupCheck_PicklistValuesGetController {
    //選択リスト値格納
    public String[] val_PicklistValues { get; set; }
    
    //コンストラクター
    public SetupCheck_PicklistValuesGetController() {
        System.debug('@@@@@@　SetupCheck_PicklistValuesGetController　@@@@@@');
        
        //URLからテーブル名と項目名を取得
        String sobject_name = ApexPages.currentPage().getParameters().get('sobject_name');
        String field_name = ApexPages.currentPage().getParameters().get('field_name');
        
        System.debug(' @@@ sobject_name : ' + sobject_name);
        System.debug(' @@@ field_name : ' + field_name);
        
        //選択リスト値を取得
        val_PicklistValues = fieldPicklistValuesGet(sobject_name, field_name);
    }
    
    //項目選択リスト値を取得
    private String[] fieldPicklistValuesGet(String sname, String fname) {
        System.debug('@@@@@@　fieldPicklistValuesGet　@@@@@@');
        System.debug(' @@@ sname : ' + sname);
        System.debug(' @@@ fname : ' + fname);
        
        //戻り値格納
        List<String> retlist = new List<String>();
        //オブジェクト項目の設定内容を格納
        Map<String, Schema.SObjectField> sof;
        
        //SObjectを取得（可変での取得方法が不明なのでまずはDynamicSOQL利用）
        //new SObject('オブジェクト名');ができるのが理想でした
        List<SObject> so = Database.query('Select Id from ' + sname +  ' limit 1');
        
        //項目の設定情報取得
        if (so.size() > 0) {
            System.debug(' @@@ so.size() > 0 ');
            //取得した検索結果レコードから設定情報を取得
            sof = so[0].getSObjectType().getDescribe().fields.getMap();
        } else {
            System.debug(' @@@ so.size() == 0 ');
            //レコードが1つも無い場合は最終手段でGlobalDescribeを利用
            //Describe自体が重そうな処理なので最終手段
            sof = Schema.getGlobalDescribe().get(sname).newSObject().getSObjectType().getDescribe().fields.getMap();
        }
        
        //項目の存在確認
        if (!sof.containsKey(fname)) return null;
        
        //項目の設定内容を取得
        Schema.DescribeFieldResult dfr = sof.get(fname).getDescribe();
        
        //データタイプ取得
        String ftype = dfr.getType().name();
        
        System.debug(' @@@ Data Type : ' + ftype);
        
        //選択リスト以外NULLを返し終了
        if (ftype != 'PICKLIST' && ftype != 'MULTIPICKLIST') return null;
        
        //リスト値を取得
        for (Schema.PicklistEntry pe : dfr.getPicklistValues()) {
            String val = '';
            //ラベル値を取得
            val = pe.getLabel();
            
            //デフォルト値チェック
            if (pe.isDefaultValue()) val += '（デフォルト）';
            
            //無効チェック
            if (!pe.isActive()) val += '（無効）';
            
            System.debug(' @@@ Value : ' + val);
            
            //リターン値に追加
            retlist.add(val);
        }
        
        //処理終了
        return retlist;
    }
    
    //テストメソッド
    static testmethod void picklistValuesGetControllerTEST() {
        test.starttest();
        //選択リスト項目（商談：フェーズ）
        PageReference pageRef = new PageReference('/apex/SetupCheck_PicklistValuesGet?sobject_name=Opportunity&field_name=StageName');
        test.setCurrentPage(pageRef);
        SetupCheck_PicklistValuesGetController pc = new SetupCheck_PicklistValuesGetController();
        //選択リスト以外の項目（商談：商談名）
        pageRef = new PageReference('/apex/SetupCheck_PicklistValuesGet?sobject_name=Opportunity&field_name=Name');
        test.setCurrentPage(pageRef);
        pc = new SetupCheck_PicklistValuesGetController();
        test.stopTest();
    }
}