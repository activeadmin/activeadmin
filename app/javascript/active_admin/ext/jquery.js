// `serializeArray` generates => [{ name: 'foo', value: 'bar' }]
// This function remaps it to => { foo: 'bar' }
$.fn.serializeObject = function() {
  return this.serializeArray()
    .reduce((obj, item) => {
      obj[item.name] = item.value
      return obj
    }, {});
};
