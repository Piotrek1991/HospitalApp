/**
 * Created by BRITENET on 17.12.2018.
 */

public with sharing class Hospital_DoctorHireControll {
    public Hospital__c hospital { get; set; }
    public List<Hospital__c> hospitals { get; set; }
    public String currentDoctorId { get; set; }
    public String selectedHospitalId { get; set; }
    public Contract__c contract { get; set; }
    public List<Wrapper> wrappers { get; set; }

    public Hospital_DoctorHireControll() {
        hospital = new Hospital__c(Name = '');
        contract = new Contract__c();
        hospitals = new List<Hospital__c>();
    }

    public void searchHospitals() {
        String query = Hospital_Utils.generateHireDoctorHospitalsQuery(hospital);

        if (String.isNotBlank(query)) {
            hospitals = Database.query(query);
        } else {
            hospitals = new List<Hospital__c>();
        }

        setWrappersEmpty();

        for (Hospital__c h : hospitals) {
            wrappers.add(new Wrapper(h));
        }
    }

    public void clearSearchForm() {
        hospital = new Hospital__c(Name = '');
    }

    public Doctor__c getDoctor() {
        return [SELECT Id, FirstNameLastName__c FROM Doctor__c WHERE Id = :currentDoctorId];
    }

    public Hospital__c getSelectedHospital() {
        System.debug(selectedHospitalId);

        if (String.isNotBlank(selectedHospitalId)) {
            return [SELECT Id, Name FROM Hospital__c WHERE Id = :selectedHospitalId];
        } else {
            return new Hospital__c(Name = '');
        }
    }

    public void hireDoctor() {
        Contract__c contractToInsert = new Contract__c(Doctor_Id__c = currentDoctorId, Hospital_Id__c = selectedHospitalId, Start_Date__c = contract.Start_Date__c, End_Date__c = contract.End_Date__c);
        insert contractToInsert;
    }

    public void cancel() {
        setFieldsEmpty();
    }

    public Class Wrapper {
        public String hospitalId { get; set; }
        public String hospitalName { get; set; }
        public String hospitalCountry { get; set; }
        public String hospitalCity { get; set; }
        public Boolean isSelected { get; set; }

        public Wrapper(Hospital__c hosp) {
            hospitalId = hosp.Id;
            hospitalCountry = hosp.Country__c;
            hospitalName = hosp.Name;
            hospitalCity = hosp.City__c;
            isSelected = false;
        }
    }

    public void changeSelect() {
        for (Wrapper w : wrappers) {
            if (w.hospitalId == selectedHospitalId) {
                w.isSelected = true;
            } else {
                w.isSelected = false;
            }
        }
    }

    private void setWrappersEmpty() {
        wrappers = new List<Wrapper>();
    }

    private void setContractEmpty() {
        contract = new Contract__c();
    }

    private void setFieldsEmpty() {
        selectedHospitalId = '';
        currentDoctorId = '';

        setWrappersEmpty();
        hospital = new Hospital__c(Name = '');
        hospitals = new List<Hospital__c>();
        setContractEmpty();
    }
}