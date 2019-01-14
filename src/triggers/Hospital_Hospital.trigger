/**
 * Created by BRITENET on 10.01.2019.
 */

trigger Hospital_Hospital on Hospital__c (after insert, after update, after delete) {

    if (Trigger.isInsert || Trigger.isUpdate) {
        Boolean isExecuted = false;
        while (!isExecuted) {
            System.debug('Trigger.newMap.keySet()'+ Trigger.newMap.keySet());
            Hospital_HospitalTriggerHandler.sendHospitalData(Trigger.newMap.keySet());
            isExecuted = true;
        }


    } else if (Trigger.isDelete) {
        Boolean isExecuted = false;
        while (!isExecuted) {
            Hospital_HospitalTriggerHandler.deleteHospitalData(Trigger.oldMap.keySet());
            isExecuted = true;
        }
    }



}




//trigger Hospital_Hospital on Hospital__c (before insert, after delete) {
//
//
//    if (Trigger.isInsert) {
//        if(Trigger.isBefore){
//            Boolean isExecuted = false;
//            while (!isExecuted) {
//                System.debug('Trigger.newMap.keySet()');
//                Set<Id> listOfHospital = new Set<Id>();
//
//                for(Hospital__c hospital : trigger.new){
//                    listOfHospital.add(hospital.Id);
//                }
//                System.debug('Trigger.newMap.keySet()2222222' + listOfHospital);
//
//                Hospital_HospitalTriggerHandler.sendHospitalData(listOfHospital);
//                System.debug('Trigger.newMap.keySet()2222222' + listOfHospital);
//
////            Hospital_HospitalTriggerHandler.assignIdToExternalID(Trigger.newMap.keySet());
//
//                isExecuted = true;
//            }
//
//
//        }
//
////    if (Trigger.isInsert) {
////        if(Trigger.isInsert){
////            Boolean isExecuted = false;
////            while (!isExecuted) {
////                System.debug('Trigger.newMap.keySet()' + Trigger.newMap.keySet());
////                Hospital_HospitalTriggerHandler.sendHospitalData(Trigger.newMap.keySet());
////                System.debug('Trigger.newMap.keySet()2222222' + Trigger.newMap.keySet());
////
//////            Hospital_HospitalTriggerHandler.assignIdToExternalID(Trigger.newMap.keySet());
////
////                isExecuted = true;
////            }
////
////        }
//
//
//    } else if (Trigger.isDelete) {
//        Boolean isExecuted = false;
//        while (!isExecuted) {
//            Hospital_HospitalTriggerHandler.deleteHospitalData(Trigger.oldMap.keySet());
//            isExecuted = true;
//        }
//    }
//
//
//}