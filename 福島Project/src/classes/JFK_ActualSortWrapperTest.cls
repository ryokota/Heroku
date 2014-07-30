/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class JFK_ActualSortWrapperTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.startTest();
        JFK_CommonM__c com1 = new JFK_CommonM__c(Name='t', Code__c='code', BunruiMeisyo__c='雇用区分');
        JFK_CommonM__c com2 = new JFK_CommonM__c(Name='t', Code__c='code', BunruiMeisyo__c='雇用種類');
        JFK_CommonM__c com3 = new JFK_CommonM__c(Name='t', Code__c='code', BunruiMeisyo__c='雇用形態');
        insert new JFK_CommonM__c[]{com1, com2, com3};
        
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact(RodosyaCD__c='test2',KoyoKeiyaku_KaishiBi__c=date.today(), KoyoKBN__c=com1.Id, KoyoSyurui__c=com2.Id, KoyoKeitai__c=com3.Id, LastName = 'contact',FirstName = '2', RodosyaNO__c = 2);
        conList.add(con);
        con = new Contact(RodosyaCD__c='test1',KoyoKeiyaku_KaishiBi__c=date.today(), KoyoKBN__c=com1.Id, KoyoSyurui__c=com2.Id, KoyoKeitai__c=com3.Id, LastName = 'contact',FirstName = '1', RodosyaNO__c = 1);
        conList.add(con);
        con = new Contact(RodosyaCD__c='test3',KoyoKeiyaku_KaishiBi__c=date.today(), KoyoKBN__c=com1.Id, KoyoSyurui__c=com2.Id, KoyoKeitai__c=com3.Id, LastName = 'contact',FirstName = '3', RodosyaNO__c = 3);
        conList.add(con);
        //RodosyaCD__c, KoyoKeiyaku_KaishiBi__c, KoyoKBN__c, KoyoSyurui__c, KoyoKeitai__c
        insert conList;
        
        List<JFK_RodoSyaTR__c> rodoList = new  List<JFK_RodoSyaTR__c>();
        Integer idx = 0;
        for(Contact c : conList){
            JFK_RodoSyaTR__c rodo = new JFK_RodoSyaTR__c(Rodosya__c = c.id, Name='conTr' + idx);
            rodoList.add(rodo);
            idx ++;
            
        }
        insert rodoList;
        rodoList = [SELECT Rodosya__r.Name, Rodosya__r.RodosyaNO__c from JFK_RodoSyaTR__c];
        List<JFK_ActualSortWrapper> sortList = new List<JFK_ActualSortWrapper>();
        //sortList.sort();
        for(JFK_RodoSyaTR__c r : rodoList){
            sortList.add(new JFK_ActualSortWrapper(r));
        }
        sortList.sort();
        
        // Verify the sort order
        system.debug(sortList[0].obj.Rodosya__r.Name);
        System.assertEquals('contact 1', sortList[0].obj.Rodosya__r.Name);
        System.assertEquals(1, sortList[0].obj.Rodosya__r.RodosyaNO__c);
        System.assertEquals('contact 2', sortList[1].obj.Rodosya__r.Name);
        System.assertEquals(2, sortList[1].obj.Rodosya__r.RodosyaNO__c);
        System.assertEquals('contact 3', sortList[2].obj.Rodosya__r.Name);
        System.assertEquals(3, sortList[2].obj.Rodosya__r.RodosyaNO__c);
        
        //例外クラスは１行しかないのでここで実行
        JFK_ActualValidateException ex = new JFK_ActualValidateException();
        Test.stopTest();
    }
}