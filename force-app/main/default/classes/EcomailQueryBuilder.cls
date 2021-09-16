public without sharing class EcomailQueryBuilder {
    private static final string DT_FORMAT = 'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'';

    public static String soqlContacts(Datetime sinceLastModifiedDate, Integer limitRecords) {
        List<String> contactFields = getContactFieldsForSoql();
        
        // build SOQL witl standard and custom fields
        String soql = 'SELECT '
                    + String.join(contactFields, ', ') + 
                    + ' FROM Contact '
                    + ' WHERE EcomailSync__c = true AND Email!=\'\'';

        if (sinceLastModifiedDate != null) {
            soql += ' AND LastModifiedDate >= ' + sinceLastModifiedDate.formatGmt(DT_FORMAT);
        }

        if(limitRecords != null) {
            soql += ' LIMIT ' + limitRecords; 
        }

        return soql;
    }

    public static String soqlLeads(Datetime sinceLastModifiedDate, Integer limitRecords) {
        List<String> leadFields = getLeadFieldsForSoql();
        
        // build SOQL witl standard and custom fields
        String soql = 'SELECT '
                    + String.join(leadFields, ', ') + 
                    + ' FROM Lead '
                    + ' WHERE EcomailSync__c = true AND Email!=\'\'';

        if (sinceLastModifiedDate != null) {
            soql += ' AND LastModifiedDate >= ' + sinceLastModifiedDate.formatGmt(DT_FORMAT);
        }

        if(limitRecords != null) {
            soql += ' LIMIT ' + limitRecords; 
        }

        return soql;
    }

    public static String soqlCampaigns(Datetime sinceLastModifiedDate, Integer limitRecords) {
        List<String> contactFields = getContactFieldsForSoql();
        Set<String> updatedContactFields =new Set<String>();

        for (String each : contactFields) {
            String newStr = 'Contact.' + each;
            System.debug(newStr);
            updatedContactFields.add(newStr);
        }

        List<String> leadFields = getLeadFieldsForSoql();
        Set<String> updatedLeadFields = new Set<String>();

        for (String each : leadFields) {
            String newStr = 'Lead.' + each;
            System.debug(newStr);
            updatedLeadFields.add(newStr);
        }

        String soqlSubqeury = ' (SELECT Type, ' + String.join(new List<String>(updatedContactFields), ', ') + ', ' + String.join(new List<String>(updatedLeadFields), ', ') + ' FROM CampaignMembers WHERE Email != \'\') ';
        
        String soql = 'SELECT Name, EcomailCampaignId__c, EcomailListId__c, EcomailSync__c, ' 
                    + soqlSubqeury
                    + 'FROM Campaign '
                    + 'WHERE EcomailSync__c = true ';

        if (sinceLastModifiedDate != null) {
            System.debug(' AND LastModifiedDate >= ' + sinceLastModifiedDate.formatGmt(DT_FORMAT));
            soql += ' AND LastModifiedDate >= ' + sinceLastModifiedDate.formatGmt(DT_FORMAT);
        }

        if(limitRecords != null) {
            soql += ' LIMIT ' + limitRecords; 
        }

        return soql;
    }

    public static List<String> getContactFieldsForSoql() {
        Set<String> fields = new Set<String> { 'Id', 'Name', 'FirstName', 'LastName', 'Email', 'MailingAddress', 'Phone'};
        fields.addAll(getContactSfdcCustomFields());
        return new List<String>(fields);
    }

    public static List<String> getLeadFieldsForSoql() {
        Set<String> fields = new Set<String> { 'Id', 'Name', 'FirstName', 'LastName', 'Email', 'Address', 'Phone'};
        fields.addAll(getLeadSfdcCustomFields());
        return new List<String>(fields);
    }

    public static List<String> getContactSfdcCustomFields() {
        return getSfdcFields(getContactMappings());
    }

    public static List<String> getLeadSfdcCustomFields() {
        return getSfdcFields(getLeadMappings());
    }

    public static List<EcomailFieldMapping__mdt> getContactMappings() {
        return getFilteredMappings('Contact');
    }

    public static List<EcomailFieldMapping__mdt> getLeadMappings() {
        return getFilteredMappings('Lead');
    }

    public static List<EcomailFieldMapping__mdt> getFilteredMappings(String sObjectName) {
        List<EcomailFieldMapping__mdt> filteredRecords = new List<EcomailFieldMapping__mdt>();

        for (EcomailFieldMapping__mdt each : EcomailCustomMetadataUtils.getFieldMappings()) {
            if (each.SfdcObject__c == sObjectName) {
                filteredRecords.add(each);
            }
        }

        return filteredRecords;
    }

    public static List<String> getSfdcFields(List<EcomailFieldMapping__mdt> mappings) {
        List<String> fields = new List<String>();

        for (EcomailFieldMapping__mdt each : mappings) {
            fields.add(getMappingFieldName(each));
        }

        return fields;
    }

    public static Map<String, String> getContactEcomailToSfdcCustomFields() {
        List<EcomailFieldMapping__mdt> mappings =  getContactMappings();
        Map<String, String> result = new Map<String, String>();

        for (EcomailFieldMapping__mdt each : mappings) {
            result.put(each.EcomailField__c, getMappingFieldName(each));
        }

        return result;
    }

    public static Map<String, String> getLeadEcomailToSfdcCustomFields() {
        List<EcomailFieldMapping__mdt> mappings =  getLeadMappings();
        Map<String, String> result = new Map<String, String>();

        for (EcomailFieldMapping__mdt each : mappings) {
            result.put(each.EcomailField__c, getMappingFieldName(each));
        }

        return result;
    }

    public static Map<String, String> getContactSfdcToEcomailCustomFields() {
        List<EcomailFieldMapping__mdt> mappings =  getContactMappings();
        Map<String, String> result = new Map<String, String>();

        for (EcomailFieldMapping__mdt each : mappings) {
            result.put(getMappingFieldName(each), each.EcomailField__c);
        }

        return result;
    }

    public static Map<String, String> getLeadSfdcToEcomailCustomFields() {
        List<EcomailFieldMapping__mdt> mappings =  getLeadMappings();
        Map<String, String> result = new Map<String, String>();

        for (EcomailFieldMapping__mdt each : mappings) {
            result.put(getMappingFieldName(each), each.EcomailField__c);
        }

        return result;
    }

    private static String getMappingFieldName(EcomailFieldMapping__mdt mapping) {
        String name;

        if (mapping.SfdcField__r.DeveloperName != null) {
            name = mapping.SfdcField__r.DeveloperName;
        } else {
            name = mapping.SfdcField__c;
        }

        return name;
    }
}