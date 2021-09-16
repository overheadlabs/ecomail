public class EcomailSyncLeads_Batchable  implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(EcomailQueryBuilder.soqlLeads(null, null));
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        EcomailContactSynchronizer syncer = new EcomailContactSynchronizer();
        syncer.synchronizeLeadsToEcomail((List<Lead>)scope);
    }

    public void finish(Database.BatchableContext BC) {
        
    }
}
