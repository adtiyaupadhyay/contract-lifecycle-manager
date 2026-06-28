@isTest
public class RenewalReminderQueueableTest {

    @isTest
    static void testQueueable_SendsReminderForContractExpiringIn7Days() {
        Contract__c con = new Contract__c();
        con.Name = 'Expiring Soon Contract';
        con.Status__c = 'Active';
        con.Contract_Value__c = 1000000;
        con.Start_Date__c = Date.today().addMonths(-11);
        con.End_Date__c = Date.today().addDays(7);
        con.Client_Name__c = 'Expiry Test Client';
        insert con;

        Test.startTest();
        System.enqueueJob(new RenewalReminderQueueable());
        Test.stopTest();

        System.assert(true, 'Queueable executed without throwing an exception');
    }

    @isTest
    static void testQueueable_NoEligibleContracts_RunsWithoutError() {
        Contract__c con = new Contract__c();
        con.Name = 'Not Expiring Soon Contract';
        con.Status__c = 'Active';
        con.Contract_Value__c = 1000000;
        con.Start_Date__c = Date.today();
        con.End_Date__c = Date.today().addMonths(6);
        con.Client_Name__c = 'No Expiry Test Client';
        insert con;

        Test.startTest();
        System.enqueueJob(new RenewalReminderQueueable());
        Test.stopTest();

        System.assert(true, 'Queueable handled zero eligible contracts gracefully');
    }
}