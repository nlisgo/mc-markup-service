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
  private $file;

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

  private function setFile($xsl) {
    $this->file = realpath(dirname(__FILE__)) . '/../../../ElifeWebService/src/main/resources/' . $xsl . '.xsl';
  }

  private function getFile() {
    return $this->file;
  }

  private function setXSL($xsl) {
    $this->setFile($xsl);
    $this->xsl = XSLString::fromString(file_get_contents($this->getFile()))->getValue();
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
    $this->setXSL('abstract');
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
    $this->setXSL('sub-article');
    return $this->getSection("//sub-article[@article-type='article-commentary']");
  }

  /**
   * @return string
   */
  public function getAuthorResponse()
  {
    $this->setXSL('sub-article');
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
   * @param string $method
   * @param string|null $argument
   * @param string $xpath_query
   * @return string
   */
  public function getHtmlXpath($method, $argument = NULL, $xpath_query = '')
  {
    if (empty($argument)) {
      $argument = [];
    }
    elseif (is_string($argument)) {
      $argument = [$argument];
    }

    $output = call_user_func_array([$this, $method], $argument);

    if (!empty($output) && !empty($xpath_query)) {
      libxml_use_internal_errors(TRUE);
      $dom = new DOMDocument();
      $dom->loadHTML('<meta http-equiv="content-type" content="text/html; charset=utf-8"><expected>' . $output . '</expected>');
      $xpath = new DOMXPath($dom);
      $nodeList = $xpath->query('//expected' . $xpath_query);
      if ($nodeList->length > 0) {
        $output = $this->getInnerHtml($nodeList->item(0));
      }
      else {
        $output = '';
      }
      libxml_clear_errors();
    }

    return $output;
  }

  /**
   * @param string $xpath_query
   * @return string
   */
  public function getSection($xpath_query, $detect_xsl = FALSE) {
    libxml_use_internal_errors(TRUE);
    $actual = new DOMDocument;
    $actual->loadXML($this->getXML());
    $xpath = new DOMXPath($actual);
    $elements = $xpath->query($xpath_query);

    if (!empty($elements) && $elements->length > 0) {
      $new = new DOMDocument;
      $item = $elements->item(0);
      if ($detect_xsl || empty($this->xsl)) {
        $xsl = NULL;
        switch ($item->nodeName) {
          case 'abstract':
            $xsl = 'abstract';
            break;
          case 'boxed-text':
            $xsl = 'boxedText';
            break;
          case 'fig':
            $xsl = 'fig';
            break;
          case 'fig-group':
            $xsl = 'fig-group';
            break;
          case 'media':
            $xsl = 'media';
            break;
          case 'sub-article':
            $xsl = 'sub-article';
            break;
          case 'supplementary-material':
            $xsl = 'supplementary-material';
            break;
          case 'table-wrap':
            $xsl = 'tableWrap';
            break;
          case 'ack':
            $xsl = 'ack';
            break;
          case 'ref-list':
            $xsl = 'reference';
            break;
        }
        if ($xsl) {
          $this->setXSL($xsl);
        }
      }
      $new->appendChild($new->importNode($item, TRUE));

      $xsl = new DOMDocument;
      $xsl->loadXML($this->getXSL());
      $xsl->documentURI = $this->getFile();

      // Configure the transformer.
      $proc = new XSLTProcessor;
      // Attach the xsl rules.
      $proc->importStylesheet($xsl);

      $output = $proc->transformToXML($new);
      $actual->loadHTML('<meta http-equiv="content-type" content="text/html; charset=utf-8">' . $output);
      libxml_clear_errors();
      return $this->getInnerHtml($actual->getElementsByTagName('body')->item(0));
    }
  }

  /**
   * @param string $doi
   * @param string $fragment_type
   * @return string
   */
  public function getDoi($doi) {
    $xpath_string = "//object-id[@pub-id-type='doi' and text()='%s'][not(parent::fig[not(@specific-use) and ancestor::fig-group])]/parent::* | //object-id[@pub-id-type='doi' and text()='%s'][parent::fig[not(@specific-use) and ancestor::fig-group]]/ancestor::fig-group | //article-id[@pub-id-type='doi' and text()='%s']/ancestor::sub-article";
    $xpath_query = sprintf($xpath_string, $doi, $doi, $doi);
    return $this->getSection($xpath_query, TRUE);
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
