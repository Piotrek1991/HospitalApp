/**
 * Created by BRITENET on 06.01.2019.
 */
@isTest
private class Hospital_MaciejDoctorsCalloutTest {

    @isTest
    static void shouldGetDoctorsCalloutTest(){
        //given
        String firstNameDoctor = 'firstName';
        String lastNameDoctor = 'lastName';
        String countryDoctor = 'country';
        String cityDoctor = 'city';
        Hosp_MaciejSoapForDoctorsWebService.Hosp_SoapForDoctorsWebService doctorsService = new Hosp_MaciejSoapForDoctorsWebService.Hosp_SoapForDoctorsWebService();
        Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap oneDoctor =
                new Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap();
        oneDoctor.name = lastNameDoctor;
        oneDoctor.firstName = firstNameDoctor;
        oneDoctor.country = countryDoctor;
        oneDoctor.city = cityDoctor;
        Hospital_MaciejDoctorsMock mock = new Hospital_MaciejDoctorsMock();
        mock.selectMethod('GETDOCTOR');
        Test.setMock(WebServiceMock.class, mock);
        //when
        List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap> listToResult = doctorsService.getDoctors( lastNameDoctor, firstNameDoctor, cityDoctor, countryDoctor);
        //then
        System.assertEquals('id', listToResult.get(0).doctorId);
    }

    @isTest
    static void shouldDeleteDoctorsCalloutTest() {
        //given
        Hospital_MaciejDoctorsMock mock = new Hospital_MaciejDoctorsMock();
        mock.selectMethod('DELETEDOCTOR');
        Test.setMock(WebServiceMock.class, mock);
        Hosp_MaciejSoapForDoctorsWebService.Hosp_SoapForDoctorsWebService doctorsService = new Hosp_MaciejSoapForDoctorsWebService.Hosp_SoapForDoctorsWebService();
        //when
        List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap> deleteDoctor = doctorsService.deleteDoctors(new List<String>{'deleteDoctorId'});
        //then
        System.assertEquals('id', deleteDoctor.get(0).doctorId);
    }


    @isTest
    static void shouldInsertDoctorsCalloutTest() {
        //given
        String doctorId;
        String firstNameDoctor = 'firstName';
        String lastNameDoctor = 'lastName';
        String countryDoctor = 'country';
        String cityDoctor = 'city';
        Hospital_MaciejDoctorsMock mock = new Hospital_MaciejDoctorsMock();
        mock.selectMethod('INSERTDOCTOR');
        Test.setMock(WebServiceMock.class, mock);
        Hosp_MaciejSoapForDoctorsWebService.Hosp_SoapForDoctorsWebService doctorsService = new Hosp_MaciejSoapForDoctorsWebService.Hosp_SoapForDoctorsWebService();
        //when
        Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap doctorToInsert =
                doctorsService.upsertDoctor(doctorId,firstNameDoctor,lastNameDoctor,countryDoctor,cityDoctor);
        //then
        System.assertEquals(null, doctorToInsert.doctorId);
    }

    @isTest
    static void shouldUpdateDoctorsCalloutTest() {
        //given
        String doctorId ='id';
        String firstNameDoctor = 'firstName';
        String lastNameDoctor = 'lastName';
        String countryDoctor = 'country';
        String cityDoctor = 'city';
        Hospital_MaciejDoctorsMock mock = new Hospital_MaciejDoctorsMock();
        mock.selectMethod('UPDATEDOCTOR');
        Test.setMock(WebServiceMock.class, mock);
        Hosp_MaciejSoapForDoctorsWebService.Hosp_SoapForDoctorsWebService doctorsService = new Hosp_MaciejSoapForDoctorsWebService.Hosp_SoapForDoctorsWebService();
        //when
        Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap deleteDoctor =
                doctorsService.upsertDoctor(doctorId,firstNameDoctor,lastNameDoctor,countryDoctor,cityDoctor);
        //then
        System.assertEquals('id', deleteDoctor.doctorId);
    }
}