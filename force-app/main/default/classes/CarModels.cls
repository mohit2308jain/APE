public with sharing class CarModels extends fflib_SObjectDomain {
    public CarModels(List<Car_Model__c> sObjectList) {
        super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new CarModels(sObjectList);
        }
    }

    public override void onValidate(Map<Id,sObject> existingRecords) {
        System.debug(existingRecords);
        for(Car_Model__c cc: (List<Car_Model__c>) Records) {
            Car_Model__c rec = (Car_Model__c)existingRecords.get(cc.Id);
            if((cc.Stage__c == 'Manufacturing' || cc.Stage__c == 'Manufactured') && rec.Stage__c == 'Launched'){
                cc.Stage__c.addError('Cannot change stage for launched car models.');
            }
            else if(cc.Stage__c == 'Manufacturing' && rec.Stage__c == 'Manufactured'){
                cc.Stage__c.addError('Cannot change stage to manufacturing for manufactured car models.');
            }
        }
    }

    // public override void handleBeforeUpdate(Map<Id,sObject> existingRecords){
    //     System.debug(existingRecords);
    //     for(Car_Model__c cc: (List<Car_Model__c>) Records) {
    //         Car_Model__c rec = (Car_Model__c)existingRecords.get(cc.Id);
    //         if((cc.Stage__c == 'Manufacturing' || cc.Stage__c == 'Manufactured') && rec.Stage__c == 'Launched'){
    //             cc.Stage__c.addError('Cannot change stage for launched car models.');
    //         }
    //         else if(cc.Stage__c == 'Manufacturing' && rec.Stage__c == 'Manufactured'){
    //             cc.Stage__c.addError('Cannot change stage to manufacturing for manufactured car models.');
    //         }
    //     }
    // }

    public void createCarModel(fflib_SObjectUnitOfWork uow){
        System.debug(Records.size());
        System.debug('Create Method Called');
        for(Car_Model__c carModel : (List<Car_Model__c>) Records) {
            uow.registerNew(carModel);
        }
    }

    public void updateStage(fflib_SObjectUnitOfWork uow, String stage) {
        System.debug(Records.size());
        System.debug('Update Stage Method Called');
        for(Car_Model__c carModel : (List<Car_Model__c>) Records) {
            carModel.Stage__c = stage;
            uow.registerDirty(carModel);
        }
    }

    public void updateCarModels(fflib_SObjectUnitOfWork uow) {
        System.debug(Records.size());
        System.debug('Update Method Called');
        for(Car_Model__c carModel : (List<Car_Model__c>) Records) {
            uow.registerDirty(carModel);
        }
    }

    public void deleteCarModel(fflib_SObjectUnitOfWork uow) {
        System.debug(Records.size());
        System.debug('Delete Method Called');
        for(Car_Model__c carModel : (List<Car_Model__c>) Records) {
            uow.registerDeleted(carModel);
        }
    }
}