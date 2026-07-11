namespace anubhav.commonzz;

using { Currency, cuid  } from '@sap/cds/common';

type Guid : String(32);

type Gender : String(1) enum {
      male         = 'M';
      female       = 'F';
      undisclosed  = 'U'
};

type AmountT : Decimal(10,2) @(
    Sementic.amount.currencyCode : 'CURRENCY_code',  // added UOM for currency code
);

// custom aspect 
 aspect Amount{
    currency: Currency @(title: '{i18n>CURRENCY}');
    GROSS_AMOUNT: AmountT @(title: '{i18n>GROSS_AMOUNT}');
    NET_AMOUNT: AmountT @(title: '{i18n>NET_AMOUNT}');
    TAX_AMOUNT: AmountT @(title: '{i18n>TAX_AMOUNT}');
 };

 type PhoneNumber : String(30) @assert.format : '^[6-9]\d{9}$' @title : '{i18n>PHONE_NUMBER}'; 

// assert fromat and lable
 type Email : String(250) @assert.format : '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' @title : '{i18n>EMAIL}';
 