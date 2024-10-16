Feature: Delete a record

  Background:
    Given "Account" class is already generated

  Scenario: Delete a record successfully
    Given get a record
    """
    @an_account = Account.find account_id
    """
    When delete the account
    """
    @an_account.delete
    """
    Then the account is deleted
