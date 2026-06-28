public class RenewalReminderQueueable implements Queueable {

    public void execute(QueueableContext context) {

        Date today = Date.today();
        Date in7Days = today.addDays(7);
        Date in15Days = today.addDays(15);
        Date in30Days = today.addDays(30);

        List<Contract__c> contractsNeedingReminders = [
            SELECT Id, Name, End_Date__c, OwnerId, Owner.Email, Owner.Name
            FROM Contract__c
            WHERE Status__c = 'Active'
            AND End_Date__c IN (:in7Days, :in15Days, :in30Days)
        ];

        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        for (Contract__c con : contractsNeedingReminders) {
            if (con.Owner.Email == null) {
                continue;
            }

            Integer daysLeft = con.End_Date__c.daysBetween(today) * -1;

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{ con.Owner.Email });
            email.setSubject('Contract Renewal Reminder: ' + con.Name);
            email.setPlainTextBody(
                'Hi ' + con.Owner.Name + ',\n\n' +
                'The contract "' + con.Name + '" is expiring in ' + daysLeft + ' days (on ' + con.End_Date__c.format() + ').\n' +
                'Please review and initiate renewal if needed.\n\n' +
                'This is an automated reminder.'
            );
            emailsToSend.add(email);
        }

        if (!emailsToSend.isEmpty()) {
            try {
                Messaging.sendEmail(emailsToSend);
            } catch (Exception e) {
                System.debug('Error sending renewal reminder emails: ' + e.getMessage());
            }
        }
    }
}