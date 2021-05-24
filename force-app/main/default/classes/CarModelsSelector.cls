public with sharing class CarModelsSelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Car_Model__c.Id, 
            Car_Model__c.Name, 
            Car_Model__c.Car__c, 
            Car_Model__c.Engine__c, 
            Car_Model__c.Seats__c, 
            Car_Model__c.Price__c, 
            Car_Model__c.Stage__c};
    }
    
    public Schema.SObjectType getSObjectType() {
        return Car_Model__c.sObjectType;
    }
    
    public override String getOrderBy() {
        return 'LastModifiedDate DESC';
    }
    
    public List<Car_Model__c> selectById(Set<ID> idSet) {
        return (List<Car_Model__c>) selectSObjectsById(idSet);
    }

    public List<Car_Model__c> selectAllCarModels() {
        System.debug('Method fired');
        String query = String.format(
        'select {0} from {1} ' +
        'order by {2}',
        new List<String> {
            getFieldListString(),
            getSObjectName(),
            getOrderBy()
          }
        );
        return (List<Car_Model__c>) Database.query(query);
    }
    
    public List<Car_Model__c> selectRecentlyLaunchedCars1() {
        String query = String.format(
        'select {0} from {1} ' +
        'where Stage__c = \'Launched\' ' +
        'order by {2}',
        new List<String> {
            getFieldListString(),
            getSObjectName(),
            getOrderBy()
          }
        );
        return (List<Car_Model__c>) Database.query(query);
    }
    
    public List<Car_Model__c> selectRecentlyLaunchedCars2() {
        return (List<Car_Model__c>) Database.query(
        /**
          Query factory has been pre-initialised by calling
          getSObjectFieldList(), getOrderBy() for you.
        */
        newQueryFactory().
        /**
          Now focus on building the remainder of the
          query needed for this method.
        */
        setCondition('Stage__c = \'Launched\'').
        // Finally build the query to execute
        toSOQL());
    }
    
    public List<CarModelInfo> selectCarModelInfo(String condition) {
        List<CarModelInfo> carModelInfos = new List<CarModelInfo>();
        
        system.debug('Query here====');
        String query = newQueryFactory(false).
            selectField(Car_Model__c.Id).
            selectField(Car_Model__c.Seats__c).
            selectField(Car_Model__c.Price__c).
            selectField(Car_Model__c.Engine__c).
            selectField(Car_Model__c.Stage__c).
            selectField(Car_Model__c.Name).
            selectField(Car_Model__c.Car__c).
            selectField('Car__r.Name').
            selectField('Car__r.Style__c').
            selectField('Car__r.Manufacturer__c').
            setCondition(condition).toSOQL();
        system.debug(query);
        
        for(Car_Model__c carModel : Database.query(query)){
        	carModelInfos.add(new CarModelInfo(carModel));
        }
        
        return carModelInfos;
    }
    
    public class CarModelInfo {       
        private Car_Model__c carModel;
        public Id id { get { return this.carModel.Id; } }     
        public String seats { get { return this.carModel.Seats__c; } }
		public Decimal price { get { return this.carModel.Price__c; } }        
        public String engine { get { return this.carModel.Engine__c; } }       
        public String carModelName { get { return this.carModel.Name; } }      
        public String stage { get { return this.carModel.Stage__c; } }
        public String car { get { return this.carModel.Car__c; } }
    	public String carName { get { return this.carModel.Car__r.Name; } }
        public String carStyle { get { return this.carModel.Car__r.Style__c; } }
        public String carManufacturer { get { return this.carModel.Car__r.Manufacturer__c; } }
        private CarModelInfo(Car_Model__c carModel) { this.carModel = carModel; }         
    }

    public List<Car_Model__c> selectCarModels(String condition) {
        List<Car_Model__c> carModelInfos = new List<Car_Model__c>();
        
        system.debug('Query here====');
        String query = newQueryFactory(false).
            selectField(Car_Model__c.Id).
            selectField(Car_Model__c.Seats__c).
            selectField(Car_Model__c.Price__c).
            selectField(Car_Model__c.Engine__c).
            selectField(Car_Model__c.Stage__c).
            selectField(Car_Model__c.Name).
            selectField(Car_Model__c.Car__c).
            selectField('Car__r.Name').
            selectField('Car__r.Style__c').
            selectField('Car__r.Manufacturer__c').
            //setCondition('id in :idSet and '+condition).
            setCondition(condition).
            toSOQL();
        system.debug(query);
        
        for(Car_Model__c carModel : Database.query(query)){
        	carModelInfos.add(carModel);
        }
        
        return carModelInfos;
    }

    public List<Car_Model__c> selectCarModelsWithBookings(){
        List<Car_Model__c> carModelInfos = new List<Car_Model__c>();
        
        fflib_QueryFactory opportunitiesQueryFactory = newQueryFactory();
        // Add a query sub-select via the Query Factory for the Opportunity Products
        fflib_QueryFactory lineItemsQueryFactory =
            new CarBookingsSelector().
                addQueryFactorySubselect(opportunitiesQueryFactory);
        
        System.debug(opportunitiesQueryFactory.toSOQL());
        return carModelInfos;
    }
}

/*
CarModelsSelector sel = new CarModelsSelector();
List<CarModelsSelector.CarModelInfo> l1 = sel.selectCarModelInfo('Stage__c = \'Launched\'');
for(CarModelsSelector.CarModelInfo lk: l1){
	system.debug(lk.carStyle);
    system.debug(lk.carModelName);
}
List<CarModelsSelector.CarModelInfo> l2 = sel.selectCarModelInfo('Stage__c = \'Manufactured\'');
for(CarModelsSelector.CarModelInfo lk: l2){
	system.debug(lk.carStyle);
    system.debug(lk.carModelName);
}
 */