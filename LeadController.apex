public class LeadController {
    private final Lead lead;

    public LeadController(ApexPages.StandardController stdController) {
        this.lead = (Lead)stdController.getRecord();
    }

    // Method to find an existing duplicate lead
    private Id findDuplicateLeadId() {
        // Example: Check for duplicate based on Email
        List<Lead> duplicates = [SELECT Id FROM Lead WHERE Email = :lead.Email AND Id != :lead.Id LIMIT 1];
        if (!duplicates.isEmpty()) {
            return duplicates[0].Id;
        }
        return null;
    }

    // Method to save or update a lead
    public PageReference saveLead() {
        Id duplicateLeadId = findDuplicateLeadId();
        if (duplicateLeadId != null) {
            // Update the existing lead
            lead.Id = duplicateLeadId; // Set ID of the duplicate lead to ensure update
        }

        try {
            upsert lead;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Lead saved successfully.'));
            return null; // Stay on the same page
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error saving lead: ' + e.getMessage()));
            return null;
        }
    }

    public PageReference cancel() {
        return (new ApexPages.StandardController(lead)).view();
    }
}