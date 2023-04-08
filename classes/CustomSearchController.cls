/**
 * @File Name          : CustomSearchController.cls
 * @Description        : 
 * @Author             : Amit Singh (SFDCPanther)
 * @Group              : 
 * @Last Modified By   : Amit Singh (SFDCPanther)
 * @Last Modified On   : 5/31/2020, 10:37:01 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    5/31/2020   Amit Singh (SFDCPanther)     Initial Version
**/
@AuraEnabled
public static String searchRecords(String objName, String fieldName, String searchKey){
    String searchKeyword = searchKey + '*';
    String returningQuery = objName+' ( Id, '+fieldName+')';
    String query = 'FIND :searchKeyword IN ALL FIELDS RETURNING '+returningQuery+' LIMIT 2000';
    List<List<sObject>> sobjectList = Search.query(Query);
    return JSON.serialize(sobjectList);
   
}

// Method to create custom object
@AuraEnabled
public static void createCustomObject(String objectName, String objectLabel) {
    // Create custom object
    Schema.SObjectType customObjectType = Schema.getGlobalDescribe().get(objectName);
    if (customObjectType == null) {
        SchemaBuilder sb = new SchemaBuilder(objectName, objectLabel);
        sb.setCustom(true);
        sb.setLabel(objectLabel);
        sb.setPluralLabel(objectLabel + 's');
        Schema.SObjectType newObjectType = sb.build();
        Schema.DescribeSObjectResult describeResult = newObjectType.getDescribe();
        if (describeResult.isCreateable()) {
            Database.SaveResult result = Database.createSObject(newObjectType.newSObject());
            if (result.isSuccess()) {
                System.debug('Custom object created successfully: ' + objectName);
            } else {
                System.debug('Failed to create custom object: ' + result.getErrors());
            }
        } else {
            System.debug('Custom object is not createable: ' + objectName);
        }
    } else {
        System.debug('Custom object already exists: ' + objectName);
    }
}
