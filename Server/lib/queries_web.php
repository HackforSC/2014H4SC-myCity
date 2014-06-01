<?php

function get_projects_count() {

    $query = MySQL::getInstance()->prepare("SELECT COUNT(*) FROM Projects");
    $query->execute();
    return $query->fetchColumn();

}

function get_all_projects() {

    $query = MySQL::getInstance()->prepare("SELECT * FROM Projects");
    $query->execute();
    return $query->fetchAll(PDO::FETCH_ASSOC);
}

function get_total_donations() {

    $query = MySQL::getInstance()->prepare("SELECT SUM(amount) FROM Donations");
    $query->execute();
    return $query->fetchColumn();
}

function get_project($project_id) {

    $query = MySQL::getInstance()->prepare("SELECT * FROM Projects WHERE id=:project_id");
    $query->bindValue(':project_id', $project_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetch();
}

function get_project_interest($interest_id) {
	$query = MySQL::getInstance()->prepare("SELECT * FROM Interests WHERE id=:interest_id");
    $query->bindValue(':interest_id', $interest_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetch();
}

function get_location($location_id) {
	$query = MySQL::getInstance()->prepare("SELECT * FROM Locations WHERE id=:location_id");
    $query->bindValue(':location_id', $location_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetch();
}

function get_project_total_donations($project_id) {
    $query = MySQL::getInstance()->prepare("SELECT SUM(amount) FROM Donations WHERE projects_id=:project_id");
    $query->bindValue(':project_id', $project_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetchColumn();
}

function get_project_total_backers($project_id) {
	$query = MySQL::getInstance()->prepare("SELECT COUNT(DISTINCT id) FROM Donations WHERE projects_id=:project_id");
    $query->bindValue(':project_id', $project_id, PDO::PARAM_INT);
    $query->execute();
    return $query->fetchColumn();
}