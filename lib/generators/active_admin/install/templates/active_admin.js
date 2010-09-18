/* Active Admin JS */

$(function(){
    $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});

    $(".clear_filters_btn").click(function(){
      window.location.search = "";
      return false;
    });
    
    // AJAX Comments
    $('form#new_active_admin_admin_comment').submit(function() {

      if ($(this).find('#admin_comment_comment').val() != "") {
        $.post($(this).attr('action'), $(this).serialize(), function(data, textStatus, xhr) {
          $('.loading_indicator').fadeOut('slow', function(){
            $('.comments').append(data);
            $('form#new_active_admin_admin_comment').find('#admin_comment_comment').val("");
            $('form#new_active_admin_admin_comment').fadeIn('slow');
          });
        });

        $(this).fadeOut('slow', function() {
          $('.loading_indicator').fadeIn();
        });
      };

      return false;
    });
});
