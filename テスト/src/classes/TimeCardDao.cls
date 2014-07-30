public with sharing class TimeCardDao {

    //チームデータ取得
    public List<team_SFO__c> getTeamData(){

        return Database.query(Constant.teamSOQL);
    }

    //出勤データ取得用
    public List<timecard_SFO__c> getSyukkinData(date Syukkin_Date,date Syukkin_Date_To,string SFOtrainingterm,string SFOteam,string StaffName,string LnameKana){
        //タイムカードSOQL文章
        string timeCardSOQL = Constant.timeCardSOQL;
        string whereString = ' Disabled__c = false ';

        //タイムカード検索用SOQL文章 WHERE句作成
        if (Syukkin_Date <> null || Syukkin_Date_To <> null || SFOtrainingterm <> null || SFOteam <> null || staffName <> null || LnameKana <> null){

			//訓練生が入力されている場合は年月日だけを見て、他の項目は見ない
			if(staffName <> null){

               	if (whereString <> ''){
               		whereString += ' AND ';
                }

				whereString += ' staff__r.Id =:staffName ';

            	if (Syukkin_Date <> null && Syukkin_Date_To <> null ){

                	if (whereString <> ''){
                    	whereString += ' AND ';
                	}

                	whereString += ' Syukkin_Date__c >= :Syukkin_Date AND Syukkin_Date__c <= :Syukkin_Date_To ';
            	}

            //訓練生が入力されていない場合は他の全ての項目を検索条件として見る
			} else {

            	if (Syukkin_Date <> null && Syukkin_Date_To <> null ){

                	if (whereString <> ''){
                    	whereString += ' AND ';
                	}

                	whereString += ' Syukkin_Date__c >= :Syukkin_Date AND Syukkin_Date__c <= :Syukkin_Date_To ';
            	}

            	if (SFOtrainingterm <> null){

                	if (whereString <> ''){
                    	whereString += ' AND ';
                	}

                	whereString += ' staff__r.trainingterm__c = :SFOtrainingterm ';
            	}

            	if (SFOteam <> null){

                	if (whereString <> ''){
                    	whereString += ' AND ';
                	}

                	whereString += ' staff__r.team__c = :SFOteam ';

            	}

            	if (LnameKana <> null){

                	if (whereString <> ''){
                    	whereString += ' AND ';
                	}

                	whereString += ' staff__r.lname_kana__c Like \'' + LnameKana + '%\'';

            	}
        	}
        }

        //WHERE句が入力されている場合はWHEREを追加
		if (whereString <> ''){
			timeCardSOQL += ' WHERE ' + whereString ;
		}

        //ソート順（デフォルトはスタッフコードでソート）
        timeCardSOQL = timeCardSOQL + ' ORDER BY staff__r.purestaffcode__c limit 1000 ';

        system.debug('●SOQL文●:' + timeCardSOQL);

        return Database.query(timeCardSOQL);

    }

}