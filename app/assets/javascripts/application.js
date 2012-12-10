//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require underscore-min
//= require backbone-min
//= require_tree .

jQuery(function($) {
  var call = new Call();
  var userState = new UserState({call: call});

  $('a.call').each(function(index, element) {
    new ClickToCallView({el: element, model: call});
  });
  new CallView({model: call});
  new NextCustomerView({model: userState});
});
