public with sharing class CarBookingsSelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Car_Booking__c.Id, 
            Car_Booking__c.Name,
            Car_Booking__c.Speakers__c,
            Car_Booking__c.Diesel__c, 
            Car_Booking__c.Extra_Airbags__c,
            Car_Booking__c.Car_Color__c, 
            Car_Booking__c.IsApproved__c,
            Car_Booking__c.Booking_Stage__c, 
            Car_Booking__c.Customer_Email__c, 
            Car_Booking__c.Total_Price__c, 
            Car_Booking__c.Account__c, 
            Car_Booking__c.Car_Model__c};
    }
    
    public Schema.SObjectType getSObjectType() {
        return Car_Booking__c.sObjectType;
    }
    
    public override String getOrderBy() {
        return 'LastModifiedDate DESC';
    }
    
    public List<Car_Booking__c> selectById(Set<ID> idSet) {
        return (List<Car_Booking__c>) selectSObjectsById(idSet);
    }
    
    public List<Car_Booking__c> selectRecentBookings1() {
        String query = String.format(
        'select {0} from {1} ' +
        'order by {2}',
        new List<String> {
            getFieldListString(),
            getSObjectName(),
            getOrderBy()
          }
        );
        return (List<Car_Booking__c>) Database.query(query);
    }
    
    public List<Car_Booking__c> selectRecentBookings2() {
        return (List<Car_Booking__c>) Database.query(
        /**
          Query factory has been pre-initialised by calling
          getSObjectFieldList(), getOrderBy() for you.
        */
        newQueryFactory().
        // Finally build the query to execute
        toSOQL());
    }

    public List<Car_Booking__c> selectAllCarBookings() {
        List<Car_Booking__c> carBookingInfos = new List<Car_Booking__c>();
        
        system.debug('Query here====');
        String query = newQueryFactory(false).
            selectField(Car_Booking__c.Id).
            selectField(Car_Booking__c.Name).
            selectField(Car_Booking__c.Speakers__c).
            selectField(Car_Booking__c.Diesel__c).
            selectField(Car_Booking__c.Extra_Airbags__c).
            selectField(Car_Booking__c.Car_Color__c).
            selectField(Car_Booking__c.IsApproved__c).
            selectField(Car_Booking__c.Booking_stage__c).
            selectField(Car_Booking__c.Customer_Email__c).
            selectField(Car_Booking__c.Total_Price__c).
            selectField(Car_Booking__c.Account__c).
            selectField(Car_Booking__c.Car_Model__c).
            selectField('Car_Model__r.Name').
            selectField('Account__r.Name').toSOQL();
        system.debug(query);
        
        for(Car_Booking__c carBooking : Database.query(query)){
        	carBookingInfos.add(carBooking);
        }
        
        return carBookingInfos;
    }
}

/*
CarBookingsSelector sel = new carBookingsSelector();
List<carBookingsSelector.CarBookingInfo> l1 = sel.selectCarBookingInfo();
for(carBookingsSelector.CarBookingInfo lk: l1){
    system.debug(lk);
	system.debug(lk.accountName);
    system.debug(lk.bookingName);
    system.debug(lk.carColor);
}
 */