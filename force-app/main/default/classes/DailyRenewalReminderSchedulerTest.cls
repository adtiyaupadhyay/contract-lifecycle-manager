@isTest
public class DailyRenewalReminderSchedulerTest {

    @isTest
    static void testScheduler_EnqueuesQueueableJob() {
        Test.startTest();
        String cronExpression = '0 0 6 * * ?';
        System.schedule('Test Daily Renewal Reminder Job', cronExpression, new DailyRenewalReminderScheduler());
        Test.stopTest();

        List<CronTrigger> scheduledJobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Test Daily Renewal Reminder Job'];
        System.assertEquals(1, scheduledJobs.size(), 'The job should be scheduled successfully');
    }
}