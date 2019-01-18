/**
 * Created by BRITENET on 10.01.2019.
 */

public class Hospital_HospitalComparator {

    public static String compareBy { get; set; }
    public static List<Hospital_HospitalWrapperForREST> sortResults(List<Hospital_HospitalWrapperForREST> hospitalsToSort, Boolean sortAsc) {
        if(hospitalsToSort != null) {
            List<Hospital_HospitalComparator.HospitalWrapper> tempHospitalsToSort = new List<Hospital_HospitalComparator.HospitalWrapper>();
            for (Hospital_HospitalWrapperForREST hospitalToConvert : hospitalsToSort) {
                tempHospitalsToSort.add(new Hospital_HospitalComparator.HospitalWrapper(hospitalToConvert, sortAsc));
            }
            tempHospitalsToSort.sort();
            hospitalsToSort.clear();
            for (Hospital_HospitalComparator.HospitalWrapper hosp : tempHospitalsToSort) {
                Hospital_HospitalWrapperForREST hospitalInWrapper = new Hospital_HospitalWrapperForREST();
                hospitalInWrapper.hospitalId = hosp.id;
                hospitalInWrapper.externalId = hosp.externalId;
                hospitalInWrapper.name = hosp.name;
                hospitalInWrapper.city = hosp.city;
                hospitalInWrapper.country = hosp.country;
                hospitalsToSort.add(hospitalInWrapper);
            }
        }
        return hospitalsToSort;
    }

    public class HospitalWrapper implements Comparable {
        public String id { get; set; }
        public String name { get; set; }
        public String country { get; set; }
        public String city { get; set; }
        public String externalId { get; set; }
        public Boolean sortAsc { get; set; }

        public HospitalWrapper(Hospital_HospitalWrapperForREST hospitalToChange, Boolean sortAsc) {
            id = hospitalToChange.hospitalId;
            name = hospitalToChange.name;
            externalId = hospitalToChange.externalId;
            country = hospitalToChange.country;
            city = hospitalToChange.city;
            this.sortAsc = sortAsc;
            if(String.isBlank(name)) {
                name = '';
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
                    HospitalWrapper compareToHospital = (HospitalWrapper) compareTo;
                    if (name == compareToHospital.name) return 0;
                    if (name > compareToHospital.name) return 1;
                    return -1;
                } else if (compareBy.equals('country')) {
                    HospitalWrapper compareToHospital = (HospitalWrapper) compareTo;
                    if (country == compareToHospital.country) return 0;
                    if (country > compareToHospital.country) return 1;
                    return -1;
                } else {
                    HospitalWrapper compareToHospital = (HospitalWrapper) compareTo;
                    if (city == compareToHospital.city) return 0;
                    if (city > compareToHospital.city) return 1;
                    return -1;
                }
            } else {
                if (compareBy.equals('name')) {
                    HospitalWrapper compareToHospital = (HospitalWrapper) compareTo;
                    if (name == compareToHospital.name) return 0;
                    if (name > compareToHospital.name) return -1;
                    return 1;
                } else if (compareBy.equals('country')) {
                    HospitalWrapper compareToHospital = (HospitalWrapper) compareTo;
                    if (country == compareToHospital.country) return 0;
                    if (country > compareToHospital.country) return -1;
                    return 1;
                } else {
                    HospitalWrapper compareToHospital = (HospitalWrapper) compareTo;
                    if (city == compareToHospital.city) return 0;
                    if (city > compareToHospital.city) return -1;
                    return 1;
                }
            }

        }
    }
}