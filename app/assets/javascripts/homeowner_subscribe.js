$(function() {
  
  function resetModal() {
    var modal = $('#homeowners-subscribe-modal'),
        form = $('form', modal);
    
    form.show();
    form.find('input[type=email], textarea').val('');
    form.find('.errors').html('');
    form.find('.control-group.homeowner_email, .control-group.homeowner_city').removeClass('error');
    modal.find('.success').html('');
    modal.find('.btn-primary').removeAttr('disabled');
    modal.find('.modal-footer').show();
  };
  
  $('#homeowners-subscribe-modal').on('show', function() {
    ga('send', 'event', 'Homeowners Modal', 'Show');
    resetModal();
  });
  
  
  $('#homeowners-subscribe-modal .modal-footer .btn-primary').click(function(e) {
    var btn = $(this),
        modal = btn.parents('#homeowners-subscribe-modal');
        
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
        $('.modal-body .success', modal).html("<p>Thank You!</p><p>You are now subscribed to the OCHomeMaster's newsletter.</p>");
        $('.modal-footer', modal).hide();
      },
      error: function(data) {
        console.log('error');
        console.log(data);
        var json = JSON.parse(data.responseText);
        btn.removeAttr('disabled');
        
        $('.control-group.homeowner_email, .control-group.homeowner_city', form).removeClass('error');
        
        if(json.errors) {
          var message = json.errors.join('. ');
          console.log(message);
          console.log(form);
          $('.errors', form).html("<p>" + message + "</p>").show();
          
          if(message.match(/email/i)) {
            $('.control-group.homeowner_email', form).addClass('error');
          }
          
          if(message.match(/city/i)) {
            $('.control-group.homeowner_city', form).addClass('error');
          }
        }
      },
      dataType: 'json'
    });
    
  });
});