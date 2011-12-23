/* Active Admin JS */
$(function(){
  $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});

  $(".clear_filters_btn").click(function(){
    window.location.search = "";
    return false;
  });

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
