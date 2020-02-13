
function updatePanel(petId) {
    var panel = $("#pet-info");

    $.ajax({
        url: "/pet/" + petId + "/events",
        type: "GET",
        success: function(data, status, jqxhr) {
            panel.html(data);
        },
        error: function(jqxhr, status, err) {
            console.log(err);
        }
    });

    panel.show(); 
    $(".event_form").show();
    $(".charts").show();
}

function setSelectedPet(petId) {
    $("[name='event[pet_id]']").val(petId);
}

function submitEventForm() {      
    var spinner = '<div class="spinner-grow" role="status"><span class="sr-only">Loading...</span></div>'
    $('.event_form').prepend(spinner);

    $.ajax({
        url: $('form').attr('action'),
        type: "POST",
        data: $('form').serialize(),
        success: function(data, status, jqxhr) {
        console.log('submit success');
        $('.spinner-grow').hide();
        updatePanel($('#pets').value);
        },
        error: function(jqxhr, status, err) {
        console.log(err);
        $('.spinner-grow').hide();
        }
    });
}

function getChart(id, type) {
    $.ajax({
        url: "/pet/" + id + "/graph/" + type,
        type: "GET",
        success: function(data, status, jqxhr) {
        //return data;
        $('#pet-chart').html(data);
        },
        error: function(jqxhr, status, err) {
        console.log("error: " + err);
        }
    });
}

$(document).ready(function () {
    $('#pets').on('change', function() {
        updatePanel(this.value);
        setSelectedPet(this.value);
        getChart(this.value, "potties-html");
    });

    $('form').submit(function(e){
        e.preventDefault();
        submitEventForm();
        return false; // prevent default action
    });

    $('.nav-tab').click(function(e){
        e.preventDefault();
        $('.nav-tab').removeClass('active');
        $('#' + this.id).addClass('active');

        var type = this.id.replace("-tab", "-html");
        getChart($("#pets").val(), type);
    });
});