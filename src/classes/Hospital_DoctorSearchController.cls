/**
 * Created by BRITENET on 12.12.2018.
 */

public with sharing class Hospital_DoctorSearchController {

    public Doctor__c doctor { get; set; }
    public List<Doctor__c> doctorsToExport { get; set; }
    private String sortOrder = 'Last_Name__c';
    private String currentAsc = ' ASC';
    private final String ascending = ' ASC';
    private final String descending = ' DESC';
    public static final String sortUp = '▲';
    public static final String sortDown = '▼';
    public String orderSignName { get; set; }
    public String orderSignEmail { get; set; }
    public String orderSignCountry { get; set; }
    public String currentSign { get; set; }
    public String doctorsInJson { get; set; }

    public ApexPages.StandardSetController standardSetController {
        get {
            if (standardSetController == null) {
                if (String.isNotBlank(doctor.Last_Name__c)) {
                    standardSetController = new ApexPages.StandardSetController(Database.query(getQuery()));
                    standardSetController.setPageSize(5);
                } else {
                    standardSetController = new ApexPages.StandardSetController(new List<Doctor__c>());
                }
            }
            return standardSetController;
        }
        set;
    }

    public Hospital_DoctorSearchController() {
        this.doctor = new Doctor__c(Name = '');
        doctorsToExport = new List<Doctor__c>();
        currentSign = sortUp;
    }

    public List<Doctor__c> getDoctors() {
        return standardSetController.getRecords();
    }

    public String getQuery() {
        Hospital_DoctorQueryBuilder queryBuilder = new Hospital_DoctorQueryBuilder();
        queryBuilder.setSelectColumn('Id,');
        queryBuilder.setSelectColumn('First_Name__c,');
        queryBuilder.setSelectColumn('Last_Name__c,');
        queryBuilder.setSelectColumn('Email__c,');
        queryBuilder.setSelectColumn('FirstNameLastName__c,');
        queryBuilder.setSelectColumn('Country__c');
        queryBuilder.setFromColumn('Doctor__c');
        queryBuilder.setLike(doctor.Last_Name__c, 'Last_Name__c' );
        queryBuilder.setLike(doctor.First_Name__c, 'First_Name__c' );
        queryBuilder.setLike(doctor.Email__c, 'Email__c' );
        queryBuilder.setLike(doctor.Country__c, 'Country__c' );
        queryBuilder.setOrderByClause();
        queryBuilder.setOrderByColumn(sortOrder);
        queryBuilder.setAscendingOrder(currentAsc);

        System.debug(queryBuilder.build());
        doctorsToExport = Database.query(queryBuilder.build());
        return queryBuilder.build();
    }

    public void searchDoctors() {
        standardSetController = null;
    }

    public Boolean hasNext {
        get {
            return standardSetController.getHasNext();
        }
        set;
    }

    public Boolean hasPrevious {
        get {
            return standardSetController.getHasPrevious();
        }
        set;
    }

    public Integer pageNumber {
        get {
            return standardSetController.getPageNumber();
        }
        set;
    }

    public void first() {
        standardSetController.first();
    }

    public void last() {
        standardSetController.last();
    }

    public void previous() {
        standardSetController.previous();
    }

    public void next() {
        standardSetController.next();
    }

    public void cancel() {
        standardSetController.cancel();
    }

    public void reset() {
        doctor.First_Name__c = '';
        doctor.Last_Name__c = '';
        doctor.Email__c = '';
        doctor.Country__c = '';
        standardSetController = null;
        doctorsToExport.clear();
    }

    public void sortByLastName() {
        this.sortOrder = 'FirstNameLastName__c';
        orderSignName = currentSign;
        clearSigns(sortOrder);
        replaceAscending();
        searchDoctors();
    }

    public void sortByEmail() {
        this.sortOrder = 'Email__c';
        orderSignEmail = currentSign;
        clearSigns(sortOrder);
        replaceAscending();
        searchDoctors();
    }

    public void sortByCountry() {
        this.sortOrder = 'Country__c';
        orderSignCountry = currentSign;
        clearSigns(sortOrder);
        replaceAscending();
        searchDoctors();
    }

    private void clearSigns(String filed) {
        if (filed.equals('FirstNameLastName__c')) {
            orderSignEmail = '';
            orderSignCountry = '';
        }
        if (filed.equals('Email__c')) {
            orderSignName = '';
            orderSignCountry = '';
        }
        if (filed.equals('Country__c')) {
            orderSignEmail = '';
            orderSignName = '';
        }
    }

    private void replaceAscending() {
        if (ascending.equals(currentAsc)) {
            currentAsc = descending;
            currentSign = sortUp;
        } else {
            currentAsc = ascending;
            currentSign = sortDown;
        }
    }

    public PageReference exportToCsv() {
        PageReference pageReference = Page.Hospital_DoctorSearchExportToCsv;
        pageReference.setRedirect(false);
        return pageReference;
    }

    public PageReference exportToXls() {
        PageReference pageReference = Page.Hospital_DoctorSearchExportToExcel;
        pageReference.setRedirect(false);
        return pageReference;
    }

    public PageReference exportToXlsX() {
        PageReference pageReference = Page.Hospital_DoctorSearchExportToXlsX;
        pageReference.setRedirect(false);
        return pageReference;
    }

    public PageReference exportToJson() {
        PageReference pageReference = Page.Hospital_DoctorSearchExportToJson;
        pageReference.setRedirect(false);
        return pageReference;
    }
    public void generateDoctorsInJson() {
        doctorsInJson = Hospital_DoctorHandler.getDoctorsInJson(doctorsToExport);
    }
}