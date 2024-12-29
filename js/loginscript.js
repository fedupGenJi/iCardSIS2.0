const icon = document.getElementById("icon");
const pass = document.getElementById("password");
const gmailInput = document.getElementById("gmail");
const loginBtn = document.getElementById("login-btn");

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

// Validate Gmail input
gmailInput.addEventListener("input", function () {
    const gmailPattern = /^[a-zA-Z0-9._%+-]+@(gmail\.com|student\.ku\.edu\.np)$/;
    const isValid = gmailPattern.test(gmailInput.value);

    if (isValid) {
        gmailInput.parentElement.classList.remove("invalid");
        loginBtn.disabled = false;
    } else {
        gmailInput.parentElement.classList.add("invalid");
        loginBtn.disabled = true;
    }
});