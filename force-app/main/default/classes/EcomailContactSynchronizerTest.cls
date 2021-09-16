@isTest public class EcomailContactSynchronizerTest {
    @testSetup
    public static void testSetup() {
        List<Contact> contacts = EcomailTestUtils.createContacts(2, true);
        List<Lead> leads = EcomailTestUtils.createLeads(2, true);    
    }


    @isTest public static void testSyncAllContactsToEcomail() {
        EcomailContactSynchronizer syncer = new EcomailContactSynchronizer();

        Test.setMock(HttpCalloutMock.class, new EcomailApiCalloutMock());
        Test.startTest();
        
        syncer.syncAllContacts();
        
        Test.stopTest();
    }

    @isTest public static void testSyncChangedContactsToEcomail() {
        EcomailContactSynchronizer syncer = new EcomailContactSynchronizer();

        Test.setMock(HttpCalloutMock.class, new EcomailApiCalloutMock());
        Test.startTest();
        
        syncer.syncChangedContacts();
        
        Test.stopTest();
    }

    @isTest public static void testSyncAllLeadsToEcomail() {
        EcomailContactSynchronizer syncer = new EcomailContactSynchronizer();

        Test.setMock(HttpCalloutMock.class, new EcomailApiCalloutMock());
        Test.startTest();
        
        syncer.syncAllLeads();
        
        Test.stopTest();
    }

    @isTest public static void testSyncChangedLeadsToEcomail() {
        EcomailContactSynchronizer syncer = new EcomailContactSynchronizer();

        Test.setMock(HttpCalloutMock.class, new EcomailApiCalloutMock());
        Test.startTest();
        
        syncer.syncChangedLeads();
        
        Test.stopTest();
    }
}
