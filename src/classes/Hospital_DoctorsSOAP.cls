/**
 * Created by BRITENET on 02.01.2019.
 */

global class Hospital_DoctorsSOAP {

    webService static List<Hospital_DoctorWrapperForSOAP> getDoctors(String firstName, String lastName, String city, String country) {
        List<Doctor__c> doctors = Database.query(getQueryDoctorSearch(firstName, lastName, city, country));
        List<Hospital_DoctorWrapperForSOAP> doctorsWrapperForSOAP = new List<Hospital_DoctorWrapperForSOAP>();

        for (Doctor__c doctor : doctors) {
            doctorsWrapperForSOAP.add(new Hospital_DoctorWrapperForSOAP(doctor));
        }
        return doctorsWrapperForSOAP;
    }

    webService static Hospital_DoctorWrapperForSOAP upsertDoctor(String doctorId, String firstName, String lastName, String city, String country) {
        Doctor__c doctor = new Doctor__c();
        if (String.isNotBlank(doctorId)) {
            doctor = new Doctor__c(Id = doctorId);
        }
        if (String.isNotBlank(firstName)) {
            doctor.First_Name__c = firstName;
        }
        if (String.isNotBlank(lastName)) {
            doctor.Last_Name__c = lastName;
        }
        if (String.isNotBlank(city)) {
            doctor.City__c = city;
        }
        if (String.isNotBlank(country)) {
            doctor.Country__c = country;
        }
        upsert doctor;
        return new Hospital_DoctorWrapperForSOAP(doctor);
    }

    webService static List<Hospital_DoctorWrapperForSOAP> deleteDoctors(List<String> doctorsId) {
        List<Doctor__c> doctorsToRemove = new List<Doctor__c>();
        List<Hospital_DoctorWrapperForSOAP> doctorsWrapperForSOAP = new List<Hospital_DoctorWrapperForSOAP>();

        List<Doctor__c> doctors = [SELECT Id, First_Name__c, Last_Name__c, City__c, Country__c FROM Doctor__c WHERE Id IN :doctorsId];


        for (Doctor__c doctor : doctors) {
            doctorsToRemove.add(doctor);
            doctorsWrapperForSOAP.add(new Hospital_DoctorWrapperForSOAP(doctor));
        }
        delete doctorsToRemove;
        return doctorsWrapperForSOAP;
    }

    static String getQueryDoctorSearch(String firstName, String lastName, String city, String country) {
        Hospital_DoctorQueryBuilder queryBuilder = new Hospital_DoctorQueryBuilder();
        queryBuilder.setSelectColumn('Id,');
        queryBuilder.setSelectColumn('First_Name__c,');
        queryBuilder.setSelectColumn('Last_Name__c,');
        queryBuilder.setSelectColumn('City__c,');
        queryBuilder.setSelectColumn('FirstNameLastName__c,');
        queryBuilder.setSelectColumn('Country__c');
        queryBuilder.setFromColumn('Doctor__c');
        queryBuilder.setLikeTest(lastName, 'Last_Name__c');
        queryBuilder.setLikeTest(firstName, 'First_Name__c');
        queryBuilder.setLikeTest(city, 'City__c');
        queryBuilder.setLikeTest(country, 'Country__c');

        return queryBuilder.buildForTest();
    }
}