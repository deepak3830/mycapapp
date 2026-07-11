const cds = require('@sap/cds')
const { func } = require('@sap/cds/lib/ql/cds-ql')

module.exports = class CDSService extends cds.ApplicationService { init() {

  const { POWorklistSet, ProductValueHelpSet, ProductViewSet, ItemViewSet } = cds.entities('CDSService')

  this.before (['CREATE', 'UPDATE'], POWorklistSet, async (req) => {
    console.log('Before CREATE/UPDATE POWorklistSet', req.data)
  })
  this.after ('READ', POWorklistSet, async (pOWorklistSet, req) => {
    console.log('After READ POWorklistSet', pOWorklistSet)
  })
  this.before (['CREATE', 'UPDATE'], ProductValueHelpSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductValueHelpSet', req.data)
  })
  this.after ('READ', ProductValueHelpSet, async (productValueHelpSet, req) => {
    console.log('After READ ProductValueHelpSet', productValueHelpSet)
  })
  this.before (['CREATE', 'UPDATE'], ProductViewSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductViewSet', req.data)
  })

  ///////////////////// Custom code////////////////////////
  this.after ('READ', ProductViewSet, async (productViewSet, req) => {
    console.log('After READ ProductViewSet', productViewSet)



// Handeler code for the virtual field soldCount, which is not persisted in the database


  //  get all product id into array   
          let ids = productViewSet.map(product => product.ProductId);

// // query ItemViewSet to get count of orders any product has been sold usinf CDS query language

    const orderCount = await SELECT.from(ItemViewSet)
                                   .columns('ProductId', {func : 'count', as: 'anubhav'})
                                   .where({'ProductId': {in : ids}})
                                   .groupBy('ProductId');

 // // loop through the productViewSet and set the soldCount for each product
    for (let index = 0; index < productViewSet.length; index++) {
    debugger; 
      const element = productViewSet[index];
      const foundRecord = orderCount.find(pc => pc.ProductId === element.ProductId);
      element.soldCount = foundRecord ? foundRecord.anubhav : 0;
    };
  })

///////////////////////Custom Code////////////////////////

  this.before (['CREATE', 'UPDATE'], ItemViewSet, async (req) => {
    console.log('Before CREATE/UPDATE ItemViewSet', req.data)
  })
  this.after ('READ', ItemViewSet, async (itemViewSet, req) => {
    console.log('After READ ItemViewSet', itemViewSet)
  })


  return super.init()
}}
