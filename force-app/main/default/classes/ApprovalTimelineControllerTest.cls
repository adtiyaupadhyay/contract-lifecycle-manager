@isTest
private class ApprovalTimelineControllerTest {
    
    @TestSetup
    static void setupData() {
        Contract__c contract = new Contract__c(
            Name = 'Timeline Test Contract',
            Status__c = 'Under Review',
            Contract_Value__c = 600000
        );
        insert contract;
        
        List<Approval_Step__c> steps = new List<Approval_Step__c>{
            new Approval_Step__c(
                Name = 'Manager Approval',
                Contract__c = contract.Id,
                Approver_Role__c = 'Manager',
                Step_Status__c = 'Approved',
                Step_Order__c = 1,
                Approved_Date__c = Date.today()
            ),
            new Approval_Step__c(
                Name = 'Finance Approval',
                Contract__c = contract.Id,
                Approver_Role__c = 'Finance',
                Step_Status__c = 'Pending',
                Step_Order__c = 2
            )
        };
        insert steps;
    }
    
    @isTest
    static void testGetApprovalSteps() {
        Contract__c contract = [SELECT Id FROM Contract__c LIMIT 1];
        
        Test.startTest();
        List<Approval_Step__c> steps = 
            ApprovalTimelineController.getApprovalSteps(contract.Id);
        Test.stopTest();
        
        System.assertEquals(2, steps.size(), 'Should return 2 approval steps');
        System.assertEquals('Manager Approval', steps[0].Name, 'First step should be Manager');
        System.assertEquals('Approved', steps[0].Step_Status__c, 'First step should be Approved');
    }
    
    @isTest
    static void testGetApprovalStepsEmptyContract() {
        Test.startTest();
        List<Approval_Step__c> steps = 
            ApprovalTimelineController.getApprovalSteps('001000000000000AAA');
        Test.stopTest();
        
        System.assertEquals(0, steps.size(), 'Should return empty list for invalid contract');
    }
}