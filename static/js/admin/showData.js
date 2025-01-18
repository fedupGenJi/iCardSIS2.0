let studentDatabase = [];
function studentData() {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', '/api/students', true);
  
    xhr.onload = function () {
      if (xhr.status >= 200 && xhr.status < 300) {
        const contentType = xhr.getResponseHeader('Content-Type');
        if (contentType && contentType.includes('application/json')) {
          try {
            const data = JSON.parse(xhr.responseText);
            populateIDCards(data); 
          } catch (error) {
            console.error('Error parsing student data:', error);
          }
        } else {
          console.error('Expected JSON but received:', contentType);
        }
      } else {
        console.error('Error fetching student data:', xhr.statusText);
      }
    };
  
    xhr.onerror = function () {
      console.error('Request failed');
    };
  
    xhr.send();
  }
    
  function populateIDCards(data) {
    const container = document.querySelector(".data-container");
    const template = document.getElementById("id-card-template");
  
    container.innerHTML = "";
  
    data.forEach(student => {
      studentDatabase.push({...student});
      const clone = template.content.cloneNode(true);
  
      clone.querySelector(".id-photo img").src = `data:image/jpeg;base64,${student.photo}`;
      clone.querySelector("h2").textContent = student.name;
      clone.querySelector(".student-id").textContent = student.studentId;
      clone.querySelector(".dob").textContent = student.DOB;
      clone.querySelector(".blood-group").textContent = student.bloodGroup;
      clone.querySelector(".course").textContent = student.Course;
      clone.querySelector(".yoe").textContent = student.YOE;
      clone.querySelector(".email").textContent = student.Gmail;
  
      container.appendChild(clone);
    });
  }
  
  
  studentData();
  
  const input = document.getElementById('studentIdd');
  const searchBtn = document.getElementById('searchBtn');

  input.addEventListener('input', () => {
      let value = input.value;

      if (value.length > 4) {
          value = value.slice(0, 4);
          input.value = value;
      }

      if (value.length === 4) {
          searchBtn.disabled = false;
      } else {
          searchBtn.disabled = true;
      }
  });

  document.addEventListener('DOMContentLoaded', () => {
    const templatexx = document.getElementById("id-card-template");

    if (!templatexx || !templatexx.content) {
        console.error("Template with id 'id-card-template' is missing or invalid.");
        return;
    }

    function searchStudentById(idd) {
        const containerxx = document.querySelector(".data-container");
        containerxx.innerHTML = '';

        const student = studentDatabase.find(student => String(student.studentId) === String(idd));

        if (student) {
            const clonex = templatexx.content.cloneNode(true);

            clonex.querySelector('.id-photo img').src = `data:image/jpeg;base64,${student.photo}`;
            clonex.querySelector('h2').textContent = student.name;
            clonex.querySelector('.student-id').textContent = student.studentId;
            clonex.querySelector('.dob').textContent = student.DOB;
            clonex.querySelector('.blood-group').textContent = student.bloodGroup;
            clonex.querySelector('.course').textContent = student.Course;
            clonex.querySelector('.yoe').textContent = student.YOE;
            clonex.querySelector('.email').textContent = student.Gmail;

            containerxx.appendChild(clonex);
        } else {
            showPopupx('Student not found.');
        }
    }

    const searchBtn = document.getElementById('searchBtn');
    searchBtn.addEventListener('click', () => {
        const studentIdd = document.getElementById('studentIdd').value;
        searchStudentById(studentIdd);
    });

    function showPopupx(message) {
      const popup = document.querySelector('.login-popup');
      const popupMessage = document.getElementById('popup-message');
  
      const existingIcon = popup.querySelector('.error-icon');
      if (existingIcon) existingIcon.remove();
  
      const errorIcon = document.createElement('span');
      errorIcon.classList.add('error-icon');
      errorIcon.innerHTML = '&#9888;'; 
  
      popupMessage.textContent = message;
      popupMessage.prepend(errorIcon);
  
      popup.querySelector('h2').textContent = '404';
      popup.querySelector('.popup-content').classList.add('errorx');
  
      popup.style.display = 'flex';
  
      const closePopup = document.getElementById('close-popup');
      closePopup.addEventListener('click', () => {
          popup.style.display = 'none';
          location.reload();
      });
  }
  
});