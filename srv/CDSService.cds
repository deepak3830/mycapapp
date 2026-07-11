using { anubhav.cds.CDSViews  } from '../db/CDSViews';

service CDSService @(path:'CDSService') {
    entity POWorklistSet as projection on CDSViews.POWorklist;
    entity ProductValueHelpSet as projection on CDSViews.ProductValueHelp;

    entity ProductViewSet as projection on CDSViews.ProductView{
          *,   // *, is required before virtual field, otherwise it will give error
      // this field does not exest in the database, but is calculated in the service layer
        virtual soldCount : Int16,
       
    };

    entity ItemViewSet    as projection on CDSViews.ItemView;
};


