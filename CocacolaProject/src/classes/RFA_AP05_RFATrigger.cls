/*
 *  Class            : RFA_AP05_RFATrigger
 *  Author           : Accenture
 *  Version History  : 1.0
 *  Creation         : 05/14/2012
 *  Assumptions      : N/A
 *  Description      : To - Do
 *                                  
 *  Updated by Jia Hu on 2013/10/25
 *  LevelStage__c removed on 2013/11/07
 *  Level__c, RFA_CL039 = Post-Circulation, RFA_CL038 = Pre-Circulation removed on 2013/11/30
 *  RFA_CL0133 removed
 */
 
//called by RFA_RFATrigger on RFA__c 
public class RFA_AP05_RFATrigger{
    
    private static Map<Id, String> recordTypeIdsMap 
        = new Map<ID, String>();
        
    private static Map<String, List<RFACapitalExpenditure__c>> capitalExpentureMap 
        = new Map<String, List<RFACapitalExpenditure__c>>();  
    
    public static Map<String, Map<String, RecordType>> RECORDTYPESMAP 
        = RFAGlobalConstants.RECORDTYPESMAP;
    // variable for storing the SObject Record type mapping
    public static Map<String, RecordType> approverRecordTypeMap 
        = RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName());
    
    public static Map<String, RecordType> rfaRecordTypeMap 
        = RECORDTYPESMAP.get(Schema.sObjectType.RFA__c.getName());
    
    public static boolean isFirstRun = true;
    
    public static boolean emailAtCirculation = true;
    public static boolean emailAtRTR = true;
    public static boolean emailAtComplete = true;
    
    public static boolean createPDF = true;
    
    public rfa_Ap02_Shareutil shareUtil
        = new rfa_Ap02_Shareutil();
          
      //WrapperCapitalExpenditure
      public class wrapperCapitalExpenditure
      {
            public String recordTypeName;                 
      }
            
      // constructor for the class
      public RFA_AP05_RFATrigger()
      {
            recordTypeIdsMap 
            	= RFA_Util_RecordTypeHelper.getRecordTypeName(Schema.sObjectType.RFA__c.getName());
      } 


	public static String getNextRFANo(integer intCurrentRFANo) {
		Integer LengthOfNo = 8;
		String strNextRFANo;
		
		String strTempRFANo = String.valueOf(intCurrentRFANo + 1);
		
		integer intNoLength = strTempRFANo.length();
		
		for(Integer i = 0; i < (LengthOfNo - intNoLength); i++) {//
			strTempRFANo = '0' + strTempRFANo;
		}
		
		strNextRFANo = 'RFA#-' + strTempRFANo;
		
		return strNextRFANo;
	}    
	
	
	//for Insert
	public void processTravelAndEntertainmentRFAs(List<RFA__c> rfaNewList) {
		for(RFA__c rfa : rfaNewList) {
			if(rfa.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_Travel_Expenses_REQUEST).Id
			) {
				//system.debug('------- rfa.Estimated_Cost_Transportation__c: ' + rfa.Estimated_Cost_Transportation__c);
				
				rfa.RequestAmountFunctionalCurrency__c = 
					getCurrencyConfirmation(rfa.Estimated_Cost_Transportation__c) 
					+ getCurrencyConfirmation(rfa.Estimated_Cost_Accommodation__c);
				/*
				if(rfa.Estimated_Cost_Transportation__c != null && rfa.Estimated_Cost_Accommodation__c != null) {
					rfa.RequestAmountFunctionalCurrency__c = rfa.Estimated_Cost_Transportation__c + rfa.Estimated_Cost_Accommodation__c;
				} else if(rfa.Estimated_Cost_Transportation__c != null && rfa.Estimated_Cost_Accommodation__c == null) {
					rfa.RequestAmountFunctionalCurrency__c = rfa.Estimated_Cost_Transportation__c;
				} else if(rfa.Estimated_Cost_Transportation__c == null && rfa.Estimated_Cost_Accommodation__c != null) {
					rfa.RequestAmountFunctionalCurrency__c = rfa.Estimated_Cost_Accommodation__c;
				} else if(rfa.Estimated_Cost_Transportation__c == null && rfa.Estimated_Cost_Accommodation__c == null) {
					rfa.RequestAmountFunctionalCurrency__c = 0;
				} */
			}
			
			if(rfa.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_Entertainment_REQUEST).Id) {
				
				rfa.RequestAmountFunctionalCurrency__c = 
					getCurrencyConfirmation(rfa.Estimated_Payment_1__c) 
					+ getCurrencyConfirmation(rfa.Estimated_Payment_2__c) 
					+ getCurrencyConfirmation(rfa.Estimated_Payment_3__c);
				
			}			
			
			
		}
	}		
	
	public Decimal getCurrencyConfirmation(Decimal inputCurrency) {
		if(inputCurrency == null) {
			return 0;
		} else {
			return inputCurrency;
		}
	}
	
	//for Update
	public void processTravelAndEntertainmentRFAs(List<RFA__c> rfaNewList, Map<Id, RFA__c> rfaOldMap) {
		for(RFA__c rfa : rfaNewList) {
			if(rfa.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_Travel_Expenses_REQUEST).Id
				&& (rfa.Estimated_Cost_Transportation__c != rfaOldMap.get(rfa.Id).Estimated_Cost_Transportation__c
				   || 
				   rfa.Estimated_Cost_Accommodation__c != rfaOldMap.get(rfa.Id).Estimated_Cost_Accommodation__c
				   )
			) {
				rfa.RequestAmountFunctionalCurrency__c = 
					getCurrencyConfirmation(rfa.Estimated_Cost_Transportation__c) 
					+ getCurrencyConfirmation(rfa.Estimated_Cost_Accommodation__c);				
				/*
				if(rfa.Estimated_Cost_Transportation__c != null && rfa.Estimated_Cost_Accommodation__c != null) {
					rfa.RequestAmountFunctionalCurrency__c = rfa.Estimated_Cost_Transportation__c + rfa.Estimated_Cost_Accommodation__c;
				} else if(rfa.Estimated_Cost_Transportation__c != null && rfa.Estimated_Cost_Accommodation__c == null) {
					rfa.RequestAmountFunctionalCurrency__c = rfa.Estimated_Cost_Transportation__c;
				} else if(rfa.Estimated_Cost_Transportation__c == null && rfa.Estimated_Cost_Accommodation__c != null) {
					rfa.RequestAmountFunctionalCurrency__c = rfa.Estimated_Cost_Accommodation__c;
				} else if(rfa.Estimated_Cost_Transportation__c == null && rfa.Estimated_Cost_Accommodation__c == null) {
					rfa.RequestAmountFunctionalCurrency__c = 0;
				} */				
				
			}
			
			if(rfa.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_Entertainment_REQUEST).Id
			  && (rfa.Estimated_Payment_1__c != rfaOldMap.get(rfa.Id).Estimated_Payment_1__c
			    || rfa.Estimated_Payment_2__c != rfaOldMap.get(rfa.Id).Estimated_Payment_2__c
			    || rfa.Estimated_Payment_3__c != rfaOldMap.get(rfa.Id).Estimated_Payment_3__c
			  )			
			) {
				//rfa.RequestAmountFunctionalCurrency__c = rfa.Estimated_Payment_1__c + rfa.Estimated_Payment_2__c + rfa.Estimated_Payment_3__c;
				rfa.RequestAmountFunctionalCurrency__c = 
					getCurrencyConfirmation(rfa.Estimated_Payment_1__c) 
					+ getCurrencyConfirmation(rfa.Estimated_Payment_2__c) 
					+ getCurrencyConfirmation(rfa.Estimated_Payment_3__c);
			}			
			
			
		}
	}	
	
	
	
	
                
  /*
  	called from RFA_RFATrigger: before update
  */    
	public static Set<String> validateRFA(RFA__c rfaObj, RFA__c oldRFAObj)
    {
        Set<String> errorSet = new Set<String>();
  
        //RFA_VR01_HighlyRestrictedRFAValidation
        if(
        	(
        		rfaObj.Stage__c <> oldRFAObj.Stage__c
        	) 
        	&& rfaObj.Stage__c <> RFAConstants.RFA_STATUS_DRAFT //'Draft'
          )
        {
                
                //RFA_VR02_RequestAmountRequired
                // should change !
                //RFA_CL107: Enter the Request Amount (JPY)
                if(rfaObj.RequestAmountFunctionalCurrency__c == null)
                {
                    errorSet.add(System.Label.RFA_CL107);
                }
                
                
                system.debug('----- RecordTypeId: ' + rfaObj.RecordTypeId);
                system.debug('----- rfaRecordTypeMap: ' + rfaRecordTypeMap);
                
                //RFA_VR06_InitialBudgetYearRequired
                if(RFAConstants.isBlank(rfaObj.InitialBudgetYear__c) 
                   && (rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_Medium_PROJECT_REQUEST).Id
                   	   || rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id
                       //|| rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_GROUP_CONSOLIDATED_PLAN).Id
                       || rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST).Id
                       //|| rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CAPPR_REQUEST).Id
                      )
                  )
                {                    
                    //RFA_CL111: Select the Budget Year
                    errorSet.add(System.Label.RFA_CL111);
                }
                
                //RFA_VR08_BudgetTypeRequired               
                if(RFAConstants.isBlank(rfaObj.BudgetType__c) 
                   && (rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_Medium_PROJECT_REQUEST).Id
                   	   || rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id
                       || rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST).Id
                       //|| rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CAPPR_REQUEST).Id
                      )
                  )
                {
                	//RFA_CL113: Select the Budget Type
                    errorSet.add(System.Label.RFA_CL113);
                }
                
                //RFA_VR07_CapitalPlanIndicatorRequired               
                if(RFAConstants.isBlank(rfaObj.IsthisanAnnualCapitalPlanrequest__c)
                   && (rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_Medium_PROJECT_REQUEST).Id
                       || rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id
                       || rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST).Id
                       //|| rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CAPPR_REQUEST).Id
                      )
                  )
                {
                    //RFA_CL112: Is this an Annual Capital Plan request? Select Yes or No
                    errorSet.add(System.Label.RFA_CL112);
                }                                    
                                            
                /*
                    updated by Jia Hu on 2013/10/28
                */
                if(RFAConstants.isBlank(rfaObj.PrimaryCOACategory__c))
                {
                    errorSet.add(RFAConstants.Primary_COA_Category_MandatoryMsg);
                }
                                                
                //RFA_VR15_UpdateCordAdmFields
                
                if(
                	//rfaObj.Level__c == 'Return To Sender' //replaced by Jia Hu on 2013/11/30
                	rfaObj.Stage__c == RFAConstants.RFA_STATUS_ReturnToRequester //'Return To Sender'
                   && (rfaObj.CapitalManagementAdministered__c  <> oldRFAObj.CapitalManagementAdministered__c
                       || rfaObj.Ratification__c  <> oldRFAObj.Ratification__c 
                       || rfaObj.Comments__c  <> oldRFAObj.Comments__c
                       || rfaObj.IncludeInCapitalReports__c  <> oldRFAObj.IncludeInCapitalReports__c))
                {
                    errorSet.add(System.Label.RFA_CL118);                    
                }       
                String rfaRecordTypeName = recordTypeIdsMap.get(rfaObj.RecordTypeId);
                System.debug('Three year cash spent total : ' + rfaObj.ThreeYearCashSpendTotalFC__c);
                System.debug('RFA Request Amount total : ' + rfaObj.RequestAmountFunctionalCurrency__c);

                // GA 5/13/2013: Added Stage != RFA_CL039 for FR1.83 enhancement during 2013 Q1 release
                //revised by Jia Hu on 2013/10/27 added 'Small Project Request ( < 25MM )'
                //error handling: errorSet
                if( (rfaRecordTypeName == RFAConstants.RECORDTYPE_Medium_PROJECT_REQUEST
                		//System.Label.RFA_CL050  
                    || rfaRecordTypeName == RFAConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST
                    	//System.Label.RFA_CL051 
                    || rfaRecordTypeName == RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST ) 
                    //&& rfaObj.Stage__c != System.Label.RFA_CL039 //removed by Jia Hu on 2013/11/30
                    ) // RFA_CL039 = Post-Circulation
                {
                    if (rfaObj.ThreeYearCashSpendTotalFC__c < rfaObj.RequestAmountFunctionalCurrency__c)
                    {   
                    	//RFA_CL094: The Three Year Cash Spend Total is
                    	//RFA_CL096: less than the RFA Request Amount (FC).
                    	//The Three Cash Spend Total is XXXX less than the RFA Request Amount (FC).                             
                        errorSet.add(
                        	Label.RFA_ErrorMsg_RQAmount_3year 
                        	/*
                        	'3ヵ年現金支出合計額が申請合計金額と一致しません。 / ' 
                        	+ System.Label.RFA_CL094 + ' ' 
                        	+ (rfaObj.RequestAmountFunctionalCurrency__c - rfaObj.ThreeYearCashSpendTotalFC__c)+ ' ' 
                        	+ System.Label.RFA_CL096*/
                        	);
                    }
                    else if(rfaObj.ThreeYearCashSpendTotalFC__c > rfaObj.RequestAmountFunctionalCurrency__c)
                    {                               
                        errorSet.add(
                        	Label.RFA_ErrorMsg_RQAmount_3year 
                        	/*
                        	'3ヵ年現金支出合計額が申請合計金額と一致しません。 / ' 
                        	+ System.Label.RFA_CL094 +' '
                        	+ (rfaObj.ThreeYearCashSpendTotalFC__c - rfaObj.RequestAmountFunctionalCurrency__c)+' ' 
                        	+ System.Label.RFA_CL097*/
                        	);
                    }
                    
                    if (rfaObj.CapitalExpenditureTotalFC__c < rfaObj.RequestAmountFunctionalCurrency__c)
                    {
                    	//RFA_CL095: The Capital Request Details Total is
                    	//RFA_CL096: less than the RFA Request Amount (FC). 
                    	//The Capital Request Details Total is XXXX less than the RFA Request Amount (JPY).                               
                        errorSet.add( Label.RFA_ErrorMsg_RQAmount_CapitalR
                        	/*
                        	'資本申請詳細の合計値が申請合計金額と一致しません。 / ' 
                        	+ System.Label.RFA_CL095 
                        	+ ' ' + (rfaObj.RequestAmountFunctionalCurrency__c - rfaObj.CapitalExpenditureTotalFC__c ) 
                        	+ ' ' + System.Label.RFA_CL096 */
                        	);
                    }
                    else if(rfaObj.CapitalExpenditureTotalFC__c > rfaObj.RequestAmountFunctionalCurrency__c)
                    {
                    	//RFA_CL097: greater than the RFA Request Amount (FC).                               
                        errorSet.add(
                        	Label.RFA_ErrorMsg_RQAmount_CapitalR
                        	/*
                        	'資本申請詳細の合計値が申請合計金額と一致しません。 / ' 
                        	+ System.Label.RFA_CL095 
                        	+ ' ' + (rfaObj.CapitalExpenditureTotalFC__c - rfaObj.RequestAmountFunctionalCurrency__c)
                        	+ ' ' + System.Label.RFA_CL097*/
                        	);
                    }
                } 
                
                /*
                Requirement #FR1.48
                Description #To bypass Request Amount (fc) Vs Three Year Cash Specnd validation for General Request RFAs.
                History     #Modified (Else To Else If) by ASHWANI KAUSHIK on 03-May-2013
                */ 
             	//RFA_CL122: General Request   RFA_CL039: Post-Circulation
                else if (rfaRecordTypeName != RFAConstants.RECORDTYPE_General_PROJECT_REQUEST 
                		&& rfaRecordTypeName != RFAConstants.RECORDTYPE_Travel_Expenses_REQUEST
                		&& rfaRecordTypeName != RFAConstants.RECORDTYPE_Entertainment_REQUEST
                	//System.Label.RFA_CL122 
                	//&& rfaObj.Stage__c != System.Label.RFA_CL039 //removed by Jia Hu on 2013/12/02
                )
                {
                	system.debug('------ In checking Amount -- RFA RecordTypeName: ' + rfaRecordTypeName + ' Stage: ' + rfaObj.Stage__c);
                    System.debug('Three year cash spent total : ' + rfaObj.ThreeYearCashSpendTotalFC__c);
                    System.debug('RFA Request Amount total : ' + rfaObj.RequestAmountFunctionalCurrency__c);
                    if (rfaObj.ThreeYearCashSpendTotalFC__c < rfaObj.RequestAmountFunctionalCurrency__c)
                    {
                    	//RFA_CL094: The Three Year Cash Spend Total is 
                    	//RFA_CL096: less than the RFA Request Amount (FC).                              
                        errorSet.add( Label.RFA_ErrorMsg_RQAmount_3year 
                        	/*
                        	'3ヵ年現金支出合計額が申請合計金額と一致しません。 / ' 
                        	+ System.Label.RFA_CL094 + ' ' 
                        	+ (rfaObj.RequestAmountFunctionalCurrency__c - rfaObj.ThreeYearCashSpendTotalFC__c) 
                        	+ ' ' + System.Label.RFA_CL096 */
                        	);
                    }
                    else if(rfaObj.ThreeYearCashSpendTotalFC__c > rfaObj.RequestAmountFunctionalCurrency__c)
                    {    
                    	//RFA_CL094: The Three Year Cash Spend Total is 
                    	//RFA_CL097: greater than the RFA Request Amount (FC).                          
                        errorSet.add(
                        	Label.RFA_ErrorMsg_RQAmount_3year 
                        	/*
                        	'3ヵ年現金支出合計額が申請合計金額と一致しません。 / ' 
                        	+ System.Label.RFA_CL094 + ' '
                        	+ (rfaObj.ThreeYearCashSpendTotalFC__c - rfaObj.RequestAmountFunctionalCurrency__c) 
                        	+ ' ' + System.Label.RFA_CL097 */
                        	);
                    }   
                }
                
                
            /****************The system will validate that a Primary Point of Contact user has been added to 
                                the RFA upon the RFA leaving the Draft Level/Stage********************/   
           //RFA_CL0133: Please add Primary Point of Contact in the RFA Approver/User section    
           // changed from LevelStage__c -> Stage__c in if() conditions by Jia Hu on 2013/11/07         
           if(
           	oldRFAObj.Stage__c != null 
           	&& oldRFAObj.Stage__c == RFAConstants.RFA_STATUS_DRAFT //'Draft' 
           	&& rfaObj.Stage__c != RFAConstants.RFA_STATUS_DRAFT //'Draft' 
           	&& rfaObj.Stage__c != null
           	)
           {
           	   //removed by Jia Hu on 2013/11/29
           	   /*
               List<RFAUserRole__c> RFA_UR = [
               		select id from RFAUserRole__c 
                    where (RecordTypeId =: approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id) 
                    and RFA__c =: rfaObj.id 
               ];
                    //Checking records in Child object with respect to expected RT.
               if (!(RFA_UR.size() > 0)){
               		errorSet.add(System.Label.RFA_CL0133);
               }*/
               
               List<RFAUserRole__c> RFA_UR_Approver = [select id from RFAUserRole__c 
                                                where (RecordTypeId =: approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id) 
                                                and RFA__c =: rfaObj.id ];
               if (!(RFA_UR_Approver.size() > 0)){
               		errorSet.add(' 承認者をRFA承認者/ユーザ セクションに追加してください。 / Please add Approver in the RFA Approver/User section');
               }               
                   
                   //added by Jia Hu on 2013/10/29
                   //need additional attached file for some proposals
                   //if((rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST).Id) 
                   //		&& rfaObj.RequestAmountFunctionalCurrency__c >= 50000000) 
               if(
                   (rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST).Id) 
                   	 || (rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id)
                   	 || (rfaObj.RecordTypeId == rfaRecordTypeMap.get(RFAConstants.RECORDTYPE_Medium_PROJECT_REQUEST).Id)
                   )                           		           
               {
                   
                   	List<Attachment> attList = [select id, name, ParentId from Attachment where ParentId =: rfaObj.Id];
                   	if( !(attList != null && attList.size() > 0) ) {
                   		errorSet.add(
                   			Label.RFA_ErrorMsg_Attachment
                   			//'添付ファイルが必要です / Attachment is needed! '
                   			);
                   	}
                   
               }
                   
            }
            /******************Draft Level/Stage validation End's here*****************************************/                
            
        }//end of if();
        
        return errorSet;      
    }//end of validateRFA();
    
    /**
      *  @ Description : method to process RFAs post insert operation. This method is called from Trigger.
      *  @ param : list<RFA__c>
      *  @ return : void
      */    
    //called from RFA_RFATrigger: after insert  
    public void processRFAAfterInsert(List<RFA__c> rfaInsertList)
    {
          // List of 3 year cash spent records for insert       
        List<ThreeYearCashSpend__c> threeYearCashSpendForInsert = new List<ThreeYearCashSpend__c>();
        // String variable to hold Additional Year text from custom label
        //RFA_CL070: Additional Years
        String additionalYears = System.label.RFA_CL070;
        for(RFA__c rfa : rfaInsertList)
        {
            Date d =  Date.today();
            Integer year;
           
            /*
            Requirement #FR1.35
            Description #Three Year Cash Spend Table year must start with initial budget year.
            History     #Added by ASHWANI KAUSHIK on 18-Apr-2013
            */
            
            //Integer year = d.year();  - Commented by ASHWANI KAUSHIK on 18-Apr-2013 for FR1.35            
            // if(recordTypeIdsMap.get(rfa.RecordTypeId)!=System.label.RFA_CL122)
            //   {
               
               if(rfa.InitialBudgetYear__c != null) year = Integer.Valueof(rfa.InitialBudgetYear__c);
                else year = d.year();
            // }            
            // else year = d.year();
            /* End */ 
            
            // Cash spent record for current Year
            threeYearCashSpendForInsert.add(new ThreeYearCashSpend__c(RFA__c = rfa.Id, Year__c = String.valueOf(year)));
            
            // Cash spent record for Current year + 1
            threeYearCashSpendForInsert.add(new ThreeYearCashSpend__c(RFA__c = rfa.Id, Year__c = String.valueOf(year + 1)));
            
            // Cash spent record for current year + 2
            threeYearCashSpendForInsert.add(new ThreeYearCashSpend__c(RFA__c = rfa.Id, Year__c = String.valueOf(year + 2)));
            
            // cash spent record for additional years.
            threeYearCashSpendForInsert.add(new ThreeYearCashSpend__c(RFA__c = rfa.Id, Year__c = additionalYears));
                              
            if(!threeYearCashSpendForInsert.isEmpty())
            {
                Database.Saveresult [] result = RFA_Util_PerformDML.performInsOperation(threeYearCashSpendForInsert);            
                for(Database.SaveResult saveResult : result)
                {
                	system.debug('------- SaveResult for threeYearCashSpendForInsert: ' + result);
                    // To -Do : Define code logic for this block if(!result.isSuccess) throw Exception;
                }               
            }   
        }
    }
    
    /**
      *  @ Description : method to update the year value on RFA Three Year Cash Spend related records. This method is called from Trigger.
      *  @ param : list<RFA__c>
      *  @ return : void
      */    
    public void rfaThreeYearCashSpendUpdate(Set<Id> rfaIdsInitialBudgetYearChange)
    {
        // List of 3 year cash spent records to update       
        List<ThreeYearCashSpend__c> threeYearCashSpendToUpdate = new List<ThreeYearCashSpend__c>();
        // String variable to hold Additional Year text from custom label
        String additionalYears = System.label.RFA_CL070;

        Date d =  Date.today();
        Integer year, i;

        for(RFA__c rfa : [
        	Select ID, InitialBudgetYear__c,RecordTypeId, 
        		(Select Year__c From Three_Year_Cash_Spend__r 
        			WHERE Year__c != :additionalYears ORDER BY Year__c asc) 
        	From RFA__c r WHERE ID IN :rfaIdsInitialBudgetYearChange])
        {
            i = 0; // counter for year incrementation
            
            if(recordTypeIdsMap.get(rfa.RecordTypeId) != 
            	RFAConstants.RECORDTYPE_General_PROJECT_REQUEST
            	//System.label.RFA_CL122
            	)
                  { 
                      if(rfa.InitialBudgetYear__c!=null) 
                               year=Integer.Valueof(rfa.InitialBudgetYear__c);
                     else 
                               year = d.year();
                  }
            else
                   year = d.year();
            
            //Assuming Three Year Cash Spend is ascending order by Year and does not include additional year based on for loop rfa object SOQL filter  
            //Update Three_Year_Cash_Spend__r.Year__c field value starting with RFA Initial Budget Year value and incrementing year accordingly.
            for (ThreeYearCashSpend__c TYCS: rfa.Three_Year_Cash_Spend__r)
            {
                TYCS.Year__c = String.valueOf(year + i++);
                threeYearCashSpendToUpdate.add(TYCS);
            }
        
            if(!threeYearCashSpendToUpdate.isEmpty())
            {
                Database.Saveresult [] result = RFA_Util_PerformDML.performUpdOperation(threeYearCashSpendToUpdate);
                
                for(Database.SaveResult saveResult : result)
                {
                    // To -Do : Define code logic for this block if(!result.isSuccess) throw Exception;
                    system.debug('------ Database.SaveResult in Method rfaThreeYearCashSpendUpdate()' + saveResult);
                }
                
            }   
        }
    }
 
    
    /**
      *  @ Description : method to process RFAs post insert operation for capital expenditure. This method is called from Trigger.
      *  @ param : list<RFA__c>
      *  @ return : void
      */    
    //called from RFA_RFATrigger: after insert  
    public void processRFAAfterInsertForCapitalExpenditure( List<RFA__c> rfaInsertList )
    {
        List<Capital_Expenditure__c> capitalExpenditureForInsert = new List<Capital_Expenditure__c>();
        for(RFA__c rfa : rfaInsertList)
        {
            /************************************Capital Expenditure Entry **********************************************/
            String rfaRecordTypeName = recordTypeIdsMap.get(rfa.RecordTypeId);
            system.debug('---------- rfaRecordTypeName: ' + rfaRecordTypeName);
            
            capitalExpentureMap = createCapitalExpenditure();
                  system.debug(rfa.RecordType.Name + ' ----record name-- ' + rfaRecordTypeName);
                  system.debug('\n capitalExpentureMap : ' + capitalExpentureMap);
                  //system.debug('----- Custom Label - Label.RFA_CL050: ' + Label.RFA_CL050); //RFA_CL050: Small Project Request A
                  if(rfaRecordTypeName  == 
                  	RFAConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST
                  	//Label.RFA_CL051
                  	) //RFA_CL051: Capital Project Request
                  {
                        for(RFACapitalExpenditure__c tempMap : capitalExpentureMap.get(
                        	RFAConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST
                        	//Label.RFA_CL051
                        	)
                        )                       	              
                        {
                            capitalExpenditureForInsert.add(
                            	new Capital_Expenditure__c(
                            		RecordTypeId = tempMap.RecordTypeId__c, 
                            		Amount__c = 0,
                            		AssetCategory__c = tempMap.AssetCategory__c,
                            		InvestmentObjectiveCategory__c = tempMap.InvestmentObjective__c,
                            		RFA__c = rfa.Id
                            	)
                            );
                            
                        }      
                        
                  }
                  else if(rfaRecordTypeName == Label.RFA_CL050)
                  {
                  		system.debug('--- Label.RFA_CL050: ' + Label.RFA_CL050 + ' -- capitalExpentureMap: ' + capitalExpentureMap);	
                        for(RFACapitalExpenditure__c tempMap : capitalExpentureMap.get(Label.RFA_CL050))              
                        {
                            capitalExpenditureForInsert.add(
                            	new Capital_Expenditure__c(
                            		RecordTypeId = tempMap.RecordTypeId__c ,
                            		Amount__c = 0,
                            		AssetCategory__c = tempMap.AssetCategory__c,
                            		InvestmentObjectiveCategory__c = tempMap.InvestmentObjective__c,
                            		RFA__c = rfa.Id
                            	)
                            );
                            system.debug('----- For Insert: ' + capitalExpenditureForInsert);
                        }
                  } //RECORDTYPE_SMALL_PROJECT_REQUEST_LessThan25MM
                  else if(rfaRecordTypeName == RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST) //added by Jia Hu on 2013/10/27
                  {		//RECORDTYPE_SMALL_PROJECT_REQUEST_LessThan25MM
                        for(RFACapitalExpenditure__c tempMap:capitalExpentureMap.get(RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST))              
                        {
                            capitalExpenditureForInsert.add(
                            	new Capital_Expenditure__c(
                            		RecordTypeId = tempMap.RecordTypeId__c ,
                            		Amount__c = 0,
                            		AssetCategory__c = tempMap.AssetCategory__c,
                            		InvestmentObjectiveCategory__c = tempMap.InvestmentObjective__c,
                            		RFA__c = rfa.Id
                            		)
                            	);
                            system.debug('----- For Insert: ' + capitalExpenditureForInsert);
                        }
                  }                                              
            }
        
            if(!capitalExpenditureForInsert.isEmpty())
            {
                  Database.Saveresult [] result = RFA_Util_PerformDML.performInsOperation(capitalExpenditureForInsert);
                  
                  for(Database.SaveResult sr : result)
                  {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('---- The following error has occurred.');                    
                        System.debug('---- ' + err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('fields that affected this error: ' + err.getFields());
                    }
                        // To -Do : Define code logic for this block if(!result.isSuccess) throw Exception;
                  }                
            } 
    }
    
     /**
      *  @ Description : method to process RFAs if record type change at RFA level then delete the capital expenditure table. This method is called from Trigger.
      *  @ param : list<RFA__c>
      *  @ return : void
      */    
    public void processRFABeforeUpdateForCapitalExpenditure(Set<Id> rfaUpdateListIds)
    {
        List<Capital_Expenditure__c> capitalExpenditureForDelete=new List<Capital_Expenditure__c>();
        Set<Id> rfaIds=new Set<Id>();
        capitalExpenditureForDelete=[Select id from Capital_Expenditure__c where rfa__c IN: rfaUpdateListIds];
        System.debug('capitalExpenditureForDelete::::'+capitalExpenditureForDelete);
        if(!capitalExpenditureForDelete.isEmpty())
            {
                  Database.DeleteResult [] result = RFA_Util_PerformDML.performDelOperation(capitalExpenditureForDelete);
                  
                  for(Database.DeleteResult DeleteResult : result)
                  {
                        // To -Do : Define code logic for this block if(!result.isSuccess) throw Exception;
                  }               
            }        
    }

     /**
      *  @ Description : method to Capture Primary Contact, 
      					CO-CREATOR, Approver, Agents & Location Coordinator. 
      					This method is called from Trigger.
      *  @ param : RFA__c
      *  @ return : void
      */    
      
    //level removed by Jia Hu on 2013/11/29
    //public void captureEmailTempValues(RFA__c rfa, Map<Id, String> levelMap){
    public void captureEmailTempValues(RFA__c rfa){ 	
    // ********************** RFA Capture Primary Contact, CO-CREATOR, Approver, Agents & Location Coordinator  ********************/
    // Capture Primary Point of Contct Names Exist on current RFA record.
    // Capture Co-Creator Names Exist on current RFA record.
    // Capture Approver Names Exist on current RFA record.
    // Capture Agents Names Exist on current RFA record from respective RFA Approvers.
    	set<ID> rtID = new set<ID>();
   	 	rtID.add(approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id);
    	//rtID.add(approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id);
    	rtID.add(approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id);
    
    //set<String> uniqueLevels = new Set<String>();
    //uniqueLevels.addAll(levelMap.values());
    
    
    string POC, Approver, Agents; //, LocCoor; //CoCre, 
    set<Id> UniqeVal = new set<Id>(); //Uniqe value of Creator, Co-Creator, and Primary Point of Contact
    UniqeVal.add(rfa.CreatedById);
    for(RFAUserRole__c rfaUser : [
    	Select UserName__c, UserName__r.Name, Agent1__c, Agent1__r.Name, Agent2__c, Agent2__r.Name, 
                                   Agent3__c, Agent3__r.Name, RecordTypeId FROM RFAUserRole__c 
                                   where (RecordTypeId in: rtID ) and RFA__c =: rfa.Id])
    {
        if(rfaUser.RecordTypeId == approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id){
            Boolean res = UniqeVal.contains(string.valueof(rfaUser.UserName__c).substring(0,15));
            system.debug(' Set Comp Res ++ ' + res);
            system.debug(' Set Values ++ ' + UniqeVal);
              if(rfaUser.UserName__c != null){// && !(UniqeVal.contains(string.valueof(rfaUser.UserName__c).substring(0,15)))){
                   if(POC == null) {POC = rfaUser.UserName__r.Name;}
                   else { POC = POC + ', ' + rfaUser.UserName__r.Name;}
                   UniqeVal.add(rfaUser.UserName__c);
              }
        }
        
        if(rfaUser.RecordTypeId==approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_Approver).Id){
              if(rfaUser.UserName__c!=null){
                   if(Approver == null){Approver = rfaUser.UserName__r.Name;}
                   else{ Approver = Approver + ', ' + rfaUser.UserName__r.Name;}
                   
                   if(rfaUser.Agent1__c != null){
                          if(Agents == null){Agents = rfaUser.Agent1__r.Name;}
                          else{ Agents = Agents + ', ' + rfaUser.Agent1__c;}
                      }
                      if(rfaUser.Agent2__c != null){
                          if(Agents == null){Agents = rfaUser.Agent2__r.Name;}
                          else{ Agents = Agents + ', ' + rfaUser.Agent2__r.Name;}
                      }
                      if(rfaUser.Agent3__c!= null){
                          if(Agents == null){Agents = rfaUser.Agent3__r.Name;}
                          else{ Agents = Agents + ', ' + rfaUser.Agent3__r.Name;}
                      }
              }
        }
        
    } 
    /*
    if(rfa.ProfitCenterName__c != null)
    {
        for(ProfitCenterUserRole__c PCUR: [
        	select ProfitCenter__c, UserName__c, UserName__r.Name from ProfitCenterUserRole__c 
                                           where 
                                           	//Level__c IN: uniqueLevels 
                                           	//and  
                                           	ProfitCenter__c =:rfa.ProfitCenterNumber__c 
                                           //and  UserType__c ='Coordinator'
                                           	and  UserType__c =: RFAConstants.ProfitCenterUserRole_UserType_Coordinator
                                           ]
           ) //Location Coordinator
        {
            if(PCUR.UserName__c!=null)
            {
                           if(LocCoor==null){LocCoor = PCUR.UserName__r.Name;}
                           else{ LocCoor = LocCoor+', '+PCUR.UserName__r.Name;}
            }
        }
    } */

    rfa.POC_Name__c = null;
    //rfa.CO_CREATOR_Name__c = null;
    rfa.Approver_Name__c = null;
    rfa.Agents_Name__c = null;
    //rfa.LOC_Name__c = null;
                      
    if(POC != null) { rfa.POC_Name__c = POC; }
    //if(CoCre!=null)rfa.CO_CREATOR_Name__c = CoCre;
    if(Approver != null) { rfa.Approver_Name__c = Approver; }
    if(Agents != null) { rfa.Agents_Name__c = Agents; }
    //if(LocCoor != null) { rfa.LOC_Name__c = LocCoor; }
    
    // ********************** RFA Capture Primary Contact, CO-CREATOR, Approver,Agents & Location Coordinator logic End here  ********************/
    }
    
    
    /**
      *  @ Description : This method contains logic to notify local ccordinator when the RFA has resumed from "Return To Sender"                    
      *  @ param : Set<String>, Map<String, RFA__c>
      *  @ return : void
      */
    //public void notifyLocalCoordinatorAfterReturnToSender(Map<Id, String> levelMap,  Map<String, String> rfaMap)
    /* removed by Jia Hu on 2013/12/01
    public void notifyLocalCoordinatorAfterReturnToSender(Map<String, String> rfaMap)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        Set<String> profitCenterNumbers = new Set<String>();
        
        //set<String> uniqueLevels = new Set<String>();
        
        profitCenterNumbers.addAll(rfaMap.values());
        
        //uniqueLevels.addAll(levelMap.values());
        
        ProfitCenterUserRole__c[] profitCenterUserRoles = [
            Select Id, UserName__c, UserType__c, ProfitCenter__c //, 
            	//Level__c 
            FROM ProfitCenterUserRole__c 
            WHERE 
            	//Level__c IN: uniqueLevels 
            	//AND 
            	ProfitCenter__c IN: profitCenterNumbers 
            	//AND UserType__c = 'Coordinator'
            	AND UserType__c =: RFAConstants.ProfitCenterUserRole_UserType_Coordinator
            	]; //Location Coordinator                               
        String breakString = '<BR/>';
        */
        //************ PCLocationCoordinatorBU__c => 2. Business Unit ******************/
        //************ PCLocationCoordinatorCorporate__c => 4. Corporate ***************/
        //************ PCLocationCoordinatorExec__c => 5. Executive ********************/
        //************ PCLocationCoordinatorGroup__c => 3. Group ***********************/
        //************ PCLocationCoordinatorKO__c => 1. Key Operations *****************/
        //************ PCLocationCoordinatorSrExec__c => 6. Senior Executive ***********/
        /*
        for(String rfaId : rfaMap.keySet())
        {          
            for(ProfitCenterUserRole__c profitCenter : profitCenterUserRoles)
            {
                if(rfaMap.get(rfaId) == profitCenter.ProfitCenter__c 
                	//&& levelMap.get(rfaId).contains(profitCenter.Level__c)
                  )
                {
                    Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();             
                    mail.setTargetObjectId(profitCenter.UserName__c);                  
                    mail.setWhatId(rfaId);                     
                    mail.setTemplateId(RFAGlobalConstants.TEMPLATE_RFA_RESUMED_FROM_RETURNTOSENDER);                   
                    mail.saveAsActivity = false;                   
                    mail.orgWideEmailAddressId=Label.RFA_CL131; //-added by RSAS 11-Oct-2012                    
                    mails.add(mail);    
                }
            }
        }                            
            if(!mails.isEmpty()) Messaging.sendEmail(mails);   
    }*/
    
    
     /**
      *  @ Description : This method contains logic to notify local ccordinator when the RFA Stage is set to
      *                  "Return To Sender" or "Pre-Circulation"                    
      *  @ param : Set<String>, Map<String, RFA__c>
      *  @ return : void
      */
    //public void notifyLocalCoordinator(Map<Id, String> levelMap,  Map<String, String> rfaMap)
    /*
    public void notifyLocalCoordinator(Map<String, String> rfaMap)
    {
        //System.debug('\n level map :' + levelMap);
        System.debug('\n rfa map : ' + rfaMap);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        Set<String> profitCenterNumbers = new Set<String>();
        //Set<String> uniqueLevels = new Set<String>();
         
        //=========================START of Fix for INC0073461========================================== 
        RFA__c currRFA = [
        	SELECT Id, Stage__c //, 
        	//LevelStage__c 
        	from RFA__c WHERE Id=:rfaMap.keyset() LIMIT 1];
        System.debug('\n RSAS currRFA ID: ' + currRFA.Id);
        //=========================END of Fix for INC0073461==========================================                                      
                                              
        profitCenterNumbers.addAll(rfaMap.values());
        //uniqueLevels.addAll(levelMap.values());
        
        //System.debug('\n rowcause for the share : ' + levelMap);
        System.debug('\n Rfa map : ' + rfaMap);
        System.debug('\n Profit center set : ' + profitCenterNumbers);
                                             
        ProfitCenterUserRole__c[] profitCenterUserRoles = [
            Select Id, UserName__c, UserType__c, ProfitCenter__c //, Level__c 
            FROM ProfitCenterUserRole__c 
            WHERE 
            	//Level__c IN: uniqueLevels 
            	//AND 
            	ProfitCenter__c IN: profitCenterNumbers 
            	//AND UserType__c = 'Coordinator'
            	AND UserType__c =: RFAConstants.ProfitCenterUserRole_UserType_Coordinator
            	];//Location Coordinator                                
        String breakString = '<BR/>';
        */
        //************ PCLocationCoordinatorBU__c => 2. Business Unit ******************/
        //************ PCLocationCoordinatorCorporate__c => 4. Corporate ***************/
        //************ PCLocationCoordinatorExec__c => 5. Executive ********************/
        //************ PCLocationCoordinatorGroup__c => 3. Group ***********************/
        //************ PCLocationCoordinatorKO__c => 1. Key Operations *****************/
        //************ PCLocationCoordinatorSrExec__c => 6. Senior Executive ***********/
        /*
        for(String rfaId : rfaMap.keySet())
        {                   
            for(ProfitCenterUserRole__c profitCenter : profitCenterUserRoles)
            {
                if(rfaMap.get(rfaId) == profitCenter.ProfitCenter__c 
                	//&& levelMap.get(rfaId).contains(profitCenter.Level__c)
                  )
                {
                    Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();              
                    mail.setTargetObjectId(profitCenter.UserName__c);
                    mail.setWhatId(rfaId);
                     
                    //=========================START of Fix for INC0073461==========================================
                    //System.debug('\n RSAS value of levelMap.get(rfaId): ' +levelMap.get(rfaId) ) ;           
                    System.debug('\n RSAS value of currRFA Stage: ' + currRFA.Stage__c); 
                   
                    if(currRFA.Stage__c == RFAGlobalConstants.RETURN_TO_SENDER)
                    //if(levelMap.get(rfaId) == RFAGlobalConstants.RETURN_TO_SENDER)
                    {
                         System.debug('\n RSAS inside RETURN_TO_SENDER');    
                         mail.setTemplateId(RFAGlobalConstants.TEMPLATE_RETURN_TO_SENDER);
                         mail.saveAsActivity = false; 
                    }                       
                       //else if(levelMap.get(rfaId) == RFAGlobalConstants.RFA_POST_CIRCULATION_STAGE) //- orig code commented out by RSAS 10-Oct-2012
                       /* removed by Jia Hu on 2013/12/02
                       else if(currRFA.Stage__c == RFAGlobalConstants.RFA_POST_CIRCULATION_STAGE) 
                        {
                        System.debug('\n RSAS inside RFA_POST_CIRCULATION_STAGE');   
                        mail.setTemplateId(Label.RFA_CL043); //RFA_CL043: VFT01_UponPostCirculation
                        mail.saveAsActivity = false; //-added by RSAS 10-Oct-2012
                        }
                        */
                    /*
                    else 
                    { 
                    
                     System.debug('\n RSAS inside else TEMPLATE_PRE_CIRCULATION') ;  
                     
                     //need to change Template ??!!
                     //mail.setTemplateId(RFAGlobalConstants.TEMPLATE_PRE_CIRCULATION);
                     mail.saveAsActivity = false;
                    }
                    mail.orgWideEmailAddressId = Label.RFA_CL131; //-added by RSAS 11-Oct-2012 for INC0075225
                    mails.add(mail); 
                    //=========================END of Fix for INC0073461========================================== 
                }
            }
        }                            
            if(!mails.isEmpty()) Messaging.sendEmail(mails);   
    }
    */
   
    //called by RFA_RFATrigger: before update
    public void processRFABeforeShare(Map<Id,Id> rfaList)
    {
        rfa_Ap02_Shareutil shareUtilCls = new rfa_Ap02_Shareutil();
        shareUtilCls.rfaProfitCenterUpdateDeleteOldProfitCenter(rfaList);   
    }
          
     /**
      *  @ Description : This method contains logic to notify Co-Creator and Primary POC when the RFA Stage is set to
      *                  "Return To Sender"                 
      *  @ param : Set<String>, Map<String, RFA__c>
      *  @ return : void
      */
    //called by RFA_RFATrigger: after update for Return to Sender  
    public void notifyRelatedUsers(Set<String> rfaId)
    {
    	//RECORDTYPE_CO_CREATOR removed by Jia Hu on 2013/10/29
        List<RFAUserRole__c> userRolesForUpdate = new List<RFAUserRole__c>();
        for(RFAUserRole__c userRole : [
        	Select Id, UserName__c, 
        	//Level__c, 
        	NotifyUsers__c 
        	FROM RFAUserRole__c             
			WHERE RecordTypeId =: approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_PPOC).Id
                  //OR RecordTypeId =: approverRecordTypeMap.get(RFAGlobalConstants.RECORDTYPE_CO_CREATOR).Id)                                                  
                  AND RFA__c IN: rfaId 
        ])
        {
            userRole.NotifyUsers__c = true;
            userRolesForUpdate.add(userRole);
        }
        if(!userRolesForUpdate.isEmpty()) {update userRolesForUpdate;}
    }
    
    //called from RFA_RFATrigger: after update
    //In which case to notify Info Only??!!
    public void processInfoOnlyNotificationFlag(Set<Id> rfaIds, Map<Id, RFA__c> oldRFAMap)
    {
        List<RFAUserRole__c> infoOnlyForUpdate = new List<RFAUserRole__c>();
        for(RFAUserRole__c userRole: [
        	SELECT Id, RFA__c, 
        		//Level__c, 
        		//RFA_Level__c, 
        		NotifyUsers__c, RFAStage__c //, 
        		//RFA_Current_Level__c 
        		FROM RFAUserRole__c
                WHERE RecordTypeId =: approverRecordTypeMap.get(RFAConstants.RTLabel_RFAUserRole_InfoOnly).Id AND
                Notifyuserfirsttime__c = false AND 
                //RFA_Level__c != :RFAGlobalConstants.CAPITAL_MGMT_HOLD AND
                //RFA_Level__c != :RFAGlobalConstants.RETURN_TO_SENDER AND
                RFAStage__c !=: RFAConstants.RFA_STATUS_ReturnToRequester
                //RFAGlobalConstants.RETURN_TO_SENDER 
                AND                
                RFAStage__c !=: RFAConstants.RFA_STATUS_DRAFT
                //RFAGlobalConstants.RFA_STAGE_DRAFT 
                AND
                RFA__c IN : rfaIds          
        ])
        {
            // Obtain old RFA Stage value
            String oldRFAStage = oldRFAMap.get(userRole.RFA__c).Stage__c;
            //String oldRFALevel = oldRFAMap.get(userRole.RFA__c).Level__c;
            
            // if RFA Level/Stage did not change from Draft and not from Return to Sender and not from Capital Management Hold and...
            // ( if RFA Level = Info Only Level and Stage != Pre-Circulation and != null or if Info Only level is less than RFA level)
            // mark Info Only record to send notification 
            if ( oldRFAStage != RFAConstants.RFA_STATUS_DRAFT
            		//RFAGlobalConstants.RFA_STAGE_DRAFT 
            	//&& oldRFALevel != RFAGlobalConstants.RETURN_TO_SENDER 
            	//&& oldRFALevel != RFAGlobalConstants.CAPITAL_MGMT_HOLD 
            	&& 
					(
						(	//removed by Jia Hu on 2013/11/06
							//shareUtil.compareRFALevel(userRole.Level__c, userRole.RFA_Current_Level__c) == 0 
							//&& 
							//userRole.RFAStage__c != RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE 
							//&& 
							userRole.RFAStage__c != null
						) 
					//|| shareUtil.compareRFALevel(userRole.Level__c, userRole.RFA_Current_Level__c) < 0 
                    //|| userRole.RFA_Level__c == RFAGlobalConstants.PENDING_BOARD_REVIEW 
                    || userRole.RFAStage__c == RFAConstants.RFA_STATUS_CLOSED
                    	//RFAGlobalConstants.RFA_STAGE_CLOSED 
                    || userRole.RFAStage__c == RFAConstants.RFA_STATUS_APPROVED
                    	//RFAGlobalConstants.RFA_STAGE_APPROVED 
                    || userRole.RFAStage__c == RFAConstants.RFA_STATUS_REJECTED
                    	//RFAGlobalConstants.RFA_STAGE_REJECTED
                    )
               )
            {
                userRole.NotifyUsers__c = true;
                infoOnlyForUpdate.add(userRole);
            }
        }
        if(!infoOnlyForUpdate.isEmpty()) {update infoOnlyForUpdate;}
    }
        
    
    //called from RFA_RFATrigger: after update / read only for Reqestor
    public void restrictAccessForKORequester(Set<String> rfaIds)
    {
        List<RFA__Share> rfaShareForUpdate = new List<RFA__Share>();    
        for(RFA__Share rfaShare :[
        	Select Id, parentId, UserOrGroupId, Accesslevel 
        	FROM RFA__Share 
        	Where parentId IN : rfaIds AND RowCause = : Schema.RFA__Share.RowCause.KORequestor__c
        	]
        )
        {
            rfaShare.Accesslevel = 'Read';
            rfaShareForUpdate.add(rfaShare);
        }
        if(!rfaShareForUpdate.isEmpty()) {update rfaShareForUpdate;}
    }
    
    //called from  RFA_RFATrigger (After Insert & After Update)  --->  RFA_AP05_RFATrigger{ processRFAAfterInsertForCapitalExpenditure( List<RFA__c> rfaInsertList) }
    public Map<String,List<RFACapitalExpenditure__c>> createCapitalExpenditure()
    {
        List<RFACapitalExpenditure__c> listSPR = new List<RFACapitalExpenditure__c >();
        List<RFACapitalExpenditure__c> listCPR = new List<RFACapitalExpenditure__c >();
        List<RFACapitalExpenditure__c> listOPR = new List<RFACapitalExpenditure__c >();
        
        Map<String, List<RFACapitalExpenditure__c>> tempMap = new map<String,List<RFACapitalExpenditure__c>>();
        listSPR=[Select AssetCategory__c,InvestmentObjective__c,RecordTypeId__c FROM RFACapitalExpenditure__c where name like 'SPR%'];
        listCPR=[Select AssetCategory__c,InvestmentObjective__c,RecordTypeId__c FROM RFACapitalExpenditure__c where name like 'CPR%'];
        //added by Jia Hu on 2013/10/26
        listOPR=[Select AssetCategory__c,InvestmentObjective__c,RecordTypeId__c FROM RFACapitalExpenditure__c where name like 'OPR%'];
        
        if(listSPR.size() > 0)
            //tempMap.put('Small Project Request',listSPR);  
            //tempMap.put('Small Project Request ( 25MM＜≦50MM )', listSPR); //Small Project Request
            tempMap.put(RFAConstants.RECORDTYPE_Medium_PROJECT_REQUEST, listSPR);
            //RECORDTYPE_SMALL_PROJECT_REQUEST_A
            
        if(listCPR.size() > 0)
            //tempMap.put('Capital Project Request',listCPR);
            tempMap.put(RFAConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST, listCPR);
            
        //added by Jia Hu on 2013/10/26    
        if(listOPR.size() > 0)
            //tempMap.put('Small Project Request ( < 25MM )',listOPR);
            tempMap.put(RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST, listOPR);
            //RECORDTYPE_SMALL_PROJECT_REQUEST_LessThan25MM
            
                        
        return tempMap;
    
    }
    
    
    //Called from RFA_RFATrigger: After Insert & After Update
    //impact on Profit Center member's sharing when RFA is created or Stage changed!
    public void processRFAProfitCenterShare(List<rfa__c> rfaList)
    {
        system.debug('---------- RFA_AP05_RFATrigger.processRFAProfitCenterShare(List<rfa__c> rfaList):   Level: ' + rfaList[0].Stage__c );
            rfa_Ap02_Shareutil shareUtilCls = new rfa_Ap02_Shareutil();
            Map<Id, Map<Id,String>> profitCenterUserRolesAccess = new Map<Id, Map<Id,String>>();
            Map<Id, String> profitCenterUserRolesAtRfaLevel = new Map<Id, String>();
            for(RFA__c rfa: rfaList)
            {
            	//need to check ??!!
                if(
                	rfa.Stage__c == RFAConstants.RFA_STATUS_ReturnToRequester
                	//RFAGlobalConstants.RETURN_TO_SENDER 
                  ) {
                    //updated by Jia Hu on 2013/11/07   considering to remove this
                    profitCenterUserRolesAtRfaLevel.put(rfa.ProfitCenterNumber__c, rfa.Stage__c);
                    
                } else {
                    profitCenterUserRolesAtRfaLevel.put(rfa.ProfitCenterNumber__c, rfa.Stage__c);
                }
                
                if(!profitCenterUserRolesAtRfaLevel.IsEmpty()) {
                    profitCenterUserRolesAccess.put(rfa.Id, profitCenterUserRolesAtRfaLevel);
                }
                
            }
            
            if(!profitCenterUserRolesAccess.IsEmpty())
            {
                //Modified by Ashwani for FR1.86 - added rfaList new parameter
                shareUtilCls.profitCenterAtRfaCreateShare(profitCenterUserRolesAccess);
            }
            
    }
    
    
    //called from RFA_RFATrigger: after insert
    public void processRFAOwnerShare(List<rfa__c> rfaList)
    {
        Map<Id, Id> OwneridAccess = new map<Id,Id>();
        rfa_Ap02_Shareutil shareUtilCls = new rfa_Ap02_Shareutil();
        
        for(RFA__c rfa: rfaList)
        { 
            OwneridAccess.put(rfa.id, Rfa.CreatedById);            
        }
        
        system.debug('KO requestor Class' + OwneridAccess);
        
        if(OwneridAccess.size() > 0)
        {
            shareUtilCls.rfaCreate(OwneridAccess);
        }
       
    }
       
    
    /**
      *  @ Description : This method contains logic to Update the Time Spent in Each Level/Stage field for RFA and the Last Level/Status Change Date
                                 Takes the List of New RFAs and Map of old instance of the RFA as input argument.             
      *  @ param : List<RFA__c>, Map<Id, RFA__c> 
      *  @ return : void
      *
      *  updated by Jia Hu on 2013/10/31   Tasks: remove useless levels; dyas spent in each level
      */
    //called from RFA_RFATrigger: before update trigger  
    public void rfaAgingCalculation(List<RFA__c> rfaLstLvlStsChange, Map<Id, RFA__c> rfaLstLvlStsChangeOld)
    {
        for(RFA__c rfa : rfaLstLvlStsChange)
        {        
            if (rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Draft')
            {
              //  if(rfa.TECH_TimeInDraft__c != NULL)
                //    rfa.TECH_TimeInDraft__c += (System.Now().getTime() - rfa.CreatedDate.getTime());
               // else
                    rfa.TECH_TimeInDraft__c = (System.Now().getTime() - rfa.CreatedDate.getTime());
            }
            else if (//??? need to check
            	//rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == RFAGlobalConstants.RETURN_TO_SENDER 
            	rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == RFAConstants.RFA_STATUS_ReturnToRequester
            )
            {
                if(rfa.TECH_TimeInReturnToSender__c != NULL) {
                    rfa.TECH_TimeInReturnToSender__c += (System.Now().getTime() 
                    	- rfa.TECH_LastStatusChangeDate__c.getTime());
                } else {
                    rfa.TECH_TimeInReturnToSender__c = (System.Now().getTime() 
                    	- rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            /* removed by Jia Hu on 2013/11/30   need to remove the fields later
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == 'CCEJ' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Pre-Circulation')
            //else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '1. Key Operations' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Pre-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInKeyOpsPreCirculation__c != NULL)
                        rfa.TECH_TimeInKeyOpsPreCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInKeyOpsPreCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            */
            //else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == 'CCEJ' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Circulation')
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Circulation')
            //else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '1. Key Operations' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInKeyOpsCirculation__c != NULL)
                        rfa.TECH_TimeInKeyOpsCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInKeyOpsCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            /*
            else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == 'CCEJ' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Post-Circulation')
            //else if (rfaLstLvlStsChangeOld.get(rfa.Id).Level__c == '1. Key Operations' && rfaLstLvlStsChangeOld.get(rfa.Id).Stage__c == 'Post-Circulation')
            {
                if(rfa.TECH_LastStatusChangeDate__c != NULL)
                {
                    if(rfa.TECH_TimeInKeyOpsPostCirculation__c != NULL)
                        rfa.TECH_TimeInKeyOpsPostCirculation__c += (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                    else
                        rfa.TECH_TimeInKeyOpsPostCirculation__c = (System.Now().getTime() - rfa.TECH_LastStatusChangeDate__c.getTime());
                }
            }
            */
                       
            rfa.TECH_LastStatusChangeDate__c = System.Now();
        }        
    }
    
    /**
      *  @ Description : This method contains logic to Validate whether Request Amount and Three Year Cash Spend Total and/ or Capital Expenditure Total
                                 are equal or not. If not equal throw the error message to the user.         
      *  @ param : List<RFA__c>
      *  @ return : void
      */
      /*
    public void validateAmount(List<RFA__c> rfaLstLvlStsChange)
    {        
        for(RFA__c rfa : rfaLstLvlStsChange)
        {
            String rfaRecordTypeName=recordTypeIdsMap.get(rfa.RecordTypeId);
            
            if (rfa.Stage__c != RFAGlobalConstants.RFA_STAGE_DRAFT)
                    {
                        if(  rfaRecordTypeName== System.Label.RFA_CL050  || rfaRecordTypeName == System.Label.RFA_CL051 )
                        {
                            if (rfa.ThreeYearCashSpendTotalFC__c < rfa.RequestAmountFunctionalCurrency__c)
                            {                               
                                rfa.addError(System.Label.RFA_CL094 +' ' + (rfa.RequestAmountFunctionalCurrency__c - rfa.ThreeYearCashSpendTotalFC__c)+' ' + System.Label.RFA_CL096);
                            }
                            else if(rfa.ThreeYearCashSpendTotalFC__c > rfa.RequestAmountFunctionalCurrency__c)
                            {                               
                                rfa.addError(System.Label.RFA_CL094 +' '+ (rfa.ThreeYearCashSpendTotalFC__c - rfa.RequestAmountFunctionalCurrency__c)+' ' + System.Label.RFA_CL097);
                            }
                            
                            if (rfa.CapitalExpenditureTotalFC__c < rfa.RequestAmountFunctionalCurrency__c)
                            {                               
                                rfa.addError(System.Label.RFA_CL095 +' '+ (rfa.RequestAmountFunctionalCurrency__c - rfa.CapitalExpenditureTotalFC__c ) +' '+ System.Label.RFA_CL096);
                            }
                            else if(rfa.CapitalExpenditureTotalFC__c > rfa.RequestAmountFunctionalCurrency__c)
                            {                               
                                rfa.addError(System.Label.RFA_CL095 +' ' +(rfa.CapitalExpenditureTotalFC__c - rfa.RequestAmountFunctionalCurrency__c)+' ' + System.Label.RFA_CL097);
                            }
                            
                        }
                        else
                        {
                            if (rfa.ThreeYearCashSpendTotalFC__c < rfa.RequestAmountFunctionalCurrency__c)
                            {                               
                                rfa.addError(System.Label.RFA_CL094 +' '+ (rfa.RequestAmountFunctionalCurrency__c - rfa.ThreeYearCashSpendTotalFC__c)+' ' + System.Label.RFA_CL096);
                            }
                            else if(rfa.ThreeYearCashSpendTotalFC__c > rfa.RequestAmountFunctionalCurrency__c)
                            {                               
                                rfa.addError( System.Label.RFA_CL094 +' '+ (rfa.ThreeYearCashSpendTotalFC__c - rfa.RequestAmountFunctionalCurrency__c) +' '+ System.Label.RFA_CL097);
                            }   
                        }
                    }
                }
            }    
       */
}