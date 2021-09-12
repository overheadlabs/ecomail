public with sharing class EcomailSyncCampaigns_Queueable implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext context) {
        EcomailCampaignSynchronizer synchronizer = new EcomailCampaignSynchronizer();

        synchronizer.synchronizeAllCampaignsToEcomail();
        synchronizer.synchronizeStatsFromEcomail();
    }
}