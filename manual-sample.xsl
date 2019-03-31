<h1 id="synopsis">Synopsis</h1>

<p><code>pandoc</code> [<em>options</em>] [<em>input-file</em>]…</p>

<h1 id="description">Description</h1>

<p>Pandoc is a <a href='https://www.haskell.org' title=''>Haskell</a> library for converting from one markup format to
another, and a command-line tool that uses this library.</p>

<p>Pandoc can convert between numerous markup and word processing formats,
including, but not limited to, various flavors of <a href='http://daringfireball.net/projects/markdown/' title=''>Markdown</a>, <a href='http://www.w3.org/html/' title=''>HTML</a>,
<a href='http://latex-project.org' title=''>LaTeX</a> and <a href='https://en.wikipedia.org/wiki/Office_Open_XML' title=''>Word docx</a>. For the full lists of input and output formats,
see the <code>--from</code> and <code>--to</code> <a href='#general-options' title=''>options below</a>.
Pandoc can also produce <a href='https://www.adobe.com/pdf/' title=''>PDF</a> output: see <a href='#creating-a-pdf' title=''>creating a PDF</a>, below.</p>

<p>Pandoc’s enhanced version of Markdown includes syntax for <a href='#tables' title=''>tables</a>,
<a href='#definition-lists' title=''>definition lists</a>, <a href='#metadata-blocks' title=''>metadata blocks</a>, <a href='#footnotes' title=''>footnotes</a>, <a href='#citations' title=''>citations</a>, <a href='#math' title=''>math</a>,
and much more. See below under <a href='#pandocs-markdown' title=''>Pandoc’s Markdown</a>.</p>

<p>Pandoc has a modular design: it consists of a set of readers, which parse
text in a given format and produce a native representation of the document
(an <em>abstract syntax tree</em> or AST), and a set of writers, which convert
this native representation into a target format. Thus, adding an input
or output format requires only adding a reader or writer. Users can also
run custom <a href='http://pandoc.org/filters.html' title=''>pandoc filters</a> to modify the intermediate AST.</p>

<p>Because pandoc’s intermediate representation of a document is less
expressive than many of the formats it converts between, one should
not expect perfect conversions between every format and every other.
Pandoc attempts to preserve the structural elements of a document, but
not formatting details such as margin size. And some document elements,
such as complex tables, may not fit into pandoc’s simple document
model. While conversions from pandoc’s Markdown to all formats aspire
to be perfect, conversions from formats more expressive than pandoc’s
Markdown can be expected to be lossy.</p>

<h2 id="using-pandoc">Using pandoc</h2>

<p>If no <em>input-files</em> are specified, input is read from <em>stdin</em>.
Output goes to <em>stdout</em> by default. For output to a file,
use the <code>-o</code> option:</p>

<pre><code>pandoc -o output.html input.txt</code></pre>

<p>By default, pandoc produces a document fragment. To produce a standalone
document (e.g. a valid HTML file including <code>&lt;head&gt;</code> and <code>&lt;body&gt;</code>),
use the <code>-s</code> or <code>--standalone</code> flag:</p>

<pre><code>pandoc -s -o output.html input.txt</code></pre>

<p>For more information on how standalone documents are produced, see
<a href='#templates' title=''>Templates</a> below.</p>

<p>If multiple input files are given, <code>pandoc</code> will concatenate them all (with
blank lines between them) before parsing. (Use <code>--file-scope</code> to parse files
individually.)</p>

<h2 id="specifying-formats">Specifying formats</h2>

<p>The format of the input and output can be specified explicitly using
command-line options. The input format can be specified using the
<code>-f/--from</code> option, the output format using the <code>-t/--to</code> option.
Thus, to convert <code>hello.txt</code> from Markdown to LaTeX, you could type:</p>

<pre><code>pandoc -f markdown -t latex hello.txt</code></pre>

<p>To convert <code>hello.html</code> from HTML to Markdown:</p>

<pre><code>pandoc -f html -t markdown hello.html</code></pre>

<p>Supported input and output formats are listed below under <a href='#options' title=''>Options</a>
(see <code>-f</code> for input formats and <code>-t</code> for output formats). You
can also use <code>pandoc --list-input-formats</code> and
<code>pandoc --list-output-formats</code> to print lists of supported
formats.</p>

<p>If the input or output format is not specified explicitly, <code>pandoc</code>
will attempt to guess it from the extensions of the filenames.
Thus, for example,</p>

<pre><code>pandoc -o hello.tex hello.txt</code></pre>

<p>will convert <code>hello.txt</code> from Markdown to LaTeX. If no output file
is specified (so that output goes to <em>stdout</em>), or if the output file’s
extension is unknown, the output format will default to HTML.
If no input file is specified (so that input comes from <em>stdin</em>), or
if the input files’ extensions are unknown, the input format will
be assumed to be Markdown.</p>

<h2 id="character-encoding">Character encoding</h2>

<p>Pandoc uses the UTF-8 character encoding for both input and output.
If your local character encoding is not UTF-8, you
should pipe input and output through <a href='http://www.gnu.org/software/libiconv/' title=''><code>iconv</code></a>:</p>

<pre><code>iconv -t utf-8 input.txt | pandoc | iconv -f utf-8</code></pre>

<p>Note that in some output formats (such as HTML, LaTeX, ConTeXt,
RTF, OPML, DocBook, and Texinfo), information about
the character encoding is included in the document header, which
will only be included if you use the <code>-s/--standalone</code> option.</p>

<h2 id="creating-a-pdf">Creating a PDF</h2>

<p>To produce a PDF, specify an output file with a <code>.pdf</code> extension:</p>

<pre><code>pandoc test.txt -o test.pdf</code></pre>

<p>By default, pandoc will use LaTeX to create the PDF, which requires
that a LaTeX engine be installed (see <code>--pdf-engine</code> below).</p>

<p>Alternatively, pandoc can use <a href='http://www.contextgarden.net/' title=''>ConTeXt</a>, <code>pdfroff</code>, or any of the
following HTML/CSS-to-PDF-engines, to create a PDF: <a href='https://wkhtmltopdf.org' title=''><code>wkhtmltopdf</code></a>,
<a href='http://weasyprint.org' title=''><code>weasyprint</code></a> or <a href='https://www.princexml.com/' title=''><code>prince</code></a>.
To do this, specify an output file with a <code>.pdf</code> extension, as before,
but add the <code>--pdf-engine</code> option or <code>-t context</code>, <code>-t html</code>, or <code>-t ms</code>
to the command line (<code>-t html</code> defaults to <code>--pdf-engine=wkhtmltopdf</code>).</p>

<p>PDF output uses <a href='#variables-for-latex' title=''>variables for LaTeX</a> (with a LaTeX engine);
<a href='#variables-for-context' title=''>variables for ConTeXt</a> (with ConTeXt); or <a href='#variables-for-wkhtmltopdf' title=''>variables for <code>wkhtmltopdf</code></a>
(an HTML/CSS-to-PDF engine; <code>--css</code> also affects the output).</p>

<p>To debug the PDF creation, it can be useful to look at the intermediate
representation: instead of <code>-o test.pdf</code>, use for example <code>-s -o test.tex</code>
to output the generated LaTeX. You can then test it with <code>pdflatex test.tex</code>.</p>

<p>When using LaTeX, the following packages need to be available
(they are included with all recent versions of <a href='http://www.tug.org/texlive/' title=''>TeX Live</a>):
<a href='https://ctan.org/pkg/amsfonts' title=''><code>amsfonts</code></a>, <a href='https://ctan.org/pkg/amsmath' title=''><code>amsmath</code></a>, <a href='https://ctan.org/pkg/lm' title=''><code>lm</code></a>, <a href='https://ctan.org/pkg/unicode-math' title=''><code>unicode-math</code></a>,
<a href='https://ctan.org/pkg/ifxetex' title=''><code>ifxetex</code></a>, <a href='https://ctan.org/pkg/ifluatex' title=''><code>ifluatex</code></a>, <a href='https://ctan.org/pkg/listings' title=''><code>listings</code></a> (if the
<code>--listings</code> option is used), <a href='https://ctan.org/pkg/fancyvrb' title=''><code>fancyvrb</code></a>, <a href='https://ctan.org/pkg/longtable' title=''><code>longtable</code></a>,
<a href='https://ctan.org/pkg/booktabs' title=''><code>booktabs</code></a>, <a href='https://ctan.org/pkg/graphicx' title=''><code>graphicx</code></a> and <a href='https://ctan.org/pkg/grffile' title=''><code>grffile</code></a> (if the document
contains images), <a href='https://ctan.org/pkg/hyperref' title=''><code>hyperref</code></a>, <a href='https://ctan.org/pkg/xcolor' title=''><code>xcolor</code></a>,
<a href='https://ctan.org/pkg/ulem' title=''><code>ulem</code></a>, <a href='https://ctan.org/pkg/geometry' title=''><code>geometry</code></a> (with the <code>geometry</code> variable set),
<a href='https://ctan.org/pkg/setspace' title=''><code>setspace</code></a> (with <code>linestretch</code>), and
<a href='https://ctan.org/pkg/babel' title=''><code>babel</code></a> (with <code>lang</code>). The use of <code>xelatex</code> or <code>lualatex</code> as
the PDF engine requires <a href='https://ctan.org/pkg/fontspec' title=''><code>fontspec</code></a>. <code>xelatex</code> uses
<a href='https://ctan.org/pkg/polyglossia' title=''><code>polyglossia</code></a> (with <code>lang</code>), <a href='https://ctan.org/pkg/xecjk' title=''><code>xecjk</code></a>, and <a href='https://ctan.org/pkg/bidi' title=''><code>bidi</code></a> (with the
<code>dir</code> variable set). If the <code>mathspec</code> variable is set,
<code>xelatex</code> will use <a href='https://ctan.org/pkg/mathspec' title=''><code>mathspec</code></a> instead of <a href='https://ctan.org/pkg/unicode-math' title=''><code>unicode-math</code></a>.
The <a href='https://ctan.org/pkg/upquote' title=''><code>upquote</code></a> and <a href='https://ctan.org/pkg/microtype' title=''><code>microtype</code></a> packages are used if
available, and <a href='https://ctan.org/pkg/csquotes' title=''><code>csquotes</code></a> will be used for <a href='#typography' title=''>typography</a>
if <code>\usepackage{csquotes}</code> is present in the template or
included via <code>/H/--include-in-header</code>. The <a href='https://ctan.org/pkg/natbib' title=''><code>natbib</code></a>,
<a href='https://ctan.org/pkg/biblatex' title=''><code>biblatex</code></a>, <a href='https://ctan.org/pkg/bibtex' title=''><code>bibtex</code></a>, and <a href='https://ctan.org/pkg/biber' title=''><code>biber</code></a> packages can optionally
be used for <a href='#citation-rendering' title=''>citation rendering</a>. The following packages
will be used to improve output quality if present, but
pandoc does not require them to be present:
<a href='https://ctan.org/pkg/upquote' title=''><code>upquote</code></a> (for straight quotes in verbatim environments),
<a href='https://ctan.org/pkg/microtype' title=''><code>microtype</code></a> (for better spacing adjustments),
<a href='https://ctan.org/pkg/parskip' title=''><code>parskip</code></a> (for better inter-paragraph spaces),
<a href='https://ctan.org/pkg/xurl' title=''><code>xurl</code></a> (for better line breaks in URLs),
<a href='https://ctan.org/pkg/bookmark' title=''><code>bookmark</code></a> (for better PDF bookmarks),
and <a href='https://ctan.org/pkg/footnotehyper' title=''><code>footnotehyper</code></a> or <a href='https://ctan.org/pkg/footnote' title=''><code>footnote</code></a> (to allow footnotes in tables).</p>

<h2 id="reading-from-the-web">Reading from the Web</h2>

<p>Instead of an input file, an absolute URI may be given. In this case
pandoc will fetch the content using HTTP:</p>

<pre><code>pandoc -f html -t markdown http://www.fsf.org</code></pre>

<p>It is possible to supply a custom User-Agent string or other
header when requesting a document from a URL:</p>

<pre><code>pandoc -f html -t markdown --request-header User-Agent:&quot;Mozilla/5.0&quot; \
  http://www.fsf.org</code></pre>

<h1 id="options">Options</h1>

<h2 class="options" id="general-options">General options</h2>

<dl>
<dt><code>-f</code> <em>FORMAT</em>, <code>-r</code> <em>FORMAT</em>, <code>--from=</code><em>FORMAT</em>, <code>--read=</code><em>FORMAT</em></dt>
<dd><p>Specify input format. <em>FORMAT</em> can be:</p>

<div id="input-formats">
<ul>
<li><code>commonmark</code> (<a href='http://commonmark.org' title=''>CommonMark</a> Markdown)</li>
<li><code>creole</code> (<a href='http://www.wikicreole.org/wiki/Creole1.0' title=''>Creole 1.0</a>)</li>
<li><code>docbook</code> (<a href='http://docbook.org' title=''>DocBook</a>)</li>
<li><code>docx</code> (<a href='https://en.wikipedia.org/wiki/Office_Open_XML' title=''>Word docx</a>)</li>
<li><code>dokuwiki</code> (<a href='https://www.dokuwiki.org/dokuwiki' title=''>DokuWiki markup</a>)</li>
<li><code>epub</code> (<a href='http://idpf.org/epub' title=''>EPUB</a>)</li>
<li><code>fb2</code> (<a href='http://www.fictionbook.org/index.php/Eng:XML_Schema_Fictionbook_2.1' title=''>FictionBook2</a> e-book)</li>
<li><code>gfm</code> (<a href='https://help.github.com/articles/github-flavored-markdown/' title=''>GitHub-Flavored Markdown</a>),
or the deprecated and less accurate <code>markdown_github</code>;
use <a href='#markdown-variants' title=''><code>markdown_github</code></a> only
if you need extensions not supported in <a href='#markdown-variants' title=''><code>gfm</code></a>.</li>
<li><code>haddock</code> (<a href='https://www.haskell.org/haddock/doc/html/ch03s08.html' title=''>Haddock markup</a>)</li>
<li><code>html</code> (<a href='http://www.w3.org/html/' title=''>HTML</a>)</li>
<li><code>ipynb</code> (<a href='https://nbformat.readthedocs.io/en/latest/' title=''>Jupyter notebook</a>)</li>
<li><code>jats</code> (<a href='https://jats.nlm.nih.gov' title=''>JATS</a> XML)</li>
<li><code>json</code> (JSON version of native AST)</li>
<li><code>latex</code> (<a href='http://latex-project.org' title=''>LaTeX</a>)</li>
<li><code>markdown</code> (<a href='#pandocs-markdown' title=''>Pandoc’s Markdown</a>)</li>
<li><code>markdown_mmd</code> (<a href='http://fletcherpenney.net/multimarkdown/' title=''>MultiMarkdown</a>)</li>
<li><code>markdown_phpextra</code> (<a href='https://michelf.ca/projects/php-markdown/extra/' title=''>PHP Markdown Extra</a>)</li>
<li><code>markdown_strict</code> (original unextended <a href='http://daringfireball.net/projects/markdown/' title=''>Markdown</a>)</li>
<li><code>mediawiki</code> (<a href='https://www.mediawiki.org/wiki/Help:Formatting' title=''>MediaWiki markup</a>)</li>
<li><code>man</code> (<a href='http://man7.org/linux/man-pages/man7/groff_man.7.html' title=''>roff man</a>)</li>
<li><code>muse</code> (<a href='https://amusewiki.org/library/manual' title=''>Muse</a>)</li>
<li><code>native</code> (native Haskell)</li>
<li><code>odt</code> (<a href='http://en.wikipedia.org/wiki/OpenDocument' title=''>ODT</a>)</li>
<li><code>opml</code> (<a href='http://dev.opml.org/spec2.html' title=''>OPML</a>)</li>
<li><code>org</code> (<a href='http://orgmode.org' title=''>Emacs Org mode</a>)</li>
<li><code>rst</code> (<a href='http://docutils.sourceforge.net/docs/ref/rst/introduction.html' title=''>reStructuredText</a>)</li>
<li><code>t2t</code> (<a href='http://txt2tags.org' title=''>txt2tags</a>)</li>
<li><code>textile</code> (<a href='http://redcloth.org/textile' title=''>Textile</a>)</li>
<li><code>tikiwiki</code> (<a href='https://doc.tiki.org/Wiki-Syntax-Text#The_Markup_Language_Wiki-Syntax' title=''>TikiWiki markup</a>)</li>
<li><code>twiki</code> (<a href='http://twiki.org/cgi-bin/view/TWiki/TextFormattingRules' title=''>TWiki markup</a>)</li>
<li><code>vimwiki</code> (<a href='https://vimwiki.github.io' title=''>Vimwiki</a>)</li>
</ul></div>

<p>Extensions can be individually enabled or disabled by
appending <code>+EXTENSION</code> or <code>-EXTENSION</code> to the format name.
See <a href='#extensions' title=''>Extensions</a> below, for a list of extensions and
their names. See <code>--list-input-formats</code> and <code>--list-extensions</code>,
below.</p></dd>
<dt><code>-t</code> <em>FORMAT</em>, <code>-w</code> <em>FORMAT</em>, <code>--to=</code><em>FORMAT</em>, <code>--write=</code><em>FORMAT</em></dt>
<dd><p>Specify output format. <em>FORMAT</em> can be:</p>

<div id="output-formats">
<ul>
<li><code>asciidoc</code> (<a href='http://www.methods.co.nz/asciidoc/' title=''>AsciiDoc</a>) or <code>asciidoctor</code> (<a href='https://asciidoctor.org/' title=''>AsciiDoctor</a>)</li>
<li><code>beamer</code> (<a href='https://ctan.org/pkg/beamer' title=''>LaTeX beamer</a> slide show)</li>
<li><code>commonmark</code> (<a href='http://commonmark.org' title=''>CommonMark</a> Markdown)</li>
<li><code>context</code> (<a href='http://www.contextgarden.net/' title=''>ConTeXt</a>)</li>
<li><code>docbook</code> or <code>docbook4</code> (<a href='http://docbook.org' title=''>DocBook</a> 4)</li>
<li><code>docbook5</code> (DocBook 5)</li>
<li><code>docx</code> (<a href='https://en.wikipedia.org/wiki/Office_Open_XML' title=''>Word docx</a>)</li>
<li><code>dokuwiki</code> (<a href='https://www.dokuwiki.org/dokuwiki' title=''>DokuWiki markup</a>)</li>
<li><code>epub</code> or <code>epub3</code> (<a href='http://idpf.org/epub' title=''>EPUB</a> v3 book)</li>
<li><code>epub2</code> (EPUB v2)</li>
<li><code>fb2</code> (<a href='http://www.fictionbook.org/index.php/Eng:XML_Schema_Fictionbook_2.1' title=''>FictionBook2</a> e-book)</li>
<li><code>gfm</code> (<a href='https://help.github.com/articles/github-flavored-markdown/' title=''>GitHub-Flavored Markdown</a>),
or the deprecated and less accurate <code>markdown_github</code>;
use <a href='#markdown-variants' title=''><code>markdown_github</code></a> only
if you need extensions not supported in <a href='#markdown-variants' title=''><code>gfm</code></a>.</li>
<li><code>haddock</code> (<a href='https://www.haskell.org/haddock/doc/html/ch03s08.html' title=''>Haddock markup</a>)</li>
<li><code>html</code> or <code>html5</code> (<a href='http://www.w3.org/html/' title=''>HTML</a>, i.e. <a href='http://www.w3.org/TR/html5/' title=''>HTML5</a>/XHTML <a href='https://www.w3.org/TR/html-polyglot/' title=''>polyglot markup</a>)</li>
<li><code>html4</code> (<a href='http://www.w3.org/TR/xhtml1/' title=''>XHTML</a> 1.0 Transitional)</li>
<li><code>icml</code> (<a href='http://wwwimages.adobe.com/www.adobe.com/content/dam/acom/en/devnet/indesign/sdk/cs6/idml/idml-cookbook.pdf' title=''>InDesign ICML</a>)</li>
<li><code>ipynb</code> (<a href='https://nbformat.readthedocs.io/en/latest/' title=''>Jupyter notebook</a>)</li>
<li><code>jats</code> (<a href='https://jats.nlm.nih.gov' title=''>JATS</a> XML)</li>
<li><code>json</code> (JSON version of native AST)</li>
<li><code>latex</code> (<a href='http://latex-project.org' title=''>LaTeX</a>)</li>
<li><code>man</code> (<a href='http://man7.org/linux/man-pages/man7/groff_man.7.html' title=''>roff man</a>)</li>
<li><code>markdown</code> (<a href='#pandocs-markdown' title=''>Pandoc’s Markdown</a>)</li>
<li><code>markdown_mmd</code> (<a href='http://fletcherpenney.net/multimarkdown/' title=''>MultiMarkdown</a>)</li>
<li><code>markdown_phpextra</code> (<a href='https://michelf.ca/projects/php-markdown/extra/' title=''>PHP Markdown Extra</a>)</li>
<li><code>markdown_strict</code> (original unextended <a href='http://daringfireball.net/projects/markdown/' title=''>Markdown</a>)</li>
<li><code>mediawiki</code> (<a href='https://www.mediawiki.org/wiki/Help:Formatting' title=''>MediaWiki markup</a>)</li>
<li><code>ms</code> (<a href='http://man7.org/linux/man-pages/man7/groff_ms.7.html' title=''>roff ms</a>)</li>
<li><code>muse</code> (<a href='https://amusewiki.org/library/manual' title=''>Muse</a>),</li>
<li><code>native</code> (native Haskell),</li>
<li><code>odt</code> (<a href='http://en.wikipedia.org/wiki/OpenDocument' title=''>OpenOffice text document</a>)</li>
<li><code>opml</code> (<a href='http://dev.opml.org/spec2.html' title=''>OPML</a>)</li>
<li><code>opendocument</code> (<a href='http://opendocument.xml.org' title=''>OpenDocument</a>)</li>
<li><code>org</code> (<a href='http://orgmode.org' title=''>Emacs Org mode</a>)</li>
<li><code>plain</code> (plain text),</li>
<li><code>pptx</code> (<a href='https://en.wikipedia.org/wiki/Microsoft_PowerPoint' title=''>PowerPoint</a> slide show)</li>
<li><code>rst</code> (<a href='http://docutils.sourceforge.net/docs/ref/rst/introduction.html' title=''>reStructuredText</a>)</li>
<li><code>rtf</code> (<a href='http://en.wikipedia.org/wiki/Rich_Text_Format' title=''>Rich Text Format</a>)</li>
<li><code>texinfo</code> (<a href='http://www.gnu.org/software/texinfo/' title=''>GNU Texinfo</a>)</li>
<li><code>textile</code> (<a href='http://redcloth.org/textile' title=''>Textile</a>)</li>
<li><code>slideous</code> (<a href='http://goessner.net/articles/slideous/' title=''>Slideous</a> HTML and JavaScript slide show)</li>
<li><code>slidy</code> (<a href='http://www.w3.org/Talks/Tools/Slidy/' title=''>Slidy</a> HTML and JavaScript slide show)</li>
<li><code>dzslides</code> (<a href='http://paulrouget.com/dzslides/' title=''>DZSlides</a> HTML5 + JavaScript slide show),</li>
<li><code>revealjs</code> (<a href='http://lab.hakim.se/reveal-js/' title=''>reveal.js</a> HTML5 + JavaScript slide show)</li>
<li><code>s5</code> (<a href='http://meyerweb.com/eric/tools/s5/' title=''>S5</a> HTML and JavaScript slide show)</li>
<li><code>tei</code> (<a href='https://github.com/TEIC/TEI-Simple' title=''>TEI Simple</a>)</li>
<li><code>zimwiki</code> (<a href='http://zim-wiki.org/manual/Help/Wiki_Syntax.html' title=''>ZimWiki markup</a>)</li>
<li>the path of a custom lua writer, see <a href='#custom-writers' title=''>Custom writers</a> below</li>
</ul></div>

<p>Note that <code>odt</code>, <code>docx</code>, and <code>epub</code> output will not be directed
to <em>stdout</em> unless forced with <code>-o -</code>.</p>

<p>Extensions can be individually enabled or
disabled by appending <code>+EXTENSION</code> or <code>-EXTENSION</code> to the format
name. See <a href='#extensions' title=''>Extensions</a> below, for a list of extensions and their
names. See <code>--list-output-formats</code> and <code>--list-extensions</code>, below.</p></dd>
<dt><code>-o</code> <em>FILE</em>, <code>--output=</code><em>FILE</em></dt>
<dd><p>Write output to <em>FILE</em> instead of <em>stdout</em>. If <em>FILE</em> is
<code>-</code>, output will go to <em>stdout</em>, even if a non-textual format
(<code>docx</code>, <code>odt</code>, <code>epub2</code>, <code>epub3</code>) is specified.</p></dd>
<dt><code>--data-dir=</code><em>DIRECTORY</em></dt>
<dd><p>Specify the user data directory to search for pandoc data files.
If this option is not specified, the default user data directory
will be used. On *nix and macOS systems this will be the <code>pandoc</code>
subdirectory of the XDG data directory (by default,
<code>$HOME/.local/share</code>, overridable by setting the <code>XDG_DATA_HOME</code>
environment variable). If that directory does not exist,
<code>$HOME/.pandoc</code> will be used (for backwards compatibility).
In Windows the default user data directory is
<code>C:\Users\USERNAME\AppData\Roaming\pandoc</code>.
You can find the default user data directory on your system by
looking at the output of <code>pandoc --version</code>.
A <code>reference.odt</code>, <code>reference.docx</code>, <code>epub.css</code>, <code>templates</code>,
<code>slidy</code>, <code>slideous</code>, or <code>s5</code> directory
placed in this directory will override pandoc’s normal defaults.</p></dd>
<dt><code>--bash-completion</code></dt>
<dd><p>Generate a bash completion script. To enable bash completion
with pandoc, add this to your <code>.bashrc</code>:</p>

<pre><code>eval &quot;$(pandoc --bash-completion)&quot;</code></pre></dd>
<dt><code>--verbose</code></dt>
<dd><p>Give verbose debugging output. Currently this only has an effect
with PDF output.</p></dd>
<dt><code>--quiet</code></dt>
<dd><p>Suppress warning messages.</p></dd>
<dt><code>--fail-if-warnings</code></dt>
<dd><p>Exit with error status if there are any warnings.</p></dd>
<dt><code>--log=</code><em>FILE</em></dt>
<dd><p>Write log messages in machine-readable JSON format to
<em>FILE</em>. All messages above DEBUG level will be written,
regardless of verbosity settings (<code>--verbose</code>, <code>--quiet</code>).</p></dd>
<dt><code>--list-input-formats</code></dt>
<dd><p>List supported input formats, one per line.</p></dd>
<dt><code>--list-output-formats</code></dt>
<dd><p>List supported output formats, one per line.</p></dd>
<dt><code>--list-extensions</code>[<code>=</code><em>FORMAT</em>]</dt>
<dd><p>List supported extensions, one per line, preceded
by a <code>+</code> or <code>-</code> indicating whether it is enabled by default
in <em>FORMAT</em>. If <em>FORMAT</em> is not specified, defaults for
pandoc’s Markdown are given.</p></dd>
<dt><code>--list-highlight-languages</code></dt>
<dd><p>List supported languages for syntax highlighting, one per
line.</p></dd>
<dt><code>--list-highlight-styles</code></dt>
<dd><p>List supported styles for syntax highlighting, one per line.
See <code>--highlight-style</code>.</p></dd>
<dt><code>-v</code>, <code>--version</code></dt>
<dd><p>Print version.</p></dd>
<dt><code>-h</code>, <code>--help</code></dt>
<dd><p>Show usage message.</p></dd>
</dl>

<h2 class="options" id="reader-options">Reader options</h2>

