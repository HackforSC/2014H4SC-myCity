	<?php
//echo "haha";
require("handlers/api_handler.php");
require("handlers/web_handler.php");
require("lib/Toro.php");
require("lib/utils.php");
require("lib/mysql.php");
require("lib/queries.php");
require("lib/queries_web.php");

date_default_timezone_set('UTC');
//Fix to adjust for using nginx
$_SERVER['PATH_INFO'] = $_SERVER['REQUEST_URI'];

//Fix for PHP environments for 4.3.0 <= PHP <= 5.4.0 (and nginx differences)
if (!function_exists('http_response_code'))
{
    function http_response_code($newcode = NULL)
    {
        static $code = 200;
        if($newcode !== NULL)
        {
            header('X-PHP-Response-Code: '.$newcode, true, $newcode);
            if(!headers_sent())
                $code = $newcode;
        }       
        return $code;
    }
}

//Prepare the request for Toro, it doesn't like GET parameters...
$_SERVER['PATH_INFO'] = strtok($_SERVER["PATH_INFO"],'?');
$_SERVER['REQUEST_URI'] = strtok($_SERVER["REQUEST_URI"],'?');




ToroHook::add("404", function() {
    $responce["status"] = "failed";
	$responce["error_detail"] = "json 404";
	$responce["error_readable"] = "The server could not find what you were looking for.\n (404)";
	header('Content-type: application/json');
	echo json_encode($responce);
	exit();
});


Toro::serve(array(
	"/" => "IndexPage",
	"/user" => "Users",
	"/user/login" => "LogInUser",
	"/user/:number/device" => "New_Device",
	"/user/:number/locations" => "get_items",
	"/user/suggest" => "PlaceHolder",
	"/user/:number/donate" => "Donate",
    "/w/project/:number" => "DetailsPage",
    "/w/contact" => "Contact",
    "/w/request" => "RequestProject",
    "/w/about" => "About"
    

));
