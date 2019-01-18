/**
 * Created by BRITENET on 16.01.2019.
 */

global class Hospital_HospitalBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    public static String endPoint = 'https://eu16.salesforce.com/services/apexrest/Hospital__c/';
    private String statusSuccess = '200';
    List<String> errorList = new List<String>();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, External_Id__c, DateTime__c, Status__c, OperationType__c, Request__c, ' +
                'Respond__c FROM LogsFromWebService__c';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<LogsFromWebService__c> logRecords) {
        List<Hospital_HospitalWrapperForREST> hospitalFromRespond = new List<Hospital_HospitalWrapperForREST>();
        List<Hospital_HospitalWrapperForREST> hospitalWithFail = new List<Hospital_HospitalWrapperForREST>();
        List<Hospital_HospitalWrapperForREST> hospitalWithFailUnique = new List<Hospital_HospitalWrapperForREST>();
        List<LogsFromWebService__c> logsToDelete = new List<LogsFromWebService__c>();

        for (LogsFromWebService__c log : logRecords) {
            String oneRespond = log.Respond__c;
            hospitalFromRespond.addAll((List<Hospital_HospitalWrapperForREST>) JSON.deserialize(oneRespond, List<Hospital_HospitalWrapperForREST>.class));
        }
        System.debug('hospitalFromRespond' + hospitalFromRespond);

        for(Hospital_HospitalWrapperForREST hospital:hospitalFromRespond){
            if(!hospital.status){
                hospitalWithFail.add(hospital);
                hospital.status = true;
            }
        }
        hospitalWithFailUnique = getUniqueValues(hospitalWithFail);
        String body = '{ "hospitals"  : ' + JSON.serialize(hospitalWithFailUnique) + ' }';

        HttpResponse response = sendHosp(body);
        List<Hospital_HospitalWrapperForREST> hospitalAfterSend =((List<Hospital_HospitalWrapperForREST>) JSON.deserialize(response.getBody(), List<Hospital_HospitalWrapperForREST>.class));
        System.debug('hospitalAfterSend' + hospitalAfterSend);

        for(Hospital_HospitalWrapperForREST hospital:hospitalAfterSend){
            if(!hospital.status){
                errorList.add('Record id: ' + hospital.externalId + ' Hospital name: ' + hospital.name);
            }
        }
        System.debug('errorList' + errorList);
    }

    private List<Hospital_HospitalWrapperForREST> getUniqueValues(List<Hospital_HospitalWrapperForREST> records) {
        Map<String, Hospital_HospitalWrapperForREST> uniqueValues = new Map<String, Hospital_HospitalWrapperForREST>();
        for(Hospital_HospitalWrapperForREST record: records) {
            if(!uniqueValues.containsKey(record.externalId)) {
                uniqueValues.put(record.externalId, record);
            }
        }
        return uniqueValues.values();
    }

    public HttpResponse sendHosp(String hospitalsJson) {
        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', hospitalsJson);

        HttpResponse response = http.send(request);
        LogsFromWebService__c logsFromWebService = new LogsFromWebService__c(DateTime__c =Datetime.now(), OperationType__c ='Send hospital',
                Status__c=String.valueOf(response.getStatusCode()), Request__c = request.getBody(), Respond__c = response.getBody());
        System.debug('logsFromWebService' + logsFromWebService);
        insert logsFromWebService;
        return response;
    }

    public HttpRequest getRequest(String methodType, String urlParams, String body) {
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

    global void finish(Database.BatchableContext bc) {
        Hospital_Utils.sendEmailToSystemAdmin(errorList);
    }
}