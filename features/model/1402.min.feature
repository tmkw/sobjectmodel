Feature: find minimum value

  Scenario Outline: find minimum one with conditions
    Given <connection type>
    And "Account" class is already generated
    Given there are some accounts who operate in Japan
    When finding the minimum AnnualRevenue in Japan 
    """
    Account.where(BillingCountry: "Japan").min(:AnnualRevenue)
    """
    Then it gets the minimum annual revenue

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
