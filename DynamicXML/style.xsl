<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:key name="KeyMatch" match="/DataList/Keys/Key" use="@property" />
	<xsl:template match="/">
		<html lang="en">
			<head>
				<meta charset="UTF-8" />
				<title>DataList</title>
			</head>
			<body>
				<xsl:variable name="DataCount" select="count(DataList/Data)" />
				<table border="1" cellspacing="0" cellpadding="0">
					<tr>
						<xsl:for-each select="key('KeyMatch','field')">
							<th nowrap="true" bgcolor="#9acd32">
								<xsl:value-of select="@value" />
							</th>
						</xsl:for-each>
					</tr>
					<xsl:call-template name="PrintData">
						<xsl:with-param name="DataCount" select="$DataCount" />
						<xsl:with-param name="CurrentDataSeq" select="1" />
					</xsl:call-template>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="PrintData">
		<xsl:param name="DataCount" />
		<xsl:param name="CurrentDataSeq" />
		<xsl:if test="$CurrentDataSeq &lt; $DataCount + 1">
			<tr>
				<xsl:for-each select="DataList/Data[$CurrentDataSeq]">
					<xsl:for-each select="key('KeyMatch','field')">
						<xsl:variable name="Field" select="@name" />
						<td nowrap="true">
							<xsl:choose>
								<xsl:when test="string-length(/DataList/Data[$CurrentDataSeq]/*[name()=$Field]) > 0">
									<xsl:value-of select="/DataList/Data[$CurrentDataSeq]/*[name()=$Field]" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>　</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</xsl:for-each>
				</xsl:for-each>
			</tr>
			<xsl:call-template name="PrintData">
				<xsl:with-param name="DataCount" select="$DataCount" />
				<xsl:with-param name="CurrentDataSeq" select="$CurrentDataSeq + 1" />
			</xsl:call-template>
		</xsl:if>	
	</xsl:template>
</xsl:stylesheet>
