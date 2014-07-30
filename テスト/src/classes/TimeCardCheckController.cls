public with sharing class TimeCardCheckController {

    /*
    * タイムカードリスト（一覧表示用）
    */
    public List<TimeCardWrapperClass> tcwList {get;set;}

    /*
    * タイムカードリスト（データソート用）
    */
    public List<timecard_SFO__c> timeCardList {get;set;}

    /*
    * チーム選択値保持用
    */
    public String teamValue {get;set;}

    /*
    * 年月日昇順表示用
    */
    public String syukkinDateASC {get;set;}

    /*
    * 年月日降順表示用
    */
    public String syukkinDateDESC{get;set;}

    /*
    * 氏名昇順表示用
    */
    public String nameASC {get;set;}

    /*
    * 氏名降順表示用
    */
    public String nameDESC{get;set;}

    /*
    * 氏名(カナ)昇順表示用
    */
    public String lnamekanaASC {get;set;}

    /*
    * 氏名(カナ)降順表示用
    */
    public String lnamekanaDESC{get;set;}

    /*
    * SCD昇順表示用
    */
    public String SCDASC {get;set;}

    /*
    * SCD降順表示用
    */
    public String SCDDESC{get;set;}

    /*
    * 現在状況昇順表示用
    */
    public String staffStatusASC {get;set;}

    /*
    * 現在状況降順表示用
    */
    public String staffStatusDESC{get;set;}

    /*
    * 訓練期間昇順表示用
    */
    public String trainingTermASC {get;set;}

    /*
    * 訓練期間降順表示用
    */
    public String trainingTermDESC{get;set;}

    /*
    * チーム昇順表示用
    */
    public String teamASC {get;set;}

    /*
    * チーム降順表示用
    */
    public String teamDESC{get;set;}

    /*
    * リーダー昇順表示用
    */
    public String leaderASC {get;set;}

    /*
    * リーダー降順表示用
    */
    public String leaderDESC{get;set;}

    /*
    * 選択リスト表示用
    */
    public List<SelectOption> SFOteamListOptions;

    //休憩時間（時）
    public string restTimeHours;
    //休憩時間（分）
    public string restTimeMinutes;
    //深夜休憩時間（時）
    public string midnightRestTimeHours;
    //深夜休憩時間（分）
    public string midnightRestTimeMinutes;
    //出勤時間（時）
    public string syussyaTimeHours;
    //出勤時間（分）
    public string syussyaTimeMinutes;
    //退社時間（時）
    public string taisyaTimeHours;
    //退社時間（分）
    public string taisyaTimeMinutes;
    //予定勤務時間
    public Decimal scheduledWorkingHours;
    //給料
    public Decimal salary;

    /*
    *コンストラクタ
    */
    public TimeCardCheckController(){

        TimeCardDao constractorTimeCardDao = new TimeCardDao();
        //テーブル出力用クラス
        tcwList = new List<TimeCardWrapperClass>();

        syukkinDateASC  = 'none';
        syukkinDateDESC = 'none';
        nameASC  = 'none';
        nameDESC = 'none';
        SCDASC  = 'none';
        SCDDESC = 'none';
        staffStatusASC  = 'none';
        staffStatusDESC = 'none';
        trainingTermASC  = 'none';
        trainingTermDESC = 'none';
        teamASC  = 'none';
        teamDESC = 'none';
        leaderDESC = 'none';
        leaderASC = 'none';
        lnamekanaDESC = 'none';
        lnamekanaASC = 'none';

        timeCardList = new List<timecard_SFO__c>();

        //タイムカード検索条件用
        timeCard = new timecard_SFO__c();
        timeCard.Syukkin_Date__c = system.today();
        timeCard.Syukkin_Date_To__c = system.today();

        //選択リストチーム一覧取得
        List<team_SFO__c> teamList = new List<team_SFO__c>();
        teamList = constractorTimeCardDao.getTeamData();
        //オプション設定
        SFOteamListOptions = new List<SelectOption>();

        //空行を追加
        SFOteamListOptions.add(new SelectOption('','--なし--'));
        //リストを追加
        for(team_SFO__c sfo:teamList){
            if(sfo.Name != null){
                SFOteamListOptions.add(new SelectOption(sfo.Id, sfo.Name));
            }

        }
    }

    /**
    * チーム選択リストを設定します。
    * @return List<SelectOption> :
    **/
    public List<SelectOption> getSFOteamList(){
        return SFOteamListOptions;
    }

    /*
    * 時間選択リスト表示用
    */
    public List<SelectOption> getHours() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('00','00'));
        options.add(new SelectOption('01','01'));
        options.add(new SelectOption('02','02'));
        options.add(new SelectOption('03','03'));
        options.add(new SelectOption('04','04'));
        options.add(new SelectOption('05','05'));
        options.add(new SelectOption('06','06'));
        options.add(new SelectOption('07','07'));
        options.add(new SelectOption('08','08'));
        options.add(new SelectOption('09','09'));
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('11','11'));
        options.add(new SelectOption('12','12'));
        options.add(new SelectOption('13','13'));
        options.add(new SelectOption('14','14'));
        options.add(new SelectOption('15','15'));
        options.add(new SelectOption('16','16'));
        options.add(new SelectOption('17','17'));
        options.add(new SelectOption('18','18'));
        options.add(new SelectOption('19','19'));
        options.add(new SelectOption('20','20'));
        options.add(new SelectOption('21','21'));
        options.add(new SelectOption('22','22'));
        options.add(new SelectOption('23','23'));
        options.add(new SelectOption('24','24'));
        options.add(new SelectOption('25','25'));
        options.add(new SelectOption('26','26'));
        options.add(new SelectOption('27','27'));
        options.add(new SelectOption('28','28'));
        options.add(new SelectOption('29','29'));
        options.add(new SelectOption('30','30'));
        return options;
    }

    /*
    * 分選択リスト表示用
    */
    public List<SelectOption> getMinutes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('00','00'));
        options.add(new SelectOption('05','05'));
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('15','15'));
        options.add(new SelectOption('20','20'));
        options.add(new SelectOption('25','25'));
        options.add(new SelectOption('30','30'));
        options.add(new SelectOption('35','35'));
        options.add(new SelectOption('40','40'));
        options.add(new SelectOption('45','45'));
        options.add(new SelectOption('50','50'));
        options.add(new SelectOption('55','55'));

        return options;
    }

    /*
    * タイムカード検索値
    */
    public timecard_SFO__c timeCard {get;set;}

    /*
    * 一覧表示ボタンを押下時に発生するイベント処理
    */
    public PageReference doSearch(){

        //年月日がFromまたはToしか入力されていない場合
        if((timeCard.Syukkin_Date__c != null && timeCard.Syukkin_Date_To__c == null) ||
            timeCard.Syukkin_Date__c == null && timeCard.Syukkin_Date_To__c != null){

          ApexPages.Message message = new ApexPages.Message( ApexPages.severity.ERROR, '年月日はFromとTo両方に検索条件を入力してください');
            ApexPages.addMessage(message);
            return null;

        }

        //年月日またはチームが入力されていない場合
        if((timeCard.Syukkin_Date__c == null || timeCard.Syukkin_Date_To__c == null) && teamValue == null){

          ApexPages.Message message = new ApexPages.Message( ApexPages.severity.ERROR, '年月日またはチームに検索条件を入力してください');
            ApexPages.addMessage(message);
            return null;

        }

    //検索条件をクリア
    tcwList.clear();
    timeCardList.clear();

        //検索処理
        searchWork();

        //200件以上の場合
        if(timeCardList.size() > 200 ){

            ApexPages.Message message = new ApexPages.Message( ApexPages.severity.ERROR, '検索結果が200件以上あります。再度検索を実行してください。');
             ApexPages.addMessage(message);
             return null;

		//1件も検索がヒットしない場合
        } else if(timeCardList.size() == 0){

            ApexPages.Message message = new ApexPages.Message( ApexPages.severity.ERROR, '検索結果が1件もありません。再度検索を実行してください。');
             ApexPages.addMessage(message);
      		 return null;

        }

        timeCardListToTcwList();

        system.debug('●tcwList●:' + tcwList);

        syukkinDateASC = 'block';
        nameASC  = 'block';
        SCDASC  = 'block';
        staffStatusASC  = 'block';
        trainingTermASC  = 'block';
        teamASC  = 'block';
        lnamekanaASC = 'block';
        leaderASC = 'block';

        return null;
    }

    /**
    保存ボタン押下時遷移
    */
    public PageReference save() {
        system.debug('■■■保存■■■');
        integer salary = 0;

        List<timecard_SFO__c> updateTimeCardList = new list<timecard_SFO__c>();

    datetime syukkinDateUpdate = null;
    datetime taikinDateUpdate = null;

        for(TimeCardWrapperClass tcwc:tcwList){

      system.debug('●taisyaTimeHours)●:' + tcwc);
      system.debug('●tcwc.restTimeHours)●:' + tcwc.restTimeHours);
       system.debug('●tcwc.restTimeHours)●:' + Decimal.valueOf(tcwc.restTimeHours) * 60 + Decimal.valueOf(tcwc.restTimeMinutes));

      //出勤日時を設定
      syukkinDateUpdate = Datetime.newInstance(tcwc.timeCard.Syukkin_Date__c.year(),
                                                     tcwc.timeCard.Syukkin_Date__c.month(),
                                                     tcwc.timeCard.Syukkin_Date__c.day(),
                                                     Integer.valueOf(tcwc.syussyaTimeHours),
                                                     Integer.valueOf(tcwc.syussyaTimeMinutes),0);



            //退勤日時を設定(24時を過ぎていた場合は日を+1日して時間を-24する)
            if(Integer.valueOf(tcwc.taisyaTimeHours) >= 24){

              taikinDateUpdate = Datetime.newInstance(tcwc.timeCard.Syukkin_Date__c.year(),
                                                      tcwc.timeCard.Syukkin_Date__c.month(),
                                                      tcwc.timeCard.Syukkin_Date__c.day() + 1,
                                                      Integer.valueOf(tcwc.taisyaTimeHours) - 24,
                                                      Integer.valueOf(tcwc.taisyaTimeMinutes),0);

            } else {

              taikinDateUpdate = Datetime.newInstance(tcwc.timeCard.Syukkin_Date__c.year(),
                                                      tcwc.timeCard.Syukkin_Date__c.month(),
                                                      tcwc.timeCard.Syukkin_Date__c.day(),
                                                      Integer.valueOf(tcwc.taisyaTimeHours),
                                                      Integer.valueOf(tcwc.taisyaTimeMinutes),0);

            }


            //変更したタイムカードを保存する
            timecard_SFO__c timeCard = new timecard_SFO__c(Id = tcwc.timeCard.Id,
                                                    workrecord__c = tcwc.timeCard.workrecord__c,//勤怠区分
                                                    Syussya_Time__c = syukkinDateUpdate,//出勤日時
                                                    Taisya_Time__c = taikinDateUpdate,//退社日時
                                                    Rest_Time__c = Decimal.valueOf(tcwc.restTimeHours) * 60
                                                                         + Decimal.valueOf(tcwc.restTimeMinutes),//休憩時間
                                                    MidNight_Rest_Time__c = Decimal.valueOf(tcwc.midnightRestTimeHours) * 60
                                                                                          + Decimal.valueOf(tcwc.midnightRestTimeMinutes),//深夜休憩時間
                                                    Salary__c = Decimal.ValueOf(tcwc.salary)//日給
                                                    );
            //リストに追加
            updateTimeCardList.add(timeCard);

system.debug('●timeCard●' + timeCard);
        }

        //データが1件もない場合は正常終了
        if(updateTimeCardList == null){

            return null;
        }

        try {

            //データを更新
            update updateTimeCardList;

            //検索結果をクリア
            tcwList.clear();
            timeCardList.clear();

            //searchWork();

            //処理を終了
            return null;

        }catch (Exception ex){
            // エラー発生時、エラーメッセージ表示
            ApexPages.addMessages(ex);

            //処理を終了
            return null;
        }

    }

	//検索処理
    private void searchWork(){

       TimeCardDao doSearchTimeCardDao = new TimeCardDao();

        //SOQL文実行
        timeCardList = doSearchTimeCardDao.getSyukkinData(timeCard.Syukkin_Date__c,timeCard.Syukkin_Date_To__c,
                                                          timeCard.trainingtermSearch__c,teamValue,String.valueOf(timeCard.staff_Search__c),
                                                          timeCard.lname_kana_Text__c);


    }

  //検索結果格納処理
    private void timeCardListToTcwList(){

        //前の検索結果をクリア
        tcwList.clear();

        for(timecard_SFO__c tc:timeCardList){

            //出勤時間（時）
            syussyaTimeHours = '00';
            //出勤時間（分）
            syussyaTimeMinutes = '00';
            //退社時間（時）
            taisyaTimeHours = '00';
            //退社時間（分）
            taisyaTimeMinutes = '00';
            //休憩時間（時）
            restTimeHours = '00';
            //休憩時間（分）
            restTimeMinutes = '00';
            //深夜休憩時間（時）
            midnightRestTimeHours = '00';
            //深夜休憩時間（分）
            midnightRestTimeMinutes = '00';
            //予定勤務時間
            scheduledWorkingHours = 0;
            //日給
            salary = 0;

            //出勤日時が入力されていた場合
            if(tc.Syussya_Time__c <> null){
                //出勤時間（時）を設定
                syussyaTimeHours = tc.Syussya_Time__c.format('HH');
                //出勤時間（分）を設定
                syussyaTimeMinutes = tc.Syussya_Time__c.format('mm');
            }

            //退社日時が入力されていた場合
            if(tc.Taisya_Time__c <> null){
                if (tc.Syussya_Time__c.day() == tc.Taisya_Time__c.day()){

                    //退社時間（時）を設定
                    taisyaTimeHours = tc.Taisya_Time__c.format('HH');

                } else {

                    //退社時間（時）を設定
                  taisyaTimeHours = string.valueOf(Decimal.valueOf(tc.Taisya_Time__c.format('HH')) + 24);

                }

                //退社時間（分）を設定
                taisyaTimeMinutes = tc.Taisya_Time__c.format('mm');
            }

            //休憩時間が入力されていた場合
            if(tc.Rest_Time__c <> 0){

                //時計算（分を60で割った値）
                restTimeHours = string.valueOf(tc.Rest_Time__c.divide(60,0,System.RoundingMode.DOWN));

                //分計算（分を60で割った余り）
                restTimeMinutes = string.valueOf(math.mod(Integer.valueOf(tc.Rest_Time__c),60));

                system.debug('●休憩時間 tc.Rest_Time__c●:' + tc.Rest_Time__c);
                system.debug('●休憩時間（時）restTimeHours●:' + restTimeHours);
                system.debug('●休憩時間（分）restTimeMinutes●:' + restTimeMinutes);
            }

            //深夜休憩時間が入力されていた場合
            if(tc.MidNight_Rest_Time__c <> 0){

                //時計算（分を60で割った値）
                midnightRestTimeHours = string.valueOf(tc.MidNight_Rest_Time__c.divide(60,0,System.RoundingMode.DOWN));

                //分計算（分を60で割った余り）
                midnightRestTimeMinutes = string.valueOf(math.mod(Integer.valueOf(tc.MidNight_Rest_Time__c),60));

                system.debug('●深夜休憩時間 tc.MidNight_Rest_Time__c●:' + tc.MidNight_Rest_Time__c);
                system.debug('●深夜休憩時間（時）midnightRestTimeHours●:' + midnightRestTimeHours);
                system.debug('●深夜休憩時間（分）midnightRestTimeMinutes●:' + midnightRestTimeMinutes);

            }

            //データを追加
            tcwList.add(new TimeCardWrapperClass(tc,syussyaTimeHours,syussyaTimeMinutes,taisyaTimeHours,
                                                                                taisyaTimeMinutes,restTimeHours,restTimeMinutes,
                                                                                midnightRestTimeHours,midnightRestTimeminutes,
                                                                                scheduledWorkingHours,salary));
       }
    }

   /**
    年月日昇順ボタン押下時遷移
    */
    public PageReference doSelectSyukkinDateASC() {
        Boolean sortAscending = true;
        TimeCardCheckHelper tcch = new TimeCardCheckHelper();
        timeCardList = (List<timecard_SFO__c>)tcch.getSortedList(timeCardList,'Syukkin_Date__c', sortAscending);

        syukkinDateDESC = 'block';
        syukkinDateASC = 'none';

        timeCardListToTcwList();
        return null;
    }

   /**
    年月日降順ボタン押下時遷移
    */
    public PageReference doSelectSyukkinDateDESC() {

        Boolean sortAscending = false;
        TimeCardCheckHelper tcch = new TimeCardCheckHelper();
        timeCardList = (List<timecard_SFO__c>)tcch.getSortedList(timeCardList,'Syukkin_Date__c', sortAscending);

        syukkinDateDESC = 'none';
        syukkinDateASC = 'block';

        timeCardListToTcwList();

        return null;
    }

   /**
    氏名(カナ)昇順ボタン押下時遷移
    */
    public PageReference doSelectlnamekanaASC() {
        Boolean sortAscending = true;
        TimeCardCheckHelper tcch = new TimeCardCheckHelper();
        timeCardList = (List<timecard_SFO__c>)tcch.getSortedList(timeCardList,'lname_kana__c', sortAscending);

        lnamekanaDESC = 'block';
        lnamekanaASC = 'none';

        timeCardListToTcwList();
        return null;
    }

   /**
    氏名(カナ)降順ボタン押下時遷移
    */
    public PageReference doSelectlnamekanaDESC() {

        Boolean sortAscending = false;
        TimeCardCheckHelper tcch = new TimeCardCheckHelper();
        timeCardList = (List<timecard_SFO__c>)tcch.getSortedList(timeCardList,'lname_kana__c', sortAscending);

        lnamekanaDESC = 'none';
        lnamekanaASC = 'block';

        timeCardListToTcwList();

        return null;
    }

   /**
    SCD昇順ボタン押下時遷移
    */
    public PageReference doSelectSCDASC() {
        Boolean sortAscending = true;
        TimeCardCheckHelper tcch = new TimeCardCheckHelper();
        timeCardList = (List<timecard_SFO__c>)tcch.getSortedList(timeCardList,'staff__r.purestaffcode__c', sortAscending);

        SCDDESC = 'block';
        SCDASC = 'none';

        timeCardListToTcwList();
        return null;
    }

   /**
    SCD降順ボタン押下時遷移
    */
    public PageReference doSelectSCDDESC() {

        Boolean sortAscending = false;
        TimeCardCheckHelper tcch = new TimeCardCheckHelper();
        timeCardList = (List<timecard_SFO__c>)tcch.getSortedList(timeCardList,'staff__r.purestaffcode__c', sortAscending);
        SCDDESC = 'none';
        SCDASC = 'block';

        timeCardListToTcwList();

        return null;
    }
   /**
    現在状況昇順ボタン押下時遷移
    */
    public PageReference doSelectStaffStatusASC() {
        Boolean sortAscending = true;
        TimeCardCheckHelper tcch = new TimeCardCheckHelper();
        timeCardList = (List<timecard_SFO__c>)tcch.getSortedList(timeCardList,'staff__r.staffstatus__c', sortAscending);

        staffStatusDESC = 'block';
        staffStatusASC = 'none';

        timeCardListToTcwList();
        return null;
    }

   /**
    現在状況降順ボタン押下時遷移
    */
    public PageReference doSelectStaffStatusDESC() {

        Boolean sortAscending = false;
        TimeCardCheckHelper tcch = new TimeCardCheckHelper();
        timeCardList = (List<timecard_SFO__c>)tcch.getSortedList(timeCardList,'staff__r.staffstatus__c', sortAscending);
        staffStatusDESC = 'none';
        staffStatusASC = 'block';

        timeCardListToTcwList();

        return null;
    }
   /**
    訓練期間昇順ボタン押下時遷移
    */
    public PageReference doSelectTrainingTermASC() {
        Boolean sortAscending = true;
        TimeCardCheckHelper tcch = new TimeCardCheckHelper();
        timeCardList = (List<timecard_SFO__c>)tcch.getSortedList(timeCardList,'staff__r.trainingterm__c', sortAscending);

        trainingTermDESC = 'block';
        trainingTermASC = 'none';


        timeCardListToTcwList();
        return null;
    }

   /**
    訓練期間降順ボタン押下時遷移
    */
    public PageReference doSelectTrainingTermDESC() {

        Boolean sortAscending = false;
        TimeCardCheckHelper tcch = new TimeCardCheckHelper();
        timeCardList = (List<timecard_SFO__c>)tcch.getSortedList(timeCardList,'staff__r.trainingterm__c', sortAscending);
        trainingTermDESC = 'none';
        trainingTermASC = 'block';
        timeCardListToTcwList();

        return null;
    }

   /**
    リーダー昇順ボタン押下時遷移
    */
    public PageReference doSelectleaderASC() {
        Boolean sortAscending = true;
        TimeCardCheckHelper tcch = new TimeCardCheckHelper();
        timeCardList = (List<timecard_SFO__c>)tcch.getSortedList(timeCardList,'leader__c', sortAscending);

        leaderDESC = 'block';
        leaderASC = 'none';

        timeCardListToTcwList();
        return null;
    }

   /**
    リーダー降順ボタン押下時遷移
    */
    public PageReference doSelectleaderDESC() {

        Boolean sortAscending = false;
        TimeCardCheckHelper tcch = new TimeCardCheckHelper();
        timeCardList = (List<timecard_SFO__c>)tcch.getSortedList(timeCardList,'leader__c', sortAscending);

        leaderDESC = 'none';
        leaderASC = 'block';

        timeCardListToTcwList();

        return null;
    }
}