<dl>
<dt><code>--base-header-level=</code><em>NUMBER</em></dt>
<dd><p>Specify the base level for headers (defaults to 1).</p></dd>
<dt><code>--strip-empty-paragraphs</code></dt>
<dd><p><em>Deprecated. Use the <code>+empty_paragraphs</code> extension instead.</em>
Ignore paragraphs with no content. This option is useful
for converting word processing documents where users have
used empty paragraphs to create inter-paragraph space.</p></dd>
<dt><code>--indented-code-classes=</code><em>CLASSES</em></dt>
<dd><p>Specify classes to use for indented code blocks–for example,
<code>perl,numberLines</code> or <code>haskell</code>. Multiple classes may be separated
by spaces or commas.</p></dd>
<dt><code>--default-image-extension=</code><em>EXTENSION</em></dt>
<dd><p>Specify a default extension to use when image paths/URLs have no
extension. This allows you to use the same source for formats that
require different kinds of images. Currently this option only affects
the Markdown and LaTeX readers.</p></dd>
<dt><code>--file-scope</code></dt>
<dd><p>Parse each file individually before combining for multifile
documents. This will allow footnotes in different files with the
same identifiers to work as expected. If this option is set,
footnotes and links will not work across files. Reading binary
files (docx, odt, epub) implies <code>--file-scope</code>.</p></dd>
<dt><code>-F</code> <em>PROGRAM</em>, <code>--filter=</code><em>PROGRAM</em></dt>
<dd><p>Specify an executable to be used as a filter transforming the
pandoc AST after the input is parsed and before the output is
written. The executable should read JSON from stdin and write
JSON to stdout. The JSON must be formatted like pandoc’s own
JSON input and output. The name of the output format will be
passed to the filter as the first argument. Hence,</p>

<pre><code>pandoc --filter ./caps.py -t latex</code></pre>

<p>is equivalent to</p>

<pre><code>pandoc -t json | ./caps.py latex | pandoc -f json -t latex</code></pre>

<p>The latter form may be useful for debugging filters.</p>

<p>Filters may be written in any language. <code>Text.Pandoc.JSON</code>
exports <code>toJSONFilter</code> to facilitate writing filters in Haskell.
Those who would prefer to write filters in python can use the
module <a href='https://github.com/jgm/pandocfilters' title=''><code>pandocfilters</code></a>, installable from PyPI. There are also
pandoc filter libraries in <a href='https://github.com/vinai/pandocfilters-php' title=''>PHP</a>, <a href='https://metacpan.org/pod/Pandoc::Filter' title=''>perl</a>, and
<a href='https://github.com/mvhenderson/pandoc-filter-node' title=''>JavaScript/node.js</a>.</p>

<p>In order of preference, pandoc will look for filters in</p>

<ol>
<li><p>a specified full or relative path (executable or
non-executable)</p></li>
<li><p><code>$DATADIR/filters</code> (executable or non-executable)
where <code>$DATADIR</code> is the user data directory (see
<code>--data-dir</code>, above).</p></li>
<li><p><code>$PATH</code> (executable only)</p></li>
</ol>

<p>Filters and lua-filters are applied in the order specified
on the command line.</p></dd>
<dt><code>--lua-filter=</code><em>SCRIPT</em></dt>
<dd><p>Transform the document in a similar fashion as JSON filters (see
<code>--filter</code>), but use pandoc’s build-in lua filtering system. The given
lua script is expected to return a list of lua filters which will be
applied in order. Each lua filter must contain element-transforming
functions indexed by the name of the AST element on which the filter
function should be applied.</p>

<p>The <code>pandoc</code> lua module provides helper functions for element
creation. It is always loaded into the script’s lua environment.</p>

<p>The following is an example lua script for macro-expansion:</p>

<pre><code>function expand_hello_world(inline)
  if inline.c == &#39;{{helloworld}}&#39; then
    return pandoc.Emph{ pandoc.Str &quot;Hello, World&quot; }
  else
    return inline
  end
end

return {{Str = expand_hello_world}}</code></pre>

<p>In order of preference, pandoc will look for lua filters in</p>

<ol>
<li><p>a specified full or relative path (executable or
non-executable)</p></li>
<li><p><code>$DATADIR/filters</code> (executable or non-executable)
where <code>$DATADIR</code> is the user data directory (see
<code>--data-dir</code>, above).</p></li>
</ol></dd>
<dt><code>-M</code> <em>KEY</em>[<code>=</code><em>VAL</em>], <code>--metadata=</code><em>KEY</em>[<code>:</code><em>VAL</em>]</dt>
<dd><p>Set the metadata field <em>KEY</em> to the value <em>VAL</em>. A value specified
on the command line overrides a value specified in the document
using <a href='#extension-yaml_metadata_block' title=''>YAML metadata blocks</a>.
Values will be parsed as YAML boolean or string values. If no value is
specified, the value will be treated as Boolean true. Like
<code>--variable</code>, <code>--metadata</code> causes template variables to be set.
But unlike <code>--variable</code>, <code>--metadata</code> affects the metadata of the
underlying document (which is accessible from filters and may be
printed in some output formats) and metadata values will be escaped
when inserted into the template.</p></dd>
<dt><code>--metadata-file=</code><em>FILE</em></dt>
<dd><p>Read metadata from the supplied YAML (or JSON) file.
This option can be used with every input format, but string
scalars in the YAML file will always be parsed as Markdown.
Generally, the input will be handled the same as in
<a href='#extension-yaml_metadata_block' title=''>YAML metadata blocks</a>.
Metadata values specified inside the document, or by using <code>-M</code>,
overwrite values specified with this option.</p></dd>
<dt><code>-p</code>, <code>--preserve-tabs</code></dt>
<dd><p>Preserve tabs instead of converting them to spaces (the default).
Note that this will only affect tabs in literal code spans and code
blocks; tabs in regular text will be treated as spaces.</p></dd>
<dt><code>--tab-stop=</code><em>NUMBER</em></dt>
<dd><p>Specify the number of spaces per tab (default is 4).</p></dd>
<dt><code>--track-changes=accept</code>|<code>reject</code>|<code>all</code></dt>
<dd><p>Specifies what to do with insertions, deletions, and comments
produced by the MS Word &ldquo;Track Changes&rdquo; feature. <code>accept</code> (the
default), inserts all insertions, and ignores all
deletions. <code>reject</code> inserts all deletions and ignores
insertions. Both <code>accept</code> and <code>reject</code> ignore comments. <code>all</code> puts
in insertions, deletions, and comments, wrapped in spans with
<code>insertion</code>, <code>deletion</code>, <code>comment-start</code>, and <code>comment-end</code>
classes, respectively. The author and time of change is
included. <code>all</code> is useful for scripting: only accepting changes
from a certain reviewer, say, or before a certain date. If a
paragraph is inserted or deleted, <code>track-changes=all</code> produces a
span with the class <code>paragraph-insertion</code>/<code>paragraph-deletion</code>
before the affected paragraph break. This option only affects the
docx reader.</p></dd>
<dt><code>--extract-media=</code><em>DIR</em></dt>
<dd><p>Extract images and other media contained in or linked from
the source document to the path <em>DIR</em>, creating it if
necessary, and adjust the images references in the document
so they point to the extracted files. If the source format is
a binary container (docx, epub, or odt), the media is
extracted from the container and the original
filenames are used. Otherwise the media is read from the
file system or downloaded, and new filenames are constructed
based on SHA1 hashes of the contents.</p></dd>
<dt><code>--abbreviations=</code><em>FILE</em></dt>
<dd><p>Specifies a custom abbreviations file, with abbreviations
one to a line. If this option is not specified, pandoc will
read the data file <code>abbreviations</code> from the user data
directory or fall back on a system default. To see the
system default, use
<code>pandoc --print-default-data-file=abbreviations</code>. The only
use pandoc makes of this list is in the Markdown reader.
Strings ending in a period that are found in this list will
be followed by a nonbreaking space, so that the period will
not produce sentence-ending space in formats like LaTeX.</p></dd>
</dl>

<h2 class="options" id="general-writer-options">General writer options</h2>

<dl>
<dt><code>-s</code>, <code>--standalone</code></dt>
<dd><p>Produce output with an appropriate header and footer (e.g. a
standalone HTML, LaTeX, TEI, or RTF file, not a fragment). This option
is set automatically for <code>pdf</code>, <code>epub</code>, <code>epub3</code>, <code>fb2</code>, <code>docx</code>, and <code>odt</code>
output. For <code>native</code> output, this option causes metadata to
be included; otherwise, metadata is suppressed.</p></dd>
<dt><code>--template=</code><em>FILE</em>|<em>URL</em></dt>
<dd><p>Use the specified file as a custom template for the generated document.
Implies <code>--standalone</code>. See <a href='#templates' title=''>Templates</a>, below, for a description
of template syntax. If no extension is specified, an extension
corresponding to the writer will be added, so that <code>--template=special</code>
looks for <code>special.html</code> for HTML output. If the template is not
found, pandoc will search for it in the <code>templates</code> subdirectory of
the user data directory (see <code>--data-dir</code>). If this option is not used,
a default template appropriate for the output format will be used (see
<code>-D/--print-default-template</code>).</p></dd>
<dt><code>-V</code> <em>KEY</em>[<code>=</code><em>VAL</em>], <code>--variable=</code><em>KEY</em>[<code>:</code><em>VAL</em>]</dt>
<dd><p>Set the template variable <em>KEY</em> to the value <em>VAL</em> when rendering the
document in standalone mode. This is generally only useful when the
<code>--template</code> option is used to specify a custom template, since
pandoc automatically sets the variables used in the default
templates. If no <em>VAL</em> is specified, the key will be given the
value <code>true</code>.</p></dd>
<dt><code>-D</code> <em>FORMAT</em>, <code>--print-default-template=</code><em>FORMAT</em></dt>
<dd><p>Print the system default template for an output <em>FORMAT</em>. (See <code>-t</code>
for a list of possible <em>FORMAT</em>s.) Templates in the user data
directory are ignored. This option may be used with
<code>-o</code>/<code>--output</code> to redirect output to a file, but
<code>-o</code>/<code>--output</code> must come before <code>--print-default-template</code>
on the command line.</p></dd>
<dt><code>--print-default-data-file=</code><em>FILE</em></dt>
<dd><p>Print a system default data file. Files in the user data directory
are ignored. This option may be used with <code>-o</code>/<code>--output</code> to
redirect output to a file, but <code>-o</code>/<code>--output</code> must come before
<code>--print-default-data-file</code> on the command line.</p></dd>
<dt><code>--eol=crlf</code>|<code>lf</code>|<code>native</code></dt>
<dd><p>Manually specify line endings: <code>crlf</code> (Windows), <code>lf</code>
(macOS/Linux/UNIX), or <code>native</code> (line endings appropriate
to the OS on which pandoc is being run). The default is
<code>native</code>.</p></dd>
<dt><code>--dpi</code>=<em>NUMBER</em></dt>
<dd><p>Specify the dpi (dots per inch) value for conversion from pixels
to inch/centimeters and vice versa. The default is 96dpi.
Technically, the correct term would be ppi (pixels per inch).</p></dd>
<dt><code>--wrap=auto</code>|<code>none</code>|<code>preserve</code></dt>
<dd><p>Determine how text is wrapped in the output (the source
code, not the rendered version). With <code>auto</code> (the default),
pandoc will attempt to wrap lines to the column width specified by
<code>--columns</code> (default 72). With <code>none</code>, pandoc will not wrap
lines at all. With <code>preserve</code>, pandoc will attempt to
preserve the wrapping from the source document (that is,
where there are nonsemantic newlines in the source, there
will be nonsemantic newlines in the output as well).
Automatic wrapping does not currently work in HTML output.
In <code>ipynb</code> output, this option affects wrapping of the
contents of markdown cells.</p></dd>
<dt><code>--columns=</code><em>NUMBER</em></dt>
<dd><p>Specify length of lines in characters. This affects text wrapping
in the generated source code (see <code>--wrap</code>). It also affects
calculation of column widths for plain text tables (see <a href='#tables' title=''>Tables</a> below).</p></dd>
<dt><code>--toc</code>, <code>--table-of-contents</code></dt>
<dd><p>Include an automatically generated table of contents (or, in
the case of <code>latex</code>, <code>context</code>, <code>docx</code>, <code>odt</code>,
<code>opendocument</code>, <code>rst</code>, or <code>ms</code>, an instruction to create
one) in the output document. This option has no effect
unless <code>-s/--standalone</code> is used, and it has no effect
on <code>man</code>, <code>docbook4</code>, <code>docbook5</code>, or <code>jats</code> output.</p></dd>
<dt><code>--toc-depth=</code><em>NUMBER</em></dt>
<dd><p>Specify the number of section levels to include in the table
of contents. The default is 3 (which means that level 1, 2, and 3
headers will be listed in the contents).</p></dd>
<dt><code>--strip-comments</code></dt>
<dd><p>Strip out HTML comments in the Markdown or Textile source,
rather than passing them on to Markdown, Textile or HTML
output as raw HTML. This does not apply to HTML comments
inside raw HTML blocks when the <code>markdown_in_html_blocks</code>
extension is not set.</p></dd>
<dt><code>--no-highlight</code></dt>
<dd><p>Disables syntax highlighting for code blocks and inlines, even when
a language attribute is given.</p></dd>
<dt><code>--highlight-style=</code><em>STYLE</em>|<em>FILE</em></dt>
<dd><p>Specifies the coloring style to be used in highlighted source code.
Options are <code>pygments</code> (the default), <code>kate</code>, <code>monochrome</code>,
<code>breezeDark</code>, <code>espresso</code>, <code>zenburn</code>, <code>haddock</code>, and <code>tango</code>.
For more information on syntax highlighting in pandoc, see
<a href='#syntax-highlighting' title=''>Syntax highlighting</a>, below. See also
<code>--list-highlight-styles</code>.</p>

<p>Instead of a <em>STYLE</em> name, a JSON file with extension
<code>.theme</code> may be supplied. This will be parsed as a KDE
syntax highlighting theme and (if valid) used as the
highlighting style.</p>

<p>To generate the JSON version of an existing style,
use <code>--print-highlight-style</code>.</p></dd>
<dt><code>--print-highlight-style=</code><em>STYLE</em>|<em>FILE</em></dt>
<dd><p>Prints a JSON version of a highlighting style, which can
be modified, saved with a <code>.theme</code> extension, and used
with <code>--highlight-style</code>. This option may be used with
<code>-o</code>/<code>--output</code> to redirect output to a file, but
<code>-o</code>/<code>--output</code> must come before <code>--print-highlight-style</code>
on the command line.</p></dd>
<dt><code>--syntax-definition=</code><em>FILE</em></dt>
<dd><p>Instructs pandoc to load a KDE XML syntax definition file,
which will be used for syntax highlighting of appropriately
marked code blocks. This can be used to add support for
new languages or to use altered syntax definitions for
existing languages.</p></dd>
<dt><code>-H</code> <em>FILE</em>, <code>--include-in-header=</code><em>FILE</em>|<em>URL</em></dt>
<dd><p>Include contents of <em>FILE</em>, verbatim, at the end of the header.
This can be used, for example, to include special
CSS or JavaScript in HTML documents. This option can be used
repeatedly to include multiple files in the header. They will be
included in the order specified. Implies <code>--standalone</code>.</p></dd>
<dt><code>-B</code> <em>FILE</em>, <code>--include-before-body=</code><em>FILE</em>|<em>URL</em></dt>
<dd><p>Include contents of <em>FILE</em>, verbatim, at the beginning of the
document body (e.g. after the <code>&lt;body&gt;</code> tag in HTML, or the
<code>\begin{document}</code> command in LaTeX). This can be used to include
navigation bars or banners in HTML documents. This option can be
used repeatedly to include multiple files. They will be included in
the order specified. Implies <code>--standalone</code>.</p></dd>
<dt><code>-A</code> <em>FILE</em>, <code>--include-after-body=</code><em>FILE</em>|<em>URL</em></dt>
<dd><p>Include contents of <em>FILE</em>, verbatim, at the end of the document
body (before the <code>&lt;/body&gt;</code> tag in HTML, or the
<code>\end{document}</code> command in LaTeX). This option can be used
repeatedly to include multiple files. They will be included in the
order specified. Implies <code>--standalone</code>.</p></dd>
<dt><code>--resource-path=</code><em>SEARCHPATH</em></dt>
<dd><p>List of paths to search for images and other resources.
The paths should be separated by <code>:</code> on Linux, UNIX, and
macOS systems, and by <code>;</code> on Windows. If <code>--resource-path</code>
is not specified, the default resource path is the working
directory. Note that, if <code>--resource-path</code> is specified,
the working directory must be explicitly listed or it
will not be searched. For example:
<code>--resource-path=.:test</code> will search the working directory
and the <code>test</code> subdirectory, in that order.</p>

<p><code>--resource-path</code> only has an effect if (a) the output
format embeds images (for example, <code>docx</code>, <code>pdf</code>, or <code>html</code>
with <code>--self-contained</code>) or (b) it is used together with
<code>--extract-media</code>.</p></dd>
<dt><code>--request-header=</code><em>NAME</em><code>:</code><em>VAL</em></dt>
<dd><p>Set the request header <em>NAME</em> to the value <em>VAL</em> when making
HTTP requests (for example, when a URL is given on the
command line, or when resources used in a document must be
downloaded). If you’re behind a proxy, you also need to set
the environment variable <code>http_proxy</code> to <code>http://...</code>.</p></dd>
</dl>

<h2 class="options" id="options-affecting-specific-writers">Options affecting specific writers</h2>

<dl>
<dt><code>--self-contained</code></dt>
<dd><p>Produce a standalone HTML file with no external dependencies, using
<code>data:</code> URIs to incorporate the contents of linked scripts, stylesheets,
images, and videos. Implies <code>--standalone</code>. The resulting file should be
&ldquo;self-contained,&rdquo; in the sense that it needs no external files and no net
access to be displayed properly by a browser. This option works only with
HTML output formats, including <code>html4</code>, <code>html5</code>, <code>html+lhs</code>, <code>html5+lhs</code>,
<code>s5</code>, <code>slidy</code>, <code>slideous</code>, <code>dzslides</code>, and <code>revealjs</code>. Scripts, images,
and stylesheets at absolute URLs will be downloaded; those at relative
URLs will be sought relative to the working directory (if the first source
file is local) or relative to the base URL (if the first source
file is remote). Elements with the attribute
<code>data-external=&quot;1&quot;</code> will be left alone; the documents they
link to will not be incorporated in the document.
Limitation: resources that are loaded dynamically through
JavaScript cannot be incorporated; as a result,
<code>--self-contained</code> does not work with <code>--mathjax</code>, and some
advanced features (e.g. zoom or speaker notes) may not work
in an offline &ldquo;self-contained&rdquo; <code>reveal.js</code> slide show.</p></dd>
<dt><code>--html-q-tags</code></dt>
<dd><p>Use <code>&lt;q&gt;</code> tags for quotes in HTML.</p></dd>
<dt><code>--ascii</code></dt>
<dd><p>Use only ASCII characters in output. Currently supported for XML
and HTML formats (which use entities instead of UTF-8 when this
option is selected), CommonMark, gfm, and Markdown (which use
entities), roff ms (which use hexadecimal escapes), and to a
limited degree LaTeX (which uses standard commands for accented
characters when possible). roff man output uses ASCII by default.</p></dd>
<dt><code>--reference-links</code></dt>
<dd><p>Use reference-style links, rather than inline links, in writing Markdown
or reStructuredText. By default inline links are used. The
placement of link references is affected by the
<code>--reference-location</code> option.</p></dd>
<dt><code>--reference-location = block</code>|<code>section</code>|<code>document</code></dt>
<dd><p>Specify whether footnotes (and references, if <code>reference-links</code> is
set) are placed at the end of the current (top-level) block, the
current section, or the document. The default is
<code>document</code>. Currently only affects the markdown writer.</p></dd>
<dt><code>--atx-headers</code></dt>
<dd><p>Use ATX-style headers in Markdown output. The default is
to use setext-style headers for levels 1-2, and then ATX headers.
(Note: for <code>gfm</code> output, ATX headers are always used.)
This option also affects markdown cells in <code>ipynb</code> output.</p></dd>
<dt><code>--top-level-division=[default|section|chapter|part]</code></dt>
<dd><p>Treat top-level headers as the given division type in LaTeX, ConTeXt,
DocBook, and TEI output. The hierarchy order is part, chapter, then section;
all headers are shifted such that the top-level header becomes the specified
type. The default behavior is to determine the best division type via
heuristics: unless other conditions apply, <code>section</code> is chosen. When the
LaTeX document class is set to <code>report</code>, <code>book</code>, or <code>memoir</code> (unless the
<code>article</code> option is specified), <code>chapter</code> is implied as the setting for this
option. If <code>beamer</code> is the output format, specifying either <code>chapter</code> or
<code>part</code> will cause top-level headers to become <code>\part{..}</code>, while
second-level headers remain as their default type.</p></dd>
<dt><code>-N</code>, <code>--number-sections</code></dt>
<dd><p>Number section headings in LaTeX, ConTeXt, HTML, or EPUB output.
By default, sections are not numbered. Sections with class
<code>unnumbered</code> will never be numbered, even if <code>--number-sections</code>
is specified.</p></dd>
<dt><code>--number-offset=</code><em>NUMBER</em>[<code>,</code><em>NUMBER</em><code>,</code><em>…</em>]</dt>
<dd><p>Offset for section headings in HTML output (ignored in other
output formats). The first number is added to the section number for
top-level headers, the second for second-level headers, and so on.
So, for example, if you want the first top-level header in your
document to be numbered &ldquo;6&rdquo;, specify <code>--number-offset=5</code>.
If your document starts with a level-2 header which you want to
be numbered &ldquo;1.5&rdquo;, specify <code>--number-offset=1,4</code>.
Offsets are 0 by default. Implies <code>--number-sections</code>.</p></dd>
<dt><code>--listings</code></dt>
<dd><p>Use the <a href='https://ctan.org/pkg/listings' title=''><code>listings</code></a> package for LaTeX code blocks. The package
does not support multi-byte encoding for source code. To handle UTF-8
you would need to use a custom template. This issue is fully
documented here: <a href='https://en.wikibooks.org/wiki/LaTeX/Source_Code_Listings#Encoding_issue' title=''>Encoding issue with the listings package</a>.</p></dd>
<dt><code>-i</code>, <code>--incremental</code></dt>
<dd><p>Make list items in slide shows display incrementally (one by one).
The default is for lists to be displayed all at once.</p></dd>
<dt><code>--slide-level=</code><em>NUMBER</em></dt>
<dd><p>Specifies that headers with the specified level create
slides (for <code>beamer</code>, <code>s5</code>, <code>slidy</code>, <code>slideous</code>, <code>dzslides</code>). Headers
above this level in the hierarchy are used to divide the
slide show into sections; headers below this level create
subheads within a slide. Note that content that is
not contained under slide-level headers will not appear in
the slide show. The default is to set the slide level based
on the contents of the document; see <a href='#structuring-the-slide-show' title=''>Structuring the slide
show</a>.</p></dd>
<dt><code>--section-divs</code></dt>
<dd><p>Wrap sections in <code>&lt;section&gt;</code> tags (or <code>&lt;div&gt;</code> tags for <code>html4</code>),
and attach identifiers to the enclosing <code>&lt;section&gt;</code> (or <code>&lt;div&gt;</code>)
rather than the header itself. See
<a href='#header-identifiers' title=''>Header identifiers</a>, below.</p></dd>
<dt><code>--email-obfuscation=none</code>|<code>javascript</code>|<code>references</code></dt>
<dd><p>Specify a method for obfuscating <code>mailto:</code> links in HTML documents.
<code>none</code> leaves <code>mailto:</code> links as they are. <code>javascript</code> obfuscates
them using JavaScript. <code>references</code> obfuscates them by printing their
letters as decimal or hexadecimal character references. The default
is <code>none</code>.</p></dd>
<dt><code>--id-prefix=</code><em>STRING</em></dt>
<dd><p>Specify a prefix to be added to all identifiers and internal links
in HTML and DocBook output, and to footnote numbers in Markdown
and Haddock output. This is useful for preventing duplicate
identifiers when generating fragments to be included in other pages.</p></dd>
<dt><code>-T</code> <em>STRING</em>, <code>--title-prefix=</code><em>STRING</em></dt>
<dd><p>Specify <em>STRING</em> as a prefix at the beginning of the title
that appears in the HTML header (but not in the title as it
appears at the beginning of the HTML body). Implies
<code>--standalone</code>.</p></dd>
<dt><code>-c</code> <em>URL</em>, <code>--css=</code><em>URL</em></dt>
<dd><p>Link to a CSS style sheet. This option can be used repeatedly to
include multiple files. They will be included in the order specified.</p>

<p>A stylesheet is required for generating EPUB. If none is
provided using this option (or the <code>css</code> or <code>stylesheet</code>
metadata fields), pandoc will look for a file <code>epub.css</code> in the
user data directory (see <code>--data-dir</code>). If it is not
found there, sensible defaults will be used.</p></dd>
<dt><code>--reference-doc=</code><em>FILE</em></dt>
<dd><p>Use the specified file as a style reference in producing a
docx or ODT file.</p>

<dl>
<dt>Docx</dt>
<dd><p>For best results, the reference docx should be a modified
version of a docx file produced using pandoc. The contents
of the reference docx are ignored, but its stylesheets and
document properties (including margins, page size, header,
and footer) are used in the new docx. If no reference docx
is specified on the command line, pandoc will look for a
file <code>reference.docx</code> in the user data directory (see
<code>--data-dir</code>). If this is not found either, sensible
defaults will be used.</p>

<p>To produce a custom <code>reference.docx</code>, first get a copy of
the default <code>reference.docx</code>: <code>pandoc -o custom-reference.docx --print-default-data-file reference.docx</code>.
Then open <code>custom-reference.docx</code> in Word, modify the
styles as you wish, and save the file. For best
results, do not make changes to this file other than
modifying the styles used by pandoc:</p>

<p>Paragraph styles:</p>

<ul>
<li>Normal</li>
<li>Body Text</li>
<li>First Paragraph</li>
<li>Compact</li>
<li>Title</li>
<li>Subtitle</li>
<li>Author</li>
<li>Date</li>
<li>Abstract</li>
<li>Bibliography</li>
<li>Heading 1</li>
<li>Heading 2</li>
<li>Heading 3</li>
<li>Heading 4</li>
<li>Heading 5</li>
<li>Heading 6</li>
<li>Heading 7</li>
<li>Heading 8</li>
<li>Heading 9</li>
<li>Block Text</li>
<li>Footnote Text</li>
<li>Definition Term</li>
<li>Definition</li>
<li>Caption</li>
<li>Table Caption</li>
<li>Image Caption</li>
<li>Figure</li>
<li>Captioned Figure</li>
<li>TOC Heading</li>
</ul>

<p>Character styles:</p>

<ul>
<li>Default Paragraph Font</li>
<li>Body Text Char</li>
<li>Verbatim Char</li>
<li>Footnote Reference</li>
<li>Hyperlink</li>
</ul>

<p>Table style:</p>

<ul>
<li>Table</li>
</ul></dd>
<dt>ODT</dt>
<dd><p>For best results, the reference ODT should be a modified
version of an ODT produced using pandoc. The contents of
the reference ODT are ignored, but its stylesheets are used
in the new ODT. If no reference ODT is specified on the
command line, pandoc will look for a file <code>reference.odt</code> in
the user data directory (see <code>--data-dir</code>). If this is not
found either, sensible defaults will be used.</p>

<p>To produce a custom <code>reference.odt</code>, first get a copy of
the default <code>reference.odt</code>: <code>pandoc -o custom-reference.odt --print-default-data-file reference.odt</code>.
Then open <code>custom-reference.odt</code> in LibreOffice, modify
the styles as you wish, and save the file.</p></dd>
<dt>PowerPoint</dt>
<dd><p>Any template included with a recent install of Microsoft
PowerPoint (either with <code>.pptx</code> or <code>.potx</code> extension) should
work, as will most templates derived from these.</p>

<p>The specific requirement is that the template should contain
the following four layouts as its first four layouts:</p>

<ol>
<li>Title Slide</li>
<li>Title and Content</li>
<li>Section Header</li>
<li>Two Content</li>
</ol>

