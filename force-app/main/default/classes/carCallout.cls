public class carCallout 
{
    @AuraEnabled()
    public static void makePostCallout(Id recordId) 
    {
        Car_Booking__c cb=[SELECT Id, Name, Account__r.Name, Booking_Stage__c, Car_Model__r.Name, Total_Price__c FROM Car_Booking__c WHERE Id=:recordId];
        JSONGenerator gen=JSON.createGenerator(true);
        String str='Booking Id: '+cb.Name+' has been confirmed';
        gen.writeStartObject();
        gen.writeStringField('from_email', 'mohit831925@gmail.com');
        gen.writeStringField('from_name', cb.Account__r.Name);
        gen.writeStringField('subject', 'Car Booking Confirmation');
        gen.writeStringField('message_html', str);
        gen.writeStringField('phone','8871958101');
        gen.writeEndObject();
        String jsonString=gen.getAsString();
        System.debug('JSON Materials: '+jsonString);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://dummy.restapiexample.com/api/v1/create');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(jsonString);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        System.debug('Response : '+response);
        if(response.getStatusCode() == 402){
            System.debug('One or more of the required parameters are missing ' + response.getStatusCode() + ' ' + response.getStatus());
        } 
        else if (response.getStatusCode() == 401){
            System.debug('Timeout occured '+response.getStatusCode()+' '+ response.getStatus());
        }
        else{
            System.debug('Successful '+ response.getStatusCode());
        }
    }
}