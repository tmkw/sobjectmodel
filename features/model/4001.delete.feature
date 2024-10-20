Feature: Delete a record

  Scenario Outline: Delete a record successfully
    Given <connection type>
    And "Account" class is already generated
    And get a record
    """
    @an_account = Account.find account_id
    """
    When delete the account
    """
    @an_account.delete
    """
    Then the account is deleted

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
