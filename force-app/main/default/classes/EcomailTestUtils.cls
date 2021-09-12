@isTest public with sharing class EcomailTestUtils {
    public static List<Contact> createContacts(Integer num, Boolean save) {
        Contact[] contacts = new List<Contact>();
        
        for (Integer i=0; i < num; i++) {
            contacts.add(createContact('Contact ' + i, 'User ' + i, 'contact' + i + '@test.cz', false));
        }

        if (save) {
            insert contacts;
        }

        return contacts;
    }

    public static Contact createContact(String firstName, String lastName, String email, Boolean save) {
        Contact contact = new Contact(
            FirstName=firstName,
            LastName=lastName,
            Email=email,
            EcomailSync__c=true
        );

        if (save) {
            insert contact;
        }
        return contact;
    }

    public static List<Lead> createLeads(Integer num, Boolean save) {
        Lead[] leads = new List<Lead>();
        
        for (Integer i=0; i < num; i++) {
            leads.add(createLead('Lead ' + i, 'User ' + i, 'lead' + i + '@test.cz', false));
        }

        if (save) {
            insert leads;
        }

        return leads;
    }

    public static Lead createLead(String firstName, String lastName, String email, Boolean save) {
        Lead lead = new Lead(
            FirstName=firstName,
            LastName=lastName,
            Email=email,
            Company='Company',
            EcomailSync__c=true
        );

        if (save) {
            insert lead;
        }
        return lead;
    }

    public static Campaign createCampaign(String name, Boolean save) {
        Campaign campaign = new Campaign(
            Name=name,
            EcomailSync__c=true
        );

        if (save) {
            insert campaign;
        }
        return campaign;
    }

    public static List<CampaignMember> createCampaignMembers(String campaignId, List<Contact> contacts, List<Lead> leads, Boolean save) {
        CampaignMember[] members = new List<CampaignMember>();
        
        for (Contact each : contacts) {
            members.add(new CampaignMember(CampaignId=campaignId, ContactId=each.Id));
        } 
        
        for (Lead each : leads) {
            members.add(new CampaignMember(CampaignId=campaignId, LeadId=each.Id));
        } 

        if (save) {
            insert members;
        }

        return members;
    }
}