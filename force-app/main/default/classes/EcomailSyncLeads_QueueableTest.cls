@isTest public with sharing class EcomailSyncLeads_QueueableTest {
    @isTest public static void test() {
        Test.startTest();

        System.enqueueJob(new EcomailSyncLeads_Queueable());

        Test.stopTest();
    }
}
