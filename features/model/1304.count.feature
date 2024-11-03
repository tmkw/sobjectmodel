Feature: count records

  Scenario Outline: count each group
    Given <connection type>
    Given "Account" class is already generated
    Given there are some accounts who operate in Japan
    When counting each city's accounts in Japan
    """
    Account.where(BillingCountry: 'Japan').group(:BillingCity).count
    """
    Then it gets the number

    Examples:
      |connection type|
      |rest           |
      |CLI/sf         |
