trigger CountContactOnAccount on Contact (after INSERT, after UPDATE, after DELETE ) {

Set <Id> accountIds = new Set <Id>();
List <Account> listOfAccountsToUpdate = new List <Account>();

 if(Trigger.isInsert){
    for(Contact con:trigger.new){
        accountIds.add(con.accountID);
    }
}

if(Trigger.isUpdate|| Trigger.isDelete){
    for(Contact con:trigger.old){
        accountIds.add(con.accountID);
    }
}

for(Account acc:[SELECT Id,Name,Count_Contacts__c,(Select Id from Contacts) from Account where Id IN: accountIds]){
    Account accObj = new Account ();
    accObj.Id = acc.Id;
    accObj.Count_Contacts__c = acc.Contacts.size();
    listOfAccountsToUpdate.add(accObj);
}

UPDATE listOfAccountsToUpdate;
}