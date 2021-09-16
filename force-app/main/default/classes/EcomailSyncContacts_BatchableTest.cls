@isTest public  class EcomailSyncContacts_BatchableTest {
    @TestSetup
    public static void setup(){
        EcomailTestUtils.createContacts(10, true);    
    }

    @isTest public static void test() {
        Test.setMock(HttpCalloutMock.class, new EcomailApiCalloutMock());
        Test.startTest();

        Database.executeBatch(new EcomailSyncContacts_Batchable(), 2000);

        Test.stopTest();
    }
}
