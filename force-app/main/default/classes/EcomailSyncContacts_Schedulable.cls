public without sharing class EcomailSyncContacts_Schedulable implements Schedulable{
    public Boolean runBatch;

    public EcomailSyncContacts_Schedulable(Boolean runBatch) {
        this.runBatch = runBatch;
    }

    public void execute(SchedulableContext SC) {
        if (runBatch == true){
            Database.executeBatch(new EcomailSyncContacts_Batchable(), 2000);
        } else {
            System.enqueueJob(new EcomailSyncContacts_Queueable());
        }
    }
}