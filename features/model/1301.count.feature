Feature: count records

  Scenario Outline: count all records
    Given <connection type>
    Given "Account" class is already generated
    When counting all accounts
    """
    Account.count
    """
    Then it gets the number

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
