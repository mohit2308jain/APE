public with sharing class CarBookingsService {

    public static CarBookings carBooking;
    public static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { Car_Booking__c.SObjectType, Car_Model__c.SObjectType });

    public void createCarBooking(List<Car_Booking__c> carBookingsList){
        try{
            carBooking = new CarBookings(carBookingsList);
            carBooking.createCarBooking(uow);

            uow.commitWork();
        }
        catch(Exception e){
            throw e;
        }
    }

    public void createCarBooking(Car_Booking__c carBookingsRecord){
        createCarBooking(new List<Car_Booking__c>{carBookingsRecord});
    }

    public void updateCarBookingStage(List<Car_Booking__c> carBookingsToBeUpdated, String stage){
        try{
            carBooking = new CarBookings(carBookingsToBeUpdated);
            carBooking.updateBookingStage(uow, stage);

            uow.commitWork();
        }
        catch (Exception e) {
            throw e;
        }
    }

    public void deleteCarBooking(List<Car_Booking__c> carBookingsToBeDeleted){
        try{
            carBooking = new CarBookings(carBookingsToBeDeleted);
            carBooking.deleteCarBooking(uow);

            uow.commitWork();
        }
        catch (Exception e) {
            throw e; 
        }
    }
}
