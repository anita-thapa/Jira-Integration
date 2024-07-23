import { LightningElement, wire, track, api } from 'lwc';
import getProjectName from '@salesforce/apex/GetProjectDetails.getProjectName';
import performHttpRequestWithNamedCredential from '@salesforce/apex/JiraRestClient.performHttpRequestWithNamedCredential';
//import processProjectTime from '@salesforce/apex/GetProjectNameAndTime.processProjectTime';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MyComponent extends LightningElement {
    projectOptions = [];
    selectedProject = '';

    @api outputProject; // Output parameter for the selected project
    @api outputTime; // Output parameter for the selected time

    @track timeList = [
        { label: 'Every Day', value: 'Every Day' },
        { label: 'Every Hour', value: 'Every Hour' },
    ];
    selectedTime = '';

    @wire(getProjectName)
    wiredProjectNames({ error, data }) {
        if (data) {
            this.projectOptions = [];
            data.forEach(mapItem => {
                const nameAddressMapper = mapItem.NameAddressMapper;
                Object.values(nameAddressMapper).forEach(projectName => {
                    this.projectOptions.push({ label: projectName, value: projectName });
                });
            });
        } else if (error) {
            console.error('Error fetching project names', error);
        }
    }

    handleProjectChange(event) {
        this.selectedProject = event.detail.value;
        this.outputProject = event.detail.value; // Update the output parameter
    }

    handleTimeChange(event) {
        this.selectedTime = event.detail.value;
        this.outputTime = event.detail.value; // Update the output parameter
    }

    handleButtonClick() {
        performHttpRequestWithNamedCredential({ selectedValues: this.selectedProject ,
            selectedTime: this.outputTime
        })
            .then(result => {
                const successCount = result.successCount;
                const failedCount = result.failedCount;

                if (failedCount > 0) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Partial Success',
                            message: `Successfully inserted/updated ${successCount} records. ${failedCount} records failed.`,
                            variant: 'warning',
                        }),
                    );
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: `All ${successCount} records from Project ${this.selectedProject} have been saved successfully`,
                            variant: 'success',
                        }),
                    );
                }
            })
            .catch(error => {
                let errorMessage = error.body.message || error.message;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error retrieving records',
                        message: errorMessage,
                        variant: 'error',
                    }),
                );
            });
            
            // processProjectTime({ selectedValue: this.selectedTime })
            // .then(() => {
            //     this.dispatchEvent(
            //         new ShowToastEvent({
            //             title: 'Success',
            //             message: this.selectedTime + ' has been chosen',
            //             variant: 'success',
            //         }),
            //     );
            // })
            // .catch(error => {
            //     this.dispatchEvent(
            //         new ShowToastEvent({
            //             title: 'Error setting time',
            //             message: error.body.message,
            //             variant: 'error',
            //         }),
            //     );
            // });
            // console.log(this.selectedTime);
    }
}