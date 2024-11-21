<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <xsl:output method="html"/>
  <xsl:template match="/index">
    <html>
      <head>
        <title><xsl:value-of select="pages/@title"/></title>
        <style>
          body { width: 80%; margin: 0 auto; }
          body { font-family: sans-serif; background: url(assets/cream_pixels.png);}
          header { text-align: center; }
          h1 { font-size: large; }
        </style>
      </head>
      <body>
        <header>
          <img src="assets/duraspace_logo.png"/>
        </header>
        <h1><xsl:value-of select="pages/@title"/></h1>
        <ul>
          <xsl:for-each select="pages/page">
            <li>
              <xsl:variable name="page_url" select="@url"/>
              <a href="{$page_url}"><xsl:value-of select="@id"/></a>
            </li>
          </xsl:for-each>
        </ul>

        <xsl:for-each select="items/item">
          <xsl:variable name="item_url" select="@url"/>
          <h1><a href="{$item_url}"><xsl:value-of select="@id"/></a></h1>
        </xsl:for-each>

      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
