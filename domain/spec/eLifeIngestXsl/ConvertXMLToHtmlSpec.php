<?php

namespace spec\eLifeIngestXsl;

use DOMDocument;
use eLifeIngestXsl\ConvertXML\XMLString;
use PhpSpec\Exception\Example\FailureException;
use PhpSpec\ObjectBehavior;
use Prophecy\Argument;

class ConvertXMLToHtmlSpec extends ObjectBehavior {
  private function setupXML($filename = '00288-vor') {
    $xml = XMLString::fromString(file_get_contents(dirname(__FILE__) . '/../../../tests/fixtures/jats/' . $filename . '.xml'));
    $this->beConstructedWith($xml);
  }

  public function it_might_have_an_abstract() {
    $this->setupXML();
    $abstract = file_get_contents(dirname(__FILE__) . '/../../../tests/fixtures/html/00288-vor-section-abstract.html');
    $this->getAbstract()->shouldHaveHTML($abstract);
  }

  public function it_might_have_a_digest() {
    $this->setupXML();
    $digest = file_get_contents(dirname(__FILE__) . '/../../../tests/fixtures/html/00288-vor-section-digest.html');
    $this->getDigest()->shouldHaveHTML($digest);
  }

  public function it_might_not_have_a_digest() {
    $this->setupXML('01911-poa');
    $this->getDigest()->shouldBeNull();
  }

  public function it_might_have_a_references_section() {
    $this->setupXML();
    $this->getReferences()->shouldNotBeNull();
  }

  public function it_might_not_have_a_references_section() {
    $this->setupXML('01911-poa');
    $this->getReferences()->shouldBeNull();
  }

  public  function it_might_have_an_acknowledgements_section() {
    $this->setupXML();
    $this->getAcknowledgements()->shouldNotBeNull();
  }

  public  function it_might_not_have_an_acknowledgements_section() {
    $this->setupXML('01911-poa');
    $this->getAcknowledgements()->shouldBeNull();
  }

  public  function it_might_have_a_decision_letter() {
    $this->setupXML();
    $this->getDecisionLetter()->shouldNotBeNull();
  }

  public  function it_might_not_have_a_decision_letter() {
    $this->setupXML('01911-poa');
    $this->getDecisionLetter()->shouldBeNull();
  }

  public  function it_might_have_a_author_response() {
    $this->setupXML();
    $this->getAuthorResponse()->shouldNotBeNull();
  }

  public  function it_might_not_have_a_author_response() {
    $this->setupXML('01911-poa');
    $this->getAuthorResponse()->shouldBeNull();
  }

  public function getMatchers() {
    return [
      'haveHTML' => function ($actual, $expected) {
        $html_prefix = '<meta http-equiv="content-type" content="text/html; charset=utf-8">';
        $wrapper = 'wrapper';
        libxml_use_internal_errors(TRUE);
        $actualDom = new DOMDocument();
        $actualDom->loadHTML($html_prefix . '<' . $wrapper . '>' . $actual . '</' . $wrapper . '>');

        $expectedDom = new DOMDocument();
        $expectedDom->loadHTML($html_prefix . '<' . $wrapper . '>' . $expected . '</' . $wrapper . '>');

        // Remove white space between tags.
        $from = ['/\>[^\S ]+/s', '/[^\S ]+\</s', '/(\s)+/s', '/> </s'];
        $to = ['>', '<', '\\1', '><'];
        $clean_actual = preg_replace($from, $to, $this->getInnerHtml($actualDom->getElementsByTagName($wrapper)->item(0)));
        $clean_expected = preg_replace($from, $to, $this->getInnerHtml($expectedDom->getElementsByTagName($wrapper)->item(0)));
        libxml_clear_errors();

        if ($clean_actual != $clean_expected) {
          throw new FailureException(sprintf('Expected "%s" but found "%s".', $clean_expected, $clean_actual));
        }
        return TRUE;
      },
    ];
  }

  /**
   * Get inner HTML.
   */
  function getInnerHtml($node) {
    $innerHTML = '';
    $children = $node->childNodes;
    foreach ($children as $child) {
      $innerHTML .= $child->ownerDocument->saveXML($child);
    }

    return trim($innerHTML);
  }
}
