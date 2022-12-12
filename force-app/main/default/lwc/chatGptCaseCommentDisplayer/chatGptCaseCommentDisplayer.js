// caseComments.js
import { LightningElement, api } from 'lwc';
import getCaseComments from '@salesforce/apex/CaseCommentService.getCaseComments';

const COLUMNS = [
    { label: 'Comment Body', fieldName: 'CommentBody' },
    { label: 'Created By', fieldName: 'CreatedByName' },
    { label: 'Created Date', fieldName: 'CreatedDate' },
];

export default class CaseComments extends LightningElement {
    @api recordId;
    columns = COLUMNS;
    caseComments;
    error;

    connectedCallback() {
        getCaseComments({ caseId: this.recordId })
            .then(result => {
                this.caseComments = result;
            })
            .catch(error => {
                this.error = error;
            });
    }
}
