Feature: count records

  Background:
    Given "Account" class is already generated

  Scenario: count all records
    When counting all accounts
    """
    Account.count
    """
    Then it gets the number


  Scenario: count with conditions
    Given there are some accounts whose name starts with ABC
    When counting accounts whose names start by ABC
    """
    Account.where(:Name, :LIKE, "ABC%").count
    """
    Then it gets the number


  Scenario: count specific field
    When counting websites of all accounts
    """
    Account.count :Website
    """
    Then it gets the number of websites


  Scenario: count each group
    Given there are some accounts who operate in Japan
    When counting each city's accounts in Japan
    """
    Account.where(BillingCountry: 'Japan').group(:BillingCity).count
    """
    Then it gets the number
