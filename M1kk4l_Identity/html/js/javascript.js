$(function(){

    function display (bool) {
        if(bool){
            $(".main-background").show()
        } else {
            $(".main-background").hide()
        }
    }
    display(false)
    window.addEventListener("message", function(event) {
        const item = event.data;
        if(item.type === "ui"){

            if(item.status){
                display(true)
            } else {
                display(false)
            }
        }
    
    })

    $("#submit").click(function(){
        let Firname = $("#FirstName").val()
        let Lastname = $("#LastName").val()
        let Age = $("#Age").val()
        if (Firname.length <= 0) {
            swal({
                title: "Nægtet!",
                text: "Du skal opfylde alle bokse!",
                icon: "error",
            })
        } else if (Lastname.length <= 0) {
            swal({
                title: "Nægtet!",
                text: "Du skal opfylde alle bokse!",
                icon: "error",
            })
        } else if (Age > 99) {
            swal({
                title: "Nægtet!",
                text: "Du må ikke have en alder over 99!",
                icon: "error",
            })
        } else if (Age < 2) {
            swal({
                title: "Nægtet!",
                text: "Du må ikke have en alder under 1!",
                icon: "error",
            })
        } else {
            $.post('http://M1kk4l_Identity/Changename', JSON.stringify({
                Firname: Firname,
                Lastname: Lastname,
                Age: Age
            }));
        }
    });
})
