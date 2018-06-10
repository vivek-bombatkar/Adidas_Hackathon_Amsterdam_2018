Feature: Manage products
  @createSchema
  Scenario: Retrieve the product list
    Given the following products:
      | id                                   | attributes            |
      | a349e23f-ae57-487c-88ee-2efa49684fd7 | attr1=val1,attr2=val2 |
      | d54f18be-fca1-4b8d-b389-12eb288935f4 | attr1=val1            |
    When I add "Content-Type" header equal to "application/json"
    And I add "Accept" header equal to "application/json"
    And I send a "GET" request to "/products"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/json; charset=utf-8"
    And print last response
    And the response should match:
    """
    [
      {
        "id": "a349e23f-ae57-487c-88ee-2efa49684fd7",
        "attributes": "@array@.count(2)",
        "name": "@string@",
        "owner": "@string@"
      },
      {
        "id": "d54f18be-fca1-4b8d-b389-12eb288935f4",
        "attributes": "@array@.count(1)",
        "name": "@string@",
        "owner": "@string@"
      }
    ]
    """

  @createSchema
  Scenario: Get a product
    Given the following products:
      | id                                   | attributes            |
      | a349e23f-ae57-487c-88ee-2efa49684fd7 | attr1=val1,attr2=val2 |
    When I add "Content-Type" header equal to "application/ld+json"
    And I add "Accept" header equal to "application/ld+json"
    And I send a "GET" request to "/products/a349e23f-ae57-487c-88ee-2efa49684fd7"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the response should match:
    """
    {
      "@context": "/contexts/Product",
      "@id": "@string@.startsWith('/products/')",
      "@type": "Product",
      "id": @uuid@,
      "attributes": "@array@.count(2)",
      "name": "@string@",
      "owner": "@string@"
    }
    """