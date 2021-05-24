import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCarBookings from '@salesforce/apex/CarBookingContoller.getCarBookings';

export default class CarBookingsList extends LightningElement {

    viewModelId;
    showViewModal = false;
    viewRecId;
    carBookings;
    error;
    carBooking;
    datas;
    len = false;
    
    constructor(){
        super();
        getCarBookings()
        .then((result) => {
            this.carBookings = result;
            this.datas = result;
            console.log(result);
            this.setLen(result.length);
        }) 
        .catch((error) => {
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
            this.carBookings = this.carBookings.filter((booking) => {
                return booking.Account__r.Name.toLowerCase().includes(searchTerm.toLowerCase());
            })
            this.setLen(this.carBookings.length);
        }
        else if(!searchTerm){
            this.carBookings = this.datas;
            this.setLen(this.carBookings.length);
        }
    }
    

    openViewModal = (event) => {
        this.viewRecId = event.target.name;
        this.carBooking = this.datas.filter((model) => {
            return model.Id.includes(this.viewRecId);
        })[0];

        this.showViewModal = true;
    }

    closeViewModal = (event) => {
        this.viewModelId = '';
        this.showViewModal = false;
    }
}