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


    Scenario: update a field to empty (=NULL)
    Given "Account" class is already generated
    And gets an account
    """
    @an_account = Account.find account_id
    """
    And sets empty the account's billing city
    """
    @an_account.BillingCity = nil
    """
    When updating the account
    """
    @an_account.save
    """
    Then the account get updated
    And the account's billing city is empty
