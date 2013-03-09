$(function() {
  
  $('#user_listing_attributes_portfolio_photo').bind('change', function(e) { 
    var file = $(this);
    var form = $(this).closest("form");
    $.ajax('/preview_photos', {
        type: 'POST',
        files: $(":file", form[0]),
        iframe: true,
        dataType: "json",
        
        success: function (e) {
          console.log('success');
          console.log(e.photo.url);
          $("#img_prev").attr("src", e.photo.url)
        },
        error: function (e) {
          console.log('error');
            console.log(e)
          console.log($.parseJSON(e.responseText));
          
          var response = $.parseJSON(e.responseText);
          if(response.errors) {
            
          } else {
            $("#img_prev").attr("src", response.photo.url);
          }
          
        },
        complete: function (n) {
            //t.hide(), e.show()
        }
    })
  });

});

