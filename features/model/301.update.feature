Feature: Update a record

  Background:
    Given "Account" class is already generated

  Scenario: Update a record successfully
    Given get a record
    """
    @an_account = Account.find account_id
    """
    And change the account's billing city to Kanazawa
    When updating the account
    """
    @an_account.save
    """
    Then the account is updated
