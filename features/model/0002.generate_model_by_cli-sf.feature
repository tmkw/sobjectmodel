Feature: Generate Object model class by Sf command(sf_cli/sf)

  Scenario: generate sObject classes successfully
    Given connection to Salesforce is ready
    """
    Yamori.connect :"cli/sf", target_org: org_alias
    """
    When starting generation: Account, Contact and User
    """
    Yamori.generate(:Account, :Contact, :User)
    """
    Then all classes get generated
