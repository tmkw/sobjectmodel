Feature: Create a record

  Scenario Outline: Another way to create
    Given <connection type>
    And "Account" class is already generated
    And new account variable is created
    """
    @new_account = Account.new(Name: "New Account", BillingCity: "Sapporo")
    """
    When saving the account
    """
    @new_account.save
    """
    Then the account is created

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
