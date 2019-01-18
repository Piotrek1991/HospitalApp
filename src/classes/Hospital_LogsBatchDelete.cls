/**
 * Created by BRITENET on 16.01.2019.
 */

global class Hospital_LogsBatchDelete implements Database.Batchable<sObject> {
    public String query;
    public Integer deleteTime;

    global Database.QueryLocator start(Database.BatchableContext BC){
        Datetime dateNow = Datetime.now();
        deleteTime = Hospital_DoctorUtils.getCsValueFromInteger('LogsDeleteTime');
        dateNow = dateNow.addDays(deleteTime);

        query = 'SELECT Id, DateTime__c FROM LogsFromWebService__c WHERE DateTime__c < '+dateNow.format('yyyy-MM-dd')+'T'+ dateNow.format('HH:mm')+':00.000Z';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> results){
        delete results;
    }

    global void finish(Database.BatchableContext BC){
    }
}