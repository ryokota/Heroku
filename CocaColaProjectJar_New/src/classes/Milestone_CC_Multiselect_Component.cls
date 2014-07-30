/**
*	マルチ選択を表現するコンポーネント制御クラスである
*	パラメータとして「選択可能なユーザ」と「選択したユーザ」を設定する
*
*	作成日　：　2013.12.2	Kim
*	修正履歴　：
*/
public with sharing class Milestone_CC_Multiselect_Component {
	// 親から渡して貰たユーザリスト
    public SelectOption[] leftOptions { get; set; }
    public SelectOption[] rightOptions { get; set; }
    
    // Hiddenの値を再設定
    private void setOptions(SelectOption[] options, String value) {
        options.clear();
        String[] parts = value.split('&');
        for (Integer i=0; i<parts.size()/2; i++) {
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i*2], 'UTF-8'), 
              EncodingUtil.urlDecode(parts[(i*2)+1], 'UTF-8')));
        }
    }
    
    // 選択可能なユーザリスト
    public String leftOptionsHidden { get; set {
           leftOptionsHidden = value;
           setOptions(leftOptions, value);
        }
    }
    
    // 選択されたユーザリスト
    public String rightOptionsHidden { get; set {
           rightOptionsHidden = value;
           setOptions(rightOptions, value);
        }
    }

}