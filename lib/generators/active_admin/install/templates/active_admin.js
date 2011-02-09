/* Active Admin JS */

$(function(){
    $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});

    $(".clear_filters_btn").click(function(){
      window.location.search = "";
      return false;
    });
    
    // AJAX Comments
    $('form#admin_note_new').submit(function() {

      if ($(this).find('#admin_note_body').val() != "") {
        $(this).fadeOut('slow', function() {
          $('.loading_indicator').fadeIn();
          $.ajax({
            url: $(this).attr('action'),
            type: 'POST',
            dataType: 'json',
            data: $(this).serialize(),
            success: function(data, textStatus, xhr) {
              $('.loading_indicator').fadeOut('slow', function(){
                
                // Hide the empty message
                $('.admin_notes_list li.empty').fadeOut().remove();
                
                // Add the note
                $('.admin_notes_list').append(data['note']);
                
                // Update the number of notes
                $('.admin_notes h3 span.admin_notes_count').html("(" + data['number_of_notes'] + ")");
                
                // Reset the form
                $('form#new_active_admin_admin_note').find('#active_admin_admin_note_body').val("");
                
                // Show the form
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
