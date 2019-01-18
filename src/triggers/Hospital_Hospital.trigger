/**
 * Created by BRITENET on 10.01.2019.
 */

trigger Hospital_Hospital on Hospital__c (before insert, before update, before delete, after insert, after update, after delete ) {

    if(Hospital_Utils.isTriggerEnabled('Hospital_Hospital')){
        Hospital_TriggerFactory.createHandler(Hospital__c.getSObjectType());
    }

//    if (Trigger.isInsert || Trigger.isUpdate) {
//        Boolean isExecuted = false;
//        while (!isExecuted) {
//            List<Hospital_HospitalWrapperForREST> hospitalsInWrapper = new List<Hospital_HospitalWrapperForREST>();
//            for (Hospital__c hosp : Trigger.new) {
//                Hospital_HospitalWrapperForREST hospToSend = new Hospital_HospitalWrapperForREST(hosp);
//                hospToSend.status = true;
//                hospitalsInWrapper.add(hospToSend);
//            }
//            String body = '{ "hospitals"  : ' + JSON.serialize(hospitalsInWrapper) + ' }';
//            Hospital_HospitalTriggerHandler.sendHosp(body);
//            isExecuted = true;
//        }
//    } else if (Trigger.isDelete) {
//        Boolean isExecuted = false;
//        while (!isExecuted) {
//            List<String> hospitalsIds = new List<String>();
//            for (Hospital__c hosp : Trigger.oldMap.values()) {
//                hospitalsIds.add(hosp.External_Id__c);
//            }
//            Hospital_HospitalTriggerHandler.deleteHospitalData(hospitalsIds);
//            isExecuted = true;
//        }
//    }
}
