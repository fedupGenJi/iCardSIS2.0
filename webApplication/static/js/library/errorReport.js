document.addEventListener("DOMContentLoaded", function () {
    fetch("/api/error-reports")
        .then(response => response.json())
        .then(data => displayErrors(data))
        .catch(error => console.error("Error fetching data:", error));

    setupPopup();
});

function displayErrors(errors) {
    const container = document.getElementById("errorContainer");
    container.innerHTML = "";

    errors.forEach(error => {
        const card = document.createElement("div");
        card.classList.add("error-card");

        card.innerHTML = `
            <h3>Book ID: ${error.bookId}</h3>
            <p>Student ID: ${error.studentId}</p>
            <div class="button-container">
                <button class="approve-btn" onclick="handleAction(${error.bookId}, ${error.studentId}, 'approve')">Approve</button>
                <button class="decline-btn" onclick="handleAction(${error.bookId}, ${error.studentId}, 'decline')">Decline</button>
            </div>
        `;

        container.appendChild(card);
    });
}

function handleAction(bookId, studentId, actionType) {
    const apiEndpoint = actionType === "approve" ? "/api/approve" : "/api/decline";
    const successMessage = actionType === "approve" ? "Approved Successfully" : "Declined Successfully";
    const errorMessage = actionType === "approve" ? "Approval Failed" : "Decline Failed";

    fetch(apiEndpoint, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ bookId, studentId })
    })
    .then(response => response.json())
    .then(data => showPopup(successMessage, "#28a745", data.message, "#28a745"))
    .catch(error => showPopup(errorMessage, "#dc3545", "Something went wrong!", "#dc3545"));
}

function showPopup(heading, headingColor, message, buttonColor) {
    const popup = document.getElementById("popup");
    const popupHeading = document.getElementById("popup-heading");
    const popupMessage = document.getElementById("popup-message");
    const closeButton = document.getElementById("close-popup");

    if (!popup || !popupHeading || !popupMessage || !closeButton) {
        console.error("Popup elements not found in the DOM");
        return;
    }

    popupHeading.innerHTML = `<span class="${headingColor === '#28a745' ? 'success-icon' : 'error-icon'}">✔️</span> ${heading}`;
    popupHeading.style.color = headingColor;
    popupMessage.textContent = message;
    closeButton.style.backgroundColor = buttonColor;
    closeButton.style.color = "#fff";

    popup.style.display = "flex";

    closeButton.onclick = () => {
        popup.style.display = "none";
        location.reload();
    };
}

function setupPopup() {
    const popupHtml = `
        <div class="login-popup" id="popup" style="display: none;">
            <div class="popup-content">
                <h2 id="popup-heading"></h2>
                <p id="popup-message"></p>
                <button class="close-btn" id="close-popup">Close</button>
            </div>
        </div>
    `;
    
    if (!document.getElementById("popup")) {
        document.body.insertAdjacentHTML("beforeend", popupHtml);
    }
}