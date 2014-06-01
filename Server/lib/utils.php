<?php
date_default_timezone_set("America/Chicago");
	
$hostIP = $_SERVER['SERVER_ADDR'];
$publicHost = $hostIP;


/*
mb_language('uni');
mb_internal_encoding("UTF-8");
mb_http_output('UTF-8');
ob_start('mb_output_handler');
*/

// ===============================================================


function printArray($aArray)
{
	echo "<pre>";
	print_r($aArray);
	echo "</pre>";
}

// ===============================================================

function isDST(/* assumes "now" */)
{
	$result = false;
	if (date("T") == "CDT") $result = true;
	return $result;
}

// ===============================================================

function truncateSentence($sentence, $startIdx)
{
	// trim the sentence at the first space after specified position
	$sentenceLength = strlen($sentence);
	$spaceIdx = $startIdx;
	$continueLoop = true;
	$spaceFound = true;
	while ($continueLoop == true)
	{
		if ($spaceIdx >= $sentenceLength)
		{
			$continueLoop = false;
			$truncated = substr($sentence, 0, $sentenceLength);
		}
		if (substr($sentence, $spaceIdx, 1) == " ")
		{
			$continueLoop = false;
			$truncated = substr($sentence, 0, $spaceIdx) . "...";
		}
		if ($spaceIdx > ($startIdx + 16))
		{
			$continueLoop = false;
			$truncated = substr($sentence, 0, $startIdx) . "...";
		}
		$spaceIdx++;
	}
	return $truncated;
}

// ===============================================================

function trimElement($element)
{
	$result = strip_tags($element);
	$result = truncateSentence($result, 200);
	return $result;
}

// ===============================================================

function fixText($originalString)
{
	// equivalent ascii values of these characters.
	//`(96) ’(130) „(132) ‘(145) ’(146) “(147) ”(148) ´(180) 

/*
	$result = '';
	$s1 = iconv('UTF-8', 'ASCII//TRANSLIT', $originalString);

	$sourceEncoding = "ASCII";
	$t1 = iconv($sourceEncoding, 'utf-8', "`’„‘’´");
	$t2 = iconv($sourceEncoding, 'utf-8', "'','''");
	$t3 = iconv($sourceEncoding, 'utf-8', '“”');
	$t4 = iconv($sourceEncoding, 'utf-8', '""');

	for ($i = 0; $i < strlen($s1); $i++)
	{
		$ch1 = $s1[$i];
		$ch2 = mb_substr($s, $i, 1);
		$ch3 = $ch1=='?'?$ch2:$ch1;

		$ch3 = strtr($ch3, $t1, $t2);
		$ch3 = strtr($ch3, $t3, $t4); 
		
		$result .= $ch3;
	}
*/
	$result = $originalString;

	$t1 = "`’„‘’´";
	$t2 = "'','''";
	$t3 = '“”';
	$t4 = '""';

//	$result = strtr($result, $t1, $t2);
//	$result = strtr($result, $t3, $t4); 

	//$result = strtr($result, "\\", ""); 
	
	
	$result = str_replace("\n", " ", $result);
	$result = str_replace("\r", " ", $result);
	$result = str_replace("\t", " ", $result);
	$result = str_replace("\v", " ", $result);
	$result = str_replace("\f", " ", $result);
	$result = trim($result);
	
/*
	if ($originalString != $result)
	{
		echo "fixText changed line -<br>";
		echo $originalString . "<br>";
		echo $result . "<br>";
	}
*/

	return $result;
}

// ===============================================================

function addLeadingZeros($value, $positions)
{
	$result = $value;
	
	$valueLen = strlen($value);
	if ($valueLen < $positions)
	{
		$result = str_repeat("0", $positions - $valueLen) . $value;
	}
	
	return $result;
}

// ===============================================================

function secureParameters($aArray)
{
	$result = $aArray;
	$result = array_map("htmlspecialchars", $result);	# secure from XSS
	$result = array_map("trim", $result); # Remove leading/trailing spaces
	$result = array_map("stripslashes",$result);//Remove slashes
	$result = array_map("mysql_real_escape_string", $result); # SQL injections
	return $result;
}

function secureParametersMYSQLi($aArray)
{
	$result = $aArray;
	$result = array_map("htmlspecialchars", $result);	# secure from XSS
	$result = array_map("trim", $result); # Remove leading/trailing spaces
	$result = array_map("stripslashes",$result);//Remove slashes
	$result = array_map("mysql_escape_mimic", $result); # SQL injections
	return $result;
}

