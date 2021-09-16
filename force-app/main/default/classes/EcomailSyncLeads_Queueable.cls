public with sharing class EcomailSyncLeads_Queueable implements Queueable {
    public void execute(QueueableContext context) {
        EcomailContactSynchronizer synchronizer = new EcomailContactSynchronizer();

        synchronizer.syncChangedLeads();
    }
}
