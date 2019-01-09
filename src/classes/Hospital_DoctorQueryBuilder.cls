/**
 * Created by BRITENET on 13.12.2018.
 */

public with sharing class Hospital_DoctorQueryBuilder {

    private String selectColumn = '';
    private String selectClause = 'SELECT';
    private String fromColumn = '';
    private String fromClause = ' FROM';
    private String whereColumnLike = '';
    private String whereClause = '';
    private String orderByColumn = '';
    private String orderByClause = '';
    private String ascendingClause = ' ASC';
    private String likeLastName = '';
    private String likeFirstName = '';
    private String likeEmail = '';
    private String likeCountry = '';

    public Hospital_DoctorQueryBuilder setSelectColumn(String column) {
        if (String.isNotBlank(column)) {
            this.selectColumn += ' ' + column;
        }
        return this;
    }

    public Hospital_DoctorQueryBuilder setFromColumn(String column) {
        if (String.isNotBlank(column)) {
            this.fromColumn = ' ' + column;
            this.whereClause = ' WHERE';
        }
        return this;
    }

    public Hospital_DoctorQueryBuilder setLike(String value, String apiName) {
        if (String.isNotBlank(value) && String.isNotBlank(apiName)) {
            if (apiName.equals('Last_Name__c')) {
                this.whereColumnLike += ' ' + apiName + ' LIKE \'' + value + '%\'';
            } else {
                this.whereColumnLike += ' AND ' + apiName + ' LIKE \'' + value + '%\'';
            }
        }
        return this;
    }

    public Hospital_DoctorQueryBuilder setLikeTest(String value, String apiName) {
        if (String.isNotBlank(value) && String.isNotBlank(apiName)) {
            if (apiName.equals('Last_Name__c')) {
                this.whereColumnLike += 'WHERE ' + apiName + ' LIKE \'' + value + '%\'';
            } else if(String.isNotBlank(whereColumnLike)) {
                this.whereColumnLike += ' AND ' + apiName + ' LIKE \'' + value + '%\'';
            }
        }
        return this;
    }

    public Hospital_DoctorQueryBuilder setOrderByColumn(String column) {
        this.orderByColumn = ' ' + column;
        return this;
    }

    public Hospital_DoctorQueryBuilder setOrderByClause() {
        this.orderByClause = ' ORDER BY ';
        return this;
    }

    public Hospital_DoctorQueryBuilder setAscendingOrder(String ascOrder) {
        this.ascendingClause = ascOrder;
        return this;
    }

    public Hospital_DoctorQueryBuilder setAscending() {
        this.ascendingClause = '';
        return this;
    }

    public String build() {
        return 'SELECT' + selectColumn + fromClause + ' Doctor__c ' + whereClause + whereColumnLike + orderByClause + orderByColumn + ascendingClause;
    }

    public String buildForTest() {
        return 'SELECT' + selectColumn + fromClause + ' Doctor__c ' + whereColumnLike;
    }
}