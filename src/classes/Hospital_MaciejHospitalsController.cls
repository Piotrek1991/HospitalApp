/**
 * Created by BRITENET on 06.01.2019.
 */

public with sharing class Hospital_MaciejHospitalsController {

    public String endPoint = 'https://eu16.salesforce.com/services/apexrest/Hospital__c/';
    public List<Hospital_HospitalWrapperForREST> hospitalsFromMaciej { get; set; }
    public Hospital__c hospitalSearchData { get; set; }
    public Hospital__c hospitalCreateData { get; set; }
    public Boolean isAnyProblemWithCallout { get; set; }
    public String messageSuccessToast { get; set; }
    public String messageErrorToast { get; set; }
    public Boolean isAnyInsertProblem { get; set; }
    public Boolean isAnyUpdateProblem { get; set; }
    public String hospitalToEditId { get; set; }

    public Hospital_MaciejHospitalsController() {
        hospitalsFromMaciej = new List<Hospital_HospitalWrapperForREST>();
        hospitalSearchData = new Hospital__c();
        hospitalCreateData = new Hospital__c();
        isAnyProblemWithCallout = false;
        isAnyInsertProblem = true;
        isAnyUpdateProblem = true;
    }

    public void searchHospitals() {
        hospitalsFromMaciej = new List<Hospital_HospitalWrapperForREST>();
        hospitalsFromMaciej = getHospitalCallout(hospitalSearchData.Name, hospitalSearchData.City__c, hospitalSearchData.Country__c);
    }

    public List<Hospital_HospitalWrapperForREST> getHospitalCallout(String queryName, String queryCity, String queryCountry) {
        Http http = new Http();
        String query = generateQueryForgetHospitalCallout(queryName, queryCity, queryCountry);
        HttpRequest request = getRequest('GET', query, '');
        HttpResponse response = http.send(request);

        List<Hospital_HospitalWrapperForREST> hospitalList = (List<Hospital_HospitalWrapperForREST>) JSON.deserializeStrict(response.getBody(), List<Hospital_HospitalWrapperForREST>.class);
        return hospitalList;
    }

    public HttpRequest getRequest(String methodType, String urlParams, String body) {
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endPoint + urlParams);
        request.setHeader('Authorization', 'Bearer ' + loginToMaciejClinic());
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setMethod(methodType);
        if (body != '') {
            request.setBody(body);
        }
        return request;
    }

    private String generateQueryForgetHospitalCallout(String queryName, String queryCity, String queryCountry) {
        String query = '?';
        if (String.isNotBlank(queryName)) {
            query += 'Name=' + queryName + '&';
        }
        if (String.isNotBlank(queryCity)) {
            query += 'City__c=' + queryCity + '&';
        }
        if (String.isNotBlank(queryCountry)) {
            query += 'Country__c=' + queryCountry;
        }
        query = query.replaceAll(' ', '%20');
        return query;
    }

    public void deleteHospital() {
        clearMessages();
        try {
            List<Hospital_HospitalWrapperForREST> deletedHospitals = deleteHospitalCallout(hospitalToEditId);
            isAnyProblemWithCallout = false;
            messageSuccessToast = Label.Hospital_successfully_deleted;
        } catch (Exception e) {
            isAnyProblemWithCallout = true;
            messageErrorToast = Label.Unable_to_delete_hospital;
        }
        List<Hospital_HospitalWrapperForREST> tempHospitals = new List<Hospital_HospitalWrapperForREST>();
        for (Hospital_HospitalWrapperForREST hospital : hospitalsFromMaciej) {
            if (hospital.hospitalId != hospitalToEditId) {
                tempHospitals.add(hospital);
            }
        }
        hospitalsFromMaciej.clear();
        hospitalsFromMaciej.addAll(tempHospitals);
    }

    public List<Hospital_HospitalWrapperForREST> deleteHospitalCallout(String hospitalToDeleteId) {
        Http http = new Http();
        HttpRequest request = getRequest('DELETE', hospitalToDeleteId, '');
        HttpResponse response = http.send(request);
        List<Hospital_HospitalWrapperForREST> hospitalList = (List<Hospital_HospitalWrapperForREST>) JSON.deserializeStrict(response.getBody(), List<Hospital_HospitalWrapperForREST>.class);
        return hospitalList;
    }

    public void insertHospital() {
        clearMessages();
        try {
            List<Hospital_HospitalWrapperForREST> insertedHospitals = insertHospitalCallout(hospitalCreateData);
            isAnyInsertProblem = false;
            if (String.isBlank(hospitalCreateData.Id)) {
                messageSuccessToast = Label.Hospital_successfully_added;
            } else {
                messageSuccessToast = Label.Hospital_successfully_updated;
            }
            refreshResultsList(insertedHospitals);
        } catch (Exception e) {
            isAnyInsertProblem = true;
            messageErrorToast = Label.Unable_to_add_hospital;
            System.debug('Is Any Insert Problem >>' + e);
        }
        if (!Test.isRunningTest()) {
            searchHospitals();
        }
        clearHireModalWindow();
    }

    public List<Hospital_HospitalWrapperForREST> insertHospitalCallout(Hospital__c hospital) {
        String body = JSON.serialize(new Hospital_HospitalWrapperForREST(hospital), true);
        body = '{ "hospitals"  : [ ' + body + ' ] }';
        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', body);
        HttpResponse response = http.send(request);
        List<Hospital_HospitalWrapperForREST> hospitalList = (List<Hospital_HospitalWrapperForREST>) JSON.deserializeStrict(response.getBody(), List<Hospital_HospitalWrapperForREST>.class);
        return hospitalList;
    }

    public void openHospitalToEdit() {
        resetHospitalToUpdate();
        for (Hospital_HospitalWrapperForREST hosp : hospitalsFromMaciej) {
            if (hosp.hospitalId.equals(hospitalToEditId)) {
                hospitalCreateData.Id = hosp.hospitalId;
                hospitalCreateData.Name = hosp.name;
                hospitalCreateData.City__c = hosp.city;
                hospitalCreateData.Country__c = hosp.country;
                break;
            }
        }
    }

    public void resetHospitalToUpdate() {
        clearMessages();
        isAnyUpdateProblem = true;
    }

    private void refreshResultsList(List<Hospital_HospitalWrapperForREST> hospitals) {
        if (!hospitals.isEmpty()
                && (String.isNotBlank(hospitalSearchData.Name)
                || String.isNotBlank(hospitalSearchData.City__c)
                || String.isNotBlank(hospitalSearchData.Country__c))) {
            hospitalToEditId = hospitals.get(0).hospitalId;
            searchHospitals();
        }
    }

    private String loginToMaciejClinic() {
        try {
            Hospital_partnerSoapSforceCom.Soap partnerSoap = new Hospital_partnerSoapSforceCom.Soap();
            Hospital_partnerSoapSforceCom.LoginResult loginResult = partnerSoap.login('piotrtoporowski@britenet.com.pl', 'britenet1wjaReYZjITIwqooeZr1ZHHsY');
            return loginResult.sessionId;
        } catch (Exception ex) {
            System.debug('Login To Maciejs Clinic Exception >> ' + ex.getMessage());
            return null;
        }
    }

    public void clearMessages() {
        ApexPages.getMessages().clear();
    }

    public void clearFieldsAndResultHospitals() {
        clearMessages();
        hospitalCreateData = new Hospital__c();
        isAnyInsertProblem = true;
        clearHireModalWindow();
        hospitalToEditId ='';
    }

    public void clearHireModalWindow() {
        clearMessages();
        hospitalCreateData = new Hospital__c();
    }
}



