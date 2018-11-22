# Vcard-from-wondershare-backups
Convert to standard vcard format the phone backups made by the Wondershare app for Android 4.1.2, so it could be imported elsewhere.
As of Android 4.1.2 the Wondershare phone backup app produced xml files which couldn't be imported by most contacts management applications, such as Android's 4.4 kitkat.
This conversion from the 'old' Wondershare Contact.contact xml file to vcard format is done by the stylesheet Wondershare2Vcard.xsl, assisted by the QuotedPrintableEncoder java class.
The assisting java code encodes standard quoted printable text from non-trivially formatted text blocks, for instance with accented characters or consecutive paragraphs, as required by the vcard format standard.
