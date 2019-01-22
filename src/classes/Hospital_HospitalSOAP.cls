/**
 * Created by BRITENET on 22.01.2019.
 */

global class Hospital_HospitalSOAP {

    webService static Hospital_HospitalWrapperForREST upsertHospital(String hospitalId, String name, String country, String city,
            String postalCode, String street) {
        Hospital__c hospital = new Hospital__c();
        if (String.isNotBlank(hospitalId)) {
            hospital = new Hospital__c(Id = hospitalId);
        }
        if (String.isNotBlank(name)) {
            hospital.Name = name;
        }
        if (String.isNotBlank(country)) {
            hospital.Country__c = country;
        }
        if (String.isNotBlank(city)) {
            hospital.City__c = city;
        }
        if (String.isNotBlank(postalCode)) {
            hospital.PostalCode__c = postalCode;
        }
        if (String.isNotBlank(street)) {
            hospital.Street__c = street;
        }
        upsert hospital;
        return new Hospital_HospitalWrapperForREST(hospital);
    }

    webService static List<Hospital_HospitalWrapperForREST> getHospitals(String hospitalId, String name, String country, String city,
            String postalCode, String street) {
        String query = 'SELECT Id, Name, Country__c, City__c, PostalCode__c, External_Id__c, Street__c FROM Hospital__c';
        List<Hospital__c> hospitals = Database.query(query);
        List<Hospital_HospitalWrapperForREST> hospitalsWrapperForSOAP = new List<Hospital_HospitalWrapperForREST>();

        for (Hospital__c hospital : hospitals) {
            hospitalsWrapperForSOAP.add(new Hospital_HospitalWrapperForREST(hospital));
        }
        return hospitalsWrapperForSOAP;
    }
}