// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function hideOrShow(){
	select_val = document.getElementById("listing_listing_type").value
	if (select_val == "offer")
		document.getElementById("cost").className = "";
	else
		document.getElementById("cost").className = "hidden";
}