@javascript @wopr
Feature: Unknown Caller Dialing Mainline
  When an unknown caller dials into the mail line, they are placed on queue

  Scenario: Unkown Caller
    Given a user is logged in
    When an unknown caller dials the main line
    Then the user's phone is not called
    When some time has passed
      And the user cicks the Next Target button
    Then the user's phone is called
    When some time has passed
    Then they are speaking to each other
