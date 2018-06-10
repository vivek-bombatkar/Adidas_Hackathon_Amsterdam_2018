<?php

namespace App\EventListener;


use App\Model\OwnerAwareInterface;
use App\Security\User;
use Doctrine\ORM\Event\LifecycleEventArgs;
use Symfony\Component\Security\Core\Authentication\Token\Storage\TokenStorage;

class OwnerAwareListener
{
    /**
     * @var TokenStorage
     */
    protected $tokenStorage;


    public function __construct(TokenStorage $tokenStorage)
    {
        $this->tokenStorage = $tokenStorage;
    }

    public function prePersist(LifecycleEventArgs $args)
    {
        $entity = $args->getEntity();
        if (!$entity instanceof OwnerAwareInterface) {
            return;
        }

        if ($userToken = $this->tokenStorage->getToken()) {
            /** @var User $user */
            $user = $userToken->getUser();

            $entity->setOwner($user->getUsername());
            $entity->setCreatedBy($user->getUsername());
        }
    }
}