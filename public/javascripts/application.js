// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$.fn.explorerAjaxSubmit = function(callback) {
  return $(this).ajaxSubmit({
    success: callback
  });
}

$(document).ready(function(){
  
  // set initial endpoint selection
  $('select[name=group_endpoint_selector]').children("optgroup").children("option").each(function(index) {
    if ($(this).val() == $('#endpoint_id').val()) {
      $(this).attr("selected", "selected");
    }
  });
  
  // endpoint selection changed
  $('select[name=group_endpoint_selector]').change(function(e) {
    e.stopImmediatePropagation();
    if ($(this).val() == "") return;
    
    location.href = '/endpoints/' + $(this).val();
  });
  
  // authentication method change
  $('select[name=authentication[auth_method]]').change(function() {
    // Reset fields
    $('#authentication-method-select input').each(function(index) {
      $(this).val("");
    });
    
    // Hide/Show related fields
    if ($(this).attr('value') == 'basic') {
      $('#authentication-oauth').hide();
      
      $('#authentication-basic').show();
    } else {
      $('#authentication-basic').hide();
      
      $('#authentication-oauth').show();
    }
  });

  // toggle parameter description
  $("div#parameter-set a.description-toggle").live('click', function(e) {
    e.stopImmediatePropagation();
    //$(this).next('div').toggle();
    //$(this).parents('tr').next('tr').children('td').children('div').toggle();
    $(this).closest('td').next().children('div').toggle();
    return false;
  });
  
  // toggle ALL parameter descriptions
  $('#parameters-expand-all').live('click', function(e) {
    e.stopImmediatePropagation();
    $("div#parameter-set a.description-toggle").each(function(index) {
      $(this).click();
    });
    return false;
  });
  
  // add temporary parameter
  $('#temporary-parameter-link').live('click', function(e) {
    e.stopImmediatePropagation();
    $('#parameter-set-temp').append(
      $('#parameter-temp').html()
    );
    return false;
  });
  
  // remove temporary parameter
  $('#parameter-set-temp a').live('click', function(e) {
    e.stopImmediatePropagation();
    $(this).parent().remove();
    return false;
  });
  
  // add temporary header
  $('#temporary-header-link').live('click', function(e) {
    e.stopImmediatePropagation();
    $('#header-set-temp').append(
      $('#header-temp').html()
    );
    return false;
  });
  
  // remove temporary header
  $('#header-set-temp a').live('click', function(e) {
    e.stopImmediatePropagation();
    $(this).parent().remove();
    return false;
  });
  
  // add auth
  $('input[name=auth]').change(function() {
    if ($(this).attr('value') == 'basic') {
      $('#basic-auth-fields').show();
      $('#basic-auth-fields .form-alpha').focus();
    } else {
      $('#basic-auth-fields').hide();
    }
  })
  $('#auth-selection :checked').change();
  
  // toggle response explanation
  $('#response-members-link').click(function(e) {
    e.stopImmediatePropagation();
    $('#explorer-response-explanation').toggle();
    return false;
  });
  
  // endpoints - change auth set
  //$('select[name=auth_set_selector]').children().eq(1).attr("selected", "selected");
  $('select[name=auth_set_selector]').children().each(function(index) {
    if ($(this).val() == $('#authentication_id').val()) {
      $(this).attr("selected", "selected");
    }
  });
  
  $('select[name=auth_set_selector]').change(function() {
    // Update auth set html
    $('#auth-set').html(
      $('#authentication_'+$(this).val()).html()
    );
    // Update auth id
    $('#authentication_id').val($(this).val());
  });
  
  // endpoints - change parameter set
  $('select[name=parameter_set]').children().first().attr("selected", "selected");
  
  $('select[name=parameter_set]').change(function() {
    // Update http method for parameter set
    $('#parameter-set-http-method').html(
      $('#parameter_set_'+$(this).val()).children('input').val()
    );
    
    // Update select option view link
    //$('#parameter-set-view').html("<a href='/parameter_sets/" + $(this).val() + "'>View</a>");
    
    // Update parameter set html
    $('#parameter-set').html(
      $('#parameter_set_'+$(this).val()).html()
    );
    
    // Update response explanations html
    $('#explorer-response-explanation').html(
      $('#response-members-'+$(this).val()).html()
    );
  });
  
  // clear!
  $('#clear-btn').click(function(e) {
     e.stopImmediatePropagation();
     $('#explorer-error').empty();
     $('#explorer-request').empty();
     $('#explorer-response').empty();
     return false;
   });
  
  // explore!
  $('#explore-form').submit(function(e) {
    e.stopImmediatePropagation();
    
    $('#explore-submit-btn').attr("disabled", "true");
    $('#explorer-loading').css({visibility: "visible"});
    
    $(this).explorerAjaxSubmit(function(res) {
      var data = JSON.parse(res);
      
      $("#explore-submit-btn").removeAttr('disabled');
      $('#explorer-loading').css({visibility: "hidden"});

      if (data.error) {
        // error response
        $('#explorer-error').html(data.error);
      } else if (data.header && data.body && data.request) {
        // successful response
        $('#explorer-request').html(data.request);
        $('#explorer-response').html('<pre>' + data.header + '</pre>' + data.body);
      } else {
        // odd error
        $('#explorer-error').html("Weird response. Sorry.")
      }
    });

    return false;
  });
  
});