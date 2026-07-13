const cds = require('@sap/cds')

module.exports = class CatalogService extends cds.ApplicationService { init() {

  const { EmployeeSet, ProductSet, BusinessPartnerSet, AddressSet, PurchaseOrderSet, PurchaseItemsSet } = cds.entities('CatalogService')



    // ====================================================
    // TEMPORARY SECURITY DEBUGGING * REMOVE AFTER TESTING
    // =======================================*============


  this.before('*', async (req) => {
    console.log('========== CAP SECURITY DEBUG ==========');
    console.log('EVENT:', req.event);
    console.log('TARGET:', req.target ? req.target.name : 'N/A');
    console.log('USER ID:', req.user ? req.user.id : 'N/A');
    console.log('IS AUTHENTICATED:', req.user.is('authenticated-user'));
    console.log('IS VIEWER:', req.user.is('Viewer'));
    console.log('IS EDITOR:', req.user.is('Editor'));
    console.log('ALL ROLES:', req.user._roles);
    console.log('USER ATTRIBUTES:', req.user.attr);
    console.log('========================================');
  });

  // end   of debug code ///
  
/////   add generic handlers for employee 
  // this.before (['CREATE', 'UPDATE'], EmployeeSet, async (req) => {   --> removed UPDATE
    this.before(['CREATE'], EmployeeSet, async (req) => {    
    console.log('Before CREATE/UPDATE EmployeeSet', req.data)
    // Throw an error if the employee salary is more than 100000
      let salaryAmout = parseFloat(req.data.salaryAmount);
      if (salaryAmout > 100000) {
        req.error(500, 'Are you nuts? Salary amount cannot be more than 100000');
      }
  })
  this.after ('READ', EmployeeSet, async (employeeSet, req) => {
    console.log('After READ EmployeeSet', employeeSet)
  })
  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
    console.log('After READ ProductSet', productSet)
  })
  this.before (['CREATE', 'UPDATE'], BusinessPartnerSet, async (req) => {
    console.log('Before CREATE/UPDATE BusinessPartnerSet', req.data)
  })
  this.after ('READ', BusinessPartnerSet, async (businessPartnerSet, req) => {
    console.log('After READ BusinessPartnerSet', businessPartnerSet)
  })
  this.before (['CREATE', 'UPDATE'], AddressSet, async (req) => {
    console.log('Before CREATE/UPDATE AddressSet', req.data)
  })
  this.after ('READ', AddressSet, async (addressSet, req) => {
    console.log('After READ AddressSet', addressSet)
  })
  this.before (['CREATE', 'UPDATE'], PurchaseOrderSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseOrderSet', req.data)
    // validate that the GROSS_AMOUNT is GE 100 
    if (req.data.GROSS_AMOUNT < 100) {
      req.error(500, 'Gross Amount must be at least 100');
    }

  })
  this.after ('READ', PurchaseOrderSet, async (purchaseOrderSet, req) => {
    console.log('After READ PurchaseOrderSet', purchaseOrderSet)
    // add condition to check if note is blank then set note to "No Note" for each record
    for (let index = 0; index < purchaseOrderSet.length; index++) {
      const element = purchaseOrderSet[index];
      if (!element.NOTE || element.NOTE.trim() === '') {
        element.NOTE = 'No Note ';
      }
    };
  })

  this.before (['CREATE', 'UPDATE'], PurchaseItemsSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseItemsSet', req.data)
  })
  this.after ('READ', PurchaseItemsSet, async (purchaseItemsSet, req) => {
    console.log('After READ PurchaseItemsSet', purchaseItemsSet)
  })

 // generic handler to handel my fuction getLargeOrders
 
      this.on('getDefaultValue', async (req, res) => {
        return {
          OVERALL_STATUS: 'N',
          LIFECYCLE_STATUS: 'N',
          GROSS_AMOUNT: 0,
        };

      });




 // generic handler to handel my fuction getLargeOrders
 
      this.on('getLargeOrders', async (req, res) => {
        try {
          const largeOrders = cds.tx(req);
          // reat top amount decending GROSS_AMOUNT orders top 3
          const reply = await largeOrders.read(PurchaseOrderSet).orderBy('GROSS_AMOUNT desc').limit(333); // read
          return reply;
          
        } catch (error) {
          req.error(500, 'Internal Server Error' + error.toString());
        }

      });

// generic handler to handel my action boost  

      this.on('boost', async (req, res) => {
       
        try {
          
          debugger;

          const primaryKey = req.params[0]; // Primary Key form  params node 0
          // start a transaction to db
          const tx = cds.tx(req);

          // CDS query lang to update the GROSS_AMOUNT bu +20000 
          // where the primary key is equal to the passed primary key 
          // and return the updated record
          // and add note : amount is boosted by 20000

          await tx.update(PurchaseOrderSet).set({ GROSS_AMOUNT: { '+=': 20000 }, 
                                                  NOTE: 'Amount is boosted by 20000' }).where(primaryKey);     // update
          // read the updated record and return it
          const updatedRecord = await tx.read(PurchaseOrderSet).where(primaryKey);
          return updatedRecord;

        } catch (error) {
          req.error(500, 'Internal Server Error' + error.toString());
        }

      });


  return super.init()
}}
