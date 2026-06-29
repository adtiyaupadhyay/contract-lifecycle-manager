public with sharing class ApprovalTimelineController {
    
    @AuraEnabled
    public static List<Approval_Step__c> getApprovalSteps(String contractId) {
        return [
            SELECT Id, Name, Approver_Role__c, Step_Status__c, Approved_Date__c, Comments__c,
                   Step_Order__c, Contract__c
            FROM Approval_Step__c
            WHERE Contract__c = :contractId
            ORDER BY Step_Order__c ASC NULLS LAST
        ];
    }
}