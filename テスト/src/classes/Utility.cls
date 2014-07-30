//ユーティリティクラス
public with sharing class Utility {
	//休日チェックメソッド
	//param チェックしたい日付(date)
	//return 休日ならばtrue/平日ならばfalse
	public static boolean isHoliday(Date i_date){
		List<Holiday> holidays = [select Id, Name from Holiday where ActivityDate = :i_date];
		if(holidays != null){
			return true;
		}else{
			return false;
		}
	}
	
	//休日範囲チェックメソッド
	//param チェックしたい日付FROM(date)/チェックしたい日付TO(date)
	//return 休日リスト(List<Date>)
	public static Set<Date> getHolidays(Date from_date, Date to_date){
		List<Holiday> holidays = [select Id, Name, ActivityDate from Holiday where ActivityDate >= :from_date and ActivityDate <= :to_date];
		Set<Date> dates;
		if(holidays != null){
			dates = new Set<Date>();
			
			for(Holiday holiday : holidays){
				dates.add(holiday.ActivityDate);
			}
		}
		return dates;
	}
}