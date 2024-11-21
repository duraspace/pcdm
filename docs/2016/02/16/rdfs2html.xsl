<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:udfrs="http://www.udfr.org/onto#"
    xmlns:nfo="http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#"
    xmlns:dcmitype="http://purl.org/dc/dcmitype/"
    xmlns:aat="http://vocab.getty.edu/aat/"
    xmlns:pronom="http://reference.data.gov.uk/technical-registry/"
    xmlns:marcres="http://id.loc.gov/vocabulary/resourceTypes/"
    xmlns:pcdmfmt="http://pcdm.org/file-format-types#">

  <xsl:output method="html"/>

  <xsl:variable name="about" select="/rdf:RDF/rdf:Description[1]/@rdf:about"/>
  <xsl:variable name="title" select="/rdf:RDF/rdf:Description[1]/dcterms:title"/>
  <xsl:variable name="comment" select="/rdf:RDF/rdf:Description[1]/rdfs:comment"/>
  <xsl:variable name="modified" select="/rdf:RDF/rdf:Description[1]/dcterms:modified"/>
  <xsl:variable name="publisher" select="/rdf:RDF/rdf:Description[1]/dcterms:publisher/@rdf:resource"/>
  <xsl:variable name="seeAlso" select="/rdf:RDF/rdf:Description[1]/rdfs:seeAlso/@rdf:resource"/>
  <xsl:variable name="versionInfo" select="/rdf:RDF/rdf:Description[1]/owl:versionInfo"/>
  <xsl:variable name="priorVersion" select="/rdf:RDF/rdf:Description[1]/owl:priorVersion/@rdf:resource"/>

  <!-- namespaces -->
  <xsl:variable name="orens" select="'http://www.openarchives.org/ore/terms/'"/>
  <xsl:variable name="ldpns" select="'http://www.w3.org/ns/ldp#'"/>
  <xsl:variable name="rdfsns" select="'http://www.w3.org/2000/01/rdf-schema#'"/>
  <xsl:variable name="dctermsns" select="'http://purl.org/dc/terms/'"/>
  <xsl:variable name="pcdmns" select="'http://pcdm.org/models#'"/>
  <xsl:variable name="pcdmusens" select="'http://pcdm.org/use#'"/>
  <xsl:variable name="pcdmrightsns" select="'http://pcdm.org/rights#'"/>

  <xsl:template match="/rdf:RDF">
    <html>
      <head>
        <title><xsl:value-of select="$title"/></title>
        <style>
          body { width: 80%; margin: 0 auto; font-family: sans-serif; background: #F6F6F6;}
          header { text-align: center; margin-top: 10px; }
          header table { width: 70%; margin: 0 auto; }
          h1 { font-size: 2em; }
          h2 { font-size: 1.7em; }
          h3 { font-size: 1.4em; padding-top: 20px; }
          h4 { margin-bottom: 0.25em; }
          hr { margin: 30px 0; }
          table { width: 100%; margin: 25px 0; border-collapse: collapse; }
          tr { border: 1px solid #ccc; }
          th { background-color: #ddd; padding: 5px; font-size: 120%; text-align:center; font-weight: bold; }
          td { vertical-align: top; padding: 5px; border: 1px solid #ccc; }
          td:first-child { width: 150px; font-weight: bold; white-space: nowrap; }
          tr.about td:nth-child(2) { font-size: 120%; font-family: monospace; }
        </style>
      </head>
      <body>
        <header>
          <img src="assets/duraspace_logo.png"/>
          <h1><xsl:value-of select="$title"/></h1>
            <table>
              <tr class="about">
                <td>Namespace</td>
                <td><xsl:value-of select="$about"/></td>
              </tr>
              <xsl:if test="not($comment = '')">
                <tr class="comment">
                  <td>Description</td>
                  <td><xsl:value-of select="$comment"/></td>
                </tr>
              </xsl:if>
              <xsl:if test="not($versionInfo = '')">
                <tr class="version">
                  <td>Version</td>
                  <td><xsl:value-of select="$versionInfo"/></td>
                </tr>
              </xsl:if>
              <xsl:if test="not($modified = '')">
                <tr>
                  <td>Last Modified</td>
                  <td><xsl:value-of select="$modified"/></td>
                </tr>
              </xsl:if>
              <xsl:if test="not($priorVersion = '')">
                <tr class="version">
                  <td>Prior version</td>
                  <td>
                    <a>
                      <xsl:attribute name="href"><xsl:value-of select="$priorVersion"/></xsl:attribute>
                      <xsl:value-of select="$priorVersion"/>
                    </a>
                  </td>
                </tr>
              </xsl:if>
              <xsl:if test="$publisher != ''">
                <tr>
                  <td>Published by</td>
                  <td>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:value-of select="$publisher"/>
                      </xsl:attribute>
                      <xsl:value-of select="$publisher"/>
                    </a>
                  </td>
                </tr>
              </xsl:if>
              <xsl:if test="$seeAlso != ''">
                <tr>
                  <td>See Also</td>
                  <td>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:value-of select="$seeAlso"/>
                      </xsl:attribute>
                      <xsl:value-of select="$seeAlso"/>
                    </a>
                  </td>
                </tr>
              </xsl:if>
            </table>
        </header>

        <!-- table of contents -->
        <div class="table-of-contents">
          <hr/>
          <h2>Table of Contents</h2>

          <xsl:if test="/rdf:RDF/rdfs:Class">
            <p><a href="#Classes">Classes</a></p>
          </xsl:if>

          <xsl:if test="/rdf:RDF/rdf:Property">
            <p><a href="#Properties">Properties</a></p>
          </xsl:if>

          <xsl:if test="/rdf:RDF/*[not(local-name() = 'Class' or local-name() = 'Property' or @rdf:about = /rdf:RDF/rdf:Description[1]/@rdf:about)]">
            <p><a href="#Individuals">Individuals</a></p>
          </xsl:if>
        </div>

        <article>
          <hr/>
          <h2>Entity Definitions</h2>
          <xsl:if test="/rdf:RDF/rdfs:Class">
            <a name="Classes"></a>
            <h3>Classes</h3>
            <xsl:for-each select="/rdf:RDF/rdfs:Class">
              <xsl:sort select="@rdf:about"/>
              <xsl:call-template name="description"/>
            </xsl:for-each>
          </xsl:if>

          <xsl:if test="/rdf:RDF/rdf:Property">
            <a name="Properties"></a>
            <h3>Properties</h3>
            <xsl:for-each select="/rdf:RDF/rdf:Property">
              <xsl:sort select="@rdf:about"/>
              <xsl:call-template name="description"/>
            </xsl:for-each>
          </xsl:if>

          <xsl:if test="/rdf:RDF/*[not(local-name() = 'Class' or local-name() = 'Property' or @rdf:about = /rdf:RDF/rdf:Description[1]/@rdf:about)]">
            <a name="Individuals"></a>
            <h3>Individuals</h3>
            <xsl:for-each select="/rdf:RDF/*[not(local-name() = 'Class' or local-name() = 'Property' or @rdf:about = /rdf:RDF/rdf:Description[1]/@rdf:about)]">
              <xsl:sort select="@rdf:about"/>
              <xsl:call-template name="description"/>
            </xsl:for-each>
          </xsl:if>

        </article>

      </body>
    </html>
  </xsl:template>

  <xsl:template name="description">
    <xsl:variable name="id" select="substring-after(@rdf:about,$about)"/>
    <div id="{$id}">
      <table>
        <tr>
          <xsl:choose>
            <xsl:when test="contains(@rdf:about,$pcdmns)">
              <th colspan="2">pcdm:<xsl:value-of select="$id"/></th>
            </xsl:when>
            <xsl:when test="contains(@rdf:about,$pcdmrightsns)">
              <th colspan="2">pcdmrights:<xsl:value-of select="$id"/></th>
            </xsl:when>
            <xsl:when test="contains(@rdf:about,$pcdmusens)">
              <th colspan="2">pcdmuse:<xsl:value-of select="$id"/></th>
            </xsl:when>
            <xsl:otherwise>
              <th colspan="2"><xsl:value-of select="@rdf:about"/></th>
            </xsl:otherwise>
          </xsl:choose>
        </tr>
        <tr class="about">
          <td>URI</td>
          <td><xsl:value-of select="@rdf:about"/></td>
        </tr>

        <xsl:if test="rdfs:label">
          <tr class="label">
            <td>Label</td>
            <td><xsl:value-of select="rdfs:label"/></td>
          </tr>
        </xsl:if>
        <xsl:for-each select="rdfs:comment">
          <tr class="comment">
            <td>Description</td>
            <td><xsl:value-of select="."/></td>
          </tr>
        </xsl:for-each>
        <tr class="property">
          <td>Type</td>
          <td><xsl:value-of select="name()"/></td>
        </tr>
        <xsl:if test="rdfs:subClassOf">
          <tr class="property">
            <td>Subclass Of</td>
            <td>
              <xsl:for-each select="rdfs:subClassOf">
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="//*[contains(rdfs:domain/@rdf:resource,$id)]|//*[contains(rdfs:range/@rdf:resource,$id)]">
          <tr class="property">
            <td>Used With</td>
            <td>
              <xsl:for-each select="//*[contains(rdfs:domain/@rdf:resource,$id)]|//*[contains(rdfs:range/@rdf:resource,$id)]">
                <xsl:sort select="@rdf:about"/>
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="//*[rdf:type/@rdf:resource=concat($about,$id)]">
          <tr class="property">
            <td>Instances</td>
            <td>
              <xsl:for-each select="//*[rdf:type/@rdf:resource=concat($about,$id)]">
                <xsl:sort select="@rdf:about"/>
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="rdf:type">
          <tr class="property">
            <td>rdf:type</td>
            <td>
              <xsl:for-each select="rdf:type">
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="rdfs:domain">
          <tr class="property">
            <td>Domain</td>
            <td>
              <xsl:for-each select="rdfs:domain">
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="rdfs:range">
          <tr class="property">
            <td>Range</td>
            <td>
              <xsl:for-each select="rdfs:range">
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="skos:broader">
          <tr class="property">
            <td>Broader</td>
            <td>
              <xsl:for-each select="skos:broader">
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="skos:exactMatch">
          <tr class="property">
            <td>Exact Match</td>
            <td>
              <xsl:for-each select="skos:exactMatch">
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="skos:closeMatch">
          <tr class="property">
            <td>Close Match</td>
            <td>
              <xsl:for-each select="skos:closeMatch">
                <xsl:call-template name="link"/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>

      </table>
    </div>
  </xsl:template>

  <xsl:template name="link">
    <xsl:variable name="ns" select="/rdf:RDF/rdf:Description/@rdf:about"/>
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="@rdf:about">
          <xsl:value-of select="@rdf:about"/>
        </xsl:when>
        <xsl:when test="@rdf:resource">
          <xsl:value-of select="@rdf:resource"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="/*/namespace::*[starts-with($id,.)]">
          <xsl:for-each select="/*/namespace::*">
            <xsl:if test="starts-with($id,.)">
              <xsl:value-of select="name()"/>:<xsl:value-of select="substring-after($id,.)"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$id"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="url">
      <xsl:choose>
        <xsl:when test="starts-with($id,$ns)">
          <xsl:if test="substring($ns, string-length($ns)) = '#'">#</xsl:if>
          <xsl:value-of select="substring-after($id,/rdf:RDF/rdf:Description/@rdf:about)"/>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$id"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$url != ''">
      <a href="{$url}">
        <xsl:value-of select="$name"/>
      </a>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>

</xsl:stylesheet>