<p>All templates included with a recent version of MS PowerPoint
will fit these criteria. (You can click on <code>Layout</code> under the
<code>Home</code> menu to check.)</p>

<p>You can also modify the default <code>reference.pptx</code>: first run
<code>pandoc -o custom-reference.pptx --print-default-data-file reference.pptx</code>, and then modify <code>custom-reference.pptx</code>
in MS PowerPoint (pandoc will use the first four layout
slides, as mentioned above).</p></dd>
</dl></dd>
<dt><code>--epub-cover-image=</code><em>FILE</em></dt>
<dd><p>Use the specified image as the EPUB cover. It is recommended
that the image be less than 1000px in width and height. Note that
in a Markdown source document you can also specify <code>cover-image</code>
in a YAML metadata block (see <a href='#epub-metadata' title=''>EPUB Metadata</a>, below).</p></dd>
<dt><code>--epub-metadata=</code><em>FILE</em></dt>
<dd><p>Look in the specified XML file for metadata for the EPUB.
The file should contain a series of <a href='http://dublincore.org/documents/dces/' title=''>Dublin Core elements</a>.
For example:</p>

<pre><code> &lt;dc:rights&gt;Creative Commons&lt;/dc:rights&gt;
 &lt;dc:language&gt;es-AR&lt;/dc:language&gt;</code></pre>

<p>By default, pandoc will include the following metadata elements:
<code>&lt;dc:title&gt;</code> (from the document title), <code>&lt;dc:creator&gt;</code> (from the
document authors), <code>&lt;dc:date&gt;</code> (from the document date, which should
be in <a href='http://www.w3.org/TR/NOTE-datetime' title=''>ISO 8601 format</a>), <code>&lt;dc:language&gt;</code> (from the <code>lang</code>
variable, or, if is not set, the locale), and <code>&lt;dc:identifier id=&quot;BookId&quot;&gt;</code> (a randomly generated UUID). Any of these may be
overridden by elements in the metadata file.</p>

<p>Note: if the source document is Markdown, a YAML metadata block
in the document can be used instead. See below under
<a href='#epub-metadata' title=''>EPUB Metadata</a>.</p></dd>
<dt><code>--epub-embed-font=</code><em>FILE</em></dt>
<dd><p>Embed the specified font in the EPUB. This option can be repeated
to embed multiple fonts. Wildcards can also be used: for example,
<code>DejaVuSans-*.ttf</code>. However, if you use wildcards on the command
line, be sure to escape them or put the whole filename in single quotes,
to prevent them from being interpreted by the shell. To use the
embedded fonts, you will need to add declarations like the following
to your CSS (see <code>--css</code>):</p>

<pre><code>@font-face {
font-family: DejaVuSans;
font-style: normal;
font-weight: normal;
src:url(&quot;DejaVuSans-Regular.ttf&quot;);
}
@font-face {
font-family: DejaVuSans;
font-style: normal;
font-weight: bold;
src:url(&quot;DejaVuSans-Bold.ttf&quot;);
}
@font-face {
font-family: DejaVuSans;
font-style: italic;
font-weight: normal;
src:url(&quot;DejaVuSans-Oblique.ttf&quot;);
}
@font-face {
font-family: DejaVuSans;
font-style: italic;
font-weight: bold;
src:url(&quot;DejaVuSans-BoldOblique.ttf&quot;);
}
body { font-family: &quot;DejaVuSans&quot;; }</code></pre></dd>
<dt><code>--epub-chapter-level=</code><em>NUMBER</em></dt>
<dd><p>Specify the header level at which to split the EPUB into separate
&ldquo;chapter&rdquo; files. The default is to split into chapters at level 1
headers. This option only affects the internal composition of the
EPUB, not the way chapters and sections are displayed to users. Some
readers may be slow if the chapter files are too large, so for large
documents with few level 1 headers, one might want to use a chapter
level of 2 or 3.</p></dd>
<dt><code>--epub-subdirectory=</code><em>DIRNAME</em></dt>
<dd><p>Specify the subdirectory in the OCF container that is to hold
the EPUB-specific contents. The default is <code>EPUB</code>. To put
the EPUB contents in the top level, use an empty string.</p></dd>
<dt><code>--ipynb-output=all|none|best</code></dt>
<dd><p>Determines how ipynb output cells are treated. <code>all</code> means
that all of the data formats included in the original are
preserved. <code>none</code> means that the contents of data cells
are omitted. <code>best</code> causes pandoc to try to pick the
richest data block in each output cell that is compatible
with the output format. The default is <code>best</code>.</p></dd>
<dt><code>--pdf-engine=</code><em>PROGRAM</em></dt>
<dd><p>Use the specified engine when producing PDF output.
Valid values are <code>pdflatex</code>, <code>lualatex</code>, <code>xelatex</code>, <code>latexmk</code>,
<code>tectonic</code>, <code>wkhtmltopdf</code>, <code>weasyprint</code>, <code>prince</code>, <code>context</code>,
and <code>pdfroff</code>. The default is <code>pdflatex</code>. If the engine is
not in your PATH, the full path of the engine may be specified here.</p></dd>
<dt><code>--pdf-engine-opt=</code><em>STRING</em></dt>
<dd><p>Use the given string as a command-line argument to the <code>pdf-engine</code>.
For example, to use a persistent directory <code>foo</code> for <code>latexmk</code>’s
auxiliary files, use <code>--pdf-engine-opt=-outdir=foo</code>.
Note that no check for duplicate options is done.</p></dd>
</dl>

<h2 class="options" id="citation-rendering">Citation rendering</h2>

<dl>
<dt><code>--bibliography=</code><em>FILE</em></dt>
<dd><p>Set the <code>bibliography</code> field in the document’s metadata to <em>FILE</em>,
overriding any value set in the metadata, and process citations
using <code>pandoc-citeproc</code>. (This is equivalent to
<code>--metadata bibliography=FILE --filter pandoc-citeproc</code>.)
If <code>--natbib</code> or <code>--biblatex</code> is also supplied, <code>pandoc-citeproc</code> is not
used, making this equivalent to <code>--metadata bibliography=FILE</code>.
If you supply this argument multiple times, each <em>FILE</em> will be added
to bibliography.</p></dd>
<dt><code>--csl=</code><em>FILE</em></dt>
<dd><p>Set the <code>csl</code> field in the document’s metadata to <em>FILE</em>,
overriding any value set in the metadata. (This is equivalent to
<code>--metadata csl=FILE</code>.)
This option is only relevant with <code>pandoc-citeproc</code>.</p></dd>
<dt><code>--citation-abbreviations=</code><em>FILE</em></dt>
<dd><p>Set the <code>citation-abbreviations</code> field in the document’s metadata to
<em>FILE</em>, overriding any value set in the metadata. (This is equivalent to
<code>--metadata citation-abbreviations=FILE</code>.)
This option is only relevant with <code>pandoc-citeproc</code>.</p></dd>
<dt><code>--natbib</code></dt>
<dd><p>Use <a href='https://ctan.org/pkg/natbib' title=''><code>natbib</code></a> for citations in LaTeX output. This option is not for use
with the <code>pandoc-citeproc</code> filter or with PDF output. It is intended for
use in producing a LaTeX file that can be processed with <a href='https://ctan.org/pkg/bibtex' title=''><code>bibtex</code></a>.</p></dd>
<dt><code>--biblatex</code></dt>
<dd><p>Use <a href='https://ctan.org/pkg/biblatex' title=''><code>biblatex</code></a> for citations in LaTeX output. This option is not for use
with the <code>pandoc-citeproc</code> filter or with PDF output. It is intended for
use in producing a LaTeX file that can be processed with <a href='https://ctan.org/pkg/bibtex' title=''><code>bibtex</code></a> or <a href='https://ctan.org/pkg/biber' title=''><code>biber</code></a>.</p></dd>
</dl>

<h2 class="options" id="math-rendering-in-html">Math rendering in HTML</h2>

<p>The default is to render TeX math as far as possible using Unicode characters.
Formulas are put inside a <code>span</code> with <code>class=&quot;math&quot;</code>, so that they may be styled
differently from the surrounding text if needed. However, this gives acceptable
results only for basic math, usually you will want to use <code>--mathjax</code> or another
of the following options.</p>

