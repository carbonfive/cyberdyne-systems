Given /^a user is logged in$/ do
  visit '/sign_in'
  fill_in 'user_session_email', with: bot(:ahnold).email
  fill_in 'user_session_password', with: bot(:ahnold).password
  click_button 'Sign In'
end

Given /^the user enters a phone number$/ do
  within('div#call') do
    fill_in 'number', with: bot(:kyle).phone_number
  end
end

Given /^the user clicks the Call button$/ do
  click_button 'Dial'
end

Then /^the user's phone is called$/ do
  bot(:ahnold).should be_on_a_call
end

Then /^the user's phone is not called$/ do
  bot(:ahnold).should_not be_on_a_call
end

Then /^the phone number is called$/ do
  bot(:kyle).should be_on_a_call
end

Then /^they are speaking to each other$/ do
  bot(:kyle).should be_on_a_call_with(bot(:ahnold))
end

Given /^an unknown caller dials the main line$/ do
  bot(:kyle).make_a_call_to(CYBERDYNE_STAGING_PHONE_NUMBER)
end

When /^the user cicks the Next Target button$/ do
  click_button 'Next Target'
end

When /^some time has passed$/ do
  sleep 10
end

When /^an known caller dials the main line$/ do
  bot(:sarah).make_a_call_to(CYBERDYNE_STAGING_PHONE_NUMBER)
end
