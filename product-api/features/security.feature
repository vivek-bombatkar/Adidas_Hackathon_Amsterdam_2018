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