<dl>
<dt><code>--mathjax</code>[<code>=</code><em>URL</em>]</dt>
<dd><p>Use <a href='https://www.mathjax.org' title=''>MathJax</a> to display embedded TeX math in HTML output.
TeX math will be put between <code>\(...\)</code> (for inline math)
or <code>\[...\]</code> (for display math) and wrapped in <code>&lt;span&gt;</code> tags
with class <code>math</code>. Then the MathJax JavaScript will render it.
The <em>URL</em> should point to the <code>MathJax.js</code> load script.
If a <em>URL</em> is not provided, a link to the Cloudflare CDN will
be inserted.</p></dd>
<dt><code>--mathml</code></dt>
<dd><p>Convert TeX math to <a href='http://www.w3.org/Math/' title=''>MathML</a> (in <code>epub3</code>, <code>docbook4</code>, <code>docbook5</code>, <code>jats</code>,
<code>html4</code> and <code>html5</code>). This is the default in <code>odt</code> output. Note that
currently only Firefox and Safari (and select e-book readers) natively
support MathML.</p></dd>
<dt><code>--webtex</code>[<code>=</code><em>URL</em>]</dt>
<dd><p>Convert TeX formulas to <code>&lt;img&gt;</code> tags that link to an external script
that converts formulas to images. The formula will be URL-encoded
and concatenated with the URL provided. For SVG images you can for
example use <code>--webtex https://latex.codecogs.com/svg.latex?</code>.
If no URL is specified, the CodeCogs URL generating PNGs
will be used (<code>https://latex.codecogs.com/png.latex?</code>).
Note: the <code>--webtex</code> option will affect Markdown output
as well as HTML, which is useful if you’re targeting a
version of Markdown without native math support.</p></dd>
<dt><code>--katex</code>[<code>=</code><em>URL</em>]</dt>
<dd><p>Use <a href='https://github.com/Khan/KaTeX' title=''>KaTeX</a> to display embedded TeX math in HTML output.
The <em>URL</em> is the base URL for the KaTeX library. That directory
should contain a <code>katex.min.js</code> and a <code>katex.min.css</code> file.
If a <em>URL</em> is not provided, a link to the KaTeX CDN will be inserted.</p></dd>
<dt><code>--gladtex</code></dt>
<dd><p>Enclose TeX math in <code>&lt;eq&gt;</code> tags in HTML output. The resulting HTML
can then be processed by <a href='http://humenda.github.io/GladTeX/' title=''>GladTeX</a> to produce images of the typeset
formulas and an HTML file with links to these images.
So, the procedure is:</p>

<pre><code>pandoc -s --gladtex input.md -o myfile.htex
gladtex -d myfile-images myfile.htex
# produces myfile.html and images in myfile-images</code></pre></dd>
</dl>

<h2 class="options" id="options-for-wrapper-scripts">Options for wrapper scripts</h2>

<dl>
<dt><code>--dump-args</code></dt>
<dd><p>Print information about command-line arguments to <em>stdout</em>, then exit.
This option is intended primarily for use in wrapper scripts.
The first line of output contains the name of the output file specified
with the <code>-o</code> option, or <code>-</code> (for <em>stdout</em>) if no output file was
specified. The remaining lines contain the command-line arguments,
one per line, in the order they appear. These do not include regular
pandoc options and their arguments, but do include any options appearing
after a <code>--</code> separator at the end of the line.</p></dd>
<dt><code>--ignore-args</code></dt>
<dd><p>Ignore command-line arguments (for use in wrapper scripts).
Regular pandoc options are not ignored. Thus, for example,</p>

<pre><code>pandoc --ignore-args -o foo.html -s foo.txt -- -e latin1</code></pre>

<p>is equivalent to</p>

<pre><code>pandoc -o foo.html -s</code></pre></dd>
</dl>

<h1 id="templates">Templates</h1>

<p>When the <code>-s/--standalone</code> option is used, pandoc uses a template to
add header and footer material that is needed for a self-standing
document. To see the default template that is used, just type</p>

<pre><code>pandoc -D *FORMAT*</code></pre>

<p>where <em>FORMAT</em> is the name of the output format. A custom template
can be specified using the <code>--template</code> option. You can also override
the system default templates for a given output format <em>FORMAT</em>
by putting a file <code>templates/default.*FORMAT*</code> in the user data
directory (see <code>--data-dir</code>, above). <em>Exceptions:</em></p>

<ul>
<li>For <code>odt</code> output, customize the <code>default.opendocument</code>
template.</li>
<li>For <code>pdf</code> output, customize the <code>default.latex</code> template
(or the <code>default.context</code> template, if you use <code>-t context</code>,
or the <code>default.ms</code> template, if you use <code>-t ms</code>, or the
<code>default.html</code> template, if you use <code>-t html</code>).</li>
<li><code>docx</code> and <code>pptx</code> have no template (however, you can use
<code>--reference-doc</code> to customize the output).</li>
</ul>

<p>Templates contain <em>variables</em>, which allow for the inclusion of
arbitrary information at any point in the file. They may be set at the
command line using the <code>-V/--variable</code> option. If a variable is not set,
pandoc will look for the key in the document’s metadata – which can be set
using either <a href='#extension-yaml_metadata_block' title=''>YAML metadata blocks</a>
or with the <code>-M/--metadata</code> option.</p>

<h2 id="metadata-variables">Metadata variables</h2>

<dl>
<dt><code>title</code>, <code>author</code>, <code>date</code></dt>
<dd><p>allow identification of basic aspects of the document. Included
in PDF metadata through LaTeX and ConTeXt. These can be set
through a <a href='#extension-pandoc_title_block' title=''>pandoc title block</a>,
which allows for multiple authors, or through a YAML metadata block:</p>

<pre><code>---
author:
- Aristotle
- Peter Abelard
...</code></pre></dd>
<dt><code>subtitle</code></dt>
<dd>document subtitle, included in HTML, EPUB, LaTeX, ConTeXt, and docx
documents</dd>
<dt><code>abstract</code></dt>
<dd>document summary, included in LaTeX, ConTeXt, AsciiDoc, and docx
documents</dd>
<dt><code>keywords</code></dt>
<dd>list of keywords to be included in HTML, PDF, ODT, pptx, docx
and AsciiDoc metadata; repeat as for <code>author</code>, above</dd>
<dt><code>subject</code></dt>
<dd>document subject, included in ODT, PDF, docx and pptx metadata</dd>
<dt><code>description</code></dt>
<dd>document description, included in ODT, docx and pptx metadata. Some
applications show this as <code>Comments</code> metadata.</dd>
<dt><code>category</code></dt>
<dd>document category, included in docx and pptx metadata</dd>
</dl>

<p>Additionally,
any root-level string metadata, not included in ODT, docx
or pptx metadata is added as a <em>custom property</em>.
The following YAML metadata block for instance:</p>

<pre><code>---
title:  &#39;This is the title&#39;
subtitle: &quot;This is the subtitle&quot;
author:
- Author One
- Author Two
description: |
    This is a long
    description.

    It consists of two paragraphs
...</code></pre>

<p>will include <code>title</code>, <code>author</code> and <code>description</code> as standard document
properties and <code>subtitle</code> as a custom property when converting to docx,
ODT or pptx.</p>

<h2 id="language-variables">Language variables</h2>

<dl>
<dt><code>lang</code></dt>
<dd><p>identifies the main language of the document using IETF language
tags (following the <a href='https://tools.ietf.org/html/bcp47' title=''>BCP 47</a> standard), such as <code>en</code> or <code>en-GB</code>.
The <a href='https://r12a.github.io/app-subtags/' title=''>Language subtag lookup</a> tool can look up or verify these tags.
This affects most formats, and controls hyphenation in PDF output
when using LaTeX (through <a href='https://ctan.org/pkg/babel' title=''><code>babel</code></a> and <a href='https://ctan.org/pkg/polyglossia' title=''><code>polyglossia</code></a>) or ConTeXt.</p>

<p>Use native pandoc <a href='#divs-and-spans' title=''>Divs and Spans</a> with the <code>lang</code> attribute to
switch the language:</p>

<pre><code>---
lang: en-GB
...

Text in the main document language (British English).

::: {lang=fr-CA}
&gt; Cette citation est écrite en français canadien.
:::

More text in English. [&#39;Zitat auf Deutsch.&#39;]{lang=de}</code></pre></dd>
<dt><code>dir</code></dt>
<dd><p>the base script direction, either <code>rtl</code> (right-to-left)
or <code>ltr</code> (left-to-right).</p>

<p>For bidirectional documents, native pandoc <code>span</code>s and <code>div</code>s
with the <code>dir</code> attribute (value <code>rtl</code> or <code>ltr</code>) can be used to
override the base direction in some output formats.
This may not always be necessary if the final renderer
(e.g. the browser, when generating HTML) supports the
<a href='http://www.w3.org/International/articles/inline-bidi-markup/uba-basics' title=''>Unicode Bidirectional Algorithm</a>.</p>

<p>When using LaTeX for bidirectional documents, only the <code>xelatex</code> engine
is fully supported (use <code>--pdf-engine=xelatex</code>).</p></dd>
</dl>

<h2 id="variables-for-html-slides">Variables for HTML slides</h2>

<p>These affect HTML output when <a href='#producing-slide-shows-with-pandoc' title=''>producing slide shows with pandoc</a>.
All <a href='https://github.com/hakimel/reveal.js#configuration' title=''>reveal.js configuration options</a> are available as variables.</p>

<dl>
<dt><code>revealjs-url</code></dt>
<dd>base URL for reveal.js documents (defaults to <code>reveal.js</code>)</dd>
<dt><code>s5-url</code></dt>
<dd>base URL for S5 documents (defaults to <code>s5/default</code>)</dd>
<dt><code>slidy-url</code></dt>
<dd>base URL for Slidy documents (defaults to
<code>https://www.w3.org/Talks/Tools/Slidy2</code>)</dd>
<dt><code>slideous-url</code></dt>
<dd>base URL for Slideous documents (defaults to <code>slideous</code>)</dd>
</dl>

<h2 id="variables-for-beamer-slides">Variables for Beamer slides</h2>

<p>These variables change the appearance of PDF slides using <a href='https://ctan.org/pkg/beamer' title=''><code>beamer</code></a>.</p>

<dl>
<dt><code>aspectratio</code></dt>
<dd>slide aspect ratio (<code>43</code> for 4:3 [default], <code>169</code> for 16:9,
<code>1610</code> for 16:10, <code>149</code> for 14:9, <code>141</code> for 1.41:1, <code>54</code> for 5:4,
<code>32</code> for 3:2)</dd>
<dt><code>beamerarticle</code></dt>
<dd>produce an article from Beamer slides</dd>
<dt><code>beameroption</code></dt>
<dd>add extra beamer option with <code>\setbeameroption{}</code></dd>
<dt><code>institute</code></dt>
<dd>author affiliations: can be a list when there are multiple authors</dd>
<dt><code>logo</code></dt>
<dd>logo image for slides</dd>
<dt><code>navigation</code></dt>
<dd>controls navigation symbols (default is <code>empty</code> for no navigation
symbols; other valid values are <code>frame</code>, <code>vertical</code>, and <code>horizontal</code>)</dd>
<dt><code>section-titles</code></dt>
<dd>enables &ldquo;title pages&rdquo; for new sections (default is true)</dd>
<dt><code>theme</code>, <code>colortheme</code>, <code>fonttheme</code>, <code>innertheme</code>, <code>outertheme</code></dt>
<dd>beamer themes:</dd>
<dt><code>themeoptions</code></dt>
<dd>options for LaTeX beamer themes (a list).</dd>
<dt><code>titlegraphic</code></dt>
<dd>image for title slide</dd>
</dl>

<h2 id="variables-for-latex">Variables for LaTeX</h2>

<p>Pandoc uses these variables when <a href='#creating-a-pdf' title=''>creating a PDF</a> with a LaTeX engine.</p>

<h3 id="layout">Layout</h3>

<dl>
<dt><code>classoption</code></dt>
<dd>option for document class, e.g. <code>oneside</code>; repeat for multiple options</dd>
<dt><code>documentclass</code></dt>
<dd>document class: usually one of the standard classes, <a href='https://ctan.org/pkg/article' title=''><code>article</code></a>, <a href='https://ctan.org/pkg/report' title=''><code>report</code></a>,
and <a href='https://ctan.org/pkg/book' title=''><code>book</code></a>; the <a href='https://ctan.org/pkg/koma-script' title=''>KOMA-Script</a> equivalents, <code>scrartcl</code>, <code>scrreprt</code>,
and <code>scrbook</code>, which default to smaller margins; or <a href='https://ctan.org/pkg/memoir' title=''><code>memoir</code></a></dd>
<dt><code>geometry</code></dt>
<dd>option for <a href='https://ctan.org/pkg/geometry' title=''><code>geometry</code></a> package, e.g. <code>margin=1in</code>;
repeat for multiple options</dd>
<dt><code>indent</code></dt>
<dd>uses document class settings for indentation (the default LaTeX template
otherwise removes indentation and adds space between paragraphs)</dd>
<dt><code>linestretch</code></dt>
<dd>adjusts line spacing using the <a href='https://ctan.org/pkg/setspace' title=''><code>setspace</code></a>
package, e.g. <code>1.25</code>, <code>1.5</code></dd>
<dt><code>margin-left</code>, <code>margin-right</code>, <code>margin-top</code>, <code>margin-bottom</code></dt>
<dd>sets margins if <code>geometry</code> is not used (otherwise <code>geometry</code>
overrides these)</dd>
<dt><code>pagestyle</code></dt>
<dd>control <code>\pagestyle{}</code>: the default article class
supports <code>plain</code> (default), <code>empty</code> (no running heads or page numbers),
and <code>headings</code> (section titles in running heads)</dd>
<dt><code>papersize</code></dt>
<dd>paper size, e.g. <code>letter</code>, <code>a4</code></dd>
<dt><code>secnumdepth</code></dt>
<dd>numbering depth for sections (with <code>--number-sections</code> option
or <code>numbersections</code> variable)</dd>
<dt><code>subparagraph</code></dt>
<dd>disables default behavior of LaTeX template that redefines (sub)paragraphs
as sections, changing the appearance of nested headings in some classes</dd>
</dl>

<h3 id="fonts">Fonts</h3>

<dl>
<dt><code>fontenc</code></dt>
<dd>allows font encoding to be specified through <code>fontenc</code> package (with <code>pdflatex</code>);
default is <code>T1</code> (see <a href='https://ctan.org/pkg/encguide' title=''>LaTeX font encodings guide</a>)</dd>
<dt><code>fontfamily</code></dt>
<dd>font package for use with <code>pdflatex</code>:
<a href='http://www.tug.org/texlive/' title=''>TeX Live</a> includes many options, documented in the <a href='http://www.tug.dk/FontCatalogue/' title=''>LaTeX Font Catalogue</a>.
The default is <a href='https://ctan.org/pkg/lm' title=''>Latin Modern</a>.</dd>
<dt><code>fontfamilyoptions</code></dt>
<dd><p>options for package used as <code>fontfamily</code>; repeat for multiple options.
For example, to use the Libertine font with proportional lowercase
(old-style) figures through the <a href='https://ctan.org/pkg/libertinus' title=''><code>libertinus</code></a> package:</p>

<pre><code>---
fontfamily: libertinus
fontfamilyoptions:
- osf
- p
...</code></pre></dd>
<dt><code>fontsize</code></dt>
<dd>font size for body text. The standard classes allow 10pt, 11pt, and 12pt.
To use another size, set <code>documentclass</code> to one of the <a href='https://ctan.org/pkg/koma-script' title=''>KOMA-Script</a> classes,
such as <code>scrartcl</code> or <code>scrbook</code>.</dd>
<dt><code>mainfont</code>, <code>sansfont</code>, <code>monofont</code>, <code>mathfont</code>, <code>CJKmainfont</code></dt>
<dd>font families for use with <code>xelatex</code> or
<code>lualatex</code>: take the name of any system font, using the
<a href='https://ctan.org/pkg/fontspec' title=''><code>fontspec</code></a> package. <code>CJKmainfont</code> uses the <a href='https://ctan.org/pkg/xecjk' title=''><code>xecjk</code></a> package.</dd>
<dt><code>mainfontoptions</code>, <code>sansfontoptions</code>, <code>monofontoptions</code>, <code>mathfontoptions</code>, <code>CJKoptions</code></dt>
<dd><p>options to use with <code>mainfont</code>, <code>sansfont</code>, <code>monofont</code>, <code>mathfont</code>,
<code>CJKmainfont</code> in <code>xelatex</code> and <code>lualatex</code>. Allow for any choices
available through <a href='https://ctan.org/pkg/fontspec' title=''><code>fontspec</code></a>; repeat for multiple options. For example,
to use the <a href='http://www.gust.org.pl/projects/e-foundry/tex-gyre' title=''>TeX Gyre</a> version of Palatino with lowercase figures:</p>

<pre><code>---
mainfont: TeX Gyre Pagella
mainfontoptions:
- Numbers=Lowercase
- Numbers=Proportional
...</code></pre></dd>
<dt><code>microtypeoptions</code></dt>
<dd>options to pass to the microtype package</dd>
</dl>

<h3 id="links">Links</h3>

<dl>
<dt><code>colorlinks</code></dt>
<dd>add color to link text; automatically enabled if any of
<code>linkcolor</code>, <code>filecolor</code>, <code>citecolor</code>, <code>urlcolor</code>, or <code>toccolor</code> are set</dd>
<dt><code>linkcolor</code>, <code>filecolor</code>, <code>citecolor</code>, <code>urlcolor</code>, <code>toccolor</code></dt>
<dd>color for internal links, external links, citation links, linked
URLs, and links in table of contents, respectively: uses options
allowed by <a href='https://ctan.org/pkg/xcolor' title=''><code>xcolor</code></a>, including the <code>dvipsnames</code>, <code>svgnames</code>, and
<code>x11names</code> lists</dd>
<dt><code>links-as-notes</code></dt>
<dd>causes links to be printed as footnotes</dd>
</dl>

<h3 id="front-matter">Front matter</h3>

<dl>
<dt><code>lof</code>, <code>lot</code></dt>
<dd>include list of figures, list of tables</dd>
<dt><code>thanks</code></dt>
<dd>contents of acknowledgments footnote after document title</dd>
<dt><code>toc</code></dt>
<dd>include table of contents (can also be set using <code>--toc/--table-of-contents</code>)</dd>
<dt><code>toc-depth</code></dt>
<dd>level of section to include in table of contents</dd>
</dl>

<h3 id="biblatex-bibliographies">BibLaTeX Bibliographies</h3>

<p>These variables function when using BibLaTeX for <a href='#citation-rendering' title=''>citation rendering</a>.</p>

<dl>
<dt><code>biblatexoptions</code></dt>
<dd>list of options for biblatex</dd>
<dt><code>biblio-style</code></dt>
<dd>bibliography style, when used with <code>--natbib</code> and <code>--biblatex</code>.</dd>
<dt><code>biblio-title</code></dt>
<dd>bibliography title, when used with <code>--natbib</code> and <code>--biblatex</code>.</dd>
<dt><code>bibliography</code></dt>
<dd>bibliography to use for resolving references</dd>
<dt><code>natbiboptions</code></dt>
<dd>list of options for natbib</dd>
</dl>

<h2 id="variables-for-context">Variables for ConTeXt</h2>

<p>Pandoc uses these variables when <a href='#creating-a-pdf' title=''>creating a PDF</a> with ConTeXt.</p>

<dl>
<dt><code>fontsize</code></dt>
<dd>font size for body text (e.g. <code>10pt</code>, <code>12pt</code>)</dd>
<dt><code>headertext</code>, <code>footertext</code></dt>
<dd>text to be placed in running header or footer (see <a href='https://wiki.contextgarden.net/Headers_and_Footers' title=''>ConTeXt Headers and Footers</a>);
repeat up to four times for different placement</dd>
<dt><code>indenting</code></dt>
<dd>controls indentation of paragraphs, e.g. <code>yes,small,next</code> (see <a href='https://wiki.contextgarden.net/Indentation' title=''>ConTeXt Indentation</a>);
repeat for multiple options</dd>
<dt><code>interlinespace</code></dt>
<dd>adjusts line spacing, e.g. <code>4ex</code> (using <a href='https://wiki.contextgarden.net/Command/setupinterlinespace' title=''><code>setupinterlinespace</code></a>);
repeat for multiple options</dd>
<dt><code>layout</code></dt>
<dd>options for page margins and text arrangement (see <a href='https://wiki.contextgarden.net/Layout' title=''>ConTeXt Layout</a>);
repeat for multiple options</dd>
<dt><code>linkcolor</code>, <code>contrastcolor</code></dt>
<dd>color for links outside and inside a page, e.g. <code>red</code>, <code>blue</code> (see <a href='https://wiki.contextgarden.net/Color' title=''>ConTeXt Color</a>)</dd>
<dt><code>linkstyle</code></dt>
<dd>typeface style for links, e.g. <code>normal</code>, <code>bold</code>, <code>slanted</code>, <code>boldslanted</code>, <code>type</code>, <code>cap</code>, <code>small</code></dd>
<dt><code>lof</code>, <code>lot</code></dt>
<dd>include list of figures, list of tables</dd>
<dt><code>mainfont</code>, <code>sansfont</code>, <code>monofont</code>, <code>mathfont</code></dt>
<dd>font families: take the name of any system font (see <a href='https://wiki.contextgarden.net/Font_Switching' title=''>ConTeXt Font Switching</a>)</dd>
<dt><code>margin-left</code>, <code>margin-right</code>, <code>margin-top</code>, <code>margin-bottom</code></dt>
<dd>sets margins, if <code>layout</code> is not used (otherwise <code>layout</code>
overrides these)</dd>
<dt><code>pagenumbering</code></dt>
<dd>page number style and location (using <a href='https://wiki.contextgarden.net/Command/setuppagenumbering' title=''><code>setuppagenumbering</code></a>);
repeat for multiple options</dd>
<dt><code>papersize</code></dt>
<dd>paper size, e.g. <code>letter</code>, <code>A4</code>, <code>landscape</code> (see <a href='https://wiki.contextgarden.net/PaperSetup' title=''>ConTeXt Paper Setup</a>);
repeat for multiple options</dd>
<dt><code>pdfa</code></dt>
<dd>adds to the preamble the setup necessary to generate PDF/A-1b:2005.
To successfully generate PDF/A the required ICC color profiles have to
be available and the content and all included files (such as images)
have to be standard conforming. The ICC profiles can be obtained
from <a href='https://wiki.contextgarden.net/PDFX#ICC_profiles' title=''>ConTeXt ICC Profiles</a>. See also <a href='https://wiki.contextgarden.net/PDF/A' title=''>ConTeXt PDFA</a> for more
details.</dd>
<dt><code>toc</code></dt>
<dd>include table of contents (can also be set using <code>--toc/--table-of-contents</code>)</dd>
<dt><code>whitespace</code></dt>
<dd>spacing between paragraphs, e.g. <code>none</code>, <code>small</code> (using <a href='https://wiki.contextgarden.net/Command/setupwhitespace' title=''><code>setupwhitespace</code></a>)</dd>
</dl>

<h2 id="variables-for-wkhtmltopdf">Variables for <code>wkhtmltopdf</code></h2>

<p>Pandoc uses these variables when <a href='#creating-a-pdf' title=''>creating a PDF</a> with <a href='https://wkhtmltopdf.org' title=''><code>wkhtmltopdf</code></a>.
The <code>--css</code> option also affects the output.</p>

<dl>
<dt><code>footer-html</code>, <code>header-html</code></dt>
<dd>add information to the header and footer</dd>
<dt><code>margin-left</code>, <code>margin-right</code>, <code>margin-top</code>, <code>margin-bottom</code></dt>
<dd>set the page margins</dd>
<dt><code>papersize</code></dt>
<dd>sets the PDF paper size</dd>
</dl>

<h2 id="variables-for-man-pages">Variables for man pages</h2>

<dl>
<dt><code>adjusting</code></dt>
<dd>adjusts text to left (<code>l</code>), right (<code>r</code>), center (<code>c</code>),
or both (<code>b</code>) margins</dd>
<dt><code>footer</code></dt>
<dd>footer in man pages</dd>
<dt><code>header</code></dt>
<dd>header in man pages</dd>
<dt><code>hyphenate</code></dt>
<dd>if <code>true</code> (the default), hyphenation will be used</dd>
<dt><code>section</code></dt>
<dd>section number in man pages</dd>
</dl>

<h2 id="variables-for-ms">Variables for ms</h2>

<dl>
<dt><code>fontfamily</code></dt>
<dd>font family (e.g. <code>T</code> or <code>P</code>)</dd>
<dt><code>indent</code></dt>
<dd>paragraph indent (e.g. <code>2m</code>)</dd>
<dt><code>lineheight</code></dt>
<dd>line height (e.g. <code>12p</code>)</dd>
<dt><code>pointsize</code></dt>
<dd>point size (e.g. <code>10p</code>)</dd>
</dl>

<h2 id="structural-variables">Structural variables</h2>

<p>Pandoc sets these variables automatically in response to <a href='#options' title=''>options</a> or
document contents; users can also modify them. These vary depending
on the output format, and include the following:</p>

<dl>
<dt><code>body</code></dt>
<dd>body of document</dd>
<dt><code>date-meta</code></dt>
<dd>the <code>date</code> variable converted to ISO 8601 YYYY-MM-DD,
included in all HTML based formats (dzslides, epub,
html, html4, html5, revealjs, s5, slideous, slidy).
The recognized formats for <code>date</code> are: <code>mm/dd/yyyy</code>,
<code>mm/dd/yy</code>, <code>yyyy-mm-dd</code> (ISO 8601), <code>dd MM yyyy</code>
(e.g. either <code>02 Apr 2018</code> or <code>02 April 2018</code>),
<code>MM dd, yyyy</code> (e.g. <code>Apr. 02, 2018</code> or <code>April 02, 2018),</code>yyyy[mm[dd]]]<code>(e.g.</code>20180402, <code>201804</code> or <code>2018</code>).</dd>
<dt><code>header-includes</code></dt>
<dd>contents specified by <code>-H/--include-in-header</code> (may have multiple
values)</dd>
<dt><code>include-before</code></dt>
<dd>contents specified by <code>-B/--include-before-body</code> (may have
multiple values)</dd>
<dt><code>include-after</code></dt>
<dd>contents specified by <code>-A/--include-after-body</code> (may have
multiple values)</dd>
<dt><code>meta-json</code></dt>
<dd>JSON representation of all of the document’s metadata. Field
values are transformed to the selected output format.</dd>
<dt><code>numbersections</code></dt>
<dd>non-null value if <code>-N/--number-sections</code> was specified</dd>
<dt><code>sourcefile</code>, <code>outputfile</code></dt>
<dd><p>source and destination filenames, as given on the command line.
<code>sourcefile</code> can also be a list if input comes from multiple files, or empty
if input is from stdin. You can use the following snippet in your template
to distinguish them:</p>

<pre><code>$if(sourcefile)$
$for(sourcefile)$
$sourcefile$
$endfor$
$else$
(stdin)
$endif$</code></pre>

<p>Similarly, <code>outputfile</code> can be <code>-</code> if output goes to the terminal.</p></dd>
<dt><code>toc</code></dt>
<dd>non-null value if <code>--toc/--table-of-contents</code> was specified</dd>
<dt><code>toc-title</code></dt>
<dd>title of table of contents (works only with EPUB,
opendocument, odt, docx, pptx, beamer, LaTeX)</dd>
</dl>

<h2 id="using-variables-in-templates">Using variables in templates</h2>

<p>Variable names are sequences of alphanumerics, <code>-</code>, and <code>_</code>,
starting with a letter. A variable name surrounded by <code>$</code> signs
will be replaced by its value. For example, the string <code>$title$</code> in</p>

<pre><code>&lt;title&gt;$title$&lt;/title&gt;</code></pre>

<p>will be replaced by the document title.</p>

<p>To write a literal <code>$</code> in a template, use <code>$$</code>.</p>

<p>Templates may contain conditionals. The syntax is as follows:</p>

<pre><code>$if(variable)$
X
$else$
Y
$endif$</code></pre>

<p>This will include <code>X</code> in the template if <code>variable</code> has a truthy
value; otherwise it will include <code>Y</code>. Here a truthy value is any
of the following:</p>

<ul>
<li>a string that is not entirely white space,</li>
<li>a non-empty array where the first value is truthy,</li>
<li>any number (including zero),</li>
<li>any object,</li>
<li>the boolean <code>true</code> (to specify the boolean <code>true</code>
value using YAML metadata or the <code>--metadata</code> flag,
use <code>true</code>, <code>True</code>, or <code>TRUE</code>; with the <code>--variable</code>
flag, simply omit a value for the variable, e.g.
<code>--variable draft</code>).</li>
</ul>

<p><code>X</code> and <code>Y</code> are placeholders for any valid template text,
and may include interpolated variables or other conditionals.
The <code>$else$</code> section may be omitted.</p>

<p>When variables can have multiple values (for example, <code>author</code> in
a multi-author document), you can use the <code>$for$</code> keyword:</p>

<pre><code>$for(author)$
&lt;meta name=&quot;author&quot; content=&quot;$author$&quot; /&gt;
$endfor$</code></pre>

<p>You can optionally specify a separator to be used between
consecutive items:</p>

<pre><code>$for(author)$$author$$sep$, $endfor$</code></pre>

<p>Note that the separator needs to be specified immediately before the <code>$endfor</code>
keyword.</p>

<p>A dot can be used to select a field of a variable that takes
an object as its value. So, for example:</p>

<pre><code>$author.name$ ($author.affiliation$)</code></pre>

<p>The value of a variable will be indented to the same level as the variable.</p>

<p>If you use custom templates, you may need to revise them as pandoc
changes. We recommend tracking the changes in the default templates,
and modifying your custom templates accordingly. An easy way to do this
is to fork the <a href='https://github.com/jgm/pandoc-templates' title=''>pandoc-templates</a> repository and merge in changes after each
pandoc release.</p>

<p>Templates may contain comments: anything on a line after <code>$--</code>
will be treated as a comment and ignored.</p>

<h1 id="extensions">Extensions</h1>

<p>The behavior of some of the readers and writers can be adjusted by
enabling or disabling various extensions.</p>

<p>An extension can be enabled by adding <code>+EXTENSION</code>
to the format name and disabled by adding <code>-EXTENSION</code>. For example,
<code>--from markdown_strict+footnotes</code> is strict Markdown with footnotes
enabled, while <code>--from markdown-footnotes-pipe_tables</code> is pandoc’s
Markdown without footnotes or pipe tables.</p>

<p>The markdown reader and writer make by far the most use of extensions.
Extensions only used by them are therefore covered in the
section <a href='#pandocs-markdown' title=''>Pandoc’s Markdown</a> below (See <a href='#markdown-variants' title=''>Markdown variants</a> for
<code>commonmark</code> and <code>gfm</code>.) In the following, extensions that also work
for other formats are covered.</p>

<p>Note that markdown extensions added to the <code>ipynb</code> format
affect Markdown cells in Jupyter notebooks (as do command-line
options like <code>--atx-headers</code>).</p>

<h2 id="typography">Typography</h2>

<h4 id="extension-smart">Extension: <code>smart</code></h4>

<p>Interpret straight quotes as curly quotes, <code>---</code> as em-dashes,
<code>--</code> as en-dashes, and <code>...</code> as ellipses. Nonbreaking spaces are
inserted after certain abbreviations, such as &ldquo;Mr.&rdquo;</p>

<p>This extension can be enabled/disabled for the following formats:</p>

<dl>
<dt>input formats</dt>
<dd><code>markdown</code>, <code>commonmark</code>, <code>latex</code>, <code>mediawiki</code>, <code>org</code>, <code>rst</code>, <code>twiki</code></dd>
<dt>output formats</dt>
<dd><code>markdown</code>, <code>latex</code>, <code>context</code>, <code>rst</code></dd>
<dt>enabled by default in</dt>
<dd><code>markdown</code>, <code>latex</code>, <code>context</code> (both input and output)</dd>
</dl>

<p>Note: If you are <em>writing</em> Markdown, then the <code>smart</code> extension
has the reverse effect: what would have been curly quotes comes
out straight.</p>

<p>In LaTeX, <code>smart</code> means to use the standard TeX ligatures
for quotation marks (<code>``</code> and <code>&#39;&#39;</code> for double quotes,
<code>`</code> and <code>&#39;</code> for single quotes) and dashes (<code>--</code> for
en-dash and <code>---</code> for em-dash). If <code>smart</code> is disabled,
then in reading LaTeX pandoc will parse these characters
literally. In writing LaTeX, enabling <code>smart</code> tells pandoc
to use the ligatures when possible; if <code>smart</code> is disabled
pandoc will use unicode quotation mark and dash characters.</p>

<h2 id="headers-and-sections">Headers and sections</h2>

<h4 id="extension-auto_identifiers">Extension: <code>auto_identifiers</code></h4>

<p>A header without an explicitly specified identifier will be
automatically assigned a unique identifier based on the header text.</p>

<p>This extension can be enabled/disabled for the following formats:</p>

<dl>
<dt>input formats</dt>
<dd><code>markdown</code>, <code>latex</code>, <code>rst</code>, <code>mediawiki</code>, <code>textile</code></dd>
<dt>output formats</dt>
<dd><code>markdown</code>, <code>muse</code></dd>
<dt>enabled by default in</dt>
<dd><code>markdown</code>, <code>muse</code></dd>
</dl>

<p>The default algorithm used to derive the identifier from the
header text is:</p>

<ul>
<li>Remove all formatting, links, etc.</li>
<li>Remove all footnotes.</li>
<li>Remove all non-alphanumeric characters,
except underscores, hyphens, and periods.</li>
<li>Replace all spaces and newlines with hyphens.</li>
<li>Convert all alphabetic characters to lowercase.</li>
<li>Remove everything up to the first letter (identifiers may
not begin with a number or punctuation mark).</li>
<li>If nothing is left after this, use the identifier <code>section</code>.</li>
</ul>

<p>Thus, for example,</p>

<table>
<tr class="header">
<th align="left">Header</th>
<th align="left">Identifier</th>
</tr>
<tr class="odd">
<td align="left"><code>Header identifiers in HTML</code></td>
<td align="left"><code>header-identifiers-in-html</code></td>
</tr>
<tr class="even">
<td align="left"><code>Maître d&#39;hôtel</code></td>
<td align="left"><code>maître-dhôtel</code></td>
</tr>
<tr class="odd">
<td align="left"><code>*Dogs*?--in *my* house?</code></td>
<td align="left"><code>dogs--in-my-house</code></td>
</tr>
<tr class="even">
<td align="left"><code>[HTML], [S5], or [RTF]?</code></td>
<td align="left"><code>html-s5-or-rtf</code></td>
</tr>
<tr class="odd">
<td align="left"><code>3. Applications</code></td>
<td align="left"><code>applications</code></td>
</tr>
<tr class="even">
<td align="left"><code>33</code></td>
<td align="left"><code>section</code></td>
</tr>
</table>

<p>These rules should, in most cases, allow one to determine the identifier
from the header text. The exception is when several headers have the
same text; in this case, the first will get an identifier as described
above; the second will get the same identifier with <code>-1</code> appended; the
third with <code>-2</code>; and so on.</p>

<p>(However, a different algorithm is used if
<code>gfm_auto_identifiers</code> is enabled; see below.)</p>

<p>These identifiers are used to provide link targets in the table of
contents generated by the <code>--toc|--table-of-contents</code> option. They
also make it easy to provide links from one section of a document to
another. A link to this section, for example, might look like this:</p>

<pre><code>See the section on
[header identifiers](#header-identifiers-in-html-latex-and-context).</code></pre>

<p>Note, however, that this method of providing links to sections works
only in HTML, LaTeX, and ConTeXt formats.</p>

<p>If the <code>--section-divs</code> option is specified, then each section will
be wrapped in a <code>section</code> (or a <code>div</code>, if <code>html4</code> was specified),
and the identifier will be attached to the enclosing <code>&lt;section&gt;</code>
(or <code>&lt;div&gt;</code>) tag rather than the header itself. This allows entire
sections to be manipulated using JavaScript or treated differently in
CSS.</p>

<h4 id="extension-ascii_identifiers">Extension: <code>ascii_identifiers</code></h4>

<p>Causes the identifiers produced by <code>auto_identifiers</code> to be pure ASCII.
Accents are stripped off of accented Latin letters, and non-Latin
letters are omitted.</p>

<h4 id="extension-gfm_auto_identifiers">Extension: <code>gfm_auto_identifiers</code></h4>

<p>Changes the algorithm used by <code>auto_identifiers</code> to conform to
GitHub’s method. Spaces are converted to dashes (<code>-</code>),
uppercase characters to lowercase characters, and punctuation
characters other than <code>-</code> and <code>_</code> are removed.</p>

<h2 id="math-input">Math Input</h2>

<p>The extensions <a href='#extension-tex_math_dollars' title=''><code>tex_math_dollars</code></a>,
<a href='#extension-tex_math_single_backslash' title=''><code>tex_math_single_backslash</code></a>, and
<a href='#extension-tex_math_double_backslash' title=''><code>tex_math_double_backslash</code></a>
are described in the section about Pandoc’s Markdown.</p>

<p>However, they can also be used with HTML input. This is handy for
reading web pages formatted using MathJax, for example.</p>

<h2 id="raw-htmltex">Raw HTML/TeX</h2>

<p>The following extensions (especially how they affect Markdown
input/output) are also described in more detail in their respective
sections of <a href='#pandocs-markdown' title=''>Pandoc’s Markdown</a>.</p>

<h4 id="raw_html">Extension: <code>raw_html</code></h4>

<p>When converting from HTML, parse elements to raw HTML which are not
representable in pandoc’s AST.
By default, this is disabled for HTML input.</p>

<h4 id="raw_tex">Extension: <code>raw_tex</code></h4>

<p>Allows raw LaTeX, TeX, and ConTeXt to be included in a document.</p>

<p>This extension can be enabled/disabled for the following formats
(in addition to <code>markdown</code>):</p>

<dl>
<dt>input formats</dt>
<dd><code>latex</code>, <code>org</code>, <code>textile</code>, <code>html</code> (environments, <code>\ref</code>, and
<code>\eqref</code> only), <code>ipynb</code></dd>
<dt>output formats</dt>
<dd><code>textile</code>, <code>commonmark</code></dd>
</dl>

<p>Note: as applied to <code>ipynb</code>, <code>raw_html</code> and <code>raw_tex</code> affect not
only raw TeX in markdown cells, but data with mime type
<code>text/html</code> in output cells. Since the <code>ipynb</code> reader attempts
to preserve the richest possible outputs when several options
are given, you will get best results if you disable <code>raw_html</code>
and <code>raw_tex</code> when converting to formats like <code>docx</code> which don’t
allow raw <code>html</code> or <code>tex</code>.</p>

<h4 id="native_divs">Extension: <code>native_divs</code></h4>

<p>This extension is enabled by default for HTML input. This means that
<code>div</code>s are parsed to pandoc native elements. (Alternatively, you
can parse them to raw HTML using <code>-f html-native_divs+raw_html</code>.)</p>

<p>When converting HTML to Markdown, for example, you may want to drop all
<code>div</code>s and <code>span</code>s:</p>

<pre><code>pandoc -f html-native_divs-native_spans -t markdown</code></pre>

<h4 id="native_spans">Extension: <code>native_spans</code></h4>

<p>Analogous to <code>native_divs</code> above.</p>

<h2 id="literate-haskell-support">Literate Haskell support</h2>

<h4 id="extension-literate_haskell">Extension: <code>literate_haskell</code></h4>

<p>Treat the document as literate Haskell source.</p>

<p>This extension can be enabled/disabled for the following formats:</p>

<dl>
<dt>input formats</dt>
<dd><code>markdown</code>, <code>rst</code>, <code>latex</code></dd>
<dt>output formats</dt>
<dd><code>markdown</code>, <code>rst</code>, <code>latex</code>, <code>html</code></dd>
</dl>

<p>If you append <code>+lhs</code> (or <code>+literate_haskell</code>) to one of the formats
above, pandoc will treat the document as literate Haskell source.
This means that</p>

<ul>
<li><p>In Markdown input, &ldquo;bird track&rdquo; sections will be parsed as Haskell
code rather than block quotations. Text between <code>\begin{code}</code>
and <code>\end{code}</code> will also be treated as Haskell code. For
ATX-style headers the character &lsquo;=&rsquo; will be used instead of &lsquo;#&rsquo;.</p></li>
<li><p>In Markdown output, code blocks with classes <code>haskell</code> and <code>literate</code>
will be rendered using bird tracks, and block quotations will be
indented one space, so they will not be treated as Haskell code.
In addition, headers will be rendered setext-style (with underlines)
rather than ATX-style (with &lsquo;#&rsquo; characters). (This is because ghc
treats &lsquo;#&rsquo; characters in column 1 as introducing line numbers.)</p></li>
<li><p>In restructured text input, &ldquo;bird track&rdquo; sections will be parsed
as Haskell code.</p></li>
<li><p>In restructured text output, code blocks with class <code>haskell</code> will
be rendered using bird tracks.</p></li>
<li><p>In LaTeX input, text in <code>code</code> environments will be parsed as
Haskell code.</p></li>
<li><p>In LaTeX output, code blocks with class <code>haskell</code> will be rendered
inside <code>code</code> environments.</p></li>
<li><p>In HTML output, code blocks with class <code>haskell</code> will be rendered
with class <code>literatehaskell</code> and bird tracks.</p></li>
</ul>

<p>Examples:</p>

<pre><code>pandoc -f markdown+lhs -t html</code></pre>

<p>reads literate Haskell source formatted with Markdown conventions and writes
ordinary HTML (without bird tracks).</p>

<pre><code>pandoc -f markdown+lhs -t html+lhs</code></pre>

<p>writes HTML with the Haskell code in bird tracks, so it can be copied
and pasted as literate Haskell source.</p>

<p>Note that GHC expects the bird tracks in the first column, so indented
literate code blocks (e.g. inside an itemized environment) will not be
picked up by the Haskell compiler.</p>

<h2 id="other-extensions">Other extensions</h2>

<h4 id="extension-empty_paragraphs">Extension: <code>empty_paragraphs</code></h4>

<p>Allows empty paragraphs. By default empty paragraphs are
omitted.</p>

<p>This extension can be enabled/disabled for the following formats:</p>

<dl>
<dt>input formats</dt>
<dd><code>docx</code>, <code>html</code></dd>
<dt>output formats</dt>
<dd><code>docx</code>, <code>odt</code>, <code>opendocument</code>, <code>html</code></dd>
</dl>

<h4 id="ext-styles">Extension: <code>styles</code></h4>

<p>When converting from docx, read all docx styles as divs (for
paragraph styles) and spans (for character styles) regardless
of whether pandoc understands the meaning of these styles.
This can be used with <a href='#custom-styles' title=''>docx custom styles</a>.
Disabled by default.</p>

<dl>
<dt>input formats</dt>
<dd><code>docx</code></dd>
</dl>

<h4 id="extension-amuse">Extension: <code>amuse</code></h4>

<p>In the <code>muse</code> input format, this enables Text::Amuse
extensions to Emacs Muse markup.</p>

<h4 id="org-citations">Extension: <code>citations</code></h4>

<p>Some aspects of <a href='#citations' title=''>Pandoc’s Markdown citation syntax</a> are also accepted
in <code>org</code> input.</p>

<h4 id="extension-ntb">Extension: <code>ntb</code></h4>

<p>In the <code>context</code> output format this enables the use of <a href='http://wiki.contextgarden.net/TABLE' title=''>Natural Tables
(TABLE)</a> instead of the default
<a href='http://wiki.contextgarden.net/xtables' title=''>Extreme Tables (xtables)</a>.
Natural tables allow more fine-grained global customization but come
at a performance penalty compared to extreme tables.</p>

<h1 id="pandocs-markdown">Pandoc’s Markdown</h1>

<p>Pandoc understands an extended and slightly revised version of
John Gruber’s <a href='http://daringfireball.net/projects/markdown/' title=''>Markdown</a> syntax. This document explains the syntax,
noting differences from standard Markdown. Except where noted, these
differences can be suppressed by using the <code>markdown_strict</code> format instead
of <code>markdown</code>. Extensions can be enabled or disabled to specify the
behavior more granularly. They are described in the following. See also
<a href='#extensions' title=''>Extensions</a> above, for extensions that work also on other formats.</p>

<h2 id="philosophy">Philosophy</h2>

<p>Markdown is designed to be easy to write, and, even more importantly,
easy to read:</p>

<blockquote>
<p>A Markdown-formatted document should be publishable as-is, as plain
text, without looking like it’s been marked up with tags or formatting
instructions.
– <a href='http://daringfireball.net/projects/markdown/syntax#philosophy' title=''>John Gruber</a></p>
</blockquote>

<p>This principle has guided pandoc’s decisions in finding syntax for
tables, footnotes, and other extensions.</p>

<p>There is, however, one respect in which pandoc’s aims are different
from the original aims of Markdown. Whereas Markdown was originally
designed with HTML generation in mind, pandoc is designed for multiple
output formats. Thus, while pandoc allows the embedding of raw HTML,
it discourages it, and provides other, non-HTMLish ways of representing
important document elements like definition lists, tables, mathematics, and
footnotes.</p>

<h2 id="paragraphs">Paragraphs</h2>

<p>A paragraph is one or more lines of text followed by one or more blank lines.
Newlines are treated as spaces, so you can reflow your paragraphs as you like.
If you need a hard line break, put two or more spaces at the end of a line.</p>

<h4 id="extension-escaped_line_breaks">Extension: <code>escaped_line_breaks</code></h4>

<p>A backslash followed by a newline is also a hard line break.
Note: in multiline and grid table cells, this is the only way
to create a hard line break, since trailing spaces in the cells
are ignored.</p>

<h2 id="headers">Headers</h2>

<p>There are two kinds of headers: Setext and ATX.</p>

<h3 id="setext-style-headers">Setext-style headers</h3>

<p>A setext-style header is a line of text &ldquo;underlined&rdquo; with a row of <code>=</code> signs
(for a level one header) or <code>-</code> signs (for a level two header):</p>

<pre><code>A level-one header
==================

A level-two header
------------------</code></pre>

<p>The header text can contain inline formatting, such as emphasis (see
<a href='#inline-formatting' title=''>Inline formatting</a>, below).</p>

<h3 id="atx-style-headers">ATX-style headers</h3>

<p>An ATX-style header consists of one to six <code>#</code> signs and a line of
text, optionally followed by any number of <code>#</code> signs. The number of
<code>#</code> signs at the beginning of the line is the header level:</p>

<pre><code>## A level-two header

### A level-three header ###</code></pre>

<p>As with setext-style headers, the header text can contain formatting:</p>

<pre><code># A level-one header with a [link](/url) and *emphasis*</code></pre>

<h4 id="extension-blank_before_header">Extension: <code>blank_before_header</code></h4>

<p>Standard Markdown syntax does not require a blank line before a header.
Pandoc does require this (except, of course, at the beginning of the
document). The reason for the requirement is that it is all too easy for a
<code>#</code> to end up at the beginning of a line by accident (perhaps through line
wrapping). Consider, for example:</p>

<pre><code>I like several of their flavors of ice cream:
#22, for example, and #5.</code></pre>

<h4 id="extension-space_in_atx_header">Extension: <code>space_in_atx_header</code></h4>

<p>Many Markdown implementations do not require a space between the
opening <code>#</code>s of an ATX header and the header text, so that
<code>#5 bolt</code> and <code>#hashtag</code> count as headers. With this extension,
pandoc does require the space.</p>

<h3 id="header-identifiers">Header identifiers</h3>

<p>See also the <a href='#extension-auto_identifiers' title=''><code>auto_identifiers</code> extension</a> above.</p>

<h4 id="extension-header_attributes">Extension: <code>header_attributes</code></h4>

<p>Headers can be assigned attributes using this syntax at the end
of the line containing the header text:</p>

<pre><code>{#identifier .class .class key=value key=value}</code></pre>

<p>Thus, for example, the following headers will all be assigned the identifier
<code>foo</code>:</p>

<pre><code># My header {#foo}

## My header ##    {#foo}

My other header   {#foo}
---------------</code></pre>

<p>(This syntax is compatible with <a href='https://michelf.ca/projects/php-markdown/extra/' title=''>PHP Markdown Extra</a>.)</p>

<p>Note that although this syntax allows assignment of classes and key/value
attributes, writers generally don’t use all of this information. Identifiers,
classes, and key/value attributes are used in HTML and HTML-based formats such
as EPUB and slidy. Identifiers are used for labels and link anchors in the
LaTeX, ConTeXt, Textile, and AsciiDoc writers.</p>

<p>Headers with the class <code>unnumbered</code> will not be numbered, even if
<code>--number-sections</code> is specified. A single hyphen (<code>-</code>) in an attribute
context is equivalent to <code>.unnumbered</code>, and preferable in non-English
documents. So,</p>

<pre><code># My header {-}</code></pre>

<p>is just the same as</p>

<pre><code># My header {.unnumbered}</code></pre>

<h4 id="extension-implicit_header_references">Extension: <code>implicit_header_references</code></h4>

<p>Pandoc behaves as if reference links have been defined for each header.
So, to link to a header</p>

<pre><code># Header identifiers in HTML</code></pre>

<p>you can simply write</p>

<pre><code>[Header identifiers in HTML]</code></pre>

<p>or</p>

<pre><code>[Header identifiers in HTML][]</code></pre>

<p>or</p>

<pre><code>[the section on header identifiers][header identifiers in
HTML]</code></pre>

<p>instead of giving the identifier explicitly:</p>

<pre><code>[Header identifiers in HTML](#header-identifiers-in-html)</code></pre>

<p>If there are multiple headers with identical text, the corresponding
reference will link to the first one only, and you will need to use explicit
links to link to the others, as described above.</p>

<p>Like regular reference links, these references are case-insensitive.</p>

<p>Explicit link reference definitions always take priority over
implicit header references. So, in the following example, the
link will point to <code>bar</code>, not to <code>#foo</code>:</p>

<pre><code># Foo

[foo]: bar

See [foo]</code></pre>

<h2 id="block-quotations">Block quotations</h2>

<p>Markdown uses email conventions for quoting blocks of text.
A block quotation is one or more paragraphs or other block elements
(such as lists or headers), with each line preceded by a <code>&gt;</code> character
and an optional space. (The <code>&gt;</code> need not start at the left margin, but
it should not be indented more than three spaces.)</p>

<pre><code>&gt; This is a block quote. This
&gt; paragraph has two lines.
&gt;
&gt; 1. This is a list inside a block quote.
&gt; 2. Second item.</code></pre>

<p>A &ldquo;lazy&rdquo; form, which requires the <code>&gt;</code> character only on the first
line of each block, is also allowed:</p>

<pre><code>&gt; This is a block quote. This
paragraph has two lines.

&gt; 1. This is a list inside a block quote.
2. Second item.</code></pre>

<p>Among the block elements that can be contained in a block quote are
other block quotes. That is, block quotes can be nested:</p>

<pre><code>&gt; This is a block quote.
&gt;
&gt; &gt; A block quote within a block quote.</code></pre>

<p>If the <code>&gt;</code> character is followed by an optional space, that space
will be considered part of the block quote marker and not part of
the indentation of the contents. Thus, to put an indented code
block in a block quote, you need five spaces after the <code>&gt;</code>:</p>

<pre><code>&gt;     code</code></pre>

<h4 id="extension-blank_before_blockquote">Extension: <code>blank_before_blockquote</code></h4>

<p>Standard Markdown syntax does not require a blank line before a block
quote. Pandoc does require this (except, of course, at the beginning of the
document). The reason for the requirement is that it is all too easy for a
<code>&gt;</code> to end up at the beginning of a line by accident (perhaps through line
wrapping). So, unless the <code>markdown_strict</code> format is used, the following does
not produce a nested block quote in pandoc:</p>

<pre><code>&gt; This is a block quote.
&gt;&gt; Nested.</code></pre>

<h2 id="verbatim-code-blocks">Verbatim (code) blocks</h2>

<h3 id="indented-code-blocks">Indented code blocks</h3>

<p>A block of text indented four spaces (or one tab) is treated as verbatim
text: that is, special characters do not trigger special formatting,
and all spaces and line breaks are preserved. For example,</p>

<pre><code>    if (a &gt; 3) {
      moveShip(5 * gravity, DOWN);
    }</code></pre>

<p>The initial (four space or one tab) indentation is not considered part
of the verbatim text, and is removed in the output.</p>

<p>Note: blank lines in the verbatim text need not begin with four spaces.</p>

<h3 id="fenced-code-blocks">Fenced code blocks</h3>

<h4 id="extension-fenced_code_blocks">Extension: <code>fenced_code_blocks</code></h4>

<p>In addition to standard indented code blocks, pandoc supports
<em>fenced</em> code blocks. These begin with a row of three or more
tildes (<code>~</code>) and end with a row of tildes that must be at least as long as
the starting row. Everything between these lines is treated as code. No
indentation is necessary:</p>

<pre><code>~~~~~~~
if (a &gt; 3) {
  moveShip(5 * gravity, DOWN);
}
~~~~~~~</code></pre>

<p>Like regular code blocks, fenced code blocks must be separated
from surrounding text by blank lines.</p>

<p>If the code itself contains a row of tildes or backticks, just use a longer
row of tildes or backticks at the start and end:</p>

<pre><code>~~~~~~~~~~~~~~~~
~~~~~~~~~~
code including tildes
~~~~~~~~~~
~~~~~~~~~~~~~~~~</code></pre>

<h4 id="extension-backtick_code_blocks">Extension: <code>backtick_code_blocks</code></h4>

<p>Same as <code>fenced_code_blocks</code>, but uses backticks (<code>`</code>) instead of tildes
(<code>~</code>).</p>

<h4 id="extension-fenced_code_attributes">Extension: <code>fenced_code_attributes</code></h4>

<p>Optionally, you may attach attributes to fenced or backtick code block using
this syntax:</p>

<pre><code>~~~~ {#mycode .haskell .numberLines startFrom=&quot;100&quot;}
qsort []     = []
qsort (x:xs) = qsort (filter (&lt; x) xs) ++ [x] ++
               qsort (filter (&gt;= x) xs)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~</code></pre>

<p>Here <code>mycode</code> is an identifier, <code>haskell</code> and <code>numberLines</code> are classes, and
<code>startFrom</code> is an attribute with value <code>100</code>. Some output formats can use this
information to do syntax highlighting. Currently, the only output formats
that uses this information are HTML, LaTeX, Docx, Ms, and PowerPoint. If
highlighting is supported for your output format and language, then the code
block above will appear highlighted, with numbered lines. (To see which
languages are supported, type <code>pandoc --list-highlight-languages</code>.) Otherwise,
the code block above will appear as follows:</p>

<pre><code>&lt;pre id=&quot;mycode&quot; class=&quot;haskell numberLines&quot; startFrom=&quot;100&quot;&gt;
  &lt;code&gt;
  ...
  &lt;/code&gt;
&lt;/pre&gt;</code></pre>

<p>The <code>numberLines</code> (or <code>number-lines</code>) class will cause the lines
of the code block to be numbered, starting with <code>1</code> or the value
of the <code>startFrom</code> attribute. The <code>lineAnchors</code> (or
<code>line-anchors</code>) class will cause the lines to be clickable
anchors in HTML output.</p>

<p>A shortcut form can also be used for specifying the language of
the code block:</p>

<pre><code>```haskell
qsort [] = []
```</code></pre>

<p>This is equivalent to:</p>

<pre><code>``` {.haskell}
qsort [] = []
```</code></pre>

<p>If the <code>fenced_code_attributes</code> extension is disabled, but
input contains class attribute(s) for the code block, the first
class attribute will be printed after the opening fence as a bare
word.</p>

<p>To prevent all highlighting, use the <code>--no-highlight</code> flag.
To set the highlighting style, use <code>--highlight-style</code>.
For more information on highlighting, see <a href='#syntax-highlighting' title=''>Syntax highlighting</a>,
below.</p>

<h2 id="line-blocks">Line blocks</h2>

<h4 id="extension-line_blocks">Extension: <code>line_blocks</code></h4>

<p>A line block is a sequence of lines beginning with a vertical bar (<code>|</code>)
followed by a space. The division into lines will be preserved in
the output, as will any leading spaces; otherwise, the lines will
be formatted as Markdown. This is useful for verse and addresses:</p>

<pre><code>| The limerick packs laughs anatomical
| In space that is quite economical.
|    But the good ones I&#39;ve seen
|    So seldom are clean
| And the clean ones so seldom are comical

| 200 Main St.
| Berkeley, CA 94718</code></pre>

<p>The lines can be hard-wrapped if needed, but the continuation
line must begin with a space.</p>

<pre><code>| The Right Honorable Most Venerable and Righteous Samuel L.
  Constable, Jr.
| 200 Main St.
| Berkeley, CA 94718</code></pre>

<p>This syntax is borrowed from <a href='http://docutils.sourceforge.net/docs/ref/rst/introduction.html' title=''>reStructuredText</a>.</p>

<h2 id="lists">Lists</h2>

<h3 id="bullet-lists">Bullet lists</h3>

<p>A bullet list is a list of bulleted list items. A bulleted list
item begins with a bullet (<code>*</code>, <code>+</code>, or <code>-</code>). Here is a simple
example:</p>

<pre><code>* one
* two
* three</code></pre>

<p>This will produce a &ldquo;compact&rdquo; list. If you want a &ldquo;loose&rdquo; list, in which
each item is formatted as a paragraph, put spaces between the items:</p>

<pre><code>* one

* two

* three</code></pre>

<p>The bullets need not be flush with the left margin; they may be
indented one, two, or three spaces. The bullet must be followed
by whitespace.</p>

<p>List items look best if subsequent lines are flush with the first
line (after the bullet):</p>

<pre><code>* here is my first
  list item.
* and my second.</code></pre>

<p>But Markdown also allows a &ldquo;lazy&rdquo; format:</p>

<pre><code>* here is my first
list item.
* and my second.</code></pre>

<h3 id="block-content-in-list-items">Block content in list items</h3>

<p>A list item may contain multiple paragraphs and other block-level
content. However, subsequent paragraphs must be preceded by a blank line
and indented to line up with the first non-space content after
the list marker.</p>

<pre><code>  * First paragraph.

    Continued.

  * Second paragraph. With a code block, which must be indented
    eight spaces:

        { code }</code></pre>

<p>Exception: if the list marker is followed by an indented code
block, which must begin 5 spaces after the list marker, then
subsequent paragraphs must begin two columns after the last
character of the list marker:</p>

<pre><code>*     code

  continuation paragraph</code></pre>

<p>List items may include other lists. In this case the preceding blank
line is optional. The nested list must be indented to line up with
the first non-space character after the list marker of the
containing list item.</p>

<pre><code>* fruits
  + apples
    - macintosh
    - red delicious
  + pears
  + peaches
* vegetables
  + broccoli
  + chard</code></pre>

<p>As noted above, Markdown allows you to write list items &ldquo;lazily,&rdquo; instead of
indenting continuation lines. However, if there are multiple paragraphs or
other blocks in a list item, the first line of each must be indented.</p>

<pre><code>+ A lazy, lazy, list
item.

+ Another one; this looks
bad but is legal.

    Second paragraph of second
list item.</code></pre>

<h3 id="ordered-lists">Ordered lists</h3>

<p>Ordered lists work just like bulleted lists, except that the items
begin with enumerators rather than bullets.</p>

<p>In standard Markdown, enumerators are decimal numbers followed
by a period and a space. The numbers themselves are ignored, so
there is no difference between this list:</p>

<pre><code>1.  one
2.  two
3.  three</code></pre>

<p>and this one:</p>

<pre><code>5.  one
7.  two
1.  three</code></pre>

<h4 id="extension-fancy_lists">Extension: <code>fancy_lists</code></h4>

<p>Unlike standard Markdown, pandoc allows ordered list items to be marked
with uppercase and lowercase letters and roman numerals, in addition to
Arabic numerals. List markers may be enclosed in parentheses or followed by a
single right-parentheses or period. They must be separated from the
text that follows by at least one space, and, if the list marker is a
capital letter with a period, by at least two spaces.<a id="fnref1" href="#fn1"><sup>1</sup></a></p>

<p>The <code>fancy_lists</code> extension also allows &lsquo;<code>#</code>&rsquo; to be used as an
ordered list marker in place of a numeral:</p>

<pre><code>#. one
#. two</code></pre>

<h4 id="extension-startnum">Extension: <code>startnum</code></h4>

<p>Pandoc also pays attention to the type of list marker used, and to the
starting number, and both of these are preserved where possible in the
output format. Thus, the following yields a list with numbers followed
by a single parenthesis, starting with 9, and a sublist with lowercase
roman numerals:</p>

<pre><code> 9)  Ninth
10)  Tenth
11)  Eleventh
       i. subone
      ii. subtwo
     iii. subthree</code></pre>

