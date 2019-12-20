package
{
	import com.lessrain.puremvc.assets.model.vo.ILoadableFont;

	import flash.display.Sprite;

	public class FontArialBold extends Sprite implements ILoadableFont 	{
		/* 
		 * Defining character range of an embedded font
		 * see also
		 * http://livedocs.macromedia.com/flex/2/docs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000792.html
		 * http://livedocs.macromedia.com/flex/2/docs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000970.html
		 * http://www.unicode.org/charts/
		 * 
		 * Punctuation, Numbers and Symbols
		 * U+0020-U+0040
		 * Upper-Case A-Z
		 * U+0041-U+005A
		 * Punctuation and Symbols
		 * U+005B-U+0060
		 * Lower-Case a-z
		 * U+0061-U+007A
		 * Punctuation and Symbols
		 * U+007B-U+007F
		 *
		 * Control characters and basic latin (same than the above in one line)
		 * Should always be included
		 * U+0020-U+007F
		 * 
		 * Latin-1 supplement
		 * Should be included for general western encoding, contains signs (pound, cent etc), umlauts and accents 
		 * U+0080-U+00FF
		 * 
		 * Latin Extended-A
		 * Should be included for East European and Turkish encodings
		 * U+0100-U+017F
		 * 
		 * Greek Basic + Extended-A
		 * U+0370-U+03FF
		 * U+1F00-U+1FFF
		 * 
		 * Cyrillic Basic + Supplement
		 * U+0400-U+04FF
		 * U+0500-U+052F
		 * 
		 * Hebrew
		 * U+0590-U+05FF
		 * 
		 * Arabic
		 * U+0600-U+06FF
		 */
		[Embed(source="../../assets/fonts/Arial Bold.ttf", fontName="Arial Bold", fontWeight= "bold", mimeType="application/x-font", unicodeRange="U+0020-U+007F,U+0080-U+00FF")]
		private var _loadedFont : Class;
		public function getFontClass() : Class 		{
			return _loadedFont;
		}
	}
}
