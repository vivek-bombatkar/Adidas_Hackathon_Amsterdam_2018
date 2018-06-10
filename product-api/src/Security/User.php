<?php

namespace App\Security;

use Lexik\Bundle\JWTAuthenticationBundle\Security\User\JWTUserInterface;

class User implements JWTUserInterface
{
    private $username;

    private $roles;

    public function __construct(
        $username,
        array $roles = []
    ) {
        $this->username = $username;
        $this->roles = $roles;
    }

    public static function createFromPayload($username, array $payload)
    {
        return new self($username, ["ROLE_USER"]);
    }

    public function getUsername()
    {
        return $this->username;
    }

    public function getRoles()
    {
        return $this->roles;
    }

    public function getPassword()
    {
    }

    public function getSalt()
    {
    }

    public function eraseCredentials()
    {
    }
}