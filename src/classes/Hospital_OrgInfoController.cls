/**
 * Created by BRITENET on 20.01.2019.
 */

public class Hospital_OrgInfoController {
    public User selectedUser { get; set; }
    public List<LoginHistory> loginHistory { get; set; }
    public String activateDeactivate { get; set; }
    public String emailField { get; set; }
    public User currentUser { get; set; }
    public Doctor__c doctor { get; set; }
    public List<User> usersInOrg { get; set; }
    public Integer numberOfActiveUser { get; set; }
    public String orgId { get; set; }
    public String selectedUserId { get; set; }
    public String thisInstancesName { get; set; }
    public String sfdcURL { get; set; }
    public String sessionId { get {return UserInfo.getSessionId();} set; }
    public Integer userLicense { get {return getTotalNumberOfUserLicense();} set; }
    public Boolean isAnyInsertProblem { get; set; }

    public Hospital_OrgInfoController() {
        getUser();
        usersInOrg = getAllUsersFromOrg();
        numberOfActiveUser = getAmountActiveUser();
        orgId = getOrgId();
        getOrganizationInfo();
        sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        loginHistory = new List<LoginHistory>();
        selectedUser = new User();
        isAnyInsertProblem = true;
    }

    public void getUser() {
        String userId = UserInfo.getUserId();
        List<User> currentUsers = [SELECT Id,Name, Address, IsActive, Email FROM User WHERE Id = :userId];
        currentUser = currentUsers.get(0);
    }

    public Integer getAmountActiveUser() {
        List<User> users = [SELECT Id,Name, IsActive, Email FROM User WHERE IsActive = true];
        return users.size();
    }

    public String getOrgId() {
        return UserInfo.getOrganizationId();
    }

    public List<User> getAllUsersFromOrg() {
        List<User> allUsers = [SELECT Id, Name, IsActive, Email FROM User ORDER BY Name];
        return allUsers;
    }

    public void activeUser() {
        for (User selectedUser : usersInOrg) {
            if (selectedUser.Id.equals(selectedUserId)) {
                selectedUser.IsActive = !selectedUser.IsActive;
                update selectedUser;
                break;
            }
        }
        usersInOrg = getAllUsersFromOrg();
        numberOfActiveUser = getAmountActiveUser();
    }

    public void getOrganizationInfo() {
        Organization orgInfo = [SELECT Id, InstanceName FROM Organization];
        thisInstancesName = orgInfo.InstanceName;
    }

    public void resetPassword() {
        System.resetPassword(selectedUserId, true);
    }

    public Integer getTotalNumberOfUserLicense() {
        return [SELECT COUNT() FROM UserLicense];
    }

    public void generateUserAndHistory() {
        isAnyInsertProblem = true;
        emailField = '';
        System.debug('selectedUser' + selectedUser);

        for (User oneUser : usersInOrg) {
            if (oneUser.Id.equals(selectedUserId)) {
                selectedUser = oneUser;
                break;
            }
        }
        System.debug('selectedUser' + selectedUser);
        if (selectedUser.IsActive) {
            activateDeactivate = 'Deactivate';
        } else {
            activateDeactivate = 'Activate';
        }
        loginHistory = [
                SELECT
                        UserId,
                        LoginTime,
                        SourceIp,
                        Platform,
                        Browser
                FROM LoginHistory
                WHERE UserId = :selectedUserId
                AND LoginTime = LAST_N_DAYS:30
                ORDER BY LoginTime DESC
                LIMIT 1000
        ];
    }

    public void changeEmail() {
        try {
            isAnyInsertProblem = false;
            update selectedUser;
        } catch (Exception ex){
            isAnyInsertProblem = true;
        }
        System.debug('isAnyInsertProblem >>'+ isAnyInsertProblem);
        usersInOrg = getAllUsersFromOrg();
    }

    public void changeEmailResetPassword() {
        changeEmail();
        resetPassword();
    }

    public PageReference goToApexPage() {
        PageReference apexClassesPage = Page.Hospital_OrgInfoApexClasses;
        apexClassesPage.getParameters().put('pageReferenceURL', ApexPages.currentPage().getUrl());
        apexClassesPage.setRedirect(true);

        return apexClassesPage;
    }

    public PageReference goToVisualforcePage() {
        PageReference apexClassesPage = Page.Hospital_OrgInfoPages;
        apexClassesPage.getParameters().put('pageReferenceURL', ApexPages.currentPage().getUrl());
        apexClassesPage.setRedirect(true);

        return apexClassesPage;
    }

    public PageReference goToJobsPage() {
        PageReference jobsPage = Page.Hospital_OrgInfoJobs;
        jobsPage.getParameters().put('pageReferenceURL', ApexPages.currentPage().getUrl());
        jobsPage.setRedirect(true);

        return jobsPage;
    }
}