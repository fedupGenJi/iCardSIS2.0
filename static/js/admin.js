const emailField = document.getElementById('admin-email');
const submitButton = document.getElementById('submitButton');
const adminForm = document.getElementById('adminForm');
const popup = document.getElementById('popup');
const closePopup = document.getElementById('closePopup');

// Regular expression to validate Gmail
const gmailRegex = /^[a-zA-Z0-9._%+-]+@gmail\.com$/;

emailField.addEventListener('input', function () {
    if (gmailRegex.test(emailField.value)) {
        emailField.classList.remove('invalid');
        submitButton.disabled = false;
        submitButton.style.opacity = "1";
    } else {
        emailField.classList.add('invalid');
        submitButton.disabled = true;
        submitButton.style.opacity = "0.6";
    }
});

adminForm.addEventListener('submit', function (event) {
    event.preventDefault();

    popup.style.display = 'flex';
});

closePopup.addEventListener('click', function () {
    popup.style.display = 'none';
});
