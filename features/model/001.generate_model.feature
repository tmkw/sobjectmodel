Feature: Generate Object model class

  Scenario: generate sObject classes successfully
    Given connection to Salesforce is ready
    """
    Yamori.connect(:rest, instance_url: host, access_token: token, api_version: api_ver)
    """
    When starting generation: Account, Contact and User
    """
    Yamori.generate(:Account, :Contact, :User)
    """
    Then all classes get generated


  Scenario: Another way to connect 
    Given connection to Salesforce is ready
    """
    client = Yamori::Rest::Client.new(instance_url: host, access_token: token, api_version: api_ver)
    Yamori.connection = Yamori::Adapter::Rest.new(client)
    """
    When starting generation: Case, Opportunity and Task
    """
    Yamori.generate(:Case, :Opportunity, :Task)
    """
    Then all classes get generated
