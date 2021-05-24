public with sharing class CarModelsService {

    public static CarModelsSelector carModelsSelector = new CarModelsSelector();
    public static CarModels carModel;
    public static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { Car_Model__c.SObjectType });

    public List<Car_Model__c> fetchAllCarModels(){
        List<Car_Model__c> carModelsList = carModelsSelector.selectAllCarModels();
        return carModelsList;
    }

    public List<Car_Model__c> fetchCarModelsByStage(String condition){
        List<Car_Model__c> carModelsList = carModelsSelector.selectCarModels(condition);
        return carModelsList;
    }

    public void createCarModel(List<Car_Model__c> carModelsList){
        try{
            carModel = new CarModels(carModelsList);
            carModel.createCarModel(uow);

            uow.commitWork();
        }
        catch(Exception e){
            throw e;
        }
    }

    public void updateCarModels(List<Car_Model__c> carModelsList){
        SavePoint sp = Database.setSavePoint();
        try{
            carModel = new CarModels(carModelsList);
            carModel.updateCarModels(uow);

            uow.commitWork();
        }
        catch (Exception e) {
            Database.rollback(sp);
      		throw e;
    	}
    }

    public void updateCarModelStage(List<Car_Model__c> carModelToBeUpdated, String stage){
        SavePoint sp = Database.setSavePoint();
        try{
            carModel = new CarModels(carModelToBeUpdated);
            carModel.updateStage(uow, stage);

            uow.commitWork();
        }
        catch (Exception e) {
            Database.rollback(sp);
            throw e;
        }
    }

    public void deleteCarModel(List<Car_Model__c> carModelToBeDeleted){
        SavePoint sp = Database.setSavePoint();
        try{
            carModel = new CarModels(carModelToBeDeleted);
            carModel.deleteCarModel(uow);

            uow.commitWork();
        }
        catch (Exception e) {
            Database.rollback(sp);
            throw e; 
        }
    }
}
