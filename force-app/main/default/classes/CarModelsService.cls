public with sharing class CarModelsService {

    public static CarModels carModel;
    public static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { Car_Model__c.SObjectType });

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

    public void createCarModel(Car_Model__c carModelRecord){
        createCarModel(new List<Car_Model__c>{carModelRecord});
    }

    public void updateCarModels(List<Car_Model__c> carModelsList){
        try{
            carModel = new CarModels(carModelsList);
            carModel.updateCarModels(uow);

            uow.commitWork();
        }
        catch (Exception e) {
      		throw e;
    	}
    }

    public void updateCarModelStage(List<Car_Model__c> carModelToBeUpdated, String stage){
        try{
            carModel = new CarModels(carModelToBeUpdated);
            carModel.updateStage(uow, stage);

            uow.commitWork();
        }
        catch (Exception e) {
            throw e;
        }
    }

    public void updateCarModelStage(Car_Model__c carModelRecord, String stage){
        updateCarModelStage(new List<Car_Model__c>{carModelRecord}, stage);
    }

    public void deleteCarModel(List<Car_Model__c> carModelToBeDeleted){
        try{
            carModel = new CarModels(carModelToBeDeleted);
            carModel.deleteCarModel(uow);

            uow.commitWork();
        }
        catch (Exception e) {
            throw e; 
        }
    }

    public void deleteCarModel(Car_Model__c carModelRecord){
        deleteCarModel(new List<Car_Model__c>{carModelRecord});
    }
}
