/**
 * Created by BRITENET on 21.01.2019.
 */

public with sharing class Hospital_OrgInfoApexClassesController {
    public List<ApexClass> listApexClasses { get; set; }

    public Hospital_OrgInfoApexClassesController() {
        allApexClasses();
    }

    public void allApexClasses(){
        listApexClasses = [SELECT ApiVersion, Body, CreatedById, CreatedBy.Name, CreatedDate, Id,
                LastModifiedById, LastModifiedBy.Name, LastModifiedDate, Name FROM ApexClass LIMIT 10000];
    }
}