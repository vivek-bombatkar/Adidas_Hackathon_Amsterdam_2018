<?php

namespace App\EventListener;

use App\Security\User;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Security\Core\Authentication\Token\Storage\TokenStorageInterface;
use Doctrine\Common\Persistence\ObjectManager;
use Doctrine\Common\Annotations\Reader;

final class OwnerFilterConfigurator
{
    private $em;
    private $tokenStorage;
    private $reader;

    public function __construct(ObjectManager $em, TokenStorageInterface $tokenStorage, Reader $reader)
    {
        $this->em = $em;
        $this->tokenStorage = $tokenStorage;
        $this->reader = $reader;
    }

    public function onKernelRequest(): void
    {
        if (!$user = $this->getUser()) {
            return;
        }


        $filter = $this->em->getFilters()->enable('owner_filter');

        $filter->setParameter('owner', $user->getUsername());

        $filter->setAnnotationReader($this->reader);
    }

    private function getUser(): ?User
    {
        if (!$token = $this->tokenStorage->getToken()) {
            return null;
        }

        $user = $token->getUser();
        return $user instanceof User ? $user : null;
    }
}
