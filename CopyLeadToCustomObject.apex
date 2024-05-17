public class CopyLeadToCustomObject {
    @InvocableMethod
    public static void copyLead(List<Id> leadIds) {
        // Querying necessary Lead data
        // title, NACIS, Annual, Revenue Total, Status
        List<Lead> leads = [SELECT LastName, FirstName, Title, NAICS__c, Annual_Revenue_Total__c, Status, Phone, Email FROM Lead WHERE Id IN :leadIds];
               
        // List to hold custom objects to be inserted
        List<Application__c> applications = new List<Application__c>();

        // Loop through each lead and create a custom object record
        for (Lead lead : leads) {
            Application__c application = new Application__c();
            application.First_Name__c = lead.FirstName;
            application.Last_Name__c = lead.LastName; 
            application.Title__c = lead.Title;
            application.NAICS__c = lead.NAICS__c;
            application.Annual_Revenue_Total__c = lead.Annual_Revenue_Total__c;
            application.Phone__c = lead.Phone;
            application.Email__c = lead.Email;
            applications.add(application);
        }

        // Insert the new custom object records
        if (!applications.isEmpty()) {
            insert applications;
        }
    }
}