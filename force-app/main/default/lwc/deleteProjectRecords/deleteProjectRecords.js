import { LightningElement, wire, track } from 'lwc';
import getProjectName from '@salesforce/apex/GetProjectDetails.getProjectName';
import deleteJiraRecords from '@salesforce/apex/JiraRestClient.deleteJiraRecords';  // Import the deleteJiraRecords method
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
 
export default class DeleteJiraRecords extends LightningElement {
    projectOptions = [];
    selectedProject = '';
    wiredProjects;
    @track isDeleting = false;
 
    @wire(getProjectName)
    wiredProjectNames(result) {
        this.wiredProjects = result;
        const { error, data } = result;
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
    }
 
    handleDeleteProject() {
        if (this.selectedProject) {
            console.log(this.selectedProject);
            this.isDeleting = true;  // Show spinner
            deleteJiraRecords({ projectName: this.selectedProject })  // Pass selected project name to deleteJiraRecords method
            .then(result => {
                
                this.isDeleting = false;  // Hide spinner
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: result.includes('deleted') ? 'Success' : 'Info',
                        message: result,
                        variant: result.includes('deleted') ? 'success' : 'info',
                    }),
                );
                // Refresh the project list after deletion
                return refreshApex(this.wiredProjects);
            })
            .catch(error => {
                this.isDeleting = false;  // Hide spinner
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting project records',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'No project selected',
                    message: 'Please select a project to delete',
                    variant: 'warning',
                }),
            );
        }
    }
}