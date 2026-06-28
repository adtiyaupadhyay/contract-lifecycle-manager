trigger ContractTrigger on Contract__c (after update) {

    if (Trigger.isAfter && Trigger.isUpdate) {
        ContractTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}