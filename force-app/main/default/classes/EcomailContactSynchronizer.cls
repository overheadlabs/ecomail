public without sharing class EcomailContactSynchronizer {
    public void syncAllContacts() {
        List<String> contactFields = EcomailQueryBuilder.getContactFieldsForSoql();
        
        // build SOQL witl standard and custom fields
        String soql = 'SELECT '
                    + String.join(contactFields, ', ') + 
                    + ' FROM Contact '
                    + ' WHERE EcomailSync__c = true AND Email!=\'\'';
        
        List<Contact> contacts = Database.query(soql);
        this.synchronizeContactsToEcomail(contacts);
    }


    public void synchronizeContactsToEcomail(List<Contact> contacts) {
        EcomailSetting__mdt settings = EcomailCustomMetadataUtils.getSettings();

        if (!settings.SyncContacts__c) {
            return;
        }
        
        Integer ecomailListId = (Integer)settings.EcomailListIdContacts__c ;

        EcomailApi api = new EcomailApi();
        api.addSubscriberBulk(ecomailListId, contacts);
    }

    public void syncAllLeads() {
        List<String> leadFields = EcomailQueryBuilder.getLeadFieldsForSoql();
        
        // build SOQL witl standard and custom fields
        String soql = 'SELECT '
                    + String.join(leadFields, ', ') + 
                    + ' FROM Lead '
                    + ' WHERE EcomailSync__c = true AND Email!=\'\'';
        
        List<Lead> leads = Database.query(soql);
        this.synchronizeLeadsToEcomail(leads);
    }

    public void synchronizeLeadsToEcomail(List<Lead> leads) {
        EcomailSetting__mdt settings = EcomailCustomMetadataUtils.getSettings();

        if (!settings.SyncLeads__c) {
            return;
        }
        
        Integer ecomailListId = (Integer)settings.EcomailListIdLeads__c ;

        EcomailApi api = new EcomailApi();
        api.addSubscriberBulk(ecomailListId, leads);
    } 

    public voud synchronizeEcomailToSfdc() {
        
    }
}