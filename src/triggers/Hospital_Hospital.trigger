/**
 * Created by BRITENET on 10.01.2019.
 */

trigger Hospital_Hospital on Hospital__c (before insert, before update, before delete, after insert, after update, after delete ) {
    if(Hospital_Utils.isTriggerEnabled('Hospital_Hospital__c')){
        Hospital_TriggerFactory.createHandler(Hospital__c.getSObjectType());
    }
}
