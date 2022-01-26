$(function () {
    function display(bool) {
        var item = event.data;

        if (bool) {
            $("#mejn").show();
        } else {
            $("#mejn").hide();
            

        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })


    $('#wash').click(function() {
		$.post('https://carwash/clean', JSON.stringify({
			action: 'wash'
		}));

		$.post('https://carwash/exit', JSON.stringify());
	})

	document.onkeyup = function(data) {
		if (data.which == 27) {
		  $.post('https://carwash/escape', JSON.stringify({}));
		}
	  }

})