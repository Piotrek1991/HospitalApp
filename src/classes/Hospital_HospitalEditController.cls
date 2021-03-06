/**
 * Created by BRITENET on 14.01.2019.
 */

public with sharing class Hospital_HospitalEditController {
    ApexPages.StandardController standardController;
    public String hospitalIdCurrent { get; set; }
    public Hospital_HospitalEditController(ApexPages.StandardController standardController) {
        this.standardController = standardController;
        hospitalIdCurrent = standardController.getRecord().Id;
    }

    public void deleteAll(){
        List<Hospital__c> hospitals = [SELECT Id, Name FROM Hospital__c];
        System.debug('UserInfo.getUserId()'+ UserInfo.getUserId());
        delete hospitals;
    }

    public PageReference saveHospital() {
        Hospital__c hospital = (Hospital__c) standardController.getRecord();
        List<Hospital__c> hospitals = [SELECT Id, Name FROM Hospital__c WHERE Id = :hospital.Id];
        if (hospitals.isEmpty()) {
            hospital = new Hospital__c(
                    Name = hospital.Name,
                    Website__c = hospital.Website__c,
                    City__c = hospital.City__c,
                    Country__c = hospital.Country__c,
                    PostalCode__c = hospital.PostalCode__c,
                    Street__c = hospital.Street__c,
//                    Master_Unit__c = hospital.Master_Unit__c,
                    //todo - zlepek
                    External_Id__c = hospital.Name + hospital.City__c + hospital.Country__c + hospital.Street__c);
            insert hospital;
        } else {
            update hospital;
        }
        return new ApexPages.StandardController(hospital).view();
    }

    public List<SelectOption> getMasterUnits() {
        List<SelectOption> options = new List<SelectOption>();
        for(Hospital__c hosp : [SELECT Id, Name FROM Hospital__c WHERE Id <> :hospitalIdCurrent]) {
            options.add(new SelectOption(hosp.Id, hosp.Name));
        }
        options.add(new SelectOption('', 'None_Option'));
        options.sort();
        return options;
    }
}