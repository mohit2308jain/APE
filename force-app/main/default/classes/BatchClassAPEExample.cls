public class BatchClassAPEExample implements Database.Batchable<sObject>{
    public static CarModelsService ser = new CarModelsService();
    public static CarModelsSelector selector = new CarModelsSelector();
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return selector.queryLocatorExample();
    }
    public void execute(Database.BatchableContext bc, List<Car_Model__c> records){
        for(Car_Model__c c: records){
            c.Stage__c = 'Launched';
            c.Engine__c = 'Updated Engine';
        }
        ser.updateCarModels(records);
        //ser.deleteCarModel(records);
    }
    public void finish(Database.BatchableContext bc){
        system.debug(selector.selectRecentlyLaunchedCars2('Stage__c = \'Launched\' and Engine__c = \'Updated Engine\'').size());
    }
}

/*
List<Car_Model__c> ca = new List<Car_Model__c>();
for(Integer i=1;i<=250;i++){
    Car_Model__c c = new Car_Model__c();
    c.Name = 'Test '+ i + Date.today();
    c.Seats__c = '4';
    c.Engine__c = 'Some Engine ' + i;
    c.Price__c = 1231;
    c.Car__c = 'a002w000009kLmtAAE';
    ca.add(c);
}
new CarModelsService().createCarModel(ca);
*/