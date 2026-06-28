public with sharing class ContractTriggerHandler {

    public static void handleAfterUpdate(List<Contract__c> newContracts, Map<Id, Contract__c> oldContractsMap) {

        for (Contract__c con : newContracts) {
            Contract__c oldCon = oldContractsMap.get(con.Id);

            Boolean statusChangedToUnderReview =
                con.Status__c == 'Under Review' &&
                oldCon.Status__c != 'Under Review';

            if (statusChangedToUnderReview) {
                ApprovalRoutingService.createApprovalSteps(con.Id, con.Contract_Value__c);
            }
        }
    }
}