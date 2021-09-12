public with sharing class EcomailSyncContacts_Queueable implements Queueable {
    public void execute(QueueableContext context) {
        EcomailContactSynchronizer synchronizer = new EcomailContactSynchronizer();

        synchronizer.syncAllContacts();
        synchronizer.syncAllLeads();
    }
}