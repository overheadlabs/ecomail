@isTest public with sharing class EcomailQueryBuilderTest {
    @isTest public static void testAll() {
        Test.startTest();
        EcomailQueryBuilder.getContactFieldsForSoql();
        EcomailQueryBuilder.getLeadFieldsForSoql();
        EcomailQueryBuilder.getContactEcomailToSfdcCustomFields();
        EcomailQueryBuilder.getLeadEcomailToSfdcCustomFields();
        EcomailQueryBuilder.getLeadSfdcToEcomailCustomFields();
        EcomailQueryBuilder.getContactSfdcToEcomailCustomFields();
        Test.stopTest();
    }
}