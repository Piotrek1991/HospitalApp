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

    public static String getAccessToken(String username, String password, String ClientId, String ClientSecret) {
        String endpoint = 'https://login.salesforce.com/services/oauth2/token';

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        req.setBody('grant_type=password' +
                '&client_id=' + ClientId +
                '&client_secret=' + ClientSecret +
                '&username=' + username +
                '&password=' + password
        );
        System.debug('req.getBody()' + req.getBody());
        req.setEndpoint(endpoint);
        Http http = new Http();
        HttpResponse res;
        String accessToken;
        System.debug('accessToken >> ' + accessToken);

        try {
            res = http.send(req);
            system.debug('body:' + res.getBody());
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    accessToken = parser.getText();
                }
            }
        } catch (system.CalloutException e) {
            System.debug('error >>> ' + e);
        }

        return accessToken;
    }

    public static String loginToFirstOrgGetSessionId() {
        String username = 'piotrtoporowski@britenet.com.pl';
        String password = 'britenet1wjaReYZjITIwqooeZr1ZHHsY';
        String ClientId = '3MVG9fTLmJ60pJ5InwHdKeAk5AOV26haJkSaTsDt1jrF_Int15g_OTUQ0XPoxYVr6rK_mEwW745kB_VKjLJKX';
        String ClientSecret = '1556104890581635631';
        return getAccessToken(username, password, ClientId, ClientSecret);
    }

    public static String loginToSecondOrgGetSessionId() {
        String username = 'malszcz@vp.pl';
        String password = 'britenet2OtEnMSu0G1vCAYom3l9u4EeA';
        String ClientId = '3MVG9fTLmJ60pJ5L9cnCubmjX_eLKbZmAPIn3jG3pirLoEoSItoLD82S6Aa.cK.IKpD88y_YhEPmInj3JYCOA';
        String ClientSecret = '4736755902322743893';
        return getAccessToken(username, password, ClientId, ClientSecret);
//        return '00D1t000000vXus!AQEAQEujDxOeW0V0_oflJ8vWhNHKGrq2sgxTUocP591EhELkQ0gn8RgS7Crj_zrdOA3NsMG.u2NcN.BDNEDskAurSxeM0Qlg';
    }

    public static String loginToOriginalOrgGetSessionId() {
        String username = 'piotr.toporowski@britenet.com.pl';
        String password = 'infobot2dP0AAU5iIESMQjwYlmRbIb4yk';
        String ClientId = '3MVG9fTLmJ60pJ5KOWKrx4ZK68vNlIfnjAFm2vxDVqcwXikS7Ue3byomd2pAWj6eXVJeneqz6k4r4IG2mux60';
        String ClientSecret = '6606012055671277163';
        return getAccessToken(username, password, ClientId, ClientSecret);
    }

}