/*  
 *  Author           : Pasona-Tquila
 *  Version History  : 1.0
 *  Creation         : 2013/12/10                                
 */
 //http://www.salesforce.com/us/developer/docs/pages/Content/pages_quick_start_renderas_pdf.htm
 /*
RFA_Email BoardApproval 	00X10000000eC4o
RFA_Email CloseRFA 	00X10000000eC11
RFA_Email CompleteRFA 	00X10000000eAx3
RFA_Email ResumefromReturntoRequester 	00X10000000eAwy
RFA_Email ReturntoRequester 	00X10000000eBWr
 */
//VF page: RFA VFP04 CM DetailsAsPDF / Ctrl: RFA_VFC04_CompletionMemoController 
 public class RFAUtility_Email {
 	
 	//Status: Approved
 	public static String getHtmlBody_CompletionMemo(
 		String strEmailSubject, String ppocNameList, String ccNameList, String strComment, RFA__c rfa) {
 		system.debug('----- strEmailSubject: ' + strEmailSubject + ' --  ccNameList: ' + ccNameList + ' rfa: ' + rfa);
 						
 		Date inst = System.Today();
		system.debug(' -- Month: ' + inst.Month() + '  Day: ' +  inst.Day() + ' --- Year: ' + inst.Year());
		
 		String strHtmlBody =
 		  '<html>' +
 		      '<head>' +
        		//'<style type="text/css"> body {font-family: "Arial Unicode MS";}</style>' +
              '</head>' +
            '<body >' + //style = "font-family: Arial Unicode MS;"
              //'<div style = "font-size:12px;max-width:600px;"' + 
              '<div style = "font-size:12px;"' + //font-family:Arial Unicode MS;
                '<p>' +                 
                    '<img src="' + Label.RFA_CL129 + '" align="middle" alt="logo">' + 
                '</p>' + 
                '<BR/>' + 
                '<p style="font-weight:bold">日付 (DATE) : ' + inst.Month() + '/' + inst.Day() + '/' + inst.Year() + '</p>' +
				//<br/>
                '<p style="font-weight:bold">TO : ' + ppocNameList + '</p>' +            
                '<p style="font-weight:bold">CC : ' + ccNameList + '</p><br/>' +
                
                '<p style="font-weight:bold"><u>件名 (SUBJECT) : </u><br/>' + 
                strEmailSubject + '<br/>' +
                '</p>' +
               
                '<p style="font-weight:bold"><u>承認ステータス (APPROVAL STATUS OF REQUEST) : </u><br/>' +
                rfa.Stage__c + '<br/>' + 
                '</p>' +
                
                '<p style="font-weight:bold"><u>コメント/条件 (COMMENTS/CONDITIONS) : </u><br/>' +
                strComment + '<br/>' +
                '</p>' + 
                
                '<p style="font-weight:bold"><u>案件名 (REQUEST TITLE) : </u><br/>' + 
                rfa.RequestTitle__c + '<br/>' + 
                '</p>' + 
                  
                '<p style="font-weight:bold"><u>申請金額(円) (REQUEST AMOUNT) : </u><br/>' + 
                //'<apex:outputText value="{0,number, #,###}"><apex:param value="{!rfaObj.RequestAmountFunctionalCurrency__c}"/></apex:outputText><br/>' + 
                '¥ ' + rfa.RequestAmountFunctionalCurrency__c + '<br/>' + 
                '</p>' + 

                '<p style="font-weight:bold"><u><承認申請文書リンク (REQUEST DOCUMENT LINK)</u><br/>' + 
                '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + rfa.Id + '">' + rfa.Name + '</a><br/>' + 
                '</p>' + //Label.RFA_CL026
                                        
              '</div>' +     
            '</body>' + 
          '</html>';
        return strHtmlBody;
 	}

 	//Status: Approved + Requires Board Approval
 	public static String getHtmlBody_BoardApproval(
 		User requester, String ppocNameList, String ccNameList, RFA__c rfa) {
 								
 		String strHtmlBody =
 		  '<html>' +
 		      '<head>' +
        		//'<style type="text/css"> body {font-family: "Arial Unicode MS";}</style>' +
              '</head>' +
            '<body >' + //style = "font-family: Arial Unicode MS;"
              //'<div style = "font-size:12px;max-width:600px;"' + 
              '<div style = "font-size:12px;"' + //font-family:Arial Unicode MS;
                '<p style="font-weight:bold">以下のRFA承認申請は、取締役会の承認が必要です。</p>' +
				'<p style="font-weight:bold">手続きについては、コーポレートアドミニストレーション部に連絡をし、対応をしてください。</p>' +
				'<p style="font-weight:bold">This RFA requires BOD approval. Please contact Corporate Administration for further proceeding.</p>' +

                '<p style="font-weight:bold">TO : ' + ppocNameList + '</p>' +            
                '<p style="font-weight:bold">CC : ' + ccNameList + '</p><br/>' +

                '<p style="font-weight:bold"><u>案件名 (REQUEST TITLE) : </u><br/>' + 
                rfa.RequestTitle__c + '<br/>' + 
                '</p>' + 
                                              
                '<p style="font-weight:bold"><u>承認ステータス (APPROVAL STATUS OF REQUEST) : </u><br/>' +
                rfa.Stage__c + '<br/>' + 
                '</p>' +

                '<p style="font-weight:bold"><u><承認申請文書リンク (REQUEST DOCUMENT LINK) : </u><br/>' + 
                '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + rfa.Id + '">' + rfa.Name + '</a><br/>' + 
                '</p>' +
                                        
              '</div>' +     
            '</body>' + 
          '</html>';
        return strHtmlBody;
 	}

	//called by sendEmail_CloseRFA()
	//close from Draft or Return to Requester
 	public static String getHtmlBody_CloseRFA(
 		User ppoc, String Subject, RFA__c rfa) {
 								
 		String strHtmlBody =
 		  '<html>' +
 		      '<head>' +
        		//'<style type="text/css"> body {font-family: "Arial Unicode MS";}</style>' +
              '</head>' +
            '<body >' + //style = "font-family: Arial Unicode MS;"
              //'<div style = "font-size:12px;max-width:600px;"' + 
              '<div style = "font-size:12px;"' + //font-family:Arial Unicode MS;
              '<br/>' + 
                '<p style="font-weight:bold">以下のRFA承認申請が取り下げられましたのでお知らせ致します。</p>' +
				'<p style="font-weight:bold">This RFA has been closed.</p>' +			

                '<p style="font-weight:bold"><u>案件名 (REQUEST TITLE): </u><br/>' + 
                rfa.RequestTitle__c + '<br/>' + 
                '</p>' + 
                                              
                '<p style="font-weight:bold"><u>取り下げ理由 (Close Reason): </u><br/>' +
                rfa.Close_Reason__c + '<br/>' + 
                '</p>' +

                '<p style="font-weight:bold">内容を確認する場合にはこのリンクをクリックし、承認申請リクエスト文書を開いてください : </p>' + 
                '<p style="font-weight:bold">Click this link to open the RFA Request Document : </p>' + 
                '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + rfa.Id + '">' + rfa.Name + '</a><br/>' + 

                '<p>ご質問がございましたら、 <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a> へご連絡ください。<BR/>' + 
                '<p>If you have any inquiries kindly contact <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a>.<BR/>' + 
                                        
              '</div>' +     
            '</body>' + 
          '</html>';
        return strHtmlBody;
 	}

	//called by sendEmail_ReturnToRequester()
	//To: Requester, PPOC, Info Copy Only, Approver & Agent (Approved or Waiting for Approval)
 	public static String getHtmlBody_ReturnToRequester(
 		User ppoc, String Subject, RFA__c rfa, String ppocNameList, String ccNameList) {
 								
 		String strHtmlBody =
 		  '<html>' +
 		      '<head>' +
        		//'<style type="text/css"> body {font-family: "Arial Unicode MS";}</style>' +
              '</head>' +
            '<body >' + //style = "font-family: Arial Unicode MS;"
              //'<div style = "font-size:12px;max-width:600px;"' + 
              '<div style = "font-size:12px;"' + //font-family:Arial Unicode MS;
              '<br/>' + 
              
                '<p style="font-weight:bold">TO : ' + ppocNameList + '</p>' +            
                '<p style="font-weight:bold">CC : ' + ccNameList + '</p><br/>' +              
              
                '<p style="font-weight:bold">この承認申請は差し戻されました。リンク先の文書内の差し戻し理由を確認してください。</p>' +
				'<p style="font-weight:bold">This RFA has been returned to you for the following reason(s). </p>' +		
				rfa.ReturnReason__c + '<br/>' + 	

                '<p style="font-weight:bold"><u>案件名 (REQUEST TITLE): </u><br/>' + 
                rfa.RequestTitle__c + '<br/>' + 
                '</p>' + 
                
                '<p style="font-weight:bold"><u>コストセンター (Cost Center): </u><br/>' +
                rfa.Cost_Center_Number_Name__c + '<br/>' + 
                '</p>' +                
                                              
                '<p style="font-weight:bold"><u>申請金額(円) (REQUEST AMOUNT) : </u><br/>' +             
                '¥ ' + rfa.RequestAmountFunctionalCurrency__c + '<br/>' + 
                '</p>' + 

                '<p style="font-weight:bold">下記リンクをクリックし、承認申請リクエスト文書をご確認ください : </p>' + 
                '<p style="font-weight:bold">Click this link to open the RFA Request Document : </p>' + 
                '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + rfa.Id + '">' + rfa.Name + '</a><br/>' + 

                '<p>ご質問がございましたら、 <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a> へご連絡ください。<BR/>' + 
                '<p>If you have any inquiries kindly contact <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a>.<BR/>' + 
                                        
              '</div>' +     
            '</body>' + 
          '</html>';
        return strHtmlBody;
 	}

	//called from sendEmail_ResumeFromRTR()
	//Resume from Return to Requester -> Circulation
	//To: Requester, PPOC
 	public static String getHtmlBody_Resume_From_RTR_ReqPPOC(
 		User ppoc, String Subject, RFA__c rfa) {
 								
 		String strHtmlBody =
 		  '<html>' +
 		      '<head>' +
        		//'<style type="text/css"> body {font-family: "Arial Unicode MS";}</style>' +
              '</head>' +
            '<body >' + //style = "font-family: Arial Unicode MS;"
              //'<div style = "font-size:12px;max-width:600px;"' + 
              '<div style = "font-size:12px;"' + //font-family:Arial Unicode MS;
              '<br/>' + 
                '<p style="font-weight:bold">この承認申請は再申請されました。 下記リンクより申請内容を検討の上、ご対応ください。</p>' +
                '<p style="font-weight:bold">This RFA has been updated and moved from Return to Requester to Circulation.</p>' +
				'<p style="font-weight:bold">Use the link below to review and take action on this RFA. </p>' +		

                '<p style="font-weight:bold"><u>案件名 (REQUEST TITLE): </u><br/>' + 
                rfa.RequestTitle__c + '<br/>' + 
                '</p>' + 
                
                '<p style="font-weight:bold"><u>コストセンター (Cost Center): </u><br/>' +
                rfa.Cost_Center_Number_Name__c + '<br/>' + 
                '</p>' +                
                                              
                '<p style="font-weight:bold"><u>申請金額(円) (REQUEST AMOUNT) : </u><br/>' +             
                '¥ ' + rfa.RequestAmountFunctionalCurrency__c + '<br/>' + 
                '</p>' + 

                '<p style="font-weight:bold">下記リンクをクリックし、承認申請リクエスト文書をご確認ください : </p>' + 
                '<p style="font-weight:bold">Click this link to open the RFA Request Document : </p>' + 
                '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + rfa.Id + '">' + rfa.Name + '</a><br/>' + 

                '<p>ご質問がございましたら、 <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a> へご連絡ください。<BR/>' + 
                '<p>If you have any inquiries kindly contact <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a>.<BR/>' + 
                                        
              '</div>' +     
            '</body>' + 
          '</html>';
        return strHtmlBody;
 	}	
	//called from sendEmail_ResumeFromRTR()
	//Resume from Return to Requester -> Circulation
	//To: Info Only Copy 
 	public static String getHtmlBody_Resume_From_RTR_InfoOnlyCopy(
 		User ppoc, String Subject, RFA__c rfa) {
 								
 		String strHtmlBody =
 		  '<html>' +
 		      '<head>' +
        		//'<style type="text/css"> body {font-family: "Arial Unicode MS";}</style>' +
              '</head>' +
            '<body >' + //style = "font-family: Arial Unicode MS;"
              //'<div style = "font-size:12px;max-width:600px;"' + 
              '<div style = "font-size:12px;"' + //font-family:Arial Unicode MS;
              '<br/>' + 
                '<p style="font-weight:bold">この承認申請は再申請されました。 下記リンクより申請内容を検討の上、ご対応ください。</p>' +
                '<p style="font-weight:bold">This RFA has been updated and moved from Return to Requester to Circulation.</p>' +
				'<p style="font-weight:bold">Use the link below to review and take action on this RFA. </p>' +		

                '<p style="font-weight:bold"><u>案件名 (REQUEST TITLE): </u><br/>' + 
                rfa.RequestTitle__c + '<br/>' + 
                '</p>' + 
                
                '<p style="font-weight:bold"><u>コストセンター (Cost Center): </u><br/>' +
                rfa.Cost_Center_Number_Name__c + '<br/>' + 
                '</p>' +                
                                              
                '<p style="font-weight:bold"><u>申請金額(円) (REQUEST AMOUNT) : </u><br/>' +             
                '¥ ' + rfa.RequestAmountFunctionalCurrency__c + '<br/>' + 
                '</p>' + 

                '<p style="font-weight:bold">下記リンクをクリックし、承認申請リクエスト文書をご確認ください : </p>' + 
                '<p style="font-weight:bold">Click this link to open the RFA Request Document : </p>' + 
                '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + rfa.Id + '">' + rfa.Name + '</a><br/>' + 

                '<p>ご質問がございましたら、 <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a> へご連絡ください。<BR/>' + 
                '<p>If you have any inquiries kindly contact <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a>.<BR/>' + 
                                        
              '</div>' +     
            '</body>' + 
          '</html>';
        return strHtmlBody;
 	}	 	
	//called from sendEmail_ResumeFromRTR()
	//Resume from Return to Requester -> Circulation
	// RFAVFT06 RFA Resumes From Return To Requestor  /00X10000000eAwy?setupid=CommunicationTemplatesEmail
	//To: Approver & Agent
 	public static String getHtmlBody_Resume_From_RTR_Approver(
 		User ppoc, String Subject, RFA__c rfa) {
 								
 		String strHtmlBody =
 		  '<html>' +
 		      '<head>' +
        		//'<style type="text/css"> body {font-family: "Arial Unicode MS";}</style>' +
              '</head>' +
            '<body >' + //style = "font-family: Arial Unicode MS;"
              //'<div style = "font-size:12px;max-width:600px;"' + 
              '<div style = "font-size:12px;"' + //font-family:Arial Unicode MS;
              '<br/>' + 
                '<p style="font-weight:bold">この承認申請は再申請されました。 下記リンクより申請内容を検討の上、ご対応ください。</p>' +
                '<p style="font-weight:bold">This RFA has been updated and moved from Return to Requester to Circulation.</p>' +
				'<p style="font-weight:bold">Use the link below to review and take action on this RFA. </p>' +		

                '<p style="font-weight:bold"><u>案件名 (REQUEST TITLE): </u><br/>' + 
                rfa.RequestTitle__c + '<br/>' + 
                '</p>' + 
                
                '<p style="font-weight:bold"><u>コストセンター (Cost Center): </u><br/>' +
                rfa.Cost_Center_Number_Name__c + '<br/>' + 
                '</p>' +                
                                              
                '<p style="font-weight:bold"><u>申請金額(円) (REQUEST AMOUNT) : </u><br/>' +             
                '¥ ' + rfa.RequestAmountFunctionalCurrency__c + '<br/>' + 
                '</p>' + 

                '<p style="font-weight:bold">下記リンクをクリックし、承認申請リクエスト文書をご確認ください : </p>' + 
                '<p style="font-weight:bold">Click this link to open the RFA Request Document : </p>' + 
                '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + rfa.Id + '">' + rfa.Name + '</a><br/>' + 

                '<p>ご質問がございましたら、 <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a> へご連絡ください。<BR/>' + 
                '<p>If you have any inquiries kindly contact <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a>.<BR/>' + 
                                        
              '</div>' +     
            '</body>' + 
          '</html>';
        return strHtmlBody;
 	}
 	
 	//called by sendEmail_EnterCirculation_ReqPPOC()
 	// RFA__c.Stage__c: Draft -> Circulation
 	// TO: Requester & PPOC
 	// Template: RFAVFT03_Upon Circulation - Requester  /00X10000000eBTi?setupid=CommunicationTemplatesEmail
 	public static String getHtmlBody_Enter_Circulation_ReqPPOC(
 		User ppoc, String Subject, RFA__c rfa) {
 								
 		String strHtmlBody =
 		  '<html>' +
 		      '<head>' +
              '</head>' +
            '<body >' + //style = "font-family: Arial Unicode MS;"
              '<div style = "font-size:12px;"' + //font-family:Arial Unicode MS;
              '<br/>' + 
                '<p style="font-weight:bold">本Eメールは下記承認申請の回覧が開始されたことをお知らせするものです。</p>' +
                '<p style="font-weight:bold">以下のリンクを使用して承認申請にアクセスしてください。</p>' +
				'<p style="font-weight:bold">This email is to notify you that the following RFA has been sent to Circulation</p>' +	
				'<p style="font-weight:bold">Use the Link below to access the Request and view status of approvals. </p>' +		

                '<p style="font-weight:bold"><u>案件名 (REQUEST TITLE): </u><br/>' + 
                rfa.RequestTitle__c + '<br/>' + 
                '</p>' + 
                
                '<p style="font-weight:bold"><u>コストセンター (Cost Center): </u><br/>' +
                rfa.Cost_Center_Number_Name__c  + '<br/>' +  //Cost_Center_Number__r.Name  CostCenterName__c
                '</p>' +                
                                              
                '<p style="font-weight:bold"><u>申請金額(円) (REQUEST AMOUNT) : </u><br/>' +             
                '¥ ' + rfa.RequestAmountFunctionalCurrency__c + '<br/>' + 
                '</p>' + 

                '<p style="font-weight:bold">下記リンクをクリックし、承認申請リクエストの文書をご確認ください : </p>' + 
                '<p style="font-weight:bold">Click this link to open the RFA Request Document : </p>' + 
                '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + rfa.Id + '">' + rfa.Name + '</a><br/>' + 

                '<p style="font-weight:bold">このEメールは、本承認申請の申請者または主要連絡先の方へ送られています。</p>' + 
                '<p style="font-weight:bold">You are receiving this email because you are the Requester or Primary Point of Contact(s) the RFA.</p>' + 

                '<p>ご質問がございましたら、 <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a> へご連絡ください。<BR/>' + 
                '<p>If you have any inquiries kindly contact <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a>.<BR/>' + 
                                        
              '</div>' +     
            '</body>' + 
          '</html>';
        return strHtmlBody;
 	} 	 	
 	//called from sendEmail_EnterCirculation_ReqPPOC()
 	// Template: RFAVFT02 Upon Circulation - Info Only  /00X10000000eAqv?setupid=CommunicationTemplatesEmail
	// To: Info Only Copy
 	public static String getHtmlBody_Enter_Circulation_InfoOnly(
 		User ppoc, String Subject, RFA__c rfa) {
 								
 		String strHtmlBody =
 		  '<html>' +
 		      '<head>' +
              '</head>' +
            '<body >' + //style = "font-family: Arial Unicode MS;"
              '<div style = "font-size:12px;"' + //font-family:Arial Unicode MS;
              '<br/>' + 
                '<p style="font-weight:bold">このEメールは、下記承認申請の参照者の方へお送りしています。</p>' +
				'<p style="font-weight:bold">You are receiving this email because you were identified to receive an informational only copy of the following RFA.</p>' +		

                '<p style="font-weight:bold"><u>案件名 (REQUEST TITLE): </u><br/>' + 
                rfa.RequestTitle__c + '<br/>' + 
                '</p>' + 
                
                '<p style="font-weight:bold"><u>コストセンター (Cost Center): </u><br/>' +
                rfa.Cost_Center_Number_Name__c  + '<br/>' +  //Cost_Center_Number__r.Name  CostCenterName__c
                '</p>' +                
                                              
                '<p style="font-weight:bold"><u>申請金額(円) (REQUEST AMOUNT) : </u><br/>' +             
                '¥ ' + rfa.RequestAmountFunctionalCurrency__c + '<br/>' + 
                '</p>' + 

                '<p style="font-weight:bold">内容を確認する場合には下記リンクをクリックし、承認申請リクエストの文書を開いてください : </p>' + 
                '<p style="font-weight:bold">Click this link to open the RFA Request Document : </p>' + 
                '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + rfa.Id + '">' + rfa.Name + '</a><br/>' +  

                '<p>ご質問がございましたら、 <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a> へご連絡ください。<BR/>' + 
                '<p>If you have any inquiries kindly contact <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a>.<BR/>' + 
                                        
              '</div>' +     
            '</body>' + 
          '</html>';
        return strHtmlBody;
 	}  	
 	
 	
 	//Only for Current Approver & Agent
 	public static String getHtmlBody_Enter_Circulation_Approver(
 		User ppoc, String Subject, RFA__c rfa) {
 								
 		String strHtmlBody =
 		  '<html>' +
 		      '<head>' +
              '</head>' +
            '<body >' + //style = "font-family: Arial Unicode MS;"
              '<div style = "font-size:12px;"' + //font-family:Arial Unicode MS;
              '<br/>' + 
                '<p style="font-weight:bold">下記リンクより申請内容を確認の上、承認をお願い致します。</p>' +
				'<p style="font-weight:bold">Your approval is requested for the following RFA. </p>' +		

                '<p style="font-weight:bold"><u>案件名 (REQUEST TITLE): </u><br/>' + 
                rfa.RequestTitle__c + '<br/>' + 
                '</p>' + 
                
                '<p style="font-weight:bold"><u>コストセンター (Cost Center): </u><br/>' +
                rfa.Cost_Center_Number_Name__c + '<br/>' + 
                '</p>' +                
                                              
                '<p style="font-weight:bold"><u>申請金額(円) (REQUEST AMOUNT) : </u><br/>' +             
                '¥ ' + rfa.RequestAmountFunctionalCurrency__c + '<br/>' + 
                '</p>' + 

                '<p style="font-weight:bold">このリンクをクリックし、承認申請リクエスト文書をご確認ください : </p>' + 
                '<p style="font-weight:bold">Click this link to open the RFA Document : </p>' + 
                '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + rfa.Id + '">' + rfa.Name + '</a><br/>' + 

                '<p>ご質問がございましたら、 <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a> へご連絡ください。<BR/>' + 
                '<p>If you have any inquiries kindly contact <a href="mailto:' + ppoc.Email + '?subject=RE : ' + Subject + '">' + ppoc.Lastname + ' ' + ppoc.FirstName + '</a>.<BR/>' + 
                                        
              '</div>' +     
            '</body>' + 
          '</html>';
        return strHtmlBody;
 	} 	

}