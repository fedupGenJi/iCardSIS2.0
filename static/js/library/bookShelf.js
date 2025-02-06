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