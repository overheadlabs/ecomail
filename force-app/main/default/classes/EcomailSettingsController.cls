public with sharing class EcomailSettingsController {
    
    @AuraEnabled
    public static Boolean synchronize(String objName){
        EcomailContactSynchronizer contactSyncer = new EcomailContactSynchronizer();
        EcomailCampaignSynchronizer campaignSyncer = new EcomailCampaignSynchronizer();

        try {
            switch on objName {
                when 'Contact' {
                    Database.executeBatch(new EcomailSyncContacts_Batchable(), 2000);
                }
                when 'Lead' {
                    Database.executeBatch(new EcomailSyncLeads_Batchable(), 2000);
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
