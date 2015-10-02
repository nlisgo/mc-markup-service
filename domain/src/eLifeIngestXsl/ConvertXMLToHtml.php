<?php

namespace eLifeIngestXsl;

use DOMDocument;
use DOMNode;
use DOMXPath;
use eLifeIngestXsl\ConvertXML\XMLString;
use eLifeIngestXsl\ConvertXML\XSLString;
use XSLTProcessor;

class ConvertXMLToHtml {
  /**
   * @var string
   */
  private $xml;
  /**
   * @var string
   */
  private $xsl;
  /**
   * @var string
   */
  private $html;

  /**
   * @param XMLString $xml
   */
  public function __construct(XMLString $xml) {
    $this->xml = $xml->getValue();
  }

  public function getXML() {
    return XMLString::fromString($this->xml);
  }

  public function getXSL() {
    return XSLString::fromString($this->xsl);
  }

  private function setXSL($xsl) {
    realpath(dirname(__FILE__));
    $this->xsl = XSLString::fromString(file_get_contents(realpath(dirname(__FILE__)) . '/../../../ElifeWebService/src/main/resources' . '/' . $xsl . '.xsl'))->getValue();
  }

  public function getOutput() {
    $sections = [
      'Abstract' => 'getAbstract',
      'Digest' => 'getDigest',
      'Acknowledgements' => 'getAcknowledgements',
      'DecisionLetter' => 'getDecisionLetter',
      'AuthorResponse' => 'getAuthorResponse',
      'References' => 'getReferences',
    ];
    $output = [];
    foreach ($sections as $section => $method) {
      $output[] = sprintf('<!-- Start of %s //-->', $section);
      $output[] = call_user_func([$this, $method]);
      $output[] = sprintf('<!-- End of %s //-->', $section);
    }

    return implode(PHP_EOL . PHP_EOL, $output);
  }

  /**
   * @return string
   */
  public function getAbstract() {
    $this->setXSL('abstract');
    return $this->getSection("//abstract[not(@abstract-type)]");
  }

  /**
   * @return string
   */
  public function getDigest() {
    $this->setXSL('digest');
    return $this->getSection("//abstract[@abstract-type='executive-summary']");
  }

  /**
   * @return string
   */
  public function getAcknowledgements()
  {
    $this->setXSL('ack');
    return $this->getSection("//ack");
  }

  /**
   * @return string
   */
  public function getDecisionLetter()
  {
    $this->setXSL('desLetter');
    return $this->getSection("//sub-article[@article-type='article-commentary']");
  }

  /**
   * @return string
   */
  public function getAuthorResponse()
  {
    $this->setXSL('authorResponse');
    return $this->getSection("//sub-article[@article-type='reply']");
  }

  /**
   * @return string
   */
  public function getReferences()
  {
    $this->setXSL('reference');
    return $this->getSection("//ref-list");
  }

  /**
   * @param string $xpath_query
   * @return string
   */
  public function getSection($xpath_query) {
    libxml_use_internal_errors(TRUE);
    $actual = new DOMDocument;
    $actual->loadXML($this->getXML());
    $xpath = new DOMXPath($actual);
    $elements = $xpath->query($xpath_query);

    if (!empty($elements) && $elements->length > 0) {
      $new = new DOMDocument;
      $new->appendChild($new->importNode($elements->item(0), TRUE));

      $xsl = new DOMDocument;
      $xsl->loadXML($this->getXSL());

      // Configure the transformer.
      $proc = new XSLTProcessor;
      // Attach the xsl rules.
      $proc->importStyleSheet($xsl);

      $output = $proc->transformToXML($new);
      $actual->loadXML($output);
      return $this->getInnerHtml($actual->getElementsByTagName('body')->item(0));
    }
  }

  /**
   * @param DOMNode $node
   * @return string
   */
  private function getInnerHtml($node) {
    $innerHTML = '';
    $children = $node->childNodes;
    foreach ($children as $child) {
      $innerHTML .= $child->ownerDocument->saveXML($child);
    }

    return trim($innerHTML);
  }
}
