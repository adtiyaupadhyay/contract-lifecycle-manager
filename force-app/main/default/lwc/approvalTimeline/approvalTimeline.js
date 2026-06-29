import { LightningElement, api, track } from 'lwc';
import getApprovalSteps from '@salesforce/apex/ApprovalTimelineController.getApprovalSteps';

export default class ApprovalTimeline extends LightningElement {
    @api recordId;
    @track steps;
    @track error;
    @track isLoading = true;

    connectedCallback() {
        this.loadSteps();
    }

    loadSteps() {
        this.isLoading = true;
        getApprovalSteps({ contractId: this.recordId })
            .then(data => {
                this.steps = data.map(step => ({
                    ...step,
                    iconName: this.getIconName(step.Step_Status__c),
                    iconClass: this.getIconClass(step.Step_Status__c),
                    badgeClass: this.getBadgeClass(step.Step_Status__c)
                }));
                this.error = undefined;
                this.isLoading = false;
            })
            .catch(error => {
                this.error = error;
                this.steps = undefined;
                this.isLoading = false;
            });
    }

    get hasSteps() {
        return this.steps && this.steps.length > 0;
    }

    getIconName(status) {
        switch (status) {
            case 'Approved':  return 'utility:success';
            case 'Rejected':  return 'utility:error';
            case 'Pending':   return 'utility:clock';
            default:          return 'utility:help';
        }
    }

    getIconClass(status) {
        switch (status) {
            case 'Approved':  return 'slds-icon_container slds-icon-utility-success';
            case 'Rejected':  return 'slds-icon_container slds-icon-utility-error';
            case 'Pending':   return 'slds-icon_container slds-icon-utility-clock';
            default:          return 'slds-icon_container';
        }
    }

    getBadgeClass(status) {
        switch (status) {
            case 'Approved':  return 'slds-badge slds-theme_success';
            case 'Rejected':  return 'slds-badge slds-theme_error';
            case 'Pending':   return 'slds-badge slds-theme_warning';
            default:          return 'slds-badge';
        }
    }
}