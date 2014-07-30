/***********************************************************************************************************
 *  支給開始日を設定を行う段階で使われるソート機能のインタフェースである
 *  対象データは労働者の「雇用形態ー短時間」の場合、労働者番号でのソート
 *  作成者 : 株式会社パソナテキーラ   キム
 *  作成日 : 2013/11/06
 *  変更履歴 : 
***********************************************************************************************************/
global class JFK_ActualSortWrapper implements Comparable {

    public JFK_RodoSyaTR__c obj;
    
    // Constructor
    public JFK_ActualSortWrapper(JFK_RodoSyaTR__c target) {
        obj = target;
    }
    
    // 労働者番号を比較
    global Integer compareTo(Object compareTo) {
        // オブジェクト型をキャスト
        JFK_ActualSortWrapper compareToWrap = (JFK_ActualSortWrapper)compareTo;
        
        // 値が同じの場合、０をリターン
        Integer returnValue = 0;
        if (obj.Rodosya__r.RodosyaNO__c > compareToWrap.obj.Rodosya__r.RodosyaNO__c) {
            returnValue = 1;
        } else if (obj.Rodosya__r.RodosyaNO__c < compareToWrap.obj.Rodosya__r.RodosyaNO__c) {
            returnValue = -1;
        }
        
        return returnValue;       
    }
}