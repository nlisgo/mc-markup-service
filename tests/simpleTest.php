<?php


use eLifeIngestXsl\ConvertXML\XMLString;
use eLifeIngestXsl\ConvertXMLToBibtex;
use eLifeIngestXsl\ConvertXMLToHtml;
use eLifeIngestXsl\ConvertXMLToRis;

class simpleTest extends PHPUnit_Framework_TestCase
{
    private $jats_folder = '';
    private $bib_folder = '';
    private $ris_folder = '';
    private $html_folder = '';

    public function setUp() {
        $realpath = realpath(dirname(__FILE__));
        $this->jats_folder = $realpath . '/fixtures/jats/';
        $this->bib_folder = $realpath . '/fixtures/bib/';
        $this->ris_folder = $realpath . '/fixtures/ris/';
        $this->html_folder = $realpath . '/fixtures/html/';
    }

    public function testJatsToBibtex() {
        $cits = glob($this->bib_folder . "*.bib");
        $compares = [];

        foreach ($cits as $cit) {
            $file = basename($cit, '.bib');
            $bibtex = new ConvertXMLToBibtex(XMLString::fromString(file_get_contents($this->jats_folder . $file . '.xml')));
            $compares[] = [
                file_get_contents($cit),
                $bibtex->getOutput(),
            ];
        }

        $this->runComparisons($compares);
    }

    public function testJatsToRis() {
        $cits = glob($this->ris_folder . "*.ris");
        $compares = [];

        foreach ($cits as $cit) {
            $file = basename($cit, '.ris');
            $ris = new ConvertXMLToRis(XMLString::fromString(file_get_contents($this->jats_folder . $file . '.xml')));
            $compares[] = [
                file_get_contents($cit),
                $ris->getOutput(),
            ];
        }

        $this->runComparisons($compares);
    }

    public function testJatsToHtmlAbstract() {
        $compares = $this->compareHtmlSection('-section-abstract', 'getAbstract');
        $this->runHtmlComparisons($compares);
    }

    public function testJatsToHtmlDigest() {
        $compares = $this->compareHtmlSection('-section-digest', 'getDigest');
        $this->runHtmlComparisons($compares);
    }

    public function testJatsToHtmlDecisionLetter() {
        $compares = $this->compareHtmlSection('-section-decision-letter', 'getDecisionLetter');
        $this->runHtmlComparisons($compares);
    }

    public function testJatsToHtmlAuthorResponse() {
        $compares = $this->compareHtmlSection('-section-author-response', 'getAuthorResponse');
        $this->runHtmlComparisons($compares);
    }

    public function testJatsToHtmlAcknowledgements() {
        $compares = $this->compareHtmlSection('-section-acknowledgements', 'getAcknowledgements');
        $this->runHtmlComparisons($compares);
    }

    public function testJatsToHtmlReferences() {
        $compares = $this->compareHtmlSection('-section-references', 'getReferences');
        $this->runHtmlComparisons($compares);
    }

    /**
     * Compare the expect and actual HTML results.
     *
     * @param array[] $compares
     */
    protected function runHtmlComparisons($compares) {
        $this->runComparisons($compares, 'assertEqualHtml');
    }

    /**
     * Compare the expect and actual results.
     *
     * @param array[] $compares
     * @param string $method
     */
    protected function runComparisons($compares, $method = 'assertEquals') {
        foreach ($compares as $compare) {
            call_user_func_array([$this, $method], $compare);
        }
    }

    /**
     * Prepare array of actual and expected results for DOI HTML.
     */
    protected function compareDoiHtmlSection($suffix) {
        $htmls = glob($this->html_folder . '*' . $suffix . '.html');
        $sections = [];

        foreach ($htmls as $html) {
            $found = preg_match('/^(?P<filename>[0-9]{5}\-[^\-]+)\-(?P<doi>[^\-]+)' . $suffix . '\.html$/', basename($html), $matches);
            if ($found) {
                $sections[] = [
                    'suffix' => '-' . $matches['doi'] . $suffix,
                    'doi' => '10.7554/' . $matches['doi'],
                ];
            }
        }
        $compares = [];

        foreach ($sections as $section) {
            $compares = array_merge($compares, $this->compareHtmlSection($section['suffix'], 'getDoi', $section['doi']));
        }

        return $compares;
    }

    /**
     * Prepare array of actual and expected results.
     */
    protected function compareHtmlSection($suffix, $method, $params = []) {
        if (is_string($params)) {
            $params = [$params];
        }
        $html_prefix = '<meta http-equiv="content-type" content="text/html; charset=utf-8">';
        $expected = 'expected';
        $htmls = glob($this->html_folder . "*" . $suffix . ".html");
        $compares = [];

        libxml_use_internal_errors(TRUE);
          foreach ($htmls as $html) {
            $file = str_replace($suffix, '', basename($html, '.html'));
            $actual_html = new ConvertXMLToHtml(XMLString::fromString(file_get_contents($this->jats_folder . $file . '.xml')));

            $expectedDom = new DOMDocument();
            $expected_html = file_get_contents($html);
            $expectedDom->loadHTML($html_prefix . '<' . $expected . '>' . $expected_html . '</' . $expected . '>');

            $compares[] = [
                $this->getInnerHtml($expectedDom->getElementsByTagName($expected)->item(0)),
                call_user_func_array([$actual_html, $method], $params),
            ];
        }
        libxml_clear_errors();

        return $compares;
    }

    /**
     * Compare two HTML fragments.
     */
    protected function assertEqualHtml($expected, $actual)
    {
        $from = ['/\>[^\S ]+/s', '/[^\S ]+\</s', '/(\s)+/s', '/> </s'];
        $to = ['>', '<', '\\1', '><'];
        $this->assertEquals(
            preg_replace($from, $to, $expected),
            preg_replace($from, $to, $actual)
        );
    }

    /**
     * Get inner HTML.
     */
    function getInnerHtml($node) { 
        $innerHTML= ''; 
        $children = $node->childNodes; 
        foreach ($children as $child) { 
            $innerHTML .= $child->ownerDocument->saveXML($child); 
        }

        return trim($innerHTML);
    } 
}
