/**
 * Created by BRITENET on 07.01.2019.
 */

@isTest
global with sharing class Hospital_MaciejDoctorsMock implements WebServiceMock {
    public String returnResult='';

    public void selectMethod(String givenMethod){
        if(givenMethod.equals('GETDOCTOR')){
            returnResult='GETDOCTOR';
        }
        if(givenMethod.equals('INSERTDOCTOR')){
            returnResult='INSERTDOCTOR';
        }
        if(givenMethod.equals('UPDATEDOCTOR')){
            returnResult='UPDATEDOCTOR';
        }
        if(givenMethod.equals('DELETEDOCTOR')){
            returnResult='DELETEDOCTOR';
        }
    }

    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {

        Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap oneDoctor = new Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap();
        oneDoctor.doctorId = 'id';
        oneDoctor.name = 'lastName';
        oneDoctor.firstName = 'firstName';
        oneDoctor.country = 'country';
        oneDoctor.city = 'city';
        List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap> listDoctor = new List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap>();
        listDoctor.add(oneDoctor);

        if (returnResult.equals('GETDOCTOR')) {
        Hosp_MaciejSoapForDoctorsWebService.getDoctorsResponse_element responseGetElement = new Hosp_MaciejSoapForDoctorsWebService.getDoctorsResponse_element();
            responseGetElement.result = listDoctor;
        response.put('response_x', responseGetElement);
        }
        if (returnResult.equals('DELETEDOCTOR')) {
            Hosp_MaciejSoapForDoctorsWebService.deleteDoctorsResponse_element responseDeleteElement = new Hosp_MaciejSoapForDoctorsWebService.deleteDoctorsResponse_element();
            responseDeleteElement.result = listDoctor;
            response.put('response_x', responseDeleteElement);
        }
        if (returnResult.equals('UPDATEDOCTOR')) {
            Hosp_MaciejSoapForDoctorsWebService.upsertDoctorResponse_element responseInsertElement = new Hosp_MaciejSoapForDoctorsWebService.upsertDoctorResponse_element();
            oneDoctor.firstName = 'firstNameAfterUpdate';
            responseInsertElement.result = oneDoctor;
            response.put('response_x', responseInsertElement);
        }
        if (returnResult.equals('INSERTDOCTOR')) {
            oneDoctor.doctorId = null;
            Hosp_MaciejSoapForDoctorsWebService.upsertDoctorResponse_element responseInsertElement = new Hosp_MaciejSoapForDoctorsWebService.upsertDoctorResponse_element();
            responseInsertElement.result = oneDoctor;
            response.put('response_x', responseInsertElement);
        }
    }
}