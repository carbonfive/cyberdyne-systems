@javascript @wopr
Feature: Servicing Outbound Call
  A user can enter phone number so that they can call it

  Scenario: Simple Session
    Given a user is logged in
      And the user enters a phone number
      And the user clicks the Call button
    Then the user's phone is called
      And the phone number is called
      And they are speaking to each other
