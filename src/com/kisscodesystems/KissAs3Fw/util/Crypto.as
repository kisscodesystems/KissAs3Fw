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
 * Crypto.
 * The hashing and the enciphering of the framework: sha-256, hmac-sha-256 and the
 * enciphering of a short value that is kept on the device the application runs on.
 *
 * MAIN FEATURES:
 * - the runtime brings no hash and no cipher of any kind, so both of them stand here:
 *   sha-256 as it is written in fips 180-4 and hmac-sha-256 as it is written in rfc 2104
 * - the enciphering is the hmac of a nonce used as a keystream the value is xored with,
 *   so a value of any length is enciphered without a padding of any kind, and the whole
 *   of it is signed with one more hmac, the tag: a payload that has been rewritten by
 *   anyone fails that tag and is answered as unreadable instead of as a wrong value
 *   (this is the counter mode of a block cipher, with the hmac standing as that block)
 * - the key of both of those is the sha-256 of the secret handed over, so a secret of any
 *   length gives the 32 bytes they work with
 * - every payload carries the nonce it has been written with, so the very same value
 *   enciphered twice gives two payloads that look nothing like each other
 * - THE SECRET OF AN APPLICATION LIVES INSIDE THAT APPLICATION, so anyone taking the
 *   binary apart can read it out and decipher the payloads written with it: this class
 *   keeps a value out of the reach of the ones looking at the files of the device, it
 *   does not keep it out of the reach of the ones taking the application itself apart
 */
