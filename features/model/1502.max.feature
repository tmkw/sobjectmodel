Feature: find maximum value

  Scenario Outline: find maximum one with conditions
    Given <connection type>
    And "Account" class is already generated
    And there are some accounts who operate in Japan
    When finding the maximum AnnualRevenue in Japan 
    """
    Account.where(BillingCountry: "Japan").max(:AnnualRevenue)
    """
    Then it gets the maximum annual revenue

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
