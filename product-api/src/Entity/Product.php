<?php

namespace App\Entity;

use ApiPlatform\Core\Annotation\ApiProperty;
use ApiPlatform\Core\Annotation\ApiResource;
use App\Annotation\OwnerAware;
use App\Model\OwnerAwareInterface;
use Doctrine\ORM\Mapping as ORM;
use Ramsey\Uuid\Uuid;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * @ORM\Entity
 * @ApiResource(
 *     collectionOperations={
 *         "get"={"path"="/wardrobe"},
 *     },
 *     itemOperations={
 *         "get"={},
 *     }
 * )
 * @OwnerAware(ownerFieldName="owner")
 */
class Product implements OwnerAwareInterface
{
    /**
     * @var string
     *
     * @ORM\Column(type="guid")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="NONE")
     */
    private $id;

    /**
     * @var array
     *
     * @ORM\Column(type="json_array", nullable=true)
     * @ApiProperty()
     */
    private $attributes = [];

    /**
     * @var string
     *
     * @ORM\Column(type="string", nullable=true, options={"default" : "unnamed"})
     * @ApiProperty()
     */
    private $name = "unnamed";

    /**
     * @var string
     *
     * @ORM\Column(type="string")
     */
    private $owner = "";

    public function __construct()
    {
        $this->id = Uuid::uuid4();
    }

    public function getId(): string
    {
        return $this->id;
    }

    public function getAttributes(): array
    {
        return $this->attributes;
    }

    public function setAttributes(array $attributes): void
    {
        $this->attributes = $attributes;
    }

    /**
     * @return string
     */
    public function getName(): string
    {
        return $this->name;
    }

    /**
     * @param string $name
     */
    public function setName(string $name): void
    {
        $this->name = $name;
    }

    public function getOwner(): string
    {
        return $this->owner;
    }

    public function setOwner(string $owner): void
    {
        $this->owner = $owner;
    }
}
