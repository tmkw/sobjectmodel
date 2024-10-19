Feature: sObject Rows: GET (/services/data/vXX.X/sobjects/sObject/id/) 

  Scenario: get an Object record successfully
    When API client sends a request to get object record
    """
    rest_client.find :Contact, contact_id
    """
    Then it gets the object record

  Scenario: get an Object record with selecting fields
    When API client sends a request to get object record
    """
    rest_client.find :Contact, contact_id, fields: [:Name]
    """
    Then it gets the object field values
