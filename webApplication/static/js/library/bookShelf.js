document.addEventListener("DOMContentLoaded", function () {
    const input = document.getElementById("studentIdd");
    const searchBtn = document.getElementById("searchBtn");
    const tableRows = document.querySelectorAll("#shelf-table tbody tr");

    input.addEventListener("input", function () {
        searchBtn.disabled = input.value.trim() === "";
    });

    searchBtn.addEventListener("click", function () {
        const searchId = input.value.trim();
        let found = false;

        tableRows.forEach(row => {
            const bookId = row.cells[0].textContent.trim();
            if (bookId === searchId) {
                row.style.display = ""; 
                found = true;
            } else {
                row.style.display = "none"; 
            }
        });

        if (!found) {
            showPopupx("Book not found.");
        }
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

function DeleteButton(bookId) {
    let bookIdStr = String(bookId);
    const confirmDialog = document.getElementById("custom-confirm-dialog");
    confirmDialog.style.display = "block";

    const confirmYes = document.getElementById("confirm-yes");
    const confirmNo = document.getElementById("confirm-no");

    function handleConfirmClick() {
        confirmDialog.style.display = "none";
        console.log("Book ID to delete:", bookIdStr);
        const xhrx = new XMLHttpRequest();
        xhrx.open("DELETE", "/library/updateBookshelf/delete", true);
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
                popupMessage.textContent = `Book ID ${bookIdStr} has been successfully deleted.`;
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
                    errorMessage = response.error || response.databaseError || response.message || errorMessage;
                } catch (e) {
                    console.error("Error parsing response:", e);
                }

                popupMessage.textContent = `Failed to delete bookId ${bookIdStr}. ${errorMessage}`;
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

        xhrx.send(JSON.stringify({ book_id : bookIdStr }));
    }

    function handleCancelClick() {
        confirmDialog.style.display = "none";
    }

    confirmYes.onclick = handleConfirmClick;
    confirmNo.onclick = handleCancelClick;
}