@isTest public class EcomailSyncCampaigns_SchedulableTest {
    @isTest public static void testSchedulable() {
        Test.startTest();
        System.schedule('Test', '0 0 23 * * ?', new EcomailSyncContacts_Schedulable());
        TEst.stopTest();
    }
}
