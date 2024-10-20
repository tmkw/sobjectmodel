Feature: Find a record by ID

  Scenario Outline: Find a record by ID
    Given <connection type>
    And "Account" class is already generated
    And <record existance>
    When finding an account
    """
    Account.find account_id
    """
    Then it gets <result>

    Examples:
      |connection type|record existance|result     |
      |rest           |○               |the account|
      |rest           |X               |nil        |
      |CLI/sf         |○               |the account|
      |CLI/sf         |X               |nil        |
