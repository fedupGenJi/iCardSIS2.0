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
      clone.querySelector(".sex").textContent = student.sex;
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
            clonex.querySelector(".sex").textContent = student.sex;
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

document.addEventListener("DOMContentLoaded", function () {
  document.addEventListener("click", function (event) {
    const deleteButton = event.target.closest("#deletexx-button");
    if (deleteButton) {
      const idCardContainer = deleteButton.closest(".small-container");
      if (idCardContainer) {
        const studentIdElement = idCardContainer.querySelector(".student-id");
        if (studentIdElement) {
          const studentId = studentIdElement.textContent.trim();
          console.log(`Delete button clicked for Student ID: ${studentId}`);

          const confirmDialog = document.getElementById("custom-confirm-dialog");
          confirmDialog.style.display = "block";

          const confirmYes = document.getElementById("confirm-yes");
          confirmYes.replaceWith(confirmYes.cloneNode(true));
          const newConfirmYes = document.getElementById("confirm-yes");

          newConfirmYes.addEventListener("click", function () {
            console.log(`Deleted Student ID: ${studentId}`);
            confirmDialog.style.display = "none";

            const xhrx = new XMLHttpRequest();
            xhrx.open("DELETE", "/api/students", true);
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

document.addEventListener("DOMContentLoaded",function(){
  const popup = document.getElementById("data-container-popup");
  const popupContent = popup.querySelector(".popup-contentx");
  document.addEventListener("click",function(event){
    const updateButton = event.target.closest('#updatexx-button');
    if(updateButton){
      const idCardContainer = updateButton.closest(".small-container");
      if(idCardContainer){
        const studentIdElement = idCardContainer.querySelector(".student-id");
        if(studentIdElement){
          const studentId = studentIdElement.textContent.trim();
          //console.log(`Updatexx button clicked for Student ID: ${studentId}`);
          const studentxx = studentDatabase.find(student => String(student.studentId) === String(studentId));
          if (studentxx) {
            //console.log('Student Data Found');
            const photosrc = `data:image/jpeg;base64,${studentxx.photo}`;
            popupContent.innerHTML = `
              <div class="small-container">
                <div class="id-card">
                  <div class = "id-photo">
                    <img src=${photosrc} alt="Student Avatar">
                  </div>
                  <div class ="id-details">
                    <p><strong>Name:&nbsp;&nbsp;</strong> <span class="editable" data-key="name">${studentxx.name}</span> <button class="edit-btn"></button></p>
                    <p><strong>Student Id:&nbsp;&nbsp;</strong> <span data-key="studentId">${studentxx.studentId}</span></p>
                    <p><strong>DOB:&nbsp;&nbsp;</strong> <span class="editable" data-key="dob">${studentxx.DOB}</span> <button class="edit-btn"></button></p>
                    <p><strong>Blood Group:&nbsp;&nbsp;</strong> <span class="editable" data-key="bloodGroup">${studentxx.bloodGroup}</span> <button class="edit-btn"></button></p>
                    <p><strong>Sex:&nbsp;&nbsp;</strong> ${studentxx.sex} </p>
                    <p><strong>Course:&nbsp;&nbsp;</strong> <span class="editable" data-key="course">${studentxx.Course}</span> <button class="edit-btn"></button></p>
                    <p><strong>Year of Enrollment:&nbsp;&nbsp;</strong> ${studentxx.YOE}</p>
                    <p><strong>Email:&nbsp;&nbsp;</strong> ${studentxx.Gmail}</p>
                  </div>
                </div>
                <div class="save-changes-btn">
                  <button class="save-changes">
                    <span class="save-text">Save Changes </span>
                  </button>
                </div>
              </div>
            `;
            const saveChangesButton = document.querySelector(".save-changes");

            if (saveChangesButton) {
                const img = document.createElement("img");
                img.classList.add("save-changes-img"); 
                img.src = "../../../static/assests/icons/user.png";
                
                saveChangesButton.prepend(img);
            }
            popup.classList.remove("hidden");

            
          } else {
             console.log('Student not found in the database.');
          }
        }else {
          console.log("Student ID element not found.");
        }
      }else {
        console.log("Parent container not found.");
      }
    }
  });

  document.addEventListener("click", function (event) {
    window.addEventListener("click", (event) => {
      if (event.target === popup) {
          popup.classList.add("hidden");
      }
  });
  });

  document.addEventListener("click", function (event) {
    const editButton = event.target.closest(".edit-btn");
    if (editButton) {
      const editableSpan = editButton.previousElementSibling;
      if (editableSpan && editableSpan.classList.contains("editable")) {
        editableSpan.setAttribute("contenteditable", "true");
        editableSpan.focus();
        
        editableSpan.style.border = "1px solid #000";
        editableSpan.style.padding = "2px";
        editableSpan.style.background = "white";
        editButton.style.display = "none";
  
        const saveChanges = () => {
          editableSpan.removeAttribute("contenteditable");
          editableSpan.style.border = "none";
          editableSpan.style.padding = "0";
          editButton.style.display = "inline";
          editableSpan.style.background = "transparent";
          editableSpan.removeEventListener("blur", saveChanges);
          editableSpan.removeEventListener("keydown", handleKeydown);
        };
  
        const handleKeydown = (e) => {
          if (e.key === "Enter") {
            e.preventDefault();
            saveChanges();
          }
        };
  
        editableSpan.addEventListener("blur", saveChanges);
        editableSpan.addEventListener("keydown", handleKeydown);
      }
    }
  });
  
  document.addEventListener("click", function (event) {
    const saveChangesButton = event.target.closest(".save-changes");
    if (saveChangesButton) {
        const popup = document.querySelector(".login-popup");
        const popupMessage = document.getElementById("popup-message");
        const popupContent = popup.querySelector(".popup-content");
        const popupTitle = popup.querySelector("h2");

        const dobElement = document.querySelector(".popup-contentx [data-key='dob']");
        const bloodGroupElement = document.querySelector(".popup-contentx [data-key='bloodGroup']");
        const studentIdElement = document.querySelector(".popup-contentx [data-key='studentId']");
        const nameElement = document.querySelector(".popup-contentx [data-key='name']");
        const courseElement = document.querySelector(".popup-contentx [data-key='course']");

        let isValid = true;
        let errorMessages = [];

        const dobValue = dobElement ? dobElement.textContent.trim() : "";
        const dobRegex = /^\d{4}-\d{2}-\d{2}$/;
        if (!dobRegex.test(dobValue)) {
            errorMessages.push("Invalid Date of Birth. Format must be YYYY-MM-DD.");
            dobElement.style.border = "2px solid red";
            dobElement.style.background = "#ffebeb";
            isValid = false;
        } else {
            dobElement.style.border = "none";
            dobElement.style.background = "transparent";
        }

        const bloodGroupValue = bloodGroupElement ? bloodGroupElement.textContent.trim().toUpperCase() : "";
        const validBloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
        if (!validBloodGroups.includes(bloodGroupValue)) {
            errorMessages.push("Invalid Blood Group.");
            bloodGroupElement.style.border = "2px solid red";
            bloodGroupElement.style.background = "#ffebeb";
            isValid = false;
        } else {
            bloodGroupElement.style.border = "none";
            bloodGroupElement.style.background = "transparent";
        }

        if (popup) {
            popup.style.display = "flex";
            if (isValid) {
                const updatedData = {
                    studentId: studentIdElement ? studentIdElement.textContent.trim() : "",
                    name: nameElement ? nameElement.textContent.trim() : "",
                    dob: dobValue,
                    bloodGroup: bloodGroupValue,
                    course: courseElement ? courseElement.textContent.trim() : ""
                };

                //console.log("Updated Data:", updatedData);

                /* popupContent.classList.remove("errorx");
                popupContent.classList.add("success");
                popupTitle.textContent = "Success";
                popupMessage.innerHTML = "<p>Changes saved successfully!</p>"; */

                const xhrx = new XMLHttpRequest();
                xhrx.open("PUT", "/api/students", true);
                xhrx.setRequestHeader("Content-Type", "application/json");

                xhrx.onreadystatechange = function () {
                    if (xhrx.readyState === 4) {
                        if (xhrx.status === 200) {
                            popupContent.classList.remove("errorx");
                            popupContent.classList.add("success");
                            popupTitle.textContent = "Success";
                            popupMessage.innerHTML = "<p>Changes saved successfully!</p>";
                        } else {
                            popupContent.classList.remove("success");
                            popupContent.classList.add("errorx");
                            popupTitle.textContent = "Error";
                            popupMessage.innerHTML = `<p>Failed to save changes. Server responded with status ${xhrx.status}.</p>`;
                        }
                    }
                };

                xhrx.send(JSON.stringify(updatedData));

            } else {
                popupContent.classList.remove("success");
                popupContent.classList.add("errorx");
                popupTitle.textContent = "Validation Error";
                popupMessage.innerHTML = errorMessages.map(msg => `<p>${msg}</p>`).join("");
            }
        }
    }
});

document.getElementById("close-popup").addEventListener("click", function () {
  const popup = document.querySelector(".login-popup");
  const popupContent = document.querySelector(".popup-content");
  if (popup) {
      popup.style.display = "none";
  }

  if (popupContent.classList.contains("success")) {
      location.reload();
  }
});


  
});