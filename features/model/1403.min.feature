Feature: find minimum value

  Scenario Outline: find minimum one in each group
    Given <connection type>
    And "Account" class is already generated
    And there are some accounts who operate in Japan
    When finding the minimum AnnualRevenue of each city in Japan
    """
    Account.where(BillingCountry: 'Japan').group(:BillingCity).min(:AnnualRevenue)
    """
    Then it gets the minimum annual revenue

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
