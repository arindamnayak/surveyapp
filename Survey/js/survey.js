
$(function() {
    
    // Replace MOBILE_SVC_NAME , API_KEY with your values from Azure portal
	var client = new WindowsAzure.MobileServiceClient(
        "https://[MOBILE_SVC_NAME].azure-mobile.net/",
        "API_KEY"
    );

    var userName = '<unknown>';
    $(".logged-out a").click(logIn);
    $(".logged-in a").click(logOut);
	$("#btnsubmit").click(CreateSurvey);

    refreshAuthDisplay();


    function refreshAuthDisplay() {
        var isLoggedIn = client.currentUser !== null;
        $(".logged-in").toggle(isLoggedIn);
        $(".logged-out").toggle(!isLoggedIn);
		

        if (isLoggedIn) {
            $("#login-name").text(userName);
        }
    }


    function logIn() {
        client.login("facebook").then(function(result) {
            client.invokeApi('getuser', {
                method: 'POST'
            }).done(function(response) {
                userName = response.result.UserName;                
                $().toastmessage('showSuccessToast', "Logged in.");
                refreshAuthDisplay();
            });
        });
    };

    function logOut() {
        client.logout();
        refreshAuthDisplay();
    }
	
	function CreateSurvey() {
		ShowLoader();
		var surveyquestion = $("#inputsurvey").val();
		var emailnotification = $("#inputemail").val();		
		var polls = [];

		for (var i = 1; i < 5; i++) {
			if ($("#opt" + i).val() != "")
				polls.push($("#opt" + i).val());
		}

		client.invokeApi('createsurvey', {
			method: 'POST',
			body: {
				surveyquestion: surveyquestion,
				notificationemail: emailnotification,
				polls: polls,			
			}
		}).done(function(response) {
			console.log(response);
			console.log(response.result.message);
			HideLoader();
			$().toastmessage('showSuccessToast', "Congrats, survey created.");
			ShowSurveyPreview();
		}, function(error) {
			var xhr = error.request;
			$().toastmessage('showErrorToast', "Please login and try again!");
			HideLoader();
			console.log('Error - status code: ' + xhr.status + '; body: ' + xhr.responseText);
		});
	};

	function ShowSurveyPreview() {
		for (var i = 1; i < 5; i++) {
			$("li input[id=opt" + i + "]").parent().text($("#opt" + i).val());
		}
		$("#inputsurvey").parent().html($("#inputsurvey").val()).css("font-weight", "bold");
		$("#btnsubmit").attr("disabled", "disabled");
		$("#emailfield").hide();
	}
});
