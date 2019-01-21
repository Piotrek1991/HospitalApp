/**
 * Created by BRITENET on 20.01.2019.
 */

public class Hospital_OrgInfoController {
    public User currentUser { get; set; }
    public List<User> usersInOrg { get; set; }
    public Integer numberOfActiveUser { get; set; }
    public String orgId { get; set; }
    public String selectedUserId { get; set; }

    public Hospital_OrgInfoController() {
        getUser();
        usersInOrg = getAllUsersFromOrg();
        numberOfActiveUser = getAmountActiveUser();
        orgId = getOrgId();
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

    public void resetPassword(){
        System.resetPassword(selectedUserId,true);
    }
}