/**
 * Created by BRITENET on 10.01.2019.
 */

public class Hospital_HospitalTriggerHandler {
    public static String endPoint = 'https://eu16.salesforce.com/services/apexrest/Hospital__c/';

    @future(Callout=true)
    public static void sendHospitalData(Set<Id> hospitalsIds){
        System.debug('hospitalsIds' + hospitalsIds);

        List<Hospital__c> hospitals = [SELECT Id,External_Id__c, Name, City__c, Country__c, Website__c, Street__c, PostalCode__c FROM Hospital__c WHERE Id IN :hospitalsIds];
        List<Hosp_HospitalWrapper> hospitalsInWrapper = new List<Hosp_HospitalWrapper>();
        for (Hospital__c hospital : hospitals) {
            hospital.External_Id__c = hospital.Name + hospital.City__c + hospital.Country__c + hospital.Street__c;
            hospitalsInWrapper.add(new Hosp_HospitalWrapper(hospital));
        }
        String body = '{ "hospitals"  : ' + JSON.serialize(hospitalsInWrapper) + ' }';
        System.debug('body' + body);
        System.debug('aaaaaaaaaaaaaaa');
        System.debug('loginToOriginalOrgGetSessionId >> ' + Hospital_Utils.loginToSecondOrgGetSessionId());

        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', body);
        HttpResponse response = http.send(request);
        System.debug('response' + response.getStatusCode());
        response.getBody();
        System.debug('Respond body >>>> ' + response.getBody());
        List<Hospital_HospitalWrapperForREST> hospFromSecondOrg= (List<Hospital_HospitalWrapperForREST>)JSON.deserialize(response.getBody(), List<Hospital_HospitalWrapperForREST>.class);
        String idFromSecondOrg = hospFromSecondOrg.get(0).hospitalId;
        System.debug('idFromSecondOrg >>>> ' + idFromSecondOrg);
        Hospital__c hospital = hospitals.get(0);
        System.debug('hospital' + hospital);
        hospital.External_Id__c = idFromSecondOrg;
    }

        @future(Callout=true)
    public static void deleteHospitalData(Set<Id> hospitalsIds){
        System.debug('hospitalsIds='+hospitalsIds);
        String hospitalToDeleteId;
        for(String hospId : hospitalsIds) {
            hospitalToDeleteId = hospId;
            break;
        }
        System.debug('hospitalToDeleteId='+hospitalToDeleteId);
        Http http = new Http();
        HttpRequest request = getRequest('DELETE', hospitalToDeleteId, '');
        HttpResponse response = http.send(request);
        System.debug('response='+response.getStatusCode());
    }


    public static HttpRequest getRequest(String methodType, String urlParams, String body) {
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endPoint + urlParams);
        request.setHeader('Authorization', 'Bearer ' + Hospital_Utils.loginToOriginalOrgGetSessionId());
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