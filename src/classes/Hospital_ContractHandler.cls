/**
 * Created by BRITENET on 13.12.2018.
 */

public with sharing class Hospital_ContractHandler {

    private List<Contract__c> contracts = new List<Contract__c>();

    public static List<Contract__c> checkAvailabilityContract(List<Contract__c> newContracts) {

        for (Contract__c newContract : newContracts) {
            String messageToUser = '';
            List<Contract__c> incorrectContracts = new List<Contract__c>();
            List<Contract__c> doctorContracts = getDoctorContracts(newContract.Doctor_Id__c, newContract.Hospital_Id__c, newContract);
            for (Contract__c contract : doctorContracts) {
                if ((newContract.Start_Date__c >= contract.Start_Date__c && newContract.Start_Date__c <= contract.End_Date__c) ||
                        (newContract.End_Date__c >= contract.Start_Date__c && newContract.End_Date__c <= contract.End_Date__c) ||
                        (newContract.Start_Date__c < contract.Start_Date__c && newContract.End_Date__c > contract.End_Date__c)
                        ) {
                    incorrectContracts.add(contract);
                    newContract.addError(String.format(Label.YoucannotcreatethisNewContract, new List<String>{contract.Name, contract.Start_Date__c.format(), contract.End_Date__c.format() }));
                }
            }
        }
        return null;
    }

    static List<Contract__c> getDoctorContracts(String doctorId, String hospitalId, Contract__c contractCheck) {
        return [
                SELECT Id, Name, Start_Date__c, End_Date__c, Hospital_Id__c, Doctor_Id__c, IsFinished__c
                FROM Contract__c
                WHERE Doctor_Id__c = :doctorId
                AND Hospital_Id__c = :hospitalId
                AND IsFinished__c = false
                AND Start_Date__c >= :contractCheck.Start_Date__c
                ORDER BY Start_Date__c
        ];
    }
}