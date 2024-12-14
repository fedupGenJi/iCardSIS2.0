const emailField = document.getElementById('admin-email');
const submitButton = document.getElementById('submitButton');
const adminForm = document.getElementById('adminForm');
const popup = document.getElementById('popup');
const closePopup = document.getElementById('closePopup');

// Regular expression to validate Gmail
const gmailRegex = /^[a-zA-Z0-9._%+-]+@gmail\.com$/;
const gmailKU = /^[a-zA-Z0-9._%+-]+@student.ku.edu.np$/;

emailField.addEventListener('input', function () {
    if (gmailRegex.test(emailField.value) || gmailKU.test(emailField.value)) {
        emailField.classList.remove('invalid');
        submitButton.disabled = false;
        submitButton.style.opacity = "1";
    } else {
        emailField.classList.add('invalid');
        submitButton.disabled = true;
        submitButton.style.opacity = "0.6";
    }
});

$(document).ready(function () {
    $('.popup').hide();

    $('#submitButton').click(function (event) {
        event.preventDefault();

        // Disable the button to prevent multiple clicks
        $(this).prop('disabled', true);

        $.ajax({
            url: '/',
            type: 'POST',
            data: $('#adminForm').serialize(),
            success: function (response) {
                console.log(response);
                if (response.success) {
                    $('#popupMessage').text(response.message || 'Registration successful');
                    $('#popupIcon').html('&#10004;');
                    $('#popupStatus').removeClass('error').addClass('success');
                    $('#popup').show();
                    $('#popupContentButton').removeClass('error').addClass('success');
                } else {
                    let errorMessage = response.error || 'An unexpected error occurred';
                    $('#popupMessage').text(errorMessage);
                    $('#popupIcon').html('&#10060;');
                    $('#popupStatus').removeClass('success').addClass('error');
                    $('#popup').show();
                    $('#popupContentButton').removeClass('success').addClass('error');
                }
            },
            error: function (xhr, status, error) {
                console.log('AJAX error:', error);
                $('#popupMessage').text('Error occurred: ' + error);
                $('#popupIcon').html('&#10060;');
                $('#popupStatus').removeClass('success').addClass('error');
                $('#popup').show();
                $('#popupContentButton').removeClass('success').addClass('error');
            },
            complete: function () {
                // Re-enable the button after the AJAX call is complete
                setTimeout(function () {
                    $('#submitButton').prop('disabled', false);
                }, 1000); // Add a 1-second delay before re-enabling
            }
        });
    });

    $('#popupContentButton').click(function () {
        $('#popup').hide();
        window.location.href = '/';
    });

    $(window).on('click', function (event) {
        if ($(event.target).is('.popup')) {
            $('#popup').hide();
            window.location.href = '/';
        }
    });
});