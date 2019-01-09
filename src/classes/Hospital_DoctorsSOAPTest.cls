/**
 * Created by BRITENET on 03.01.2019.
 */

@isTest
private class Hospital_DoctorsSOAPTest {

    @testSetup
    static void setup() {
        List<Doctor__c> testDoctors = new List<Doctor__c>();

        for (Integer i = 1; i <= 2; i++) {
            testDoctors.add(new Doctor__c(Last_Name__c = 'doctorLastName' + i,
                    First_Name__c = 'doctorFirstName' + i,
                    City__c = 'doctorCity',
                    Country__c = 'AU'));
        }
        insert testDoctors;
    }

    @isTest
    static void shouldGetDoctorsWithAllParameters() {
        //given
        String lastName = 'doctorLastName';
        String firstName = 'doctorFirstName';
        String city = 'doctorCity';
        String country = 'AU';
        //when
        List<Hospital_DoctorWrapperForSOAP> listDoctor = Hospital_DoctorsSOAP.getDoctors(firstName, lastName, city, country);
        //then
        System.assertEquals(2, listDoctor.size());
    }

    @isTest
    static void shouldNotGetDoctorsWithoutParameters() {
        //given
        String lastName = '1';
        String firstName = '';
        String city = '';
        String country = '';
        //when
        List<Hospital_DoctorWrapperForSOAP> listDoctor = Hospital_DoctorsSOAP.getDoctors(firstName, lastName, city, country);
        //then
        System.assertEquals(0, listDoctor.size());
    }

    @isTest
    static void shouldNotGetDoctorsWithNotExistsName() {
        //given
        String lastName = 'doctorLastName3';
        String firstName = '';
        String city = '';
        String country = '';
        //when
        List<Hospital_DoctorWrapperForSOAP> listDoctor = Hospital_DoctorsSOAP.getDoctors(firstName, lastName, city, country);
        //then
        System.assertEquals(0, listDoctor.size());
    }

    @isTest
    static void shouldDeleteDoctorsWithId() {
        //given
        List<Doctor__c> doctors = [SELECT Id,First_Name__c, Last_Name__c, Country__c, City__c FROM Doctor__c WHERE Last_Name__c LIKE 'doctorLastName%'];
        List<String> doctorsIds = new List<String>();
        for (Doctor__c d : doctors) {
            doctorsIds.add(d.Id);
        }
        //when
        List<Hospital_DoctorWrapperForSOAP> results = Hospital_DoctorsSOAP.deleteDoctors(doctorsIds);
        //then
        System.assertEquals(2, results.size());
    }

    @isTest
    static void shouldNotDeleteDoctorsWhichNotHaveId() {
        //given
        List<Doctor__c> doctors = [SELECT Id,First_Name__c, Last_Name__c, Country__c, City__c FROM Doctor__c WHERE Last_Name__c LIKE 'doctorLastName3'];
        List<String> doctorsIds = new List<String>();
        for (Doctor__c doc : doctors) {
            doctorsIds.add(doc.Id);
        }
        //when
        List<Hospital_DoctorWrapperForSOAP> results = Hospital_DoctorsSOAP.deleteDoctors(doctorsIds);
        //then
        System.assertEquals(0, results.size());
    }

    @isTest
    static void shouldUpsertDoctorWhichAreExists() {
        //given
        List<Doctor__c> doctors = [SELECT Id,First_Name__c, Last_Name__c, Country__c, City__c FROM Doctor__c WHERE Last_Name__c LIKE 'doctorLastName1'];
        String lastNameAfterChange = 'doctorLastNameAfterUpsert';
        String firstNameAfterChange = 'doctorFirstNameAfterUpsert';
        //when
        Hospital_DoctorWrapperForSOAP result;
        if (!doctors.isEmpty()) {
            result = Hospital_DoctorsSOAP.upsertDoctor(doctors.get(0).Id, firstNameAfterChange, lastNameAfterChange, doctors.get(0).City__c, doctors.get(0).Country__c);
        }
        //then
        System.assertEquals(lastNameAfterChange, result.webServiceDoctorLastName);
    }

    @isTest
    static void shouldNotUpsertDoctorWhichNotExists() {
        //given
        List<Doctor__c> doctors = [SELECT Id,First_Name__c, Last_Name__c, Country__c, City__c FROM Doctor__c WHERE Last_Name__c LIKE 'doctorLastName5'];
        String lastNameAfterChange = 'doctorLastNameAfterChange';
        String firstNameAfterChange = 'doctorFirstNameAfterChange';
        //when
        Hospital_DoctorWrapperForSOAP result;
        if (!doctors.isEmpty()) {
            result = Hospital_DoctorsSOAP.upsertDoctor(doctors.get(0).Id, firstNameAfterChange, lastNameAfterChange, doctors.get(0).City__c, doctors.get(0).Country__c);
        }
        //then
        System.assertEquals(0, doctors.size());
    }

    @isTest
    static void shouldUpsertDoctor_Insert() {
        //given
        String lastName = 'TestDoctorName4';
        String firstName = 'TestDoctorFirstName4';
        String city = 'City4';
        String country = 'AU';
        //when
        Hospital_DoctorWrapperForSOAP result;
        if (String.isNotBlank(lastName) && String.isNotBlank(firstName)) {
            result = Hospital_DoctorsSOAP.upsertDoctor('', firstName, lastName, city, country);
        }
        //then
        System.assertNotEquals(null, result.webServiceDoctorId);
    }

    @isTest
    static void shouldNotUpsertDoctorBecauseDoctorDoesNotHaveRequiredFields() {
        //given
        String lastName;
        String firstName;
        String city = 'City4';
        String country = 'AU';
        //when
        Hospital_DoctorWrapperForSOAP result;
        if (String.isNotBlank(lastName) && String.isNotBlank(firstName)) {
            result = Hospital_DoctorsSOAP.upsertDoctor('', firstName, lastName, city, country);
        }
        //then
        System.assertEquals(null, result);
    }
}