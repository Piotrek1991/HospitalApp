/**
 * Created by BRITENET on 03.01.2019.
 */

public with sharing class Hospital_MaciejDoctorsController {
    public List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap> doctorsFromMaciej { get; set; }
    public List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap> deletedDoctorsToTest { get; set; }
    public Hosp_MaciejSoapForDoctorsWebService.Hosp_SoapForDoctorsWebService doctorsService { get; set; }
    public Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap doctorToTest { get; set; }
    public Doctor__c doctorSearchData { get; set; }
    public Doctor__c doctorCreateData { get; set; }
    public String selectedDoctorId { get; set; }
    public Boolean isAnyProblemWithCallout { get; set; }
    public String messageSuccessToast { get; set; }
    public String messageErrorToast { get; set; }
    public Boolean isSearchSuccessful { get; set; }

    public Hospital_MaciejDoctorsController() {
        doctorsService = new Hosp_MaciejSoapForDoctorsWebService.Hosp_SoapForDoctorsWebService();
        doctorsFromMaciej = new List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap>();
        doctorToTest = new Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap();
        doctorSearchData = new Doctor__c();
        doctorCreateData = new Doctor__c();
        selectedDoctorId = '';
        doctorsService.timeout_x = 1000;
        doctorsService.SessionHeader = new Hosp_MaciejSoapForDoctorsWebService.SessionHeader_element();
        doctorsService.SessionHeader.sessionId = loginToMaciejClinic();
        isAnyProblemWithCallout = false;
        isSearchSuccessful = false;
    }

    public void searchDoctors() {
        isSearchSuccessful = false;
        doctorsFromMaciej = new List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap>();
        doctorsFromMaciej = doctorsService.getDoctors(doctorSearchData.Last_Name__c, doctorSearchData.First_Name__c, doctorSearchData.City__c, doctorSearchData.Country__c);
        if (doctorsFromMaciej != null && doctorsFromMaciej.size() > 0) {
            isSearchSuccessful = true;
        }
    }

    public void upsertDoctors() {
        clearMessages();
        try {
            if (String.isBlank(doctorCreateData.Id)) {
                messageSuccessToast = Label.Doctor_successfully_added;
            } else {
                messageSuccessToast = Label.Doctor_successfully_updated;
                if (doctorsFromMaciej != null && doctorsFromMaciej.size() > 0) {
                    isSearchSuccessful = true;
                }
            }
            doctorToTest = doctorsService.upsertDoctor(doctorCreateData.Id, doctorCreateData.Last_Name__c,
                    doctorCreateData.First_Name__c, doctorCreateData.City__c, doctorCreateData.Country__c);
            isAnyProblemWithCallout = false;
            upsertDoctorData();
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Failed_duplicate_record);
            ApexPages.addMessage(myMsg);
            isAnyProblemWithCallout = true;
            System.debug('Exception insert >>' + e.getMessage());
        }
        if (!Test.isRunningTest()) {
            searchDoctors();
        }
    }

    public void upsertDoctorData() {
        for (Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap doctor : doctorsFromMaciej) {
            if (doctor.doctorId.equals(selectedDoctorId)) {
                doctor.doctorId = doctorCreateData.Id;
                doctor.firstName = doctorCreateData.First_Name__c;
                doctor.name = doctorCreateData.Last_Name__c;
                doctor.city = doctorCreateData.City__c;
                doctor.country = doctorCreateData.Country__c;
                break;
            }
        }
    }

    public void deleteDoctors() {
        clearMessages();
        deletedDoctorsToTest = new List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap>();
        try {
            deletedDoctorsToTest = doctorsService.deleteDoctors(new List<String>{
                    selectedDoctorId
            });
            isAnyProblemWithCallout = false;
            messageSuccessToast = Label.Doctor_successfully_deleted;
        } catch (Exception e) {
            isAnyProblemWithCallout = true;
            messageErrorToast = Label.Unable_to_delete_doctor;
        }
        List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap> tempDoctors = new List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap>();
        for (Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap doctor : doctorsFromMaciej) {
            if (doctor.doctorId != selectedDoctorId) {
                tempDoctors.add(doctor);
            }
        }
        doctorsFromMaciej.clear();
        doctorsFromMaciej.addAll(tempDoctors);
        if (doctorsFromMaciej == null || doctorsFromMaciej.size() == 0) {
            isSearchSuccessful = false;
        }
    }

    public void editDoctors() {
        for (Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap doctor : doctorsFromMaciej) {
            if (doctor.doctorId.equals(selectedDoctorId)) {
                doctorCreateData.Id = doctor.doctorId;
                doctorCreateData.First_Name__c = doctor.firstName;
                doctorCreateData.Last_Name__c = doctor.name;
                doctorCreateData.City__c = doctor.city;
                doctorCreateData.Country__c = doctor.country;
            }
        }
    }

    public void clearMessages() {
        ApexPages.getMessages().clear();
    }

    public void clearFieldsAndResultDoctors() {
        clearMessages();
        doctorCreateData = new Doctor__c();
        isAnyProblemWithCallout = true;
        clearHireModalWindow();
    }

    public void clearHireModalWindow() {
        clearMessages();
        doctorCreateData = new Doctor__c();
    }

    public static String loginToMaciejClinic() {
        try {
            Hospital_partnerSoapSforceCom.Soap partnerSoap = new Hospital_partnerSoapSforceCom.Soap();
            Hospital_partnerSoapSforceCom.LoginResult loginResult = partnerSoap.login('piotrtoporowski@britenet.com.pl', 'britenet1wjaReYZjITIwqooeZr1ZHHsY');

            return loginResult.sessionId;
        } catch (Exception ex) {
            System.debug('Login To Maciejs Clinic Exception >> ' + ex.getMessage());
            return null;
        }
    }
}