<p>Pandoc will start a new list each time a different type of list
marker is used. So, the following will create three lists:</p>

<pre><code>(2) Two
(5) Three
1.  Four
*   Five</code></pre>

<p>If default list markers are desired, use <code>#.</code>:</p>

<pre><code>#.  one
#.  two
#.  three</code></pre>

<h4 id="extension-task_lists">Extension: <code>task_lists</code></h4>

<p>Pandoc supports task lists, using the syntax of GitHub-Flavored Markdown.</p>

<pre><code>- [ ] an unchecked task list item
- [x] checked item</code></pre>

<h3 id="definition-lists">Definition lists</h3>

<h4 id="extension-definition_lists">Extension: <code>definition_lists</code></h4>

<p>Pandoc supports definition lists, using the syntax of
<a href='https://michelf.ca/projects/php-markdown/extra/' title=''>PHP Markdown Extra</a> with some extensions.<a id="fnref2" href="#fn2"><sup>2</sup></a></p>

<pre><code>Term 1

:   Definition 1

Term 2 with *inline markup*

:   Definition 2

        { some code, part of Definition 2 }

    Third paragraph of definition 2.</code></pre>

<p>Each term must fit on one line, which may optionally be followed by
a blank line, and must be followed by one or more definitions.
A definition begins with a colon or tilde, which may be indented one
or two spaces.</p>

<p>A term may have multiple definitions, and each definition may consist of one or
more block elements (paragraph, code block, list, etc.), each indented four
spaces or one tab stop. The body of the definition (including the first line,
aside from the colon or tilde) should be indented four spaces. However,
as with other Markdown lists, you can &ldquo;lazily&rdquo; omit indentation except
at the beginning of a paragraph or other block element:</p>

<pre><code>Term 1

:   Definition
with lazy continuation.

    Second paragraph of the definition.</code></pre>

<p>If you leave space before the definition (as in the example above),
the text of the definition will be treated as a paragraph. In some
output formats, this will mean greater spacing between term/definition
pairs. For a more compact definition list, omit the space before the
definition:</p>

<pre><code>Term 1
  ~ Definition 1

Term 2
  ~ Definition 2a
  ~ Definition 2b</code></pre>

<p>Note that space between items in a definition list is required.
(A variant that loosens this requirement, but disallows &ldquo;lazy&rdquo;
hard wrapping, can be activated with <code>compact_definition_lists</code>: see
<a href='#non-pandoc-extensions' title=''>Non-pandoc extensions</a>, below.)</p>

<h3 id="numbered-example-lists">Numbered example lists</h3>

<h4 id="extension-example_lists">Extension: <code>example_lists</code></h4>

<p>The special list marker <code>@</code> can be used for sequentially numbered
examples. The first list item with a <code>@</code> marker will be numbered &lsquo;1&rsquo;,
the next &lsquo;2&rsquo;, and so on, throughout the document. The numbered examples
need not occur in a single list; each new list using <code>@</code> will take up
where the last stopped. So, for example:</p>

<pre><code>(@)  My first example will be numbered (1).
(@)  My second example will be numbered (2).

Explanation of examples.

(@)  My third example will be numbered (3).</code></pre>

<p>Numbered examples can be labeled and referred to elsewhere in the
document:</p>

<pre><code>(@good)  This is a good example.

As (@good) illustrates, ...</code></pre>

<p>The label can be any string of alphanumeric characters, underscores,
or hyphens.</p>

<p>Note: continuation paragraphs in example lists must always
be indented four spaces, regardless of the length of the
list marker. That is, example lists always behave as if the
<code>four_space_rule</code> extension is set. This is because example
labels tend to be long, and indenting content to the
first non-space character after the label would be awkward.</p>

<h3 id="compact-and-loose-lists">Compact and loose lists</h3>

<p>Pandoc behaves differently from <code>Markdown.pl</code> on some &ldquo;edge
cases&rdquo; involving lists. Consider this source:</p>

<pre><code>+   First
+   Second:
    -   Fee
    -   Fie
    -   Foe

+   Third</code></pre>

<p>Pandoc transforms this into a &ldquo;compact list&rdquo; (with no <code>&lt;p&gt;</code> tags around
&ldquo;First&rdquo;, &ldquo;Second&rdquo;, or &ldquo;Third&rdquo;), while Markdown puts <code>&lt;p&gt;</code> tags around
&ldquo;Second&rdquo; and &ldquo;Third&rdquo; (but not &ldquo;First&rdquo;), because of the blank space
around &ldquo;Third&rdquo;. Pandoc follows a simple rule: if the text is followed by
a blank line, it is treated as a paragraph. Since &ldquo;Second&rdquo; is followed
by a list, and not a blank line, it isn’t treated as a paragraph. The
fact that the list is followed by a blank line is irrelevant. (Note:
Pandoc works this way even when the <code>markdown_strict</code> format is specified. This
behavior is consistent with the official Markdown syntax description,
even though it is different from that of <code>Markdown.pl</code>.)</p>

<h3 id="ending-a-list">Ending a list</h3>

<p>What if you want to put an indented code block after a list?</p>

<pre><code>-   item one
-   item two

    { my code block }</code></pre>

<p>Trouble! Here pandoc (like other Markdown implementations) will treat
<code>{ my code block }</code> as the second paragraph of item two, and not as
a code block.</p>

<p>To &ldquo;cut off&rdquo; the list after item two, you can insert some non-indented
content, like an HTML comment, which won’t produce visible output in
any format:</p>

<pre><code>-   item one
-   item two

&lt;!-- end of list --&gt;

    { my code block }</code></pre>

<p>You can use the same trick if you want two consecutive lists instead
of one big list:</p>

<pre><code>1.  one
2.  two
3.  three

&lt;!-- --&gt;

1.  uno
2.  dos
3.  tres</code></pre>

<h2 id="horizontal-rules">Horizontal rules</h2>

<p>A line containing a row of three or more <code>*</code>, <code>-</code>, or <code>_</code> characters
(optionally separated by spaces) produces a horizontal rule:</p>

<pre><code>*  *  *  *

---------------</code></pre>

<h2 id="tables">Tables</h2>

<p>Four kinds of tables may be used. The first three kinds presuppose the use of
a fixed-width font, such as Courier. The fourth kind can be used with
proportionally spaced fonts, as it does not require lining up columns.</p>

<h4 id="extension-table_captions">Extension: <code>table_captions</code></h4>

<p>A caption may optionally be provided with all 4 kinds of tables (as
illustrated in the examples below). A caption is a paragraph beginning
with the string <code>Table:</code> (or just <code>:</code>), which will be stripped off.
It may appear either before or after the table.</p>

<h4 id="extension-simple_tables">Extension: <code>simple_tables</code></h4>

<p>Simple tables look like this:</p>

<pre><code>  Right     Left     Center     Default
-------     ------ ----------   -------
     12     12        12            12
    123     123       123          123
      1     1          1             1

Table:  Demonstration of simple table syntax.</code></pre>

<p>The headers and table rows must each fit on one line. Column
alignments are determined by the position of the header text relative
to the dashed line below it:<a id="fnref3" href="#fn3"><sup>3</sup></a></p>

<ul>
<li>If the dashed line is flush with the header text on the right side
but extends beyond it on the left, the column is right-aligned.</li>
<li>If the dashed line is flush with the header text on the left side
but extends beyond it on the right, the column is left-aligned.</li>
<li>If the dashed line extends beyond the header text on both sides,
the column is centered.</li>
<li>If the dashed line is flush with the header text on both sides,
the default alignment is used (in most cases, this will be left).</li>
</ul>

<p>The table must end with a blank line, or a line of dashes followed by
a blank line.</p>

<p>The column headers may be omitted, provided a dashed line is used
to end the table. For example:</p>

<pre><code>-------     ------ ----------   -------
     12     12        12             12
    123     123       123           123
      1     1          1              1
-------     ------ ----------   -------</code></pre>

<p>When headers are omitted, column alignments are determined on the basis
of the first line of the table body. So, in the tables above, the columns
would be right, left, center, and right aligned, respectively.</p>

<h4 id="extension-multiline_tables">Extension: <code>multiline_tables</code></h4>

<p>Multiline tables allow headers and table rows to span multiple lines
of text (but cells that span multiple columns or rows of the table are
not supported). Here is an example:</p>

<pre><code>-------------------------------------------------------------
 Centered   Default           Right Left
  Header    Aligned         Aligned Aligned
----------- ------- --------------- -------------------------
   First    row                12.0 Example of a row that
                                    spans multiple lines.

  Second    row                 5.0 Here&#39;s another one. Note
                                    the blank line between
                                    rows.
-------------------------------------------------------------

Table: Here&#39;s the caption. It, too, may span
multiple lines.</code></pre>

<p>These work like simple tables, but with the following differences:</p>

<ul>
<li>They must begin with a row of dashes, before the header text
(unless the headers are omitted).</li>
<li>They must end with a row of dashes, then a blank line.</li>
<li>The rows must be separated by blank lines.</li>
</ul>

<p>In multiline tables, the table parser pays attention to the widths of
the columns, and the writers try to reproduce these relative widths in
the output. So, if you find that one of the columns is too narrow in the
output, try widening it in the Markdown source.</p>

<p>Headers may be omitted in multiline tables as well as simple tables:</p>

<pre><code>----------- ------- --------------- -------------------------
   First    row                12.0 Example of a row that
                                    spans multiple lines.

  Second    row                 5.0 Here&#39;s another one. Note
                                    the blank line between
                                    rows.
----------- ------- --------------- -------------------------

: Here&#39;s a multiline table without headers.</code></pre>

<p>It is possible for a multiline table to have just one row, but the row
should be followed by a blank line (and then the row of dashes that ends
the table), or the table may be interpreted as a simple table.</p>

<h4 id="extension-grid_tables">Extension: <code>grid_tables</code></h4>

<p>Grid tables look like this:</p>

<pre><code>: Sample grid table.

+---------------+---------------+--------------------+
| Fruit         | Price         | Advantages         |
+===============+===============+====================+
| Bananas       | $1.34         | - built-in wrapper |
|               |               | - bright color     |
+---------------+---------------+--------------------+
| Oranges       | $2.10         | - cures scurvy     |
|               |               | - tasty            |
+---------------+---------------+--------------------+</code></pre>

<p>The row of <code>=</code>s separates the header from the table body, and can be
omitted for a headerless table. The cells of grid tables may contain
arbitrary block elements (multiple paragraphs, code blocks, lists,
etc.). Cells that span multiple columns or rows are not
supported. Grid tables can be created easily using <a href='http://table.sourceforge.net/' title=''>Emacs table mode</a>.</p>

<p>Alignments can be specified as with pipe tables, by putting
colons at the boundaries of the separator line after the
header:</p>

<pre><code>+---------------+---------------+--------------------+
| Right         | Left          | Centered           |
+==============:+:==============+:==================:+
| Bananas       | $1.34         | built-in wrapper   |
+---------------+---------------+--------------------+</code></pre>

<p>For headerless tables, the colons go on the top line instead:</p>

<pre><code>+--------------:+:--------------+:------------------:+
| Right         | Left          | Centered           |
+---------------+---------------+--------------------+</code></pre>

<h5 id="grid-table-limitations">Grid Table Limitations</h5>

<p>Pandoc does not support grid tables with row spans or column spans.
This means that neither variable numbers of columns across rows nor
variable numbers of rows across columns are supported by Pandoc.
All grid tables must have the same number of columns in each row,
and the same number of rows in each column. For example, the
Docutils <a href='http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#grid-tables' title=''>sample grid tables</a> will not render as expected with
Pandoc.</p>

<h4 id="extension-pipe_tables">Extension: <code>pipe_tables</code></h4>

<p>Pipe tables look like this:</p>

<pre><code>| Right | Left | Default | Center |
|------:|:-----|---------|:------:|
|   12  |  12  |    12   |    12  |
|  123  |  123 |   123   |   123  |
|    1  |    1 |     1   |     1  |

  : Demonstration of pipe table syntax.</code></pre>

<p>The syntax is identical to <a href='https://michelf.ca/projects/php-markdown/extra/#table' title=''>PHP Markdown Extra tables</a>. The beginning and
ending pipe characters are optional, but pipes are required between all
columns. The colons indicate column alignment as shown. The header
cannot be omitted. To simulate a headerless table, include a header
with blank cells.</p>

<p>Since the pipes indicate column boundaries, columns need not be vertically
aligned, as they are in the above example. So, this is a perfectly
legal (though ugly) pipe table:</p>

<pre><code>fruit| price
-----|-----:
apple|2.05
pear|1.37
orange|3.09</code></pre>

<p>The cells of pipe tables cannot contain block elements like paragraphs
and lists, and cannot span multiple lines. If a pipe table contains a
row whose printable content is wider than the column width (see
<code>--columns</code>), then the table will take up the full text width and
the cell contents will wrap, with the relative cell widths determined
by the number of dashes in the line separating the table header from
the table body. (For example <code>---|-</code> would make the first column 3/4
and the second column 1/4 of the full text width.)
On the other hand, if no lines are wider than column width, then
cell contents will not be wrapped, and the cells will be sized
to their contents.</p>

<p>Note: pandoc also recognizes pipe tables of the following
form, as can be produced by Emacs’ orgtbl-mode:</p>

<pre><code>| One | Two   |
|-----+-------|
| my  | table |
| is  | nice  |</code></pre>

<p>The difference is that <code>+</code> is used instead of <code>|</code>. Other orgtbl features
are not supported. In particular, to get non-default column alignment,
you’ll need to add colons as above.</p>

<h2 id="metadata-blocks">Metadata blocks</h2>

<h4 id="extension-pandoc_title_block">Extension: <code>pandoc_title_block</code></h4>

<p>If the file begins with a title block</p>

<pre><code>% title
% author(s) (separated by semicolons)
% date</code></pre>

<p>it will be parsed as bibliographic information, not regular text. (It
will be used, for example, in the title of standalone LaTeX or HTML
output.) The block may contain just a title, a title and an author,
or all three elements. If you want to include an author but no
title, or a title and a date but no author, you need a blank line:</p>

<pre><code>%
% Author

% My title
%
% June 15, 2006</code></pre>

<p>The title may occupy multiple lines, but continuation lines must
begin with leading space, thus:</p>

<pre><code>% My title
  on multiple lines</code></pre>

<p>If a document has multiple authors, the authors may be put on
separate lines with leading space, or separated by semicolons, or
both. So, all of the following are equivalent:</p>

<pre><code>% Author One
  Author Two

% Author One; Author Two

% Author One;
  Author Two</code></pre>

<p>The date must fit on one line.</p>

<p>All three metadata fields may contain standard inline formatting
(italics, links, footnotes, etc.).</p>

<p>Title blocks will always be parsed, but they will affect the output only
when the <code>--standalone</code> (<code>-s</code>) option is chosen. In HTML output, titles
will appear twice: once in the document head – this is the title that
will appear at the top of the window in a browser – and once at the
beginning of the document body. The title in the document head can have
an optional prefix attached (<code>--title-prefix</code> or <code>-T</code> option). The title
in the body appears as an H1 element with class &ldquo;title&rdquo;, so it can be
suppressed or reformatted with CSS. If a title prefix is specified with
<code>-T</code> and no title block appears in the document, the title prefix will
be used by itself as the HTML title.</p>

