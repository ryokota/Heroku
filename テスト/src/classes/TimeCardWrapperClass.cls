public with sharing class TimeCardWrapperClass {
    /**SOQLで取得したタイムカードオブジェクト*/
    public timecard_SFO__c timeCard{get;set;}
    /*曜日*/
    public string youbi{get;set;}
    /* 出社時間（時）*/
    public string syussyaTimeHours{get;set;}
    /* 出社時間（分）*/
    public string syussyaTimeMinutes{get;set;}
    /* 退社時間（時）*/
    public string taisyaTimeHours{get;set;}
    /* 退社時間（分）*/
    public string taisyaTimeMinutes{get;set;}
    /* 休憩時間（時）*/
    public string restTimeHours{get;set;}
    /**休憩時間（分）*/
    public string restTimeMinutes{get;set;}
    /**うち深夜休憩時間（時）*/
    public string midnightRestTimeHours{get;set;}
    /**うち深夜休憩時間（分）*/
    public string midnightRestTimeMinutes{get;set;}
    /*勤務時間*/
    public string workingTime{get;set;}
    /*うち時間外勤務時間*/
    public string overTime{get;set;}
    /*うち深夜勤務時間*/
    public string midnightWorkTime{get;set;}
    /*予定勤務時間*/
    public string scheduledWorkingHours{get;set;}
    /*給料*/
    public string salary{get;set;}

    public String youbiColor {get {
        if (timeCard.Holiday__c || youbi == '日') {
            return 'red';
        } else if (youbi == '土') {
            return 'blue';
        }
        return 'black';
    }}

    /*コンストラクタ*/
    public TimeCardWrapperClass(timecard_SFO__c timeCard ,string syussyaTimeHours,string syussyaTimeMinutes,
                                string taisyaTimeHours,string taisyaTimeMinutes,string restTimeHours,
                                string restTimeMinutes,string midnightRestTimeHours,
                                string midnightRestTimeMinutes,
                                Decimal scheduledWorkingHours,Decimal salary){

        //時、分共に一桁の場合は頭に「0」をつける
        if(restTimeHours.length() == 1){
            restTimeHours = '0' + restTimeHours;
        }
        if(restTimeMinutes.length() == 1){
            restTimeMinutes = '0' + restTimeMinutes;
        }

        //時、分共に一桁の場合は頭に「0」をつける
        if(midnightRestTimeHours.length() == 1){
            midnightRestTimeHours = '0' + midnightRestTimeHours;
        }

        if(midnightRestTimeMinutes.length() == 1){
            midnightRestTimeMinutes = '0' + midnightRestTimeMinutes;
        }

        this.timeCard = timeCard;
        this.youbi = getYobi(timeCard.Syukkin_Date__c);
        this.syussyaTimeHours = syussyaTimeHours;
        this.syussyaTimeMinutes = syussyaTimeMinutes;
        this.taisyaTimeHours = taisyaTimeHours;
        this.taisyaTimeMinutes = taisyaTimeMinutes;
        this.restTimeHours = restTimeHours;
        this.restTimeMinutes = restTimeMinutes;
        this.midnightRestTimeHours = midnightRestTimeHours;
        this.midnightRestTimeMinutes = midnightRestTimeMinutes;
        this.scheduledWorkingHours = string.valueOf(scheduledWorkingHours);
        this.workingTime = string.valueOf(timeCard.Working_Time__c);
        this.overTime = string.valueOf(timeCard.zangyou__c);
        this.midnightWorkTime = string.valueOf(timeCard.MidNight_Work_Time_Calc__c);
        this.salary = string.valueOf(salary);

       // applyWorkrecord();
    }

    /*曜日取得関数*/
    public String getYobi(Date vdDate){
        datetime tDate = datetime.newInstance(vdDate.year(), vdDate.month(), vdDate.day());
        String week = tDate.format('E');
        if(week == 'Sun'){
            return '日';
        }else if(week =='Mon'){
            return '月';
        }else if(week =='Tue'){
            return '火';
        }else if(week =='Wed'){
            return '水';
        }else if(week =='Thu'){
            return '木';
        }else if(week =='Fri'){
            return '金';
        }else if(week =='Sat'){
            return '土';
        }
            return null;
        }

    /*レコード編集操作*/
/*    public void applyWorkrecord() {

        //予定勤務時間
        scheduledWorkingHours = '0';

        String workrecord = timeCard.workrecord__c;
        if (workrecord == '有休') {

            defaultSyussyaTime();
            defaultTaisyaTime();
            defaultRestTime();
            defaultmidnightRestTime();

        } else if (workrecord == '欠勤') {

            //開始時間、終了時間、休憩時間、深夜休憩時間を選択不可に設定
            editableTimes = true;

            allZero();

        } else if (workrecord == '出勤') {


            if (syussyaTimeHours == '00' && syussyaTimeMinutes == '00'){

                defaultSyussyaTime();

            }

            if (taisyaTimeHours == '00' && taisyaTimeMinutes == '00'){

                defaultTaisyaTime();

            }

            if (restTimeHours == '00' && restTimeMinutes == '00'){

                defaultRestTime();

            }

        	//予定勤務時間
        	scheduledWorkingHours = '7.5';

        } else {

            editableTimes = true;
            allZero();

        }
    }*/


    /*出社時間初期設定*/
/*   private void defaultSyussyaTime(){
            //出社時間（時）
            syussyaTimeHours = '09';
            //出社時間（分）
            syussyaTimeMinutes = '00';
    }*/

    /*退社時間初期設定*/
 /*   private void defaultTaisyaTime(){
            //退社時間（時）
            taisyaTimeHours = '17';
            //退社時間（分）
            taisyaTimeMinutes = '30';
    }*/

    /*休憩時間初期設定*/
  /*  private void defaultRestTime(){
            //休憩時間（時）
            restTimeHours = '01';
            //休憩時間（分）
            restTimeMinutes = '00';
    }*/

    /*深夜休憩時間初期設定*/
/*    private void defaultmidnightRestTime(){
            //深夜休憩時間（時）
            midnightRestTimeHours = '00';
            //深夜休憩時間（分）
            midnightRestTimeMinutes = '00';
    }*/

    /*全て0設定*/
  /*  private void allZero(){
            //出社時間（時）
            syussyaTimeHours = '00';
            //出社時間（分）
            syussyaTimeMinutes = '00';
            //退社時間（時）
            taisyaTimeHours = '00';
            //出社時間（分）
            taisyaTimeMinutes = '00';
            //休憩時間（時）
            restTimeHours = '00';
            //休憩時間（分）
            restTimeMinutes = '00';
            //深夜休憩時間（時）
            midnightRestTimeHours = '00';
            //深夜休憩時間（分）
            midnightRestTimeMinutes = '00';
    }*/
}