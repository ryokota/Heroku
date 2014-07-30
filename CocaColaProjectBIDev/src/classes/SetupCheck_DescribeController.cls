/**********************************************************
*  SetupCheck_DescribeController
*  オブジェクトの一覧と項目の設定内容一覧を取得する
*  version： 1.0
*  作成： TDC Hokazono
***********************************************************/
public class SetupCheck_DescribeController {
    //オブジェクト設定格納
    private transient Map<String, Schema.DescribeSObjectResult> descSr;
    
    //データタイプ設定格納
    private Map<String, List<String>> typelabel;
    
    //選択オブジェクト格納
    public String SelectObj {get; set;}
    
    //オブジェクト名、ラベル格納
    public String SelectObjNm {get; set;}
    public String SelectObjLb {get; set;}
    
    //表示列チェック格納
    public Boolean checknum {get; set;}
    public Boolean checklbl {get; set;}
    public Boolean checknme {get; set;}
    public Boolean checktyp {get; set;}
    public Boolean checklgt {get; set;}
    public Boolean checkplv {get; set;}
    public Boolean checknul {get; set;}
    public Boolean checkcst {get; set;}
    public Boolean checkhlt {get; set;}
    
    //表示項目チェック格納
    public String radiodspcol {get; set;}
    
    //ソートフラグ格納
    public String sortitem {get; set;}
    
    //ソートフラグ格納
    //（True：昇順、False：降順）
    private Boolean sortflg {get; set;}
    
    //コンストラクター
    public SetupCheck_DescribeController() {
        System.debug('@@@@@@　SetupCheck_DescribeController　@@@@@@');
        
        //全オブジェクトの情報を取得
        allObjectDescribeGet();
        
        //画面初期設定
        checknum = true;
        checklbl = true;
        checknme = true;
        checktyp = true;
        checklgt = true;
        checkplv = true;
        checknul = true;
        checkcst = true;
        checkhlt = true;
        
        radiodspcol = 'BTH';
        
        //ソートフラグ
        sortitem = '';
        sortflg = false;
        
        //フィールドタイプのラベルを設定
        typeLabelSet();
    }
    
    //全オブジェクトの設定情報を取得
    public void allObjectDescribeGet() {
        System.debug('@@@@@@　allObjectDescribeGet　@@@@@@');
        //既に取得済みの場合終了
        if (descSr != null) return;
        
        //テーブルの設定内容を取得
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        
        //設定情報を格納
        descSr = new Map<String, Schema.DescribeSObjectResult>();
        //オブジェクトの設定内容を格納
        for (Schema.SObjectType st : gd.values()) {
            Schema.DescribeSObjectResult r = st.getDescribe();
            descSr.put(r.getName(), r);
        }
        
        return;
    }
    
    //全オブジェクト名を取得し選択リストを設定
    public List<SelectOption> getObjAllName() {
        System.debug('@@@@@@　getObjAllName　@@@@@@');
        //リターン値
        List<SelectOption> options = new List<SelectOption>();
        
        //全オブジェクトの情報を取得
        allObjectDescribeGet();
        
        //ソート用変数
        Map<String, String> objmap = new Map<String, String>();
        List<String> KeyList = new List<String>();
        
        //オブジェクトをソート用変数に格納
        for (Schema.DescribeSObjectResult dsr : descSr.values()) {
            //System.debug(dsr.getLabel() + '(' + dsr.getName() + ')');
            KeyList.add(dsr.getName());
            objmap.put(dsr.getName(), dsr.getLabel());
            
        }
        
        //Nameでソート
        KeyList.sort();
        
        //選択リスト値を設定
        options.add(new SelectOption('','-- 選択してください --'));
        for (String key : KeyList) {
            options.add(new SelectOption(key, objmap.get(key)));
        }
        
        //処理終了
        return options;
    }
    
