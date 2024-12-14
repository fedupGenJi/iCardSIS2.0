const newPassword = document.getElementById('newPassword');
const confirmPassword = document.getElementById('confirmPassword');
const passwordMismatch = document.getElementById('passwordMismatch');
const submitButton = document.getElementById('submitButton');
const photoInput = document.getElementById('photo');
const ciphertext = new URLSearchParams(window.location.search).get('email');

// Function to validate passwords
function validatePasswords() {
    if (confirmPassword.value === '') {
        confirmPassword.classList.remove('not-matching', 'matching');
        passwordMismatch.style.display = 'none';
    } else if (newPassword.value === confirmPassword.value) {
        confirmPassword.classList.remove('not-matching');
        confirmPassword.classList.add('matching');
        passwordMismatch.style.display = 'none';
    } else {
        confirmPassword.classList.remove('matching');
        confirmPassword.classList.add('not-matching');
        passwordMismatch.style.display = 'block';
    }

    checkFormValidity();
}

// File size validation and check for file presence
function validateFileInput() {
    const file = photoInput.files[0];
    if (!file) {
        console.log('No file selected.');
        return false;
    }

    if (file.size > 4 * 1024 * 1024) {
        alert('Photo size exceeds 4MB. Please upload a smaller file.');
        photoInput.value = '';
        return false;
    }

    return true;
}

// Check overall form validity
function checkFormValidity() {
    const isPasswordValid = newPassword.value && newPassword.value === confirmPassword.value;
    const isPhotoValid = validateFileInput();
    submitButton.disabled = !(isPasswordValid && isPhotoValid); // Enable if both conditions are true
}

// Event listeners for input changes
newPassword.addEventListener('input', validatePasswords);
confirmPassword.addEventListener('input', validatePasswords);
photoInput.addEventListener('change', () => {
    validateFileInput();
    checkFormValidity();
});

$(document).ready(function () {
    console.log('Script is loaded and jQuery is ready.');

    const toggleIcons = document.querySelectorAll('.toggle-icon');
    console.log('Toggle icons:', toggleIcons);

    toggleIcons.forEach(icon => {
        icon.addEventListener('click', () => {
            const isPasswordHidden = newPassword.type === 'password';
            newPassword.type = isPasswordHidden ? 'text' : 'password';
            confirmPassword.type = isPasswordHidden ? 'text' : 'password';

            toggleIcons.forEach(i => {
                const eyeOpenPath = i.src.replace('eye-closed.png', 'eye-open.png');
                const eyeClosedPath = i.src.replace('eye-open.png', 'eye-closed.png');
                i.src = isPasswordHidden ? eyeOpenPath : eyeClosedPath;
            });
        });
    });
});


// Handle form submission
$(document).ready(function () {
    $('.popup').hide();

    $('#submitButton').click(function (event) {
        event.preventDefault();

        // Disable button
        $(this).prop('disabled', true);

        // Debug the URL and FormData
        console.log('AJAX URL:', '/registrationConfig?email=' + encodeURIComponent(ciphertext));
        console.log('Ciphertext:', ciphertext);

        if (!photoInput.files.length) {
            alert('Please upload a photo.');
            $(this).prop('disabled', false);
            return;
        }

        const formData = new FormData();
        formData.append('confirmPassword', confirmPassword.value);
        formData.append('photo', photoInput.files[0]);

        console.log('File included:', photoInput.files[0].name);

        $.ajax({
            url: '/registrationConfig?email=' + encodeURIComponent(ciphertext),
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                console.log('Response:', response);
                if (response.success) {
                    $('#popupMessage').text(response.message || 'Configuration successful');
                    $('#popupIcon').html('&#10004;');
                    $('#popupStatus').removeClass('error').addClass('success');
                    $('#popup').show();
                } else {
                    $('#popupMessage').text(response.error || 'An unexpected error occurred');
                    $('#popupIcon').html('&#10060;');
                    $('#popupStatus').removeClass('success').addClass('error');
                    $('#popup').show();
                }
            },
            error: function (xhr, status, error) {
                console.log('AJAX error:', error);
                $('#popupMessage').text('Error occurred: ' + error);
                $('#popupIcon').html('&#10060;');
                $('#popupStatus').removeClass('success').addClass('error');
                $('#popup').show();
            },
            complete: function () {
                setTimeout(() => $('#submitButton').prop('disabled', false), 1000);
            }
        });
    });

    $('#popupContentButton').click(function () {
        $('#popup').hide();
    });

    $(window).on('click', function (event) {
        if ($(event.target).is('.popup')) {
            $('#popup').hide();
        }
    });
});