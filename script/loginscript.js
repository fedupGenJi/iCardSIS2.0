const icon = document.getElementById("icon");
const pass = document.getElementById("password");

icon.onclick = function() {
    if(pass.type === "password") {
        pass.type = "text";
        icon.src = "../assests/icons/lock-open-solid-24.png";
    }
    else {
        pass.type = "password";
        icon.src = "../assests/icons/lock-solid-24.png";
    }
}