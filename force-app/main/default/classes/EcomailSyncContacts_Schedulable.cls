public without sharing class EcomailSyncContacts_Schedulable implements Schedulable{
    public void execute(SchedulableContext SC) {
        System.enqueueJob(new EcomailSyncContacts_Queueable());
    }
}