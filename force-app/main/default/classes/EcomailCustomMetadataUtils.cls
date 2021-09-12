public class EcomailCustomMetadataUtils {
    public static EcomailSetting__mdt getSettings() {
        EcomailSetting__mdt settings;

        if(!Test.isRunningTest()) {
            settings = EcomailSetting__mdt.getInstance('Main');
        } else {

            settings = new EcomailSetting__mdt();
            settings.APIKey__c = '<replace_this>';
            settings.FromEmail__c = 'replace_this@replace.com';
            settings.FromName__c = '<replace_this>';
            settings.ReplyToEmail__c = 'replace_this@replace.com';
            settings.SyncContacts__c = true;
            settings.SyncLeads__c = true;
            settings.SyncCampaigns__c = true;
        }

        return settings;
    }

    public static List<EcomailFieldMapping__mdt> getFieldMappings() {
        List<EcomailFieldMapping__mdt> mappings;

        if(!Test.isRunningTest()) {
            mappings = EcomailFieldMapping__mdt.getAll().values();
        } else {
            mappings = new List<EcomailFieldMapping__mdt>();
            EcomailFieldMapping__mdt mappingLead = new EcomailFieldMapping__mdt();
            mappingLead.SfdcObject__c = 'Lead';
            mappingLead.SfdcField__c = 'Id';
            mappingLead.EcomailField__c = 'obj_id';

            EcomailFieldMapping__mdt mappingContact = new EcomailFieldMapping__mdt();
            mappingContact.SfdcObject__c = 'Contact';
            mappingContact.SfdcField__c = 'Id';
            mappingContact.EcomailField__c = 'obj_id';

            mappings.add(mappingLead);
            mappings.add(mappingContact);
        }

        return  mappings;
    }  
}