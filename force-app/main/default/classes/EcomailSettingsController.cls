public with sharing class EcomailSettingsController {
    
    @AuraEnabled
    public static Boolean synchronize(String objName){
        EcomailContactSynchronizer contactSyncer = new EcomailContactSynchronizer();
        EcomailCampaignSynchronizer campaignSyncer = new EcomailCampaignSynchronizer();

        try {
            switch on objName {
                when 'Contact' {
                    contactSyncer.syncAllContacts();
                }
                when 'Lead' {
                    contactSyncer.syncAllLeads();
                }
                when 'Campaign' {
                    campaignSyncer.synchronizeAllCampaignsToEcomail();
                }
            }    

            return true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
