/*******************************************************************************
 *  ふくしま産業復興雇用支援事業
 *  クラス      : JFK_CreateData4Test
 *  概要        : テストに必要なオブジェクトのデータを登録する
 *  ---------------------------------------------------------------------------
 *  【修正履歴】
 *    ・2013/10/25 Create
 ******************************************************************************/
@isTest
public class JFK_CreateData4Test {
	
	/*
	*	初期実行クラス(必要なデータを作成)
	*	
	*	登録順序は取引先（事業所M）→汎用M→募集M※2回→取引先責任者（労働者M）※2回
	*	→事業所TR※2回→労働者TR→審査シート→汎用TR
	*/
	public void init(){
		//事業者Mテストデータ
		List<Account> jigyosyoMList = new List<Account>();
		//事業者TRテストデータ
		List<JFK_JigyosyoTR__c> jigyosyoTRList = new List<JFK_JigyosyoTR__c>();
		//労働者TRテストデータ
		List<JFK_RodoSyaTR__c> rodoSyaTRList = new List<JFK_RodoSyaTR__c>();
		//労働者Mテストデータ
		List<Contact> rodoSyaMList = new List<Contact>();
		//募集Mテストデータ
		List<JFK_Bosyu__c> bosyuList = new List<JFK_Bosyu__c>();
		//汎用Mのリスト
		List<JFK_CommonM__c> commonMList = new List<JFK_CommonM__c>();
		//汎用TRのリスト
		List<JFK_CommonTR__c> commonTRList = new List<JFK_CommonTR__c>();
		//審査シートのリストデータ
		List<JFK_CheckSheetTR__c> chkList = new List<JFK_CheckSheetTR__c>();
		
		//事業所M
		jigyosyoMList.add(createJigyosyoData());
		List<Database.saveresult> srJigyosyoM = Database.insert(jigyosyoMList);

		//汎用M
		commonMList = createCommonMList();
		List<Database.saveresult> srCommonM = Database.insert(commonMList);

		//募集M
		// 年度・回(25年度 １回)
		bosyuList.add(createBosyuM_NendoKaiData()); 
		List<Database.saveresult> srBosyuMNendoKai = Database.insert(bosyuList);
		bosyuList.remove(0);

		// 支給時期(1-1)
		bosyuList.add(createBosyuM_JikiData(srBosyuMNendoKai[0].getId())); 
		List<Database.saveresult> srBosyuMJikiData = Database.insert(bosyuList);

		//労働者M
		rodoSyaMList.add(createContactData1(srJigyosyoM[0].GetID(),srCommonM[7].GetID(),srCommonM[9].GetID(),srCommonM[11].GetID()));
		List<Database.saveresult> srRodoSyaM1 = Database.insert(rodoSyaMList);
		
		rodoSyaMList.remove(0);
		
		// 補充労働者
		rodoSyaMList.add(createContactData2(srJigyosyoM[0].GetID(),srRodoSyaM1[0].GetID(),srCommonM[8].GetID(),srCommonM[10].GetID(),srCommonM[12].GetID()));
		List<Database.saveresult> srRodoSyaM2 = Database.insert(rodoSyaMList);

		//事業所TR
		jigyosyoTRList.add(createJigyosyoTR_NendoKaiData(srJigyosyoM[0].GetId(),srCommonM[13].GetID(),srBosyuMNendoKai[0].GetID()));
		List<Database.saveresult> srJigyosyoTRNendoKai = Database.insert(jigyosyoTRList);

		jigyosyoTRList.remove(0);
		
		jigyosyoTRList.add(createJigyosyoTR_JikiData(srJigyosyoM[0].GetId(),srCommonM[14].GetID(),srJigyosyoTRNendoKai[0].GetID(),srBosyuMJikiData[0].GetID()));
		List<Database.saveresult> srJigyosyoTRJiki = Database.insert(jigyosyoTRList);

		//労働者TR
		rodoSyaTRList.add(createRodosyaTRData(srRodoSyaM2[0].GetID(),srJigyosyoTRJiki[0].GetID(),srCommonM[9].GetID()));
		List<Database.saveresult> srRodosyaTR = Database.insert(rodoSyaTRList);
		
		//審査シート
		chkList.add(createCheckSheetData1('審査シートテスト1',1,1,1,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),null,'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト1',2,1,8,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),null,'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト1',3,1,10,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),null,'OK','OK'));
		
		//審査シート(労働者用)
		chkList.add(createCheckSheetData1('審査シートテスト2',1,1,1,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',1,2,2,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',1,3,3,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',1,4,4,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',1,5,5,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',1,6,6,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',1,7,7,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',1,8,8,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',2,1,9,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',3,1,10,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',3,2,11,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',3,3,12,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',4,1,13,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',4,2,14,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',4,3,15,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',4,4,16,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',4,5,17,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',4,6,18,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',4,7,19,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));
		chkList.add(createCheckSheetData1('審査シートテスト2',4,8,20,srCommonM[18].GetID(),srJigyosyoTRJiki[0].GetID(),srRodosyaTR[0].GetID(),'OK','OK'));

		List<Database.saveresult> srChkList = Database.insert(chkList);
		
		//汎用TR HD
		commonTRList.add(createHDData(srJigyosyoTRJiki[0].GetID(),srChkList[0].GetID(),srRodosyaTR[0].GetID(),null));
		commonTRList.add(createHDData(srJigyosyoTRJiki[0].GetID(),srChkList[1].GetID(),srRodosyaTR[0].GetID(),null));
		
		//汎用TR GS
		commonTRList.add(createGSData(srJigyosyoTRJiki[0].GetID(),srChkList[0].GetID(),null, null));
		
		//汎用TR MD
		commonTRList.add(createMDData(srJigyosyoTRNendoKai[0].GetId()));

		//汎用TR HM
		commonTRList.add(createHMData(srJigyosyoTRJiki[0].GetId()));

		List<Database.saveresult> srCommonTRList = Database.insert(commonTRList);
	}
	
	/*
	 *	チェックリスト用カスタム設定データ作成クラス
	 *	
	 */
	public void init2() {
		//審査シート(CustomSetting)のリストデータ
		List<JFK_CheckSheetM_JCJ__c> chkMList = new List<JFK_CheckSheetM_JCJ__c>();

		//審査シート
		chkMList.add(createCheckSheetM('審査シートテスト1',1,1,1));
		chkMList.add(createCheckSheetM('審査シートテスト2',1,2,2));
		chkMList.add(createCheckSheetM('審査シートテスト3',1,3,3));
		chkMList.add(createCheckSheetM('審査シートテスト4',1,4,4));
		chkMList.add(createCheckSheetM('審査シートテスト5',1,5,5));
		chkMList.add(createCheckSheetM('審査シートテスト6',1,6,6));
		chkMList.add(createCheckSheetM('審査シートテスト7',2,1,7));
		chkMList.add(createCheckSheetM('審査シートテスト8',2,2,8));
		chkMList.add(createCheckSheetM('審査シートテスト9',2,3,9));
		chkMList.add(createCheckSheetM('審査シートテスト10',3,1,10));
		chkMList.add(createCheckSheetM('審査シートテスト11',4,1,21));
		chkMList.add(createCheckSheetM('審査シートテスト12',5,1,29));

		List<Database.saveresult> srChkList = Database.insert(chkMList);
	}
	
	public void init3() {
		//審査シート(CustomSetting)のリストデータ
		List<JFK_CheckSheetM_JCR_1__c> chkMList = new List<JFK_CheckSheetM_JCR_1__c>();

		//審査シート
		chkMList.add(createCheckSheetM2('審査シートテスト1',1,1,1));
		chkMList.add(createCheckSheetM2('審査シートテスト2',1,2,2));
		chkMList.add(createCheckSheetM2('審査シートテスト3',1,3,3));
		chkMList.add(createCheckSheetM2('審査シートテスト4',1,4,4));
		chkMList.add(createCheckSheetM2('審査シートテスト5',1,5,5));
		chkMList.add(createCheckSheetM2('審査シートテスト6',1,6,6));
		chkMList.add(createCheckSheetM2('審査シートテスト7',2,1,7));
		chkMList.add(createCheckSheetM2('審査シートテスト8',2,2,8));
		chkMList.add(createCheckSheetM2('審査シートテスト9',3,1,9));
		chkMList.add(createCheckSheetM2('審査シートテスト10',3,2,10));
		chkMList.add(createCheckSheetM2('審査シートテスト11',3,3,11));
		chkMList.add(createCheckSheetM2('審査シートテスト13',3,4,12));
		chkMList.add(createCheckSheetM2('審査シートテスト14',3,5,13));
		chkMList.add(createCheckSheetM2('審査シートテスト15',3,6,14));
		chkMList.add(createCheckSheetM2('審査シートテスト16',3,7,15));
		chkMList.add(createCheckSheetM2('審査シートテスト17',3,8,16));
		chkMList.add(createCheckSheetM2('審査シートテスト18',3,9,17));
		chkMList.add(createCheckSheetM2('審査シートテスト19',3,10,18));
		
		chkMList.add(createCheckSheetM2('審査シートテスト20',4,1,19));

		List<Database.saveresult> srChkList = Database.insert(chkMList);
	}
	
	public void init4() {
		//審査シート(CustomSetting)のリストデータ
		List<JFK_CheckSheetM_JCR_Supplementary__c> chkMList = new List<JFK_CheckSheetM_JCR_Supplementary__c>();

		//審査シート
		chkMList.add(createCheckSheetM3('審査シートテスト1',1,1,1));
		chkMList.add(createCheckSheetM3('審査シートテスト2',1,2,2));
		chkMList.add(createCheckSheetM3('審査シートテスト3',1,3,3));
		chkMList.add(createCheckSheetM3('審査シートテスト4',1,4,4));
		chkMList.add(createCheckSheetM3('審査シートテスト5',1,5,5));
		chkMList.add(createCheckSheetM3('審査シートテスト6',1,6,6));
		chkMList.add(createCheckSheetM3('審査シートテスト7',1,7,7));
		chkMList.add(createCheckSheetM3('審査シートテスト8',1,8,8));
		chkMList.add(createCheckSheetM3('審査シートテスト9',1,9,9));
		chkMList.add(createCheckSheetM3('審査シートテスト10',1,10,10));
		chkMList.add(createCheckSheetM3('審査シートテスト11',2,1,11));
		chkMList.add(createCheckSheetM3('審査シートテスト13',2,2,12));
		chkMList.add(createCheckSheetM3('審査シートテスト14',3,1,13));
		chkMList.add(createCheckSheetM3('審査シートテスト15',3,2,14));
		chkMList.add(createCheckSheetM3('審査シートテスト16',3,3,15));
		chkMList.add(createCheckSheetM3('審査シートテスト17',3,4,16));
		chkMList.add(createCheckSheetM3('審査シートテスト18',3,5,17));
		chkMList.add(createCheckSheetM3('審査シートテスト19',3,6,18));
		chkMList.add(createCheckSheetM3('審査シートテスト20',3,7,19));
		chkMList.add(createCheckSheetM3('審査シートテスト21',4,1,20));
		chkMList.add(createCheckSheetM3('審査シートテスト22',4,2,21));
		chkMList.add(createCheckSheetM3('審査シートテスト23',4,3,22));
		chkMList.add(createCheckSheetM3('審査シートテスト24',4,4,23));
		chkMList.add(createCheckSheetM3('審査シートテスト25',4,5,24));
		chkMList.add(createCheckSheetM3('審査シートテスト26',4,6,25));
		chkMList.add(createCheckSheetM3('審査シートテスト27',4,7,26));
		chkMList.add(createCheckSheetM3('審査シートテスト28',4,8,27));
		chkMList.add(createCheckSheetM3('審査シートテスト29',4,9,28));
		chkMList.add(createCheckSheetM3('審査シートテスト30',4,10,29));

		List<Database.saveresult> srChkList = Database.insert(chkMList);
	}
	
    /*
     * createJigyosyoTR_NendoKaiData
     * 引数 ：
     * 戻り値：
     * 概要 ： 事業所TRデータを作成する
     */
	public JFK_JigyosyoTR__c createJigyosyoTR_NendoKaiData(Id accountData,
															Id common,
															Id lstBosyuM_NendoKai) {
        JFK_JigyosyoTR__c jigyosyoTR_NendoKai = new JFK_JigyosyoTR__c(
              Name = 'JigyosyoTR_NendoKai_Test'
            , BosyuJoho_YearTime__c = lstBosyuM_NendoKai
            , Account__c = accountData
            , SeiriNO__c = '123'
            , ShinseiBi__c = date.valueOf('2013-01-01')
            , JigyoKBN__c = common
            , Area__c = '1:県北'
        );
        
        return jigyosyoTR_NendoKai;
    }
    
    /*
     * createJigyosyoTR_JikiData
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public JFK_JigyosyoTR__c createJigyosyoTR_JikiData(Id accountData,
															Id common,
															Id jigyosyoTR,
															Id lstBosyuM) {

        JFK_JigyosyoTR__c jigyosyoTR_Jiki = new JFK_JigyosyoTR__c(
              Name = 'JigyosyoTR_Jiki_Test'
            , Nendo_Kai_Jigyosyo__c = jigyosyoTR
            , BosyuJoho_ShikyuJiki__c = lstBosyuM
            , JigyoKBN__c = common
        );
        
        return jigyosyoTR_Jiki;
    }
    
    /*
     * createRodosyaTRData
     * 引数 ：
     * 戻り値：
     * 概要 ： 労働者TRデータを作成する
     */
	public JFK_RodoSyaTR__c createRodosyaTRData(Id lstRodosyaM,
												Id jigyosyoTR,
												Id common) {
        JFK_RodoSyaTR__c rodosyaTR = new JFK_RodoSyaTR__c(
              Name = 'rodosyaTR_Test'
            , Zenki_KoyoKeitai__c = common
            , JigyosyoTR_ShikyuJiki__c = jigyosyoTR
            , Rodosya__c = lstRodosyaM
        );
        
        return rodosyaTR;
    }
	
    /*
     * createCheckSheetData_CustomSetting1
     * 引数 ：
     * 戻り値：
     * 概要 ： 審査シート(カスタム設定)のテストデータを作成する
     */
	public JFK_CheckSheetM_JCJ__c createCheckSheetM(string SheetName
													, integer cat_no
													, integer no
													, integer seq_no) {
							
        JFK_CheckSheetM_JCJ__c chk1 = new JFK_CheckSheetM_JCJ__c(
              Name = SheetName
            , CategoryNo__c = cat_no
            , No__c = no
            , SEQNo__c = seq_no
            , NoForShow__c = 1
            , CheckKomoku__c = 'AAA'
            , CheckNaiyo__c = 'BBB'
        );
        
        return chk1;
    }

    /*
     * createCheckSheetData_CustomSetting2
     * 引数 ：
     * 戻り値：
     * 概要 ： 審査シート(カスタム設定)のテストデータを作成する
     */
	private JFK_CheckSheetM_JCR_1__c createCheckSheetM2(string SheetName
													, integer cat_no
													, integer no
													, integer seq_no) {
							
        JFK_CheckSheetM_JCR_1__c chk1 = new JFK_CheckSheetM_JCR_1__c(
              Name = SheetName
            , CategoryNo__c = cat_no
            , No__c = no
            , SEQNo__c = seq_no
            , NoForShow__c = 1
            , CheckKomoku__c = 'AAA'
            , CheckNaiyo__c = 'BBB'
        );
        
        return chk1;
    }

    /*
     * createCheckSheetData_CustomSetting3
     * 引数 ：
     * 戻り値：
     * 概要 ： 審査シート(カスタム設定)のテストデータを作成する
     */
	private JFK_CheckSheetM_JCR_Supplementary__c createCheckSheetM3(string SheetName
													, integer cat_no
													, integer no
													, integer seq_no) {
							
        JFK_CheckSheetM_JCR_Supplementary__c chk1 = new JFK_CheckSheetM_JCR_Supplementary__c(
              Name = SheetName
            , CategoryNo__c = cat_no
            , No__c = no
            , SEQNo__c = seq_no
            , NoForShow__c = 1
            , CheckKomoku__c = 'AAA'
            , CheckNaiyo__c = 'BBB'
        );
        
        return chk1;
    }

    /*
     * createCheckSheetData1
     * 引数 ：
     * 戻り値：
     * 概要 ： 審査シートのテストデータを作成する
     */
	private JFK_CheckSheetTR__c createCheckSheetData1(string SheetName
													, integer cat_no
													, integer no, integer seq_no
													, Id cmnM
													, Id jigyosyoTR
													, Id rodosyaTR
													, string hantei1
													, string hantei2) {
							
        JFK_CheckSheetTR__c chk1 = new JFK_CheckSheetTR__c(
              Name = SheetName
            , CheckSheetName__c = cmnM
            , CategoryNo__c = cat_no
            , No__c = no
            , SEQNo__c = seq_no
            , JigyosyoTR__c = jigyosyoTR
            , RodosyaTR__c = rodosyaTR
            , NoForShow__c = 1
            , CheckKomoku__c = 'AAA'
			, Hantei_1st__c = hantei1
			, Hantei_2nd__c = hantei2
        );
        
        return chk1;
    }
    
    /*
     * createHDData
     * 引数 ：
     * 戻り値：
     * 概要 ： HDの汎用TRを作成する
     */
	private JFK_CommonTR__c createHDData(Id jigyosyoTR, 
									Id checkSheetTR, 
									Id rodosyaTR,
									Id contact) {
										
        JFK_CommonTR__c hd = new JFK_CommonTR__c(
              Name = 'HD_Test'
            , RecordKBN__c = 'HD'
            , JijyosyoTR_ShikyuJiki__c = jigyosyoTR
            , CheckSheetTR__c = checkSheetTR
            , HD_Status__c = 'A'
            , RodosyaTR__c = rodosyaTR
        );
        
        return hd;
    }

    /*
     * createHMData
     * 引数 ：
     * 戻り値：
     * 概要 ： HMの汎用TRを作成する
     */
	private JFK_CommonTR__c createHMData(Id jigyosyoTR) {
										
        JFK_CommonTR__c hm = new JFK_CommonTR__c(
              Name = 'HM_Test'
            , RecordKBN__c = 'HM'
            , JijyosyoTR_ShikyuJiki__c = jigyosyoTR
        );
        
        return hm;
    }

    /*
     * createMDData
     * 引数 ：
     * 戻り値：
     * 概要 ： MDの汎用TRを作成する
     */
	private JFK_CommonTR__c createMDData(ID jigyosyoTR)
    {
										
        JFK_CommonTR__c md = new JFK_CommonTR__c(
              Name = 'MD_Test'
            , RecordKBN__c = 'MD'
            , JigyosyoTR_YearTime__c = jigyosyoTR
            , MD_Group__c = '連絡先の指定'
        );
        
        return md;
    }

    /*
     * createJTLData
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	private JFK_CommonTR__c createJTLData(Id jigyosyoTR, 
									Id checkSheetTR, 
									Id rodosyaTR,
									Id contact){
										

        JFK_CommonTR__c jtl = new JFK_CommonTR__c(
              Name = 'JTL_Test'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備'
            , JTL_Kaden_Juryo__c = '架電'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-02-02')
            , JijyosyoTR_ShikyuJiki__c = jigyosyoTR
            , MD_TaisyoRodosyaShimei__c = contact
            , RodosyaTR__c = rodosyaTR
            , CheckSheetTR__c = checkSheetTR
        );
        
        return jtl;
    }

    /*
     * createGSData
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	private JFK_CommonTR__c createGSData(Id jigyosyoTR, 
									Id checkSheetTR, 
									Id rodosyaTR,
									Id contact) {

        JFK_CommonTR__c gs = new JFK_CommonTR__c(
			  Name =  'GS_Test'
            , RecordKBN__c = 'GS'
			, GS_JissekiSyoruiShinsa_ChakusyuBi__c = date.valueOf('2013-03-03')
			, GS_JissekiHoseiShido_JisshiBi__c = date.valueOf('2013-03-03')
			, GS_JissekiSyoruiShinsa_KanryoBi__c  = date.valueOf('2013-03-03')
            , GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c = date.valueOf('2013-03-03')
            , GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c = date.valueOf('2013-03-03')
            , GS_JissekiSyoruiShinsa_KanryoBi_1st__c = date.valueOf('2013-03-03')
            , GS_JissekiSyoruiShinsa_KanryoBi_2nd__c = date.valueOf('2013-03-03')
            , GS_CheckSheetURL1__c = null
            , GS_CheckSheetURL2__c = null
            , GS_Miteisyutsusya_1stTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_2ndTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_3rdTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_4thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_5thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_6thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_7thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_8thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_9thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_10thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , JijyosyoTR_ShikyuJiki__c = jigyosyoTR
            , MD_TaisyoRodosyaShimei__c = contact
            , RodosyaTR__c = rodosyaTR
            , CheckSheetTR__c = checkSheetTR
       );
        
        return gs;
    }
	
    /*
     * createJigyosyo
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createJigyosyo(list<Account> lstAccount) {
        Account a = new Account(
             Name = '須藤システム株式会社'
            ,KoyoHokenTekiyoJigyosyoNO__c = '12345678901'
        );
        
        lstAccount.add(a);
    }

    /*
     * createRodosya
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createRodosya(list<Contact> lstContact) {
		string koyoKBNId;
		string KoyoKeitaiId;
		string koyoSyuruiId;

		Account jigyosyo = [SELECT Id from Account order by Id limit 1];
		list<JFK_CommonM__c> lstcommonM = [SELECT id, Name, Code__c, BunruiMeisyo__c from JFK_CommonM__c];
	
		for (JFK_CommonM__c commonM : lstcommonM) {
			if (commonM.BunruiMeisyo__c == '雇用区分') {
				koyoKBNId = commonM.Id;
			} else if (commonM.BunruiMeisyo__c == '雇用形態') {
				KoyoKeitaiId = commonM.Id;
			} else if (commonM.BunruiMeisyo__c == '雇用種類') {
				koyoSyuruiId = commonM.Id;
			}
			
			if (koyoKBNId != null && KoyoKeitaiId != null && koyoSyuruiId != null) {
				break;
			}
		}

        Contact c = new Contact(
              LastName = '須藤'
            , FirstName = '太郎'
            , AccountId = jigyosyo.Id
            , RodosyaNO__c = 1234
            , KoyoSyurui__c = koyoSyuruiId
            , KoyoKBN__c = koyoKBNId
            , KoyoKeitai__c = KoyoKeitaiId
            , YatoiIre_Nengappi__c = date.valueOf('2011-01-01')
            , KoyoKeiyaku_KaishiBi__c = date.valueOf('2011-01-01')
            , RodosyaCD__c = '1234567890'
        );

        lstContact.add(c);
    }

    /*
     * createBosyuM_NendoKai
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createBosyuM_NendoKai(list<JFK_Bosyu__c> lstBosyuM) {
        JFK_Bosyu__c b = new JFK_Bosyu__c(
              Name = '25年度第１回'
            , BosyuNendo__c = 25
            , BosyuKai__c = 1
        );
        
        lstBosyuM.add(b);
    }

    /*
     * createBosyuM_Jiki
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createBosyuM_Jiki(list<JFK_Bosyu__c> lstBosyuM) {
		list<JFK_Bosyu__c> lstBosyuM_NendoKai = [select id from JFK_Bosyu__c where BosyuNendo__c = 25];
		
        JFK_Bosyu__c b = new JFK_Bosyu__c(
              Name = '1-1'
            , Bosyu__c = lstBosyuM_NendoKai[0].Id
            , NenMe__c = 1
            , KaiMe__c = 1
        );
        
        lstBosyuM.add(b);
    }

    /*
     * createJigyosyoTR_NendoKai
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createJigyosyoTR_NendoKai(list<JFK_JigyosyoTR__c> lstJigyosyoTR) {
		list<JFK_Bosyu__c> lstBosyuM_NendoKai = [select id from JFK_Bosyu__c where BosyuNendo__c = 25];
		Account jigyosyo = [SELECT Id from Account order by Id limit 1];
		//JFK_CommonM__c area = [select id from JFK_CommonM__c where name = '県北' limit 1];
		
        JFK_JigyosyoTR__c jigyosyoTR = new JFK_JigyosyoTR__c(
              Name = 'JigyosyoTR_NendoKai_Test'
            , BosyuJoho_YearTime__c = lstBosyuM_NendoKai[0].Id
            , Account__c = jigyosyo.Id
            , SeiriNO__c = '123'
            , ShinseiBi__c = date.valueOf('2013-01-01')
			, Area__c = '1:県北'
        );
        
        lstJigyosyoTR.add(jigyosyoTR);
    }

    /*
     * createJigyosyoTR_Jiki
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createJigyosyoTR_Jiki(list<JFK_JigyosyoTR__c> lstJigyosyoTR) {
		list<JFK_Bosyu__c> lstBosyuM_Jiki = [select id from JFK_Bosyu__c where Name = '1-1'];
		list<JFK_JigyosyoTR__c> lstJigyosyoTR_NendoKai = [select id from JFK_JigyosyoTR__c where Name = 'JigyosyoTR_NendoKai_Test'];		
        
        JFK_JigyosyoTR__c jigyosyoTR = new JFK_JigyosyoTR__c(
              Name = 'JigyosyoTR_Jiki_Test'
            , Nendo_Kai_Jigyosyo__c = lstJigyosyoTR_NendoKai[0].Id
            , BosyuJoho_ShikyuJiki__c = lstBosyuM_Jiki[0].Id
        );
        
        lstJigyosyoTR.add(jigyosyoTR);
    }

    /*
     * createRodosyaTR
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createRodosyaTR(list<JFK_RodosyaTR__c> lstRodosyaTR) {
		list<JFK_JigyosyoTR__c> lstJigyosyoTR = [select id from JFK_JigyosyoTR__c where BosyuJoho_ShikyuJiki__c != null];		
        
        JFK_RodosyaTR__c rodosyaTR = new JFK_RodosyaTR__c(
              Name = 'rodosyaTR_Test'
            , JigyosyoTR_ShikyuJiki__c = lstJigyosyoTR[0].Id
        );
        
        lstRodosyaTR.add(rodosyaTR);
    }

    /*
     * createHM
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createHM(list<JFK_CommonTR__c> lstCommonTR) {
		list<JFK_JigyosyoTR__c> JigyosyoTR_Jiki = [select id from JFK_JigyosyoTR__c where Name = 'JigyosyoTR_Jiki_Test'];		

        JFK_CommonTR__c hm = new JFK_CommonTR__c(
              Name = 'HM_Test'
            , RecordKBN__c = 'HM'
            , HM_HoseiMemo__c = 'Memo'
            , HM_TaioBi__c = date.valueOf('2012-02-02')
            , HM_Aitesaki__c = '鈴木さん'
            , JijyosyoTR_ShikyuJiki__c = JigyosyoTR_Jiki[0].Id
        );
        
        lstCommonTR.add(hm);
    }

    /*
     * createCheckSheet
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createCheckSheet(list<JFK_CheckSheetTR__c> lstcheckSheetTR
								, string SheetName, integer cat_no, integer no, integer seq_no
								, list<JFK_JigyosyoTR__c> JigyosyoTR_Jiki, JFK_CommonM__c cmnM) {
		
        JFK_CheckSheetTR__c chk = new JFK_CheckSheetTR__c(
              Name = SheetName
            , CheckSheetName__c = cmnM.id 
            , CategoryNo__c = cat_no
            , No__c = no
            , SEQNo__c = seq_no
            , JigyosyoTR__c = JigyosyoTR_Jiki[0].Id
        );
        
        lstcheckSheetTR.add(chk);
    }

    /*
     * createCheckSheet2
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createCheckSheet2(list<JFK_CheckSheetTR__c> lstcheckSheetTR
								, string SheetName, integer cat_no, integer no, integer seq_no
								, list<JFK_JigyosyoTR__c> JigyosyoTR_Jiki, JFK_RodoSyaTR__c rodosyaTR, JFK_CommonM__c cmnM) {
        JFK_CheckSheetTR__c chk = new JFK_CheckSheetTR__c(
              Name = SheetName
            , CheckSheetName__c = cmnM.id 
            , CategoryNo__c = cat_no
            , No__c = no
            , SEQNo__c = seq_no
            , JigyosyoTR__c = JigyosyoTR_Jiki[0].Id
            , RodosyaTR__c = rodosyaTR.id
        );
        
        lstcheckSheetTR.add(chk);
    }

    /*
     * createCheckSheet3
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createCheckSheet3(list<JFK_CheckSheetTR__c> lstcheckSheetTR
								, string SheetName, integer cat_no, integer no, integer seq_no
								, list<JFK_JigyosyoTR__c> JigyosyoTR_Jiki, JFK_RodoSyaTR__c rodosyaTR, JFK_CommonM__c cmnM) {
        JFK_CheckSheetTR__c chk = new JFK_CheckSheetTR__c(
              Name = SheetName
            , CheckSheetName__c = cmnM.id 
            , CategoryNo__c = cat_no
            , No__c = no
            , SEQNo__c = seq_no
            , JigyosyoTR__c = JigyosyoTR_Jiki[0].Id
            , RodosyaTR__c = rodosyaTR.id
        );
        
        lstcheckSheetTR.add(chk);
    }

    /*
     * createHD
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createHD(list<JFK_CommonTR__c> lstCommonTR, JFK_CheckSheetTR__c chk, list<JFK_JigyosyoTR__c> JigyosyoTR_Jiki) {
        JFK_CommonTR__c hd = new JFK_CommonTR__c(
              Name = 'HD_Test'
            , RecordKBN__c = 'HD'
            , JijyosyoTR_ShikyuJiki__c = JigyosyoTR_Jiki[0].Id
            , CheckSheetTR__c = chk.Id
            , HD_Status__c = 'A'
        );
        
        lstCommonTR.add(hd);
    }

    /*
     * createHD2
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createHD2(list<JFK_CommonTR__c> lstCommonTR, JFK_CheckSheetTR__c chk, list<JFK_JigyosyoTR__c> JigyosyoTR_Jiki, JFK_RodosyaTR__c rodosyaTR) {
        JFK_CommonTR__c hd = new JFK_CommonTR__c(
              Name = 'HD_Test'
            , RecordKBN__c = 'HD'
            , JijyosyoTR_ShikyuJiki__c = JigyosyoTR_Jiki[0].Id
            , CheckSheetTR__c = chk.Id
            , RodosyaTR__c = rodosyaTR.id
            , HD_Status__c = 'A'
        );
        
        lstCommonTR.add(hd);
    }

    /*
     * createJTL
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createJTL(list<JFK_CommonTR__c> lstCommonTR) {
		list<JFK_JigyosyoTR__c> JigyosyoTR_Jiki = [select id from JFK_JigyosyoTR__c where Name = 'JigyosyoTR_Jiki_Test'];

        JFK_CommonTR__c jtl = new JFK_CommonTR__c(
              Name = 'JTL_Test'
            , RecordKBN__c = 'JTL'
            , JTL_KadenNaiyo__c = '書類不備'
            , JTL_Kaden_Juryo__c = '架電'
            , JTL_Tantosya__c = UserInfo.getUserId()
            , JTL_Hizuke__c = date.valueOf('2012-02-02')
            , JijyosyoTR_ShikyuJiki__c = JigyosyoTR_Jiki[0].Id
        );
        
        lstCommonTR.add(jtl);
    }

    /*
     * createGS
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createGS(list<JFK_CommonTR__c> lstCommonTR) {
		list<JFK_JigyosyoTR__c> JigyosyoTR_Jiki = [select id from JFK_JigyosyoTR__c where Name = 'JigyosyoTR_Jiki_Test'];

        JFK_CommonTR__c gs = new JFK_CommonTR__c(
			  Name =  'GS_Test'
            , RecordKBN__c = 'GS'
			, GS_JissekiSyoruiShinsa_ChakusyuBi__c = date.valueOf('2013-03-03')
			, GS_JissekiHoseiShido_JisshiBi__c = date.valueOf('2013-03-03')
			, GS_JissekiSyoruiShinsa_KanryoBi__c  = date.valueOf('2013-03-03')
            , GS_JissekiSyoruiShinsa_ChakusyuBi_1st__c = date.valueOf('2013-03-03')
            , GS_JissekiSyoruiShinsa_ChakusyuBi_2nd__c = date.valueOf('2013-03-03')
            , GS_JissekiSyoruiShinsa_KanryoBi_1st__c = date.valueOf('2013-03-03')
            , GS_JissekiSyoruiShinsa_KanryoBi_2nd__c = date.valueOf('2013-03-03')
            , GS_CheckSheetURL1__c = null
            , GS_CheckSheetURL2__c = null
            , GS_Miteisyutsusya_1stTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_2ndTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_3rdTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_4thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_5thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_6thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_7thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_8thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_9thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , GS_Miteisyutsusya_10thTokusokuJissiBi__c = date.valueOf('2013-03-03')
            , JijyosyoTR_ShikyuJiki__c = JigyosyoTR_Jiki[0].Id
       );
        
        lstCommonTR.add(gs);
    }

    /*
     * createCommonM
     * 引数 ：
     * 戻り値：
     * 概要 ： 
     */
	public void createCommonM(list<JFK_CommonM__c> lstCmn) {
        JFK_CommonM__c cmn1 = new JFK_CommonM__c();
        cmn1.Name = '県北';
        cmn1.Code__c = '1';
        cmn1.BunruiMeisyo__c = 'エリア区分';
		lstCmn.add(cmn1);

        JFK_CommonM__c cmn2 = new JFK_CommonM__c();
        cmn2.Name = '県中';
        cmn2.Code__c = '2';
        cmn2.BunruiMeisyo__c = 'エリア区分';
		lstCmn.add(cmn2);

        JFK_CommonM__c cmn3 = new JFK_CommonM__c();
        cmn3.Name = '県南';
        cmn3.Code__c = '3';
        cmn3.BunruiMeisyo__c = 'エリア区分';
		lstCmn.add(cmn3);

        JFK_CommonM__c cmn4 = new JFK_CommonM__c();
        cmn4.Name = '会津';
        cmn4.Code__c = '4';
        cmn4.BunruiMeisyo__c = 'エリア区分';
		lstCmn.add(cmn4);

        JFK_CommonM__c cmn5 = new JFK_CommonM__c();
        cmn5.Name = '南会津';
        cmn5.Code__c = '5';
        cmn5.BunruiMeisyo__c = 'エリア区分';
		lstCmn.add(cmn5);

        JFK_CommonM__c cmn6 = new JFK_CommonM__c();
        cmn6.Name = '相双';
        cmn6.Code__c = '6';
        cmn6.BunruiMeisyo__c = 'エリア区分';
		lstCmn.add(cmn6);

        JFK_CommonM__c cmn7 = new JFK_CommonM__c();
        cmn7.Name = 'いわき';
        cmn7.Code__c = '7';
        cmn7.BunruiMeisyo__c = 'エリア区分';
		lstCmn.add(cmn7);

        JFK_CommonM__c cmn8 = new JFK_CommonM__c();
        cmn8.Name = '新規雇用';
        cmn8.Code__c = '001';
        cmn8.BunruiMeisyo__c = '雇用区分';
		lstCmn.add(cmn8);

        JFK_CommonM__c cmn9 = new JFK_CommonM__c();
        cmn9.Name = '再雇用';
        cmn9.Code__c = '002';
        cmn9.BunruiMeisyo__c = '雇用区分';
		lstCmn.add(cmn9);

        JFK_CommonM__c cmn10 = new JFK_CommonM__c();
        cmn10.Name = 'フルタイム';
        cmn10.Code__c = '001';
        cmn10.BunruiMeisyo__c = '雇用形態';
		lstCmn.add(cmn10);

        JFK_CommonM__c cmn11 = new JFK_CommonM__c();
        cmn11.Name = '短時間労働者';
        cmn11.Code__c = '002';
        cmn11.BunruiMeisyo__c = '雇用形態';
		lstCmn.add(cmn11);

        JFK_CommonM__c cmn12 = new JFK_CommonM__c();
        cmn12.Name = '正規雇用';
        cmn12.Code__c = '001';
        cmn12.BunruiMeisyo__c = '雇用種類';
		lstCmn.add(cmn12);

        JFK_CommonM__c cmn13 = new JFK_CommonM__c();
        cmn13.Name = '有期雇用';
        cmn13.Code__c = '001';
        cmn13.BunruiMeisyo__c = '雇用種類';
		lstCmn.add(cmn13);

        JFK_CommonM__c cmn14 = new JFK_CommonM__c();
        cmn14.Name = '①';
        cmn14.Code__c = '001';
        cmn14.BunruiMeisyo__c = '事業所区分';
		lstCmn.add(cmn14);

        JFK_CommonM__c cmn15 = new JFK_CommonM__c();
        cmn15.Name = '②';
        cmn15.Code__c = '002';
        cmn15.BunruiMeisyo__c = '事業所区分';
		lstCmn.add(cmn15);

        JFK_CommonM__c cmn16 = new JFK_CommonM__c();
        cmn16.Name = '③';
        cmn16.Code__c = '003';
        cmn16.BunruiMeisyo__c = '事業所区分';
		lstCmn.add(cmn16);

        JFK_CommonM__c cmn17 = new JFK_CommonM__c();
        cmn17.Name = '④';
        cmn17.Code__c = '004';
        cmn17.BunruiMeisyo__c = '事業所区分';
		lstCmn.add(cmn17);

        JFK_CommonM__c cmn18 = new JFK_CommonM__c();
        cmn18.Name = '①以外';
        cmn18.Code__c = '005';
        cmn18.BunruiMeisyo__c = '事業所区分';
		lstCmn.add(cmn18);

        JFK_CommonM__c cmn19 = new JFK_CommonM__c();
        cmn19.Name = 'JCJ';
        cmn19.Code__c = '001';
        cmn19.BunruiMeisyo__c = '審査シート';
		lstCmn.add(cmn19);

        JFK_CommonM__c cmn20 = new JFK_CommonM__c();
        cmn20.Name = 'JCR';
        cmn20.Code__c = '002';
        cmn20.BunruiMeisyo__c = '審査シート';
		lstCmn.add(cmn20);

        JFK_CommonM__c cmn21 = new JFK_CommonM__c();
        cmn21.Name = 'JCR（補充労働者用）';
        cmn21.Code__c = '001';
        cmn21.BunruiMeisyo__c = '審査シート';
		lstCmn.add(cmn21);
    }

    /*
     * createBosyuM_NendoKaiData
     * 引数 ：
     * 戻り値：
     * 概要 ：  募集Mテストデータを作成
     */
	public JFK_Bosyu__c createBosyuM_NendoKaiData() {
        JFK_Bosyu__c b1 = new JFK_Bosyu__c(
              Name = '25年度第1回'
            , BosyuNendo__c = 25
            , BosyuKai__c = 1
        );
        
        return b1;
    }

    /*
     * createBosyuM_JikiData
     * 引数 ：
     * 戻り値：
     * 概要 ： 募集Mテストデータを作成
     */
	public JFK_Bosyu__c createBosyuM_JikiData(Id lstBosyuM) {
		
        JFK_Bosyu__c b2 = new JFK_Bosyu__c(
              Name = '1-1'
            , Bosyu__c = lstBosyuM
            , NenMe__c = 1
            , KaiMe__c = 1
        );
        
        return b2;
    }

	 /*
     * createJigyosyoData
     * 引数 ：
     * 戻り値：
     * 概要 ： 取引先テストコード用のテストデータを作成
     */
	public Account createJigyosyoData() {
		
        Account a = new Account(
             Name = '須藤システム株式会社'
			//雇用保険適用事業所番号
            ,KoyoHokenTekiyoJigyosyoNO__c = '12345678901'
			//委任状あり
			,HoseiShido_Aitesaki_IninjoAri__c = true
			//債権者登録番号
			,SaikensyaTorokuNO__c = 'abcd1234567890'
			//事務所名・担当者名
			,HoseiShido_Aitesaki_Jimusyo_TantosyaMei__c = 'テスト太郎'
			//住所（助成金対象事業所）
			,Address_Taisyo__c = '埼玉県'
			//住所（申請事業所）
			,Address_Shinsei__c = '埼玉県'
			//住所（送付先）
			,Address_Sofusaki__c = '埼玉県'
			//対象分野等名称
			,TaisyoBunyaName__c = 'テスト対象分野'
			//代表者（役職氏名）
			,DaihyousyaYakusyokuShimei__c = 'テスト太郎'
			//担当者氏名
			,HoseiShido_Aitesaki_TantosyaMei__c = 'テスト太郎'
			//部署名
			,HoseiShido_Aitesaki_Busyo__c = 'テスト太郎'
			//補助・融資名称
			,HojoYushiName__c = 'テスト融資'
			//郵便番号（申請事業所）
			,YubinBango_Shinsei__c = '343'
			//郵便番号（送付先）
			,YubinBango_Sofusaki__c = '343'
			//連絡先１
			,HoseiShido_Aitesaki_Renrakusaki__c = '09012345678'
			//連絡先２
			,HoseiShido_Aitesaki_Renrakusaki2__c = '090219843576'
        );
        
        return a;
    }
    
    /*
     * createContactData1
     * 引数 ：
     * 戻り値：
     * 概要 ： 労働者M（取引先責任者）のテストデータを作成
     */
	public Contact createContactData1(Id jigyosyo,Id commonKoyoKubun,Id commonKoyoKeitai,Id commonKoyoSyurui) {
            Contact c1 = new Contact(
              LastName = '須藤'
            , FirstName = '太郎'
            , AccountId = jigyosyo
            , RodosyaNO__c = 1234
            , KoyoSyurui__c = commonKoyoSyurui
            , KoyoKBN__c = commonKoyoKubun
            , KoyoKeitai__c = commonKoyoKeitai
            , YatoiIre_Nengappi__c = date.valueOf('2011-01-01')
            , KoyoKeiyaku_KaishiBi__c = date.valueOf('2011-01-01')
            , KoyoKeiyaku_SyuryoBi__c = date.valueOf('2013-12-31')
            , RodosyaCD__c = '1234567890'          
            , RisyokuBi__c = date.valueOf('2013-12-31')
        );

        return c1;
	}
	
    /*
     * createContactData2
     * 引数 ：
     * 戻り値：
     * 概要 ： 労働者M（取引先責任者）のテストデータを作成
     */
	public Contact createContactData2(Id jigyosyo,Id contact,Id commonKoyoKubun,Id commonKoyoKeitai,Id commonKoyoSyurui) {
            Contact c2 = new Contact(
              LastName = '横田'
            , FirstName = '良'
            , AccountId = jigyosyo
            , RodosyaNO__c = 1234
            , KoyoSyurui__c = commonKoyoSyurui
            , KoyoKBN__c = commonKoyoKubun
            , KoyoKeitai__c = commonKoyoKeitai
            , YatoiIre_Nengappi__c = date.valueOf('2011-01-01')
            , KoyoKeiyaku_KaishiBi__c = date.valueOf('2011-01-01')
            , KoyoKeiyaku_SyuryoBi__c = date.valueOf('2013-12-31')
            , RodosyaCD__c = '1234567891'
            , HojuMoto_Rodosya__c = contact            
        );

        return c2;
	}
    
    /*
     * createCommonMList
     * 引数 ：
     * 戻り値：
     * 概要 ： 汎用Mのテストコード用のテストデータリストを作成
     */
	public List<JFK_CommonM__c> createCommonMList() {
		
		List<JFK_CommonM__c> cmnList = new List<JFK_CommonM__c>();
		
        JFK_CommonM__c cmn1 = new JFK_CommonM__c();
        cmn1.Name = '県北';
        cmn1.Code__c = '1';
        cmn1.BunruiMeisyo__c = 'エリア区分';
		cmnList.add(cmn1);

        JFK_CommonM__c cmn2 = new JFK_CommonM__c();
        cmn2.Name = '県中';
        cmn2.Code__c = '2';
        cmn2.BunruiMeisyo__c = 'エリア区分';
		cmnList.add(cmn2);

        JFK_CommonM__c cmn3 = new JFK_CommonM__c();
        cmn3.Name = '県南';
        cmn3.Code__c = '3';
        cmn3.BunruiMeisyo__c = 'エリア区分';
		cmnList.add(cmn3);

        JFK_CommonM__c cmn4 = new JFK_CommonM__c();
        cmn4.Name = '会津';
        cmn4.Code__c = '4';
        cmn4.BunruiMeisyo__c = 'エリア区分';
		cmnList.add(cmn4);

        JFK_CommonM__c cmn5 = new JFK_CommonM__c();
        cmn5.Name = '南会津';
        cmn5.Code__c = '5';
        cmn5.BunruiMeisyo__c = 'エリア区分';
		cmnList.add(cmn5);

        JFK_CommonM__c cmn6 = new JFK_CommonM__c();
        cmn6.Name = '相双';
        cmn6.Code__c = '6';
        cmn6.BunruiMeisyo__c = 'エリア区分';
		cmnList.add(cmn6);

        JFK_CommonM__c cmn7 = new JFK_CommonM__c();
        cmn7.Name = 'いわき';
        cmn7.Code__c = '7';
        cmn7.BunruiMeisyo__c = 'エリア区分';
		cmnList.add(cmn7);

        JFK_CommonM__c cmn8 = new JFK_CommonM__c();
        cmn8.Name = '新規雇用';
        cmn8.Code__c = '001';
        cmn8.BunruiMeisyo__c = '雇用区分';
		cmnList.add(cmn8);

        JFK_CommonM__c cmn9 = new JFK_CommonM__c();
        cmn9.Name = '再雇用';
        cmn9.Code__c = '002';
        cmn9.BunruiMeisyo__c = '雇用区分';
		cmnList.add(cmn9);

        JFK_CommonM__c cmn10 = new JFK_CommonM__c();
        cmn10.Name = 'フルタイム';
        cmn10.Code__c = '001';
        cmn10.BunruiMeisyo__c = '雇用形態';
		cmnList.add(cmn10);

        JFK_CommonM__c cmn11 = new JFK_CommonM__c();
        cmn11.Name = '短時間労働者';
        cmn11.Code__c = '002';
        cmn11.BunruiMeisyo__c = '雇用形態';
		cmnList.add(cmn11);

        JFK_CommonM__c cmn12 = new JFK_CommonM__c();
        cmn12.Name = '正規雇用';
        cmn12.Code__c = '001';
        cmn12.BunruiMeisyo__c = '雇用種類';
		cmnList.add(cmn12);

        JFK_CommonM__c cmn13 = new JFK_CommonM__c();
        cmn13.Name = '有期雇用';
        cmn13.Code__c = '001';
        cmn13.BunruiMeisyo__c = '雇用種類';
		cmnList.add(cmn13);

        JFK_CommonM__c cmn14 = new JFK_CommonM__c();
        cmn14.Name = '①';
        cmn14.Code__c = '001';
        cmn14.BunruiMeisyo__c = '事業所区分';
		cmnList.add(cmn14);

        JFK_CommonM__c cmn15 = new JFK_CommonM__c();
        cmn15.Name = '②';
        cmn15.Code__c = '002';
        cmn15.BunruiMeisyo__c = '事業所区分';
		cmnList.add(cmn15);

        JFK_CommonM__c cmn16 = new JFK_CommonM__c();
        cmn16.Name = '③';
        cmn16.Code__c = '003';
        cmn16.BunruiMeisyo__c = '事業所区分';
		cmnList.add(cmn16);

        JFK_CommonM__c cmn17 = new JFK_CommonM__c();
        cmn17.Name = '④';
        cmn17.Code__c = '004';
        cmn17.BunruiMeisyo__c = '事業所区分';
		cmnList.add(cmn17);

        JFK_CommonM__c cmn18 = new JFK_CommonM__c();
        cmn18.Name = '①以外';
        cmn18.Code__c = '005';
        cmn18.BunruiMeisyo__c = '事業所区分';
		cmnList.add(cmn18);

        JFK_CommonM__c cmn19 = new JFK_CommonM__c();
        cmn19.Name = 'JCJ';
        cmn19.Code__c = '001';
        cmn19.BunruiMeisyo__c = '審査シート';
		cmnList.add(cmn19);

        JFK_CommonM__c cmn20 = new JFK_CommonM__c();
        cmn20.Name = 'JCR';
        cmn20.Code__c = '002';
        cmn20.BunruiMeisyo__c = '審査シート';
		cmnList.add(cmn20);

        JFK_CommonM__c cmn21 = new JFK_CommonM__c();
        cmn21.Name = 'JCR（補充労働者用）';
        cmn21.Code__c = '001';
        cmn21.BunruiMeisyo__c = '審査シート';
		cmnList.add(cmn21);
		
		return cmnList;
		
    }
	
}