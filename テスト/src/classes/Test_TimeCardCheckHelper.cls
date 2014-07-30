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
private class Test_TimeCardCheckHelper {

// Unit testing
/*
    static testMethod void testSortCustomObject() {
        List<TPValue__c> TPValues;
        TimeCardCheckHelper sorter = new TimeCardCheckHelper();
        String fieldName;

        TPValues = [SELECT TPName__r.TPName__c, Value__c FROM TPValue__c LIMIT 50];
        fieldName = 'Value__c';
        testOrderedList(sorter.getSortedList(TPValues, fieldName, true), fieldName, true);

        fieldName = 'TPName__r.TPName__c';
        testOrderedList(sorter.getSortedList(TPValues, fieldName, true), fieldName, true);
    }
*/
    static testMethod void testSimpleField_Ascending() {
        testSortingContacts('Name', true);
    }
    static testMethod void testSimpleField_Descending() {
        testSortingContacts('Name', False);
    }
    static testMethod void testLookupField_Ascending() {
        testSortingContacts('Account.Name', True);
    }
    static testMethod void testLookupField_Decending() {
        testSortingContacts('Account.Name', False);
    }
    static testMethod void testMultipleCalls() {
        TimeCardCheckHelper sorter;
        sorter = testSortingContacts(null, 'Name', true);
        testSortingContacts(sorter, 'Name', False);
        testSortingContacts(sorter, 'Account.Name', True);
        testSortingContacts(sorter, 'Account.Name', False);
    }
    static testMethod void testForgotOriginalList() {
        Boolean exceptionDetected = false;
        TimeCardCheckHelper sorter = new TimeCardCheckHelper();
        try {
           // sorter.getSortedList('Name', true);
        } catch (NullPointerException e) {
            exceptionDetected = true;
        }
        System.assert(exceptionDetected);
    }
    static testMethod void testPassingList() {
        TimeCardCheckHelper sorter = new TimeCardCheckHelper();
        List<Contact> contacts = [SELECT Name, Phone, Account.Name FROM Contact LIMIT 50];
        List<Contact> sortedList = (List<Contact>) sorter.getSortedList(contacts, 'Name', true);
        testOrderedList(sortedList, 'Name', true);
    }
    private static void testSortingContacts(string fieldName, Boolean isAscending) {
        testSortingContacts(null, fieldName, isAscending);
    }
    private static TimeCardCheckHelper testSortingContacts(TimeCardCheckHelper sorter, string fieldName, Boolean isAscending) {
        // If sorted is null,create it.
        if (sorter == null) {
            sorter = new TimeCardCheckHelper();
            sorter.originalList = [SELECT Name, Phone, Account.Name FROM Contact LIMIT 50];
        }

        // Sort list
        List<Contact> sortedList = (List<Contact>) sorter.getSortedList(fieldName, isAscending);        // Test sort order
        testOrderedList(sortedList, fieldName, isAscending);

        return sorter;
    }
    private static void testOrderedList(List<sObject> sortedList, string fieldName, Boolean isAscending) {
        String lastValue = null;
        String currentValue = null;        for (sObject sObj : sortedList) {
            //currentValue = getValue(sObj, fieldName);
            if ((lastValue != null) && (currentValue != null)) {                String strDebug = '';
                strDebug += '\n--------------------------------------------------------------';
                strDebug += '\nSTART';
                strDebug += '\n--------------------------------------------------------------';
                strDebug += '\n[Ascending:'+isAscending+']';
                strDebug += '\n[Previous:'+lastValue+'] [IsNull():'+(lastValue==null)+']';
                strDebug += '\n[Current:'+currentValue+'] [IsNull():'+(currentValue==null)+']';
                strDebug += '\n[CompareTo:'+(currentValue.compareTo(lastValue))+']';
                strDebug += '\n--------------------------------------------------------------';
                strDebug += '\nEND';
                strDebug += '\n--------------------------------------------------------------';
                System.debug(strDebug);                if (isAscending) {
                    System.assertEquals(currentValue.compareTo(lastValue)>=0, true);
                } else {
                    System.assertEquals(currentValue.compareTo(lastValue)<=0, true);
                }
            }
            lastValue = currentValue;
        }
    }
}