/* Active Admin JS */

$(function(){
    $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});

    $(".clear_filters_btn").click(function(){
      window.location.search = "";
      return false;
    });
    
    // AJAX Comments
    $('form#new_active_admin_admin_note').submit(function() {

      if ($(this).find('#admin_note_comment').val() != "") {
        $(this).fadeOut('slow', function() {
          $('.loading_indicator').fadeIn();
          $.ajax({
            url: $(this).attr('action'),
            type: 'POST',
            dataType: 'html',
            data: $(this).serialize(),
            success: function(data, textStatus, xhr) {
              $('.loading_indicator').fadeOut('slow', function(){
                $('.comments').append(data);
                $('form#new_active_admin_admin_note').find('#active_admin_admin_note_body').val("");
                $('form#new_active_admin_admin_note').fadeIn('slow');
              })
            },
            error: function(xhr, textStatus, errorThrown) {
              //called when there is an error
            }
          });
        });
        
      };

      return false;
    });
});
