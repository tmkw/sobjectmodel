Feature: find maximum value

  Scenario Outline: find maximum value in all records
    Given <connection type>
    And "Account" class is already generated
    When finding maximum AnnualRevenue in all accounts
    """
    Account.max(:AnnualRevenue)
    """
    Then it gets the maximum annual revenue

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
