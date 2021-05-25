public with sharing class CarBookings  extends fflib_SObjectDomain {
    public CarBookings(List<Car_Booking__c> sObjectList) {
        super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new CarBookings(sObjectList);
        }
    }

    public void createCarBooking(fflib_SObjectUnitOfWork uow){
        System.debug(Records.size());
        System.debug('create booking method called');
        for(Car_Booking__c carBooking: (List<Car_Booking__c>) Records) {
            uow.registerNew(carBooking);
        }
    }

    public void updateBookingStage(fflib_SObjectUnitOfWork uow, String stage) {
        System.debug(Records.size());
        System.debug('Update Booking Stage Method Called');
        Set<Id> carModelIds = new Set<Id>();
        for(Car_Booking__c carBooking: (List<Car_Booking__c>) Records) {
            carBooking.Booking_Stage__c = stage;
            carModelIds.add(carBooking.Car_Model__c);
            uow.registerDirty(carBooking);
        }

        CarModelsSelector carModelsSelector = new CarModelsSelector();
        List<Car_Model__c> carModels = carModelsSelector.selectById(carModelIds);
        for(Car_Model__c carModel: carModels){
            carModel.Total_Cars_Sold__c += 1;
        }

        CarModels carModel = new CarModels(carModels);
        try{
            carModel.updateCarModels(uow);
        }
        catch(Exception e){
            throw e;
        }
    }

    public void deleteCarBooking(fflib_SObjectUnitOfWork uow) {
        System.debug(Records.size());
        System.debug('Delete booking Method Called');
        for(Car_Booking__c carBooking: (List<Car_Booking__c>) Records) {
            uow.registerDeleted(carBooking);
        }
    }
}