/**
 * Created by BRITENET on 02.01.2019.
 */

global class Hospital_HospitalWrapperForREST{

    webService String hospitalId { get; set; }
    webService String name { get; set; }
    webService String country { get; set; }
    webService String city { get; set; }
    webService String postalCode { get; set; }
    webService String street { get; set; }

    global Hospital_HospitalWrapperForREST(Hospital__c hospital) {
        hospitalId = hospital.Id;
        name = hospital.Name;
        country = hospital.Country__c;
        city = hospital.City__c;
        postalCode = hospital.PostalCode__c;
        street = hospital.Street__c;
    }

    global Hospital_HospitalWrapperForREST() {
    }
}