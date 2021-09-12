@isTest public with sharing class EcomailSyncContacts_QueueableTest {
    @isTest public static void test() {
        Test.startTest();

        System.enqueueJob(new EcomailSyncContacts_Queueable());

        Test.stopTest();
    }
}