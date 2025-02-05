const popupContainer = document.getElementById("popupContainer");
const addBookBtn = document.getElementById("addBookBtn");
const messageBox = document.getElementById("messageBox");
const bookIdInput = document.getElementById("bookId");
const bookNameInput = document.getElementById("bookName");
const bookCountInput = document.getElementById("bookCount");
const messageText = document.getElementById("messageText");
const messageButton = document.getElementById("messageButton");
const popupContainerx = document.getElementById("popupContainerxx");
const removeBookbtn = document.getElementById("removeBookBtn")
const bookIdInputxx = document.getElementById("bookIdx");
const bookCountInputxx = document.getElementById("bookCountx");

addBookBtn.addEventListener("click", () => {
    if (messageBox.style.display !== "block") {
        popupContainer.style.display = "flex";
    }
});

removeBookbtn.addEventListener("click", () => {
    if (messageBox.style.display !== "block") {
        popupContainerx.style.display = "flex";
    }
});

function closePopup() {
    if (messageBox.style.display !== "block") {
        popupContainer.style.display = "none";
        clearFormFields();
    }
}

function closePopupxx() {
    if (messageBox.style.display !== "block") {
        popupContainerx.style.display = "none";
        clearFormFieldx();
    }
}

function clearFormFields() {
    bookIdInput.value = "";
    bookNameInput.value = "";
    bookCountInput.value = "";
}

function clearFormFieldx() {
    bookIdInputxx.value = "";
    bookCountInputxx.value = "";
}

function submitBook() {
    const bookId = bookIdInput.value.trim();
    const bookName = bookNameInput.value.trim();
    const bookCount = bookCountInput.value.trim();

    if (bookId && bookName && bookCount) {
        const xhr = new XMLHttpRequest();
        xhr.open("POST", "/library/updateBookshelf/add", true);
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                messageBox.style.display = "block";
        
                try {
                    const response = JSON.parse(xhr.responseText);
        
                    if (xhr.status === 200 && response.success) {
                        messageText.innerHTML = ` ${response.message}`;
                        messageButton.style.background = "green";
                        messageButton.style.color = "white";
                        messageButton.dataset.success = "true"; 
                    } else {
                        messageText.innerHTML = response.message || "Error adding book.";
                        messageButton.style.background = "red";
                        messageButton.style.color = "white";
                        messageButton.dataset.success = "false"; 
                    }
                } catch (error) {
                    messageText.innerHTML = "Unexpected server response.";
                    messageButton.style.background = "red";
                    messageButton.style.color = "white";
                    messageButton.dataset.success = "false";
                }
        
                addBookBtn.disabled = true;
            }
        };        

        const data = JSON.stringify({ id: bookId, name: bookName, count: bookCount });
        xhr.send(data);
    } else {
        messageText.innerHTML = "Please fill all fields.";
        messageButton.style.background = "red";
        messageButton.style.color = "white";
        messageButton.dataset.success = "false";
    }

    messageBox.style.display = "block";
    addBookBtn.disabled = true;
}

function closeMessageBox() {
    messageBox.style.display = "none";
    addBookBtn.disabled = false;

    if (messageButton.dataset.success === "true") {
        closePopup();
        closePopupxx();
    }
}

window.onclick = function (event) {
    
    if (event.target === popupContainer && messageBox.style.display !== "block") {
        closePopup();
    }

    if (event.target === popupContainerx && messageBox.style.display !== "block") {
        closePopupxx();
    }
};

bookCountInput.addEventListener("input", function () {
    this.value = this.value.replace(/[^0-9]/g, ''); 
});

bookCountInput.addEventListener("keypress", function (event) {
    if (!/[0-9]/.test(event.key)) {
        event.preventDefault(); 
    }
});

bookIdInput.addEventListener("input", function () {
    this.value = this.value.replace(/[^0-9]/g, ''); 
});

bookIdInput.addEventListener("keypress", function (event) {
    if (!/[0-9]/.test(event.key)) {
        event.preventDefault(); 
    }
});

bookCountInputxx.addEventListener("input", function () {
    this.value = this.value.replace(/[^0-9]/g, ''); 
});

bookCountInputxx.addEventListener("keypress", function (event) {
    if (!/[0-9]/.test(event.key)) {
        event.preventDefault(); 
    }
});

bookIdInputxx.addEventListener("input", function () {
    this.value = this.value.replace(/[^0-9]/g, ''); 
});

bookIdInputxx.addEventListener("keypress", function (event) {
    if (!/[0-9]/.test(event.key)) {
        event.preventDefault(); 
    }
});

function submitBookxx() {
    const bookId = bookIdInputxx.value.trim();
    const bookCount = bookCountInputxx.value.trim();
    if(bookId && bookCount){
        const xhr = new XMLHttpRequest();
        xhr.open("POST", "/library/updateBookshelf/delete", true);
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                messageBox.style.display = "block";
        
                try {
                    const response = JSON.parse(xhr.responseText);
        
                    if (xhr.status === 200 && response.success) {
                        messageText.innerHTML = ` ${response.message}`;
                        messageButton.style.background = "green";
                        messageButton.style.color = "white";
                        messageButton.dataset.success = "true"; 
                    } else {
                        messageText.innerHTML = response.message || "Error adding book.";
                        messageButton.style.background = "red";
                        messageButton.style.color = "white";
                        messageButton.dataset.success = "false"; 
                    }
                } catch (error) {
                    messageText.innerHTML = "Unexpected server response.";
                    messageButton.style.background = "red";
                    messageButton.style.color = "white";
                    messageButton.dataset.success = "false";
                }
        
                addBookBtn.disabled = true;
            }
        };        

        const data = JSON.stringify({ id: bookId, count: bookCount });
        xhr.send(data);
    }else {
        messageText.innerHTML = "Please fill all fields.";
        messageButton.style.background = "red";
        messageButton.style.color = "white";
        messageButton.dataset.success = "false";
    }

    messageBox.style.display = "block";
    removeBookbtn.disabled = true;
}