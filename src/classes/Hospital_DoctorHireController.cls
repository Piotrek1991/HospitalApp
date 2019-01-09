/**
 * Created by BRITENET on 17.12.2018.
 */

public with sharing class Hospital_DoctorHireController {
    public Hospital__c hospital { get; set; }
    public List<Hospital__c> hospitals { get; set; }
    public String currentDoctorId { get; set; }
    public String selectedHospitalId { get; set; }

    public Hospital_DoctorHireController() {
        hospital = new Hospital__c(Name = '', Website__c = '', Parent_Hospital__c = '', Street__c = '', PostalCode__c = '', City__c = '', Country__c = '');
        hospitals = new List<Hospital__c>();
    }

    public void searchHospitals() {
        String query = 'SELECT Id, Name, Country__c, City__c, Website__c FROM Hospital__c WHERE Name LIKE \'' + hospital.Name + '%\'';
        //String query = 'SELECT Id, Name, Country__c, City__c, WWW__c FROM Hospital__c WHERE Name LIKE \'' + hospital.Name + '%\' OR Country__c LIKE \'' + hospital.Country__c + '%\' OR WWW__c LIKE ' + hospital.WWW__c + '%\'';

        hospitals = Database.query(query);
    }

    public void clearSearchForm() {
        hospital = new Hospital__c(Name = '', Website__c = '', Parent_Hospital__c = '', Street__c = '', PostalCode__c = '', City__c = '', Country__c = '');
    }

    public Doctor__c getDoctor() {
        return [SELECT Id, Name, FirstNameLastName__c FROM Doctor__c WHERE Id = :currentDoctorId];
    }

    public Hospital__c getSelectedHospital() {
        System.debug(selectedHospitalId);

        if (String.isNotBlank(selectedHospitalId)) {
            return [SELECT Id, Name FROM Hospital__c WHERE Id = :selectedHospitalId];
        } else {
            return new Hospital__c(Name = '', Website__c = '', Parent_Hospital__c = '', Street__c = '', PostalCode__c = '', City__c = '', Country__c = '');
        }
    }

    public void hireDoctor() {

    }

    public void cancel() {

    }
}