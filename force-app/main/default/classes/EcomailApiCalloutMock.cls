public class EcomailApiCalloutMock implements HttpCalloutMock{
    private String type; 

    public EcomailApiCalloutMock() {
        this.type = 'bulk_insert';
    }

    public EcomailApiCalloutMock(String type) {
        this.type = type;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        
        response.setHeader('Content-Type', 'json/application');
        response.setStatusCode(200);
        String body;

        switch on this.type {
            when 'bulk_insert' {
                body = '{"inserts": 1}';
            }
            when 'campaign_stats' {
                body = '{ "stats": { "inject": 0, "delivery": 0,"delivery_rate": 0,"open": 0,"total_open": 0, "open_rate": 0,"click": 0, "total_click": 0,"click_rate": 0,"bounce": 0,"bounce_rate": 0,"unsub": 0,"unsub_rate": 0,"spam": 0,"spam_rate": 0,"conversions": 0,"conversions_value": 0}}';
            }
            when else {
                body = '{}';
            }
        }
        response.setBody(body);

        return response;
    }
}