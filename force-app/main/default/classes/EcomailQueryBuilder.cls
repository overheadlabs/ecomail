public without sharing class EcomailQueryBuilder {
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