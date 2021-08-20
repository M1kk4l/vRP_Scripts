$(function(){
    
    $(".main-background").hide()

    window.addEventListener("message", function(event) {
        const item = event.data;
        if(item.type === "ui"){

            if(item.status){
                $(".main-background").show()
            } else {
                $(".main-background").hide()
            }
        }

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
                $.post(`http://${item.resource}/ChangenIdentity`, JSON.stringify({
                    Firname: Firname,
                    Lastname: Lastname,
                    Age: Age
                }));
            }
        });
    })
})
