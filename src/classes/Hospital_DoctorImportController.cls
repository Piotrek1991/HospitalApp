/**
 * Created by BRITENET on 18.12.2018.
 */

public with sharing class Hospital_DoctorImportController {

    public Transient Blob csvFileBody { get; set; }
    public Integer fileSize { get; set; }
    public Boolean doneUploading { get; set; }
    public Transient String fileName { get; set; }
    public Transient String contentType { get; set; }
    public List<String> csvFileLines { get; set; }
    public List<String> inputValues { get; set; }
    public List<String> fieldList { get; set; }
    public Boolean isEmptyMap { get; set; }
    public List<Doctor__c> doctorsToImport { get; set; }
    public Map<String, DoctorImportWrapper> mapDoctorImportWrapper { get; set; }

    public Hospital_DoctorImportController() {
        csvFileLines = new List<String>();
        fieldList = New List<String>();
        doneUploading = false;
        doctorsToImport = new List<Doctor__c>();
        mapDoctorImportWrapper = new Map<String, DoctorImportWrapper>();
    }

    public class DoctorImportWrapper {
        public Doctor__c doctorWrapper { get; set; }
        public Boolean doctorIsSelectedWrapper { get; set; }
        public String doctorWrapperStatus { get; set; }

        public DoctorImportWrapper(Doctor__c doctor) {
            doctorWrapper = new Doctor__c();
            doctorWrapper.Id = doctor.Id;
            doctorWrapper.First_Name__c = doctor.First_Name__c;
            doctorWrapper.Last_Name__c = doctor.Last_Name__c;
            doctorWrapper.Name = doctor.Name;
            doctorWrapper.Country__c = doctor.Country__c;
            doctorWrapper.City__c = doctor.City__c;
            doctorIsSelectedWrapper = true;
            doctorWrapperStatus = '';
        }
    }

    private void isEmptyMap() {
        isEmptyMap = mapDoctorImportWrapper.isEmpty();
    }

    public void importCSVFile() {
        mapDoctorImportWrapper.clear();
        checkCorrectImportFile();
        try {
            generateListDoctorImportWrapperFromFile();
            doneUploading = true;
        } catch (Exception e) {
            Hospital_Utils.addToErrors(e, 'Hospital_DoctorImportController');
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.UnableCSV, new List<String>{
            }));
            doneUploading = false;
            ApexPages.addMessage(msg);
        }
    }

    public void generateListDoctorImportWrapperFromFile() {
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        for (Integer i = 1; i < csvFileLines.size(); i++) {
            Doctor__c doctor = new Doctor__c() ;
            List<String> csvRecordData = csvfilelines.get(i).split(',');
            doctor.Id = null;
            doctor.Name = csvRecordData.get(1);
            doctor.First_Name__c = csvRecordData.get(0);
            doctor.Last_Name__c = csvRecordData.get(1);
            doctor.City__c = csvRecordData.get(2);
            doctor.Country__c = csvRecordData.get(3);
            String key = Hospital_GuidUtil.generateGuid();
            mapDoctorImportWrapper.put(key, new DoctorImportWrapper(doctor));
        }
    }

    public void checkCorrectImportFile() {
        try {
            if (!fileName.endsWithIgnoreCase('csv')) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.UnableCSV, new List<String>{
                }));
                ApexPages.addMessage(msg);

            } else {
                doneUploading = true;
                System.debug('Done upload in checkCorrectImportFile ' + doneUploading);
            }
        } catch (Exception ex) {
            Hospital_Utils.addToErrors(ex, 'Hospital_DoctorImportController');
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.UnableCSV, new List<String>{
            }));
            ApexPages.addMessage(msg);
        }
    }

    public void importDoctorsToDataBase() {
        System.debug('Doctors' + mapDoctorImportWrapper);
        convertDoctorsWrapperToImport();
        try {
            List<Database.SaveResult> resultsAfterImportDoctorToDatabase = Database.insert(doctorsToImport, false);
            Integer j = 0;
            for (String key : mapDoctorImportWrapper.keySet()) {
                if (mapDoctorImportWrapper.get(key).doctorIsSelectedWrapper) {
                    for (Integer i = j; i < resultsAfterImportDoctorToDatabase.size(); i++) {
                        if (resultsAfterImportDoctorToDatabase.get(i).isSuccess()) {
                            mapDoctorImportWrapper.get(key).doctorWrapperStatus = Label.Success;
                            mapDoctorImportWrapper.get(key).doctorWrapper.Id = resultsAfterImportDoctorToDatabase.get(i).getId();
                        } else {
                            mapDoctorImportWrapper.get(key).doctorWrapperStatus = resultsAfterImportDoctorToDatabase.get(i).errors[0].getMessage();
                            mapDoctorImportWrapper.get(key).doctorWrapper.Id = null;
                        }
                        j++;
                        break;
                    }
                }
            }


        } catch (Exception ex) {
            Hospital_Utils.addToErrors(ex, 'Hospital_DoctorImportController');
            System.debug('Exception during insert to database' + ex.getMessage());
        }
        doctorsToImport.clear();
    }

    public void convertDoctorsWrapperToImport() {
        for (String key : mapDoctorImportWrapper.keySet()) {
            mapDoctorImportWrapper.get(key).doctorWrapper.Id = null;
            mapDoctorImportWrapper.get(key).doctorWrapperStatus = '';
            DoctorImportWrapper doctor = mapDoctorImportWrapper.get(key);
            if (doctor.doctorIsSelectedWrapper) {
                doctorsToImport.add(new Doctor__c(Name = doctor.doctorWrapper.Last_Name__c, First_Name__c = doctor.doctorWrapper.First_Name__c,
                        Last_Name__c = doctor.doctorWrapper.Last_Name__c, City__c = doctor.doctorWrapper.City__c, Country__c = doctor.doctorWrapper.Country__c));
            }
        }
    }

    public void deselectCheckBox() {
        for (DoctorImportWrapper doct : mapDoctorImportWrapper.values()) {
            doct.doctorIsSelectedWrapper = !doct.doctorIsSelectedWrapper;
        }
    }

    public void clearAllCheckBox() {
        for (DoctorImportWrapper doct : mapDoctorImportWrapper.values()) {
            doct.doctorIsSelectedWrapper = false;
        }
    }
    public void selectCheckBox() {
        for (DoctorImportWrapper doct : mapDoctorImportWrapper.values()) {
            doct.doctorIsSelectedWrapper = true;
        }
    }

    public void clear() {
        mapDoctorImportWrapper.clear();
        doneUploading = false;
    }
}