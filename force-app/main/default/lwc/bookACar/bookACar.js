import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import getLaunchedCarModels from '@salesforce/apex/CarModelController2.getLaunchedCarModels';

export default class BookACar extends NavigationMixin(LightningElement) {

    viewModelId;
    showViewModal = false;
    viewRecId;
    carModels;
    error;
    carModel;
    datas;
    len = false;
    
    constructor(){
        super();
        getLaunchedCarModels()
        .then((result) => {
            this.carModels = result;
            this.datas = result;
            console.log(result);
            this.setLen(result.length);
        }) 
        .catch((error) => {
            console.log(error);
            this.error = error;
            this.showErrorToast(error);
        })
    }

    setLen = (res) => {
        this.len = (res) ? true : false;
    }

    showErrorToast = (err) => {
        const event = new ShowToastEvent({
            title: 'Error',
            variant: 'error',
            message: err.body.message,
        });
        this.dispatchEvent(event);
    }

    //Function used to fetch records according to the value given as input in the searchbar
    searchRecords = (event) => { 
        const searchTerm = event.target.value;
        
        if(searchTerm){
            this.carModels = this.carModels.filter((model) => {
                return model.Name.toLowerCase().includes(searchTerm.toLowerCase());
            })
            this.setLen(this.carModels.length);
        }
        else if(!searchTerm){
            this.carModels = this.datas;
            this.setLen(this.carModels.length);
        }
    }
    
    handleNavigate = (event) => {
        let recid = event.target.name;

        var compDefinition = {
            componentDef: "c:carBookingPage",
            attributes: {
                recId: recid
            }
        };
        // Base64 encode the compDefinition JS object
        var encodedCompDef = btoa(JSON.stringify(compDefinition));
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/one/one.app#' + encodedCompDef
            }
        });
    }

    openViewModal = (event) => {
        this.viewRecId = event.target.name;
        this.carModel = this.datas.filter((model) => {
            return model.Id.includes(this.viewRecId);
        })[0];

        this.showViewModal = true;
    }

    closeViewModal = (event) => {
        this.viewModelId = '';
        this.showViewModal = false;
    }
}

/*
//Function used to fetch records according to the value given as input in the searchbar
    searchRecords = (event) => { 
        
        const searchTerm = event.target.value;
        console.log(searchTerm);
        
        if(searchTerm){
            this.carModels = this.carModels.filter((model) => {
                return model.Name.toLowerCase().includes(searchTerm.toLowerCase());
            })
            this.setLen(this.carModels.length);
            console.log("List");
            console.log(this.carModels)
        }
        else if(!searchTerm){
            this.carModels = this.datas;
            this.setLen(this.carModels.length);
            console.log("Full List");
            console.log(this.carModels)
        }

        /*
        if(searchTerm){
            getLaunchedCarModelBySearchTerm( { searchTerm: searchTerm } ).then((result) => {
                this.carModels = result;
                this.setLen(result.length);
            }) 
            .catch(error => { 
                this.error = error;
                this.showErrorToast(error);
            }); 
        } 
        else if(!searchTerm) 
        {
            getLaunchedCarModels()
            .then((result) => {
                this.carModels = result;
                this.setLen(result.length);
            }) 
            .catch((error) => {
                this.error = error;
                this.showErrorToast(error);
            })
        }
        else{
            this.carModels = undefined;
        }
        
    }
    


            this[NavigationMixin.Navigate]({
            type: "standard__component",
            attributes: {
                componentName: "c__NavigateToLWC"
            },
            state: {
                c__propertyValue: recid
            }
        });
        */

        /*
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Car_Booking__c',
                actionName: 'new'
            },
        });

        /* @wire(getLaunchedCarModels)
    Car_Model__c({data, error}){
        if(data){
            this.handleDataToShow(data);
            this.error = undefined;
        }
        else if(error){
            this.carModels = undefined;
            this.error = error;
        }
    } */