<p>The man page writer extracts a title, man page section number, and
other header and footer information from the title line. The title
is assumed to be the first word on the title line, which may optionally
end with a (single-digit) section number in parentheses. (There should
be no space between the title and the parentheses.) Anything after
this is assumed to be additional footer and header text. A single pipe
character (<code>|</code>) should be used to separate the footer text from the header
text. Thus,</p>

<pre><code>% PANDOC(1)</code></pre>

<p>will yield a man page with the title <code>PANDOC</code> and section 1.</p>

<pre><code>% PANDOC(1) Pandoc User Manuals</code></pre>

<p>will also have &ldquo;Pandoc User Manuals&rdquo; in the footer.</p>

<pre><code>% PANDOC(1) Pandoc User Manuals | Version 4.0</code></pre>

<p>will also have &ldquo;Version 4.0&rdquo; in the header.</p>

<h4 id="extension-yaml_metadata_block">Extension: <code>yaml_metadata_block</code></h4>

<p>A YAML metadata block is a valid YAML object, delimited by a line of three
hyphens (<code>---</code>) at the top and a line of three hyphens (<code>---</code>) or three dots
(<code>...</code>) at the bottom. A YAML metadata block may occur anywhere in the
document, but if it is not at the beginning, it must be preceded by a blank
line. (Note that, because of the way pandoc concatenates input files when
several are provided, you may also keep the metadata in a separate YAML file
and pass it to pandoc as an argument, along with your Markdown files:</p>

<pre><code>pandoc chap1.md chap2.md chap3.md metadata.yaml -s -o book.html</code></pre>

<p>Just be sure that the YAML file begins with <code>---</code> and ends with <code>---</code> or
<code>...</code>.) Alternatively, you can use the <code>--metadata-file</code> option. Using
that approach however, you cannot reference content (like footnotes)
from the main markdown input document.</p>

<p>Metadata will be taken from the fields of the YAML object and added to any
existing document metadata. Metadata can contain lists and objects (nested
arbitrarily), but all string scalars will be interpreted as Markdown. Fields
with names ending in an underscore will be ignored by pandoc. (They may be
given a role by external processors.) Field names must not be
interpretable as YAML numbers or boolean values (so, for
example, <code>yes</code>, <code>True</code>, and <code>15</code> cannot be used as field names).</p>

<p>A document may contain multiple metadata blocks. The metadata fields will
be combined through a <em>left-biased union</em>: if two metadata blocks attempt
to set the same field, the value from the first block will be taken.</p>

<p>When pandoc is used with <code>-t markdown</code> to create a Markdown document,
a YAML metadata block will be produced only if the <code>-s/--standalone</code>
option is used. All of the metadata will appear in a single block
at the beginning of the document.</p>

<p>Note that YAML escaping rules must be followed. Thus, for example,
if a title contains a colon, it must be quoted. The pipe character
(<code>|</code>) can be used to begin an indented block that will be interpreted
literally, without need for escaping. This form is necessary
when the field contains blank lines or block-level formatting:</p>

<pre><code>---
title:  &#39;This is the title: it contains a colon&#39;
author:
- Author One
- Author Two
keywords: [nothing, nothingness]
abstract: |
  This is the abstract.

  It consists of two paragraphs.
...</code></pre>

<p>Template variables will be set automatically from the metadata. Thus, for
example, in writing HTML, the variable <code>abstract</code> will be set to the HTML
equivalent of the Markdown in the <code>abstract</code> field:</p>

<pre><code>&lt;p&gt;This is the abstract.&lt;/p&gt;
&lt;p&gt;It consists of two paragraphs.&lt;/p&gt;</code></pre>

<p>Variables can contain arbitrary YAML structures, but the template must match
this structure. The <code>author</code> variable in the default templates expects a
simple list or string, but can be changed to support more complicated
structures. The following combination, for example, would add an affiliation
to the author if one is given:</p>

<pre><code>---
title: The document title
author:
- name: Author One
  affiliation: University of Somewhere
- name: Author Two
  affiliation: University of Nowhere
...</code></pre>

<p>To use the structured authors in the example above, you would need a custom
template:</p>

<pre><code>$for(author)$
$if(author.name)$
$author.name$$if(author.affiliation)$ ($author.affiliation$)$endif$
$else$
$author$
$endif$
$endfor$</code></pre>

<p>Raw content to include in the document’s header may be specified
using <code>header-includes</code>; however, it is important to mark up
this content as raw code for a particular output format, using
the <a href='#extension-raw_attribute' title=''><code>raw_attribute</code> extension</a>), or it
will be interpreted as markdown. For example:</p>

<pre><code>header-includes:
- |
  ```{=latex}
  \let\oldsection\section
  \renewcommand{\section}[1]{\clearpage\oldsection{#1}}
  ```</code></pre>

<h2 id="backslash-escapes">Backslash escapes</h2>

<h4 id="extension-all_symbols_escapable">Extension: <code>all_symbols_escapable</code></h4>

<p>Except inside a code block or inline code, any punctuation or space
character preceded by a backslash will be treated literally, even if it
would normally indicate formatting. Thus, for example, if one writes</p>

<pre><code>*\*hello\**</code></pre>

<p>one will get</p>

<pre><code>&lt;em&gt;*hello*&lt;/em&gt;</code></pre>

<p>instead of</p>

<pre><code>&lt;strong&gt;hello&lt;/strong&gt;</code></pre>

<p>This rule is easier to remember than standard Markdown’s rule,
which allows only the following characters to be backslash-escaped:</p>

<pre><code>\`*_{}[]()&gt;#+-.!</code></pre>

<p>(However, if the <code>markdown_strict</code> format is used, the standard Markdown rule
will be used.)</p>

<p>A backslash-escaped space is parsed as a nonbreaking space. It will
appear in TeX output as <code>~</code> and in HTML and XML as <code>\&amp;#160;</code> or
<code>\&amp;nbsp;</code>.</p>

<p>A backslash-escaped newline (i.e. a backslash occurring at the end of
a line) is parsed as a hard line break. It will appear in TeX output as
<code>\\</code> and in HTML as <code>&lt;br /&gt;</code>. This is a nice alternative to
Markdown’s &ldquo;invisible&rdquo; way of indicating hard line breaks using
two trailing spaces on a line.</p>

<p>Backslash escapes do not work in verbatim contexts.</p>

<h2 id="inline-formatting">Inline formatting</h2>

<h3 id="emphasis">Emphasis</h3>

<p>To <em>emphasize</em> some text, surround it with <code>*</code>s or <code>_</code>, like this:</p>

<pre><code>This text is _emphasized with underscores_, and this
is *emphasized with asterisks*.</code></pre>

<p>Double <code>*</code> or <code>_</code> produces <strong>strong emphasis</strong>:</p>

<pre><code>This is **strong emphasis** and __with underscores__.</code></pre>

<p>A <code>*</code> or <code>_</code> character surrounded by spaces, or backslash-escaped,
will not trigger emphasis:</p>

<pre><code>This is * not emphasized *, and \*neither is this\*.</code></pre>

<h4 id="extension-intraword_underscores">Extension: <code>intraword_underscores</code></h4>

<p>Because <code>_</code> is sometimes used inside words and identifiers,
pandoc does not interpret a <code>_</code> surrounded by alphanumeric
characters as an emphasis marker. If you want to emphasize
just part of a word, use <code>*</code>:</p>

<pre><code>feas*ible*, not feas*able*.</code></pre>

<h3 id="strikeout">Strikeout</h3>

<h4 id="extension-strikeout">Extension: <code>strikeout</code></h4>

<p>To strikeout a section of text with a horizontal line, begin and end it
with <code>~~</code>. Thus, for example,</p>

<pre><code>This ~~is deleted text.~~</code></pre>

<h3 id="superscripts-and-subscripts">Superscripts and subscripts</h3>

<h4 id="extension-superscript-subscript">Extension: <code>superscript</code>, <code>subscript</code></h4>

<p>Superscripts may be written by surrounding the superscripted text by <code>^</code>
characters; subscripts may be written by surrounding the subscripted
text by <code>~</code> characters. Thus, for example,</p>

<pre><code>H~2~O is a liquid.  2^10^ is 1024.</code></pre>

<p>If the superscripted or subscripted text contains spaces, these spaces
must be escaped with backslashes. (This is to prevent accidental
superscripting and subscripting through the ordinary use of <code>~</code> and <code>^</code>.)
Thus, if you want the letter P with &lsquo;a cat&rsquo; in subscripts, use
<code>P~a\ cat~</code>, not <code>P~a cat~</code>.</p>

<h3 id="verbatim">Verbatim</h3>

<p>To make a short span of text verbatim, put it inside backticks:</p>

<pre><code>What is the difference between `&gt;&gt;=` and `&gt;&gt;`?</code></pre>

<p>If the verbatim text includes a backtick, use double backticks:</p>

<pre><code>Here is a literal backtick `` ` ``.</code></pre>

<p>(The spaces after the opening backticks and before the closing
backticks will be ignored.)</p>

<p>The general rule is that a verbatim span starts with a string
of consecutive backticks (optionally followed by a space)
and ends with a string of the same number of backticks (optionally
preceded by a space).</p>

<p>Note that backslash-escapes (and other Markdown constructs) do not
work in verbatim contexts:</p>

<pre><code>This is a backslash followed by an asterisk: `\*`.</code></pre>

<h4 id="extension-inline_code_attributes">Extension: <code>inline_code_attributes</code></h4>

<p>Attributes can be attached to verbatim text, just as with
<a href='#fenced-code-blocks' title=''>fenced code blocks</a>:</p>

<pre><code>`&lt;$&gt;`{.haskell}</code></pre>

<h3 id="small-caps">Small caps</h3>

<p>To write small caps, use the <code>smallcaps</code> class:</p>

<pre><code>[Small caps]{.smallcaps}</code></pre>

<p>Or, without the <code>bracketed_spans</code> extension:</p>

<pre><code>&lt;span class=&quot;smallcaps&quot;&gt;Small caps&lt;/span&gt;</code></pre>

<p>For compatibility with other Markdown flavors, CSS is also supported:</p>

<pre><code>&lt;span style=&quot;font-variant:small-caps;&quot;&gt;Small caps&lt;/span&gt;</code></pre>

<p>This will work in all output formats that support small caps.</p>

<h2 id="math">Math</h2>

<h4 id="extension-tex_math_dollars">Extension: <code>tex_math_dollars</code></h4>

<p>Anything between two <code>$</code> characters will be treated as TeX math. The
opening <code>$</code> must have a non-space character immediately to its right,
while the closing <code>$</code> must have a non-space character immediately to its
left, and must not be followed immediately by a digit. Thus,
<code>$20,000 and $30,000</code> won’t parse as math. If for some reason
you need to enclose text in literal <code>$</code> characters, backslash-escape
them and they won’t be treated as math delimiters.</p>

<p>TeX math will be printed in all output formats. How it is rendered
depends on the output format:</p>

<dl>
<dt>LaTeX</dt>
<dd>It will appear verbatim surrounded by <code>\(...\)</code> (for inline
math) or <code>\[...\]</code> (for display math).</dd>
<dt>Markdown, Emacs Org mode, ConTeXt, ZimWiki</dt>
<dd>It will appear verbatim surrounded by <code>$...$</code> (for inline
math) or <code>$$...$$</code> (for display math).</dd>
<dt>reStructuredText</dt>
<dd>It will be rendered using an <a href='http://docutils.sourceforge.net/docs/ref/rst/roles.html#math' title=''>interpreted text role <code>:math:</code></a>.</dd>
<dt>AsciiDoc</dt>
<dd>For AsciiDoc output format (<code>-t asciidoc</code>) it will appear verbatim
surrounded by <code>latexmath:[$...$]</code> (for inline math) or
<code>[latexmath]++++\[...\]+++</code> (for display math).
For AsciiDoctor output format (<code>-t asciidoctor</code>) the LaTex delimiters
(<code>$..$</code> and <code>\[..\]</code>) are omitted.</dd>
<dt>Texinfo</dt>
<dd>It will be rendered inside a <code>@math</code> command.</dd>
<dt>roff man</dt>
<dd>It will be rendered verbatim without <code>$</code>’s.</dd>
<dt>MediaWiki, DokuWiki</dt>
<dd>It will be rendered inside <code>&lt;math&gt;</code> tags.</dd>
<dt>Textile</dt>
<dd>It will be rendered inside <code>&lt;span class=&quot;math&quot;&gt;</code> tags.</dd>
<dt>RTF, OpenDocument</dt>
<dd>It will be rendered, if possible, using Unicode characters,
and will otherwise appear verbatim.</dd>
<dt>ODT</dt>
<dd>It will be rendered, if possible, using MathML.</dd>
<dt>DocBook</dt>
<dd>If the <code>--mathml</code> flag is used, it will be rendered using MathML
in an <code>inlineequation</code> or <code>informalequation</code> tag. Otherwise it
will be rendered, if possible, using Unicode characters.</dd>
<dt>Docx</dt>
<dd>It will be rendered using OMML math markup.</dd>
<dt>FictionBook2</dt>
<dd>If the <code>--webtex</code> option is used, formulas are rendered as images
using CodeCogs or other compatible web service, downloaded
and embedded in the e-book. Otherwise, they will appear verbatim.</dd>
<dt>HTML, Slidy, DZSlides, S5, EPUB</dt>
<dd>The way math is rendered in HTML will depend on the
command-line options selected. Therefore see <a href='#math-rendering-in-html' title=''>Math rendering in HTML</a>
above.</dd>
</dl>

<h2 id="raw-html">Raw HTML</h2>

<h4 id="extension-raw_html">Extension: <code>raw_html</code></h4>

<p>Markdown allows you to insert raw HTML (or DocBook) anywhere in a document
(except verbatim contexts, where <code>&lt;</code>, <code>&gt;</code>, and <code>&amp;</code> are interpreted
literally). (Technically this is not an extension, since standard
Markdown allows it, but it has been made an extension so that it can
be disabled if desired.)</p>

<p>The raw HTML is passed through unchanged in HTML, S5, Slidy, Slideous,
DZSlides, EPUB, Markdown, CommonMark, Emacs Org mode, and Textile
output, and suppressed in other formats.</p>

<p>For a more explicit way of including raw HTML in a Markdown
document, see the <a href='#extension-raw_attribute' title=''><code>raw_attribute</code> extension</a>.</p>

<p>In the CommonMark format, if <code>raw_html</code> is enabled, superscripts,
subscripts, strikeouts and small capitals will be represented as HTML.
Otherwise, plain-text fallbacks will be used. Note that even if
<code>raw_html</code> is disabled, tables will be rendered with HTML syntax if
they cannot use pipe syntax.</p>

<h4 id="extension-markdown_in_html_blocks">Extension: <code>markdown_in_html_blocks</code></h4>

<p>Standard Markdown allows you to include HTML &ldquo;blocks&rdquo;: blocks
of HTML between balanced tags that are separated from the surrounding text
with blank lines, and start and end at the left margin. Within
these blocks, everything is interpreted as HTML, not Markdown;
so (for example), <code>*</code> does not signify emphasis.</p>

<p>Pandoc behaves this way when the <code>markdown_strict</code> format is used; but
by default, pandoc interprets material between HTML block tags as Markdown.
Thus, for example, pandoc will turn</p>

