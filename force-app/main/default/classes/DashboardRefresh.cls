public with sharing class DashboardRefresh {
    @AuraEnabled
    public static String refreshDataSync(){
        try{
        	String connection = 'SFDC_LOCAL';
            String baseUrl = 'https://compliancequest16-dev-ed.develop.lightning.force.com';
        	String url= baseUrl+'/services/data/60.0/sobjects/InsightsExternalData/0FbdM0000003waXSAQ/actions/refresh'; 
 			// Create a HTTP request to trigger the data sync
         	HttpRequest req = new HttpRequest();
         	req.setEndpoint(url);
         	req.setMethod('POST');
         	req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
         	req.setHeader('Content-Type', 'application/json');
 			Http http = new Http();
        	HTTPResponse res = http.send(req);

            if (res.getStatusCode() == 200 || res.getStatusCode() == 202) {
                System.debug('Data sync request successfull. ' + res.getBody());
                return 'Data sync triggered successfully.';
            } else {
                System.debug('Failed to trigger data sync. Status: ' + res.getStatusCode() + ', Response: ' + res.getBody());
                throw new AuraHandledException('Error triggering data sync: ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            throw new AuraHandledException('Error triggering data sync: ' + e.getMessage());
        }
        
    }

}