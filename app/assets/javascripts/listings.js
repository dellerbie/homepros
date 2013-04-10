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
        $("#img_prev").attr("src", e.photo.url)
      },
      error: function (e) {
        var response = $.parseJSON(e.responseText);
        if(response.errors) {
        
        } else {
          $("#img_prev").attr("src", response.photo.url);
        }
      }    
    });
  });
  
  if(!$('#user_listing_attributes_portfolio_photo_cache').val()) {
    $('#img_prev').attr('src', '/assets/small-listing.png');
  }
  
  $('#user_listing_attributes_portfolio_photo_description').keyup(function() {
    var text = $(this).val() || 'Your image description';
    $('.preview .description').text(text);
  });
  
  $('#user_listing_attributes_company_name').keyup(function() {
    var text = $(this).val() || 'Your company name';
    $('.preview .company-name').text(text);
  });
  
  $('#user_listing_attributes_city_id').change(function() {
    var text = $('option:selected', this).text() || 'Company location';
    $('.preview .location').text(text);
  });
  
  $('input[name="user[listing_attributes][budget_id]"]').change(function() {
    var text = $(this).parent().text() || 'Typical project budget range';
    $('.preview .budget').text(text);
  });
  
});

