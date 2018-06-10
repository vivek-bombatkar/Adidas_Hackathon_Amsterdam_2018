Feature: Security
  @createSchema
  Scenario: Check JWT Token not found
    Given I logout
    When I add "Accept" header equal to "application/json"
    And I send a "GET" request to "/"
    Then the response status code should be 401
    And the response should match:
    """
    {
      "code": 401,
      "message": "JWT Token not found"
    }
    """
    And I send a "GET" request to "/products"
    Then the response status code should be 401

  @createSchema
  Scenario: Check JWT Token not valid
    Given I login with an invalid token
    When I add "Accept" header equal to "application/json"
    And I send a "GET" request to "/"
    Then the response status code should be 401
    And the response should match:
    """
    {
      "code": 401,
      "message": "Invalid JWT Token"
    }
    """


  @createSchema
  Scenario: Retrieve the thing list
    Given the following products:
      | id                                   | owner |
      | a349e23f-ae57-487c-88ee-2efa49684fd7 | a62e64e2-e6ba-4484-9182-1b19917241fd     |
      | d54f18be-fca1-4b8d-b389-12eb288935f4 | a62e64e2-e6ba-4484-9182-1b19917241fd     |
      | f06a6b62-cd84-4b31-94b7-0badff67a366 | a62e64e2-e6ba-4484-9182-1b19917241fc     |
    When I add "Accept" header equal to "application/json"
    Given I login as "a62e64e2-e6ba-4484-9182-1b19917241fd"
    And I send a "GET" request to "/products"
    And the response should contain 2 elements
    When I add "Accept" header equal to "application/json"
    Given I login as "a62e64e2-e6ba-4484-9182-1b19917241fc"
    And I send a "GET" request to "/products"
    And the response should contain 1 elements
    When I add "Accept" header equal to "application/json"
    Given I login as "a62e64e2-e6ba-4484-9182-1b19917241fb"
    And I send a "GET" request to "/products"
    And the response should contain 0 elements

