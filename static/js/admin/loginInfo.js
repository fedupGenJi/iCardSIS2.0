let studentDatabase = [];
function studentData() {
const xhr = new XMLHttpRequest();
xhr.open('GET', '/api/login', true);

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

    clone.querySelector("h2").textContent = student.studentId;
    clone.querySelector(".phone-number").textContent = student.phoneNo;
    clone.querySelector(".email").textContent = student.Gmail;
    clone.querySelector(".pin").textContent = "****";
    clone.querySelector(".password").textContent = "********";

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

            clonex.querySelector("h2").textContent = student.studentId;
            clonex.querySelector(".phone-number").textContent = student.phoneNo;
            clonex.querySelector(".email").textContent = student.Gmail;

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

document.addEventListener("DOMContentLoaded", function () {
  document.addEventListener("click", function (event) {
      const deleteButton = event.target.closest("#deletexx-button");
      if (deleteButton) {
          const idCardContainer = deleteButton.closest(".small-container");
          if (idCardContainer) {
              const studentIdElement = idCardContainer.querySelector("h2");
              if (studentIdElement) {
                  const studentId = studentIdElement.textContent.trim();
                  console.log(`Delete button clicked for Student ID: ${studentId}`);

                  const confirmDialog = document.getElementById("custom-confirm-dialog");
                  confirmDialog.style.display = "flex";

                  const confirmYes = document.getElementById("confirm-yes");
                  confirmYes.replaceWith(confirmYes.cloneNode(true));
                  const newConfirmYes = document.getElementById("confirm-yes");

                  newConfirmYes.addEventListener("click", function () {
                      confirmDialog.style.display = "none";

                      const xhrx = new XMLHttpRequest();
                      xhrx.open("DELETE", "/api/login", true);
                      xhrx.setRequestHeader("Content-Type", "application/json");

                      xhrx.onload = function () {
                          const popup = document.querySelector(".login-popup");
                          const popupContent = document.querySelector(".popup-content");
                          const popupMessage = document.querySelector("#popup-message");
                          const popupTitle = document.querySelector(".popup-content h2");
                          const closeBtn = document.querySelector("#close-popup");

                          if (xhrx.status === 200) {
                              popupContent.classList.remove("errorx");
                              popupContent.classList.add("success");

                              popupTitle.innerHTML = '<span class="success-icon">&#10004;</span> Success!';
                              popupMessage.textContent = `Student ID ${studentId} has been successfully deleted.`;
                              popup.style.display = "flex";

                              closeBtn.replaceWith(closeBtn.cloneNode(true));
                              const newCloseBtn = document.getElementById("close-popup");

                              newCloseBtn.addEventListener("click", function () {
                                  popup.style.display = "none";
                                  location.reload();
                              });
                          } else {
                              popupContent.classList.remove("success");
                              popupContent.classList.add("errorx");

                              popupTitle.innerHTML = '<span class="error-icon">&#10006;</span> Failure!';

                              let errorMessage = "An unexpected error occurred.";
                              try {
                                  const response = JSON.parse(xhrx.responseText);
                                  errorMessage = response.error || response.databaseError || errorMessage;
                              } catch (e) {
                                  console.error("Error parsing response:", e);
                              }

                              popupMessage.textContent = `Failed to delete Student ID ${studentId}. ${errorMessage}`;
                              popup.style.display = "flex";

                              closeBtn.replaceWith(closeBtn.cloneNode(true));
                              const newCloseBtn = document.getElementById("close-popup");

                              newCloseBtn.addEventListener("click", function () {
                                  popup.style.display = "none";
                              });
                          }
                      };

                      xhrx.onerror = function () {
                          const popup = document.querySelector(".login-popup");
                          const popupContent = document.querySelector(".popup-content");
                          const popupMessage = document.querySelector("#popup-message");
                          const popupTitle = document.querySelector(".popup-content h2");
                          const closeBtn = document.querySelector("#close-popup");

                          popupContent.classList.remove("success");
                          popupContent.classList.add("errorx");

                          popupTitle.innerHTML = '<span class="error-icon">&#10006;</span> Error!';
                          popupMessage.textContent = "An error occurred while sending the request.";
                          popup.style.display = "flex";

                          closeBtn.replaceWith(closeBtn.cloneNode(true));
                          const newCloseBtn = document.getElementById("close-popup");

                          newCloseBtn.addEventListener("click", function () {
                              popup.style.display = "none";
                          });
                      };

                      xhrx.send(JSON.stringify({ student_id: studentId }));
                  });

                  const confirmNo = document.getElementById("confirm-no");
                  confirmNo.replaceWith(confirmNo.cloneNode(true));
                  const newConfirmNo = document.getElementById("confirm-no");

                  newConfirmNo.addEventListener("click", function () {
                      confirmDialog.style.display = "none";
                  });

              } else {
                  console.log("Student ID element not found.");
              }
          } else {
              console.log("Parent container not found.");
          }
      }
  });
});