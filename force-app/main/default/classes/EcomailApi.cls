public without sharing class EcomailApi {
    /**
     * @description Creates new list and returns its id
     * @param  name List name
     * @return      Id of created list
     */
    public Integer addNewList(String name) {
        HttpResponse response = this.sendRequest('lists', 'GET', '{"name": "'+ name + '"}');
        AddNewListResponse newList = (AddNewListResponse) JSON.deserialize(response.getBody(), AddNewListResponse.class);
        return newList.id;
    }   

    /**
     * @description Get all contact lists
     * @return   return contact lists
     */
    public List<GetListsRecordResponse> getAllLists() {
        
        HttpResponse response = this.sendRequest('lists', 'GET', null);
        List<GetListsRecordResponse> listRecords = (List<GetListsRecordResponse>)JSON.deserialize(response.getBody(), List<GetListsRecordResponse>.class);
        return listRecords;
    }

    private Subscriber makeSubscriber(SObject contact) {
        Subscriber subscriber = new Subscriber();
        subscriber.email = (String) contact.get('Email');
        subscriber.name = (String) contact.get('FirstName');
        subscriber.surname = (String) contact.get('LastName');
        subscriber.phone = (String) contact.get('Phone');

        Address address;

        Map<String, String> customFields;
        
        if (((Id) contact.get('Id')).getSobjectType().getDescribe().getName() == 'Contact') {
            customFields = EcomailQueryBuilder.getContactSfdcToEcomailCustomFields();
            address = (Address) contact.get('MailingAddress');
        } else {
            customFields = EcomailQueryBuilder.getLeadSfdcToEcomailCustomFields();
            address = (Address) contact.get('Address');
        }

        if (address != null) {
            subscriber.street = address.getStreet();
            subscriber.city = address.getCity();
            subscriber.zip = address.getPostalCode();
            subscriber.country = address.getCountry();
        }
        
        subscriber.custom_fields = new Map<String, Object>();
        
        // fill custom fields

        for (String sfdcField : customFields.keySet()) {
            Object val = contact.get(sfdcField);
            subscriber.custom_fields.put(customFields.get(sfdcField), (Object) val);
            System.debug('hem ' + customFields.get(sfdcField));
        }

        return subscriber;
    }

    /**
     * @description Add new subscriber to list
     * @param listId Id of list where to add subscriber
     * @param contact Contact to add
     * @return Id of new subscriber
     */
    public Integer addSubscriber(Decimal listId, SObject contact) {
        Subscriber subscriber = makeSubscriber(contact);

        String serializedSubscriber = JSON.serialize(subscriber);
        String body = '{"update_existing": true, "subscriber_data": ' + serializedSubscriber + '}';

        HttpResponse response = this.sendRequest('lists/' + listId + '/subscribe', 'POST', body);
        OnlyIdResponse idResponse = (OnlyIdResponse) JSON.deserialize(response.getBody(), OnlyIdResponse.class);
        return IdResponse.id;
    }

    /**
     * @description Add new 
     * @param  listId   Id of list where subscribers will be added
     * @param  contacts Contacts to add
     * @return          Number of addded subscibers or error
     */
    public Boolean addSubscriberBulk(Decimal listId, SObject[] contacts) {
        Subscriber[] subscribers = new List<Subscriber>();

        if (contacts.isEmpty()) {
            return null;
        }
        
        // workaround. Firstly call simple add-subscribe endpoint to create custom field definitions on list
        addSubscriber(listId, contacts[0]);

        for (SObject contact : contacts) {
            Subscriber subscriber = makeSubscriber(contact);
            subscribers.add(subscriber);
        }

        for (List<Subscriber> lstSubscribers : chunkSubscribers(subscribers)) {
            String serializedSubscribers = JSON.serialize(lstSubscribers);
            String body = '{"update_existing": true, "subscriber_data": ' + serializedSubscribers + '}';
    
            HttpResponse response = this.sendRequest('lists/' + listId + '/subscribe-bulk', 'POST', body);
            AddSubsriberBulkResponse result = (AddSubsriberBulkResponse) JSON.deserialize(response.getBody(), AddSubsriberBulkResponse.class);
        }
       
        return true;
    }
    
    public List<Subscriber> getSubscribers(String listId) {
        HttpResponse response = this.sendRequest('lists/' + listId, 'GET', null);
        List<Subscriber> listRecords = (List<Subscriber>)JSON.deserialize(response.getBody(), List<Subscriber>.class);
        return listRecords;
    }

    public EcomailCampaignStats getCampaignStats(Decimal campaignId) {
        HttpResponse response = this.sendRequest('campaigns/' + (Integer) campaignId + '/stats', 'GET', null);
        EcomailCampaignStatsResponse deserializedResponse = (EcomailCampaignStatsResponse)JSON.deserialize(response.getBody(), EcomailCampaignStatsResponse.class);
        return deserializedResponse.stats;
    }

    public Integer addNewCampaign(String title, List<Integer> listIds) {
        EcomailSetting__mdt settings = EcomailCustomMetadataUtils.getSettings();


        String campaignTitle = 'SFDC - ' + title;
        String body = '{"title": "' + campaignTitle + '",'
        + '"from_name": "' + settings.FromName__c + '",'
        + '"from_email": "' + settings.FromEmail__c + '",'
        + '"reply_to": "' + settings.ReplyToEmail__c + '",'        
        + '"subject": "Replacce this subject",'        
        + '"html_text": "Replace this content",'
        + '"recepient_lists": ' + JSON.serialize(listIds)
        + '}';

        HttpResponse response = this.sendRequest('campaigns', 'POST', body);
        OnlyIdResponse deserializedResponse = (OnlyIdResponse) JSON.deserialize(response.getBody(), OnlyIdResponse.class);
        return deserializedResponse.id;
    }

    public HttpResponse sendRequest(String endpoint, String method, String body) {
        EcomailSetting__mdt settings = EcomailCustomMetadataUtils.getSettings();
        String apiKey = settings.APIKey__c;
        String baseUrl = 'callout:Ecomail/';
    
        Http http = new Http();

        HttpRequest request = new HttpRequest();

        request.setHeader('key', apiKey);
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(baseUrl + endpoint);
        if (body != null) {
            request.setBody(body);
        }
        request.setMethod(method);

        HttpResponse response = http.send(request);
        return response;
    }

    /**
     * @description Chunkify subscribers. Bulk add API can handle max 3000 subscribers in one request
     * @param  subscribers List of subsribers to chunkify
     * @return             Chunkified list of subscribers
     */ 
    private List<List<Subscriber>> chunkSubscribers(List<Subscriber> subscribers) {
        Integer chunkSize = 3000;
        List<Subscriber> tempList;
        List<List<Subscriber>> wrapperList = new List<List<Subscriber>>();

        for(Integer i = 0 ; i < (subscribers.size() / chunkSize)+1 ; i++){
            tempList = new List<Subscriber>();
            for(Integer j=(i*200);(j<(i*200)+200) && j<subscribers.size() ; j++){
                tempList.add(subscribers.get(j));
            }
            wrapperList.add(tempList);
        }

        return wrapperList;
    }

    // ---------- CLASSESS ------------
    public class OnlyIdResponse {
        Integer id;
    }

    public class AddNewListResponse {   
        String name;
        Integer id;
    }

    public class AddSubsriberBulkRequest {   
        List<Subscriber> subscriber_data;
        Boolean update_existing;
    }

    public class AddSubsriberBulkResponse {   
        Integer inserts;
        Object errors;
    }

    public class GetListsRecordResponse {
        String id;
        String name;
    }

    public class Subscriber {
        String email;
        String name;
        String surname;
        String company;
        String street;
        String city;
        String country;
        String zip;
        String phone;

        List<EcomailList> lists;
        Map<String, Object> custom_fields;
    }

    public class EcomailCampaignStatsResponse {
        public EcomaiLCampaignStats stats;
    }

    public class EcomailCampaignStats {
        public Integer inject;
        public Integer delivery;
        public Integer delivery_rate;
        public Integer open;
        public Integer total_open;
        public Integer open_rate;
        public Integer click;
        public Integer total_click;
        public Integer click_rate;
        public Integer bounce;
        public Integer bounce_rate;
        public Integer unsub;
        public Integer unsub_rate;
        public Integer spam;
        public Integer spam_rate;
        public Integer conversions;
        public Integer conversions_value;
    }

    public class EcomailList {

    }
    public class GetSubscriber {

    }
}