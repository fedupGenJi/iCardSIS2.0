const input = document.getElementById('year');
input.addEventListener('input', () => {
  const value = input.value;
  input.value = value.replace(/\D/g, '').slice(0, 4);
});

const inputy = document.getElementById('yoe');
inputy.addEventListener('input', () => {
  const value = inputy.value;
  inputy.value = value.replace(/\D/g, '').slice(0, 4);
});

const inputx = document.getElementById('month');
inputx.addEventListener('input', () => {
  const value = inputx.value;
  inputx.value = value.replace(/\D/g, '').slice(0, 2);
});

const inputxx = document.getElementById('date');
inputxx.addEventListener('input', () => {
  const value = inputxx.value;
  inputxx.value = value.replace(/\D/g, '').slice(0, 2);
});

const photoBox = document.querySelector('.photo-box');
const photoUploadInput = document.createElement('input');
photoUploadInput.type = 'file';
photoUploadInput.accept = 'image/*';
photoUploadInput.style.display = 'none';
document.body.appendChild(photoUploadInput);

photoBox.addEventListener('click', () => {
  photoUploadInput.click();
});

photoUploadInput.addEventListener('change', (event) => {
  const file = event.target.files[0];
  if (file) {
    const reader = new FileReader();
    reader.onload = function (e) {
      photoBox.style.backgroundImage = `url(${e.target.result})`;
      photoBox.style.backgroundSize = 'cover';
      photoBox.style.backgroundPosition = 'center';
      photoBox.textContent = '';
    };
    reader.readAsDataURL(file);
  }
});

function showError(element, message) {
  const errorElement = element.parentElement.querySelector('.error');
  if (errorElement) {
    errorElement.textContent = message;
    errorElement.classList.add('visible');
  }
}

function hideError(element) {
  const errorElement = element.parentElement.querySelector('.error');
  if (errorElement) {
    errorElement.textContent = '';
    errorElement.classList.remove('visible');
  }
}

function validateForm() {
  const photoBox = document.querySelector('.photo-box');
  const photoUploadInput = document.querySelector('input[type="file"]');
  const fullName = document.querySelector('input[placeholder="Full Name"]');
  const yearInput = document.getElementById('year');
  const monthInput = document.getElementById('month');
  const dateInput = document.getElementById('date');
  const bloodGroup = document.querySelector('input[placeholder="Blood Group"]');
  const sex = document.querySelector('select');
  const email = document.querySelector('input[type="email"]');
  const course = document.querySelector('input[placeholder="Course"]');
  const yoeInput = document.getElementById('yoe');
  const currentYear = new Date().getFullYear();

  let valid = true;

  if (!photoUploadInput.files[0]) {
    showError(photoBox, 'Photo is required.');
    valid = false;
  } else if (photoUploadInput.files[0].size > 4 * 1024 * 1024) {
    showError(photoBox, 'Photo must be less than 4MB.');
    valid = false;
  } else {
    hideError(photoBox);
  }

  if (!fullName.value.trim()) {
    showError(fullName, 'Full Name is required.');
    valid = false;
  } else {
    hideError(fullName);
  }

  const year = parseInt(yearInput.value, 10);
  const month = parseInt(monthInput.value, 10);
  const date = parseInt(dateInput.value, 10);

  if (!yearInput.value || !monthInput.value || !dateInput.value) {
    showError(yearInput, 'Date of Birth is required.');
    showError(monthInput, '');
    showError(dateInput, '');
    valid = false;
  } else if (
    isNaN(year) || isNaN(month) || isNaN(date) ||
    month < 1 || month > 12 ||
    year > currentYear ||
    (date < 1 || date > (month === 2 ? 29 : [4, 6, 9, 11].includes(month) ? 30 : 31))
  ) {
    showError(yearInput, 'Invalid Date of Birth.');
    showError(monthInput, '');
    showError(dateInput, '');
    valid = false;
  } else {
    hideError(yearInput);
    hideError(monthInput);
    hideError(dateInput);
  }

  const validBloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  if (!bloodGroup.value.trim() || !validBloodGroups.includes(bloodGroup.value.trim().toUpperCase())) {
    showError(bloodGroup, 'Invalid Blood Group.');
    valid = false;
  } else {
    hideError(bloodGroup);
  }

  if (sex.value === 'Choose') {
    showError(sex, 'Please select your sex.');
    valid = false;
  } else {
    hideError(sex);
  }

  const emailRegex = /^[a-zA-Z0-9._%+-]+@gmail\.com$/;
  if (!emailRegex.test(email.value.trim())) {
    showError(email, 'Invalid Gmail address.');
    valid = false;
  } else {
    hideError(email);
  }

  if (!course.value.trim()) {
    showError(course, 'Course is required.');
    valid = false;
  } else {
    hideError(course);
  }

  const yoe = parseInt(yoeInput.value, 10);
  if (
    !yoeInput.value.trim() ||
    isNaN(yoe) ||
    yoe < year ||
    yoe > currentYear
  ) {
    showError(yoeInput, `Invalid YOE.`);
    valid = false;
  } else {
    hideError(yoeInput);
  }

  return valid;
}

document.querySelector('input[type="checkbox"]').addEventListener('click', (event) => {
  const isValid = validateForm();
  if (!isValid) {
    event.preventDefault();
  }
});

document.addEventListener('DOMContentLoaded', function () {
  const checkbox = document.querySelector('.checkboxxx input[type="checkbox"]');
  const submitButton = document.getElementById('submit-btn');

  function toggleSubmitButton() {
    submitButton.disabled = !checkbox.checked;
  }

  checkbox.addEventListener('change', toggleSubmitButton);
  toggleSubmitButton();
});