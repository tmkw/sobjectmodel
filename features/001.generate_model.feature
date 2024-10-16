Feature: Generate Object model class

  Scenario: generate sObject classes successfully
    Given connection to Salesforce is ready
    """
    Yamori.connect(:rest, instance_url: host, access_token: token, api_version: api_ver)
    """
    When starting generation:
    """
    Yamori.generate(:Account, :Contact, :User)
    """
    Then all classes get generated
