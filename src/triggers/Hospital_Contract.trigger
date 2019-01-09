/**
 * Created by BRITENET on 13.12.2018.
 */

trigger Hospital_Contract on Contract__c (before insert, before update) {
    if (Trigger.isInsert || Trigger.isUpdate) {
        Hospital_ContractHandler.checkAvailabilityContract(trigger.new);
    }
}