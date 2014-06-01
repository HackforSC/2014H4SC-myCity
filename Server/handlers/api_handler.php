<?

class PlaceHolder {
	
	function get(){
		
		echo "This Endpoint is Under Construction";
		
	}
	function post(){
		
		echo "This Endpoint is Under Construction";
		
	}
	
	
	
	
}


class SignCheck {
	function hashing(){
	
	if(empty($_REQUEST["signing_hash"])){ 
			$errorvar["signing_hash"] = "missing"; 
			}
	if(empty($_REQUEST["json"])){ 
			$errorvar["json"] = "missing"; 
			}
			
		if(!empty($errorvar)){
		
		$responce["errorvar"] = $errorvar;
		$responce["status"] = "failed";
		$responce["error_detail"] = "";
		$responce["error_readable"] = "Authentication with the server failed.";
		header('Content-type: application/json');
		echo json_encode($responce);
		exit();
		
		}
	
	
	$json_body = json_decode($_REQUEST["json"], true);
	
	$uploaded_time = $json_body["time_stamp"];
		
		
	//Check the signing Key 
	
	$pre_hash_string = 	$_REQUEST["json"] . $uploaded_time . "BYaLNZfwYz9ZLazkbDBJua[qiLmH,BDIfHE3Y8&7Oyi;QQvBZy";
	
	$hashed_string = hash('sha256', $pre_hash_string);
	}
	
	
	
	
	
	
	
	
	
	
	
	function accessKeyCheck(){
	
		$json_body = json_decode($_REQUEST["json"], true);
		if(empty($json_body["access_key"])){ 
			$errorvar["access_key"] = "missing"; 
			}
		
		if(!empty($errorvar)){
		
		$responce["errorvar"] = $errorvar;
		$responce["status"] = "failed";
		$responce["error_detail"] = "";
		$responce["error_readable"] = "Authentication with the server failed.";
		header('Content-type: application/json');
		echo json_encode($responce);
		exit();
		
		}
		
		//CHECK THE ACCESS KEY VS THE USER ID
		$user_info = get_user_with_accesskey($json_body["access_key"]);
		//echo "UserID: " . $user_id_pass;
		//echo var_dump($user_info);
		if($user_info[0]["id"] != $json_body["user_id"]){
			
		$responce["status"] = "failed";
		$responce["error_detail"] = "";
		$responce["error_readable"] = "Authentication with the server failed.";
		header('Content-type: application/json');
		echo json_encode($responce);
		exit();	
			
	
			
		}
	
		
	}
	
	
	
	
	
	
	
	
	
	
	
}


class Users {
	function __construct() {
       ToroHook::add("before_handler", SignCheck::hashing());
        
    }
    
    function get() {
	    
	    echo "GET is not available on this endpoint";
	    
	    
    }
    
    
    
    function post() {
	    
	    //Check for the user variables
	    $json_body = json_decode($_REQUEST["json"], true);
	    if(empty($json_body["email_address"])){ 
			$errorvars["email_address"] = "missing"; 
			}
		if(empty($json_body["password"])){ 
			$errorvars["password"] = "missing"; 
			}
		if(empty($json_body["last_name"])){ 
			$errorvars["last_name"] = "missing"; 
			}
		if(empty($json_body["first_name"])){ 
			$errorvars["first_name"] = "missing"; 
			}			
	
	    if(!empty($errorvars)){
		
		$responce["errorvar"] = $errorvars;
		$responce["status"] = "failed";
		$responce["error_detail"] = "";
		$responce["error_readable"] = "Authentication with the server failed.";
		header('Content-type: application/json');
		echo json_encode($responce);
		exit();
		
		}
		
		
		//SET UP THE PASSWORD HASH
		$access_key = generateAccountID(128);
		$hasher = new PasswordHash(8, FALSE);
		$password_hash = $hasher->hashPassword($json_body["password"]);
		
		
		
		//SET UP THE NEW USER
	    new_user($json_body["email_address"], $password_hash, $json_body["last_name"], $json_body["first_name"], $access_key);
	    
	    //REFRESH USER FROM DB
	    $user = get_user($access_key);
	    
	    
	    //SEND BACK THE ITEMS
	    unset($user[0]["password_hash"]);
	    $responce["user"] = $user[0];
	    $responce["status"] = "success";
		$responce["error_detail"] = "";
		$responce["error_readable"] = "";
		header('Content-type: application/json');
		echo json_encode($responce);
 
	    
    }
	
}


class LogInUser {

	function __construct() {
       ToroHook::add("before_handler", SignCheck::hashing());
        
    }
	
	function post(){
		
		$json_body = json_decode($_REQUEST["json"], true);
	    if(empty($json_body["email_address"])){ 
			$errorvars["email_address"] = "missing"; 
			}
		if(empty($json_body["password"])){ 
			$errorvars["password"] = "missing"; 
			}
		
		if(!empty($errorvars)){
		
		$responce["errorvar"] = $errorvars;
		$responce["status"] = "failed";
		$responce["error_detail"] = "";
		$responce["error_readable"] = "Authentication with the server failed.";
		header('Content-type: application/json');
		echo json_encode($responce);
		exit();
		
		}
		
		$user_data = get_user_with_email($json_body["email_address"]);
		$hasher = new PasswordHash(8, FALSE);
		$password = $json_body["password"];
		$passwordHash = $user_data[0]["password_hash"];
		//echo $passwordHash;
		if(!($hasher->CheckPassword($password, $passwordHash))){
			
			$responce["status"] = "failed";
			$responce["error_detail"] = "password error";
			$responce["error_readable"] = "The email address and password do not match";
			header('Content-type: application/json');
			echo json_encode($responce);
			exit();
				
			
		}
		
		//GIVE BACK A USER ELIMENT 
		unset($user_data[0]["password_hash"]);
	    $responce["user"] = $user_data[0];
	    $responce["status"] = "success";
		$responce["error_detail"] = "";
		$responce["error_readable"] = "";
		header('Content-type: application/json');
		echo json_encode($responce);
		
		
		
		
		
		
	
	}
	
}

