Feature: sObject Basic Information: POST (/services/data/vXX.X/sobjects/sObject/) 

  Scenario: create an Object record successfully
    When API client sends a request to create object record
    """
    rest_client.create :Contact, LastName: 'New Contact Name'
    """
    Then the record gets created
