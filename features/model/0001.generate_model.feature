Feature: Generate Object model class

  Scenario: generate sObject classes successfully
    Given connection to Salesforce is ready
    """
    SObjectModel.connect(:rest, instance_url: host, access_token: token, api_version: api_ver)
    """
    When starting generation: Account, Contact and User
    """
    SObjectModel.generate(:Account, :Contact, :User)
    """
    Then all classes get generated


  Scenario: Another way to connect 
    Given connection to Salesforce is ready
    """
    client = SObjectModel::Rest::Client.new(instance_url: host, access_token: token, api_version: api_ver)
    SObjectModel.connection = SObjectModel::Adapter::Rest.new(client)
    """
    When starting generation: Case, Opportunity and Task
    """
    SObjectModel.generate(:Case, :Opportunity, :Task)
    """
    Then all classes get generated
