$(function(){

    function display (bool) {
        if(bool){
            $("container").show()
        } else {
            $("container").hide()
        }
    }
    display(false)
    window.addEventListener("message", function(event) {
        const item = event.data;
        if(item.type === "ui"){
            $('#balance').text("Politi Box " + item.Money + ",-")
            $('#MyMoney').text("Din bank " + item.MyMoney + ",-")

            if(item.status){
                display(true)
            } else {
                display(false)
            }
        }
    
    })
    
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post("http://M1kk4l_Politibox/exit", JSON.stringify({}));
        }
    };

    $("#Luk").click(function(){
        $.post("http://M1kk4l_Politibox/exit", JSON.stringify({}));
    });

    $("#Indsæt").click(function(){
        let input = $("input").val()

        if(input.length <= 0) {
            swal({
                title: "Kontakt Besked ikke Sendt!",
                text: "Du skal opfylde alle bokse!",
                icon: "error",
            })
        } else {
            $.post('http://M1kk4l_Politibox/Indset', JSON.stringify({
                Antal: input
            }));
            $.post("http://M1kk4l_Politibox/exit", JSON.stringify({}));
        }
    });

    $("#Hæv").click(function(){
        let input = $("input").val()

        if(input.length <= 0) {
            swal({
                title: "Kontakt Besked ikke Sendt!",
                text: "Du skal opfylde alle bokse!",
                icon: "error",
            })
        } else {
            $.post('http://M1kk4l_Politibox/Hev', JSON.stringify({
                Antal: input
            }));
            $.post("http://M1kk4l_Politibox/exit", JSON.stringify({}));
        }
    });
})
