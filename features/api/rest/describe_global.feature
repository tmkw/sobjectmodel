Feature: Describe Global (GET /services/data/vXX.X/sobjects/) 

  Scenario: get a list of all sObject successfully
    When API client sends a request to get all object schema
    """
    rest_client.describe_global
    """
    Then it gets the list of all sobject and some system settings