function mysql_escape_mimic($inp) { 
    if(is_array($inp)) 
        return array_map(__METHOD__, $inp); 

    if(!empty($inp) && is_string($inp)) { 
        return str_replace(array('\\', "\0", "\n", "\r", "'","'", '"', "\x1a"), array('\\\\', '\\0', '\\n', '\\r', "\\'", "\\'", '\\"', '\\Z'), $inp); 
    } 

    return $inp; 
} 

// ===============================================================

function dom2array($node) {
  $res = array();
  print $node->nodeType.'<br/>';
  if($node->nodeType == XML_TEXT_NODE){
      $res = $node->nodeValue;
  }
  else{
      if($node->hasAttributes()){
          $attributes = $node->attributes;
          if(!is_null($attributes)){
              $res['@attributes'] = array();
              foreach ($attributes as $index=>$attr) {
                  $res['@attributes'][$attr->name] = $attr->value;
              }
          }
      }
      if($node->hasChildNodes()){
          $children = $node->childNodes;
          for($i=0;$i<$children->length;$i++){
              $child = $children->item($i);
              $res[$child->nodeName] = dom2array($child);
          }
      }
  }
  return $res;
}

// ===============================================================

function dom2array_full($node)
{ 
    $result = array(); 
    
    $node_class = get_class($node);
    
    if ($node_class == "DOMElement")
    {
    	unset($newResult);
		$newResult["name"] = $node->nodeName;
		$newResult["value"] = $node->nodeValue;
				
		if ($node->hasAttributes()) 
		{ 
			$attributes = $node->attributes; 
			if(!is_null($attributes))
			{
				unset($attributeList);
				foreach ($attributes as $index=>$attr) 
				{
					$attribute["name"] = $attr->name;
					$attribute["value"] = $attr->value;
					
					$attributeList[] = $attribute; 
				}
				
				$newResult["attributes"] = $attributeList;
			}
		} 
		
		if ($node->hasChildNodes())
		{ 
			unset($childNodes);
			$children = $node->childNodes; 
			for($i = 0; $i < $children->length; $i++) 
			{ 
				$child = $children->item($i); 
				$childNodes[] = dom2array_full($child); 
			} 

			$newResult["childNodes"] = $childNodes;
		} 
 
 		$result[] = $newResult; 
	}
    elseif ($node_class == "DOMText")
    {
    	unset($newResult);
		$newResult["name"] = $node->nodeName;
		$newResult["value"] = $node->nodeValue;
 		$result[] = $newResult; 
    }
    elseif ($node_class == "DOMNodeList")
    {
		unset($childNodes);
		for($i = 0; $i < $node->length; $i++) 
		{ 
			$child = $node->item($i);
			$result[] = dom2array_full($child);
		} 
    }
    elseif ($node_class == "DOMCdataSection")
    {
		unset($newResult);
		$newResult["name"] = "cdata";
		$newResult["value"] = $node->data;
		
 		$result[] = $newResult; 		
    }
    else
    {
    	echo "node_class not handled: $node_class<br>";
    	//echo $node . "<br>";
    	//printArray($node);
    	echo "variable type = " . gettype($node) . "<br>";
    	echo "object class = " . get_class($node) . "<br>";
    }
    
    return $result; 
} 

// ===============================================================

function recursive_array_search($needle, $haystack) 
{ 
    foreach ($haystack as $key=>$value) 
    { 
    	$current_value = $value;
    	
        if ($needle === $key) 
        { 
            return $current_value; 
        } 
        else
        if (($needle === $key) OR (is_array($value) && 
        		recursive_array_search($needle, $value))) 
        { 
        	if (is_array($value))
        	{
        		$current_value = recursive_array_search($needle, $value);
        		if ($current_value !== false)
        		{
        			return $current_value;
        		}
        	}
        } 
    } 
    return false; 
} 

// ===============================================================

function find_tag($tag, $tagArray) 
{ 
	foreach ($tagArray as $item)
	{
		if ($item["name"] == $tag)
		{
			$value = $item["value"];
			if ($value > "")
			{
				return $value;
			}
		}
	}
	return null;
}


// ===============================================================

