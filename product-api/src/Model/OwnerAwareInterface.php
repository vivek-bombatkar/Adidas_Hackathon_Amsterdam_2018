<?php

namespace App\Model;


interface OwnerAwareInterface
{
    public function setOwner(string $owner);

    public function getOwner();
}