public without sharing class EcomailCampaignSynchronizer {
    
    public List<Campaign> getAllCampaignsToSync() {
        String soql = EcomailQueryBuilder.soqlCampaigns(null, null);
        
        return Database.query(soql);
    }

    public List<Campaign> getChangedCampaignsToSync() {
        Datetime since = Datetime.now();
        since.addHours(-2);

        String soql = EcomailQueryBuilder.soqlCampaigns(since, 50000);
        return Database.query(soql);
    }

    public List<Campaign> filterCampaignsToCreate(List<Campaign> allCampaigns) {
        List<Campaign> result = new List<Campaign>();

        for (Campaign campaign : allCampaigns) {
            if (campaign.EcomailCampaignId__c == null) {
                result.add(campaign);
            }
        }

        return result;
    }

    public List<Campaign> filterCampaignsToUpdate(List<Campaign> allCampaigns) {
        List<Campaign> result = new List<Campaign>();

        for (Campaign campaign : allCampaigns) {
            if (campaign.EcomailCampaignId__c != null) {
                result.add(campaign);
            }
        }

        return result;
    }

    public void synchronizeAllCampaignsToEcomail() {
        EcomailSetting__mdt settings = EcomailCustomMetadataUtils.getSettings();

        if (!settings.SyncCampaigns__c) {
            return;
        }

        List<Campaign> allCampaigns = this.getAllCampaignsToSync();
        List<Campaign> campaignsToCreate = this.filterCampaignsToCreate(allCampaigns);
        List<Campaign> campaignsToUpdate = this.filterCampaignsToUpdate(allCampaigns);

        synchronizeCampaigns(campaignsToCreate, campaignsToUpdate);
    }

    public void synchronizeChangedCampaignsToEcomail() {
        EcomailSetting__mdt settings = EcomailCustomMetadataUtils.getSettings();

        if (!settings.SyncCampaigns__c) {
            return;
        }

        List<Campaign> allCampaigns = this.getChangedCampaignsToSync();
        List<Campaign> campaignsToCreate = this.filterCampaignsToCreate(allCampaigns);
        List<Campaign> campaignsToUpdate = this.filterCampaignsToUpdate(allCampaigns);

        synchronizeCampaigns(campaignsToCreate, campaignsToUpdate);
    }

    public void synchronizeCampaignsToEcomail(List<Campaign> campaigns) {
        EcomailSetting__mdt settings = EcomailSetting__mdt.getInstance('Main');

        if (!settings.SyncCampaigns__c) {
            return;
        }

        List<Campaign> campaignsToCreate = this.filterCampaignsToCreate(campaigns);
        List<Campaign> campaignsToUpdate = this.filterCampaignsToUpdate(campaigns);
    }

    public Campaign createCampaign(Campaign campaign) {
        EcomailApi ecomailApi = new EcomailApi();

        String listName = 'SFDC - ' + campaign.Name;

        Integer newListId = ecomailApi.addNewList(listName);
        Integer newCampaignId = ecomailApi.addNewCampaign(campaign.Name, new List<Integer>{ newListId} );

        SObject[] members = new List<SObject>();
        members.addAll((List<SObject>) this.getContactsFromCampaignMembers(campaign.CampaignMembers));
        members.addAll((List<SObject>) this.getLeadsFromCampaignMembers(campaign.CampaignMembers));

        Boolean subscribersResponse = ecomailApi.addSubscriberBulk(
            newListId,
            members
        );

        campaign.EcomailCampaignId__c = newCampaignId;
        campaign.EcomailListId__c = newListId;

        return campaign;
    }

    public void updateCampaign(Campaign campaign) {
        EcomailApi ecomailApi = new EcomailApi();

        SObject[] members = new List<SObject>();
        members.addAll((List<SObject>) this.getContactsFromCampaignMembers(campaign.CampaignMembers));
        members.addAll((List<SObject>) this.getLeadsFromCampaignMembers(campaign.CampaignMembers));

        Boolean subscribersResponse = ecomailApi.addSubscriberBulk(
            campaign.EcomailListId__c,
            members
        );
    }

    public void synchronizeStatsFromEcomail() {
        Campaign[] campaigns = [
            SELECT Id, EcomailCampaignId__c
            FROM Campaign
            WHERE EcomailSync__c = true AND EcomailCampaignId__c != null
        ];

        List<Campaign> toUpdate = new List<Campaign>();

        for (Campaign campaign : campaigns) {
            Campaign updated = this.getStatsForCampaign(campaign);
            toUpdate.add(updated);
        }

        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }

    private Campaign getStatsForCampaign(Campaign campaign) {
        EcomailApi ecomailApi = new EcomailApi();

        EcomailApi.EcomailCampaignStats stats = ecomailApi.getCampaignStats(campaign.EcomailCampaignId__c);
        campaign.EcomailStatsBounce__c = stats.bounce;
        campaign.EcomailStatsBounceRate__c = stats.bounce_rate;
        campaign.EcomailStatsClick__c = stats.click;
        campaign.EcomailStatsClickRate__c = stats.click_rate;
        campaign.EcomailStatsConversions__c = stats.conversions;
        campaign.EcomailStatsConversionsValue__c = stats.conversions_value;
        campaign.EcomailStatsDelivery__c = stats.delivery;
        campaign.EcomailStatsDeliveryRate__c = stats.delivery_rate;
        campaign.EcomailStatsInject__c = stats.inject;
        campaign.EcomailStatsOpen__c = stats.open;
        campaign.EcomailStatsOpenRate__c = stats.open_rate;
        campaign.EcomailStatsSpam__c = stats.spam;
        campaign.EcomailStatsSpamRate__c = stats.spam_rate;
        campaign.EcomailStatsTotalClick__c = stats.total_click;
        campaign.EcomailStatsTotalOpen__c = stats.total_open;
        campaign.EcomailStatsUnsub__c = stats.unsub;
        campaign.EcomailStatsUnsubRate__c = stats.unsub_rate;
        return campaign;
    }

    private List<Contact> getContactsFromCampaignMembers(List<CampaignMember> campaignMembers) {
        List<Contact> contacts = new List<Contact>();

        for (CampaignMember each : campaignMembers) {
            if (each.Type == 'Contact') {
                contacts.add(each.Contact);
            }
        }

        return contacts;
    }

    private List<Lead> getLeadsFromCampaignMembers(List<CampaignMember> campaignMembers) {
        List<Lead> leads = new List<Lead>();

        for (CampaignMember each : campaignMembers) {
            if (each.Type == 'Lead') {
                leads.add(each.Lead);
            }
        }

        return leads;
    }

    private void synchronizeCampaigns(List<Campaign> campaignsToCreate, List<Campaign> campaignsToUpdate ) {
        List<Campaign> updateCampaigns = new List<Campaign>();

        for (Campaign campaign : campaignsToCreate) {
            updateCampaigns.add(this.createCampaign(campaign));
        }

        for (Campaign campaign : campaignsToUpdate) {
            this.updateCampaign(campaign);
        }

        update updateCampaigns;
    }
}