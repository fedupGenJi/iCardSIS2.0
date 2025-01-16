function studentData() {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', '/admin/dataPage', true);
  
    xhr.onload = function () {
      if (xhr.status >= 200 && xhr.status < 300) {
        // Log the response text (HTML in this case)
        console.log('Received HTML:', xhr.responseText);
  
        // Check if the response is JSON
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
  

  function studentData() {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', '/admin/dataPage', true);
  
    xhr.onload = function () {
      if (xhr.status >= 200 && xhr.status < 300) {
        // Check if the response is JSON
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
  
    container.innerHTML = "";
  
    data.forEach(student => {
      const smallContainer = document.createElement("div");
      smallContainer.classList.add("small-container");
  
      smallContainer.innerHTML = `
        <div class="id-card">
          <div class="id-photo">
            <img src="data:image/jpeg;base64,${student.photo}" alt="Student Photo">
          </div>
          <div class="id-details">
            <h2>${student.name}</h2>
            <p><strong>Student ID:</strong> ${student.studentId}</p>
            <p><strong>DOB:</strong> ${student.DOB}</p>
            <p><strong>Blood Group:</strong> ${student.bloodGroup}</p>
            <p><strong>Course:</strong> ${student.Course}</p>
            <p><strong>Year of Enrollment:</strong> ${student.YOE}</p>
            <p><strong>Email:</strong> ${student.Gmail}</p>
          </div>
        </div>
      `;
  
      container.appendChild(smallContainer);
    });
  }
  
  studentData();
  