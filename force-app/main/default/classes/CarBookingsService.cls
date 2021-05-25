public with sharing class CarBookingsService {

    public static CarBookingsSelector carBookingsSelector = new CarBookingsSelector();
    public static CarBookings carBooking;
    public static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { Car_Booking__c.SObjectType, Car_Model__c.SObjectType });

    public List<Car_Booking__c> fetchAllCarBookings(){
        List<Car_Booking__c> carBookingsList = carBookingsSelector.selectAllCarBookings();
        return carBookingsList;
    }

    public List<Car_Booking__c> fetchByCarBookingsId(set<Id> ids){
        List<Car_Booking__c> carBookingsList = carBookingsSelector.selectById(ids);
        return carBookingsList;
    }

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
