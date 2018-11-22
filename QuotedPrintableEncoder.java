/**
 * Evaluating org.apache.commons.codec.net.QuotedPrintableCodec
 * @author Antonio Cacho, ajsccacho@gmail.com
 */
import java.nio.charset.Charset;
import org.apache.commons.codec.net.QuotedPrintableCodec;
import org.apache.commons.codec.Charsets;
import org.apache.commons.codec.EncoderException;
import org.apache.commons.codec.DecoderException;
import java.lang.ArrayIndexOutOfBoundsException;

public class QuotedPrintableEncoder {
	
	/** If coded text contains newline characters */
	static final boolean MULTILINE= false;
	
	/** The character set is fixed */
	static final Charset CHARSET= Charsets.UTF_8;
	
	/** the codec engine is instantiated up-front for efficient servicing of repeated requests */
	private static final QuotedPrintableCodec codec= new QuotedPrintableCodec(CHARSET, MULTILINE);

	/** basic self-testing */
	public static final void main( String[] args ) {
		String plainText="CCidadão 6 11 6ZY7, (evitar Paracetamol).\n\n  correção fossa nasal direita.";
		String knownEncd=
		    "CCidad=C3=A3o 6 11 6ZY7, (evitar Paracetamol).=0D=0A=0D=0A  corre=C3=A7=C3=A3o fossa nasal direita.";
		String codedTest= robustEncode(plainText);
		System.out.println("known encoding:   [" + knownEncd + "]");
		System.out.println("encode(plainText):[" + codedTest + "]");
		try{
			System.out.println("plainText:                [" + plainText + "]");
			System.out.println("decode(encode(plainText)):[" + codec.decode(codedTest) + "]");
		} catch(DecoderException e) { e.printStackTrace(); }
		System.out.println("\ntrying to fail:[" + robustEncode( "" ) + "]");
	}
	
	/**
	 * 	Handles the exceptions eventually resulting from encoding 
	 */
	public static final String robustEncode( final String arg ) {
		String result;
		try{
			result= codec.encode(arg);
		} catch(EncoderException e) {
			result= e.toString();
		} catch(ArrayIndexOutOfBoundsException e) {
			result= "Error: possibly encoding a void string, leading to " + e.toString();
		}
		return result;		
	}
}
