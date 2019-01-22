/**
 * Created by BRITENET on 21.01.2019.
 */

public with sharing class Hospital_OrgInfoPagesController {
    public List<ApexPage> listVisualForcePages { get; set; }
    public String selectedPageId { get; set; }
    public ApexPage apexPage { get; set; }

    public Hospital_OrgInfoPagesController() {
        allVisualForcePages();
        apexPage = new ApexPage();
    }

    public void allVisualForcePages() {
        listVisualForcePages = [SELECT ApiVersion, Markup, CreatedBy.Name, CreatedDate, Id, LastModifiedBy.Name, LastModifiedDate, Name FROM ApexPage];
    }

    public void openPageClasses() {
        for (ApexPage oneElement : listVisualForcePages) {
            if (oneElement.Id.equals(selectedPageId)) {
                apexPage = oneElement;
                break;
            }
        }
    }
}