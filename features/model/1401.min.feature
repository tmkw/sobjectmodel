Feature: find minimum value

  Scenario Outline: find minimum value in all records
    Given <connection type>
    And "Account" class is already generated
    When finding mimimum AnnualRevenue in all accounts
    """
    Account.min(:AnnualRevenue)
    """
    Then it gets the minimum annual revenue

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
