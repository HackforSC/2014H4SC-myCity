<?php



function new_user($email_address, $password_hash, $last_name, $first_name, $access_key){

	$time = time();
	//SET UP THE QUERY
	$query = MySQL::getInstance()->prepare("INSERT INTO users (first_name, last_name, email_address, time_stamp, password_hash, access_key) VALUES (:first_name, :last_name, :email_address, :time_stamp, :password_hash, :access_key)");
	$query->bindValue(':first_name', $first_name, PDO::PARAM_STR);
	$query->bindValue(':last_name', $last_name, PDO::PARAM_STR);
	$query->bindValue(':email_address', $email_address, PDO::PARAM_STR);
	$query->bindValue(':time_stamp', $time, PDO::PARAM_INT);
	$query->bindValue(':password_hash', $password_hash, PDO::PARAM_STR);
	$query->bindValue(':access_key', $access_key, PDO::PARAM_STR);
	$query->execute();
	
	
}

function get_user($access_key) {
    $query = MySQL::getInstance()->prepare("SELECT * FROM users WHERE access_key=:access_key LIMIT 1");
    $query->bindValue(':access_key', $access_key, PDO::PARAM_STR);
    $query->execute();
    return $query->fetchAll(PDO::FETCH_ASSOC);
}


function get_user_with_email($email_address) {
    $query = MySQL::getInstance()->prepare("SELECT * FROM users WHERE email_address=:email_address ORDER BY id DESC LIMIT 1");
    $query->bindValue(':email_address', $email_address, PDO::PARAM_STR);
    $query->execute();
    return $query->fetchAll(PDO::FETCH_ASSOC);
}

function get_user_with_accesskey($access_key) {
    $query = MySQL::getInstance()->prepare("SELECT * FROM users WHERE access_key=:access_key ORDER BY id DESC LIMIT 1");
    $query->bindValue(':access_key', $access_key, PDO::PARAM_STR);
    $query->execute();
    return $query->fetchAll(PDO::FETCH_ASSOC);
}

function get_all_locations() {
    $query = MySQL::getInstance()->prepare("SELECT * FROM Locations");
    $query->execute();
    return $query->fetchAll(PDO::FETCH_ASSOC);
}

function get_all_interests_with_locations($location_id) {
    $query = MySQL::getInstance()->prepare("SELECT * FROM Interests WHERE Locations_id=:locations_id");
    $query->bindValue(':locations_id', $location_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetchAll(PDO::FETCH_ASSOC);
}

function get_all_projects_with_interest($interest_id) {

    $query = MySQL::getInstance()->prepare("SELECT * FROM Projects WHERE Interests_id=:interests_id");
    $query->bindValue(':interests_id', $interest_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetchAll(PDO::FETCH_ASSOC);
}

function get_all_tags_with_project($project_id) {
    $query = MySQL::getInstance()->prepare("SELECT * FROM tags WHERE Projects_id=:projects_id");
    $query->bindValue(':projects_id', $project_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetchAll(PDO::FETCH_ASSOC);
}


function get_all_donations_with_project_user($project_id, $user_id) {
    $query = MySQL::getInstance()->prepare("SELECT * FROM Donations WHERE projects_id=:projects_id AND user_id=:user_id");
    $query->bindValue(':projects_id', $project_id, PDO::PARAM_INT);
    $query->bindValue(':user_id', $user_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetchAll(PDO::FETCH_ASSOC);
}


function get_all_donations_with_project_user_sum($project_id, $user_id) {
    $query = MySQL::getInstance()->prepare("SELECT SUM(amount) FROM Donations WHERE projects_id=:projects_id");
    $query->bindValue(':projects_id', $project_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetchAll(PDO::FETCH_ASSOC);
}

function get_all_donations_with_project_user_sum_user($project_id, $user_id) {
    $query = MySQL::getInstance()->prepare("SELECT SUM(amount) FROM Donations WHERE projects_id=:projects_id AND user_id=:user_id");
    $query->bindValue(':projects_id', $project_id, PDO::PARAM_INT);
    $query->bindValue(':user_id', $user_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetchAll(PDO::FETCH_ASSOC);
}

function get_total_donations_for_project($project_id) {
    $query = MySQL::getInstance()->prepare("SELECT COUNT(*) FROM Donations WHERE projects_id=:projects_id");
    $query->bindValue(':projects_id', $project_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetchColumn();
}

function get_beacon_for_interest($interest_id) {
    $query = MySQL::getInstance()->prepare("SELECT beacon_udid FROM Beacons WHERE Interests_id=:interest_id");
    $query->bindValue(':interest_id', $interest_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetchColumn();
}

function new_donation($user_id, $project_id, $amount) {

    $time = time();
    //SET UP THE QUERY
    $query = MySQL::getInstance()->prepare("INSERT INTO Donations (user_id, projects_id, amount, time_stamp) VALUES (:user_id, :project_id, :amount, :time_stamp)");
    $query->bindValue(':user_id', $user_id, PDO::PARAM_INT);
    $query->bindValue(':project_id', $project_id, PDO::PARAM_INT);
    $query->bindValue(':amount', $amount, PDO::PARAM_INT);
    $query->bindValue(':time_stamp', $time, PDO::PARAM_INT);
    $query->execute();
    
    
}

/*
function get_total_donations_for_project($project_id) {
    $query = MySQL::getInstance()->prepare("SELECT SUM(id) FROM Donations WHERE projects_id=:projects_id");
    $query->bindValue(':projects_id', $project_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetchAll(PDO::FETCH_ASSOC);
}
*/
