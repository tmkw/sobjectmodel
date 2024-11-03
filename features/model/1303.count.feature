Feature: count records

  Scenario Outline: count specific field
    Given <connection type>
    Given "Account" class is already generated
    When counting websites of all accounts
    """
    Account.count :Website
    """
    Then it gets the number of websites

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
