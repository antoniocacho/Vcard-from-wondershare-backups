# Vcard-from-wondershare-backups
Convert to standard vcard format the phone backups made by the Wondershare app for Android 4.1.2, so it could be imported elsewhere.
As of Android 4.1.2 the Wondershare phone backup app produced xml files which couldn't be imported by most contacts management applications, such as Android's 4.4 kitkat.
This conversion to vcard format from the 'old' Wondershare Contact.contact xml file, is done by the stylesheet Wondershare2Vcard.xsl, assisted by the QuotedPrintableEncoder java class.
The assisting java code encodes standard quoted printable text from non-trivially formatted text blocks, for instance with accented characters or consecutive paragraphs, as required by the vcard format standard.
The test file ContactsTest.xml is converted to ContactsTest._vcf. To import the later, one has to remove the underscore '_'. This underscore prevents the development computer to annoyingly try to commit such test data to the actual developer user contacts.
Another much, much larger and complex personal data-set was tested with good results.
