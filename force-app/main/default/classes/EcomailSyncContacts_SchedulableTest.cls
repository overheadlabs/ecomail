@isTest public with sharing class EcomailSyncContacts_SchedulableTest {
    @isTest public static void testBatch() {
        Test.startTest();
        System.schedule('Test', '0 0 23 * * ?', new EcomailSyncContacts_Schedulable(true));
        TEst.stopTest();
    }

    @isTest public static void testQueue() {
        Test.startTest();
        System.schedule('Test', '0 0 23 * * ?', new EcomailSyncContacts_Schedulable(false));
        TEst.stopTest();
    }
}