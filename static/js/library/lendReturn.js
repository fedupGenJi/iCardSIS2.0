document.addEventListener("DOMContentLoaded", function () {
    const lendBookBtn = document.getElementById("lendBookBtn");
    const lendBookModal = document.getElementById("lendBookModal");
    const closeModalBtn = document.getElementById("closeModalBtn");
    const lendBookForm = document.getElementById("lendBookForm");
    const messageBox = document.getElementById("messageBox");
    const messageText = document.getElementById("messageText");
    const messageButton = document.getElementById("messageButton");

    let hasError = false;

    lendBookBtn.addEventListener("click", function () {
        lendBookModal.style.display = "flex";
    });

    closeModalBtn.addEventListener("click", function () {
        lendBookModal.style.display = "none";
        if (!hasError) lendBookForm.reset();
    });

    window.addEventListener("click", function (event) {
        if (event.target === lendBookModal) {
            lendBookModal.style.display = "none";
            if (!hasError) lendBookForm.reset();
        }
    });

    document.getElementById("studentId").addEventListener("input", function () {
        this.value = this.value.replace(/[^0-9]/g, "").slice(0, 4);
    });

    document.getElementById("bookId").addEventListener("input", function () {
        this.value = this.value.replace(/[^0-9]/g, "");
    });

    document.getElementById("submissionDate").addEventListener("input", function () {
        let value = this.value.replace(/[^0-9]/g, "");
        if (value.length >= 4) value = value.slice(0, 4) + "-" + value.slice(4);
        if (value.length >= 7) value = value.slice(0, 7) + "-" + value.slice(7);
        this.value = value.slice(0, 10);
    });

    function showMessageBox(message, success) {
        messageText.innerHTML = message;
        messageButton.style.background = success ? "green" : "red";
        messageButton.style.color = "white";
        messageButton.dataset.success = success ? "true" : "false";
        messageBox.style.display = "block";
        hasError = !success;
    }

    function closeMessageBox() {
        messageBox.style.display = "none";
        if (!hasError) {
            lendBookModal.style.display = "none";
            lendBookForm.reset();
        }
    }

    messageButton.addEventListener("click", closeMessageBox);

    function isValidDate(dateString) {
        const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
        if (!dateRegex.test(dateString)) return false;
        const date = new Date(dateString);
        if (isNaN(date.getTime())) return false;
        const today = new Date();
        const minAllowedDate = new Date();
        minAllowedDate.setFullYear(today.getFullYear() - 4);
        return date >= minAllowedDate && date <= today;
    }

    lendBookForm.addEventListener("submit", async function (event) {
        event.preventDefault();
        
        const studentIdInput = document.getElementById("studentId").value.trim();
        const bookIdInput = document.getElementById("bookId").value.trim();
        const submissionDateInput = document.getElementById("submissionDate").value.trim();
        let errorMessage = "";
    
        if (!/^\d{4}$/.test(studentIdInput)) errorMessage += "Student ID must be exactly 4 digits.<br>";
        if (!/^\d+$/.test(bookIdInput)) errorMessage += "Book ID must be a valid integer.<br>";
        if (!isValidDate(submissionDateInput)) errorMessage += "Submission date must be in YYYY-MM-DD format and within 4 years from today.<br>";
    
        if (errorMessage) {
            showMessageBox(errorMessage, false);
        } else {
            try {
                const response = await fetch("/library/lendBook", {
                    method: "PUT",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({
                        studentId: studentIdInput,
                        bookId: bookIdInput,
                        submittedDate: submissionDateInput
                    })
                });
    
                const result = await response.json();
                
                if (result.status) {
                    showMessageBox(result.message, true);
                } else {
                    showMessageBox(result.message, false);
                }
            } catch (error) {
                showMessageBox("An error occurred while processing your request.", false);
            }
        }
    });
});

document.addEventListener("DOMContentLoaded", function () {
    const returnBookBtn = document.getElementById("returnBookBtn");
    const returnBookModal = document.getElementById("returnBookModal");
    const closeModalBtn = document.getElementById("closeModalBtn");
    const returnBookForm = document.getElementById("returnBookForm");
    const messageBox = document.getElementById("messageBox");
    const messageText = document.getElementById("messageText");
    const messageButton = document.getElementById("messageButton");

    let hasError = false;

    returnBookBtn.addEventListener("click", function () {
        returnBookModal.style.display = "flex";
    });

    closeModalBtn.addEventListener("click", function () {
        returnBookModal.style.display = "none";
        if (!hasError) returnBookForm.reset();
    });

    window.addEventListener("click", function (event) {
        if (event.target === returnBookModal) {
            returnBookModal.style.display = "none";
            if (!hasError) returnBookForm.reset();
        }
    });

    document.getElementById("studentIdx").addEventListener("input", function () {
        this.value = this.value.replace(/[^0-9]/g, "").slice(0, 4);
    });

    document.getElementById("bookIdx").addEventListener("input", function () {
        this.value = this.value.replace(/[^0-9]/g, "");
    });

    function showMessageBox(message, success) {
        messageText.innerHTML = message;
        messageButton.style.background = success ? "green" : "red";
        messageButton.style.color = "white";
        messageButton.dataset.success = success ? "true" : "false";
        messageBox.style.display = "block";
        hasError = !success;
    }

    function closeMessageBox() {
        messageBox.style.display = "none";
        if (!hasError) {
            returnBookModal.style.display = "none";
            returnBookForm.reset();
        }
    }

    messageButton.addEventListener("click", closeMessageBox);

    returnBookForm.addEventListener("submit", function (event) {
        event.preventDefault();
        const studentIdInput = document.getElementById("studentIdx").value.trim();
        const bookIdInput = document.getElementById("bookIdx").value.trim();
        let errorMessage = "";

        if (!/^\d{4}$/.test(studentIdInput)) errorMessage += "Student ID must be exactly 4 digits.<br>";
        if (!/^\d+$/.test(bookIdInput)) errorMessage += "Book ID must be a valid integer.<br>";

        if (errorMessage) {
            showMessageBox(errorMessage, false);
        } else {
            showMessageBox("Book returned successfully!", true);
        }
    });
});