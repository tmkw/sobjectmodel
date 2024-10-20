Feature: count records

  Scenario Outline: count with conditions
    Given <connection type>
    Given "Account" class is already generated
    Given there are some accounts whose name starts with ABC
    When counting accounts whose names start by ABC
    """
    Account.where(:Name, :LIKE, "ABC%").count
    """
    Then it gets the number

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
