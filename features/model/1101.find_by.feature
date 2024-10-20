Feature: Find a record by query condtions

  Scenario Outline: Find a record by query condtions successfully
    Given <connection type>
    And "Account" class is already generated
    When finding an account
    """
    Account.find_by Name: account_name
    """
    Then it gets the account

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
