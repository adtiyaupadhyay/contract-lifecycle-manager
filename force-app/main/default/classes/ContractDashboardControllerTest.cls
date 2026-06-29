@isTest
private class ContractDashboardControllerTest {
    
    @TestSetup
    static void setupData() {
        List<Contract__c> contracts = new List<Contract__c>{
            new Contract__c(
                Name = 'Test Contract Alpha',
                Status__c = 'Draft',
                Contract_Value__c = 100000,
                End_Date__c = Date.today().addDays(7)
            ),
            new Contract__c(
                Name = 'Test Contract Beta',
                Status__c = 'Active',
                Contract_Value__c = 600000,
                End_Date__c = Date.today().addDays(30)
            ),
            new Contract__c(
                Name = 'Test Contract Gamma',
                Status__c = 'Draft',
                Contract_Value__c = 200000,
                End_Date__c = Date.today().addDays(15)
            )
        };
        insert contracts;
    }
    
    @isTest
    static void testGetAllContracts() {
        Test.startTest();
        List<ContractDashboardController.ContractWrapper> results = 
            ContractDashboardController.getContracts('All');
        Test.stopTest();
        
        System.assertEquals(3, results.size(), 'Should return all 3 contracts');
    }
    
    @isTest
    static void testGetContractsByStatus() {
        Test.startTest();
        List<ContractDashboardController.ContractWrapper> results = 
            ContractDashboardController.getContracts('Draft');
        Test.stopTest();
        
        System.assertEquals(2, results.size(), 'Should return 2 Draft contracts');
    }
    
    @isTest
    static void testDaysUntilExpiryCalculation() {
        Test.startTest();
        List<ContractDashboardController.ContractWrapper> results = 
            ContractDashboardController.getContracts('All');
        Test.stopTest();
        
        for (ContractDashboardController.ContractWrapper w : results) {
            System.assertNotEquals(null, w.daysUntilExpiry, 'Days until expiry should be set');
        }
    }
}