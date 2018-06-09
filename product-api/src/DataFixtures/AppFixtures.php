<?php
namespace App\DataFixtures;

use App\Entity\Product;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Common\Persistence\ObjectManager;

class AppFixtures extends Fixture
{
    public const MAIN_USER = "b22d5aba-d2af-4af8-ad5a-6a5695be2eca";

    public const MAIN_PRODUCT_REF = "main-product";

    public function load(ObjectManager $manager)
    {
        $product = new Product();

        $product->setName("Powerlift.3.1 Shoes");

        $product->setAttributes([
            "Gender" => "Women",
            "Sports" => "Weightlifting",
            "Category" => "Shoes",
            "Color" => "Black / Red",
            "Size" => "38",
            "Product features" => "ADIWEAR™ outsole, Weightlifting-engineered",
            "Image" => ""
        ]);

        $manager->persist($product);


        $manager->flush();

        $this->addReference(self::MAIN_PRODUCT_REF, $product);
    }
}