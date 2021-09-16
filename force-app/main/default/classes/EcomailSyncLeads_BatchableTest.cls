@IsTest public without sharing class EcomailSyncLeads_BatchableTest {
    @TestSetup
    public static void setup(){
        EcomailTestUtils.createLeads(10, true);    
    }

    @isTest public static void testLeads() {
        Test.setMock(HttpCalloutMock.class, new EcomailApiCalloutMock());

        Test.startTest();
        
        Database.executeBatch(new EcomailSyncLeads_Batchable(), 2000);

        Test.stopTest();
    }
}
