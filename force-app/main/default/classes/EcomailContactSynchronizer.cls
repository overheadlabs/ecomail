public without sharing class EcomailContactSynchronizer {
    public void syncAllContacts() {
        String soql = EcomailQueryBuilder.soqlContacts(null, null);
        
        List<Contact> contacts = Database.query(soql);
        this.synchronizeContactsToEcomail(contacts);
    }

    public void syncChangedContacts() {
        Datetime since = Datetime.now();
        since.addHours(-2);
        // TODO: order by synced time to sync 
        String soql = EcomailQueryBuilder.soqlContacts(since, 50000);
        
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
        String soql = EcomailQueryBuilder.soqlLeads(null, null);

        
        List<Lead> leads = Database.query(soql);
        this.synchronizeLeadsToEcomail(leads);
    }

    public void syncChangedLeads() {
        Datetime since = Datetime.now();
        since.addHours(-2);

        String soql = EcomailQueryBuilder.soqlLeads(since, 50000);

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
}