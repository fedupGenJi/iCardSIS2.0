const newPassword = document.getElementById('newPassword');
const confirmPassword = document.getElementById('confirmPassword');
const passwordMismatch = document.getElementById('passwordMismatch');
const submitButton = document.getElementById('submitButton');

// Function to validate passwords
function validatePasswords() {
    if (confirmPassword.value === '') {
        confirmPassword.classList.remove('not-matching', 'matching');
    } else if (newPassword.value === confirmPassword.value) {
        confirmPassword.classList.remove('not-matching');
        confirmPassword.classList.add('matching');
        passwordMismatch.style.display = 'none';
        submitButton.disabled = false; 
    } else {
        confirmPassword.classList.remove('matching');
        confirmPassword.classList.add('not-matching');
        passwordMismatch.style.display = 'block';
        submitButton.disabled = true; 
    }
}

newPassword.addEventListener('input', validatePasswords);
confirmPassword.addEventListener('input', validatePasswords);

//Function for password see-hide and image
const toggleIcons = document.querySelectorAll('.toggle-icon');

        toggleIcons.forEach(icon => {
            icon.addEventListener('click', () => {
                const newPassword = document.getElementById('newPassword');
                const confirmPassword = document.getElementById('confirmPassword');

                const isPasswordHidden = newPassword.type === 'password';

                newPassword.type = isPasswordHidden ? 'text' : 'password';
                confirmPassword.type = isPasswordHidden ? 'text' : 'password';

                toggleIcons.forEach(i => {
                    i.src = isPasswordHidden ? '../icons/eye-open.png' : '../icons/eye-closed.png';
                });
            });
        });

        const photoInput = document.getElementById('photo');
        photoInput.addEventListener('change', () => {
            const file = photoInput.files[0];
            if (file.size > 1024 * 1024) {
                alert('Photo size exceeds 1MB. Please upload a smaller file.');
                photoInput.value = ''; // Reset file input
            }
        });