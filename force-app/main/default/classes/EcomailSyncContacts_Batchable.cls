public class EcomailSyncContacts_Batchable implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(EcomailQueryBuilder.soqlContacts(null, null));
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        EcomailContactSynchronizer syncer = new EcomailContactSynchronizer();
        syncer.synchronizeContactsToEcomail((List<Contact>)scope);
    }

    public void finish(Database.BatchableContext BC) {

    }

}