    //項目一覧を設定
    public List<FieldValue> getTableVal() {
        System.debug('@@@@@@　getTableVal　@@@@@@');
        //リターン値
        List<FieldValue> retval = new List<FieldValue>();
        
        //全オブジェクトの情報を取得
        allObjectDescribeGet();
        
        //オブジェクト名が未選択の場合処理終了
        if (!execCheckObject()) return null;
        
        //オブジェクト名、ラベルを取得
        objNameLabelGet();
        
        //オブジェクトから項目を取得
        Map<String, Schema.SObjectField> fieldsmap = descSr.get(SelectObj).fields.getMap();
        
        //項目分ループ
        for (Schema.SObjectField field : fieldsmap.values()) {
            //項目の設定内容を取得
            Schema.DescribeFieldResult fd = field.getDescribe();
            //変数に格納Label_No
            FieldValue fv = new FieldValue();
            
            System.debug(' @@@ 項目名　：　' + fd.getName());
            
            //各項目設定を取得・設定
            fv.Label_Label = fd.getLabel();
            fv.Label_Name = fd.getName();
            fv.Label_Type = fieldTypeGet(fd);
            fv.Label_Length = fieldLengthGet(fd);
            fv.Label_Nillable = fd.isNillable();
            fv.Label_Custom = fd.isCustom();
            fv.Label_HelpText = fieldHelpTextGet(fd);
            
            //フラグを設定
            //データタイプ取得
            String ftype = fd.getType().name();
            //選択リストタイプチェック
            if (ftype != 'PICKLIST' && ftype != 'MULTIPICKLIST') {
                fv.Label_PicklistValues_flg = false;
            } else {
                fv.Label_PicklistValues_flg = true;
            }
            //ヘルプテキストNULLチェック
            if (fv.Label_HelpText == null) {
                fv.Label_HelpText_flg = false;
            } else {
                fv.Label_HelpText_flg = true;
            }
            
            //リターン値に追加
            retval.add(fv);
        }
        
        //ソートフラグがある場合ソート実行
        if (sortitem != '') retval = listSortExec(retval);
        
        //項目Noをセット
        //項目番号
        Integer item_no = 0;
        for(FieldValue fv : retval) {
            item_no++;
            fv.Label_no = item_no;
        }
        
        //処理終了
        return retval;
    }
    
    //項目データ型を取得（日本語化）
    private String fieldTypeGet(Schema.DescribeFieldResult fd) {
        System.debug('@@@@@@　fieldTypeGet　@@@@@@');
        //リターン値
        String retval = '';
        //データタイプ取得
        String typeval = fd.getType().name();
        
        //データタイプを取得
        if (typelabel.containsKey(typeval)) {
            //タイプマップにある場合日本語名を格納
            retval = typelabel.get(typeval)[0];
            
        } else {
            //タイプマップに無い場合そのまま格納
            retval = typeval;
        }
        
        //ルックアップの場合オブジェクト名を取得
        if (typeval == 'REFERENCE') {
            Boolean flg = false;
            retval += '（';
            for (Schema.sObjectType sot : fd.getReferenceTo()) {
                if (flg) retval += ',';
                retval += sot.getDescribe().getLabel();
                flg = true;
            }
            retval += '）';
            
        }
        
        //自動採番項目チェック
        if (fd.isAutoNumber()) retval = '自動採番';
        
        //数式項目チェック
        if (fd.isCalculated()) retval = '数式（' + retval + '）';
        
        //外部ID項目チェック
        if (fd.isExternalID()) retval += '（外部 ID）';
        
        //ユニークチェック
        if (fd.isUnique()) {
            retval += '（ユニーク　';
            //大文字・小文字判別
            if (fd.isCaseSensitive()) {
                retval += '大文字と小文字を区別する';
            } else {
                retval += '大文字と小文字を区別しない';
            }
            retval += '）';
        }
        
        //処理終了
        return retval;
    }
    
    //項目文字数を取得
    private String fieldLengthGet(Schema.DescribeFieldResult fd) {
        System.debug('@@@@@@　fieldLengthGet　@@@@@@');
        //リターン値
        String retval = '';
        //文字数取得タイプ判別用
        String lengthtype = '';
        //データタイプ取得
        String typeval = fd.getType().name();
        
        //データタイプ存在チェック
        if (typelabel.containsKey(typeval)) lengthtype = typelabel.get(typeval)[1];
        
        //文字数取得タイプ「」（空白）の場合
        if (lengthtype == '') {
            //直接文字数格納
            retval = fd.getLength() + '';
            
        //文字数取得タイプ「NULL」の場合
        } else if (lengthtype == 'NULL') {
            //空白格納
            retval = '';
            
        //文字数取得タイプ「INT」の場合
        } else if (lengthtype == 'INT') {
            //整数の桁数格納
            retval = fd.getDigits() + ',0';
            
        //文字数取得タイプ「DBL」の場合
        } else if (lengthtype == 'DBL') {
            //全体の文字数と小数点の位置から文字数設定
            Integer precision = fd.getPrecision();
            Integer scale = fd.getScale();
            retval = (precision - scale) + ',' + scale;
            
        }
        
        //処理終了
        return retval;
    }
    
