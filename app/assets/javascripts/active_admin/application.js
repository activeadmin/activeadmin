//= require_tree  ./lib/
//= require_tree  ./components/
//= require_tree  ./pages/

  var reindexSort = function($context, inputName) {
    // TODO: Select inputs in a less brittle way.
    var $sortInputs = $('input[name$="['+inputName+']"]', $context);
    $sortInputs.each(function(index){
      $(this).val(index);
    })
  }

  $(".has_many.sortable").each(function(){
    var $hasMany = $(this);
    var inputName = $(this).attr('data-sortable-input');

    // TODO: Select items in a less brittle way.
    $('li[id$="_'+inputName+'_input"]', $hasMany).hide();
    reindexSort($hasMany, inputName);

    $(this).sortable({
      items: 'fieldset',
      update: function(event, ui) {
        reindexSort($hasMany, inputName);
      }
    });
  });

});
