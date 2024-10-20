Feature: Update a record

  Scenario Outline: Update a record successfully
    Given <connection type>
    And "Account" class is already generated
    And get a record
    """
    @an_account = Account.find account_id
    """
    And change the account's billing city to Kanazawa
    When updating the account
    """
    @an_account.save
    """
    Then the account is updated

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
