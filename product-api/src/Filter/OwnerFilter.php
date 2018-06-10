<?php
namespace App\Filter;

use App\Annotation\OwnerAware;
use App\Model\OwnerAwareInterface;
use Doctrine\ORM\Mapping\ClassMetaData;
use Doctrine\ORM\Query\Filter\SQLFilter;
use Doctrine\Common\Annotations\Reader;

final class OwnerFilter extends SQLFilter
{
    private $reader;

    public function addFilterConstraint(ClassMetadata $targetEntity, $targetTableAlias): string
    {
        if (null === $this->reader) {
            throw new \RuntimeException(sprintf('An annotation reader must be provided. Be sure to call "%s::setAnnotationReader()".', __CLASS__));
        }

        // The Doctrine filter is called for any query on any entity
        // Check if the current entity is "user aware" (marked with an annotation)
        $userAware = $this->reader->getClassAnnotation($targetEntity->getReflectionClass(), OwnerAware::class);

        if (!$userAware) {
            return '';
        }

        $fieldName = $userAware->ownerFieldName;
        try {
            // Don't worry, getParameter automatically escapes parameters
            $owner = $this->getParameter('owner');
        } catch (\InvalidArgumentException $e) {
            // No user id has been defined
            return '';
        }

        if (empty($fieldName) || empty($owner)) {
            return '';
        }

        return sprintf('%s.%s = %s', $targetTableAlias, $fieldName, $owner);
    }

    public function setAnnotationReader(Reader $reader): void
    {
        $this->reader = $reader;
    }
}