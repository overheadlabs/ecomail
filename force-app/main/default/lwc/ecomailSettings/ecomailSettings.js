import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import synchronize from '@salesforce/apex/EcomailSettingsController.synchronize';


export default class EcomailSettings extends LightningElement {

    handleSyncAllContacts(event) {
        this.callSyncer('Contact');
    } 

    handleSyncAllLeads(event) {
        this.callSyncer('Lead');
    } 

    handleSyncAllCampaigns(event) {
        this.callSyncer('Campaign');
    } 

    callSyncer(objName) {
        synchronize({ objName })
            .then(result => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Started',
                    message: 'Synchronization has started. Just wait.',
                    variant: 'success'
                }));
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: error,
                    variant: 'success'
                }));
            });
    }
}