/**
 * Created by BRITENET on 18.12.2018.
 */

public with sharing class Hospital_ContractSearchController {

    private Contract__c contract;
    public List<Contract__c> contracts;
    public String selectedContractId { get; set; }
    private Date dateNow = date.today();
    private String sortOrder = 'Name';
    private String currentAsc = ' ASC';
    private final String ascending = ' ASC';
    private final String descending = ' DESC';

    public Hospital_ContractSearchController() {
        this.contract = new Contract__c();
    }

    public List<Contract__c> getContracts() {
        contracts = Database.query('SELECT Id, Start_Date__c, End_Date__c, Name, Email__c FROM Contract__c'
                + ' ORDER BY ' + sortOrder + currentAsc
        );
        return contracts;
    }

    public void removeContract() {
        Contract__c selectedContract = null;
        for (Contract__c oneContract : contracts)
            if (oneContract.Id == selectedContractId) {
                selectedContract = oneContract;
                break;
            }

        if (selectedContract.Start_Date__c <= dateNow && selectedContract.End_Date__c >= dateNow) {
            selectedContract.End_Date__c = dateNow;
            upsert selectedContract;
            return;
        }

        if (selectedContract.Start_Date__c > dateNow) {
            delete selectedContract;
        }
    }

    public void sortByEndDay() {
        currentAsc = ascending;
        this.sortOrder = 'End_Date__c';
        getContracts();
        replaceAscending();
    }

    public void sortByEmail() {
        currentAsc = ascending;
        this.sortOrder = 'Email__c';
        getContracts();
        replaceAscending();
    }

    public void sortByStartDay() {
        currentAsc = ascending;
        this.sortOrder = 'Start_Date__c';
        getContracts();
        replaceAscending();
    }

    public void sortByName() {
        currentAsc = ascending;
        this.sortOrder = 'Name';
        getContracts();
        replaceAscending();
    }

    private void replaceAscending() {
        if (ascending.equals(currentAsc)) {
            currentAsc = descending;
        } else {
            currentAsc = ascending;
        }
    }
}