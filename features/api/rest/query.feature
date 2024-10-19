Feature: Query: GET (/services/data/vXX.X/query?q=query) 

  Scenario: get Object records with SOQL successfully
    Given there are 3 contacts whose names start with XYZ
    When API client sends a request to get records by SOQL
    """
    rest_client.query "SELECT Id, Name FROM Contact WHERE Name LIKE 'XYZ%'"
    """
    Then it gets the records
