@javascript @wopr
Feature: Known Caller Dialing Mainline
  When an known caller dials into the mail line, they are transferred to a user immediately

  Scenario: Unkown Caller
    Given a user is logged in
    When an known caller dials the main line
    Then the user's phone is called
      And they are speaking to each other
