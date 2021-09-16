@isTest public without sharing class EcomailSyncLeads_SchedulableTest {
    @isTest public static void testBatch() {
        Test.startTest();
        System.schedule('Test', '0 0 23 * * ?', new EcomailSyncLeads_Schedulable(true));
        TEst.stopTest();
    }

    @isTest public static void testQueue() {
        Test.startTest();
        System.schedule('Test', '0 0 23 * * ?', new EcomailSyncLeads_Schedulable(false));
        TEst.stopTest();
    }
}
