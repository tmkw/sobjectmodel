Feature: take an arbitary record

  Scenario Outline: take with conditions
    Given <connection type>
    And "Account" class is already generated
    And there are some accounts whose name starts with ABC
    When finding an account
    """
    Account.where(:Name, :LIKE, "ABC%").take
    """
    Then it gets one of them

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
