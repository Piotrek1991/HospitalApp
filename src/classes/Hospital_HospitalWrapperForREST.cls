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
//    private String compareBy ='name';

    global Hospital_HospitalWrapperForREST(Hospital__c hospital) {
        hospitalId = hospital.Id;
        name = hospital.Name;
        country = hospital.Country__c;
        city = hospital.City__c;
        postalCode = hospital.PostalCode__c;
        street = hospital.Street__c;
    }

//    global void setCompareBy(String compareFiled){
//        this.compareBy = compareFiled;
//    }

//    global Integer compareTo(Object compareTo) {
////        if( compareBy.equals('name')){
//            Hospital_HospitalWrapperForREST compareToHospital = (Hospital_HospitalWrapperForREST)compareTo;
//            if (name == compareToHospital.name) return 0;
//            if (name > compareToHospital.name) return 1;
//            return -1;
////        }
//        else if( compareBy.equals('country')){
//            Hospital_HospitalWrapperForREST compareToHospital = (Hospital_HospitalWrapperForREST)compareTo;
//            if (country == compareToHospital.country) return 0;
//            if (country > compareToHospital.country) return 1;
//            return -1;
//        }
//        else {
//            Hospital_HospitalWrapperForREST compareToHospital = (Hospital_HospitalWrapperForREST)compareTo;
//            if (city == compareToHospital.city) return 0;
//            if (city > compareToHospital.city) return 1;
//            return -1;
//        }

}