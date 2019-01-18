/**
 * Created by BRITENET on 18.12.2018.
 */

public with sharing class Hospital_DoctorUtils {

    public static Boolean isFunctionalityEnabled(String csName) {
        return isFunctionalityEnabled(csName, getCurrentUser().Country);
    }

    public static Boolean isFunctionalityEnabled(String csName, String country) {
        Hospital_Custom_Settings__c csItem = Hospital_Custom_Settings__c.getInstance(csName);
        if (csItem == null) {
            return false;
        }
        List<String> setValue = csItem.Value__c.split(',');
        return setValue.contains(country);
    }

    public static User getCurrentUser() {
        if (Cache.Session.get('HospitalCurrentUser') == null) {
            return getUser(UserInfo.getUserId());
        }
        return (User) Cache.Session.get('HospitalCurrentUser');
    }

    public static User getUser(String userId) {
        List<User> userItem = [SELECT Id, Country FROM User WHERE Id = :userId];
        if (userItem.isEmpty()) {
            return null;
        }
        Cache.Session.put('HospitalCurrentUser', userItem.get(0));
        return userItem.get(0);
    }

    public static String getCsValue(String csName) {
        Hospital_Custom_Settings__c csItem =  Hospital_Custom_Settings__c.getInstance(csName);
        if (csItem == null) {
            return null;
        }
        return csItem.Value__c;
    }

    public static Integer getCsValueFromInteger(String csName) {
        return Integer.valueOf(getCsValue(csName));
    }

    public static Boolean getCsValueFromBoolean(String csName) {
        getCsValue(csName);
        return Boolean.valueOf(getCsValue(csName));
    }

    public static String blobToString(Blob input, String inCharset) {
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for (Integer i = 0; i < bytesCount; ++i)
            bytes[i] = hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }

    public static void removeObjectFromList(List<SObject> lst, SObject o) {
        for (Integer i = lst.size() - 1; i >= 0; --i) {
            if (lst.get(i) == o || lst.get(i).get('id') == o.get('id')) {
                lst.remove(i);
            }
        }
    }

    public static List<Doctor__c> sendEmailToDoctor(List<Doctor__c> doctors) {

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        List<String> address = new List<String>();

        for (Doctor__c doctor : doctors) {
            if (doctor.Email__c != null) {
                address.add(doctor.Email__c);
                Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                string body = 'Hello ' + doctor.Name + doctor.Last_Name__c + '. Your personal data are in our database. Please read information ' +
                        'about personal data protection: http://prawo.sejm.gov.pl/isap.nsf/download.xsp/WDU20180001000/T/D20181000L.pdf';
                singleMail.setSenderDisplayName('Salesforce Hospital');
                singleMail.setSubject('Information about personal data protection');
                singleMail.setTreatTargetObjectAsRecipient(false);
                singleMail.setToAddresses(address);
                singleMail.setSaveAsActivity(false);
                singleMail.setHtmlBody(body);
                emails.add(singleMail);
            }
        }
        Messaging.sendEmail(emails);
        return doctors;
    }

}