package com.kisscodesystems.KissAs3Fw.util
{
  import com.kisscodesystems.KissAs3Fw.Application;
  import flash.crypto.generateRandomBytes;
  import flash.system.System;
  import flash.utils.ByteArray;
  public class Crypto
  {
    // the sizes sha-256 is built of: the digest it gives, the block it works on and the
    // number of the rounds one block is taken through
    private const HASH_BYTES:int = 32;
    private const BLOCK_BYTES:int = 64;
    private const ROUNDS:int = 64;
    // the two paddings of the hmac, standing on every byte of the block
    private const IPAD:uint = 0x36;
    private const OPAD:uint = 0x5C;
    // the length of the nonce every enciphered payload begins with
    private const NONCE_BYTES:int = 16;
    // the first 32 bits of the fractional parts of the square roots of the first eight
    // primes: the state sha-256 starts from
    private const INITIAL_STATE:Vector.<uint> = new <uint>[
      0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A
      , 0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19];
    // the first 32 bits of the fractional parts of the cube roots of the first sixty-four
    // primes: the constant of every round of sha-256
    private const ROUND_CONSTANTS:Vector.<uint> = new <uint>[
      0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5, 0x3956C25B, 0x59F111F1, 0x923F82A4, 0xAB1C5ED5
      , 0xD807AA98, 0x12835B01, 0x243185BE, 0x550C7DC3, 0x72BE5D74, 0x80DEB1FE, 0x9BDC06A7, 0xC19BF174
      , 0xE49B69C1, 0xEFBE4786, 0x0FC19DC6, 0x240CA1CC, 0x2DE92C6F, 0x4A7484AA, 0x5CB0A9DC, 0x76F988DA
      , 0x983E5152, 0xA831C66D, 0xB00327C8, 0xBF597FC7, 0xC6E00BF3, 0xD5A79147, 0x06CA6351, 0x14292967
      , 0x27B70A85, 0x2E1B2138, 0x4D2C6DFC, 0x53380D13, 0x650A7354, 0x766A0ABB, 0x81C2C92E, 0x92722C85
      , 0xA2BFE8A1, 0xA81A664B, 0xC24B8B70, 0xC76C51A3, 0xD192E819, 0xD6990624, 0xF40E3585, 0x106AA070
      , 0x19A4C116, 0x1E376C08, 0x2748774C, 0x34B0BCB5, 0x391C0CB3, 0x4ED8AA4A, 0x5B9CCA4F, 0x682E6FF3
      , 0x748F82EE, 0x78A5636F, 0x84C87814, 0x8CC70208, 0x90BEFFFA, 0xA4506CEB, 0xBEF9A3F7, 0xC67178F2];
    // the characters one byte is written with when it is turned into a hexadecimal string
    private const HEX_CHARACTERS:String = "0123456789abcdef";
    protected var application:Application = null;
    /**
     * Constructs the cryptography helper, exiting if no application reference is given.
     * @param applicationRef the application reference used for logging
     */
    public function Crypto(applicationRef:Application):void
    {
      super();
      if (applicationRef != null)
      {
        application = applicationRef;
      }
      else
      {
        System.exit(1);
      }
      application.trace("<" + this + " Crypto> called.", 1);
      application.trace("<" + this + " Crypto> applicationRef: " + applicationRef, 0);
      application.trace("<" + this + " Crypto> constructed.", 1);
    }
    /**
     * Returns the sha-256 digest of the given bytes, the 32 bytes of it. The bytes handed
     * over are left as they are, the position of that byte array included.
     * @param message the bytes to be hashed
     * @return the digest, an empty byte array when no bytes have been given
     */
    public function sha256(message:ByteArray):ByteArray
    {
      application.trace("<" + this + " Crypto sha256> called.", 1);
      const digest:ByteArray = new ByteArray();
      if (message == null)
      {
        application.trace("<" + this + " Crypto sha256> there are no bytes to hash!", 6);
        return digest;
      }
      // the message is padded to whole blocks: one bit standing alone, then the zeros and
      // the length of the message in bits, as the last eight bytes of the last block
      const padded:ByteArray = new ByteArray();
      padded.writeBytes(message, 0, message.length);
      padded.writeByte(0x80);
      while (padded.length % BLOCK_BYTES != BLOCK_BYTES - 8)
      {
        padded.writeByte(0);
      }
      padded.writeUnsignedInt(uint(message.length) >>> 29);
      padded.writeUnsignedInt(uint(message.length) << 3);
      const state:Vector.<uint> = INITIAL_STATE.concat();
      const schedule:Vector.<uint> = new Vector.<uint>(ROUNDS, true);
      padded.position = 0;
      while (padded.position < padded.length)
      {
        hashOneBlock(padded, state, schedule);
      }
      for (var i:int = 0; i < state.length; i++)
      {
        digest.writeUnsignedInt(state[i]);
      }
      padded.clear();
      digest.position = 0;
      return digest;
    }
    /**
     * Returns the hmac-sha-256 of the given message, the 32 bytes of it: the digest of
     * the message and of the key together, the way rfc 2104 writes it.
     * @param key the key of the hmac, of any length
     * @param message the bytes the hmac is taken of
     * @return the hmac, an empty byte array when the key or the message is missing
     */
    public function hmacSha256(key:ByteArray, message:ByteArray):ByteArray
    {
      application.trace("<" + this + " Crypto hmacSha256> called.", 1);
      if (key == null || message == null)
      {
        application.trace("<" + this + " Crypto hmacSha256> the key or the message is not there!", 6);
        return new ByteArray();
      }
      // a key longer than one block is hashed down to its digest, a shorter one is filled
      // up with zeros: the hmac works on one block of a key either way
      const blockKey:ByteArray = new ByteArray();
      if (key.length > BLOCK_BYTES)
      {
        const hashedKey:ByteArray = sha256(key);
        blockKey.writeBytes(hashedKey, 0, hashedKey.length);
        hashedKey.clear();
      }
      else
      {
        blockKey.writeBytes(key, 0, key.length);
      }
      while (blockKey.length < BLOCK_BYTES)
      {
        blockKey.writeByte(0);
      }
      const inner:ByteArray = new ByteArray();
      const outer:ByteArray = new ByteArray();
      for (var i:int = 0; i < BLOCK_BYTES; i++)
      {
        inner.writeByte(blockKey[i] ^ IPAD);
        outer.writeByte(blockKey[i] ^ OPAD);
      }
      inner.writeBytes(message, 0, message.length);
      const innerHash:ByteArray = sha256(inner);
      outer.writeBytes(innerHash, 0, innerHash.length);
      const hmac:ByteArray = sha256(outer);
      blockKey.clear();
      inner.clear();
      outer.clear();
      innerHash.clear();
      return hmac;
    }
    /**
     * Enciphers the given bytes with the given secret and answers the payload that can be
     * written anywhere: the nonce of it, the enciphered bytes and the tag signing both.
     * @param plain the bytes to be enciphered
     * @param secret the secret the key is taken from
     * @return the payload, an empty byte array when there is nothing to encipher
     */
    public function encrypt(plain:ByteArray, secret:String):ByteArray
    {
      application.trace("<" + this + " Crypto encrypt> called.", 1);
      const payload:ByteArray = new ByteArray();
      if (plain == null || secret == null)
      {
        application.trace("<" + this + " Crypto encrypt> there is nothing to encipher!", 6);
        return payload;
      }
      const key:ByteArray = keyOfSecret(secret);
      const nonce:ByteArray = randomBytes(NONCE_BYTES);
      const enciphered:ByteArray = xorWithKeystream(plain, key, nonce);
      payload.writeBytes(nonce, 0, nonce.length);
      payload.writeBytes(enciphered, 0, enciphered.length);
      const tag:ByteArray = tagOfPayload(key, nonce, enciphered);
      payload.writeBytes(tag, 0, tag.length);
      key.clear();
      nonce.clear();
      enciphered.clear();
      tag.clear();
      payload.position = 0;
      return payload;
    }
    /**
     * Deciphers a payload written by the encrypt above. The answer is null when that
     * payload is not one of this class, when it has been rewritten by anyone or when the
     * secret is another one: a value that cannot be trusted is no value at all.
     * @param payload the payload to be deciphered
     * @param secret the secret the key is taken from
     * @return the deciphered bytes, null when the payload cannot be trusted
     */
    public function decrypt(payload:ByteArray, secret:String):ByteArray
    {
      application.trace("<" + this + " Crypto decrypt> called.", 1);
      if (payload == null || secret == null)
      {
        application.trace("<" + this + " Crypto decrypt> there is nothing to decipher!", 6);
        return null;
      }
      if (payload.length < NONCE_BYTES + HASH_BYTES)
      {
        application.trace("<" + this + " Crypto decrypt> the payload is a shorter one than the shortest payload of this class!", 6);
        return null;
      }
      const key:ByteArray = keyOfSecret(secret);
      const nonce:ByteArray = new ByteArray();
      const enciphered:ByteArray = new ByteArray();
      const tag:ByteArray = new ByteArray();
      nonce.writeBytes(payload, 0, NONCE_BYTES);
      enciphered.writeBytes(payload, NONCE_BYTES, payload.length - NONCE_BYTES - HASH_BYTES);
      tag.writeBytes(payload, payload.length - HASH_BYTES, HASH_BYTES);
      const expectedTag:ByteArray = tagOfPayload(key, nonce, enciphered);
      const trusted:Boolean = bytesEqual(tag, expectedTag);
      var plain:ByteArray = null;
      if (trusted)
      {
        plain = xorWithKeystream(enciphered, key, nonce);
      }
      else
      {
        application.trace("<" + this + " Crypto decrypt> the tag of the payload is another one, so it cannot be trusted!", 6);
      }
      key.clear();
      nonce.clear();
      enciphered.clear();
      tag.clear();
      expectedTag.clear();
      return plain;
    }
    /**
     * Returns the given number of random bytes, the ones the runtime gives.
     * @param count the number of the bytes asked for
     * @return the random bytes, an empty byte array when nothing has been asked for
     */
    public function randomBytes(count:int):ByteArray
    {
      application.trace("<" + this + " Crypto randomBytes> called.", 1);
      application.trace("<" + this + " Crypto randomBytes> count: " + count, 0);
      if (count <= 0)
      {
        return new ByteArray();
      }
      return generateRandomBytes(count);
    }
    /**
     * Returns the given text as the bytes of it, written in utf-8.
     * @param text the text to be written
     * @return the bytes of that text, an empty byte array when there is no text
     */
    public function stringToBytes(text:String):ByteArray
    {
      const bytes:ByteArray = new ByteArray();
      if (text != null)
      {
        bytes.writeUTFBytes(text);
      }
      bytes.position = 0;
      return bytes;
    }
    /**
     * Returns the given bytes as the utf-8 text they are written with.
     * @param bytes the bytes to be read
     * @return the text of those bytes, the empty string when there are none
     */
    public function bytesToString(bytes:ByteArray):String
    {
      if (bytes == null || bytes.length == 0)
      {
        return "";
      }
      bytes.position = 0;
      return bytes.readUTFBytes(bytes.length);
    }
    /**
     * Returns the given bytes as a hexadecimal string, two lowercase characters standing
     * for every one of them.
     * @param bytes the bytes to be written
     * @return the hexadecimal string, the empty string when there are no bytes
     */
    public function bytesToHex(bytes:ByteArray):String
    {
      if (bytes == null)
      {
        return "";
      }
      var hex:String = "";
      for (var i:int = 0; i < bytes.length; i++)
      {
        hex += HEX_CHARACTERS.charAt((bytes[i] >>> 4) & 0x0F) + HEX_CHARACTERS.charAt(bytes[i] & 0x0F);
      }
      return hex;
    }
    /**
     * Returns the bytes of the given hexadecimal string. The answer is empty when that
     * string holds anything other than an even number of hexadecimal characters.
     * @param hex the hexadecimal string to be read
     * @return the bytes of that string, an empty byte array when it cannot be read
     */
    public function hexToBytes(hex:String):ByteArray
    {
      const bytes:ByteArray = new ByteArray();
      if (hex == null || hex.length == 0 || hex.length % 2 != 0)
      {
        return bytes;
      }
      const lowercaseHex:String = hex.toLowerCase();
      for (var i:int = 0; i < lowercaseHex.length; i += 2)
      {
        const high:int = HEX_CHARACTERS.indexOf(lowercaseHex.charAt(i));
        const low:int = HEX_CHARACTERS.indexOf(lowercaseHex.charAt(i + 1));
        if (high < 0 || low < 0)
        {
          application.trace("<" + this + " Crypto hexToBytes> the string holds a character that is not a hexadecimal one!", 6);
          bytes.clear();
          return bytes;
        }
        bytes.writeByte((high << 4) | low);
      }
      bytes.position = 0;
      return bytes;
    }
    /**
     * Tells whether the two given byte arrays hold the very same bytes. Every byte of
     * them is looked at, the answer of an equal length never tells where the difference
     * stands: the ones measuring the time of this call learn nothing from it.
     * @param bytes1 the one byte array
     * @param bytes2 the other byte array
     * @return true when the two hold the same bytes
     */
    public function bytesEqual(bytes1:ByteArray, bytes2:ByteArray):Boolean
    {
      if (bytes1 == null || bytes2 == null)
      {
        return false;
      }
      if (bytes1.length != bytes2.length)
      {
        return false;
      }
      var difference:int = 0;
      for (var i:int = 0; i < bytes1.length; i++)
      {
        difference |= bytes1[i] ^ bytes2[i];
      }
      return difference == 0;
    }
    /**
     * Returns the key the hashing and the enciphering work with: the digest of the given
     * secret, so a secret of any length gives the 32 bytes of a key.
     * @param secret the secret of the application
     * @return the 32 bytes of the key
     */
    protected function keyOfSecret(secret:String):ByteArray
    {
      const secretBytes:ByteArray = stringToBytes(secret);
      const key:ByteArray = sha256(secretBytes);
      secretBytes.clear();
      return key;
    }
    /**
     * Returns the given bytes xored with the keystream of the given key and nonce. The
     * enciphering and the deciphering are this very same call: xoring a second time with
     * the same keystream gives the bytes that have been handed over first.
     * @param bytes the bytes to be xored
     * @param key the key of the keystream
     * @param nonce the nonce of the keystream
     * @return the xored bytes
     */
    protected function xorWithKeystream(bytes:ByteArray, key:ByteArray, nonce:ByteArray):ByteArray
    {
      const xored:ByteArray = new ByteArray();
      // one block of the keystream is the hmac of the nonce and of the number of that
      // block, so the blocks of it are built one by one, as long as there are bytes left
      var counter:int = 0;
      var block:ByteArray = null;
      for (var i:int = 0; i < bytes.length; i++)
      {
        if (i % HASH_BYTES == 0)
        {
          if (block != null)
          {
            block.clear();
          }
          const counted:ByteArray = new ByteArray();
          counted.writeBytes(nonce, 0, nonce.length);
          counted.writeUnsignedInt(counter);
          block = hmacSha256(key, counted);
          counted.clear();
          counter++;
        }
        xored.writeByte(bytes[i] ^ block[i % HASH_BYTES]);
      }
      if (block != null)
      {
        block.clear();
      }
      xored.position = 0;
      return xored;
    }
    /**
     * Returns the tag signing an enciphered payload: the hmac of the nonce and of the
     * enciphered bytes together, so neither of the two can be rewritten unnoticed.
     * @param key the key of the hmac
     * @param nonce the nonce of the payload
     * @param enciphered the enciphered bytes of the payload
     * @return the 32 bytes of the tag
     */
    protected function tagOfPayload(key:ByteArray, nonce:ByteArray, enciphered:ByteArray):ByteArray
    {
      const tagged:ByteArray = new ByteArray();
      tagged.writeBytes(nonce, 0, nonce.length);
      tagged.writeBytes(enciphered, 0, enciphered.length);
      const tag:ByteArray = hmacSha256(key, tagged);
      tagged.clear();
      return tag;
    }
    /**
     * Takes the state of the hash through the block standing at the position of the given
     * bytes, and steps that position to the block coming after it.
     * @param padded the padded message, at the position of the block to be hashed
     * @param state the eight words of the state, rewritten by this call
     * @param schedule the sixty-four words of the schedule, rewritten by this call
     */
    private function hashOneBlock(padded:ByteArray, state:Vector.<uint>, schedule:Vector.<uint>):void
    {
      var i:int = 0;
      for (i = 0; i < 16; i++)
      {
        schedule[i] = padded.readUnsignedInt();
      }
      for (i = 16; i < ROUNDS; i++)
      {
        const sigma0:uint = rotateRight(schedule[i - 15], 7) ^ rotateRight(schedule[i - 15], 18) ^ (schedule[i - 15] >>> 3);
        const sigma1:uint = rotateRight(schedule[i - 2], 17) ^ rotateRight(schedule[i - 2], 19) ^ (schedule[i - 2] >>> 10);
        schedule[i] = (schedule[i - 16] + sigma0 + schedule[i - 7] + sigma1) >>> 0;
      }
      var a:uint = state[0];
      var b:uint = state[1];
      var c:uint = state[2];
      var d:uint = state[3];
      var e:uint = state[4];
      var f:uint = state[5];
      var g:uint = state[6];
      var h:uint = state[7];
      for (i = 0; i < ROUNDS; i++)
      {
        const sum1:uint = rotateRight(e, 6) ^ rotateRight(e, 11) ^ rotateRight(e, 25);
        const choice:uint = (e & f) ^ ((e ^ 0xFFFFFFFF) & g);
        const temp1:uint = (h + sum1 + choice + ROUND_CONSTANTS[i] + schedule[i]) >>> 0;
        const sum0:uint = rotateRight(a, 2) ^ rotateRight(a, 13) ^ rotateRight(a, 22);
        const majority:uint = (a & b) ^ (a & c) ^ (b & c);
        const temp2:uint = (sum0 + majority) >>> 0;
        h = g;
        g = f;
        f = e;
        e = (d + temp1) >>> 0;
        d = c;
        c = b;
        b = a;
        a = (temp1 + temp2) >>> 0;
      }
      state[0] = (state[0] + a) >>> 0;
      state[1] = (state[1] + b) >>> 0;
      state[2] = (state[2] + c) >>> 0;
      state[3] = (state[3] + d) >>> 0;
      state[4] = (state[4] + e) >>> 0;
      state[5] = (state[5] + f) >>> 0;
      state[6] = (state[6] + g) >>> 0;
      state[7] = (state[7] + h) >>> 0;
    }
    /**
     * Returns the given word rotated to the right by the given number of bits: the bits
     * falling out at the one end come back in at the other one.
     * @param word the thirty-two bits to be rotated
     * @param bits the number of the bits to rotate by
     * @return the rotated word
     */
    private function rotateRight(word:uint, bits:int):uint
    {
      return ((word >>> bits) | (word << (32 - bits))) >>> 0;
    }
    /**
     * Frees every reference held by this object.
     */
    public function destroy():void
    {
      application.trace("<" + this + " Crypto destroy> called.", 1);
      application = null;
    }
  }
}
