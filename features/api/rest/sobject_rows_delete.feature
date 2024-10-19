Feature: sObject Rows: DELETE (/services/data/vXX.X/sobjects/sObject/id/) 

  Scenario: delete an Object record successfully
    When API client sends a request to delete object record
    """
    rest_client.delete :Contact, contact_id
    """
    Then the record gets deleted
