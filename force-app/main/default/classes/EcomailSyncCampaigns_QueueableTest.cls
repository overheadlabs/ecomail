@isTest public with sharing class EcomailSyncCampaigns_QueueableTest {
    @isTest public static void test() {
        Test.startTest();

        System.enqueueJob(new EcomailSyncCampaigns_Queueable());

        Test.stopTest();
    }
}