function getCharset($url)
{ 
	// extract the charset attribute from the HTTP header
	
	// get http header only
	$ch = curl_init(); 
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); 
	curl_setopt($ch, CURLOPT_URL, $url); 
	curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 20);
	curl_setopt ($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.11) Gecko/20071127 Firefox/2.0.0.11');
	curl_setopt($ch, CURLOPT_HEADER, true); 
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'HEAD'); // HTTP request is 'HEAD'
	$header = curl_exec($ch); 
	curl_close($ch);
	$header_array = explode("\n", $header);
	printArray($header_array);
	
	$charset = "";
	
	foreach($header_array as $header_idx => $header_value)
	{
		$valueLength = strlen($header_value);
		$contentTypeTag = "Content-Type:";
		$contentTypeTagLength = strlen($contentTypeTag);
		
		$tagPos = stripos($header_value, $contentTypeTag);
		if ($tagPos !== false)
		{
			if ($tagPos == 0)
			{
				$charsetTag = "charset=";
				$charsetTagLength = strlen($charsetTag);
				$charsetPos = stripos($header_value, $charsetTag);
				{
					if ($charsetPos !== false)
					{
						$continueScan = true;
						$charsetPos += $charsetTagLength;
						while ($continueScan == true)
						{
							$aChar = substr($header_value, $charsetPos, 1);
							
							if ($aChar == ";")
							{
								$continueScan = false;
							}
							else
							{
								$charset .= $aChar;
							}
							
							$charsetPos++;
							if ($charsetPos >= $valueLength)
							{
								$continueScan = false;
							}
						}
					}
				}
			}
		}
	}
	
	return trim($charset);
}

class PasswordHash {
	var $itoa64;
	var $iteration_count_log2;
	var $portable_hashes;
	var $random_state;

	function PasswordHash($iteration_count_log2, $portable_hashes)
	{
		$this->itoa64 = './0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

		if ($iteration_count_log2 < 4 || $iteration_count_log2 > 31)
			$iteration_count_log2 = 8;
		$this->iteration_count_log2 = $iteration_count_log2;

		$this->portable_hashes = $portable_hashes;

		$this->random_state = microtime();
		if (function_exists('getmypid'))
			$this->random_state .= getmypid();
	}

	function get_random_bytes($count)
	{
		$output = '';
		if (is_readable('/dev/urandom') &&
		    ($fh = @fopen('/dev/urandom', 'rb'))) {
			$output = fread($fh, $count);
			fclose($fh);
		}

		if (strlen($output) < $count) {
			$output = '';
			for ($i = 0; $i < $count; $i += 16) {
				$this->random_state =
				    md5(microtime() . $this->random_state);
				$output .=
				    pack('H*', md5($this->random_state));
			}
			$output = substr($output, 0, $count);
		}

		return $output;
	}

	function encode64($input, $count)
	{
		$output = '';
		$i = 0;
		do {
			$value = ord($input[$i++]);
			$output .= $this->itoa64[$value & 0x3f];
			if ($i < $count)
				$value |= ord($input[$i]) << 8;
			$output .= $this->itoa64[($value >> 6) & 0x3f];
			if ($i++ >= $count)
				break;
			if ($i < $count)
				$value |= ord($input[$i]) << 16;
			$output .= $this->itoa64[($value >> 12) & 0x3f];
			if ($i++ >= $count)
				break;
			$output .= $this->itoa64[($value >> 18) & 0x3f];
		} while ($i < $count);

		return $output;
	}

	function gensalt_private($input)
	{
		$output = '$P$';
		$output .= $this->itoa64[min($this->iteration_count_log2 +
			((PHP_VERSION >= '5') ? 5 : 3), 30)];
		$output .= $this->encode64($input, 6);

		return $output;
	}

	function crypt_private($password, $setting)
	{
		$output = '*0';
		if (substr($setting, 0, 2) == $output)
			$output = '*1';

		$id = substr($setting, 0, 3);
		# We use "$P$", phpBB3 uses "$H$" for the same thing
		if ($id != '$P$' && $id != '$H$')
			return $output;

		$count_log2 = strpos($this->itoa64, $setting[3]);
		if ($count_log2 < 7 || $count_log2 > 30)
			return $output;

		$count = 1 << $count_log2;

		$salt = substr($setting, 4, 8);
		if (strlen($salt) != 8)
			return $output;

		# We're kind of forced to use MD5 here since it's the only
		# cryptographic primitive available in all versions of PHP
		# currently in use.  To implement our own low-level crypto
		# in PHP would result in much worse performance and
		# consequently in lower iteration counts and hashes that are
		# quicker to crack (by non-PHP code).
		if (PHP_VERSION >= '5') {
			$hash = md5($salt . $password, TRUE);
			do {
				$hash = md5($hash . $password, TRUE);
			} while (--$count);
		} else {
			$hash = pack('H*', md5($salt . $password));
			do {
				$hash = pack('H*', md5($hash . $password));
			} while (--$count);
		}

		$output = substr($setting, 0, 12);
		$output .= $this->encode64($hash, 16);

		return $output;
	}

