/**
 * Created by BRITENET on 10.01.2019.
 */

public class Hospital_HospitalTriggerHandler implements ITrigger{
    public static String endPoint = 'https://eu16.salesforce.com/services/apexrest/Hospital__c/';

    public void beforeInsert(List<Hospital__c> hospitals){
        Boolean isExecuted = false;
        while (!isExecuted) {
            List<Hospital_HospitalWrapperForREST> hospitalsInWrapper = new List<Hospital_HospitalWrapperForREST>();
            for (Hospital__c hosp : hospitals) {
                Hospital_HospitalWrapperForREST hospToSend = new Hospital_HospitalWrapperForREST(hosp);
                hospToSend.status = true;
                hospitalsInWrapper.add(hospToSend);
            }
            String body = '{ "hospitals"  : ' + JSON.serialize(hospitalsInWrapper) + ' }';
            Hospital_HospitalTriggerHandler.sendHosp(body);
            isExecuted = true;
        }
    }

    public void beforeUpdate(List<Hospital__c> hospitals){
        Boolean isExecuted = false;
        while (!isExecuted) {
            List<Hospital_HospitalWrapperForREST> hospitalsInWrapper = new List<Hospital_HospitalWrapperForREST>();
            for (Hospital__c hosp : hospitals) {
                Hospital_HospitalWrapperForREST hospToSend = new Hospital_HospitalWrapperForREST(hosp);
                hospToSend.status = true;
                hospitalsInWrapper.add(hospToSend);
            }
            String body = '{ "hospitals"  : ' + JSON.serialize(hospitalsInWrapper) + ' }';
            Hospital_HospitalTriggerHandler.sendHosp(body);
            isExecuted = true;
        }
    }

    public void beforeDelete(List<Hospital__c> hospitalMap){
        Boolean isExecuted = false;
        while (!isExecuted) {
            List<String> hospitalsIds = new List<String>();
            for (Hospital__c hosp : hospitalMap) {
                hospitalsIds.add(hosp.External_Id__c);
            }
            Hospital_HospitalTriggerHandler.deleteHospitalData(hospitalsIds);
            isExecuted = true;
        }
    }

    public void afterInsert(List<Hospital__c> hospitals){

    }

    public void afterUpdate(List<Hospital__c> hospitals){

    }

    public void afterDelete(List<Hospital__c> hospitals){

    }

    @future(Callout=true)
    public static void sendHosp(String hospitalsJson) {
        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', hospitalsJson);

        HttpResponse response = http.send(request);
        LogsFromWebService__c logsFromWebService = new LogsFromWebService__c(DateTime__c =Datetime.now(), OperationType__c ='Send hospital',
        Status__c=String.valueOf(response.getStatusCode()), Request__c = request.getBody(), Respond__c = response.getBody());
        System.debug('logsFromWebService' + logsFromWebService);
        insert logsFromWebService;
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

        LogsFromWebService__c logsFromWebService = new LogsFromWebService__c(DateTime__c =Datetime.now(), OperationType__c ='Delete hospital',
        Status__c=String.valueOf(response.getStatusCode()), Request__c = request.getBody(), Respond__c = response.getBody());
        insert logsFromWebService;
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