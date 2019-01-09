/**
 * Created by BRITENET on 02.01.2019.
 */

global class Hospital_DoctorWrapperForSOAP {

    webService String webServiceDoctorId { get; set; }
    webService String webServiceDoctorFirstName { get; set; }
    webService String webServiceDoctorLastName { get; set; }
    webService String webServiceDoctorCountry { get; set; }
    webService String webServiceDoctorCity { get; set; }

    global Hospital_DoctorWrapperForSOAP(Doctor__c doctor) {
        webServiceDoctorId = doctor.Id;
        webServiceDoctorFirstName = doctor.First_Name__c;
        webServiceDoctorLastName = doctor.Last_Name__c;
        webServiceDoctorCountry = doctor.Country__c;
        webServiceDoctorCity = doctor.City__c;
    }
}