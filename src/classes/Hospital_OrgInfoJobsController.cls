/**
 * Created by BRITENET on 22.01.2019.
 */

public with sharing class Hospital_OrgInfoJobsController {
    public List<AsyncApexJob> jobsList { get; set; }

    public Hospital_OrgInfoJobsController() {
        getAllApexJobs();
    }

    public void getAllApexJobs() {
        String futureString = 'Future';
        jobsList = [
                SELECT ID, JobItemsProcessed, TotalJobItems, Status, JobType, CreatedDate, MethodName, ApexClass.Name
                FROM AsyncApexJob
                WHERE JobType = :futureString
                ORDER BY CreatedDate DESC
        ];
    }
}