    //ヘルプテキスト値を配列に変換
    private String[] fieldHelpTextGet(Schema.DescribeFieldResult fd) {
        System.debug('@@@@@@　fieldHelpTextGet　@@@@@@');
        //リターン値
        List<String> retlist = new List<String>();
        //ヘルプテキスト取得
        String htxt = fd.getInlineHelpText();
        
        //値が無い場合NULLを返し終了
        if (htxt == '' || htxt == null) return null;
        
        //テキスト内の改行から配列を生成
        retlist = htxt.split('\n', -1);
        
        //処理終了
        return retlist;
    }
    
    //データタイプを設定（日本語ラベル、文字数取得タイプ）
    private void typeLabelSet() {
        System.debug('@@@@@@　typeLabelSet　@@@@@@');
        //データタイプ格納用
        typelabel = new Map<String, List<String>>();
        
        //文字数をそのまま表示
        typelabel.put('ID', new String[]{'ID', ''});
        typelabel.put('ANYTYPE', new String[]{'AnyType', ''});
        typelabel.put('BASE64', new String[]{'Base64', ''});
        typelabel.put('EMAIL', new String[]{'電子メール', ''});
        typelabel.put('PHONE', new String[]{'電話', ''});
        typelabel.put('COMBOBOX', new String[]{'テキスト（＋選択リスト）', ''});
        typelabel.put('ENCRYPTEDSTRING', new String[]{'パスワード', ''});
        typelabel.put('STRING', new String[]{'テキスト', ''});
        typelabel.put('TEXTAREA', new String[]{'テキストエリア', ''});
        typelabel.put('URL', new String[]{'URL', ''});
        typelabel.put('TIME', new String[]{'時間', ''});
        
        //文字数をNULL（空白）で表示
        typelabel.put('BOOLEAN', new String[]{'チェックボックス', 'NULL'});
        typelabel.put('DATE', new String[]{'日付', 'NULL'});
        typelabel.put('DATETIME', new String[]{'日付/時間', 'NULL'});
        typelabel.put('PICKLIST', new String[]{'選択リスト', 'NULL'});
        typelabel.put('MULTIPICKLIST', new String[]{'選択リスト(複数選択)', 'NULL'});
        typelabel.put('REFERENCE', new String[]{'ルックアップ', ''});
        
        //文字数を整数のみ表示
        typelabel.put('INTEGER', new String[]{'数値', 'INT'});
        
        //文字数を整数と小数点以下で表示
        typelabel.put('CURRENCY', new String[]{'通貨', 'DBL'});
        typelabel.put('DOUBLE', new String[]{'数値', 'DBL'});
        typelabel.put('PERCENT', new String[]{'パーセント', 'DBL'});
    }
    
    //オブジェクトの選択状況、存在確認
    private Boolean execCheckObject() {
        System.debug('@@@@@@　execCheckObject　@@@@@@');
        //オブジェクト名が未選択の場合FALSE
        if (SelectObj == '' || SelectObj == null) return false;
        //オブジェクトが存在しない場合FALSE
        if (!descSr.containsKey(SelectObj)) return false;
        
        //その他の場合TRUE
        return true;
    }
    
    //オブジェクト名、ラベル取得
    private void objNameLabelGet() {
        System.debug('@@@@@@　objNameLabelGet　@@@@@@');
        //オブジェクト名が未選択の場合処理終了
        if(!execCheckObject()) return;
        
        //設定内容を取得
        Schema.DescribeSObjectResult dsor = descSr.get(SelectObj);
        //オブジェクト名取得
        SelectObjNm = dsor.getName();
        //オブジェクトラベル取得
        SelectObjLb = dsor.getLabel();
    }
    
