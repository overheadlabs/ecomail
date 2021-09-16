public without sharing class EcomailSyncLeads_Schedulable implements Schedulable {
    public Boolean runBatch;

    public EcomailSyncLeads_Schedulable(Boolean runBatch) {
        this.runBatch = runBatch;
    }

    public void execute(SchedulableContext SC) {
        if (runBatch == true){
            Database.executeBatch(new EcomailSyncLeads_Batchable(), 2000);
        } else {
            System.enqueueJob(new EcomailSyncLeads_Queueable());
        }
    }
}
