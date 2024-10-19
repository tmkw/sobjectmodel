Feature: Create a record

  Background:
    Given "Account" class is already generated

  Scenario: Create a record successfully
    When creating an account
    """
    Account.create Name: "New Account", BillingCity: "Sapporo"
    """
    Then the account is created


  Scenario: Another way to create
    Given new account variable is created
    """
    @new_account = Account.new(Name: "New Account", BillingCity: "Sapporo")
    """
    When saving the account
    """
    @new_account.save
    """
    Then the account is created
