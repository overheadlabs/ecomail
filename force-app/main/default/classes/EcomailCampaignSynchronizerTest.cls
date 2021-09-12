@isTest public class EcomailCampaignSynchronizerTest {
    @testSetup
    public static void testSetup() {
        List<Contact> contacts = EcomailTestUtils.createContacts(2, true);
        List<Lead> leads = EcomailTestUtils.createLeads(2, true);    
        Campaign campaign = EcomailTestUtils.createCampaign('Test Campiagn', true);
        EcomailTestUtils.createCampaignMembers(campaign.Id, contacts, leads, true);
    }


    @isTest public static void testSyncAllCampaignsToEcomail() {
        EcomailCampaignSynchronizer syncer = new EcomailCampaignSynchronizer();

        Test.setMock(HttpCalloutMock.class, new EcomailApiCalloutMock());
        Test.startTest();
        
        syncer.synchronizeAllCampaignsToEcomail();
        
        Test.stopTest();
    }

    @isTest public static void testSyncampaignStatsFromEcomail() {
        EcomailCampaignSynchronizer syncer = new EcomailCampaignSynchronizer();

        Campaign campaign = [SELECT EcomailSync__c, EcomailCampaignId__c FROM Campaign LIMIT 1];
        campaign.EcomailSync__c = true;
        campaign.EcomailCampaignId__c = 1;
        update campaign;

        Test.setMock(HttpCalloutMock.class, new EcomailApiCalloutMock('campaign_stats'));
        Test.startTest();
        
        syncer.synchronizeStatsFromEcomail();
        
        Test.stopTest();
    }
}