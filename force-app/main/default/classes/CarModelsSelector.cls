public with sharing class CarModelsSelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Car_Model__c.Id, 
            Car_Model__c.Name, 
            Car_Model__c.Car__c, 
            Car_Model__c.Engine__c, 
            Car_Model__c.Seats__c, 
            Car_Model__c.Price__c, 
            Car_Model__c.Stage__c,
            Car_Model__c.Total_Cars_Sold__c};
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
    
    public List<Car_Model__c> selectRecentlyLaunchedCars2(string condition) {
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
        setCondition(condition).
        // Finally build the query to execute
        toSOQL());
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
            selectField(Car_Model__c.Total_Cars_Sold__c).
            selectField('Car__r.Name').
            selectField('Car__r.Style__c').
            selectField('Car__r.Manufacturer__c').
            //setCondition('id in :idSet and '+condition).
            setCondition(condition).
            toSOQL();
        system.debug(query);
        
        carModelInfos = Database.query(query);
        
        return carModelInfos;
    }

    public List<Car_Model__c> selectCarModelsWithBookings(){
        List<Car_Model__c> carModelInfos = new List<Car_Model__c>();
        
        fflib_QueryFactory carModelsQueryFactory = newQueryFactory();
        fflib_QueryFactory carBookingQueryFactory = new CarBookingsSelector().addQueryFactorySubselect(carModelsQueryFactory);
        
        String query = carModelsQueryFactory.toSOQL();
        System.debug(query);
        carModelInfos = Database.query(query);
        return carModelInfos;
    }

    public Database.QueryLocator queryLocatorExample(){
        return Database.getQueryLocator(
            newQueryFactory().setCondition('CreatedDate = Today').toSOQL()
        );
    }
}

    

/*
CarModelsSelector sel = new CarModelsSelector();
List<Car_Model__c> cc = sel.selectCarModelsWithBookings();
for(Car_Model__c c: cc){
    system.debug(c);
    system.debug(c.Car_Bookings__r);
}
 */