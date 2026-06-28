public with sharing class ApprovalRoutingService {

    public static void createApprovalSteps(Id contractId, Decimal contractValue) {

        List<Approval_Step__c> stepsToInsert = new List<Approval_Step__c>();

        Approval_Step__c managerStep = new Approval_Step__c();
        managerStep.Contract__c = contractId;
        managerStep.Approver_Role__c = 'Manager';
        managerStep.Step_Order__c = 1;
        managerStep.Step_Status__c = 'Pending';
        stepsToInsert.add(managerStep);

        if (contractValue >= 500000 && contractValue <= 5000000) {
            Approval_Step__c financeStep = new Approval_Step__c();
            financeStep.Contract__c = contractId;
            financeStep.Approver_Role__c = 'Finance';
            financeStep.Step_Order__c = 2;
            financeStep.Step_Status__c = 'Pending';
            stepsToInsert.add(financeStep);
        }

        if (contractValue > 5000000) {
            Approval_Step__c financeStep = new Approval_Step__c();
            financeStep.Contract__c = contractId;
            financeStep.Approver_Role__c = 'Finance';
            financeStep.Step_Order__c = 2;
            financeStep.Step_Status__c = 'Pending';
            stepsToInsert.add(financeStep);

            Approval_Step__c directorStep = new Approval_Step__c();
            directorStep.Contract__c = contractId;
            directorStep.Approver_Role__c = 'Director';
            directorStep.Step_Order__c = 3;
            directorStep.Step_Status__c = 'Pending';
            stepsToInsert.add(directorStep);
        }

        if (!stepsToInsert.isEmpty()) {
            insert stepsToInsert;
        }
    }
}