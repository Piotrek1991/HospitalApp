/**
 * Created by BRITENET on 10.01.2019.
 */

public class Hospital_HospitalTriggerHandler {
    public static String endPoint = 'https://eu16.salesforce.com/services/apexrest/Hospital__c/';

    @future(Callout=true)
    public static void sendHospitalData(Set<Id> hospitalsIds) {
//        System.debug('hospitalsIds' + hospitalsIds);
//
//        List<Hospital__c> hospitals = [SELECT Id, External_Id__c, Name, City__c, Country__c, Website__c, Street__c, PostalCode__c FROM Hospital__c WHERE Id IN :hospitalsIds];
//        List<Hosp_HospitalWrapper> hospitalsInWrapper = new List<Hosp_HospitalWrapper>();
//        for (Hospital__c hospital : hospitals) {
//            hospitalsInWrapper.add(new Hosp_HospitalWrapper(hospital));
//        }
//        String body = '{ "hospitals"  : ' + JSON.serialize(hospitalsInWrapper) + ' }';
//        System.debug('First Body' + body);
//
//        Http http = new Http();
//        HttpRequest request = getRequest('PUT', '', body);
//        HttpResponse response = http.send(request);
//        System.debug('response' + response.getStatusCode());
    }

    @future(Callout=true)
    public static void assignIdToExternalID(Set<Id> hospitalsIds) {
//        List<Hospital__c> hospitals = [SELECT Id, External_Id__c, Name, City__c, Country__c, Website__c, Street__c, PostalCode__c FROM Hospital__c WHERE External_Id__c IN :hospitalsIds];
//        List<Hosp_HospitalWrapper> hospitalsInWrapper = new List<Hosp_HospitalWrapper>();
//        for (Hospital__c hospital : hospitals) {
//            hospitalsInWrapper.add(new Hosp_HospitalWrapper(hospital));
//        }
//        String body = '{ "hospitals"  : ' + JSON.serialize(hospitalsInWrapper) + ' }';
//        System.debug('Second body' + body);
//
//        Http http = new Http();
//        HttpRequest request = getRequest('PUT', '', body);
//        HttpResponse response = http.send(request);
//        System.debug('response' + response.getStatusCode());
    }

    @future(Callout=true)
    public static void deleteHospitalData(Set<Id> hospitalsIds) {
//        System.debug('hospitalsIds=' + hospitalsIds);
//        String hospitalToDeleteId;
//        for (String hospId : hospitalsIds) {
//            hospitalToDeleteId = hospId.substring(0,15);
//            break;
//        }
//
//
//        System.debug('hospitalToDeleteId=' + hospitalToDeleteId);
//        Http http = new Http();
//        HttpRequest request = getRequest('DELETE', hospitalToDeleteId, '');
//        HttpResponse response = http.send(request);
//        System.debug('response=' + response.getStatusCode());
    }


    public static HttpRequest getRequest(String methodType, String urlParams, String body) {
//        HttpRequest request = new HttpRequest();
//        request.setEndPoint(endPoint + urlParams);
//        request.setHeader('Authorization', 'Bearer ' + Hospital_Utils.loginToSecondOrgGetSessionId());
//        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
//        request.setMethod(methodType);
//        if (body != '') {
//            request.setBody(body);
//        }
//        return request;
        return null;
    }

    private class Hosp_HospitalWrapper {
//        public String hospitalId { get; set; }
//        public String externalId { get; set; }
//        public String name { get; set; }
//        public String country { get; set; }
//        public String city { get; set; }
//        public String postalCode { get; set; }
//        public String street { get; set; }
//        public Hosp_HospitalWrapper(Hospital__c hospital) {
//            hospitalId = String.valueOf(hospital.Id).substring(0,15);
//            externalId = hospital.External_Id__c;
//            name = hospital.Name;
//            country = hospital.Country__c;
//            city = hospital.City__c;
//            postalCode = hospital.PostalCode__c;
//            street = hospital.Street__c;
//        }
    }


}