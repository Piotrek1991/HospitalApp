/**
 * Created by BRITENET on 14.01.2019.
 */

public with sharing class Hospital_DoctorComparator {

    public static String compareBy { get; set; }
    public static List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap> sortResults(List<Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap> doctorsToSort, Boolean sortAsc) {
        if(doctorsToSort != null) {
            List<Hospital_DoctorComparator.DoctorWrapper> tempDoctorsToSort = new List<Hospital_DoctorComparator.DoctorWrapper>();
            for (Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap doctorToConvert : doctorsToSort) {
                tempDoctorsToSort.add(new Hospital_DoctorComparator.DoctorWrapper(doctorToConvert, sortAsc));
            }
            tempDoctorsToSort.sort();
            doctorsToSort.clear();
            for (Hospital_DoctorComparator.DoctorWrapper doc : tempDoctorsToSort) {
                Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap doctorInWrapper = new Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap();
                doctorInWrapper.doctorId = doc.id;
                doctorInWrapper.name = doc.name;
                doctorInWrapper.firstName = doc.firstName;
                doctorInWrapper.city = doc.city;
                doctorInWrapper.country = doc.country;
                doctorsToSort.add(doctorInWrapper);
            }
        }
        return doctorsToSort;
    }
    public class DoctorWrapper implements Comparable {
        public String id { get; set; }
        public String name { get; set; }
        public String firstName { get; set; }
        public String country { get; set; }
        public String city { get; set; }
        public Boolean sortAsc { get; set; }
        public DoctorWrapper(Hosp_MaciejDoctorWrapperForSoap.Hosp_DoctorWrapperForSoap doctorToChange, Boolean sortAsc) {
            id = doctorToChange.doctorId;
            name = doctorToChange.name;
            firstName = doctorToChange.firstName;
            country = doctorToChange.country;
            city = doctorToChange.city;
            this.sortAsc = sortAsc;
            if(String.isBlank(name)) {
                name = '';
            }
            if(String.isBlank(firstName)) {
                firstName = '';
            }
            if(String.isBlank(country)) {
                country = '';
            }
            if(String.isBlank(city)) {
                city = '';
            }
        }
        public Integer compareTo(Object compareTo) {
            if (sortAsc) {
                if (compareBy.equals('name')) {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (name == compareToDoctor.name) return 0;
                    if (name > compareToDoctor.name) return 1;
                    return -1;
                } else if (compareBy.equals('firstName')) {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (firstName == compareToDoctor.firstName) return 0;
                    if (firstName > compareToDoctor.firstName) return 1;
                    return -1;
                } else if (compareBy.equals('country')) {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (country == compareToDoctor.country) return 0;
                    if (country > compareToDoctor.country) return 1;
                    return -1;
                } else {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (city == compareToDoctor.city) return 0;
                    if (city > compareToDoctor.city) return 1;
                    return -1;
                }
            } else {
                if (compareBy.equals('name')) {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (name == compareToDoctor.name) return 0;
                    if (name > compareToDoctor.name) return -1;
                    return 1;
                } else if (compareBy.equals('firstName')) {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (firstName == compareToDoctor.firstName) return 0;
                    if (firstName > compareToDoctor.firstName) return -1;
                    return 1;
                } else if (compareBy.equals('country')) {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (country == compareToDoctor.country) return 0;
                    if (country > compareToDoctor.country) return -1;
                    return 1;
                } else {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (city == compareToDoctor.city) return 0;
                    if (city > compareToDoctor.city) return -1;
                    return 1;
                }
            }
        }
    }
}