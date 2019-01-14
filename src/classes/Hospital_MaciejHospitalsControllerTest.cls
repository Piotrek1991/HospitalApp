/**
 * Created by BRITENET on 08.01.2019.
 */
@isTest
public with sharing class Hospital_MaciejHospitalsControllerTest {

    @isTest
    static void shouldInsertAndGetHospitalsCallout() {
        //given
        Map<String, String> header = new Map<String, String>();
        header.put('sessionId', '');

        Hospital_MaciejHospitalSingleRequestMock fakeHospitalInsert = new Hospital_MaciejHospitalSingleRequestMock(200,
                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);

        Hospital_MaciejHospitalSingleRequestMock fakeHospitalGet = new Hospital_MaciejHospitalSingleRequestMock(200,
                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/', fakeHospitalInsert);
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/?Name=HospitalTest&City__c=Lublin&Country__c=PL', fakeHospitalGet);

        HttpCalloutMock multiCalloutMock =
                new Hospital_MaciejHospitalsMultiMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Hospital_MaciejHospitalsController controller = new Hospital_MaciejHospitalsController();
        String name = 'HospitalTest';
        String country = 'PL';
        String city = 'Lublin';
        Hospital__c hospital = new Hospital__c(Name = name, City__c = city, Country__c = country);
        controller.hospitalCreateData = hospital;
        controller.hospitalSearchData = hospital;
        //when
        controller.insertHospital();
        controller.searchHospitals();
        //then
        System.assertEquals(1, controller.hospitalsFromMaciej.size());
    }

    @isTest
    static void shouldDeleteHospitalsCallout() {
        //given
        Map<String, String> header = new Map<String, String>();
        header.put('sessionId', '');

        Hospital_MaciejHospitalSingleRequestMock fakeHospitalRespond = new Hospital_MaciejHospitalSingleRequestMock(200,
                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/', fakeHospitalRespond);
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/?Name=HospitalTest&City__c=Lublin&Country__c=PL', fakeHospitalRespond);
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/deleteId', fakeHospitalRespond);

        HttpCalloutMock multiCalloutMock =
                new Hospital_MaciejHospitalsMultiMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Hospital_MaciejHospitalsController controller = new Hospital_MaciejHospitalsController();
        String id = 'deleteId';
        String name = 'HospitalTest';
        String country = 'PL';
        String city = 'Lublin';
        Hospital__c hospital = new Hospital__c(Name = name, City__c = city, Country__c = country);
        controller.hospitalCreateData = hospital;
        controller.hospitalSearchData = hospital;
        controller.hospitalToEditId = id;
        //when
        controller.insertHospital();
        controller.searchHospitals();
        controller.hospitalToEditId = id;
        controller.deleteHospital();
        //then
        System.assertEquals(1, controller.hospitalsFromMaciej.size());
    }
}