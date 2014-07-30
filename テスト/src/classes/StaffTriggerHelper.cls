public with sharing class StaffTriggerHelper {
	private static boolean alreadyCreatedTasks = false;
	
	public static boolean hasAlreadyCreatedStaffs() {
		return alreadyCreatedTasks;
	}
	
	// この変数を true に設定すると、 
	// Web 要求 (または Test メソッド) 実行中は 
	// この新しい値を維持 
	public static void setAlreadyCreatedStaffs() {
		alreadyCreatedTasks = true;
	}
	
	public static void setAlreadyCreatedStaffsFalse() {
		alreadyCreatedTasks = false;
	}
}