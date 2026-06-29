import { LightningElement, track, wire } from 'lwc';
import getContracts from '@salesforce/apex/ContractDashboardController.getContracts';

const STATUS_OPTIONS = [
    { label: 'All', value: 'All' },
    { label: 'Draft', value: 'Draft' },
    { label: 'Under Review', value: 'Under Review' },
    { label: 'Active', value: 'Active' },
    { label: 'Renewed', value: 'Renewed' },
    { label: 'Expired', value: 'Expired' }
];

export default class ContractDashboard extends LightningElement {
    @track selectedStatus = 'All';
    @track contracts;
    @track error;
    @track isLoading = false;

    statusOptions = STATUS_OPTIONS;

    @wire(getContracts, { statusFilter: '$selectedStatus' })
    wiredContracts({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.contracts = data.map(c => ({
                ...c,
                recordUrl: `/lightning/r/Contract__c/${c.id}/view`,
                statusBadgeClass: this.getStatusBadgeClass(c.status),
                daysClass: this.getDaysClass(c.daysUntilExpiry),
                lockedLabel: c.isLocked ? '🔒 Yes' : 'No'
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contracts = undefined;
        }
    }

    get hasContracts() {
        return this.contracts && this.contracts.length > 0;
    }

    handleStatusChange(event) {
        this.isLoading = true;
        this.selectedStatus = event.detail.value;
    }

    getStatusBadgeClass(status) {
        const base = 'slds-badge ';
        switch (status) {
            case 'Active':     return base + 'slds-badge_lightest' + ' badge-active';
            case 'Draft':      return base + 'badge-draft';
            case 'Under Review': return base + 'badge-review';
            case 'Renewed':    return base + 'badge-renewed';
            case 'Expired':    return base + 'badge-expired';
            default:           return base;
        }
    }

    getDaysClass(days) {
        if (days === null || days === undefined) return '';
        if (days <= 7)  return 'days-critical';
        if (days <= 30) return 'days-warning';
        return 'days-ok';
    }
}