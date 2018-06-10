<?php

use Behat\Behat\Context\Context;
use Lexik\Bundle\JWTAuthenticationBundle\Encoder\JWTEncoderInterface;

class SecurityContext implements Context
{
    /**
     * @var JWTEncoderInterface
     */
    private $jwtEncoder;

    private $restContext;

    public function __construct(
        JWTEncoderInterface $jwtEncoder
    ) {
        $this->jwtEncoder = $jwtEncoder;
    }

    /**
     * @Given I login as :user_email
     */
    public function loginAs($email)
    {
        $user = EntityContext::BASE_USER;
        $user["email"] = $email;

        $token = $this->jwtEncoder->encode($user);

        $this->restContext->iAddHeaderEqualTo('Authorization', "Bearer $token");
    }

    /**
     * @Given I login as my base user
     */
    public function loginAsBaseUser($user = EntityContext::BASE_USER)
    {
        $token = $this->jwtEncoder->encode($user);

        $this->restContext->iAddHeaderEqualTo('Authorization', "Bearer $token");
    }

    /**
     * @Given I login with an invalid token
     */
    public function loginWithInvalidToken()
    {
        $this->restContext->iAddHeaderEqualTo('Authorization', "Bearer invalid-token");
    }

    /**
     * @Given I logout
     */
    public function logoutAs()
    {
        $this->restContext->iAddHeaderEqualTo('Authorization', '');
    }

    /**
     * @BeforeScenario
     */
    public function prepareForTheScenario(\Behat\Behat\Hook\Scope\BeforeScenarioScope $scope)
    {
        $this->restContext = $scope->getEnvironment()->getContext(\Behatch\Context\RestContext::class);
    }

    /**
     * @BeforeScenario
     * @login
     */
    public function login(\Behat\Behat\Hook\Scope\BeforeScenarioScope $scope)
    {
        $this->restContext = $scope->getEnvironment()->getContext(\Behatch\Context\RestContext::class);

        $token = $this->jwtEncoder->encode(EntityContext::BASE_USER);

        $this->restContext->iAddHeaderEqualTo('Authorization', "Bearer $token");
    }

    /**
     * @AfterScenario
     * @login
     */
    public function logout() {
        $this->restContext->iAddHeaderEqualTo('Authorization', '');
    }
}
