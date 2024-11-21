<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:ldp="http://www.w3.org/ns/ldp#"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:pcdm="http://pcdm.org/models">
  <xsl:output method="html"/>
  <xsl:variable name="about" select="/rdf:RDF/rdf:Description[1]/@rdf:about"/>
  <xsl:variable name="title" select="/rdf:RDF/rdf:Description[1]/dcterms:title"/>
  <xsl:variable name="comment" select="/rdf:RDF/rdf:Description[1]/rdfs:comment"/>
  <xsl:variable name="modified" select="/rdf:RDF/rdf:Description[1]/dcterms:modified"/>
  <xsl:variable name="publisher" select="/rdf:RDF/rdf:Description[1]/dcterms:publisher/@rdf:resource"/>
  <xsl:variable name="seeAlso" select="/rdf:RDF/rdf:Description[1]/rdfs:seeAlso/@rdf:resource"/>
  <xsl:variable name="versionInfo" select="/rdf:RDF/rdf:Description/owl:versionInfo"/>


  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="$title"/></title>
        <style>
          h4 { margin-bottom: 0.25em; }
          body { font-family: sans-serif; }
          .about { font-family: monospace; margin-left: 1em; }
          .label { margin-left: 1em; font-style:italic; }
          .comment { margin-left: 1em; }
          .property { margin-left: 1em; }
          .modified { margin-left: 1em; }
          .published { margin-left: 1em; }
          .seealso { margin-left: 1em; }
          .version { margin-left: 1em; }
        </style>
      </head>
      <body>
        <h1><xsl:value-of select="$title"/></h1>
        <div class="about"><xsl:value-of select="$about"/></div>
        <div class="comment"><xsl:value-of select="$comment"/></div>
        <div class="modified">Modified: <xsl:value-of select="$modified"/></div>
        <div class="published">Published by: <a href="{$publisher}"><xsl:value-of select="$publisher"/></a></div>
        <xsl:if test="not($versionInfo = '')">
          <div class="version">Version Info: <xsl:value-of select="$versionInfo" /></div>
        </xsl:if>
        <xsl:if test="$seeAlso != ''">
          <div class="seealso">See Also: <a href="{$seeAlso}"><xsl:value-of select="$seeAlso"/></a></div>
        </xsl:if>

        <!-- table of contents -->
        <div class="table-of-contents">
            <h2>Table of Contents</h2>
            <xsl:for-each select="/rdf:RDF/rdfs:Class">
              <xsl:sort select="@rdf:about"/>
              <xsl:if test="position() = 1"><h3>Classes</h3></xsl:if>
              <xsl:call-template name="toc-entry"/>
            </xsl:for-each>
            <xsl:for-each select="/rdf:RDF/rdf:Property">
              <xsl:sort select="@rdf:about"/>
              <xsl:if test="position() = 1"><h3>Properties</h3></xsl:if>
              <xsl:call-template name="toc-entry"/>
          </xsl:for-each>
        </div>

        <!-- class list -->
        <div class="contents">
            <h2>Entity Definitions</h2>
            <xsl:for-each select="/rdf:RDF/rdfs:Class">
              <xsl:sort select="@rdf:about"/>
              <xsl:if test="position() = 1"><h3>Classes</h3></xsl:if>
              <xsl:call-template name="main-entry"/>
            </xsl:for-each>

            <!-- properties list -->
            <xsl:for-each select="/rdf:RDF/rdf:Property">
              <xsl:sort select="@rdf:about"/>
              <xsl:if test="position() = 1"><h3>Properties</h3></xsl:if>
              <xsl:call-template name="main-entry"/>
          </xsl:for-each>
        </div>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="display-uri">
    <xsl:param name="label"/>
    <xsl:param name="uri"/>
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="/*/namespace::*[starts-with($uri,.)]">
          <xsl:for-each select="/*/namespace::*">
            <xsl:if test="starts-with($uri,.)">
              <xsl:value-of select="name()"/>:<xsl:value-of select="substring-after($uri,.)"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$uri"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$uri != ''">
      <li><xsl:value-of select="$label"/><xsl:text>: </xsl:text>
        <a href="{$uri}"><xsl:value-of select="$name"/></a>
      </li>
    </xsl:if>
  </xsl:template>
  <xsl:template name="toc-entry">
    <xsl:variable name="id">
      <xsl:value-of select="substring-after(@rdf:about,$about)"/>
    </xsl:variable>
    <xsl:if test="$id != ''">
      <a href="#{$id}"><xsl:value-of select="$id"/></a>
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>
  <xsl:template name="main-entry">
    <xsl:variable name="id">
      <xsl:value-of select="substring-after(@rdf:about,$about)"/>
    </xsl:variable>
    <xsl:if test="$id != ''">
      <h4 id="{$id}"><xsl:value-of select="$id"/></h4>
      <ul>
        <li>Label: <xsl:value-of select="rdfs:label"/></li>
        <xsl:if test="rdfs:comment != ''">
          <li>Comment: <xsl:value-of select="rdfs:comment"/></li>
        </xsl:if>
        <xsl:if test="rdfs:subClassOf/@rdf:resource">
          <xsl:call-template name="display-uri">
            <xsl:with-param name="label">Subclass of</xsl:with-param>
            <xsl:with-param name="uri" select="rdfs:subClassOf/@rdf:resource"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="rdfs:subPropertyOf/@rdf:resource">
          <xsl:call-template name="display-uri">
            <xsl:with-param name="label">Subproperty of</xsl:with-param>
            <xsl:with-param name="uri" select="rdfs:subPropertyOf/@rdf:resource"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="rdfs:domain/@rdf:resource">
          <xsl:call-template name="display-uri">
            <xsl:with-param name="label">Domain</xsl:with-param>
            <xsl:with-param name="uri" select="rdfs:domain/@rdf:resource"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="rdfs:range/@rdf:resource">
          <xsl:call-template name="display-uri">
            <xsl:with-param name="label">Range</xsl:with-param>
            <xsl:with-param name="uri" select="rdfs:range/@rdf:resource"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="owl:inverseOf/@rdf:resource">
          <xsl:call-template name="display-uri">
            <xsl:with-param name="label">Inverse of</xsl:with-param>
            <xsl:with-param name="uri" select="owl:inverseOf/@rdf:resource"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="rdfs:isDefinedBy/@rdf:resource">
          <li>Is defined by: <a href="{rdfs:isDefinedBy/@rdf:resource}"><xsl:value-of select="rdfs:isDefinedBy/@rdf:resource"/></a></li>
        </xsl:if>
      </ul>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
