Feature: Create a record

  Scenario Outline: Create a record successfully
    Given <connection type>
    And "Account" class is already generated
    When creating an account
    """
    Account.create Name: "New Account", BillingCity: "Sapporo"
    """
    Then the account is created

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
