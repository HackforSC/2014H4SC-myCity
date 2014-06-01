<?php

class IndexPage {
	
	function get() {

		// Set some variables
		$values['project_count'] = get_projects_count();
		$values['donations_total'] = get_total_donations();

		// Set the page content
		$content_for_layout = "_index";

		// Page-specific values
		$values['projects'] = get_all_projects();

		foreach($values['projects'] as &$project) {
			$project['total_raised'] = get_project_total_donations($project['id']);
			$project['percent'] = round(($project['total_raised'] / $project['goal_amount']) * 100);
		}
		
		unset($project);

		include("views/layout.php");

	}

}

class DetailsPage {
	function get($project_id) {

		// Set some variables
		$values['project_count'] = get_projects_count();
		$values['donations_total'] = get_total_donations();

		// Set the page content
		$content_for_layout = "_detail";

		// Page-specific values
		$values['project'] = get_project($project_id);
		$values['project_donations'] = get_project_total_donations($project_id);
		$values['percent'] = round(($values['project_donations'] / $values['project']['goal_amount']) * 100);
		$values['backers'] = get_project_total_backers($project_id);
		$values['interest'] = get_project_interest($values['project']['Interests_id']);
		$values['location'] = get_location($values['interest']['Locations_id']);

		include("views/layout.php");

	}
}

class Contact {
	function get() {
				// Set some variables
		$values['project_count'] = get_projects_count();
		$values['donations_total'] = get_total_donations();
		$content_for_layout = "_contact";
		include("views/layout.php");
	}
}

class RequestProject {
	function get() {
				// Set some variables
		$values['project_count'] = get_projects_count();
		$values['donations_total'] = get_total_donations();
		$content_for_layout = "_request";
		include("views/layout.php");
	}
}

class About {
	function get() {
				// Set some variables
		$values['project_count'] = get_projects_count();
		$values['donations_total'] = get_total_donations();
		$content_for_layout = "_about";
		include("views/layout.php");
	}
}