$(function() {
  // Provides a before-removal hook:
  // $ ->
  //   # This is a good place to tear down JS plugins to prevent memory leaks.
  //   $(document).on 'has_many_remove:before', '.has_many_container', (e, fieldset, container)->
  //     fieldset.find('.select2').select2 'destroy'
  //
  //   # If you need to do anything after removing the items you can use the
  //   has_many_remove:after hook
  //   $(document).on 'has_many_remove:after', '.has_many_container', (e, fieldset, container)->
  //     list_item_count = container.find('.has_many_fields').length
  //     alert("There are now #{list_item_count} items in the list")
  //
  $(document).on('click', 'a.button.has_many_remove', function(event){
    event.preventDefault();
    const parent    = $(this).closest('.has_many_container');
    const to_remove = $(this).closest('fieldset');
    recompute_positions(parent);

    parent.trigger('has_many_remove:before', [to_remove, parent]);
    to_remove.remove();
    return parent.trigger('has_many_remove:after', [to_remove, parent]);
  });

  // Provides before and after creation hooks:
  // $ ->
  //   # The before hook allows you to prevent the creation of new records.
  //   $(document).on 'has_many_add:before', '.has_many_container', (e, container)->
  //     if $(@).children('fieldset').length >= 3
  //       alert "you've reached the maximum number of items"
  //       e.preventDefault()
  //
  //   # The after hook is a good place to initialize JS plugins and the like.
  //   $(document).on 'has_many_add:after', '.has_many_container', (e, fieldset, container)->
  //     fieldset.find('select').chosen()
  //
  $(document).on('click', 'a.button.has_many_add', function(event){
    let before_add;
    event.preventDefault();
    const parent = $(this).closest('.has_many_container');
    parent.trigger((before_add = $.Event('has_many_add:before')), [parent]);

    if (!before_add.isDefaultPrevented()) {
      let index = parent.data('has_many_index') || (parent.children('fieldset').length - 1);
      parent.data({has_many_index: ++index});

      const regex = new RegExp($(this).data('placeholder'), 'g');
      const html  = $(this).data('html').replace(regex, index);

      const fieldset = $(html).insertBefore(this);
      recompute_positions(parent);
      return parent.trigger('has_many_add:after', [fieldset, parent]);
    }
  });

  $(document).on('change', '.has_many_container[data-sortable] :input[name$="[_destroy]"]', function() {
    recompute_positions($(this).closest('.has_many'));
  });

  init_sortable();
  $(document).on('has_many_add:after', '.has_many_container', init_sortable);
});

var init_sortable = function() {
  const elems = $('.has_many_container[data-sortable]:not(.ui-sortable)');
  elems.sortable({
    items: '> fieldset',
    handle: '> ol > .handle',
    start: (ev, ui) => {
      ui.item.css({opacity: 0.3});
    },
    stop: function (ev, ui) {
      ui.item.css({opacity: 1.0});
      recompute_positions($(this));
    }
  });
  elems.each(recompute_positions);
};

var recompute_positions = function(parent){
  parent = parent instanceof jQuery ? parent : $(this);
  const input_name = parent.data('sortable');
  let position = parseInt(parent.data('sortable-start') || 0, 10);

  parent.children('fieldset').each(function() {
    // We ignore nested inputs, so when defining your has_many, be sure to keep
    // your sortable input at the root of the has_many block.
    const destroy_input  = $(this).find("> ol > .input > :input[name$='[_destroy]']");
    const sortable_input = $(this).find(`> ol > .input > :input[name$='[${input_name}]']`);

    if (sortable_input.length) {
      sortable_input.val(destroy_input.is(':checked') ? '' : position++);
    }
  });
};
