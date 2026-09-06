/**
 * This class is a part of the KissAs3Fw ActionScript framework.
 * See the header comment lines of the
 * com.kisscodesystems.KissAs3Fw.Application
 * The whole framework is available at:
 * https://github.com/kisscodesystems/KissAs3Fw
 * Demo applications:
 * https://github.com/kisscodesystems/KissAs3Dm
 *
 * DESCRIPTION:
 * CryptoUnitTest
 * Checks the Crypto of the framework.
 *
 * MAIN FEATURES:
 * - the hash and the hmac are checked against the digests published for them, the ones of
 *   fips 180-4 and the ones of rfc 4231: a hash answering anything else than those is a
 *   wrong hash, however well the enciphering built on top of it seems to work
 * - the messages hashed here stand on both sides of the padding: one that is shorter than
 *   one block, one that fills a block up and one that is longer than a single block
 * - the enciphering is checked the way it is used: a value goes in, the payload of it
 *   comes out and that payload gives the very same value back
 * - and it is checked the way it is attacked as well: a payload of another secret, a
 *   payload one byte of which has been rewritten and a payload that is far too short are
 *   all answered as unreadable, never as a value
 */
package com.kisscodesystems.KissAs3Fw.suite
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import com.kisscodesystems.KissAs3Fw.util.Crypto;
  import com.kisscodesystems.KissAs3Ut.BaseUnitTest;
  import com.kisscodesystems.KissAs3Ut.UnitTestReport;
  import flash.utils.ByteArray;
  public class CryptoUnitTest extends BaseUnitTest
  {
    // the secret the enciphering of this suite works with, and another one that must
    // never open a payload written with the first
    private const SECRET:String = "the secret of this very suite";
    private const OTHER_SECRET:String = "the secret of this very suite ";
    // the shortest payload of the framework: the nonce of sixteen bytes and the tag of
    // thirty-two, with nothing at all standing between them
    private const SHORTEST_PAYLOAD_LENGTH:int = 48;
    private var crypto:Crypto = null;
    /**
     * Constructs the suite.
     * @param applicationRef the main application reference
     * @param reportRef the report every assertion result goes into
     */
    public function CryptoUnitTest(applicationRef:Application, reportRef:UnitTestReport):void
    {
      super(applicationRef, reportRef);
    }
    /**
     * Returns the name of this suite.
     */
    override public function getName():String
    {
      return "Crypto";
    }
    /**
     * Runs the assertions of this suite.
     */
    override public function run():void
    {
      crypto = new Crypto(application);
      runHashTests();
      runHmacTests();
      runHexTests();
      runEncryptionTests();
      crypto.destroy();
      crypto = null;
    }
    /**
     * Checks the hash against the digests published in fips 180-4.
     */
    protected function runHashTests():void
    {
      assertEquals("the digest of the empty message is the published one"
        , "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        , hashOf(""));
      assertEquals("the digest of abc is the published one"
        , "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
        , hashOf("abc"));
      // this message is fifty-six bytes long, so the length of it does not fit into the
      // block it stands in: the padding of it takes one more whole block
      assertEquals("the digest of the message filling one block up is the published one"
        , "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1"
        , hashOf("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"));
      // and this one is a hundred and twelve bytes long, so it is hashed in three blocks
      assertEquals("the digest of the message longer than one block is the published one"
        , "cf5b16a778af8380036ce59e7b0492370b249b11e8f07a51afac45037afee9d1"
        , hashOf("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"));
      const digest:ByteArray = crypto.sha256(crypto.stringToBytes("abc"));
      assertEquals("the digest is thirty-two bytes long", 32, digest.length);
      assertEquals("the digest is handed out at its beginning", 0, digest.position);
      digest.clear();
      // the message handed over is read only: hashing it twice gives the same digest
      const message:ByteArray = crypto.stringToBytes("abc");
      message.position = 2;
      const first:String = crypto.bytesToHex(crypto.sha256(message));
      const second:String = crypto.bytesToHex(crypto.sha256(message));
      assertEquals("the same message gives the same digest again", first, second);
      assertEquals("the message is left at the position it has been handed over at"
        , 2, message.position);
      message.clear();
      assertEquals("the digest of nothing at all is an empty answer", 0
        , crypto.sha256(null).length);
    }
    /**
     * Checks the hmac against the digests published in rfc 4231.
     */
    protected function runHmacTests():void
    {
      // the first case: a key of twenty bytes, every one of them the same
      const key1:ByteArray = repeatedBytes(0x0B, 20);
      assertEquals("the hmac of the first published case is the published one"
        , "b0344c61d8db38535ca8afceaf0bf12b881dc200c9833da726e9376c2e32cff7"
        , crypto.bytesToHex(crypto.hmacSha256(key1, crypto.stringToBytes("Hi There"))));
      key1.clear();
      // the second case: a key that is four bytes long only
      const key2:ByteArray = crypto.stringToBytes("Jefe");
      assertEquals("the hmac of the second published case is the published one"
        , "5bdcc146bf60754e6a042426089575c75a003f089d2739839dec58b964ec3843"
        , crypto.bytesToHex(crypto.hmacSha256(key2
          , crypto.stringToBytes("what do ya want for nothing?"))));
      key2.clear();
      // the sixth case: a key of a hundred and thirty-one bytes, so a key that is longer
      // than one block and that is hashed down before it is used
      const key6:ByteArray = repeatedBytes(0xAA, 131);
      assertEquals("the hmac of the case with the key longer than one block is the published one"
        , "60e431591ee0b67f0d8a26aacbf5b77f8e0bc6213728c5140546040f0ee37f54"
        , crypto.bytesToHex(crypto.hmacSha256(key6
          , crypto.stringToBytes("Test Using Larger Than Block-Size Key - Hash Key First"))));
      key6.clear();
      const key:ByteArray = crypto.stringToBytes(SECRET);
      const message:ByteArray = crypto.stringToBytes("the message of this assertion");
      assertEquals("the hmac is thirty-two bytes long", 32
        , crypto.hmacSha256(key, message).length);
      assertEquals("the hmac of nothing at all is an empty answer", 0
        , crypto.hmacSha256(null, message).length);
      assertEquals("the hmac of no message at all is an empty answer", 0
        , crypto.hmacSha256(key, null).length);
      key.clear();
      message.clear();
    }
    /**
     * Checks the writing of the bytes as a hexadecimal string and the reading of them
     * back, the two halves of the same helper.
     */
    protected function runHexTests():void
    {
      const bytes:ByteArray = new ByteArray();
      bytes.writeByte(0x00);
      bytes.writeByte(0x0F);
      bytes.writeByte(0xF0);
      bytes.writeByte(0xFF);
      assertEquals("the bytes are written as a hexadecimal string", "000ff0ff"
        , crypto.bytesToHex(bytes));
      assertTrue("the string gives the very same bytes back"
        , crypto.bytesEqual(bytes, crypto.hexToBytes("000ff0ff")));
      assertTrue("an uppercase string gives those bytes as well"
        , crypto.bytesEqual(bytes, crypto.hexToBytes("000FF0FF")));
      bytes.clear();
      assertEquals("a string of an odd length gives no bytes at all", 0
        , crypto.hexToBytes("000").length);
      assertEquals("a string holding a character that is not a hexadecimal one gives no bytes at all"
        , 0, crypto.hexToBytes("00zz").length);
      assertEquals("no string at all gives no bytes at all", 0, crypto.hexToBytes(null).length);
      assertEquals("no bytes at all are written as an empty string", "", crypto.bytesToHex(null));
      // the two comparing rules: the length and every byte of the two
      const bytes1:ByteArray = crypto.hexToBytes("0102");
      const bytes2:ByteArray = crypto.hexToBytes("0103");
      const bytes3:ByteArray = crypto.hexToBytes("010203");
      assertTrue("the same bytes are equal", crypto.bytesEqual(bytes1, crypto.hexToBytes("0102")));
      assertFalse("bytes differing in one byte are not equal", crypto.bytesEqual(bytes1, bytes2));
      assertFalse("bytes of another length are not equal", crypto.bytesEqual(bytes1, bytes3));
      assertFalse("bytes and nothing at all are not equal", crypto.bytesEqual(bytes1, null));
      bytes1.clear();
      bytes2.clear();
      bytes3.clear();
      // the text of the bytes and the bytes of the text are the two halves of one helper
      assertEquals("the bytes of a text give that very text back", "árvíztűrő tükörfúrógép"
        , crypto.bytesToString(crypto.stringToBytes("árvíztűrő tükörfúrógép")));
      assertEquals("no bytes at all give an empty text", "", crypto.bytesToString(null));
      assertEquals("no text at all gives no bytes at all", 0, crypto.stringToBytes(null).length);
    }
    /**
     * Checks the enciphering: the way it is used and the way it is attacked alike.
     */
    protected function runEncryptionTests():void
    {
      const value:String = "a value that is kept on the device";
      const plain:ByteArray = crypto.stringToBytes(value);
      const payload:ByteArray = crypto.encrypt(plain, SECRET);
      assertTrue("the payload is longer than the nonce and the tag together"
        , payload.length > SHORTEST_PAYLOAD_LENGTH);
      assertEquals("the payload carries the nonce, the value and the tag"
        , SHORTEST_PAYLOAD_LENGTH + plain.length, payload.length);
      assertEquals("the payload is handed out at its beginning", 0, payload.position);
      assertEquals("the payload gives the very same value back", value
        , crypto.bytesToString(crypto.decrypt(payload, SECRET)));
      // the value itself never stands in the payload: it is enciphered in it
      assertTrue("the payload holds the value nowhere"
        , crypto.bytesToHex(payload).indexOf(crypto.bytesToHex(plain)) < 0);
      // every payload carries a nonce of its own, so the same value never looks the same
      const otherPayload:ByteArray = crypto.encrypt(plain, SECRET);
      assertFalse("the same value enciphered again gives another payload"
        , crypto.bytesEqual(payload, otherPayload));
      assertEquals("that other payload gives the same value back", value
        , crypto.bytesToString(crypto.decrypt(otherPayload, SECRET)));
      otherPayload.clear();
      // the empty value is a value as well: it gives the shortest payload of the framework
      const emptyPayload:ByteArray = crypto.encrypt(crypto.stringToBytes(""), SECRET);
      assertEquals("the payload of the empty value is the shortest one"
        , SHORTEST_PAYLOAD_LENGTH, emptyPayload.length);
      assertEquals("the payload of the empty value gives the empty value back", ""
        , crypto.bytesToString(crypto.decrypt(emptyPayload, SECRET)));
      emptyPayload.clear();
      // a value longer than one block of the keystream is enciphered block by block
      const longValue:String = repeatedText("the quick brown fox jumps over the lazy dog. ", 10);
      const longPayload:ByteArray = crypto.encrypt(crypto.stringToBytes(longValue), SECRET);
      assertEquals("a value longer than one block gives that very value back", longValue
        , crypto.bytesToString(crypto.decrypt(longPayload, SECRET)));
      longPayload.clear();
      // and the three ways a payload fails: another secret, a rewritten byte, a short one
      assertNull("another secret opens the payload not at all"
        , crypto.decrypt(payload, OTHER_SECRET));
      const rewritten:ByteArray = new ByteArray();
      rewritten.writeBytes(payload, 0, payload.length);
      rewritten[SHORTEST_PAYLOAD_LENGTH / 2] = rewritten[SHORTEST_PAYLOAD_LENGTH / 2] ^ 0x01;
      assertNull("a payload one byte of which has been rewritten is not opened at all"
        , crypto.decrypt(rewritten, SECRET));
      rewritten.clear();
      const tagRewritten:ByteArray = new ByteArray();
      tagRewritten.writeBytes(payload, 0, payload.length);
      tagRewritten[tagRewritten.length - 1] = tagRewritten[tagRewritten.length - 1] ^ 0x01;
      assertNull("a payload the tag of which has been rewritten is not opened at all"
        , crypto.decrypt(tagRewritten, SECRET));
      tagRewritten.clear();
      const tooShort:ByteArray = new ByteArray();
      tooShort.writeBytes(payload, 0, SHORTEST_PAYLOAD_LENGTH - 1);
      assertNull("a payload shorter than the shortest one is not opened at all"
        , crypto.decrypt(tooShort, SECRET));
      tooShort.clear();
      assertNull("nothing at all is not opened at all", crypto.decrypt(null, SECRET));
      assertEquals("nothing at all is enciphered as an empty payload", 0
        , crypto.encrypt(null, SECRET).length);
      plain.clear();
      payload.clear();
      // the random bytes: the number asked for and nothing when nothing is asked for
      const random:ByteArray = crypto.randomBytes(16);
      assertEquals("the random bytes are as many as they have been asked for", 16, random.length);
      assertFalse("the random bytes are other ones every time"
        , crypto.bytesEqual(random, crypto.randomBytes(16)));
      random.clear();
      assertEquals("no random bytes are asked for, none are given", 0, crypto.randomBytes(0).length);
    }
    /**
     * Returns the digest of the given text as a hexadecimal string.
     * @param text the text to be hashed
     */
    private function hashOf(text:String):String
    {
      const message:ByteArray = crypto.stringToBytes(text);
      const digest:ByteArray = crypto.sha256(message);
      const hex:String = crypto.bytesToHex(digest);
      message.clear();
      digest.clear();
      return hex;
    }
    /**
     * Returns the given byte repeated the given number of times.
     * @param oneByte the byte to be repeated
     * @param count the number of the bytes asked for
     */
    private function repeatedBytes(oneByte:int, count:int):ByteArray
    {
      const bytes:ByteArray = new ByteArray();
      for (var i:int = 0; i < count; i++)
      {
        bytes.writeByte(oneByte);
      }
      bytes.position = 0;
      return bytes;
    }
    /**
     * Returns the given text repeated the given number of times.
     * @param text the text to be repeated
     * @param count the number of the repetitions asked for
     */
    private function repeatedText(text:String, count:int):String
    {
      var repeated:String = "";
      for (var i:int = 0; i < count; i++)
      {
        repeated += text;
      }
      return repeated;
    }
    /**
     * Frees everything this suite holds.
     */
    override public function destroy():void
    {
      // 1: unregister every event listener added to a dispatcher other than local_var.getBaseEventDispatcher()
      // 2: stopImmediatePropagation, bitmapData.dispose(), array.splice(0), etc.
      if (crypto != null)
      {
        crypto.destroy();
      }
      // 3: call the super destroy.
      super.destroy();
      // 4: every reference and value should be reset to null, 0 or false.
      crypto = null;
    }
  }
}
