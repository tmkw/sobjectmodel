Feature: take an arbitary record

  Background:
    Given "Account" class is already generated

  Scenario: take one of account record arbitary
    When taking an account
    """
    Account.take
    """
    Then it gets one of accounts

  Scenario: take with conditions
    Given there are some accounts whose name starts with ABC
    When finding an account
    """
    Account.where(:Name, :LIKE, "ABC%").take
    """
    Then it gets one of them

  Scenario: fails when there is no record to match
    When finding an account
    """
    Account.where(Name: "Mr.No one").take
    """
    Then it gets nil
