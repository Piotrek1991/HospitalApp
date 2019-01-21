/**
 * Created by BRITENET on 20.12.2018.
 */

public with sharing class Hospital_ViewController {
    public List<Contract__c> contracts { get; set; }
    public String hospitalIdCurrent { get; set; }
    public static Hospital__c hospitalCurrent { get; set; }
    public String selectedContractId { get; set; }
    private Date dateNow = date.today();
    public Doctor__c doctor { get; set; }
    public List<Doctor__c> doctors { get; set; }
    private String sortOrder = 'Last_Name__c';
    private String currentAsc = ' ASC';
    public List<DoctorWrapper> doctorWrappers { get; set; }
    public String selectedDoctorId { get; set; }
    public String selectedDoctorContractId { get; set; }
    public String selectedDoctorContractEditDateId { get; set; }
    public List<ContractWrapper> contractWrappers { get; set; }
    public Contract__c newHireContract { get; set; }
    public Boolean editStartDateFlag { get; set; }
    public List<Contract__c> contractsToInsert { get; set; }
    public Boolean isEnyErrorInModalWindow { get; set; }
    public Integer doctorPL { get {return selectEmployers('PL');} set; }
    public Integer doctorNL { get {return selectEmployers('NL');} set; }
    public Integer doctorAU { get {return selectEmployers('AU');} set; }
    public Integer doctorUSA { get {return selectEmployers('USA');} set; }
    public String employersPerDay { get; set; }

    public Hospital_ViewController(ApexPages.StandardController standardController) {
        hospitalIdCurrent = standardController.getRecord().Id;
        contracts = new List<Contract__c>();
        getContracts();
        doctor = new Doctor__c();
        doctors = new List<Doctor__c>();
        doctorWrappers = new List<DoctorWrapper>();
        contractWrappers = new List<ContractWrapper>();
        newHireContract = new Contract__c();
        editStartDateFlag = false;
        isEnyErrorInModalWindow = false;
        hospitalCurrent = new Hospital__c();
        getHospital();
        employersPerDay = getEmployersPerDay();
    }

    public String getEmployersPerDay() {
        List<Contract__c> contractsList = [SELECT Id, Start_Date__c, End_Date__c FROM Contract__c];
        Map<Datetime, Integer> elementsToDisplay = new Map<Datetime, Integer>();
        List<String> stringList = new List<String>();
        Datetime dateTemp = Datetime.now();

        for(Integer i =6; i>=0; i--  ){
            elementsToDisplay.put(dateTemp.addDays(-i),0);
        }

        for (Contract__c contract : contractsList) {
            for(Datetime mapElement : elementsToDisplay.keySet() ){
                if(contract.Start_Date__c <= mapElement && contract.End_Date__c >= dateTemp){
                    elementsToDisplay.put(mapElement, elementsToDisplay.get(mapElement) + 1);
                }
            }
        }
        employersPerDay = '';
        for (Datetime oneElement : elementsToDisplay.keySet()) {
            employersPerDay = employersPerDay + elementsToDisplay.get(oneElement) + ',';
        }
        employersPerDay.substring(0, employersPerDay.length()-1);

        return employersPerDay;
    }

    public Integer selectEmployers(String country) {
        return [SELECT COUNT() FROM Doctor__c WHERE Country__c = :country];
    }

    public void getHospital() {
        hospitalCurrent = [SELECT Id, Name, Country__c FROM Hospital__c WHERE Id = :hospitalIdCurrent];

    }

    public static Boolean getIsLicenseNoEnabled() {
        if (hospitalCurrent != null) {
            return Hospital_DoctorUtils.isFunctionalityEnabled('HospitalAddressNotEnabled', hospitalCurrent.Country__c);
        }
        return false;
    }

    public List<Contract__c> getContracts() {
        contracts = [
                SELECT Id,
                        Name,
                        Start_Date__c,
                        End_Date__c,
                        Doctor_Id__r.First_Name__c,
                        Doctor_Id__r.Last_Name__c,
                        Doctor_Id__r.FirstNameLastName__c,
                        Doctor_Id__r.Id,
                        Hospital_Id__r.Name
                FROM Contract__c
                WHERE Hospital_Id__c = :hospitalIdCurrent
                ORDER BY Start_Date__c
        ];
        return contracts;
    }

    public void removeContract() {
        System.debug('Hospital View Contract idCurrent' + selectedContractId);
        List<Contract__c> contractsChoose = [SELECT Id, Start_Date__c, End_Date__c FROM Contract__c WHERE Id = :selectedContractId];
        Contract__c selectedContract = null;
        for (Contract__c oneContract : contractsChoose) {
            if (oneContract.Id == selectedContractId) {
                selectedContract = oneContract;
                break;
            }
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
        getContracts();
    }

    public void searchDoctors() {
        String query = getQueryDoctorSearch();
        doctorWrappers.clear();
        if (String.isNotBlank(query)) {
            doctors = Database.query(query);
        } else {
            doctors.clear();
        }
        for (Doctor__c doctor : doctors) {
            if (contractWrappers.size() < 1) {
                doctorWrappers.add(new DoctorWrapper(doctor));
            } else {
                DoctorWrapper doctWrap = new DoctorWrapper(doctor);
                for (ContractWrapper contractWrapper : contractWrappers) {
                    if (contractWrapper.contractDoctor.Id.equals(doctor.Id)) {
                        doctWrap.doctorWrapperIsSelected = true;
                    }
                }
                doctorWrappers.add(doctWrap);
            }
        }
    }

    public void clearSearchDoctors() {
        setFieldsEmpty();
    }

    public String getQueryDoctorSearch() {
        Hospital_DoctorQueryBuilder queryBuilder = new Hospital_DoctorQueryBuilder();
        queryBuilder.setSelectColumn('Id,');
        queryBuilder.setSelectColumn('First_Name__c,');
        queryBuilder.setSelectColumn('Last_Name__c,');
        queryBuilder.setSelectColumn('City__c,');
        queryBuilder.setSelectColumn('FirstNameLastName__c,');
        queryBuilder.setSelectColumn('Country__c');
        queryBuilder.setFromColumn('Doctor__c');
        queryBuilder.setLike(doctor.Last_Name__c, 'Last_Name__c');
        queryBuilder.setLike(doctor.First_Name__c, 'First_Name__c');
        queryBuilder.setLike(doctor.City__c, 'Email__c');
        queryBuilder.setLike(doctor.Country__c, 'Country__c');
        queryBuilder.setOrderByClause();
        queryBuilder.setOrderByColumn(sortOrder);
        queryBuilder.setAscendingOrder(currentAsc);

        doctors = Database.query(queryBuilder.build());
        return queryBuilder.build();
    }

    public class DoctorWrapper {
        public Doctor__c doctorWrapper {
            get;
            set;
        }
        public Contract__c contractWrapper {
            get;
            set;
        }
        public Boolean doctorWrapperIsSelected {
            get;
            set;
        }

        public DoctorWrapper(Doctor__c doctor) {
            doctorWrapper = new Doctor__c();
            doctorWrapper.Id = doctor.Id;
            doctorWrapper.First_Name__c = doctor.First_Name__c;
            doctorWrapper.Last_Name__c = doctor.Last_Name__c;
            doctorWrapper.Name = doctor.FirstNameLastName__c;
            doctorWrapper.Country__c = doctor.Country__c;
            doctorWrapper.City__c = doctor.City__c;
            doctorWrapperIsSelected = false;

        }
    }

    public void changeSelectDoctor() {
        for (DoctorWrapper docWrap : doctorWrappers) {
            if (docWrap.doctorWrapper.Id.equals(selectedDoctorId)) {
                docWrap.doctorWrapperIsSelected = true;
                Doctor__c selectedDoctorToAdd = new Doctor__c(Id = docWrap.doctorWrapper.Id, Name = docWrap.doctorWrapper.Name,
                        First_Name__c = docWrap.doctorWrapper.First_Name__c, Last_Name__c = docWrap.doctorWrapper.Last_Name__c,
                        Country__c = docWrap.doctorWrapper.Country__c, City__c = docWrap.doctorWrapper.City__c);
                System.debug('Selected Doctor To Add' + selectedDoctorToAdd);
                contractWrappers.add(new ContractWrapper(selectedDoctorToAdd));
                System.debug('Contract Wrappers ' + contractWrappers);

                break;
            }
        }
    }

    public void removeDoctorFromSelectedDoctors() {
        Integer positionDoctorToRemove;
        for (ContractWrapper contractWrap : contractWrappers) {
            if (contractWrap.contractDoctor.Id.equals(selectedDoctorContractId)) {
                positionDoctorToRemove = contractWrappers.indexOf(contractWrap);
                System.debug('Position to remove ' + positionDoctorToRemove);
                contractWrappers.remove(positionDoctorToRemove);
                break;
            }
        }
        for (DoctorWrapper docWrap : doctorWrappers) {
            if (docWrap.doctorWrapper.Id.equals(selectedDoctorContractId)) {
                docWrap.doctorWrapperIsSelected = false;
            }
        }
    }

    public void clearFieldsAndResultDoctors() {
        setFieldsEmpty();
    }

    private void setFieldsEmpty() {
        doctor = new Doctor__c(Name = '');
        doctors.clear();
        doctorWrappers.clear();
        contractWrappers.clear();
        editStartDateFlag = false;
    }

    public class ContractWrapper {
        public Doctor__c contractDoctor {
            get;
            set;
        }
        public Contract__c contractWrapperToSet {
            get;
            set;
        }
        public String contractWrapperStatus {
            get;
            set;
        }
        public Boolean contractWrapperEditDate {
            get;
            set;
        }

        public ContractWrapper(Doctor__c doctor) {
            contractDoctor = new Doctor__c();
            contractDoctor.Id = doctor.Id;
            contractDoctor.First_Name__c = doctor.First_Name__c;
            contractDoctor.Last_Name__c = doctor.Last_Name__c;
            contractDoctor.Name = doctor.Name;
            contractDoctor.Country__c = doctor.Country__c;
            contractDoctor.City__c = doctor.City__c;
            contractWrapperToSet = new Contract__c();
            contractWrapperStatus = '';
            contractWrapperEditDate = false;
        }
    }

    public void saveStartEndDate() {
        for (ContractWrapper contractWrapper : contractWrappers) {
            if (contractWrapper.contractDoctor.Id.equals(selectedDoctorContractId)) {
                contractWrapper.contractWrapperToSet.Start_Date__c = newHireContract.Start_Date__c;
                contractWrapper.contractWrapperToSet.End_Date__c = newHireContract.End_Date__c;
                System.debug('Selected Wrapper' + contractWrapper);
                newHireContract.Start_Date__c = null;
                newHireContract.End_Date__c = null;
                break;
            }
        }
        editStartDate();
    }

    public void editStartDate() {
        for (ContractWrapper contractWrapper : contractWrappers) {
            if (contractWrapper.contractDoctor.Id.equals(selectedDoctorContractId)) {
                newHireContract.Start_Date__c = contractWrapper.contractWrapperToSet.Start_Date__c;
                newHireContract.End_Date__c = contractWrapper.contractWrapperToSet.End_Date__c;
                contractWrapper.contractWrapperEditDate = !contractWrapper.contractWrapperEditDate;
            }
        }
        editStartDateFlag = !editStartDateFlag;
    }

    public void clearStartDateEndDate() {
        for (ContractWrapper contractWrap : contractWrappers) {
            if (contractWrap.contractDoctor.Id.equals(selectedDoctorContractId)) {
                contractWrap.contractWrapperToSet.Start_Date__c = null;
                contractWrap.contractWrapperToSet.End_Date__c = null;
                break;
            }
        }
    }

    public void templateStartDateEndDate() {
        ContractWrapper contractWrapperSelected;
        for (ContractWrapper contractWrapper : contractWrappers) {
            if (contractWrapper.contractDoctor.Id.equals(selectedDoctorContractId)) {
                contractWrapperSelected = contractWrapper;
            }
        }
        for (ContractWrapper contractWrapper : contractWrappers) {
            contractWrapper.contractWrapperToSet.Start_Date__c = contractWrapperSelected.contractWrapperToSet.Start_Date__c;
            contractWrapper.contractWrapperToSet.End_Date__c = contractWrapperSelected.contractWrapperToSet.End_Date__c;
        }
    }

    public void hireAllDoctor() {
        isEnyErrorInModalWindow = false;
        createNewContractsToInsert();
        try {
            List<Database.SaveResult> resultsAfterImportDoctorToDatabase = Database.insert(contractsToInsert, false);

            for (Integer i = 0; i < resultsAfterImportDoctorToDatabase.size(); i++) {
                if (resultsAfterImportDoctorToDatabase.get(i).isSuccess()) {
                    contractWrappers.get(i).contractWrapperStatus = Label.Success;
                    contractWrappers.get(i).contractWrapperToSet.Id = resultsAfterImportDoctorToDatabase.get(i).getId();
                } else {
                    contractWrappers.get(i).contractWrapperStatus = resultsAfterImportDoctorToDatabase.get(i).errors[0].getMessage();
                    isEnyErrorInModalWindow = true;
                }
            }
        } catch (Exception ex) {
            Hospital_Utils.addToErrors(ex, 'Hospital_ViewController');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDmlMessage(0)));
            System.debug('Message ' + new ApexPages.Message(ApexPages.severity.ERROR, ex.getDmlMessage(0)));
        }
        getContracts();
    }

    public void createNewContractsToInsert() {
        contractsToInsert = new List<Contract__c>();
        for (ContractWrapper contractWrapper : contractWrappers) {
            contractWrapper.contractWrapperToSet.Id = null;
            contractsToInsert.add(new Contract__c(Doctor_Id__c = contractWrapper.contractDoctor.Id, Hospital_Id__c = hospitalIdCurrent,
                    Start_Date__c = contractWrapper.contractWrapperToSet.Start_Date__c,
                    End_Date__c = contractWrapper.contractWrapperToSet.End_Date__c));
        }
    }

    public void clearHireModalWindow() {
        clearFieldsAndResultDoctors();
        ApexPages.getMessages().clear();
    }
}