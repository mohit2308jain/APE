public with sharing class CarModelController2 {
    
    public string accId {get; set;}
    public List<Car_Model__c> carModelsList {get; set;}
    public Car_Model__c carModelRecord {get; set;}
    public static CarModelsSelector carModelsSelector = new CarModelsSelector();
    public static CarModelsService carModelServiceVar = new CarModelsService();
    
    public carModelController2(){
        loadData();
        carModelRecord = new Car_Model__c();
    }
    
    private void loadData(){
        String condition = 'Stage__c = \'Manufacturing\'';
        carModelsList = carModelsSelector.selectCarModels(condition);
        
        //[SELECT Id, Name, Engine__c, Seats__c, Price__c, Stage__c FROM Car_Model__c ORDER BY LastModifiedDate DESC];
    }

    public Pagereference saveCarModel(){
        try{
            carModelServiceVar.createCarModel(carModelRecord);
            
            PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            pageRef.setRedirect(true);
            return pageRef;
        }
        Catch (Exception e){
            ApexPages.addMessages(e);
            return null;
        } 
    }
    
    public void updateModels(){
        try{
            carModelServiceVar.updateCarModels(carModelsList);
    	}
        catch (Exception e) {
      		ApexPages.addMessages(e);
    	}
    }
    
    public void updateToManufactured(){
        if (accId == null){
            return;
        }
        
        Car_Model__c carModelTobeUpdated = null;
        for(Car_Model__c model: carModelsList){
            if(model.Id == accId){
                carModelTobeUpdated = model;
                break;
            }
        }

        if(carModelTobeUpdated != null){
            SavePoint sp = Database.setSavePoint();
            try{
                carModelServiceVar.updateCarModelStage(carModelTobeUpdated, 'Manufactured');
                loadData();
            }
            catch (Exception e) {
                ApexPages.addMessages(e);
            }
        }
    }
    
    public void deleteCarModel(){
        if (accId == null){
            return;
        }
        
        Car_Model__c carModelTobeDeleted = null;
        for(Car_Model__c model: carModelsList){
            if(model.Id == accId){
                carModelTobeDeleted = model;
                break;
            }
        }
        
        if(carModelTobeDeleted != null){
            try{
                carModelServiceVar.deleteCarModel(carModelTobeDeleted);
                loadData();
            }
            catch (Exception e) {
                ApexPages.addMessages(e);
            }
        }
    }  

    @AuraEnabled
    public static String updateToLaunched(Car_Model__c carModelRecordForLaunch){
        try{
            carModelServiceVar.updateCarModelStage(carModelRecordForLaunch, 'Launched');
            return 'Success';
        }
        catch (Exception e) {
            return 'Error';
        }
    }
    
    @AuraEnabled
    public static List<Car_Model__c> getLaunchedCarModels() {
        String condition = 'Stage__c = \'Launched\'';
        List<Car_Model__c> carModelsList = carModelsSelector.selectCarModels(condition);
        return carModelsList;
    }

    @AuraEnabled
    public static List<Car_Model__c> getManufacturedCarModels() {
        String condition = 'Stage__c = \'Manufactured\'';
        List<Car_Model__c> carModelsList = carModelsSelector.selectCarModels(condition);
        return carModelsList;
    }
}