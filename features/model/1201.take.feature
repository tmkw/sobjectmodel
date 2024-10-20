Feature: take an arbitary record

  Scenario Outline: take one of account record arbitary
    Given <connection type>
    And "Account" class is already generated
    When taking an account
    """
    Account.take
    """
    Then it gets one of accounts

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
