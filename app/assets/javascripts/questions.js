$(function() {
  
  function resetModal() {
    var modal = $('.show-listing #contact-modal'),
        form = $('form', modal);
    
    form.show();
    form.find('input[type=email], textarea').val('');
    form.find('.errors').html('');
    form.find('.control-group.email, .control-group.text').removeClass('error');
    modal.find('.success').html('');
    modal.find('.btn-primary').removeAttr('disabled');
    modal.find('.modal-footer').show();
  };
  
  $('.show-listing #contact-modal').on('show', function() {
    resetModal();
  });
  
  
  $('.show-listing #contact-modal .modal-footer .btn-primary').click(function(e) {
    var btn = $(this),
        modal = btn.parents('#contact-modal');
        
    btn.attr('disabled', 'disabled');
    
    var form = $('form', modal);
    $.ajax({
      type: 'POST',
      url: form.attr('action'),
      data: form.serialize(),
      success: function(data) {
        btn.removeAttr('disabled');
        
        form.find('.errors').html('');
        form.hide();
        $('.modal-body .success', modal).html("<p>Your message was sent.</p>");
        $('.modal-footer', modal).hide();
      },
      error: function(data) {
        var json = JSON.parse(data.responseText);
        btn.removeAttr('disabled');
        
        $('.control-group.email, .control-group.text', form).removeClass('error');
        
        if(json.errors) {
          var message = json.errors.join('. ');
          $('.modal-body .errors', form).html("<p>" + message + "</p>");
          
          if(message.match(/email/i)) {
            $('.control-group.email', form).addClass('error');
          }
          
          if(message.match(/text/i)) {
            $('.control-group.text', form).addClass('error');
          }
        }
      },
      dataType: 'json'
    });
    
  });
});