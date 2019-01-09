/**
 * Created by BRITENET on 13.12.2018.
 */

public with sharing class Hospital_Utils {

    User getCurrentUser() {
        return getUser(UserInfo.getUserId());
    }

    public static User getUser(String userId) {
        List<User> userItem = [SELECT Id, email, country FROM User WHERE id = :userId];
        if (userItem.isEmpty()) {
            return null;
        }
        return userItem[0];
    }
    private static String addToWhereIfNotBlank(String fieldName, String checkedField) {
        if (String.isNotBlank(checkedField)) {
            return ' AND ' + fieldName + ' LIKE \'' + checkedField + '%\'';
        } else {
            return ' ';
        }
    }

    public static String generateHireDoctorHospitalsQuery(Hospital__c hospital) {
        String query = '';
        if(String.isNotBlank(hospital.Name)) {
            query = 'SELECT Id, Name, Country__c, City__c, Website__c FROM Hospital__c WHERE Name LIKE \'' + hospital.Name + '%\'' + addToWhereIfNotBlank('Website__c', hospital.Website__c) + addToWhereIfNotBlank('Country__c', hospital.Country__c);
        } else if(String.isNotBlank(hospital.Website__c)) {
            query = 'SELECT Id, Name, Country__c, City__c, Website__c FROM Hospital__c WHERE WWW__c LIKE \'' + hospital.Website__c + '%\'' + addToWhereIfNotBlank('Country__c', hospital.Country__c);
        } else if(String.isNotBlank(hospital.Country__c)) {
            query = 'SELECT Id, Name, Country__c, City__c, WWW__c FROM Hospital__c WHERE Country__c = \'' + hospital.Country__c + '\'';
        }
        System.debug(query);
        return query;
    }

}