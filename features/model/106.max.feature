Feature: find maximum value

  Background:
    Given "Account" class is already generated

  Scenario: find maximum value in all records
    When finding maximum AnnualRevenue in all accounts
    """
    Account.max(:AnnualRevenue)
    """
    Then it gets the maximum annual revenue


  Scenario: find maximum one with conditions
    Given there are some accounts who operate in Japan
    When finding the maximum AnnualRevenue in Japan 
    """
    Account.where(BillingCountry: "Japan").max(:AnnualRevenue)
    """
    Then it gets the maximum annual revenue


  Scenario: find maximum one in each group
    Given there are some accounts who operate in Japan
    When finding the maximum AnnualRevenue of each city in Japan
    """
    Account.where(BillingCountry: 'Japan').group(:BillingCity).max(:AnnualRevenue)
    """
    Then it gets the maximum annual revenue
