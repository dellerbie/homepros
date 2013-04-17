$(function() {
  $('.listings-index .filters .dropdown .dropdown-menu a').click(function(e) {
    e.preventDefault();
    
    var dropdown = $(this).parents('.dropdown'),
        city = $('.filters .cities .dropdown-toggle').data('slug'),
        specialty = $('.filters .specialties .dropdown-toggle').data('slug'),
        selection = $(this).data('slug'),
        url = '';
    
    if(dropdown.is('.cities')) {
      if(specialty = 'all-specialties') {
        specialty = '';
      } else {
        specialty = '/' + specialty;
      }
      
      if(selection == 'all-cities') {
        selection = '';
      }
      
      url = '/' + selection + specialty;
    } else if(dropdown.is('.specialties')) {
      console.log(city);
      if(city == 'all-cities') {
        city = '';
      } else {
        city = '/' + city;
      }
      
      if(selection == 'all-specialties') {
        selection = '';
      }
      
      url = city + '/' + selection;
    }
    
    window.location = url;
  });
});