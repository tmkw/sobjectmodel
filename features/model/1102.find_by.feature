Feature: Find a record by query condtions

  Scenario Outline: fail to find
    Given <connection type>
    And "Account" class is already generated
    When finding an account
    """
    Account.find_by Name: "Nowhere.co"
    """
    Then it gets nil

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
