/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_cmdUtilities
 *  概要        : 
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/09/27 Create
 ******************************************************************************/
public class JFK_cmdUtilities {
    /*
     * getRecordTypeId
     * 引数 	： RecordType名
     * 戻り値	： RecordTypeId
     * 概要 ： RecordTypeId取得
     */
     public static string getRecordTypeId(string recordType) {
        Schema.DescribeSObjectResult R = JFK_CommonTR__c.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> lstRT = R.getRecordTypeInfos();
        string recordTypeId = '';
        
        for (Schema.RecordTypeInfo rt : lstRT) {
            if (rt.getName() == recordType) {
                recordTypeId = rt.getRecordTypeId();
                break;
            }
        }
        
        return recordTypeId;        
     }

    /*
     * chkSaveResult
     * 引数 	： Database.SaveResult[]
     * 戻り値	： 更新成功：true   更新失敗：false
     * 概要 	： 更新失敗いた時、デバッグログを出力する。
     */
    public static boolean chkSaveResult(Database.SaveResult[] srList) {
        boolean isSuccess = true;

        if (srList == null) return true;

        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                //System.debug('DB update success : ' + sr.getId());
            } else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('fields that affected this error: ' + err.getFields());
                }
                isSuccess = false;
            }
        }
        
        return isSuccess;
    }

    /*
     * createSelectOption_Bosyu
     * 引数 	： 募集リスト
     *       SelectOptionを作成する項目
     * 戻り値	：SelectOption
     * 概要 	： 
     */
    public static list<SelectOption> createSelectOption(list<JFK_Bosyu__c> lstBosyu, string objectName) {
        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption('', ''));
        for (JFK_Bosyu__c bosyu : lstBosyu) {
            boolean isExists = false;
            for (integer i = 0; i < options.size(); i++) {
                if (options[i].getValue() == string.valueOf(bosyu.get(objectName))) {
                    isExists = true;
                }
            }
            if (!isExists) {
                options.add(new SelectOption(string.valueOf(bosyu.get(objectName)), string.valueOf(bosyu.get(objectName))));
            }
        }
        
        return options;
    }
}