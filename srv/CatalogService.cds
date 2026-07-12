// consume refrence of my data model

using { anubhav.db.master, anubhav.db.transaction } from '../db/datamodel';



service CatalogService @(path: 'CatalogService', requires: 'authenticated-user') { // to enable authentication and authorization, so that the user can only
    // access the service if he is authenticated, and can only access the data if he has the required role, otherwise he will get an error message
    
    //Entity  - representation of an end point of data to perform CRUDQ tasks
    entity EmployeeSet     @(
        //  Start add security
                             restrict : [
                                    { grant : ['READ'], to : 'Viewer', where : 'bankName = $user.spiderman' },  // this will allow the user to view the data if he has the Viewer role, otherwise he will get an error message
                                    { grant : ['UPDATE', 'DELETE', 'CREATE'], to : 'Editor' } // this will allow the user to update and delete the data if he has the Editor role, otherwise he will get an error message
                               
                                ],
        // End add security


                             )   as projection on master.employee;
    entity ProductSet         as projection on master.product;
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet         as projection on master.address;
//////////*******************************************************///////////////////////////////// /////////////
// make it read only, so that it can be used in the UI for displaying the data, but not for creating or updating the data

    // @readonly  // to remove the delete button from the UI, so that the user cannot delete the data from the UI, but can only view the data
 
    // commenting this section to enable Authentication and Authorization, so that the user can only view the data if he has the required role, otherwise
    // he will get an error message, and the user can only create, update or delete the data if he has the required role, otherwise he will get an error message 

    // @Capabilities : {     //@capabilities is used to define the capabilities of the entity, like insertable, updatable, deletable, etc.
    //     Insertable : true,  // Please note first letter of the capability should be capital, otherwise it will not work
    //     Updatable : true,   
    //     Deletable : true,
    //     Filterable : true,
    //     Sortable : true,
    //     Searchable : true, 
    // }
////////////////////////////********************************************************////////////////////////////
    entity PurchaseOrderSet @(
        //  Start add security
                             restrict : [
                                    { grant : ['READ'], to : 'Viewer'},  // this will allow the user to view the data if he has the Viewer role, otherwise he will get an error message
                                    { grant : ['UPDATE', 'DELETE', 'CREATE', '*'], to : 'Editor' } // this will allow the user to update and delete the data if he has the Editor role, otherwise he will get an error message
                               
                                ],
        // End add security
        
                              odata.draft.enabled: true,
                              Common.DefaultValuesFunction: 'getDefaultValue' // attach the default value function 
                             ) as projection on transaction.purchaseorder  
    // @(odata.draft.enabled: true) adds the draft functionality to the entity, so that the user can create a new purchase order and save it as a draft, and then later on can submit it for approval
    {
        *,      // to add all the fields of the entity
      case  
        when OVERALL_STATUS = 'A' then 'Approved'
        when OVERALL_STATUS = 'R' then 'Rejected'
        when OVERALL_STATUS = 'P' then 'Pending'
        else 'Unknown'
              end as OverallStatus : String(20),  //to add a new field to the entity with a new name and type


  
        case
        when OVERALL_STATUS = 'A' then '2' // this was throwing error untill its written in this way 
        when OVERALL_STATUS = 'R' then '3'
        when OVERALL_STATUS = 'P' then '1'
        else '0'
        end as spiderMan : String(1),
             
          
    //   case  
    //     when OVERALL_STATUS = 'A' then 2  // This was throwing error  
    //     when OVERALL_STATUS = 'R' then 1
    //     when OVERALL_STATUS = 'P' then 3
    //     else 0
    //     end as spiderMan : Integer,  //to add a new field to the entity with a new name and type
    //     //  end as spiderMan : String(20),  // to add criticalitty to the entity with a new name and type

  
    }
    actions{
        ///Side effect - a trigger to my action leads to a change of a field value in data
        //this force framework to make a GET call after action is triggred to load data
        //_anubhav is  variable that will contain the updated data coming from Backend


        // Not needed to use the @Common.SideEffects annotation if the action is bound to an entity, 
        //as the framework will automatically handle the side effects for you. However, 
        //if you want to specify the target properties explicitly, you can use the @Common.SideEffects annotation as shown below.
       
       
        // @cds.odata.bindingparameter.name: '_anubhav'
        // @Common.SideEffects :{
        //     TargetProperties: ['_anubhav/GROSS_AMOUNT','_anubhav/OVERALL_STATUS']
        // }
        // action to create a new purchase order
        action boost() returns PurchaseOrderSet

    };
    // to feed value to ValueHelp, so that the user can select the value from the list of values, instead of typing it manually
    @readonly
    entity SatatusCodesSet as projection on master.StatusCodes;

    
    entity PurchaseItemsSet   as projection on transaction.poitems;

    // non instance bound because they are not connected to any entity
    function getLargeOrders() returns array of PurchaseOrderSet;

// Get default values for the PurchaseOrderSet entity, which can be used to pre-populate fields when creating a new purchase order
    function getDefaultValue() returns PurchaseOrderSet;

}