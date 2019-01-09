/**
 * Created by BRITENET on 13.12.2018.
 */

public with sharing class Hospital_DoctorViewPageController {
    private Doctor__c doctor { get; set; }
    public Contract__c contract { get; set; }
    public List<Contract__c> contracts;
    public String selectedContractId { get; set; }
    private Date dateNow = date.today();
    private String sortOrder = 'Name';
    private String currentAsc = ' ASC';
    private final String ascending = ' ASC';
    private final String descending = ' DESC';
    public String doctorId { get; set; }
    public String renderingService { get; set; }
    public String recordId = doctorId;
    public String pageReferenceUrl;
    public Boolean hasAvatar { get; set; }
    public Attachment avatarSRC { get; set; }
    public Boolean printToPDF { get; set; }
    public Hospital__c hospital { get; set; }
    public List<Hospital__c> hospitals { get; set; }
    public String currentDoctorId { get; set; }
    public String selectedHospitalId { get; set; }
    public List<Wrapper> wrappers { get; set; }
    public Boolean isSuccess { get; set; }
    public Boolean runModalWindow { get; set; }

    public Hospital_DoctorViewPageController(ApexPages.StandardController standardController) {
        doctorId = standardController.getRecord().Id;
        getContracts();
        List<Attachment> savedPicture = [SELECT Id, name, body FROM Attachment WHERE parentId = :doctorId AND name = :Label.Hospital_DefaultPicture];
        if (savedPicture.size() > 0) {
            hasAvatar = true;
            avatarSrc = savedPicture[0];
        }
        isSuccess = false;
        currentDoctorId = doctorId;
        renderingService = '';
        contract = new Contract__c();
        hospital = new Hospital__c(Name = '');
        hospitals = new List<Hospital__c>();
        printToPDF = true;
    }

    public List<Contract__c> getContracts() {
        contracts = [SELECT Id, Name, Start_Date__c, End_Date__c, Email__c, Doctor_Id__c FROM Contract__c WHERE Doctor_Id__c = :doctorId];
        return contracts;
    }

    public void setRunModalWindow() {
        runModalWindow = true;
    }

    public void removeContract() {
        Contract__c selectedContract = null;
        for (Contract__c oneContract : contracts)
            if (oneContract.Id == selectedContractId) {
                selectedContract = oneContract;
                break;
            }

        if (selectedContract.Start_Date__c <= dateNow && selectedContract.End_Date__c >= dateNow) {
            selectedContract.End_Date__c = dateNow;
            selectedContract.IsFinished__c = true;
            upsert selectedContract;
            return;
        }

        if (selectedContract.Start_Date__c > dateNow) {
            delete selectedContract;
        }
    }

    public void sortByEndDay() {
        currentAsc = ascending;
        this.sortOrder = 'End_Date__c';
        getContracts();
        replaceAscending();
    }

    public void sortByEmail() {
        currentAsc = ascending;
        this.sortOrder = 'Email__c';
        getContracts();
        replaceAscending();
    }

    public void sortByStartDay() {
        currentAsc = ascending;
        this.sortOrder = 'Start_Date__c';
        getContracts();
        replaceAscending();
    }

    public void sortByName() {
        currentAsc = ascending;
        this.sortOrder = 'Name';
        getContracts();
        replaceAscending();
    }

    private void replaceAscending() {
        if (ascending.equals(currentAsc)) {
            currentAsc = descending;
        } else {
            currentAsc = ascending;
        }
    }

    public PageReference changeRecordPicture() {
        PageReference cropImagePage = Page.Hospital_DoctorProfileImage;
        cropImagePage.getParameters().put('recordId', doctorId);
        cropImagePage.getParameters().put('pageReferenceURL', ApexPages.currentPage().getUrl());
        cropImagePage.setRedirect(true);

        return cropImagePage;
    }

    public void getAvatarSRC() {
        avatarSRC = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :recordId];
    }

    public PageReference exportToPDF() {
        printToPDF = false;
        renderingService = 'PDF';
        PageReference pageReference = Page.Hospital_DoctorViewExportToPDFHandler;
        pageReference.setRedirect(false);
        return pageReference;
    }

    public void deletePicture() {
        List<Attachment> savedPicture = [SELECT Id, name, body FROM Attachment WHERE parentId = :doctorId AND name = :Label.Hospital_DefaultPicture];
        if (savedPicture.size() > 0) {
            delete savedPicture;
        }
        hasAvatar = false;
    }

    public void searchHospitals() {
        String query = Hospital_Utils.generateHireDoctorHospitalsQuery(hospital);
        System.debug(query);
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
        selectedHospitalId = '';
        hospitals.clear();
    }

    public Doctor__c getDoctor() {
        return [SELECT Id, Name, FirstNameLastName__c FROM Doctor__c WHERE Id = :currentDoctorId];
    }

    public Hospital__c getSelectedHospital() {
        System.debug('Error hospital' + selectedHospitalId);

        if (String.isNotBlank(selectedHospitalId)) {
            return [SELECT Id, Name FROM Hospital__c WHERE Id = :selectedHospitalId];
        } else {
            return new Hospital__c(Name = '');
        }
    }


    public void hireDoctor() {
        Contract__c contractToInsert = new Contract__c(Doctor_Id__c = currentDoctorId, Hospital_Id__c = selectedHospitalId, Start_Date__c = contract.Start_Date__c, End_Date__c = contract.End_Date__c);
        try {
            insert contractToInsert;
            isSuccess = true;

        } catch (DmlException ex) {
            isSuccess = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDmlMessage(0)));
        }
    }

    public void cancel() {
        ApexPages.getMessages().clear();
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
            System.debug('wrapper' + w);
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

        setWrappersEmpty();
        hospital = new Hospital__c(Name = '');
        hospitals = new List<Hospital__c>();
        setContractEmpty();
    }

    public void clearFieldsAndResult(){
        hospital = new Hospital__c(Name = '');
        setFieldsEmpty();
    }
}