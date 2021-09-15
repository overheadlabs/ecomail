@isTest public with sharing class EcomailSettingsControllerTest {
    @isTest public static void testSynchronize() {
        Test.startTest();
        EcomailSettingsController.synchronize('Contact');
        EcomailSettingsController.synchronize('Lead');
        EcomailSettingsController.synchronize('Campaign');
        Test.stopTest();
    }
}
