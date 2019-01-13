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

        if (Trigger.isInsert) {
            Boolean isExecuted2 = false;
            while (!isExecuted2) {
                System.debug('Trigger.newMap.keySet()'+ Trigger.newMap.keySet());
                Hospital_HospitalTriggerHandler.assignIdToExternalID(Trigger.newMap.keySet());
                isExecuted2 = true;
            }
        }


    } else if (Trigger.isDelete) {
        Boolean isExecuted = false;
        while (!isExecuted) {
            Hospital_HospitalTriggerHandler.deleteHospitalData(Trigger.oldMap.keySet());
            isExecuted = true;
        }
    }



}