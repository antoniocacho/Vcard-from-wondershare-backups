<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:mstns="http://tempuri.org/Contacts.xsd"
	xmlns:java="http://xml.apache.org/xslt/java"
  	extension-element-prefixes="java">
	<xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" media-type="application/vcf"/>
	<xsl:strip-space elements="*" />
	
	<!-- vCard tag subset: BEGIN END VERSION FN ADR TEL EMAIL URL PHOTO ORG NOTE X-ANDROID-CUSTOM/nickname -->
	
	<xsl:template match="/">
		<xsl:apply-templates select="mstns:ContactsDataSet/mstns:Contact"/>
	</xsl:template>
	
	<xsl:template match="mstns:Contact">
		<xsl:text>BEGIN:VCARD&#xA;VERSION:2.1&#xA;</xsl:text>
		<xsl:apply-templates select="mstns:FullName"/>
		<xsl:apply-templates select="mstns:PictureImage"/>
		<xsl:variable name="Id" select="mstns:Id"/>
		<xsl:apply-templates select="../mstns:Address">
			<xsl:with-param name="currentContactId" select="$Id"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="../mstns:PhoneNumbers">
			<xsl:with-param name="currentContactId" select="$Id"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="../mstns:Emails">
			<xsl:with-param name="currentContactId" select="$Id"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="../mstns:WebSites">
			<xsl:with-param name="currentContactId" select="$Id"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="(../mstns:Organizations[mstns:ContactId=$Id])[1]"/> 	<!-- Only one, the first found -->
		<xsl:apply-templates select="(../mstns:NickNames[mstns:ContactId=$Id])[1]"/> 		<!-- Only one, the first found -->
		<xsl:apply-templates select="../mstns:Notes">
			<xsl:with-param name="currentContactId" select="$Id"/>
		</xsl:apply-templates>
		<xsl:text>END:VCARD&#xA;</xsl:text>
	</xsl:template>
	
	<xsl:template match="mstns:Notes">
		<xsl:param name="currentContactId"/>
		<xsl:variable name="contactId" select="mstns:ContactId"/>
		<xsl:if test="$currentContactId=$contactId">
			<xsl:text>NOTE;CHARSET=UTF-8;ENCODING=QUOTED-PRINTABLE:</xsl:text>
			<!-- java extension for encoding -->
			<xsl:variable name="noteContent" select="mstns:Value"/>
			<xsl:value-of select="java:QuotedPrintableEncoder.robustEncode(string($noteContent))"/>
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mstns:Address">
		<xsl:param name="currentContactId"/>
		<xsl:variable name="contactId" select="mstns:ContactId"/>
		<xsl:if test="$currentContactId=$contactId">
			<xsl:text>ADR;</xsl:text>
			<xsl:variable name="label" select="mstns:Name"/>
			<xsl:value-of select="translate(string($label), '&#58;&#xA;&#xD;', ' ')"/>		<!-- remove ":" and line brakes -->
			<xsl:text>:</xsl:text>
			<xsl:variable name="address" select="mstns:Address"/>
			<xsl:value-of select="translate(string($address), '&#58;', ' ')"/>				<!-- remove ":" -->
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mstns:PhoneNumbers">
		<xsl:param name="currentContactId"/>
		<xsl:variable name="contactId" select="mstns:ContactId"/>
		<xsl:if test="$currentContactId=$contactId">
			<xsl:text>TEL;</xsl:text>
			<xsl:variable name="phoneLabel" select="mstns:Name"/>
			<xsl:value-of select="translate(string($phoneLabel), '&#58;&#xA;&#xD;', ' ')"/>	<!-- remove ":" and line brakes -->
			<xsl:text>:</xsl:text>
			<xsl:variable name="phoneData" select="mstns:Value"/>
			<xsl:value-of select="translate(string($phoneData), '&#58;&#xA;&#xD;', ' ')"/>	<!-- remove ":" and line brakes -->
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mstns:Emails">
		<xsl:param name="currentContactId"/>
		<xsl:variable name="contactId" select="mstns:ContactId"/>
		<xsl:if test="$currentContactId=$contactId">
			<xsl:text>EMAIL;</xsl:text>
			<xsl:variable name="label" select="mstns:Name"/>
			<xsl:value-of select="translate(string($label), '&#58;&#xA;&#xD;', ' ')"/>		<!-- remove ":" and line brakes -->
			<xsl:text>:</xsl:text>
			<xsl:variable name="mailAddress" select="mstns:Value"/>
			<xsl:value-of select="translate(string($mailAddress), '&#58;&#xA;&#xD;', ' ')"/>	<!-- remove ":" and line brakes -->
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mstns:WebSites">
		<xsl:param name="currentContactId"/>
		<xsl:variable name="contactId" select="mstns:ContactId"/>
		<xsl:if test="$currentContactId=$contactId">
			<xsl:text>URL:</xsl:text>
			<xsl:value-of select="mstns:Value"/>
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mstns:Organizations">
		<xsl:text>ORG:</xsl:text>
		<xsl:value-of select="mstns:Company"/>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
	<xsl:template match="mstns:NickNames">
		<xsl:text>X-ANDROID-CUSTOM:vnd.android.cursor.item/nickname;</xsl:text>
		<xsl:value-of select="mstns:Value"/>
		<xsl:text>;1;;;;;;;;;;;;;</xsl:text>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
	<xsl:template match="mstns:PictureImage">
		<xsl:text>PHOTO;ENCODING=BASE64;JPEG:</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
	<xsl:template match="mstns:FullName">
		<xsl:text>FN:</xsl:text>
		<xsl:variable name="fullName" select="."/>			
		<xsl:value-of select="translate(string($fullName), '&#58;&#xA;&#xD;', ' ')"/>	<!-- remove ":" and line brakes -->
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>
