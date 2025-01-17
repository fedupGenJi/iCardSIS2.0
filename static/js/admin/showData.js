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
  