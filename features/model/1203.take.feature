Feature: take an arbitary record

  Scenario Outline: fails when there is no record to match
    Given <connection type>
    And "Account" class is already generated
    When finding an account
    """
    Account.where(Name: "Mr.No one").take
    """
    Then it gets nil

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
