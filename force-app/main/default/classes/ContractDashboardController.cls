public with sharing class ContractDashboardController {
    
    @AuraEnabled(cacheable=true)
    public static List<ContractWrapper> getContracts(String statusFilter) {
        
        String query = 'SELECT Id, Name, Status__c, Contract_Value__c, End_Date__c, Is_Locked__c ' +
                       'FROM Contract__c ';
        
        if (statusFilter != null && statusFilter != '' && statusFilter != 'All') {
            query += 'WHERE Status__c = :statusFilter ';
        }
        
        query += 'ORDER BY End_Date__c ASC NULLS LAST LIMIT 200';
        
        List<Contract__c> contracts = Database.query(query);
        List<ContractWrapper> wrappers = new List<ContractWrapper>();
        
        for (Contract__c c : contracts) {
            wrappers.add(new ContractWrapper(c));
        }
        
        return wrappers;
    }
    
    public class ContractWrapper {
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String status;
        @AuraEnabled public Decimal contractValue;
        @AuraEnabled public Date endDate;
        @AuraEnabled public Integer daysUntilExpiry;
        @AuraEnabled public Boolean isLocked;
        
        public ContractWrapper(Contract__c c) {
            this.id = c.Id;
            this.name = c.Name;
            this.status = c.Status__c;
            this.contractValue = c.Contract_Value__c;
            this.endDate = c.End_Date__c;
            this.isLocked = c.Is_Locked__c;
            
            if (c.End_Date__c != null) {
                this.daysUntilExpiry = Date.today().daysBetween(c.End_Date__c);
            }
        }
    }
}