$(function () {

    $(".container").hide()
    $(".column").hide()

    window.addEventListener("message", function (event) {
        const item = event.data;
        if (item.type === "container") {
            if (item.status) {
                $(".container").show()
            } else {
                $(".container").hide()
            }
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post("http://M1kk4l_Policemechanic/close", JSON.stringify({}));
        }
    };

    $("#LukContainer").click(function () {
        $.post("http://M1kk4l_Policemechanic/close", JSON.stringify({}));
    });

    $("#LukColumn").click(function () {
        $.post("http://M1kk4l_Policemechanic/close", JSON.stringify({}));
    });

    $("#RepairBuy").click(function () {
        $.post("http://M1kk4l_Policemechanic/Repair", JSON.stringify({}));
    });

    $("#WashBuy").click(function () {
        $.post("http://M1kk4l_Policemechanic/Wash", JSON.stringify({}));
    });

    $("#changecolor").click(function () {
        $(".column").show()
        startup()
    });

    $("#ColorChanged").click(function () {
        $.post("http://M1kk4l_Policemechanic/close", JSON.stringify({}));
    });

    var primary;
    var defaultColor = "#0000ff";

    function startup() {
        document.getElementById("RepairBuy").disabled = true;
        document.getElementById("WashBuy").disabled = true;
        document.getElementById("changecolor").disabled = true;


        primary = document.querySelector("#primary");
        primary.value = defaultColor;
        primary.addEventListener("input", updatePrimary, false);
        primary.select();
      
      
        secondary = document.querySelector("#secondary");
        secondary.value = defaultColor;
        secondary.addEventListener("input", updateSecondary, false);
        secondary.select();
      }
      
      function updatePrimary(event) {
        color = event.target.value
        color = hexToRGB(color)
      
        rgb = color.split(",")
        $.post('http://M1kk4l_Policemechanic/primaryColor', JSON.stringify({rgb}));
      }
      
      function updateSecondary(event) {
        color = event.target.value
        color = hexToRGB(color)
      
        rgb = color.split(",")
        $.post('http://M1kk4l_Policemechanic/SecondaryColor', JSON.stringify({rgb}));
      }
      
      
      function hexToRGB(h) {
        let r = 0, g = 0, b = 0;
      
        // 3 digits
        if (h.length == 4) {
          r = "0x" + h[1] + h[1];
          g = "0x" + h[2] + h[2];
          b = "0x" + h[3] + h[3];
      
        // 6 digits
        } else if (h.length == 7) {
          r = "0x" + h[1] + h[2];
          g = "0x" + h[3] + h[4];
          b = "0x" + h[5] + h[6];
        }
      
        return ""+ +r + "," + +g + "," + +b + "";
      }
})