Feature: Find a record by query condtions

  Background:
    Given "Account" class is already generated

  Scenario: Find a record by query condtions successfully
    When finding an account
    """
    Account.find_by Name: account_name
    """
    Then it gets the account

  Scenario: fail to find
    When finding an account
    """
    Account.find_by Name: "Nowhere.co"
    """
    Then it gets nil