    //表示項目ラジオボタンを設定
    public List<SelectOption> getDispType() {
        System.debug('@@@@@@　getDispType　@@@@@@');
        //リターン値
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('BTH', '両方'));
        options.add(new SelectOption('STD', '標準'));
        options.add(new SelectOption('CST', 'カスタム'));
        
        //処理終了
        return options;
    }
    
    //項目設定内容のソート実行
    private List<FieldValue> listSortExec(List<FieldValue> fldval) {
        //戻り値格納
        List<FieldValue> resultList = new List<FieldValue>();
        
        //値を格納
        Map<String, List<FieldValue>> fvMap = new Map<String, List<FieldValue>>();
        
        //パラメータからリストを生成
        for(FieldValue fv : fldval) {
            //項目格納
            String itemval = '';
            
            //項目を取得
            //ソート項目により分岐
            if (sortitem == 'Label_Label') {
                itemval = fv.Label_Label;
            } else if (sortitem == 'Label_Name') {
                itemval = fv.Label_Name;
            } else if (sortitem == 'Label_Type') {
                itemval = fv.Label_Type;
            } else if (sortitem == 'Label_Length') {
                itemval = fv.Label_Length;
            }
            
            //存在チェック
            if(fvMap.get(itemval) == null) { fvMap.put(itemval, new List<FieldValue>()); }
            //値を追加
            fvMap.get(itemval).add(fv);
        }
        //リストからキーを取得
        List<String> keys = new List<String>(fvMap.keySet());
        
        //ソートを実行
        keys.sort();
        
        //ソートフラグがFALSEの場合降順
        if (!sortflg) {
            System.debug(' @@@ Sort Flag : FALSE');
            //値格納
            List<String> keys_desc = new List<String>();
            
            //リスト分ループ
            for (Integer i = 1; i <= keys.size(); i++) {
                //キーを降順で追加
                keys_desc.add(keys[keys.size()-i]);
            }
            keys = keys_desc;
        }
        //ソート結果を取得
        for(String key:keys) { resultList.addAll(fvMap.get(key)); }
        
        return resultList;
    }
    
    //表示ボタン押下時の処理
    public void viewPage() {
        System.debug('@@@@@@　viewPage　@@@@@@');
        
        //処理終了
        return;
    }
    
    //表示ボタン押下時の処理
    public void sortItems() {
        System.debug('@@@@@@　sortItems　@@@@@@');
        
        //ソートフラグを変換
        sortflg = !sortflg;
        System.debug(' @@@ Sort Flag : ' + sortflg);
        System.debug(' @@@ Sort Item : ' + sortitem);
        
        //処理終了
        return;
    }
    
    //項目一覧表示用クラス
    public class FieldValue {
        public Integer Label_No { get { return Label_No; } set { Label_No = value; } }
        public String Label_Label { get { return Label_Label; } set { Label_Label = value; } }
        public String Label_Name { get { return Label_Name; } set { Label_Name = value; } }
        public String Label_Type { get { return Label_Type; } set { Label_Type = value; } }
        public String Label_Length { get { return Label_Length; } set { Label_Length = value; } }
        public Boolean Label_PicklistValues_flg { get { return Label_PicklistValues_flg; } set { Label_PicklistValues_flg = value; } }
        public Boolean Label_Nillable { get { return Label_Nillable; } set { Label_Nillable = value; } }
        public Boolean Label_Custom { get { return Label_Custom; } set { Label_Custom = value; } }
        public String[] Label_HelpText { get { return Label_HelpText; } set { Label_HelpText = value; } }
        public Boolean Label_HelpText_flg { get { return Label_HelpText_flg; } set { Label_HelpText_flg = value; } }
    }
    
    //テストメソッド
    static testmethod void describeControllerTEST() {
        SetupCheck_DescribeController dc = new SetupCheck_DescribeController();
        List<SelectOption> so_oan = dc.getObjAllName();
        List<SelectOption> so_dst = dc.getDispType();
        
        dc.viewPage();
        dc.sortItems();
        
        //オブジェクト選択無し
        dc.getTableVal();
        //オブジェクト選択「Account」（ソート無し）
        dc.SelectObj = 'Account';
        dc.getTableVal();
        //オブジェクト選択「Event」（ソート有り）
        dc.sortflg = false;
        dc.sortitem = 'Label_Label';
        dc.SelectObj = 'Event';
        dc.getTableVal();
    }
}