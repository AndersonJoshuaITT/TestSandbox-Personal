public class ContactSearch {
    public  static Map<String,Integer> ContactSearchWithEmail(String firstname, String email){
   Map<String,Integer> contactEmailCount=new Map<String,Integer>();
			List<AggregateResult> 
			acc = [SELECT count(Name),Email FROM Contact WHERE FirstName=:firstname AND Email=:email GROUP BY Email HAVING count(Name)>1];
                for(AggregateResult aggres : acc)
                {
	contactEmailCount.put((String)aggres.get('Email'),(Integer)aggres.get('expr0'));
                }
                            // Query for the Duplicate email to see if it exist.
                            List<Duplicate__c> queriedDuplicate = [SELECT Email__c 
                                                      FROM Duplicate__c  
                                                      WHERE Email__c = :email
                                                      ];
        If(!queriedDuplicate.isempty()){
    						// if email exist Update Number of Dupliactes 
                            queriedDuplicate[0].Number_of_Duplicates__c  =contactEmailCount.get(email);
							 // 1. This call is to update Duplicate amount
                            update queriedDuplicate;
        }
                            
        Else{
                             Duplicate__c  dup = new Duplicate__c(Email__c =email,Number_of_Duplicates__c = contactEmailCount.get(email));
    						insert dup;
        }
        return contactEmailCount;
       }
}