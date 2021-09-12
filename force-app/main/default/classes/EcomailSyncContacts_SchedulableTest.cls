@isTest public with sharing class EcomailSyncContacts_SchedulableTest {
    @isTest public static void test() {
        Test.startTest();
        System.schedule('Test', '0 0 23 * * ?', new EcomailSyncContacts_Schedulable());
        TEst.stopTest();
    }
}