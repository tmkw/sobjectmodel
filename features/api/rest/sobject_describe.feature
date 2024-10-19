Feature: sObject Describe (GET /services/data/vXX.X/sobjects/sObject/describe/) 

  Scenario: get an Object schema successfully
    When API client sends a request to get object schema
    """
    rest_client.describe :Account
    """
    Then it gets the schema
