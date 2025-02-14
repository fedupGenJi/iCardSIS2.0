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
                  confirmDialog.style.display = "block";

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

document.addEventListener("DOMContentLoaded", function () {
    document.addEventListener("click", function (event) {
        const updatePopup = document.getElementById("update-popup");
        const popupContent = document.querySelector(".popup-content");
        
        if (event.target.closest("#updatexx-button")) {
            const idCardContainer = event.target.closest(".small-container");
            if (idCardContainer) {
                const studentIdElement = idCardContainer.querySelector("h2");
                if (studentIdElement) {
                    const studentId = studentIdElement.textContent.trim();
                    console.log(`Update button clicked for Student ID: ${studentId}`);

                    const student = studentDatabase.find(st => String(st.studentId) === String(studentId));

                    if (student) {
                        document.getElementById("popup-student-id").textContent = `Student ID: ${student.studentId}`;
                        document.getElementById("popup-phone-number").textContent = student.phoneNo;
                        document.getElementById("popup-email").textContent = student.Gmail;

                        updatePopup.style.display = "flex";
                    } else {
                        console.error("Student data not found.");
                    }
                }
            }
        }

        if (event.target === updatePopup) {
            updatePopup.style.display = "none";
        }
    });
});

let passwordChanged = false;
let pinChanged = false;

function openPasswordPopup() {
    document.getElementById("password-container").style.display = "block";
    document.getElementById("overlay").style.display = "block";
}

function openPinPopup() {
    document.getElementById("pin-container").style.display = "block";
    document.getElementById("overlayxx").style.display = "block";
}

function validatePin(input) {
    input.value = input.value.replace(/\D/g, '').slice(0, 4);
}

document.getElementById("overlay").addEventListener("click", function (event) {
    if (event.target.id === "overlay") {
        closePasswordPopup();
    }
});

document.getElementById("overlayxx").addEventListener("click", function (event) {
    if (event.target.id === "overlayxx") {
        closePinPopup();
    }
});

function closePasswordPopup() {
    document.getElementById("password-container").style.display = "none";
    document.getElementById("overlay").style.display = "none";

    document.getElementById("new-password").value = "";
    document.getElementById("confirm-password").value = "";
}

function closePinPopup() {
    document.getElementById("pin-container").style.display = "none";
    document.getElementById("overlayxx").style.display = "none";

    document.getElementById("new-pin").value = "";
    document.getElementById("confirm-pin").value = "";
}

function validatePin(input) {
    input.value = input.value.replace(/\D/g, '').slice(0, 4);
}

function updatePassword() {
    let newPassword = document.getElementById("new-password").value;
    let confirmPassword = document.getElementById("confirm-password").value;
    let popupContent = document.querySelector(".popup-content");
    let popupMessage = document.getElementById("popup-message");
    let popupTitle = document.querySelector(".popup-content h2");

    if (newPassword && confirmPassword) {
        if (newPassword === confirmPassword) {
            popupContent.classList.add("success");
            popupContent.classList.remove("errorx");
            popupTitle.innerHTML = '<span class="success-icon">✔</span> Success';
            popupMessage.innerText = "Password updated successfully!";
            passwordChanged = true;
        } else {
            popupContent.classList.add("errorx");
            popupContent.classList.remove("success");
            popupTitle.innerHTML = '<span class="error-icon">✖</span> Error';
            popupMessage.innerText = "Passwords do not match. Please try again.";
            passwordChanged = false;
        }
        showPopup();
    } else {
        popupContent.classList.add("errorx");
        popupContent.classList.remove("success");
        popupTitle.innerHTML = '<span class="error-icon">!</span> Error';
        popupMessage.innerText = "Both fields are required.";
        passwordChanged = false;
    }
    showPopup();
}

function updatePin() {
    let newPin = document.getElementById("new-pin").value;
    let confirmPin = document.getElementById("confirm-pin").value;
    let popupContent = document.querySelector(".popup-content");
    let popupMessage = document.getElementById("popup-message");
    let popupTitle = document.querySelector(".popup-content h2");

    if(newPin.length != 4)
    {
        popupContent.classList.add("errorx");
        popupContent.classList.remove("success");
        popupTitle.innerHTML = '<span class="error-icon">??</span> Error';
        popupMessage.innerText = "4 digit pin is required.";
        pinChanged = false;
    }
    else{
        if (newPin && confirmPin) {
            if (newPin === confirmPin) {
                popupContent.classList.add("success");
                popupContent.classList.remove("errorx");
                popupTitle.innerHTML = '<span class="success-icon">✔</span> Success';
                popupMessage.innerText = "Pin updated successfully!";
                pinChanged = true;
            } else {
                popupContent.classList.add("errorx");
                popupContent.classList.remove("success");
                popupTitle.innerHTML = '<span class="error-icon">✖</span> Error';
                popupMessage.innerText = "Pin do not match. Please try again.";
                pinChanged = false;
            }
        } else {
            popupContent.classList.add("errorx");
            popupContent.classList.remove("success");
            popupTitle.innerHTML = '<span class="error-icon">!</span> Error';
            popupMessage.innerText = "Both fields are required.";
            pinChanged = false;
        }
    }
    showPopup();
}

function showPopup() {
    let popup = document.querySelector(".login-popup");
    popup.style.display = "flex";
}

function closePopup() {
    let popup = document.querySelector(".login-popup");
    popup.style.display = "none";
    if(passwordChanged){
        closePasswordPopup();
    }
    if(pinChanged)
    {
        closePinPopup();
    }
    if (!passwordChanged) {
        document.getElementById("password-container").style.display = "block";
    }
}
document.getElementById("close-popup").addEventListener("click", closePopup);