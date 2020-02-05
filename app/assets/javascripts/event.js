$(document).ready(function(){
    function setId() {
        sel = $("select[id=pet]")[0];
        hf = document.getElementById("pet_id");
        hf.value = sel.value;
    }

    if ($(".pet-select").length > 0) {
        $("select[id=pet]")[0].addEventListener("change", setId, false);
    }
});
