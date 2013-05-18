$(function() {
  $(".new-listing .chzn-select, .edit-listing .chzn-select").chosen();

  $('#user_listing_attributes_company_name, #listing_company_name').on('blur keyup', function() {
    var text = $(this).val() || 'Your company name',
        limit = $('.preview').is('.premium') ? 41 : 24;
        
    if(text.length > limit) {
      text = text.substring(0,limit-3) + '...';
    }
        
    $('.preview .company-name').text(text);
  });

  $('#user_listing_attributes_city_id, #listing_city_id').change(function() {
    var text = $('option:selected', this).text() || 'Company location';
    $('.preview .location').text(text);
  });

  $('#user_listing_attributes_specialty_ids, #listing_specialty_ids').change(function(e) {    
    var text = 'Specialties',
        specialties = [],
        limit = $('.preview').is('.premium') ? 48 : 30;

    $('option:selected', $(this)).each(function() {
      specialties.push($(this).text());
    });
    
    if(specialties.length > 0) {
      text = specialties.join(', ');
      if(text.length > limit) {
        text = text.substring(0,limit-3) + '...';
      }
    }
    
    $('.preview .specialties').text(text);
  });
});