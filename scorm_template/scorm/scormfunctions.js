//Include the standard ADL-supplied API discovery algorithm

///////////////////////////////////////////
//Begin ADL-provided API discovery algorithm
///////////////////////////////////////////

var nFindAPITries = 0;
var API = null;
var maxTries = 500;
// The ScanForAPI() function searches for an object named API_1484_11
// in the window that is passed into the function.  If the object is
// found a reference to the object is returned to the calling function.
// If the instance is found the SCO now has a handle to the LMS
// provided API Instance.  The function searches a maximum number
// of parents of the current window.  If no object is found the
// function returns a null reference.  This function also reassigns a
// value to the win parameter passed in, based on the number of
// parents.  At the end of the function call, the win variable will be
// set to the upper most parent in the chain of parents.
function ScanForAPI(win)
{
	while ((win.API == null) && (win.parent != null)
	&& (win.parent != win))
	{
		nFindAPITries++;
		if (nFindAPITries > maxTries)
		{
			return null;
		}
		win = win.parent;
	}
	return win.API;
}

// The GetAPI() function begins the process of searching for the LMS
// provided API Instance.  The function takes in a parameter that
// represents the current window.  The function is built to search in a
// specific order and stop when the LMS provided API Instance is found.
// The function begins by searching the current window�s parent, if the
// current window has a parent.  If the API Instance is not found, the
// function then checks to see if there are any opener windows.  If
// the window has an opener, the function begins to look for the
// API Instance in the opener window.
function GetAPI(win)
{
	if ((win.parent != null) && (win.parent != win))
	{
		API = ScanForAPI(win.parent);
	}
	if ((API == null) && (win.opener != null))
	{
		API = ScanForAPI(win.opener);
	}
}

///////////////////////////////////////////
//End ADL-provided API discovery algorithm
///////////////////////////////////////////


//Create function handlers for the loading and unloading of the page

//Constants
var SCORM_TRUE = "true";
var SCORM_FALSE = "false";
var SCORM_NO_ERROR = "0";

//Since the Unload handler will be called twice, from both the onunload
//and onbeforeunload events, ensure that we only call Terminate once.
var terminateCalled = false;

//Track whether or not we successfully initialized.
var initialized = false;

function ScormProcessInitialize(){
	var result;

	GetAPI(window);

	if (API == null){
		alert("ERROR - Could not establish a connection with the LMS.\n\nYour results may not be recorded.");
		return;
	}

	result = API.LMSInitialize("");

	if (result == SCORM_FALSE){
		var errorNumber = API.GetLastError();
		var errorString = API.GetErrorString(errorNumber);
		var diagnostic = API.GetDiagnostic(errorNumber);

		var errorDescription = "Number: " + errorNumber + "\nDescription: " + errorString + "\nDiagnostic: " + diagnostic;

		alert("Error - Could not initialize communication with the LMS.\n\nYour results may not be recorded.\n\n" + errorDescription);
		return;
	}

	initialized = true;
}

function ScormProcessTerminate(){

	var result;

	//Don't terminate if we haven't initialized or if we've already terminated
	if (initialized == false || terminateCalled == true){return;}

	result = API.LMSFinish("");

	terminateCalled = true;

	if (result == SCORM_FALSE){
		var errorNumber = API.GetLastError();
		var errorString = API.GetErrorString(errorNumber);
		var diagnostic = API.GetDiagnostic(errorNumber);

		var errorDescription = "Number: " + errorNumber + "\nDescription: " + errorString + "\nDiagnostic: " + diagnostic;

		alert("Error - Could not terminate communication with the LMS.\n\nYour results may not be recorded.\n\n" + errorDescription);
		return;
	}
}

function ScormProcessCommit(){
	
	var result;

	result = API.LMSCommit("");

	if (result == SCORM_FALSE){
		var errorNumber = API.GetLastError();
		var errorString = API.GetErrorString(errorNumber);
		var diagnostic = API.GetDiagnostic(errorNumber);

		var errorDescription = "Number: " + errorNumber + "\nDescription: " + errorString + "\nDiagnostic: " + diagnostic;

		alert("Error - Could not commit to the LMS.\n\nYour results may not be recorded.\n\n" + errorDescription);
		return;
	}
}


/*
The onload and onunload event handlers are assigned in launchpage.html because more processing needs to
occur at these times in this example.
*/
//window.onload = ScormProcessInitialize;
//window.onunload = ScormProcessTerminate;
//window.onbeforeunload = ScormProcessTerminate;

//There are situations where a GetValue call is expected to have an error
//and should not alert the user.
function ScormProcessGetValue(element, checkError){
	var result;

	if (initialized == false || terminateCalled == true){return;}

	result = API.LMSGetValue(element);

	if (checkError == true && result == ""){

		var errorNumber = API.GetLastError();

		if (errorNumber != SCORM_NO_ERROR){
			var errorString = API.GetErrorString(errorNumber);
			var diagnostic = API.GetDiagnostic(errorNumber);

			var errorDescription = "Number: " + errorNumber + "\nDescription: " + errorString + "\nDiagnostic: " + diagnostic;

			alert("Error - Could not retrieve a value from the LMS.\n\n" + errorDescription);
			return "";
		}
	}

	return result;
}

function ScormProcessSetValue(element, value){
	var result;

	if (initialized == false || terminateCalled == true){return;}

	result = API.LMSSetValue(element, value);

	if (result == SCORM_FALSE){
		var errorNumber = API.GetLastError();
		var errorString = API.GetErrorString(errorNumber);
		var diagnostic = API.GetDiagnostic(errorNumber);

		var errorDescription = "Number: " + errorNumber + "\nDescription: " + errorString + "\nDiagnostic: " + diagnostic;

		alert("Error - Could not store a value in the LMS.\n\nYour results may not be recorded.\n\n" + errorDescription);
		return;
	}

	return result;
}


