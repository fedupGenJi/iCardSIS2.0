function fetchEmployees() {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', '/api/employees', true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            const employees = JSON.parse(xhr.responseText);
            displayEmployees(employees);
        }
    };
    xhr.send();
}

function displayEmployees(employees) {
    const employeeList = document.getElementById('employee-list');
    employeeList.innerHTML = "";
    employees.forEach(employee => {
        const employeeDiv = document.createElement('div');
        employeeDiv.classList.add('employee');
        const photoSrc = employee.photo ? `data:image/jpeg;base64,${employee.photo}` : 'static/icons/default-profile.jpg';
        employeeDiv.innerHTML = `
            <img src="${photoSrc}" alt="Profile Photo" class="photo">
            <div class="details">
                <p><strong>Name:</strong> ${employee.userName}</p>
                <p><strong>Admin ID:</strong> ${employee.adminId}</p>
                <p><strong>Email:</strong> ${employee.Gmail}</p>
                <p><strong>Status:</strong> ${employee.status}</p>
            </div>
            <button type="button" class="delete-btn">Delete</button>
        `;
        employeeList.appendChild(employeeDiv);
    });
    addDeleteListeners();
}

function addDeleteListeners() {
    const employeeList = document.getElementById('employee-list');
    const confirmDialog = document.getElementById('custom-confirm-dialog');
    const confirmYes = document.getElementById('confirm-yes');
    const confirmNo = document.getElementById('confirm-no');
    employeeList.addEventListener('click', event => {
        if (event.target.classList.contains('delete-btn')) {
            const employeeDiv = event.target.closest('.employee');
            const adminId = employeeDiv.querySelector('p:nth-child(2)').textContent.split(":")[1].trim();
            confirmDialog.style.display = 'flex';
            confirmYes.onclick = () => {
                confirmDialog.style.display = 'none';
                deleteUser(adminId, employeeDiv);
            };
            confirmNo.onclick = () => {
                confirmDialog.style.display = 'none';
            };
        }
    });
}

function deleteUser(adminId, employeeDiv) {
    const xhr = new XMLHttpRequest();
    xhr.open('DELETE', `/api/employees/${adminId}`, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                employeeDiv.remove();
                showPopup(true, "Admin removed successfully!");
            } else {
                showPopup(false, "Failed to remove admin.");
            }
        }
    };
    xhr.send();
}

function showPopup(isSuccess, message) {
    const popup = document.getElementById("popup");
    popup.innerHTML = `
        <div class="popup-content">
            <h3 style="color:${isSuccess ? '#28a745' : '#dc3545'}">${isSuccess ? '✔️' : '❌'}</h3>
            <p>${message}</p>
            <button onclick="hidePopup()" class="popup-content-button ${isSuccess ? 'success' : 'error'}">Close</button>
        </div>
    `;
    popup.style.display = "flex";
}

function hidePopup() {
    const popup = document.getElementById("popup");
    popup.style.display = "none";
}

document.addEventListener('DOMContentLoaded', fetchEmployees);

document.getElementById('registeredUserButton').addEventListener('click', () => {
    window.location.href = '/';
});