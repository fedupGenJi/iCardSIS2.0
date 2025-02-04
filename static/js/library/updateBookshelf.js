const popupContainer = document.getElementById("popupContainer");
const addBookBtn = document.getElementById("addBookBtn");
const messageBox = document.getElementById("messageBox");

addBookBtn.addEventListener("click", () => {
    if (messageBox.style.display !== "block") {
        popupContainer.style.display = "flex";
    }
});

function closePopup() {
    if (messageBox.style.display !== "block") {
        popupContainer.style.display = "none"; 
    }
}

function submitBook() {
    const bookId = document.getElementById("bookId").value;
    const bookName = document.getElementById("bookName").value;
    const bookCount = document.getElementById("bookCount").value;
    const messageText = document.getElementById("messageText");
    const messageButton = document.getElementById("messageButton");

    if (bookId && bookName && bookCount) {
        messageText.innerHTML = `<strong>Book Added:</strong><br>ID: ${bookId}<br>Name: ${bookName}<br>Count: ${bookCount}`;
        messageButton.style.background = "green";
        messageButton.style.color = "white";
        if (messageBox.style.display !== "block") {
            closePopup();
        }
    } else {
        messageText.innerHTML = "Please fill all fields.";
        messageButton.style.background = "red";
        messageButton.style.color = "white";
    }

    messageBox.style.display = "block";
    addBookBtn.disabled = true;
}

function closeMessageBox() {
    messageBox.style.display = "none";
    addBookBtn.disabled = false;
}

window.onclick = function(event) {
    if (event.target === popupContainer && messageBox.style.display !== "block") {
        closePopup();
    }
};