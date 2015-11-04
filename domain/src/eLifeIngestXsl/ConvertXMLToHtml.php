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
    if (file_exists($this->getFile())) {
      $this->xsl = XSLString::fromString(file_get_contents($this->getFile()))->getValue();
    }
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
  public function getTitle() {
    $this->setXSL('formatOnly');
    return $this->getSection("//title-group/article-title");
  }

  /**
   * @return string
   */
  public function getImpactStatement() {
    $this->setXSL('formatOnly');
    return $this->getSection("//custom-meta-group//meta-name[contains(text(), 'Author impact statement')]/following-sibling::meta-value");
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
  public function getAcknowledgements() {
    $this->setXSL('ack');
    return $this->getSection("//ack");
  }

  /**
   * @return string
   */
  public function getDecisionLetter() {
    $this->setXSL('sub-article');
    return $this->getSection("//sub-article[@article-type='article-commentary']");
  }

  /**
   * @return string
   */
  public function getAuthorResponse() {
    $this->setXSL('sub-article');
    return $this->getSection("//sub-article[@article-type='reply']");
  }

  /**
   * @return string
   */
  public function getReferences() {
    $this->setXSL('reference');
    return $this->getSection("//ref-list");
  }

  /**
   * @return string
   */
  public function getDatasets() {
    // @todo - elife - nlisgo - need dataset.xsl
    $this->setXSL('dataset');
    return $this->getSection("//sec[@sec-type='supplementary-material']/sec[@sec-type='datasets']");
  }

  /**
   * @return string
   */
  public function getAuthorInfoGroupAuthors() {
    // @todo - elife - nlisgo - need authorInfoGroupAuthor.xsl
    $this->setXSL('authorInfoGroupAuthor');
    return $this->getSection('//article-meta');
  }

  /**
   * @return string
   */
  public function getAuthorInfoContributions() {
    // @todo - elife - nlisgo - need authorInfoContribution.xsl
    $this->setXSL('authorInfoContribution');
    return $this->getSection("//sec[@sec-type='additional-information']/fn-group[@content-type='author-contribution']");
  }

  /**
   * @return string
   */
  public function getAuthorInfoEqualContrib() {
    // @todo - elife - nlisgo - need authorInfoEqualContrib.xsl
    $this->setXSL('authorInfoEqualContrib');
    return $this->getSection("//author-notes");
  }

  /**
   * @return string
   */
  public function getAuthorInfoOtherFootnotes() {
    // @todo - elife - nlisgo - need authorInfoOtherFootnote.xsl
    $this->setXSL('authorInfoOtherFootnote');
    return $this->getSection("//author-notes");
  }

  /**
   * @return string
   */
  public function getAuthorInfoCorrespondence() {
    // @todo - elife - nlisgo - need authorInfoCorrespondence.xsl
    $this->setXSL('authorInfoCorrespondence');
    return $this->getSection("//author-notes");
  }

  /**
   * @return string
   */
  public function getAuthorInfoAdditionalAddress() {
    // @todo - elife - nlisgo - need authorInfoAdditionalAddress.xsl
    $this->setXSL('authorInfoAdditionalAddress');
    return $this->getSection("//author-notes");
  }

  /**
   * @return string
   */
  public function getAuthorInfoCompetingInterest() {
    // @todo - elife - nlisgo - need authorInfoCompetingInterest.xsl
    $this->setXSL('authorInfoCompetingInterest');
    return $this->getSection("//sec[@sec-type='additional-information']/fn-group[@content-type='author-contribution']");
  }

  /**
   * @return string
   */
  public function getAuthorInfoFunding() {
    // @todo - elife - nlisgo - need authorInfoFunding.xsl
    $this->setXSL('authorInfoFunding');
    return $this->getSection("//funding-group");
  }

  /**
   * @return string
   */
  public function getArticleInfoIdentification() {
    // @todo - elife - nlisgo - need articleInfoIdentification.xsl
    $this->setXSL('articleInfoIdentification');
    return $this->getSection("//article-meta");
  }

  /**
   * @return string
   */
  public function getArticleInfoHistory() {
    // @todo - elife - nlisgo - need articleInfoHistory.xsl
    $this->setXSL('articleInfoHistory');
    return $this->getSection("//article-meta");
  }

  /**
   * @return string
   */
  public function getArticleInfoEthics() {
    // @todo - elife - nlisgo - need articleInfoEthics.xsl
    $this->setXSL('articleInfoEthics');
    return $this->getSection("//sec[@sec-type='additional-information']/fn-group[@content-type='ethics-information']");
  }

  /**
   * @return string
   */
  public function getArticleInfoReviewingEditor() {
    // @todo - elife - nlisgo - need articleInfoReviewingEditor.xsl
    $this->setXSL('articleInfoReviewingEditor');
    return $this->getSection("//sub-article//contrib-group/contrib[@contrib-type='editor']");
  }

  /**
   * @return string
   */
  public function getArticleInfoLicense() {
    // @todo - elife - nlisgo - need articleInfoLicense.xsl
    $this->setXSL('articleInfoLicense');
    return $this->getSection("//article-meta/permissions");
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
      if (!$this->getXSL()) {
        return '';
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
      return $this->tidyHtml($this->getInnerHtml($actual->getElementsByTagName('body')->item(0)));
    }
  }

  /**
   * @param string $html
   * @return string mixed
   */
  public static function tidyHtml($html) {
    // Fix self-closing tags issue.
    $self_closing = [
      'area',
      'base',
      'br',
      'col',
      'command',
      'embed',
      'hr',
      'img',
      'input',
      'keygen',
      'link',
      'meta',
      'param',
      'source',
      'track',
      'wbr',
    ];

    $from = [
      '/<(?!' . implode('|', $self_closing) . ')([a-z]+)\/>/',
      '/<(?!' . implode('|', $self_closing) . ')([a-z]+)( [^\/>]+)\/>/',
    ];
    $to = [
      '<$1></$1>',
      '<$1$2></$1>',
    ];
    return preg_replace($from, $to, $html);
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
   * @param string $doi
   * @return string
   */
  public function getDoi($doi) {
    $xpath_string = "//object-id[@pub-id-type='doi' and text()='%s'][not(parent::fig[not(@specific-use) and ancestor::fig-group])]/parent::* | //object-id[@pub-id-type='doi' and text()='%s'][parent::fig[not(@specific-use) and ancestor::fig-group]]/ancestor::fig-group | //article-id[@pub-id-type='doi' and text()='%s']/ancestor::sub-article";
    $xpath_query = sprintf($xpath_string, $doi, $doi, $doi);
    return $this->getSection($xpath_query, TRUE);
  }

  /**
   * @param string $id
   * @param string $within
   * @return string
   */
  public function getId($id, $within = "//*[@id='main-text']") {
    return $this->getSection($within . "//*[@id='" . $id . "']");
  }

  /**
   * @param string $aff_id
   * @return string
   */
  public function getAffiliation($aff_id) {
    // @todo - elife - nlisgo - need affiliation.xsl
    $this->setXSL('affiliation');
    return $this->getSection("//aff[@id='" . $aff_id . "']");
  }

  /**
   * @param string $bib_id
   * @return string
   */
  public function getReference($bib_id) {
    // @todo - elife - nlisgo - need referenceSingle.xsl
    $this->setXSL('referenceSingle');
    return $this->getSection("//ref-list/ref[@id='" . $bib_id . "']");
  }

  /**
   * @param string $app_id
   * @return string
   */
  public function getAppendix($app_id) {
    // @todo - elife - nlisgo - need appendix.xsl
    $this->setXSL('appendix');
    return $this->getSection("//app-group/app[@id='" . $app_id . "']");
  }

  /**
   * @param string $equ_id
   * @return string
   */
  public function getEquation($equ_id) {
    // @todo - elife - nlisgo - need equation.xsl
    $this->setXSL('equation');
    return $this->getSection("//display-formula[@id='" . $equ_id . "']");
  }

  /**
   * @param string $dataset_id
   * @return string
   */
  public function getDataset($dataset_id) {
    // @todo - elife - nlisgo - need dataset.xsl
    $this->setXSL('datasetSingle');
    return $this->getSection("//related-object[@id='" . $dataset_id . "']");
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
