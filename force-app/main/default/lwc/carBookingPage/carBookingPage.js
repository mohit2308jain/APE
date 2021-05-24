import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import updateBookingStage from '@salesforce/apex/CarBookingContoller.updateBookingStage';
import deleteCarBooking from '@salesforce/apex/CarBookingContoller.deleteCarBooking';

import BOOKINGSTAGE from '@salesforce/schema/Car_Booking__c.Booking_Stage__c';
import CARCOLOR from '@salesforce/schema/Car_Booking__c.Car_Color__c';
import CUSTOMERACCOUNT from '@salesforce/schema/Car_Booking__c.Account__c';
import CUSTOMEREMAIL from '@salesforce/schema/Car_Booking__c.Customer_Email__c';
import SPEAKERS from '@salesforce/schema/Car_Booking__c.Speakers__c';
import DIESEL from '@salesforce/schema/Car_Booking__c.Diesel__c';
import AIRBAGS from '@salesforce/schema/Car_Booking__c.Extra_Airbags__c';
import TOTALPRICE from '@salesforce/schema/Car_Booking__c.Total_Price__c';
import CARMODEL from '@salesforce/schema/Car_Booking__c.Car_Model__c'

export default class CarBookingPage extends NavigationMixin(LightningElement) {
    @api recId;

    bookingstage_field = BOOKINGSTAGE;
    carcolor_field = CARCOLOR;
    customeracc_field = CUSTOMERACCOUNT;
    cusemail_field = CUSTOMEREMAIL;
    speakers_field = SPEAKERS;
    diesel_field = DIESEL;
    airbags_field = AIRBAGS;
    totalprice_field = TOTALPRICE;
    carmodel_field = CARMODEL;

    showPaymentModal = false;
    showDeleteModal = false;
    showBookingForm = true;
    showBookingRecord = false;
    bookingId;
    pagetitle = 'Add Car Booking';

    createCarBooking = (event) => {
        this.bookingId = event.detail.id;
        this.showToastMsgs('Success', 'success', 'Booking Created !');
        this.showBookingForm = false;
        this.showBookingRecord = true;
        this.pagetitle = 'Your Booking Details';
    }

    clear = (event) => {
        this.template.querySelector('form').reset();
    }

    navigateToCarModelsPage = () => {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                //Name of any CustomTab. Visualforce tabs, web tabs, Lightning Pages, and Lightning Component tabs
                apiName: 'Book_A_Car'
            },
        });
    }

    completePayment = () => {

        updateBookingStage({bookingId: this.bookingId}).then(() => {
            console.log('succ');
            this.showToastMsgs('Success', 'success', 'Payment Done');
            this.navigateToCarModelsPage();
        }).catch((error) => {
            console.log(error);
            this.showToastMsgs('Error', 'error', 'Error in Payment');
        })
    }

    openPaymentModal = (event) => {
        this.showPaymentModal = true;
        this.showDeleteModal = false;
    }

    closePaymentModal = (event) => {
        this.showPaymentModal = false;
        this.showDeleteModal = false;
    }

    cancelBooking = () => {
        deleteCarBooking({bookingId: this.bookingId}).then(() => {
            console.log('succ');
            this.showToastMsgs('Success', 'success', 'Booking Cancelled');
            this.navigateToCarModelsPage();
        }).catch((error) => {
            console.log(error);
            this.showToastMsgs('Error', 'error', 'Error in Cancelling Booking');
        })
    }

    openDeleteModal = (event) => {
        this.showDeleteModal = true;
        this.showPaymentModal = false;
    }

    closeDeleteModal = (event) => {
        this.showPaymentModal = false;
        this.showDeleteModal = false;
    }

    showToastMsgs = (title, variant, msg) => {
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: msg,
        });
        this.dispatchEvent(event);
    }

}