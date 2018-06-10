<?php

use Behat\Gherkin\Node\PyStringNode;
use Behatch\Context\JsonContext as BaseJsonContext;
use Behatch\HttpCall\HttpCallResultPool;
use Coduo\PHPMatcher\Factory\SimpleFactory;

final class JsonContext extends BaseJsonContext
{
    public function __construct(HttpCallResultPool $httpCallResultPool)
    {
        parent::__construct($httpCallResultPool);
    }

    /**
     * @Then the response should match:
     */
    public function theResponseShouldMatch(PyStringNode $string) {
        $expectedValue = $string->getRaw();

        $response = $this->getJson();

        $factory = new SimpleFactory();
        $matcher = $factory->createMatcher();

        if(!$matcher->match((string)$response, $expectedValue)) {
            $message = (string) $matcher->getError();

            throw new \Exception($message);
        }
    }

    /**
     * @Then the response should contain :nb elements
     */
    public function theResponseShouldContainElm($nb) {
        $response = $this->getJson();

        $count = count($response->getContent());

        if($count != $nb) {
            throw new \Exception("The response does not contain $nb elements but $count.");
        }
    }
}
