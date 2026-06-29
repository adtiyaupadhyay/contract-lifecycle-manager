import { LightningElement, api, track } from 'lwc';
import suggestClauses from '@salesforce/apex/ClauseSuggestionService.suggestClauses';

export default class ClauseSuggestion extends LightningElement {
    @api recordId;
    @api contractName;
    @api contractValue;
    @api contractStatus;
    
    @track suggestions;
    @track error;
    @track isLoading = false;

    handleSuggestClauses() {
        this.isLoading = true;
        this.suggestions = undefined;
        this.error = undefined;

        suggestClauses({
            contractName: this.contractName || 'General Contract',
            contractValue: this.contractValue ? String(this.contractValue) : '0',
            contractStatus: this.contractStatus || 'Draft'
        })
        .then(result => {
            this.suggestions = result;
            this.isLoading = false;
        })
        .catch(error => {
            this.error = error.body ? error.body.message : 'An error occurred';
            this.isLoading = false;
        });
    }
}