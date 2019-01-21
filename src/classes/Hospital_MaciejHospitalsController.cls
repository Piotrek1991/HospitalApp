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
    public List<Hospital_HospitalComparator.HospitalWrapper> sortedHospital { get; set; }

    public Boolean sortAsc { get; set; }
    public String showSortByNameSignAsc { get; set; }
    public String showSortByNameSignDesc { get; set; }
    public String showSortByCitySignAsc { get; set; }
    public String showSortByCitySignDesc { get; set; }
    public String showSortByCountrySignAsc { get; set; }
    public String showSortByCountrySignDesc { get; set; }

    public Hospital_MaciejHospitalsController() {
        hospitalsFromMaciej = new List<Hospital_HospitalWrapperForREST>();
        hospitalSearchData = new Hospital__c();
        hospitalCreateData = new Hospital__c();
        isAnyProblemWithCallout = false;
        isAnyInsertProblem = true;
        isAnyUpdateProblem = true;
        sortedHospital = new List<Hospital_HospitalComparator.HospitalWrapper>();
        sortAsc = true;
        hideAllSortOrderSigns();
    }

    public void searchHospitals() {
        hospitalsFromMaciej = new List<Hospital_HospitalWrapperForREST>();
        hospitalsFromMaciej = getHospitalCallout(hospitalSearchData.Name, hospitalSearchData.City__c, hospitalSearchData.Country__c);
        sortByName();
        System.debug('hospitalsFromMaciej >> ' + hospitalsFromMaciej);

    }

    public List<Hospital_HospitalWrapperForREST> getHospitalCallout(String queryName, String queryCity, String queryCountry) {
        try {
            Http http = new Http();
            String query = generateQueryForgetHospitalCallout(queryName, queryCity, queryCountry);
            HttpRequest request = getRequest('GET', query, '');
            HttpResponse response = http.send(request);
            System.debug('Status Code --> ' + response.getStatusCode());
            System.debug('response.getBody() --> ' + response.getBody());
            List<Hospital_HospitalWrapperForREST> hospitalList = (List<Hospital_HospitalWrapperForREST>) JSON.deserialize(response.getBody(), List<Hospital_HospitalWrapperForREST>.class);
            System.debug('hospitalList --> ' + hospitalList);
            return hospitalList;
        } catch (Exception ex) {
            Hospital_Utils.addToErrors(ex, 'Hospital_MaciejHospitalsController');
            System.debug('ex --> ' + ex.getMessage());
        }
        return null;
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
        System.debug('hospitalToEditId  >>' + hospitalToEditId);
        try {
            List<Hospital_HospitalWrapperForREST> deletedHospitals = deleteHospitalCallout(hospitalToEditId);
            isAnyProblemWithCallout = false;
            messageSuccessToast = Label.Hospital_successfully_deleted;
        } catch (Exception e) {
            Hospital_Utils.addToErrors(e, 'Hospital_MaciejHospitalsController');
            isAnyProblemWithCallout = true;
            messageErrorToast = Label.Unable_to_delete_hospital;
        }
        System.debug('Method delete, hospitalFromAMciej >>' + hospitalsFromMaciej);
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
        for(Hospital_HospitalWrapperForREST hospTemp :hospitalsFromMaciej){
            if(hospTemp.hospitalId.equals(hospitalToDeleteId)){
                hospitalToDeleteId = hospTemp.externalId;
                break;
            }
        }
        HttpRequest request = getRequest('DELETE', hospitalToDeleteId, '');
        HttpResponse response = http.send(request);
        List<Hospital_HospitalWrapperForREST> hospitalList = (List<Hospital_HospitalWrapperForREST>) JSON.deserialize(response.getBody(), List<Hospital_HospitalWrapperForREST>.class);
        return hospitalList;
    }

    public void insertHospital() {
        clearMessages();
        try {
            List<Hospital_HospitalWrapperForREST> insertedHospitals = insertHospitalCallout(hospitalCreateData);
            if (!Test.isRunningTest()) {

                isAnyInsertProblem = false;
                if (String.isBlank(hospitalCreateData.Id)) {
                    messageSuccessToast = Label.Hospital_successfully_added;
                } else {
                    messageSuccessToast = Label.Hospital_successfully_updated;
                }
            }
            refreshResultsList(insertedHospitals);
        } catch (Exception e) {
            Hospital_Utils.addToErrors(e, 'Hospital_MaciejHospitalsController');
            isAnyInsertProblem = true;
            messageErrorToast = e.getMessage();
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
        System.debug('body >>>>' + body);
        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', body);
        HttpResponse response = http.send(request);
        List<Hospital_HospitalWrapperForREST> hospitalList = (List<Hospital_HospitalWrapperForREST>) JSON.deserialize(response.getBody(), List<Hospital_HospitalWrapperForREST>.class);
        return hospitalList;
    }

    public void openHospitalToEdit() {
        System.debug('hospitalToEditId' + hospitalToEditId);
        resetHospitalToUpdate();
        for (Hospital_HospitalWrapperForREST hosp : hospitalsFromMaciej) {
            if (hosp.hospitalId.equals(hospitalToEditId)) {
                hospitalCreateData.Id = hosp.hospitalId;
                hospitalCreateData.External_Id__c = hosp.externalId;
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
    public static String loginToMaciejClinic() {
        if(!Test.isRunningTest()){
            try {
                Hospital_partnerSoapSforceCom.Soap partnerSoap = new Hospital_partnerSoapSforceCom.Soap();
                Hospital_partnerSoapSforceCom.LoginResult loginResult = partnerSoap.login('piotrtoporowski@britenet.com.pl', 'britenet1wjaReYZjITIwqooeZr1ZHHsY');

                return loginResult.sessionId;
            } catch (Exception ex) {
                Hospital_Utils.addToErrors(ex, 'Hospital_MaciejHospitalsController');

                System.debug('Login To Maciejs Clinic Exception >> ' + ex.getMessage());
                return null;
            }
        }
        return null;
    }

//    private String loginToMaciejClinic() {
//       return Hospital_Utils.loginToFirstOrgGetSessionId();
//    }

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

    public void sortByName() {
        hideAllSortOrderSigns();
        if(sortAsc){
            showSortByNameSignAsc = 'display-block';
            showSortByNameSignDesc = 'none';
        } else {
            showSortByNameSignAsc = 'none';
            showSortByNameSignDesc = 'display-block';
        }
        Hospital_HospitalComparator.compareBy = 'name';
        hospitalsFromMaciej = Hospital_HospitalComparator.sortResults(hospitalsFromMaciej, sortAsc);
        flipSortOrder();
    }
    public void sortByCity() {
        hideAllSortOrderSigns();
        if(sortAsc){
            showSortByCitySignAsc = 'display-block';
            showSortByCitySignDesc = 'none';
        } else {
            showSortByCitySignAsc = 'none';
            showSortByCitySignDesc = 'display-block';
        }
        Hospital_HospitalComparator.compareBy = 'city';
        hospitalsFromMaciej = Hospital_HospitalComparator.sortResults(hospitalsFromMaciej, sortAsc);
        flipSortOrder();
    }
    public void sortByCountry() {
        hideAllSortOrderSigns();
        if(sortAsc){
            showSortByCountrySignAsc = 'display-block';
            showSortByCountrySignDesc = 'none';
        } else {
            showSortByCountrySignAsc = 'none';
            showSortByCountrySignDesc = 'display-block';
        }
        Hospital_HospitalComparator.compareBy = 'country';
        hospitalsFromMaciej = Hospital_HospitalComparator.sortResults(hospitalsFromMaciej, sortAsc);
        flipSortOrder();
    }
    private void flipSortOrder() {
        sortAsc = !sortAsc;
    }
    private void hideAllSortOrderSigns() {
        showSortByNameSignAsc = 'none';
        showSortByNameSignDesc = 'none';
        showSortByCitySignAsc = 'none';
        showSortByCitySignDesc = 'none';
        showSortByCountrySignAsc = 'none';
        showSortByCountrySignDesc = 'none';
    }
}