	function gensalt_extended($input)
	{
		$count_log2 = min($this->iteration_count_log2 + 8, 24);
		# This should be odd to not reveal weak DES keys, and the
		# maximum valid value is (2**24 - 1) which is odd anyway.
		$count = (1 << $count_log2) - 1;

		$output = '_';
		$output .= $this->itoa64[$count & 0x3f];
		$output .= $this->itoa64[($count >> 6) & 0x3f];
		$output .= $this->itoa64[($count >> 12) & 0x3f];
		$output .= $this->itoa64[($count >> 18) & 0x3f];

		$output .= $this->encode64($input, 3);

		return $output;
	}

	function gensalt_blowfish($input)
	{
		# This one needs to use a different order of characters and a
		# different encoding scheme from the one in encode64() above.
		# We care because the last character in our encoded string will
		# only represent 2 bits.  While two known implementations of
		# bcrypt will happily accept and correct a salt string which
		# has the 4 unused bits set to non-zero, we do not want to take
		# chances and we also do not want to waste an additional byte
		# of entropy.
		$itoa64 = './ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

		$output = '$2a$';
		$output .= chr(ord('0') + $this->iteration_count_log2 / 10);
		$output .= chr(ord('0') + $this->iteration_count_log2 % 10);
		$output .= '$';

		$i = 0;
		do {
			$c1 = ord($input[$i++]);
			$output .= $itoa64[$c1 >> 2];
			$c1 = ($c1 & 0x03) << 4;
			if ($i >= 16) {
				$output .= $itoa64[$c1];
				break;
			}

			$c2 = ord($input[$i++]);
			$c1 |= $c2 >> 4;
			$output .= $itoa64[$c1];
			$c1 = ($c2 & 0x0f) << 2;

			$c2 = ord($input[$i++]);
			$c1 |= $c2 >> 6;
			$output .= $itoa64[$c1];
			$output .= $itoa64[$c2 & 0x3f];
		} while (1);

		return $output;
	}

	function HashPassword($password)
	{
		$random = '';

		if (CRYPT_BLOWFISH == 1 && !$this->portable_hashes) {
			$random = $this->get_random_bytes(16);
			$hash =
			    crypt($password, $this->gensalt_blowfish($random));
			if (strlen($hash) == 60)
				return $hash;
		}

		if (CRYPT_EXT_DES == 1 && !$this->portable_hashes) {
			if (strlen($random) < 3)
				$random = $this->get_random_bytes(3);
			$hash =
			    crypt($password, $this->gensalt_extended($random));
			if (strlen($hash) == 20)
				return $hash;
		}

		if (strlen($random) < 6)
			$random = $this->get_random_bytes(6);
		$hash =
		    $this->crypt_private($password,
		    $this->gensalt_private($random));
		if (strlen($hash) == 34)
			return $hash;

		# Returning '*' on error is safe here, but would _not_ be safe
		# in a crypt(3)-like function used _both_ for generating new
		# hashes and for validating passwords against existing hashes.
		return '*';
	}

	function CheckPassword($password, $stored_hash)
	{
		$hash = $this->crypt_private($password, $stored_hash);
		if ($hash[0] == '*')
			$hash = crypt($password, $stored_hash);

		return $hash == $stored_hash;
	}
}

function generateAccountID($length) 
{ 
	$random= "";
	srand((double)microtime()*1000000);

	$data = "AbcDE123IJKLMN67QRSTUVWXYZ"; 
	$data .= "aBCdefghijklmn123opq45rs67tuv89wxyz"; 
	$data .= "0FGH45OP89";

	for($i = 0; $i < $length; $i++) 
	{ 
		$random .= substr($data, (rand()%(strlen($data))), 1); 
	}

	return $random; 
}





?>