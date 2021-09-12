public without sharing class EcomailSyncCampaigns_Schedulable implements Schedulable {
    public void execute(SchedulableContext SC) {
        System.enqueueJob(new EcomailSyncCampaigns_Queueable());
    }
}