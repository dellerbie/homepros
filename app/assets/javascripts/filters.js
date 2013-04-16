$(function() {
  $('.listings-index .filters .dropdown .dropdown-menu a').click(function(e) {
    e.preventDefault();
    
    var dropdown = $(this).parents('.dropdown'),
        city = $('.filters .cities .dropdown-toggle').data('slug'),
        specialty = $('.filters .specialties .dropdown-toggle').data('slug'),
        budget = $('.filters .budgets .dropdown-toggle').data('slug'),
        selection = $(this).data('slug');
    
    if(dropdown.is('.cities')) {
      url = '/' + selection + '/' + specialty + '/' + budget;
    } else if(dropdown.is('.specialties')) {
      url = '/' + city + '/' + selection + '/' + budget;
    } else {
      url = '/' + city + '/' + specialty + '/' + selection;
    }
    
    if(url == '/all-cities/all-specialties/all-budgets') {
      url = '/';
    }
    
    window.location = url;
  });
});