public class DailyRenewalReminderScheduler implements Schedulable {

    public void execute(SchedulableContext context) {
        System.enqueueJob(new RenewalReminderQueueable());
    }
}