/**
 * Created by BRITENET on 16.01.2019.
 */

global class Hospital_HospitalBatchDelete implements Database.Batchable<sObject>, Database.Stateful{
    public String query;

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        delete scope;
        DataBase.emptyRecycleBin(scope);
    }

    global void finish(Database.BatchableContext BC){
    }
}