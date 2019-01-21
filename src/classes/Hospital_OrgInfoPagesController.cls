/**
 * Created by BRITENET on 21.01.2019.
 */

public with sharing class Hospital_OrgInfoPagesController {
    public List<ApexPage> listVisualForcePages { get; set; }

    public Hospital_OrgInfoPagesController() {
        allVisualForcePages();
    }

    public void allVisualForcePages(){
        listVisualForcePages = [SELECT ApiVersion, Markup, CreatedBy.Name, CreatedDate, Id, LastModifiedBy.Name, LastModifiedDate, Name FROM ApexPage ];
    }
}