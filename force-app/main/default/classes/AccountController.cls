public with sharing class AccountController {
    public AccountController() {

    }
    public static List<Account> getAllActiveAccounts(){
        return [SELECT Id, Name FROM Account];
    }
}
