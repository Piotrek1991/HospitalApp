/**
 * Created by BRITENET on 08.01.2019.
 */
@isTest
public with sharing class Hospital_MaciejHospitalsControllerTest {
//    @isTest
//    static void shouldGetHospitalsCallout() {
//        //given
//        Map<String, String> header = new Map<String, String>();
//        header.put('sessionId', '');
//        Hospital_MaciejHospitalSingleRequestMock fakeHospitalResp = new Hospital_MaciejHospitalSingleRequestMock(200,
//                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
//                header);
//        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
//        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/?Name=HospitalTest&City__c=Lublin&Country__c=PL', fakeHospitalResp);
//
//        HttpCalloutMock multiCalloutMock =
//                new Hospital_MaciejHospitalsMultiMock(endpoint2TestResp);
//        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
//
//        Hospital_MaciejHospitalsController controller = new Hospital_MaciejHospitalsController();
//        String name = 'HospitalTest';
//        String country = 'PL';
//        String city = 'Lublin';
//
//        Hospital__c hospital = new Hospital__c(Name = name, City__c = city, Country__c = country);
//        controller.hospitalSearchData = hospital;
//        List<Hospital_HospitalWrapperForREST> hospitals = new List<Hospital_HospitalWrapperForREST>();
//        //when
//        controller.searchHospitals();
//        hospitals.addAll(controller.hospitalsFromMaciej);
//        //then
//        System.assertEquals('HospitalTest', hospitals.get(0).name);
//    }

//    @isTest
//    static void shouldUpsertHospitalsCallout() {
//        //given
//        Map<String, String> header = new Map<String, String>();
//        header.put('sessionId', '');
//
//        Hospital_MaciejHospitalSingleRequestMock fakeHospitalDelete = new Hospital_MaciejHospitalSingleRequestMock(200,
//                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
//                header);
//
//
//        Hospital_MaciejHospitalSingleRequestMock fakeHospitalResp = new Hospital_MaciejHospitalSingleRequestMock(200,
//                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
//                header);
//        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
//        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/', fakeHospitalResp);
//        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/?Name=HospitalTest&City__c=Lublin&Country__c=PL', fakeHospitalDelete);
//
//        HttpCalloutMock multiCalloutMock =
//                new Hospital_MaciejHospitalsMultiMock(endpoint2TestResp);
//        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
//        Hospital_MaciejHospitalsController controller = new Hospital_MaciejHospitalsController();
//        String name = 'HospitalTest';
//        String country = 'PL';
//        String city = 'Lublin';
//        Hospital__c hospital = new Hospital__c(Name = name, City__c = city, Country__c = country);
//        controller.hospitalCreateData = hospital;
//        //when
//        controller.insertHospital();
//        //then
//        System.assertEquals(false, controller.isAnyInsertProblem);
//
//    }
//    @isTest
//    static void shouldDeleteHospitalsCallout() {
//        //given
//        Map<String, String> header = new Map<String, String>();
//        header.put('sessionId', '');
//        Hospital_MaciejHospitalSingleRequestMock fakeHospitalResp = new Hospital_MaciejHospitalSingleRequestMock(200,
//                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
//                header);
//        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
//        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/deletedId', fakeHospitalResp);
//        HttpCalloutMock multiCalloutMock = new Hospital_MaciejHospitalsMultiMock(endpoint2TestResp);
//        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
//
//        Hospital_MaciejHospitalsController controller = new Hospital_MaciejHospitalsController();
//        String id = 'deletedId';
//        String name = 'HospitalTest';
//        String country = 'PL';
//        String city = 'Lublin';
//        Hospital__c hospital = new Hospital__c(Name = name, City__c = city, Country__c = country);
//        controller.hospitalsFromMaciej.add(new Hospital_HospitalWrapperForREST(hospital));
//        controller.hospitalToEditId = id;
//        //when
//        controller.deleteHospital();
//        //then
//        System.assertEquals(false, controller.isAnyProblemWithCallout);
//    }

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