Feature: sObject Rows: PATCH (/services/data/vXX.X/sobjects/sObject/id/) 

  Scenario: update an Object record successfully
    When API client sends a request to update object record
    """
    rest_client.update :Contact, contact_id, LastName: 'Name Updated'
    """
    Then the record gets updated
