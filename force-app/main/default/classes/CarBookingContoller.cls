public with sharing class CarBookingContoller {
    public static CarBookingsService carBookingServiceVar = new CarBookingsService();
    
    public static List<Car_Booking__c> getCarBookingsById(set<Id> ids){
        return carBookingServiceVar.fetchByCarBookingsId(ids);
    }

    @AuraEnabled
    public static List<Car_Booking__c> getCarBookings() {
        return carBookingServiceVar.fetchAllCarBookings();
    }  

    @AuraEnabled
    public static void updateBookingStage(Id bookingId){
        try{
            carBookingServiceVar.updateCarBookingStage(getCarBookingsById(new set<Id>{bookingId}), 'Payment Done');
        }
        catch (Exception e) {
            throw e;
        }
    }

    @AuraEnabled
    public static void deleteCarBooking(Id bookingId){
        try{
            carBookingServiceVar.deleteCarBooking(getCarBookingsById(new set<Id>{bookingId}));
        }
        catch (Exception e) {
            throw e;
        }
    }  
}
