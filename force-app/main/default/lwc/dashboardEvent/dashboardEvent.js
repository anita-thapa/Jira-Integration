import { LightningElement } from 'lwc';

export default class DashboardEvent extends LightningElement {
    handleRefresh(){
        refreshDataSync()
        .then(result=>{
            console.log('Data Sync Successfull: ',result);
        })
        .catch(error=>{
            console.error('Error occured while syncing data:',error);
        })
    }
}