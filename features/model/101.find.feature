Feature: Find a record by ID

  Background:
    Given "Account" class is already generated

  Scenario Outline: Find a record by ID
    Given <record existance>
    When finding an account
    """
    Account.find account_id
    """
    Then it gets <result>

    Examples:
      |record existance|result     |
      |○               |the account|
      |X               |nil        |