<pre><code>&lt;table&gt;
&lt;tr&gt;
&lt;td&gt;*one*&lt;/td&gt;
&lt;td&gt;[a link](http://google.com)&lt;/td&gt;
&lt;/tr&gt;
&lt;/table&gt;</code></pre>

<p>into</p>

<pre><code>&lt;table&gt;
&lt;tr&gt;
&lt;td&gt;&lt;em&gt;one&lt;/em&gt;&lt;/td&gt;
&lt;td&gt;&lt;a href=&quot;http://google.com&quot;&gt;a link&lt;/a&gt;&lt;/td&gt;
&lt;/tr&gt;
&lt;/table&gt;</code></pre>

<p>whereas <code>Markdown.pl</code> will preserve it as is.</p>

<p>There is one exception to this rule: text between <code>&lt;script&gt;</code> and
<code>&lt;style&gt;</code> tags is not interpreted as Markdown.</p>

<p>This departure from standard Markdown should make it easier to mix
Markdown with HTML block elements. For example, one can surround
a block of Markdown text with <code>&lt;div&gt;</code> tags without preventing it
from being interpreted as Markdown.</p>

<h4 id="extension-native_divs">Extension: <code>native_divs</code></h4>

<p>Use native pandoc <code>Div</code> blocks for content inside <code>&lt;div&gt;</code> tags.
For the most part this should give the same output as
<code>markdown_in_html_blocks</code>, but it makes it easier to write pandoc
filters to manipulate groups of blocks.</p>

<h4 id="extension-native_spans">Extension: <code>native_spans</code></h4>

<p>Use native pandoc <code>Span</code> blocks for content inside <code>&lt;span&gt;</code> tags.
For the most part this should give the same output as <code>raw_html</code>,
but it makes it easier to write pandoc filters to manipulate groups
of inlines.</p>

<h4 id="extension-raw_tex">Extension: <code>raw_tex</code></h4>

<p>In addition to raw HTML, pandoc allows raw LaTeX, TeX, and ConTeXt to be
included in a document. Inline TeX commands will be preserved and passed
unchanged to the LaTeX and ConTeXt writers. Thus, for example, you can use
LaTeX to include BibTeX citations:</p>

<pre><code>This result was proved in \cite{jones.1967}.</code></pre>

<p>Note that in LaTeX environments, like</p>

<pre><code>\begin{tabular}{|l|l|}\hline
Age &amp; Frequency \\ \hline
18--25  &amp; 15 \\
26--35  &amp; 33 \\
36--45  &amp; 22 \\ \hline
\end{tabular}</code></pre>

<p>the material between the begin and end tags will be interpreted as raw
LaTeX, not as Markdown.</p>

<p>For a more explicit and flexible way of including raw TeX in a
Markdown document, see the <a href='#extension-raw_attribute' title=''><code>raw_attribute</code>
extension</a>.</p>

<p>Inline LaTeX is ignored in output formats other than Markdown, LaTeX,
Emacs Org mode, and ConTeXt.</p>

<h3 id="generic-raw-attribute">Generic raw attribute</h3>

<h4 id="extension-raw_attribute">Extension: <code>raw_attribute</code></h4>

<p>Inline spans and fenced code blocks with a special
kind of attribute will be parsed as raw content with the
designated format. For example, the following produces a raw
roff <code>ms</code> block:</p>

<pre><code>```{=ms}
.MYMACRO
blah blah
```</code></pre>

<p>And the following produces a raw <code>html</code> inline element:</p>

<pre><code>This is `&lt;a&gt;html&lt;/a&gt;`{=html}</code></pre>

<p>This can be useful to insert raw xml into <code>docx</code> documents, e.g.
a pagebreak:</p>

<pre><code>```{=openxml}
&lt;w:p&gt;
  &lt;w:r&gt;
    &lt;w:br w:type=&quot;page&quot;/&gt;
  &lt;/w:r&gt;
&lt;/w:p&gt;
```</code></pre>

<p>The format name should match the target format name (see
<code>-t/--to</code>, above, for a list, or use <code>pandoc --list-output-formats</code>). Use <code>openxml</code> for <code>docx</code> output,
<code>opendocument</code> for <code>odt</code> output, <code>html5</code> for <code>epub3</code> output,
<code>html4</code> for <code>epub2</code> output, and <code>latex</code>, <code>beamer</code>,
<code>ms</code>, or <code>html5</code> for <code>pdf</code> output (depending on what you
use for <code>--pdf-engine</code>).</p>

<p>This extension presupposes that the relevant kind of
inline code or fenced code block is enabled. Thus, for
example, to use a raw attribute with a backtick code block,
<code>backtick_code_blocks</code> must be enabled.</p>

<p>The raw attribute cannot be combined with regular attributes.</p>

<h2 id="latex-macros">LaTeX macros</h2>

<h4 id="extension-latex_macros">Extension: <code>latex_macros</code></h4>

<p>When this extension is enabled, pandoc will parse LaTeX
macro definitions and apply the resulting macros to all LaTeX
math and raw LaTeX. So, for example, the following will work in
all output formats, not just LaTeX:</p>

<pre><code>\newcommand{\tuple}[1]{\langle #1 \rangle}

$\tuple{a, b, c}$</code></pre>

<p>Note that LaTeX macros will not be applied if they occur
inside inside a raw span or block marked with the
<a href='#extension-raw_attribute' title=''><code>raw_attribute</code> extension</a>.</p>

<p>When <code>latex_macros</code> is disabled, the raw LaTeX and math will
not have macros applied. This is usually a better approach when
you are targeting LaTeX or PDF.</p>

<p>Whether or not <code>latex_macros</code> is enabled, the macro definitions
will still be passed through as raw LaTeX.</p>

<h2 id="links-1">Links</h2>

<p>Markdown allows links to be specified in several ways.</p>

<h3 id="automatic-links">Automatic links</h3>

<p>If you enclose a URL or email address in pointy brackets, it
will become a link:</p>

<pre><code>&lt;http://google.com&gt;
&lt;sam@green.eggs.ham&gt;</code></pre>

<h3 id="inline-links">Inline links</h3>

<p>An inline link consists of the link text in square brackets,
followed by the URL in parentheses. (Optionally, the URL can
be followed by a link title, in quotes.)</p>

<pre><code>This is an [inline link](/url), and here&#39;s [one with
a title](http://fsf.org &quot;click here for a good time!&quot;).</code></pre>

<p>There can be no space between the bracketed part and the parenthesized part.
The link text can contain formatting (such as emphasis), but the title cannot.</p>

<p>Email addresses in inline links are not autodetected, so they have to be
prefixed with <code>mailto</code>:</p>

<pre><code>[Write me!](mailto:sam@green.eggs.ham)</code></pre>

<h3 id="reference-links">Reference links</h3>

<p>An <em>explicit</em> reference link has two parts, the link itself and the link
definition, which may occur elsewhere in the document (either
before or after the link).</p>

<p>The link consists of link text in square brackets, followed by a label in
square brackets. (There cannot be space between the two unless the
<code>spaced_reference_links</code> extension is enabled.) The link definition
consists of the bracketed label, followed by a colon and a space, followed by
the URL, and optionally (after a space) a link title either in quotes or in
parentheses. The label must not be parseable as a citation (assuming
the <code>citations</code> extension is enabled): citations take precedence over
link labels.</p>

<p>Here are some examples:</p>

<pre><code>[my label 1]: /foo/bar.html  &quot;My title, optional&quot;
[my label 2]: /foo
[my label 3]: http://fsf.org (The free software foundation)
[my label 4]: /bar#special  &#39;A title in single quotes&#39;</code></pre>

<p>The URL may optionally be surrounded by angle brackets:</p>

<pre><code>[my label 5]: &lt;http://foo.bar.baz&gt;</code></pre>

<p>The title may go on the next line:</p>

<pre><code>[my label 3]: http://fsf.org
  &quot;The free software foundation&quot;</code></pre>

<p>Note that link labels are not case sensitive. So, this will work:</p>

<pre><code>Here is [my link][FOO]

[Foo]: /bar/baz</code></pre>

<p>In an <em>implicit</em> reference link, the second pair of brackets is
empty:</p>

<pre><code>See [my website][].

[my website]: http://foo.bar.baz</code></pre>

<p>Note: In <code>Markdown.pl</code> and most other Markdown implementations,
reference link definitions cannot occur in nested constructions
such as list items or block quotes. Pandoc lifts this arbitrary
seeming restriction. So the following is fine in pandoc, though
not in most other implementations:</p>

<pre><code>&gt; My block [quote].
&gt;
&gt; [quote]: /foo</code></pre>

<h4 id="extension-shortcut_reference_links">Extension: <code>shortcut_reference_links</code></h4>

<p>In a <em>shortcut</em> reference link, the second pair of brackets may
be omitted entirely:</p>

<pre><code>See [my website].

[my website]: http://foo.bar.baz</code></pre>

<h3 id="internal-links">Internal links</h3>

<p>To link to another section of the same document, use the automatically
generated identifier (see <a href='#header-identifiers' title=''>Header identifiers</a>). For example:</p>

<pre><code>See the [Introduction](#introduction).</code></pre>

<p>or</p>

<pre><code>See the [Introduction].

[Introduction]: #introduction</code></pre>

<p>Internal links are currently supported for HTML formats (including
HTML slide shows and EPUB), LaTeX, and ConTeXt.</p>

<h2 id="images">Images</h2>

<p>A link immediately preceded by a <code>!</code> will be treated as an image.
The link text will be used as the image’s alt text:</p>

<pre><code>![la lune](lalune.jpg &quot;Voyage to the moon&quot;)

![movie reel]

[movie reel]: movie.gif</code></pre>

<h4 id="extension-implicit_figures">Extension: <code>implicit_figures</code></h4>

<p>An image with nonempty alt text, occurring by itself in a
paragraph, will be rendered as a figure with a caption. The
image’s alt text will be used as the caption.</p>

<pre><code>![This is the caption](/url/of/image.png)</code></pre>

<p>How this is rendered depends on the output format. Some output
formats (e.g. RTF) do not yet support figures. In those
formats, you’ll just get an image in a paragraph by itself, with
no caption.</p>

<p>If you just want a regular inline image, just make sure it is not
the only thing in the paragraph. One way to do this is to insert a
nonbreaking space after the image:</p>

<pre><code>![This image won&#39;t be a figure](/url/of/image.png)\</code></pre>

<p>Note that in reveal.js slide shows, an image in a paragraph
by itself that has the <code>stretch</code> class will fill the screen,
and the caption and figure tags will be omitted.</p>

<h4 id="extension-link_attributes">Extension: <code>link_attributes</code></h4>

<p>Attributes can be set on links and images:</p>

<pre><code>An inline ![image](foo.jpg){#id .class width=30 height=20px}
and a reference ![image][ref] with attributes.

[ref]: foo.jpg &quot;optional title&quot; {#id .class key=val key2=&quot;val 2&quot;}</code></pre>

<p>(This syntax is compatible with <a href='https://michelf.ca/projects/php-markdown/extra/' title=''>PHP Markdown Extra</a> when only <code>#id</code>
and <code>.class</code> are used.)</p>

<p>For HTML and EPUB, all attributes except <code>width</code> and <code>height</code> (but
including <code>srcset</code> and <code>sizes</code>) are passed through as is. The other
writers ignore attributes that are not supported by their output
format.</p>

<p>The <code>width</code> and <code>height</code> attributes on images are treated specially. When
used without a unit, the unit is assumed to be pixels. However, any of
the following unit identifiers can be used: <code>px</code>, <code>cm</code>, <code>mm</code>, <code>in</code>, <code>inch</code>
and <code>%</code>. There must not be any spaces between the number and the unit.
For example:</p>

<pre><code>![](file.jpg){ width=50% }</code></pre>

<ul>
<li>Dimensions are converted to inches for output in page-based formats like
LaTeX. Dimensions are converted to pixels for output in HTML-like
formats. Use the <code>--dpi</code> option to specify the number of pixels per
inch. The default is 96dpi.</li>
<li>The <code>%</code> unit is generally relative to some available space.
For example the above example will render to the following.

<ul>
<li>HTML: <code>&lt;img href=&quot;file.jpg&quot; style=&quot;width: 50%;&quot; /&gt;</code></li>
<li>LaTeX: <code>\includegraphics[width=0.5\textwidth,height=\textheight]{file.jpg}</code>
(If you’re using a custom template, you need to configure <code>graphicx</code>
as in the default template.)</li>
<li>ConTeXt: <code>\externalfigure[file.jpg][width=0.5\textwidth]</code></li>
</ul></li>
<li>Some output formats have a notion of a class
(<a href='http://wiki.contextgarden.net/Using_Graphics#Multiple_Image_Settings' title=''>ConTeXt</a>)
or a unique identifier (LaTeX <code>\caption</code>), or both (HTML).</li>
<li>When no <code>width</code> or <code>height</code> attributes are specified, the fallback
is to look at the image resolution and the dpi metadata embedded in
the image file.</li>
</ul>

<h2 id="divs-and-spans">Divs and Spans</h2>

<p>Using the <code>native_divs</code> and <code>native_spans</code> extensions
(see <a href='#extension-native_divs' title=''>above</a>), HTML syntax can
be used as part of markdown to create native <code>Div</code> and <code>Span</code>
elements in the pandoc AST (as opposed to raw HTML).
However, there is also nicer syntax available:</p>

<h4 id="extension-fenced_divs">Extension: <code>fenced_divs</code></h4>

<p>Allow special fenced syntax for native <code>Div</code> blocks. A Div
starts with a fence containing at least three consecutive
colons plus some attributes. The attributes may optionally
be followed by another string of consecutive colons.
The attribute syntax is exactly as in fenced code blocks (see
<a href='#extension-fenced_code_attributes' title=''>Extension: <code>fenced_code_attributes</code></a>). As with fenced
code blocks, one can use either attributes in curly braces
or a single unbraced word, which will be treated as a class
name. The Div ends with another line containing a string of at
least three consecutive colons. The fenced Div should be
separated by blank lines from preceding and following blocks.</p>

<p>Example:</p>

<pre><code>::::: {#special .sidebar}
Here is a paragraph.

And another.
:::::</code></pre>

<p>Fenced divs can be nested. Opening fences are distinguished
because they <em>must</em> have attributes:</p>

<pre><code>::: Warning ::::::
This is a warning.

::: Danger
This is a warning within a warning.
:::
::::::::::::::::::</code></pre>

<p>Fences without attributes are always closing fences. Unlike
with fenced code blocks, the number of colons in the closing
fence need not match the number in the opening fence. However,
it can be helpful for visual clarity to use fences of different
lengths to distinguish nested divs from their parents.</p>

<h4 id="extension-bracketed_spans">Extension: <code>bracketed_spans</code></h4>

<p>A bracketed sequence of inlines, as one would use to begin
a link, will be treated as a <code>Span</code> with attributes if it is
followed immediately by attributes:</p>

<pre><code>[This is *some text*]{.class key=&quot;val&quot;}</code></pre>

<h2 id="footnotes">Footnotes</h2>

<h4 id="extension-footnotes">Extension: <code>footnotes</code></h4>

<p>Pandoc’s Markdown allows footnotes, using the following syntax:</p>

<pre><code>Here is a footnote reference,[^1] and another.[^longnote]

[^1]: Here is the footnote.

[^longnote]: Here&#39;s one with multiple blocks.

    Subsequent paragraphs are indented to show that they
belong to the previous footnote.

        { some.code }

    The whole paragraph can be indented, or just the first
    line.  In this way, multi-paragraph footnotes work like
    multi-paragraph list items.

This paragraph won&#39;t be part of the note, because it
isn&#39;t indented.</code></pre>

<p>The identifiers in footnote references may not contain spaces, tabs,
or newlines. These identifiers are used only to correlate the
footnote reference with the note itself; in the output, footnotes
will be numbered sequentially.</p>

<p>The footnotes themselves need not be placed at the end of the
document. They may appear anywhere except inside other block elements
(lists, block quotes, tables, etc.). Each footnote should be
separated from surrounding content (including other footnotes)
by blank lines.</p>

<h4 id="extension-inline_notes">Extension: <code>inline_notes</code></h4>

<p>Inline footnotes are also allowed (though, unlike regular notes,
they cannot contain multiple paragraphs). The syntax is as follows:</p>

<pre><code>Here is an inline note.^[Inlines notes are easier to write, since
you don&#39;t have to pick an identifier and move down to type the
note.]</code></pre>

<p>Inline and regular footnotes may be mixed freely.</p>

<h2 id="citations">Citations</h2>

<h4 id="extension-citations">Extension: <code>citations</code></h4>

<p>Using an external filter, <code>pandoc-citeproc</code>, pandoc can automatically generate
citations and a bibliography in a number of styles. Basic usage is</p>

<pre><code>pandoc --filter pandoc-citeproc myinput.txt</code></pre>

<p>In order to use this feature, you will need to specify a bibliography file
using the <code>bibliography</code> metadata field in a YAML metadata section, or
<code>--bibliography</code> command line argument. You can supply multiple <code>--bibliography</code>
arguments or set <code>bibliography</code> metadata field to YAML array, if you want to
use multiple bibliography files. The bibliography may have any of these
formats:</p>

<table>
<tr class="header">
<th align="left">Format</th>
<th align="left">File extension</th>
</tr>
<tr class="odd">
<td align="left">BibLaTeX</td>
<td align="left">.bib</td>
</tr>
<tr class="even">
<td align="left">BibTeX</td>
<td align="left">.bibtex</td>
</tr>
<tr class="odd">
<td align="left">Copac</td>
<td align="left">.copac</td>
</tr>
<tr class="even">
<td align="left">CSL JSON</td>
<td align="left">.json</td>
</tr>
<tr class="odd">
<td align="left">CSL YAML</td>
<td align="left">.yaml</td>
</tr>
<tr class="even">
<td align="left">EndNote</td>
<td align="left">.enl</td>
</tr>
<tr class="odd">
<td align="left">EndNote XML</td>
<td align="left">.xml</td>
</tr>
<tr class="even">
<td align="left">ISI</td>
<td align="left">.wos</td>
</tr>
<tr class="odd">
<td align="left">MEDLINE</td>
<td align="left">.medline</td>
</tr>
<tr class="even">
<td align="left">MODS</td>
<td align="left">.mods</td>
</tr>
<tr class="odd">
<td align="left">RIS</td>
<td align="left">.ris</td>
</tr>
</table>

<p>Note that <code>.bib</code> can be used with both BibTeX and BibLaTeX files;
use <code>.bibtex</code> to force BibTeX.</p>

<p>Note that <code>pandoc-citeproc --bib2json</code> and <code>pandoc-citeproc --bib2yaml</code>
can produce <code>.json</code> and <code>.yaml</code> files from any of the supported formats.</p>

<p>In-field markup: In BibTeX and BibLaTeX databases,
pandoc-citeproc parses a subset of LaTeX markup; in CSL YAML
databases, pandoc Markdown; and in CSL JSON databases, an
<a href='http://docs.citationstyles.org/en/1.0/release-notes.html#rich-text-markup-within-fields' title=''>HTML-like markup</a>:</p>

<dl>
<dt><code>&lt;i&gt;...&lt;/i&gt;</code></dt>
<dd>italics</dd>
<dt><code>&lt;b&gt;...&lt;/b&gt;</code></dt>
<dd>bold</dd>
<dt><code>&lt;span style=&quot;font-variant:small-caps;&quot;&gt;...&lt;/span&gt;</code> or <code>&lt;sc&gt;...&lt;/sc&gt;</code></dt>
<dd>small capitals</dd>
<dt><code>&lt;sub&gt;...&lt;/sub&gt;</code></dt>
<dd>subscript</dd>
<dt><code>&lt;sup&gt;...&lt;/sup&gt;</code></dt>
<dd>superscript</dd>
<dt><code>&lt;span class=&quot;nocase&quot;&gt;...&lt;/span&gt;</code></dt>
<dd>prevent a phrase from being capitalized as title case</dd>
</dl>

<p><code>pandoc-citeproc -j</code> and <code>-y</code> interconvert the CSL JSON
and CSL YAML formats as far as possible.</p>

<p>As an alternative to specifying a bibliography file using <code>--bibliography</code>
or the YAML metadata field <code>bibliography</code>, you can include
the citation data directly in the <code>references</code> field of the
document’s YAML metadata. The field should contain an array of
YAML-encoded references, for example:</p>

<pre><code>---
references:
- type: article-journal
  id: WatsonCrick1953
  author:
  - family: Watson
    given: J. D.
  - family: Crick
    given: F. H. C.
  issued:
    date-parts:
    - - 1953
      - 4
      - 25
  title: &#39;Molecular structure of nucleic acids: a structure for deoxyribose
    nucleic acid&#39;
  title-short: Molecular structure of nucleic acids
  container-title: Nature
  volume: 171
  issue: 4356
  page: 737-738
  DOI: 10.1038/171737a0
  URL: http://www.nature.com/nature/journal/v171/n4356/abs/171737a0.html
  language: en-GB
...</code></pre>

<p>(<code>pandoc-citeproc --bib2yaml</code> can produce these from a bibliography file in one
of the supported formats.)</p>

<p>Citations and references can be formatted using any style supported by the
<a href='http://citationstyles.org' title=''>Citation Style Language</a>, listed in the <a href='https://www.zotero.org/styles' title=''>Zotero Style Repository</a>.
These files are specified using the <code>--csl</code> option or the <code>csl</code> metadata field.
By default, <code>pandoc-citeproc</code> will use the <a href='http://chicagomanualofstyle.org' title=''>Chicago Manual of Style</a> author-date
format. The CSL project provides further information on <a href='https://citationstyles.org/authors/' title=''>finding and editing styles</a>.</p>

<p>To make your citations hyperlinks to the corresponding bibliography
entries, add <code>link-citations: true</code> to your YAML metadata.</p>

<p>Citations go inside square brackets and are separated by semicolons.
Each citation must have a key, composed of &lsquo;@&rsquo; + the citation
identifier from the database, and may optionally have a prefix,
a locator, and a suffix. The citation key must begin with a letter, digit,
or <code>_</code>, and may contain alphanumerics, <code>_</code>, and internal punctuation
characters (<code>:.#$%&amp;-+?&lt;&gt;~/</code>). Here are some examples:</p>

<pre><code>Blah blah [see @doe99, pp. 33-35; also @smith04, chap. 1].

Blah blah [@doe99, pp. 33-35, 38-39 and *passim*].

Blah blah [@smith04; @doe99].</code></pre>

<p><code>pandoc-citeproc</code> detects locator terms in the <a href='https://github.com/citation-style-language/locales' title=''>CSL locale files</a>.
Either abbreviated or unabbreviated forms are accepted. In the <code>en-US</code>
locale, locator terms can be written in either singular or plural forms,
as <code>book</code>, <code>bk.</code>/<code>bks.</code>; <code>chapter</code>, <code>chap.</code>/<code>chaps.</code>; <code>column</code>,
<code>col.</code>/<code>cols.</code>; <code>figure</code>, <code>fig.</code>/<code>figs.</code>; <code>folio</code>, <code>fol.</code>/<code>fols.</code>;
<code>number</code>, <code>no.</code>/<code>nos.</code>; <code>line</code>, <code>l.</code>/<code>ll.</code>; <code>note</code>, <code>n.</code>/<code>nn.</code>; <code>opus</code>,
<code>op.</code>/<code>opp.</code>; <code>page</code>, <code>p.</code>/<code>pp.</code>; <code>paragraph</code>, <code>para.</code>/<code>paras.</code>; <code>part</code>,
<code>pt.</code>/<code>pts.</code>; <code>section</code>, <code>sec.</code>/<code>secs.</code>; <code>sub verbo</code>, <code>s.v.</code>/<code>s.vv.</code>;
<code>verse</code>, <code>v.</code>/<code>vv.</code>; <code>volume</code>, <code>vol.</code>/<code>vols.</code>; <code>¶</code>/<code>¶¶</code>; <code>§</code>/<code>§§</code>. If no
locator term is used, &ldquo;page&rdquo; is assumed.</p>

<p><code>pandoc-citeproc</code> will use heuristics to distinguish the locator
from the suffix. In complex cases, the locator can be enclosed
in curly braces (using <code>pandoc-citeproc</code> 0.15 and higher only):</p>

<pre><code>[@smith{ii, A, D-Z}, with a suffix]
[@smith, {pp. iv, vi-xi, (xv)-(xvii)} with suffix here]</code></pre>

<p>A minus sign (<code>-</code>) before the <code>@</code> will suppress mention of
the author in the citation. This can be useful when the
author is already mentioned in the text:</p>

<pre><code>Smith says blah [-@smith04].</code></pre>

<p>You can also write an in-text citation, as follows:</p>

<pre><code>@smith04 says blah.

@smith04 [p. 33] says blah.</code></pre>

<p>If the style calls for a list of works cited, it will be placed
in a div with id <code>refs</code>, if one exists:</p>

<pre><code>::: {#refs}
:::</code></pre>

<p>Otherwise, it will be placed at the end of the document.
Generation of the bibliography can be suppressed by setting
<code>suppress-bibliography: true</code> in the YAML metadata.</p>

<p>If you wish the bibliography to have a section header, you can
set <code>reference-section-title</code> in the metadata, or put the header
at the beginning of the div with id <code>refs</code> (if you are using it)
or at the end of your document:</p>

<pre><code>last paragraph...

# References</code></pre>

<p>The bibliography will be inserted after this header. Note that
the <code>unnumbered</code> class will be added to this header, so that the
section will not be numbered.</p>

<p>If you want to include items in the bibliography without actually
citing them in the body text, you can define a dummy <code>nocite</code> metadata
field and put the citations there:</p>

<pre><code>---
nocite: |
  @item1, @item2
...

@item3</code></pre>

<p>In this example, the document will contain a citation for <code>item3</code>
only, but the bibliography will contain entries for <code>item1</code>, <code>item2</code>, and
<code>item3</code>.</p>

<p>It is possible to create a bibliography with all the citations,
whether or not they appear in the document, by using a wildcard:</p>

<pre><code>---
nocite: |
  @*
...</code></pre>

<p>For LaTeX output, you can also use <a href='https://ctan.org/pkg/natbib' title=''><code>natbib</code></a> or <a href='https://ctan.org/pkg/biblatex' title=''><code>biblatex</code></a> to
render the bibliography. In order to do so, specify bibliography
files as outlined above, and add <code>--natbib</code> or <code>--biblatex</code>
argument to <code>pandoc</code> invocation. Bear in mind that bibliography
files have to be in respective format (either BibTeX or
BibLaTeX).</p>

<p>For more information, see the <a href='https://github.com/jgm/pandoc-citeproc/blob/master/man/pandoc-citeproc.1.md' title=''>pandoc-citeproc man page</a>.</p>

<h2 id="non-pandoc-extensions">Non-pandoc extensions</h2>

<p>The following Markdown syntax extensions are not enabled by default
in pandoc, but may be enabled by adding <code>+EXTENSION</code> to the format
name, where <code>EXTENSION</code> is the name of the extension. Thus, for
example, <code>markdown+hard_line_breaks</code> is Markdown with hard line breaks.</p>

<h4 id="extension-old_dashes">Extension: <code>old_dashes</code></h4>

<p>Selects the pandoc &lt;= 1.8.2.1 behavior for parsing smart dashes:
<code>-</code> before a numeral is an en-dash, and <code>--</code> is an em-dash.
This option only has an effect if <code>smart</code> is enabled. It is
selected automatically for <code>textile</code> input.</p>

<h4 id="extension-angle_brackets_escapable">Extension: <code>angle_brackets_escapable</code></h4>

<p>Allow <code>&lt;</code> and <code>&gt;</code> to be backslash-escaped, as they can be in
GitHub flavored Markdown but not original Markdown. This is
implied by pandoc’s default <code>all_symbols_escapable</code>.</p>

<h4 id="extension-lists_without_preceding_blankline">Extension: <code>lists_without_preceding_blankline</code></h4>

<p>Allow a list to occur right after a paragraph, with no intervening
blank space.</p>

<h4 id="extension-four_space_rule">Extension: <code>four_space_rule</code></h4>

<p>Selects the pandoc &lt;= 2.0 behavior for parsing lists, so that
four spaces indent are needed for list item continuation
paragraphs.</p>

<h4 id="extension-spaced_reference_links">Extension: <code>spaced_reference_links</code></h4>

<p>Allow whitespace between the two components of a reference link,
for example,</p>

<pre><code>[foo] [bar].</code></pre>

<h4 id="extension-hard_line_breaks">Extension: <code>hard_line_breaks</code></h4>

<p>Causes all newlines within a paragraph to be interpreted as hard line
breaks instead of spaces.</p>

<h4 id="extension-ignore_line_breaks">Extension: <code>ignore_line_breaks</code></h4>

<p>Causes newlines within a paragraph to be ignored, rather than being
treated as spaces or as hard line breaks. This option is intended for
use with East Asian languages where spaces are not used between words,
but text is divided into lines for readability.</p>

<h4 id="extension-east_asian_line_breaks">Extension: <code>east_asian_line_breaks</code></h4>

<p>Causes newlines within a paragraph to be ignored, rather than
being treated as spaces or as hard line breaks, when they occur
between two East Asian wide characters. This is a better choice
than <code>ignore_line_breaks</code> for texts that include a mix of East
Asian wide characters and other characters.</p>

<h4 id="extension-emoji">Extension: <code>emoji</code></h4>

<p>Parses textual emojis like <code>:smile:</code> as Unicode emoticons.</p>

<h4 id="extension-tex_math_single_backslash">Extension: <code>tex_math_single_backslash</code></h4>

<p>Causes anything between <code>\(</code> and <code>\)</code> to be interpreted as inline
TeX math, and anything between <code>\[</code> and <code>\]</code> to be interpreted
as display TeX math. Note: a drawback of this extension is that
it precludes escaping <code>(</code> and <code>[</code>.</p>

<h4 id="extension-tex_math_double_backslash">Extension: <code>tex_math_double_backslash</code></h4>

<p>Causes anything between <code>\\(</code> and <code>\\)</code> to be interpreted as inline
TeX math, and anything between <code>\\[</code> and <code>\\]</code> to be interpreted
as display TeX math.</p>

<h4 id="extension-markdown_attribute">Extension: <code>markdown_attribute</code></h4>

<p>By default, pandoc interprets material inside block-level tags as Markdown.
This extension changes the behavior so that Markdown is only parsed
inside block-level tags if the tags have the attribute <code>markdown=1</code>.</p>

<h4 id="extension-mmd_title_block">Extension: <code>mmd_title_block</code></h4>

<p>Enables a <a href='http://fletcherpenney.net/multimarkdown/' title=''>MultiMarkdown</a> style title block at the top of
the document, for example:</p>

<pre><code>Title:   My title
Author:  John Doe
Date:    September 1, 2008
Comment: This is a sample mmd title block, with
         a field spanning multiple lines.</code></pre>

<p>See the MultiMarkdown documentation for details. If <code>pandoc_title_block</code> or
<code>yaml_metadata_block</code> is enabled, it will take precedence over
<code>mmd_title_block</code>.</p>

<h4 id="extension-abbreviations">Extension: <code>abbreviations</code></h4>

<p>Parses PHP Markdown Extra abbreviation keys, like</p>

<pre><code>*[HTML]: Hypertext Markup Language</code></pre>

<p>Note that the pandoc document model does not support
abbreviations, so if this extension is enabled, abbreviation keys are
simply skipped (as opposed to being parsed as paragraphs).</p>

<h4 id="extension-autolink_bare_uris">Extension: <code>autolink_bare_uris</code></h4>

<p>Makes all absolute URIs into links, even when not surrounded by
pointy braces <code>&lt;...&gt;</code>.</p>

<h4 id="extension-mmd_link_attributes">Extension: <code>mmd_link_attributes</code></h4>

<p>Parses multimarkdown style key-value attributes on link
and image references. This extension should not be confused with the
<a href='#extension-link_attributes' title=''><code>link_attributes</code></a> extension.</p>

<pre><code>This is a reference ![image][ref] with multimarkdown attributes.

[ref]: http://path.to/image &quot;Image title&quot; width=20px height=30px
       id=myId class=&quot;myClass1 myClass2&quot;</code></pre>

<h4 id="extension-mmd_header_identifiers">Extension: <code>mmd_header_identifiers</code></h4>

<p>Parses multimarkdown style header identifiers (in square brackets,
after the header but before any trailing <code>#</code>s in an ATX header).</p>

<h4 id="extension-compact_definition_lists">Extension: <code>compact_definition_lists</code></h4>

<p>Activates the definition list syntax of pandoc 1.12.x and earlier.
This syntax differs from the one described above under <a href='#definition-lists' title=''>Definition lists</a>
in several respects:</p>

<ul>
<li>No blank line is required between consecutive items of the
definition list.</li>
<li>To get a &ldquo;tight&rdquo; or &ldquo;compact&rdquo; list, omit space between consecutive
items; the space between a term and its definition does not affect
anything.</li>
<li>Lazy wrapping of paragraphs is not allowed: the entire definition must
be indented four spaces.<a id="fnref4" href="#fn4"><sup>4</sup></a></li>
</ul>

<h2 id="markdown-variants">Markdown variants</h2>

<p>In addition to pandoc’s extended Markdown, the following Markdown
variants are supported:</p>

<dl>
<dt><code>markdown_phpextra</code> (PHP Markdown Extra)</dt>
<dd><code>footnotes</code>, <code>pipe_tables</code>, <code>raw_html</code>, <code>markdown_attribute</code>,
<code>fenced_code_blocks</code>, <code>definition_lists</code>, <code>intraword_underscores</code>,
<code>header_attributes</code>, <code>link_attributes</code>, <code>abbreviations</code>,
<code>shortcut_reference_links</code>, <code>spaced_reference_links</code>.</dd>
<dt><code>markdown_github</code> (deprecated GitHub-Flavored Markdown)</dt>
<dd><code>pipe_tables</code>, <code>raw_html</code>, <code>fenced_code_blocks</code>, <code>auto_identifiers</code>,
<code>gfm_auto_identifiers</code>, <code>backtick_code_blocks</code>,
<code>autolink_bare_uris</code>, <code>space_in_atx_header</code>,
<code>intraword_underscores</code>, <code>strikeout</code>, <code>task_lists</code>, <code>emoji</code>,
<code>shortcut_reference_links</code>, <code>angle_brackets_escapable</code>,
<code>lists_without_preceding_blankline</code>.</dd>
<dt><code>markdown_mmd</code> (MultiMarkdown)</dt>
<dd><code>pipe_tables</code>, <code>raw_html</code>, <code>markdown_attribute</code>, <code>mmd_link_attributes</code>,
<code>tex_math_double_backslash</code>, <code>intraword_underscores</code>,
<code>mmd_title_block</code>, <code>footnotes</code>, <code>definition_lists</code>,
<code>all_symbols_escapable</code>, <code>implicit_header_references</code>,
<code>auto_identifiers</code>, <code>mmd_header_identifiers</code>,
<code>shortcut_reference_links</code>, <code>implicit_figures</code>,
<code>superscript</code>, <code>subscript</code>, <code>backtick_code_blocks</code>,
<code>spaced_reference_links</code>, <code>raw_attribute</code>.</dd>
<dt><code>markdown_strict</code> (Markdown.pl)</dt>
<dd><code>raw_html</code>, <code>shortcut_reference_links</code>,
<code>spaced_reference_links</code>.</dd>
</dl>

<p>We also support <code>commonmark</code> and <code>gfm</code> (GitHub-Flavored Markdown,
which is implemented as a set of extensions on <code>commonmark</code>).</p>

<p>Note, however, that <code>commonmark</code> and <code>gfm</code> have limited support
for extensions. Only those listed below (and <code>smart</code>,
<code>raw_tex</code>, and <code>hard_line_breaks</code>) will work. The extensions
can, however, all be individually disabled. Also, <code>raw_tex</code>
only affects <code>gfm</code> output, not input.</p>

<dl>
<dt><code>gfm</code> (GitHub-Flavored Markdown)</dt>
<dd><code>pipe_tables</code>, <code>raw_html</code>, <code>fenced_code_blocks</code>, <code>auto_identifiers</code>,
<code>gfm_auto_identifiers</code>, <code>backtick_code_blocks</code>,
<code>autolink_bare_uris</code>, <code>space_in_atx_header</code>,
<code>intraword_underscores</code>, <code>strikeout</code>, <code>task_lists</code>, <code>emoji</code>,
<code>shortcut_reference_links</code>, <code>angle_brackets_escapable</code>,
<code>lists_without_preceding_blankline</code>.</dd>
</dl>

<h1 id="producing-slide-shows-with-pandoc">Producing slide shows with pandoc</h1>

<p>You can use pandoc to produce an HTML + JavaScript slide presentation
that can be viewed via a web browser. There are five ways to do this,
using <a href='http://meyerweb.com/eric/tools/s5/' title=''>S5</a>, <a href='http://paulrouget.com/dzslides/' title=''>DZSlides</a>, <a href='http://www.w3.org/Talks/Tools/Slidy/' title=''>Slidy</a>, <a href='http://goessner.net/articles/slideous/' title=''>Slideous</a>, or <a href='http://lab.hakim.se/reveal-js/' title=''>reveal.js</a>.
You can also produce a PDF slide show using LaTeX <a href='https://ctan.org/pkg/beamer' title=''><code>beamer</code></a>, or
slides shows in Microsoft <a href='https://en.wikipedia.org/wiki/Microsoft_PowerPoint' title=''>PowerPoint</a> format.</p>

<p>Here’s the Markdown source for a simple slide show, <code>habits.txt</code>:</p>

<pre><code>% Habits
% John Doe
% March 22, 2005

# In the morning

## Getting up

- Turn off alarm
- Get out of bed

## Breakfast

- Eat eggs
- Drink coffee

# In the evening

## Dinner

- Eat spaghetti
- Drink wine

------------------

![picture of spaghetti](images/spaghetti.jpg)

## Going to sleep

- Get in bed
- Count sheep</code></pre>

<p>To produce an HTML/JavaScript slide show, simply type</p>

<pre><code>pandoc -t FORMAT -s habits.txt -o habits.html</code></pre>

<p>where <code>FORMAT</code> is either <code>s5</code>, <code>slidy</code>, <code>slideous</code>, <code>dzslides</code>, or <code>revealjs</code>.</p>

<p>For Slidy, Slideous, reveal.js, and S5, the file produced by pandoc with the
<code>-s/--standalone</code> option embeds a link to JavaScript and CSS files, which are
assumed to be available at the relative path <code>s5/default</code> (for S5), <code>slideous</code>
(for Slideous), <code>reveal.js</code> (for reveal.js), or at the Slidy website at
<code>w3.org</code> (for Slidy). (These paths can be changed by setting the <code>slidy-url</code>,
<code>slideous-url</code>, <code>revealjs-url</code>, or <code>s5-url</code> variables; see <a href='#variables-for-html-slides' title=''>Variables for HTML slides</a>,
above.) For DZSlides, the (relatively short) JavaScript and CSS are included in
the file by default.</p>

<p>With all HTML slide formats, the <code>--self-contained</code> option can be used to
produce a single file that contains all of the data necessary to display the
slide show, including linked scripts, stylesheets, images, and videos.</p>

<p>To produce a PDF slide show using beamer, type</p>

<pre><code>pandoc -t beamer habits.txt -o habits.pdf</code></pre>

<p>Note that a reveal.js slide show can also be converted to a PDF
by printing it to a file from the browser.</p>

<p>To produce a Powerpoint slide show, type</p>

<pre><code>pandoc habits.txt -o habits.pptx</code></pre>

<h2 id="structuring-the-slide-show">Structuring the slide show</h2>

<p>By default, the <em>slide level</em> is the highest header level in
the hierarchy that is followed immediately by content, and not another
header, somewhere in the document. In the example above, level 1 headers
are always followed by level 2 headers, which are followed by content,
so 2 is the slide level. This default can be overridden using
the <code>--slide-level</code> option.</p>

<p>The document is carved up into slides according to the following
rules:</p>

<ul>
<li><p>A horizontal rule always starts a new slide.</p></li>
<li><p>A header at the slide level always starts a new slide.</p></li>
<li><p>Headers <em>below</em> the slide level in the hierarchy create
headers <em>within</em> a slide.</p></li>
<li><p>Headers <em>above</em> the slide level in the hierarchy create
&ldquo;title slides,&rdquo; which just contain the section title
and help to break the slide show into sections.
Non-slide content under these headers will be included
on the title slide (for HTML slide shows) or in a
subsequent slide with the same title (for beamer).</p></li>
<li><p>A title page is constructed automatically from the document’s title
block, if present. (In the case of beamer, this can be disabled
by commenting out some lines in the default template.)</p></li>
</ul>

<p>These rules are designed to support many different styles of slide show. If
you don’t care about structuring your slides into sections and subsections,
you can just use level 1 headers for all each slide. (In that case, level 1
will be the slide level.) But you can also structure the slide show into
sections, as in the example above.</p>

<p>Note: in reveal.js slide shows, if slide level is 2, a two-dimensional
layout will be produced, with level 1 headers building horizontally
and level 2 headers building vertically. It is not recommended that
you use deeper nesting of section levels with reveal.js.</p>

<h2 id="incremental-lists">Incremental lists</h2>

<p>By default, these writers produce lists that display &ldquo;all at once.&rdquo;
If you want your lists to display incrementally (one item at a time),
use the <code>-i</code> option. If you want a particular list to depart from the
default, put it in a <code>div</code> block with class <code>incremental</code> or
<code>nonincremental</code>. So, for example, using the <code>fenced div</code> syntax, the
following would be incremental regardless of the document default:</p>

<pre><code>::: incremental

- Eat spaghetti
- Drink wine

:::</code></pre>

<p>or</p>

<pre><code>::: nonincremental

- Eat spaghetti
- Drink wine

:::</code></pre>

<p>While using <code>incremental</code> and <code>nonincremental</code> divs are the
recommended method of setting incremental lists on a per-case basis,
an older method is also supported: putting lists inside a blockquote
will depart from the document default (that is, it will display
incrementally without the <code>-i</code> option and all at once with the <code>-i</code>
option):</p>

<pre><code>&gt; - Eat spaghetti
&gt; - Drink wine</code></pre>

<p>Both methods allow incremental and nonincremental lists to be mixed
in a single document.</p>

<h2 id="inserting-pauses">Inserting pauses</h2>

<p>You can add &ldquo;pauses&rdquo; within a slide by including a paragraph containing
three dots, separated by spaces:</p>

<pre><code># Slide with a pause

content before the pause

. . .

content after the pause</code></pre>

<h2 id="styling-the-slides">Styling the slides</h2>

<p>You can change the style of HTML slides by putting customized CSS files
in <code>$DATADIR/s5/default</code> (for S5), <code>$DATADIR/slidy</code> (for Slidy),
or <code>$DATADIR/slideous</code> (for Slideous),
where <code>$DATADIR</code> is the user data directory (see <code>--data-dir</code>, above).
The originals may be found in pandoc’s system data directory (generally
<code>$CABALDIR/pandoc-VERSION/s5/default</code>). Pandoc will look there for any
files it does not find in the user data directory.</p>

<p>For dzslides, the CSS is included in the HTML file itself, and may
be modified there.</p>

<p>All <a href='https://github.com/hakimel/reveal.js#configuration' title=''>reveal.js configuration options</a> can be set through variables.
For example, themes can be used by setting the <code>theme</code> variable:</p>

<pre><code>-V theme=moon</code></pre>

<p>Or you can specify a custom stylesheet using the <code>--css</code> option.</p>

<p>To style beamer slides, you can specify a <code>theme</code>, <code>colortheme</code>,
<code>fonttheme</code>, <code>innertheme</code>, and <code>outertheme</code>, using the <code>-V</code> option:</p>

<pre><code>pandoc -t beamer habits.txt -V theme:Warsaw -o habits.pdf</code></pre>

<p>Note that header attributes will turn into slide attributes
(on a <code>&lt;div&gt;</code> or <code>&lt;section&gt;</code>) in HTML slide formats, allowing you
to style individual slides. In beamer, the only header attribute
that affects slides is the <code>allowframebreaks</code> class, which sets the
<code>allowframebreaks</code> option, causing multiple slides to be created
if the content overfills the frame. This is recommended especially for
bibliographies:</p>

<pre><code># References {.allowframebreaks}</code></pre>

<h2 id="speaker-notes">Speaker notes</h2>

<p>Speaker notes are supported in reveal.js and PowerPoint (pptx)
output. You can add notes to your Markdown document thus:</p>

<pre><code>::: notes

This is my note.

- It can contain Markdown
- like this list

:::</code></pre>

<p>To show the notes window in reveal.js, press <code>s</code> while viewing the
presentation. Speaker notes in PowerPoint will be available, as usual,
in handouts and presenter view.</p>

<p>Notes are not yet supported for other slide formats, but the notes
will not appear on the slides themselves.</p>

<h2 id="columns">Columns</h2>

<p>To put material in side by side columns, you can use a native
div container with class <code>columns</code>, containing two or more div
containers with class <code>column</code> and a <code>width</code> attribute:</p>

<pre><code>:::::::::::::: {.columns}
::: {.column width=&quot;40%&quot;}
contents...
:::
::: {.column width=&quot;60%&quot;}
contents...
:::
::::::::::::::</code></pre>

<h2 id="frame-attributes-in-beamer">Frame attributes in beamer</h2>

<p>Sometimes it is necessary to add the LaTeX <code>[fragile]</code> option to
a frame in beamer (for example, when using the <code>minted</code> environment).
This can be forced by adding the <code>fragile</code> class to the header
introducing the slide:</p>

<pre><code># Fragile slide {.fragile}</code></pre>

<p>All of the other frame attributes described in Section 8.1 of
the <a href='http://ctan.math.utah.edu/ctan/tex-archive/macros/latex/contrib/beamer/doc/beameruserguide.pdf' title=''>Beamer User’s Guide</a> may also be used: <code>allowdisplaybreaks</code>,
<code>allowframebreaks</code>, <code>b</code>, <code>c</code>, <code>t</code>, <code>environment</code>, <code>label</code>, <code>plain</code>,
<code>shrink</code>, <code>standout</code>, <code>noframenumbering</code>.</p>

<h2 id="background-in-reveal.js-and-beamer">Background in reveal.js and beamer</h2>

<p>Background images can be added to self-contained reveal.js slideshows and
to beamer slideshows.</p>

<p>For the same image on every slide, use the configuration
option <code>background-image</code> either in the YAML metadata block
or as a command-line variable. (There are no other options in
beamer and the rest of this section concerns reveal.js slideshows.)</p>

<p>For reveal.js, you can instead use the reveal.js-native option
<code>parallaxBackgroundImage</code>. You can also set <code>parallaxBackgroundHorizontal</code>
and <code>parallaxBackgroundVertical</code> the same way and must also set
<code>parallaxBackgroundSize</code> to have your values take effect.</p>

<p>To set an image for a particular reveal.js slide, add
<code>{data-background-image=&quot;/path/to/image&quot;}</code>
to the first slide-level header on the slide (which may even be empty).</p>

<p>In reveal.js’s overview mode, the parallaxBackgroundImage will show up
only on the first slide.</p>

<p>Other reveal.js background settings also work on individual slides, including
<code>data-background-size</code>, <code>data-background-repeat</code>, <code>data-background-color</code>,
<code>data-transition</code>, and <code>data-transition-speed</code>.</p>

<p>See the <a href='https://github.com/hakimel/reveal.js#slide-backgrounds' title=''>reveal.js
documentation</a>
for more details.</p>

<p>For example in reveal.js:</p>

<pre><code>---
title: My Slideshow
parallaxBackgroundImage: /path/to/my/background_image.png
---

## Slide One

Slide 1 has background_image.png as its background.

## {data-background-image=&quot;/path/to/special_image.jpg&quot;}

Slide 2 has a special image for its background, even though the header has no content.</code></pre>

<h1 id="creating-epubs-with-pandoc">Creating EPUBs with pandoc</h1>

<h2 id="epub-metadata">EPUB Metadata</h2>

<p>EPUB metadata may be specified using the <code>--epub-metadata</code> option, but
if the source document is Markdown, it is better to use a <a href='#extension-yaml_metadata_block' title=''>YAML metadata
block</a>. Here is an example:</p>

<pre><code>---
title:
- type: main
  text: My Book
- type: subtitle
  text: An investigation of metadata
creator:
- role: author
  text: John Smith
- role: editor
  text: Sarah Jones
identifier:
- scheme: DOI
  text: doi:10.234234.234/33
publisher:  My Press
rights: © 2007 John Smith, CC BY-NC
ibooks:
  version: 1.3.4
...</code></pre>

<p>The following fields are recognized:</p>

<dl>
<dt><code>identifier</code></dt>
<dd>Either a string value or an object with fields <code>text</code> and
<code>scheme</code>. Valid values for <code>scheme</code> are <code>ISBN-10</code>,
<code>GTIN-13</code>, <code>UPC</code>, <code>ISMN-10</code>, <code>DOI</code>, <code>LCCN</code>, <code>GTIN-14</code>,
<code>ISBN-13</code>, <code>Legal deposit number</code>, <code>URN</code>, <code>OCLC</code>,
<code>ISMN-13</code>, <code>ISBN-A</code>, <code>JP</code>, <code>OLCC</code>.</dd>
<dt><code>title</code></dt>
<dd>Either a string value, or an object with fields <code>file-as</code> and
<code>type</code>, or a list of such objects. Valid values for <code>type</code> are
<code>main</code>, <code>subtitle</code>, <code>short</code>, <code>collection</code>, <code>edition</code>, <code>extended</code>.</dd>
<dt><code>creator</code></dt>
<dd>Either a string value, or an object with fields <code>role</code>, <code>file-as</code>,
and <code>text</code>, or a list of such objects. Valid values for <code>role</code> are
<a href='http://loc.gov/marc/relators/relaterm.html' title=''>MARC relators</a>, but
pandoc will attempt to translate the human-readable versions
(like &ldquo;author&rdquo; and &ldquo;editor&rdquo;) to the appropriate marc relators.</dd>
<dt><code>contributor</code></dt>
<dd>Same format as <code>creator</code>.</dd>
<dt><code>date</code></dt>
<dd>A string value in <code>YYYY-MM-DD</code> format. (Only the year is necessary.)
Pandoc will attempt to convert other common date formats.</dd>
<dt><code>lang</code> (or legacy: <code>language</code>)</dt>
<dd>A string value in <a href='https://tools.ietf.org/html/bcp47' title=''>BCP 47</a> format. Pandoc will default to the local
language if nothing is specified.</dd>
<dt><code>subject</code></dt>
<dd>A string value or a list of such values.</dd>
<dt><code>description</code></dt>
<dd>A string value.</dd>
<dt><code>type</code></dt>
<dd>A string value.</dd>
<dt><code>format</code></dt>
<dd>A string value.</dd>
<dt><code>relation</code></dt>
<dd>A string value.</dd>
<dt><code>coverage</code></dt>
<dd>A string value.</dd>
<dt><code>rights</code></dt>
<dd>A string value.</dd>
<dt><code>cover-image</code></dt>
<dd>A string value (path to cover image).</dd>
<dt><code>css</code> (or legacy: <code>stylesheet</code>)</dt>
<dd>A string value (path to CSS stylesheet).</dd>
<dt><code>page-progression-direction</code></dt>
<dd>Either <code>ltr</code> or <code>rtl</code>. Specifies the <code>page-progression-direction</code>
attribute for the <a href='http://idpf.org/epub/301/spec/epub-publications.html#sec-spine-elem' title=''><code>spine</code> element</a>.</dd>
<dt><code>ibooks</code></dt>
<dd><p>iBooks-specific metadata, with the following fields:</p>

<ul>
<li><code>version</code>: (string)</li>
<li><code>specified-fonts</code>: <code>true</code>|<code>false</code> (default <code>false</code>)</li>
<li><code>ipad-orientation-lock</code>: <code>portrait-only</code>|<code>landscape-only</code></li>
<li><code>iphone-orientation-lock</code>: <code>portrait-only</code>|<code>landscape-only</code></li>
<li><code>binding</code>: <code>true</code>|<code>false</code> (default <code>true</code>)</li>
<li><code>scroll-axis</code>: <code>vertical</code>|<code>horizontal</code>|<code>default</code></li>
</ul></dd>
</dl>

<h2 id="the-epubtype-attribute">The <code>epub:type</code> attribute</h2>

<p>For <code>epub3</code> output, you can mark up the header that corresponds to an EPUB
chapter using the <a href='http://www.idpf.org/epub/31/spec/epub-contentdocs.html#sec-epub-type-attribute' title=''><code>epub:type</code> attribute</a>. For example, to set
the attribute to the value <code>prologue</code>, use this markdown:</p>

<pre><code># My chapter {epub:type=prologue}</code></pre>

<p>Which will result in:</p>

<pre><code>&lt;body epub:type=&quot;frontmatter&quot;&gt;
  &lt;section epub:type=&quot;prologue&quot;&gt;
    &lt;h1&gt;My chapter&lt;/h1&gt;</code></pre>

<p>Pandoc will output <code>&lt;body epub:type=&quot;bodymatter&quot;&gt;</code>, unless
you use one of the following values, in which case either
<code>frontmatter</code> or <code>backmatter</code> will be output.</p>

<table>
<tr class="header">
<th align="left"><code>epub:type</code> of first section</th>
<th align="left"><code>epub:type</code> of body</th>
</tr>
<tr class="odd">
<td align="left">prologue</td>
<td align="left">frontmatter</td>
</tr>
<tr class="even">
<td align="left">abstract</td>
<td align="left">frontmatter</td>
</tr>
<tr class="odd">
<td align="left">acknowledgments</td>
<td align="left">frontmatter</td>
</tr>
<tr class="even">
<td align="left">copyright-page</td>
<td align="left">frontmatter</td>
</tr>
<tr class="odd">
<td align="left">dedication</td>
<td align="left">frontmatter</td>
</tr>
<tr class="even">
<td align="left">foreword</td>
<td align="left">frontmatter</td>
</tr>
<tr class="odd">
<td align="left">halftitle,</td>
<td align="left">frontmatter</td>
</tr>
<tr class="even">
<td align="left">introduction</td>
<td align="left">frontmatter</td>
</tr>
<tr class="odd">
<td align="left">preface</td>
<td align="left">frontmatter</td>
</tr>
<tr class="even">
<td align="left">seriespage</td>
<td align="left">frontmatter</td>
</tr>
<tr class="odd">
<td align="left">titlepage</td>
<td align="left">frontmatter</td>
</tr>
<tr class="even">
<td align="left">afterword</td>
<td align="left">backmatter</td>
</tr>
<tr class="odd">
<td align="left">appendix</td>
<td align="left">backmatter</td>
</tr>
<tr class="even">
<td align="left">colophon</td>
<td align="left">backmatter</td>
</tr>
<tr class="odd">
<td align="left">conclusion</td>
<td align="left">backmatter</td>
</tr>
<tr class="even">
<td align="left">epigraph</td>
<td align="left">backmatter</td>
</tr>
</table>

<h2 id="linked-media">Linked media</h2>

<p>By default, pandoc will download media referenced from any <code>&lt;img&gt;</code>, <code>&lt;audio&gt;</code>,
<code>&lt;video&gt;</code> or <code>&lt;source&gt;</code> element present in the generated EPUB,
and include it in the EPUB container, yielding a completely
self-contained EPUB. If you want to link to external media resources
instead, use raw HTML in your source and add <code>data-external=&quot;1&quot;</code> to the tag
with the <code>src</code> attribute. For example:</p>

<pre><code>&lt;audio controls=&quot;1&quot;&gt;
  &lt;source src=&quot;http://example.com/music/toccata.mp3&quot;
          data-external=&quot;1&quot; type=&quot;audio/mpeg&quot;&gt;
  &lt;/source&gt;
&lt;/audio&gt;</code></pre>

<h1 id="creating-jupyter-notebooks-with-pandoc">Creating Jupyter notebooks with pandoc</h1>

<p>When creating a <a href='https://nbformat.readthedocs.io/en/latest/' title=''>Jupyter notebook</a>, pandoc will try to infer the
notebook structure. Code blocks with the class <code>code</code> will be
taken as code cells, and intervening content will be taken as
Markdown cells. Attachments will automatically be created for
images in Markdown cells. Metadata will be taken from the
<code>jupyter</code> metadata field. For example:</p>

<pre><code>---
title: My notebook
jupyter:
  nbformat: 4
  nbformat_minor: 5
  kernelspec:
     display_name: Python 2
     language: python
     name: python2
  language_info:
     codemirror_mode:
       name: ipython
       version: 2
     file_extension: &quot;.py&quot;
     mimetype: &quot;text/x-python&quot;
     name: &quot;python&quot;
     nbconvert_exporter: &quot;python&quot;
     pygments_lexer: &quot;ipython2&quot;
     version: &quot;2.7.15&quot;
---

# Lorem ipsum

**Lorem ipsum** dolor sit amet, consectetur adipiscing elit. Nunc luctus
bibendum felis dictum sodales.

``` code
print(&quot;hello&quot;)
```

## Pyout

``` code
from IPython.display import HTML
HTML(&quot;&quot;&quot;
&lt;script&gt;
console.log(&quot;hello&quot;);
&lt;/script&gt;
&lt;b&gt;HTML&lt;/b&gt;
&quot;&quot;&quot;)
```

## Image

This image ![image](myimage.png) will be
included as a cell attachment.</code></pre>

<p>If you want to add cell attributes, group cells differently, or
add output to code cells, then you need to include divs to
indicate the structure. You can use either <a href='#extension-fenced_divs' title=''>fenced
divs</a> or <a href='#extension-native_divs' title=''>native divs</a> for this. Here is an example:</p>

<pre><code>:::::: {.cell .markdown}
# Lorem

**Lorem ipsum** dolor sit amet, consectetur adipiscing elit. Nunc luctus
bibendum felis dictum sodales.
::::::

:::::: {.cell .code execution_count=1}
``` {.python}
print(&quot;hello&quot;)
```

::: {.output .stream .stdout}
```
hello
```
:::
::::::

:::::: {.cell .code execution_count=2}
``` {.python}
from IPython.display import HTML
HTML(&quot;&quot;&quot;
&lt;script&gt;
console.log(&quot;hello&quot;);
&lt;/script&gt;
&lt;b&gt;HTML&lt;/b&gt;
&quot;&quot;&quot;)
```

::: {.output .execute_result execution_count=2}
```{=html}
&lt;script&gt;
console.log(&quot;hello&quot;);
&lt;/script&gt;
&lt;b&gt;HTML&lt;/b&gt;
hello
```
:::
::::::</code></pre>

<p>If you include raw HTML or TeX in an output cell, use the
[raw attribute][Extension: <code>fenced_attribute</code>], as shown
in the last cell of the example above. Although pandoc can
process &ldquo;bare&rdquo; raw HTML and TeX, the result is often
interspersed raw elements and normal textual elements, and
in an output cell pandoc expects a single, connected raw
block. To avoid using raw HTML or TeX except when
marked explicitly using raw attributes, we recommend
specifying the extensions <code>-raw_html-raw_tex+raw_attribute</code> when
translating between Markdown and ipynb notebooks.</p>

<h1 id="syntax-highlighting">Syntax highlighting</h1>

<p>Pandoc will automatically highlight syntax in <a href='#fenced-code-blocks' title=''>fenced code blocks</a> that
are marked with a language name. The Haskell library <a href='https://github.com/jgm/skylighting' title=''>skylighting</a> is
used for highlighting. Currently highlighting is supported only for
HTML, EPUB, Docx, Ms, and LaTeX/PDF output. To see a list of language names
that pandoc will recognize, type <code>pandoc --list-highlight-languages</code>.</p>

<p>The color scheme can be selected using the <code>--highlight-style</code> option.
The default color scheme is <code>pygments</code>, which imitates the default color
scheme used by the Python library pygments (though pygments is not actually
used to do the highlighting). To see a list of highlight styles,
type <code>pandoc --list-highlight-styles</code>.</p>

<p>If you are not satisfied with the predefined styles, you can
use <code>--print-highlight-style</code> to generate a JSON <code>.theme</code> file which
can be modified and used as the argument to <code>--highlight-style</code>. To
get a JSON version of the <code>pygments</code> style, for example:</p>

<pre><code>pandoc --print-highlight-style pygments &gt; my.theme</code></pre>

<p>Then edit <code>my.theme</code> and use it like this:</p>

<pre><code>pandoc --highlight-style my.theme</code></pre>

<p>If you are not satisfied with the built-in highlighting, or you
want highlight a language that isn’t supported, you can use the
<code>--syntax-definition</code> option to load a <a href='https://docs.kde.org/stable5/en/applications/katepart/highlight.html' title=''>KDE-style XML syntax definition
file</a>.
Before writing your own, have a look at KDE’s <a href='https://github.com/KDE/syntax-highlighting/tree/master/data/syntax' title=''>repository of syntax
definitions</a>.</p>

<p>To disable highlighting, use the <code>--no-highlight</code> option.</p>

<h1 id="custom-styles">Custom Styles</h1>

<p>Custom styles can be used in the docx and ICML formats.</p>

<h2 id="output">Output</h2>

<p>By default, pandoc’s docx and ICML output applies a predefined set of styles
for blocks such as paragraphs and block quotes, and uses largely default
formatting (italics, bold) for inlines. This will work for most
purposes, especially alongside a <code>reference.docx</code> file. However, if you
need to apply your own styles to blocks, or match a preexisting set of
styles, pandoc allows you to define custom styles for blocks and text
using <code>div</code>s and <code>span</code>s, respectively.</p>

<p>If you define a <code>div</code> or <code>span</code> with the attribute <code>custom-style</code>,
pandoc will apply your specified style to the contained elements. So,
for example using the <code>bracketed_spans</code> syntax,</p>

<pre><code>[Get out]{custom-style=&quot;Emphatically&quot;}, he said.</code></pre>

<p>would produce a docx file with &ldquo;Get out&rdquo; styled with character
style <code>Emphatically</code>. Similarly, using the <code>fenced_divs</code> syntax,</p>

<pre><code>Dickinson starts the poem simply:

::: {custom-style=&quot;Poetry&quot;}
| A Bird came down the Walk---
| He did not know I saw---
:::</code></pre>

<p>would style the two contained lines with the <code>Poetry</code> paragraph style.</p>

<p>For docx output, styles will be defined in the output file as inheriting
from normal text, if the styles are not yet in your reference.docx.
If they are already defined, pandoc will not alter the definition.</p>

<p>This feature allows for greatest customization in conjunction with
<a href='http://pandoc.org/filters.html' title=''>pandoc filters</a>. If you want all paragraphs after block quotes to be
indented, you can write a filter to apply the styles necessary. If you
want all italics to be transformed to the <code>Emphasis</code> character style
(perhaps to change their color), you can write a filter which will
transform all italicized inlines to inlines within an <code>Emphasis</code>
custom-style <code>span</code>.</p>

<p>For docx output, you don’t need to enable any extensions for
custom styles to work.</p>

<h2 id="input">Input</h2>

<p>The docx reader, by default, only reads those styles that it can
convert into pandoc elements, either by direct conversion or
interpreting the derivation of the input document’s styles.</p>

<p>By enabling the <a href='#ext-styles' title=''><code>styles</code> extension</a> in the docx reader
(<code>-f docx+styles</code>), you can produce output that maintains the styles
of the input document, using the <code>custom-style</code> class. Paragraph
styles are interpreted as divs, while character styles are interpreted
as spans.</p>

<p>For example, using the <code>custom-style-reference.docx</code> file in the test
directory, we have the following different outputs:</p>

<p>Without the <code>+styles</code> extension:</p>

<pre><code>$ pandoc test/docx/custom-style-reference.docx -f docx -t markdown
This is some text.

This is text with an *emphasized* text style. And this is text with a
**strengthened** text style.

&gt; Here is a styled paragraph that inherits from Block Text.</code></pre>

<p>And with the extension:</p>

<pre><code>$ pandoc test/docx/custom-style-reference.docx -f docx+styles -t markdown

::: {custom-style=&quot;FirstParagraph&quot;}
This is some text.
:::

::: {custom-style=&quot;BodyText&quot;}
This is text with an [emphasized]{custom-style=&quot;Emphatic&quot;} text style.
And this is text with a [strengthened]{custom-style=&quot;Strengthened&quot;}
text style.
:::

::: {custom-style=&quot;MyBlockStyle&quot;}
&gt; Here is a styled paragraph that inherits from Block Text.
:::</code></pre>

<p>With these custom styles, you can use your input document as a
reference-doc while creating docx output (see below), and maintain the
same styles in your input and output files.</p>

<h1 id="custom-writers">Custom writers</h1>

<p>Pandoc can be extended with custom writers written in <a href='http://www.lua.org' title=''>lua</a>. (Pandoc
includes a lua interpreter, so lua need not be installed separately.)</p>

<p>To use a custom writer, simply specify the path to the lua script
in place of the output format. For example:</p>

<pre><code>pandoc -t data/sample.lua</code></pre>

<p>Creating a custom writer requires writing a lua function for each
possible element in a pandoc document. To get a documented example
which you can modify according to your needs, do</p>

<pre><code>pandoc --print-default-data-file sample.lua</code></pre>

<h1 id="a-note-on-security">A note on security</h1>

<p>If you use pandoc to convert user-contributed content in a web
application, here are some things to keep in mind:</p>

<ol>
<li><p>Although pandoc itself will not create or modify any files other
than those you explicitly ask it create (with the exception
of temporary files used in producing PDFs), a filter or custom
writer could in principle do anything on your file system. Please
audit filters and custom writers very carefully before using them.</p></li>
<li><p>If your application uses pandoc as a Haskell library (rather than
shelling out to the executable), it is possible to use it in a mode
that fully isolates pandoc from your file system, by running the
pandoc operations in the <code>PandocPure</code> monad. See the document
<a href='http://pandoc.org/using-the-pandoc-api.html' title=''>Using the pandoc API</a>
for more details.</p></li>
<li><p>Pandoc’s parsers can exhibit pathological performance on some
corner cases. It is wise to put any pandoc operations under
a timeout, to avoid DOS attacks that exploit these issues.
If you are using the pandoc executable, you can add the
command line options <code>+RTS -M512M -RTS</code> (for example) to limit
the heap size to 512MB.</p></li>
<li><p>The HTML generated by pandoc is not guaranteed to be safe.
If <code>raw_html</code> is enabled for the Markdown input, users can
inject arbitrary HTML. Even if <code>raw_html</code> is disabled,
users can include dangerous content in attributes for
headers, spans, and code blocks. To be safe, you should
run all the generated HTML through an HTML sanitizer.</p></li>
</ol>

<h1 id="authors">Authors</h1>

<p>Copyright 2006–2019 John MacFarlane (jgm@berkeley.edu). Released
under the <a href='http://www.gnu.org/copyleft/gpl.html' title='GNU General Public License'>GPL</a>, version 2 or greater. This software carries no
warranty of any kind. (See COPYRIGHT for full copyright and
warranty notices.) For a full list of contributors, see the file
AUTHORS.md in the pandoc source code.</p>
<ol class="footnotes">
<li id="fn1"><p>The point of this rule is to ensure that normal paragraphs
starting with people’s initials, like</p>

<pre><code>B. Russell was an English philosopher.</code></pre>

<p>do not get treated as list items.</p>

<p>This rule will not prevent</p>

<pre><code>(C) 2007 Joe Smith</code></pre>

<p>from being interpreted as a list item. In this case, a backslash
escape can be used:</p>

<pre><code>(C\) 2007 Joe Smith</code> <a href="#fnref1">&#8617;</a></pre></li>
<li id="fn2"><p>I have been influenced by the suggestions of <a href='http://www.justatheory.com/computers/markup/modest-markdown-proposal.html' title=''>David Wheeler</a>. <a href="#fnref2">&#8617;</a></p></li>
<li id="fn3"><p>This scheme is due to Michel Fortin, who proposed it on the
<a href='http://six.pairlist.net/pipermail/markdown-discuss/2005-March/001097.html' title=''>Markdown discussion list</a>. <a href="#fnref3">&#8617;</a></p></li>
<li id="fn4"><p>To see why laziness is incompatible with relaxing the requirement
of a blank line between items, consider the following example:</p>

<pre><code>bar
:    definition
foo
:    definition</code></pre>

<p>Is this a single list item with two definitions of &ldquo;bar,&rdquo; the first of
which is lazily wrapped, or two list items? To remove the ambiguity
we must either disallow lazy wrapping or require a blank line between
list items. <a href="#fnref4">&#8617;</a></p></li>
</ol>

