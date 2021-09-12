@isTest public with sharing class EcomailApiTest {

    @testSetup
    public static void testSetup() {
        List<Contact> contacts = EcomailTestUtils.createContacts(2, true);
        List<Lead> leads = EcomailTestUtils.createLeads(2, true);    
        Campaign campaign = EcomailTestUtils.createCampaign('Test Campiagn', true);
        EcomailTestUtils.createCampaignMembers(campaign.Id, contacts, leads, true);
    }

    @isTest public static void testaAddSubscriberBulk() {
        Contact[] contacts = [
            SELECT fields(STANDARD) FROM Contact LIMIT 200
        ];

        Test.setMock(HttpCalloutMock.class, new EcomailApiCalloutMock());
        Test.startTest();
        
        EcomailApi api = new EcomailApi();
        api.addSubscriberBulk(1, contacts);
        Test.stopTest();
    }
}