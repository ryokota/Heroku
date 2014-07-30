public with sharing class Constant {

/*タイムカードオブジェクト取得用SOQL*/
public static final String timeCardSOQL = 'SELECT Id,' +                  //ID
                                    ' Syukkin_Date__c,' +                 //出勤日
                                    ' workrecord__c , ' +                 //勤務実績
                                    ' Syussya_Time__c , ' +               //出社日時
                                    ' Taisya_Time__c , ' +                //退社日時
                                    ' Rest_Time__c , ' +                  //休憩時間
                                    ' MidNight_Rest_Time__c, ' +          //うち深夜休憩時間
                                    ' staff__r.Name, ' +                  //氏名
                                    ' staff__r.purestaffcode__c, ' +      //スタッフコード
                                    ' staff__r.staffstatus__c, ' +        //現在状況
                                    ' staff__r.trainingterm__c, ' +       //訓練期間
                                    ' Scheduled_Working_Hours_Number__c, ' +   //予定勤務時間
                                    ' tanka__c, ' +                       //単価
                                    ' Salary__c, ' +                      //給料
                                    ' staff__r.team__r.Name, ' +          //コース
                                    ' Holiday__c, ' +                     //休日
                                    ' Working_Time__c, ' +                //勤務時間（数式）
                                    ' zangyou__c, ' +                     //残業時間
                                    ' MidNight_Work_Time_Calc__c, ' +     //深夜残業時間（数式）
                                    ' lname_kana__c, ' +                  //姓（カナ）
                                    ' leader__c, ' +                      //リーダー
                                    ' staff__r.logicaldelete_date__c, ' + //退職日
                                    ' Disabled__c, ' +                    //無効
                                    ' Fixed_Work_Time__c, ' +             //勤怠修正済
                                    ' Kbn__c ' +                          //区分
                                    ' FROM timecard_SFO__c ';

/*チーム一覧取得用SOQL*/
public static final String teamSOQL = 'SELECT id,' +                      //ID
                                    ' Name ' +                            //チーム名
                                    ' FROM team_SFO__c ';
}