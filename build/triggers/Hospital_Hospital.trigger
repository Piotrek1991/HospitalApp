/**
 * Created by BRITENET on 10.01.2019.
 */

trigger Hospital_Hospital on Hospital__c (before insert, before update, before delete) {

//    if (UserInfo.getUserId().equals('0051t000002SGkIAAW')) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            Boolean isExecuted = false;
            while (!isExecuted) {
                List<Hospital_HospitalWrapperForREST> hospitalsInWrapper = new List<Hospital_HospitalWrapperForREST>();
                for (Hospital__c hosp : Trigger.new) {
                    hospitalsInWrapper.add(new Hospital_HospitalWrapperForREST(hosp));
                }
                String body = '{ "hospitals"  : ' + JSON.serialize(hospitalsInWrapper) + ' }';
                Hospital_HospitalTriggerHandler.sendHosp(body);
                isExecuted = true;
            }
        } else if (Trigger.isDelete) {
            Boolean isExecuted = false;
            while (!isExecuted) {
                List<String> hospitalsIds = new List<String>();
                for (Hospital__c hosp : Trigger.oldMap.values()) {
                    hospitalsIds.add(hosp.External_Id__c);
                }
                Hospital_HospitalTriggerHandler.deleteHospitalData(hospitalsIds);
                isExecuted = true;
            }
        }
    }
//}