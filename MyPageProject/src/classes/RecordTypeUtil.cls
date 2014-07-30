public with sharing class RecordTypeUtil {

    public static Id getId(String objName, String recordName) {
        
        RecordType rt = [select
                                Id
                            from
                                RecordType
                            where
                                SobjectType   = :objName and
                                DeveloperName = :recordName];
        return rt.Id;
    }

}