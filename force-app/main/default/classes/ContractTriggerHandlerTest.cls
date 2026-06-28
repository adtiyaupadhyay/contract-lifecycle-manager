@isTest
public class ContractTriggerHandlerTest {

    @isTest
    static void testStatusChangeToUnderReview_CreatesApprovalSteps() {
        Contract__c con = new Contract__c();
        con.Name = 'Trigger Test Contract';
        con.Status__c = 'Draft';
        con.Contract_Value__c = 6000000;
        con.Start_Date__c = Date.today();
        con.End_Date__c = Date.today().addYears(1);
        con.Client_Name__c = 'Trigger Test Client';
        insert con;

        Test.startTest();
        con.Status__c = 'Under Review';
        update con;
        Test.stopTest();

        List<Approval_Step__c> steps = [SELECT Id, Approver_Role__c FROM Approval_Step__c WHERE Contract__c = :con.Id];
        System.assertEquals(3, steps.size(), 'High value contract moving to Under Review should create 3 approval steps');
    }

    @isTest
    static void testStatusChangeToSomethingElse_DoesNotCreateApprovalSteps() {
        Contract__c con = new Contract__c();
        con.Name = 'Trigger Test Contract 2';
        con.Status__c = 'Draft';
        con.Contract_Value__c = 6000000;
        con.Start_Date__c = Date.today();
        con.End_Date__c = Date.today().addYears(1);
        con.Client_Name__c = 'Trigger Test Client 2';
        insert con;

        Test.startTest();
        con.Status__c = 'Rejected';
        update con;
        Test.stopTest();

        List<Approval_Step__c> steps = [SELECT Id FROM Approval_Step__c WHERE Contract__c = :con.Id];
        System.assertEquals(0, steps.size(), 'Changing to a status other than Under Review should not create approval steps');
    }

    @isTest
    static void testRepeatedSaveWithoutStatusChange_DoesNotDuplicateSteps() {
        Contract__c con = new Contract__c();
        con.Name = 'Trigger Test Contract 3';
        con.Status__c = 'Under Review';
        con.Contract_Value__c = 100000;
        con.Start_Date__c = Date.today();
        con.End_Date__c = Date.today().addYears(1);
        con.Client_Name__c = 'Trigger Test Client 3';
        insert con;

        Test.startTest();
        con.Client_Name__c = 'Updated Client Name';
        update con;
        Test.stopTest();

        List<Approval_Step__c> steps = [SELECT Id FROM Approval_Step__c WHERE Contract__c = :con.Id];
        System.assertEquals(0, steps.size(), 'No approval steps should be created since contract was already Under Review before this update, and only Client Name changed');
    }
}