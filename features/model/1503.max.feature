Feature: find maximum value

  Scenario Outline: find maximum one in each group
    Given <connection type>
    And "Account" class is already generated
    And there are some accounts who operate in Japan
    When finding the maximum AnnualRevenue of each city in Japan
    """
    Account.where(BillingCountry: 'Japan').group(:BillingCity).max(:AnnualRevenue)
    """
    Then it gets the maximum annual revenue

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