class New_Device {

	function __construct() {
       ToroHook::add("before_handler", SignCheck::hashing());
       ToroHook::add("before_handler", SignCheck::accessKeyCheck());
        
    }
	
	function post($user_id){
		
		$json_body = json_decode($_REQUEST["json"], true);
		if(empty($json_body["push_token"])){ 
			$errorvars["push_token"] = "missing"; 
			}
		if(empty($json_body["os"])){ 
			$errorvars["os"] = "missing"; 
			}
		if(empty($json_body["os_version"])){ 
			$errorvars["os_version"] = "missing"; 
			}
		
		if(!empty($errorvars)){
		$responce["errorvar"] = $errorvars;
		$responce["status"] = "failed";
		$responce["error_detail"] = "";
		$responce["error_readable"] = "Authentication with the server failed.";
		header('Content-type: application/json');
		echo json_encode($responce);
		exit();
		
		}
		
		$responce["status"] = "success";
		$responce["error_detail"] = "";
		$responce["error_readable"] = "";
		header('Content-type: application/json');
		echo json_encode($responce);
		
		
		
	}
	
	
	
	
	
	
	
}

class get_items {


	function __construct() {
       ToroHook::add("before_handler", SignCheck::hashing());
       ToroHook::add("before_handler", SignCheck::accessKeyCheck());
        
    }
	
	function post($user_id){
		
		
		//GET ALL LOCATIONS
		
		$Locations = get_all_locations();
		
		///LOOP TO CHANGE THE PATIENT IDS
		for($i=0; $i < count($Locations); $i++)
		{
		 	$Interests = get_all_interests_with_locations($Locations[$i]["id"]);
		 	//$Locations[$i]["interests"] = $Interests;
		 		for($i2=0; $i2 < count($Interests); $i2++)
		 		{
		 		 	
		 		 	if(get_beacon_for_interest($Interests[$i2]["id"])) {
		 		 		$Interests[$i2]["beacons"] = get_beacon_for_interest($Interests[$i2]["id"]);
		 		 	} else {
		 		 		$Interests[$i2]["beacons"] = '';
		 		 	}

			 		$Projects = get_all_projects_with_interest($Interests[$i2]["id"]);
			 		
			 		$Interests[$i2]["projects"] = $Projects;
			 		//echo var_dump($Locations);
			 		for($i3=0; $i3 < count($Projects); $i3++)
			 		{
				 		$tags = get_all_tags_with_project($Projects[$i3]["id"]);
				 		$donations = get_all_donations_with_project_user($Projects[$i3]["id"], $user_id);
				 		$total = get_all_donations_with_project_user_sum($Projects[$i3]["id"], $user_id);
				 		$user_donations = get_all_donations_with_project_user_sum_user($Projects[$i3]["id"], $user_id);
				 		$total_donations = get_total_donations_for_project($Projects[$i3]["id"]);
				 		$Projects[$i3]["tags"] = $tags;
				 		$Projects[$i3]["donations"] = $donations;
				 		$Projects[$i3]["total_donations"] = $total[0]["SUM(amount)"];
				 		$Projects[$i3]["user_donations"] = $user_donations[0]["SUM(amount)"];
				 		$Projects[$i3]["total_backers"] = $total_donations;
				 		
				 		if($Projects[$i3]["user_donations"] == null)
				 		{
					 		$Projects[$i3]["user_donations"] = "0";
				 		}
				 		
				 		if($Projects[$i3]["total_donations"] == null)
				 		{
					 		$Projects[$i3]["total_donations"] = "0";
				 		}
				 		if($Projects[$i3]["total_backers"] == null)
				 		{
					 		$Projects[$i3]["total_backers"] = "0";
				 		}
				 		
			 		}
			 		$Interests[$i2]["projects"] = $Projects;
		 		}
		 	$Locations[$i]["interests"] = $Interests;
		}
		//echo var_dump($Locations);
		$responce["locations"] = $Locations;
		$responce["status"] = "success";
		$responce["error_detail"] = "";
		$responce["error_readable"] = "";
		header('Content-type: application/json');
		echo json_encode($responce);
	
	}
	
}

class Donate {


	function __construct() {
       ToroHook::add("before_handler", SignCheck::hashing());
       ToroHook::add("before_handler", SignCheck::accessKeyCheck());
        
    }
	
	function post($user_id) {

		$json_body = json_decode($_REQUEST["json"], true);
		new_donation($json_body['user_id'], $json_body['project_id'], $json_body['ammount']);
		
		$responce["status"] = "success";
		$responce["error_detail"] = "";
		$responce["error_readable"] = "";
		header('Content-type: application/json');
		echo json_encode($responce);

	
	}
	
}



