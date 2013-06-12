$(function() { 
  OCHM.SAW_HOMEOWNER_DIALOG_COOKIE = 'saw_homeowner_subscribe_dialog';
  OCHM.HOMEOWNER_SIGNED_UP_COOKIE = 'signed_up_homeowner_subscribe';

  OCHM.showHomeownerDialog = function() {
    var signed_in = $('body').data('signed-in'),
        saw_dialog = $.cookie(OCHM.SAW_HOMEOWNER_DIALOG_COOKIE),
        signed_up = $.cookie(OCHM.HOMEOWNER_SIGNED_UP_COOKIE);

    if(!signed_in && !saw_dialog && !signed_up) {
      $('#homeowners-subscribe-modal').modal('toggle');
      $.cookie(OCHM.SAW_HOMEOWNER_DIALOG_COOKIE, true, { expires: moment().add('minutes', 15).toDate(), path: '/' });
    } else if(signed_in) {
      $.cookie(OCHM.SAW_HOMEOWNER_DIALOG_COOKIE, false, { expires: moment().add('minutes', 15).toDate(), path: '/' });
      $.cookie(OCHM.HOMEOWNER_SIGNED_UP_COOKIE, false, { expires: 30, path: '/' });
    }
  }
    
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
    ga('send', 'event', 'Homeowners Newsletter', 'Show');
    resetModal();
  });
  
  $('#homeowners-subscribe-modal').on('hidden', function () {
    if($.cookie(OCHM.HOMEOWNER_SIGNED_UP_COOKIE)) return true;
    ga('send', 'event', 'Homeowners Newsletter', 'No Thanks');
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
        $.cookie(OCHM.HOMEOWNER_SIGNED_UP_COOKIE, true, { expires: 30, path: '/' });
        ga('send', 'event', 'Homeowner Newsletter', 'Signed Up');
      },
      error: function(data) {
        var json = JSON.parse(data.responseText);
        btn.removeAttr('disabled');
        
        $('.control-group.homeowner_email, .control-group.homeowner_city', form).removeClass('error');
        
        if(json.errors) {
          var message = json.errors.join('. ');
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