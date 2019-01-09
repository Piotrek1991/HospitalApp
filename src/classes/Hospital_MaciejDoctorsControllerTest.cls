/**
 * Created by BRITENET on 07.01.2019.
 */

@isTest
public with sharing class Hospital_MaciejDoctorsControllerTest {

    @isTest
    static void shouldGetDoctorsCalloutTest() {
        //given
        Hospital_MaciejDoctorsMock mock = new Hospital_MaciejDoctorsMock();
        mock.selectMethod('GETDOCTOR');
        Test.setMock(WebServiceMock.class, mock);

        Hospital_MaciejDoctorsController controller = new Hospital_MaciejDoctorsController();
        Doctor__c oneDoctor = new Doctor__c();
        oneDoctor.Last_Name__c = 'lastName';
        oneDoctor.First_Name__c = 'firstName';
        oneDoctor.Country__c = 'country';
        oneDoctor.City__c = 'city';
        controller.doctorSearchData = oneDoctor;
        List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap> doctors = new List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap>();
        //when
        controller.searchDoctors();
        doctors = controller.doctorsFromMaciej;
        //then
        System.assertEquals('firstName', doctors.get(0).firstName);
    }

    @isTest
    static void shouldDeleteDoctorsFromMaciej() {
        //given
        Hospital_MaciejDoctorsMock mock = new Hospital_MaciejDoctorsMock();
        mock.selectMethod('DELETEDOCTOR');
        Test.setMock(WebServiceMock.class, mock);

        Hospital_MaciejDoctorsController controller = new Hospital_MaciejDoctorsController();
        Doctor__c oneDoctor = new Doctor__c();
        oneDoctor.Last_Name__c = 'lastName';
        oneDoctor.First_Name__c = 'firstName';
        oneDoctor.Country__c = 'country';
        oneDoctor.City__c = 'city';
        controller.doctorSearchData = oneDoctor;
        List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap> doctors = new List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap>();
        //when
        controller.deleteDoctors();
        doctors = controller.deletedDoctorsToTest;
        //then
        System.assertEquals(1, doctors.size());
    }
    @isTest
    static void shouldInsertDoctorsFromMaciej() {
        //given
        Hospital_MaciejDoctorsMock mock = new Hospital_MaciejDoctorsMock();
        mock.selectMethod('INSERTDOCTOR');
        Test.setMock(WebServiceMock.class, mock);

        Hospital_MaciejDoctorsController controller = new Hospital_MaciejDoctorsController();
        Doctor__c oneDoctor = new Doctor__c();
        oneDoctor.Last_Name__c = 'lastName';
        oneDoctor.First_Name__c = 'firstName';
        oneDoctor.Country__c = 'country';
        oneDoctor.City__c = 'city';
        controller.doctorCreateData = oneDoctor;
        //when
        controller.upsertDoctors();
        //then
        System.assertEquals('firstName', controller.doctorToTest.firstName);
    }
    @isTest
    static void shouldUpdateDoctorsFromMaciej() {
        //given
        Hospital_MaciejDoctorsMock mock = new Hospital_MaciejDoctorsMock();
        mock.selectMethod('UPDATEDOCTOR');
        Test.setMock(WebServiceMock.class, mock);

        Hospital_MaciejDoctorsController controller = new Hospital_MaciejDoctorsController();
        Doctor__c oneDoctor = new Doctor__c();
        oneDoctor.Last_Name__c = 'lastName';
        oneDoctor.First_Name__c = 'firstNameAfterUpdate';
        oneDoctor.Country__c = 'country';
        oneDoctor.City__c = 'city';
        controller.doctorCreateData = oneDoctor;
        //when
        controller.upsertDoctors();
        //then
        System.assertEquals('firstNameAfterUpdate', controller.doctorToTest.firstName);
    }

    @isTest
    static void shouldUpdateDoctorData() {
        //given
        Hospital_MaciejDoctorsController controller = new Hospital_MaciejDoctorsController();
        Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap oneDoctor = new Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap();
        oneDoctor.doctorId = 'doctorId';
        oneDoctor.name = 'lastName';
        oneDoctor.firstName = 'firstNameAfterUpdate';
        oneDoctor.country = 'country';
        oneDoctor.city = 'city';
        List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap> doctors = new List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap>();
        doctors.add(oneDoctor);
        controller.doctorsFromMaciej = doctors;
        controller.selectedDoctorId = 'doctorId';
        Doctor__c doctorCreate = new Doctor__c(First_Name__c = 'firstNameAfterUpdate', Last_Name__c = 'lastName',
                Country__c = 'country', City__c = 'city');
        controller.doctorCreateData = doctorCreate;
        //when
        controller.upsertDoctorData();
        //then
        System.assertEquals('firstNameAfterUpdate', controller.doctorsFromMaciej.get(0).firstName);
    }

    @isTest
    static void shouldClearFields() {
        //given
        Hospital_MaciejDoctorsController controller = new Hospital_MaciejDoctorsController();
        Doctor__c doctorCreate = new Doctor__c(First_Name__c = 'firstNameAfterUpdate', Last_Name__c = 'lastName',
                Country__c = 'country', City__c = 'city');
        controller.doctorCreateData = doctorCreate;
        controller.isAnyProblemWithCallout = false;
        //when
        controller.clearFieldsAndResultDoctors();
        //then
        System.assertEquals(null, controller.doctorCreateData.City__c);
        System.assertEquals(true, controller.isAnyProblemWithCallout);
    }
}