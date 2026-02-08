(($) => {

  $(document)
    .on('focus', 'input.datepicker:not(.hasDatepicker)', function() {
      const input = $(this);

      // Only create datepickers in compatible browsers
      if (input[0].type === 'date') { return; }

      const defaults = { dateFormat: 'yy-mm-dd' };
      const options  = input.data('datepicker-options');

      input.datepicker($.extend(defaults, options));

      // See https://github.com/jquery/jquery-ui/issues/2385
      input.datepicker('show');
    });

})(jQuery);
