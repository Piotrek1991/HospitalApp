/**
 * Created by BRITENET on 10.01.2019.
 */

public class Hospital_HospitalTriggerHandler {
    public static String endPoint = 'https://eu16.salesforce.com/services/apexrest/Hospital__c/';

    @future(Callout=true)
    public static void sendHosp(String hospitalsJson) {
        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', hospitalsJson);

        HttpResponse response = http.send(request);
    }

    @future(Callout=true)
    public static void deleteHospitalData(List<String> hospitalsIds) {
        System.debug('hospitalsIds=' + hospitalsIds);

        System.debug('hospitals=' + hospitalsIds);
        String hospitalToDeleteId;
        for (String hospId : hospitalsIds) {
            hospitalToDeleteId = hospId;
            break;
        }
        System.debug('hospitalToDeleteId=' + hospitalToDeleteId);
        Http http = new Http();
        HttpRequest request = getRequest('DELETE', hospitalToDeleteId, '');
        HttpResponse response = http.send(request);
        System.debug('response=' + response.getStatusCode());
    }

    public static HttpRequest getRequest(String methodType, String urlParams, String body) {
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endPoint + urlParams);
        request.setHeader('Authorization', 'Bearer ' + Hospital_Utils.loginToSecondOrgGetSessionId());
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setMethod(methodType);
        if (body != '') {
            request.setBody(body);
        }
        return request;
    }

    private class Hosp_HospitalWrapper {
        public String hospitalId { get; set; }
        public String name { get; set; }
        public String country { get; set; }
        public String city { get; set; }
        public String postalCode { get; set; }
        public String street { get; set; }
        public String externalId{ get; set; }

        public Hosp_HospitalWrapper(Hospital__c hospital) {
            hospitalId = hospital.Id;
            name = hospital.Name;
            country = hospital.Country__c;
            city = hospital.City__c;
            postalCode = hospital.PostalCode__c;
            street = hospital.Street__c;
            externalId = hospital.External_Id__c;
        }
    }
}