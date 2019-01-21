/**
 * Created by BRITENET on 10.01.2019.
 */

public class Hospital_HospitalTriggerHandler implements ITrigger {

    public static String endPoint = 'https://eu16.salesforce.com/services/apexrest/Hospital__c/';

    public void beforeInsert(List<Hospital__c> hospitals) {
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

    public void beforeUpdate(List<Hospital__c> hospitals) {
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

    public void beforeDelete(List<Hospital__c> hospitalMap) {
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

    public void afterInsert(List<Hospital__c> hospitals) {

    }

    public void afterUpdate(List<Hospital__c> hospitals) {

    }

    public void afterDelete(List<Hospital__c> hospitals) {

    }

    @future(Callout=true)
    public static void sendHosp(String hospitalsJson) {
        List<LogsWebService__c> logsToInsert = new List<LogsWebService__c>();

        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', hospitalsJson);
        HttpResponse response = http.send(request);

        List<Hospital_HospitalWrapperForREST> hospitalAfterSend = ((List<Hospital_HospitalWrapperForREST>) JSON.deserialize(response.getBody(), List<Hospital_HospitalWrapperForREST>.class));

//        for (Hospital_HospitalWrapperForREST hospital : hospitalAfterSend) {
//            logsToInsert.add(new LogsWebService__c(External_Id__c = hospital.externalId, DateTime__c = Datetime.now(),
//                    OperationType__c = 'Send hospital', ParentHospital_Id__c = hospital.hospitalId, Status__c = hospital.status));
//        }
        System.debug('logsToInsert' + logsToInsert);
        insert logsToInsert;

        LogsFromWebService__c logsFromWebService = new LogsFromWebService__c(DateTime__c = Datetime.now(), OperationType__c = 'Send hospital',
                Status__c = String.valueOf(response.getStatusCode()), Request__c = request.getBody(), Respond__c = response.getBody());
        System.debug('logsFromWebService' + logsFromWebService);
        insert logsFromWebService;
    }

    @future(Callout=true)
    public static void deleteHospitalData(List<String> hospitalsIds) {
        String hospitalToDeleteId;
        for (String hospId : hospitalsIds) {
            hospitalToDeleteId = hospId;
            break;
        }
        Http http = new Http();
        HttpRequest request = getRequest('DELETE', hospitalToDeleteId, '');
        HttpResponse response = http.send(request);

        List<Hospital_HospitalWrapperForREST> hospitalAfterSend = ((List<Hospital_HospitalWrapperForREST>) JSON.deserialize(response.getBody(), List<Hospital_HospitalWrapperForREST>.class));
        List<LogsWebService__c> logsToInsert = new List<LogsWebService__c>();

//        for (Hospital_HospitalWrapperForREST hospital : hospitalAfterSend) {
//            logsToInsert.add(new LogsWebService__c(External_Id__c = hospital.externalId, DateTime__c = Datetime.now(),
//                    OperationType__c = 'Delete hospital', ParentHospital_Id__c = hospital.hospitalId, Status__c = hospital.status));
//        }
//        insert logsToInsert;


        LogsFromWebService__c logsFromWebService = new LogsFromWebService__c(DateTime__c = Datetime.now(), OperationType__c = 'Delete hospital',
                Status__c = String.valueOf(response.getStatusCode()), Request__c = request.getBody(), Respond__c = response.getBody());
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
}