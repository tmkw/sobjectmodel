Feature: find minimum value

  Background:
    Given "Account" class is already generated

  Scenario: find minimum value in all records
    When finding mimimum AnnualRevenue in all accounts
    """
    Account.min(:AnnualRevenue)
    """
    Then it gets the minimum annual revenue


  Scenario: find minimum one with conditions
    Given there are some accounts who operate in Japan
    When finding the minimum AnnualRevenue in Japan 
    """
    Account.where(BillingCountry: "Japan").min(:AnnualRevenue)
    """
    Then it gets the minimum annual revenue


  Scenario: find minimum one in each group
    Given there are some accounts who operate in Japan
    When finding the minimum AnnualRevenue of each city in Japan
    """
    Account.where(BillingCountry: 'Japan').group(:BillingCity).min(:AnnualRevenue)
    """
    Then it gets the minimum annual revenue
