namespace anubhav.db;

using { anubhav.commonzz as common } from './commons';
// sap capm provided common data types are used in this file.
using { Currency, cuid, managed  } from '@sap/cds/common';


context master {

    entity businesspartner {
        key NODE_KEY: common.Guid; // @(title: '{i18n>BP}'); ;
        BP_ROLE: String(2) @(title: '{i18n>BP_ROLE}');
        EMAIL_ADDRESS: String(125) @(title: '{i18n>EMAIL_ADDRESS}');
        PHONE_NUMBER: String(32) @(title: '{i18n>PHONE_NUMBER}');
        FAX_NUMBER: String(32) @(title: '{i18n>FAX_NUMBER}');
        WEB_ADDRESS: String(44) @(title: '{i18n>WEB_ADDRESS}');
        COMPANY_NAME: String(250) @(title: '{i18n>COMPANY_NAME}');
        BP_ID: String(32) @(title: '{i18n>BP_ID}');
        //COLUMN NAME - ADDRESS_GUID_NODE_KEY
        ADDRESS_GUID: Association to one address;
     };

        entity address{
        key NODE_KEY: common.Guid @(title: '{i18n>ADDRESS}');
        CITY: String(44) @(title: '{i18n>CITY}');
        POSTAL_CODE: String(8) @(title: '{i18n>POSTAL_CODE}');
        STREET: String(44) @(title: '{i18n>STREET}');
        BUILDING: String(128) @(title: '{i18n>BUILDING}');
        COUNTRY: String(44) @(title: '{i18n>COUNTRY}');
        ADDRESS_TYPE: String(44) @(title: '{i18n>ADDRESS_TYPE}');
        VAL_START_DATE: Date @(title: '{i18n>VAL_START_DATE}');
        VAL_END_DATE: Date @(title: '{i18n>VAL_END_DATE}');
        LATITUDE: Decimal @(title: '{i18n>LATITUDE}');
        LONGITUDE: Decimal @(title: '{i18n>LONGITUDE}')    ;
        businesspartner: Association to one businesspartner on
                    businesspartner.NODE_KEY = $self.NODE_KEY
        };

// Primary key will genrate automatically by cuid aspect of sap capm. cuid is a unique identifier for each record in the entity.
    entity employee: cuid{
        nameFirst     : String(256) @(title: '{i18n>FIRST_NAME}');
        nameMiddle    : String(256) @(title: '{i18n>MIDDLE_NAME}');
        nameLast      : String(256) @(title: '{i18n>LAST_NAME}');
        nameInitials  : String(40) @(title: '{i18n>INITIALS}');
        sex           : common.Gender @(title: '{i18n>SEX}');
        language      : String(1) @(title: '{i18n>LANGUAGE}');
        phoneNumber   : common.PhoneNumber @(title: '{i18n>PHONE_NUMBER}');
        email         : common.Email @(title: '{i18n>EMAIL}');
        loginName     : String(12) @(title: '{i18n>LOGIN_NAME}');
        Currency      : Currency @(title: '{i18n>CURRENCY}');
        salaryAmount  : common.AmountT @(title: '{i18n>SALARY_AMOUNT}');
        accountNumber : String(16) @(title: '{i18n>ACCOUNT_NUMBER}');
        bankId        : String(50) @(title: '{i18n>BANK_ID}');
        bankName      : String(64) @(title: '{i18n>BANK_NAME}');
    }

    //master data products
    entity product {
        key NODE_KEY: common.Guid @(title: '{i18n>PRODUCT}');
        PRODUCT_ID: String(28) @(title: '{i18n>PRODUCT_ID}');
        TYPE_CODE: String(2) @(title: '{i18n>TYPE_CODE}');
        CATEGORY: String(32) @(title: '{i18n>CATEGORY}');
        DESCRIPTION: localized String(255) @(title: '{i18n>DESCRIPTION}');
        SUPPLIER_GUID: Association to one master.businesspartner;
        TAX_TARIF_CODE: Integer @(title: '{i18n>TAX_TARIF_CODE}');
        MEASURE_UNIT: String(2) @(title: '{i18n>MEASURE_UNIT}');
        WEIGHT_MEASURE: Decimal(5, 2) @(title: '{i18n>WEIGHT_MEASURE}');
        WEIGHT_UNIT: String(2) @(title: '{i18n>WEIGHT_UNIT}');
        CURRENCY_CODE: String(4) @(title: '{i18n>CURRENCY_CODE}');
        PRICE:  Decimal(15,2) @(title: '{i18n>PRICE}');
        WIDTH:  Decimal(5,2) @(title: '{i18n>WIDTH}');
        DEPTH:  Decimal(5,2) @(title: '{i18n>DEPTH}');
        HEIGHT: Decimal(5,2) @(title: '{i18n>HEIGHT}');
        DIM_UNIT: String(2) @(title: '{i18n>DIM_UNIT}');
    };

   entity StatusCodes {
        key CODE: String(1);
        Value: String(10);
    };
};

context transaction {
    entity purchaseorder: common.Amount, cuid{
        //key NODE_KEY: common.Guid @(title: '{i18n>PO_KEY}');
        PO_ID: String(32) @(title: '{i18n>PO_ID}');
        PARTNER_GUID : Association to master.businesspartner @(title: '{i18n>PARTNER_KEY}');
        LIFECYCLE_STATUS: String(1) @(title: '{i18n>OVERALL_STATUS}');
        OVERALL_STATUS: String(1) @(title: '{i18n>OVERALL_STATUS}');
        NOTE: String(100) @(title: '{i18n>NOTE}');
        Items: Composition of  many poitems on Items.PARENT_KEY = $self@(title: '{i18n>PO_ITEM_KEY}');
    }

    entity poitems: common.Amount, cuid{
        //key NODE_KEY: common.Guid @(title: '{i18n>PO_ITEM_KEY}');
        PARENT_KEY: Association to purchaseorder @(title: '{i18n>PO_KEY}');
        PO_ITEM_POS: Integer @(title: '{i18n>PO_ITEM_POS}');
        PRODUCT_GUID : Association to master.product @(title: '{i18n>PRODUCT_KEY}');        
    }




// context transaction {
//     entity purchaseorder : common.Amount, cuid {
//         // key NODE_KEY: common.Guid   ;
//         PO_ID: String(32) @(title: '{i18n>PO_ID}');
//         PARTNER_GUID: Association to one master.businesspartner;
//         LIFECYCLE_STATUS: String(1) @(title: '{i18n>LIFECYCLE_STATUS}');
//         OVERALL_STATUS: String(1) @(title: '{i18n>OVERALL_STATUS}');
//         NOTE: String(100) @(title: '{i18n>NOTE}');   
//         Items: Composition of many poitems on Items.PARENT_KEY = $self;            
//     };
    
//     entity poitems : common.Amount, cuid {
//         // key NODE_KEY: common.Guid @(title: '{i18n>PO_ITEMS}');
//         PARENT_KEY: Association to one purchaseorder on PARENT_KEY.ID = $self.ID;
//         PO_ITEM_POS: Integer @(title: '{i18n>PO_ITEM_POS}');
//         PRODUCT_GUID: Association to one master.product;        
//     };
}