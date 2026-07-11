using CatalogService as service from '../../srv/CatalogService';


annotate service.PurchaseOrderSet with @(
    //Add fields to the screen for filtering the data
    UI.SelectionFields: [
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        OVERALL_STATUS,
        NET_AMOUNT
    ],
    
    // Add columns to the table data
    UI.LineItem:[
       {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataFieldForAction',     // coming from the CatalogService to boost the 
            Action : 'CatalogService.boost',
            Label : 'boost',
            // Inline : true,            
        },        
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
            
        },

        {
            $Type : 'UI.DataField',  
            Value : OVERALL_STATUS,
            Criticality: spiderMan,  // to add criticalitty to the entity with a new name and type
            // Criticality: spiderMan,  // to add criticalitty to the entity with a new name and type
            // @UI.Importance : #High, // to make the field more important in the table
            // @UI.PartOfPreview, // use of this field in the preview of the table, when we click on the row of the table, it will show the details of the row in a new screen, and this field will be shown in the preview section of the new screen
            // // @UI.Hidden,    
        },
       ],
    
    UI.HeaderInfo: {    
     
        //title of the table- first screen
        TypeName : 'Purchase Order',
        TypeNamePlural: 'Purchase Orders',
        //Second screen title section
        //////////////////*****************//////////////////////////
        Title: {Value : PO_ID},
        Description: {Value: PARTNER_GUID.COMPANY_NAME},
        /////////////////////////*************///////////////////////
        // ImageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9prr_HpO6Jfpbnt7_6wmAQytOZRTr7mnoSlBrS5OjkA&s=10'
        ImageUrl: 'https://cap.cloud.sap/docs/logos/cap.svg'
    },
        // these are Tabs in the second screen, we can add multiple tabs in the second screen, and each tab can have multiple blocks, and each block can have multiple fields
   UI.Facets: [
         {
             $Type : 'UI.CollectionFacet',
             Label : 'General Information',
             Facets : [
                 // add Facets / blocks / Tab strip 
                 {
                    // add identification block to the second screen
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.Identification', 
                    Label : 'General Information', 
                
                 },
   // add a field group block to the second screen
                 {
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#group1',  
                    Label : 'Pricing Details',
                 },
   // add a field group block to the second screen
                 {
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#group2',  
                    Label : 'Status Details',
                 },                 

             ],
         },
         {
                    $Type : 'UI.ReferenceFacet',
                    Target : 'Items/@UI.LineItem',  // Not sure what is Items@/UI.LineItem, 
                    Label : 'Purchase Items',
         }
    ],

    // add a default block  -- only one block is allowed in the default block, so we can add only one block in the default block

   UI.Identification: [     
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : NOTE
        },        
    ],
 
//  // add a field group block pricing details to the second screen
   UI.FieldGroup #group1: {
        // Label : 'Pricing Details',
        Data : [    
            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },

        ],
    },

//  // add another field for status data
   UI.FieldGroup #group2: {
        // Label : 'Status Details',
        Data : [    
            {
                $Type : 'UI.DataField',
                Value : OVERALL_STATUS,
            },
            {
                $Type : 'UI.DataField',
                Value : LIFECYCLE_STATUS
            },
            {
                $Type : 'UI.DataField',
                Value : currency_code,
            },
        ],
    },
    
);

// Annotate line item of the PurchaseItemsSet entity to show the data in the second screen of the PurchaseOrderSet entity

annotate service.PurchaseItemsSet with @(

  UI.HeaderInfo: {    // linking Thirdscreen to the second screen of the PurchaseOrderSet entity
     
        //title of the table- first screen
        TypeName : 'Purchase Items',
        TypeNamePlural: 'Purchase Order Items',
        Title: {Value : PO_ITEM_POS},
        Description: {Value: PRODUCT_GUID.PRODUCT_ID},
  },   

  UI.LineItem: [
        {
            $Type : 'UI.DataField',
            // Value : ID,  removed
            Value : PO_ITEM_POS,  // added to show the position of the item in the table
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
    ],
    UI.Facets: [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Items Details', 
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.Identification', 
                    Label : 'Third Level Item Details', 
                
                 }

            ],
        }
    ],

 
    UI.Identification: [
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
            Label : 'Product Id',
        },
        {
            $Type : 'UI.DataField',
            Value : NOTE,
            Label : 'Note',
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        }
    ],   

);

//annotate a field to get its meaningful text - play with Texts
annotate service.PurchaseOrderSet with {
    @(
        Common.Text: OverallStatus,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'SatatusCodesSet',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : OVERALL_STATUS,
                    ValueListProperty : 'CODE',
                },
            ],
            Label : 'ValueHelp',
        },
        Common.ValueListWithFixedValues : true,
        )// to get the text of the field OVERALL_STATUS, we need to annotate the field with @Common.Text and give the name of the field which we want to get the text, in this case it is
    OVERALL_STATUS;
    @Common.Text: NOTE // to get the text of the field NOTE, we need to annotate the field with @Common.Text and give the name of the field which we want to get the text, in this case it is
    PO_ID;

    //-----------------------------//
    @Common.Text: PARTNER_GUID.COMPANY_NAME // to get the text of the field PARTNER_GUID.COMPANY_NAME, we need to annotate the field with @Common.Text and give the name of the field which we want to get the text, in this case it is
    // syntax to hide PARTNER_GUID  -- Text Only
    @Common : {  TextArrangement: #TextOnly, Label: 'Business Partner Name'}    
    // @UI.Hidden : true   // to hide the field from the UI, but still it will be available in the backend
    // Connect Value Help/F4 help
    @ValueList.entity : service.BusinessPartnerSet 
    PARTNER_GUID;
};


// annotate a field to get its meaningful text for PO Items
annotate service.PurchaseItemsSet with {
    //////////Start - this create proble in UI as it makes GUID to be entered on sceen manually 
    // @Common.Text: PO_ITEM_POS   // text to be replaced with
    // @Common : {  Label: 'Purchase order Item'}  // label
    // ID;  // key filed to be replaced with text
    /////End - this create proble in UI as it makes GUID to be entered on sceen manually 
    //-----------------------------//
    @Common.Text : PRODUCT_GUID.PRODUCT_ID // replcing value 
    // Connect Value Help/F4 help
    @ValueList.entity : service.ProductSet
    PRODUCT_GUID;  // Replaced value
};

// annotate for value help
//Design Value help / F4 help in CAPM for Partner Guid and Product Guid
@cds.odata.valuelist
annotate service.BusinessPartnerSet with @(
    UI.Identification:[
        {
            $Type : 'UI.DataField',
            Value : COMPANY_NAME,
        },
    ]
);

@cds.odata.valuelist
annotate service.ProductSet with @(
    UI.Identification:[
        {
            $Type : 'UI.DataField',
            Value : DESCRIPTION,
        },
    ]
);
 

// auto genenrated code by page map for value help, to get the text of the field OVERALL_STATUS  
annotate service.SatatusCodesSet with {  
    CODE @Common.Text : Value
};

