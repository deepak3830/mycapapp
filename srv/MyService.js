const cds = require('@sap/cds')

module.exports = class MyService extends cds.ApplicationService { init() {

  const { EmployeeSet, ProductSet, BusinessPartnerSet, AddressSet, PurchaseOrderSet, PurchaseItemsSet } = cds.entities('MyService')


  this.on ('anubhav', async (req) => {
    console.log('On anubhav', req.data)
  })

  return super.init()
}}
