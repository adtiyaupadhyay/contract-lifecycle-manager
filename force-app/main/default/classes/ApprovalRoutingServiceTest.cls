@isTest
public class ApprovalRoutingServiceTest {

    @TestSetup
    static void setupData() {
        Contract__c testContract = new Contract__c();
        testContract.Name = 'Test Contract';
        testContract.Status__c = 'Draft';
        testContract.Contract_Value__c = 100000;
        testContract.Start_Date__c = Date.today();
        testContract.End_Date__c = Date.today().addYears(1);
        testContract.Client_Name__c = 'Test Client';
        insert testContract;
    }

    @isTest
    static void testLowValueContract_CreatesOnlyManagerStep() {
        Contract__c con = [SELECT Id FROM Contract__c LIMIT 1];

        Test.startTest();
        ApprovalRoutingService.createApprovalSteps(con.Id, 100000);
        Test.stopTest();

        List<Approval_Step__c> steps = [SELECT Id, Approver_Role__c FROM Approval_Step__c WHERE Contract__c = :con.Id];
        System.assertEquals(1, steps.size(), 'Low value contract should create only 1 approval step');
        System.assertEquals('Manager', steps[0].Approver_Role__c);
    }

    @isTest
    static void testMidValueContract_CreatesManagerAndFinanceSteps() {
        Contract__c con = [SELECT Id FROM Contract__c LIMIT 1];

        Test.startTest();
        ApprovalRoutingService.createApprovalSteps(con.Id, 2000000);
        Test.stopTest();

        List<Approval_Step__c> steps = [SELECT Id, Approver_Role__c FROM Approval_Step__c WHERE Contract__c = :con.Id];
        System.assertEquals(2, steps.size(), 'Mid value contract should create 2 approval steps');
    }

    @isTest
    static void testHighValueContract_CreatesAllThreeSteps() {
        Contract__c con = [SELECT Id FROM Contract__c LIMIT 1];

        Test.startTest();
        ApprovalRoutingService.createApprovalSteps(con.Id, 6000000);
        Test.stopTest();

        List<Approval_Step__c> steps = [SELECT Id, Approver_Role__c FROM Approval_Step__c WHERE Contract__c = :con.Id];
        System.assertEquals(3, steps.size(), 'High value contract should create 3 approval steps');
    }
}