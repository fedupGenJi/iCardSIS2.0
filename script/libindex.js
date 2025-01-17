const lendReturnCard = document.getElementById('lend-return-books');
        const lendReturnPopup = document.getElementById('lendReturnPopup');
        const lendBookPopup = document.getElementById('lendBookPopup');
        const returnBookPopup = document.getElementById('returnBookPopup');
        const lendButton = document.getElementById('lendButton');
        const returnButton = document.getElementById('returnButton');
        const lendSearchButton = document.getElementById('lendSearchButton');
        const returnSearchButton = document.getElementById('returnSearchButton');
        const updateBookshelfCard = document.getElementById('update-bookshelf');
        const updateBookshelfPopup = document.getElementById('updateBookshelfPopup');
        const firstOptionButton = document.getElementById('firstOptionButton');
        const lastImagePopup = document.getElementById('lastImagePopup');
        const closeImagePopup = document.getElementById('closeImagePopup');
        const secondOptionButton = document.getElementById('secondOptionButton'); // Button to trigger the popup
        const expireBookPopup = document.getElementById('expireBookPopup'); // Expire popup
        const expireSubmitButton = document.getElementById('expireSubmitButton'); // Submit button for expiry
        const errorReportCard = document.getElementById('error-report');
        const errorReportPopup = document.getElementById('errorReportPopup');
        const errorSearchButton = document.getElementById('errorSearchButton');
        const errorReportResultPopup = document.getElementById('errorReportResultPopup');
        const removeBookButton = document.getElementById('removeBookButton');
        const removeFineButton = document.getElementById('removeFineButton');
        const closeErrorPopup = document.getElementById('closeErrorPopup');
        const errorStudentIdSpan = document.getElementById('errorStudentId');

// Open the Error Report Popup when "Error Report" card is clicked
errorReportCard.addEventListener('click', () => {
    errorReportPopup.style.display = 'flex'; // Show the Error Report Popup
});

// Handle Search functionality
errorSearchButton.addEventListener('click', () => {
    const studentId = document.getElementById('studentIdNumber').value;

    if (studentId) {
        // Display the Student ID in the Result Popup
        errorStudentIdSpan.textContent = studentId;

        // Hide the Error Report Popup
        errorReportPopup.style.display = 'none';

        // Show the Error Report Result Popup
        errorReportResultPopup.style.display = 'flex';
    } else {
        alert('Please enter a Student ID!');
    }
});

// Close the Error Report Result Popup
closeErrorPopup.addEventListener('click', () => {
    errorReportResultPopup.style.display = 'none'; // Hide the result popup
});

// Remove Book button action
removeBookButton.addEventListener('click', () => {
    const studentId = document.getElementById('studentIdNumber').value;
    console.log(`Removing Book for Student ID: ${studentId}`);
    // Add your custom logic for removing the book here
    alert('Book has been removed!');
    errorReportResultPopup.style.display = 'none'; // Close the result popup
});

// Remove Fine button action
removeFineButton.addEventListener('click', () => {
    const studentId = document.getElementById('studentIdNumber').value;
    console.log(`Removing Fine for Student ID: ${studentId}`);
    // Add your custom logic for removing the fine here
    alert('Fine has been removed!');
    errorReportResultPopup.style.display = 'none'; // Close the result popup
});

// Close popups when clicking outside
window.addEventListener('click', (event) => {
    if (event.target === errorReportPopup) {
        errorReportPopup.style.display = 'none'; // Close Error Report Popup
    }
    if (event.target === errorReportResultPopup) {
        errorReportResultPopup.style.display = 'none'; // Close Result Popup
    }
});


// Open the Expire Old Book Popup
secondOptionButton.addEventListener('click', () => {
    updateBookshelfPopup.style.display = 'none'; // Hide the Update Bookshelf Popup
    expireBookPopup.style.display = 'flex'; // Show the Expire Old Book Popup
});

// Close the Expire Old Book Popup when clicking outside
window.addEventListener('click', (event) => {
    if (event.target === expireBookPopup) {
        expireBookPopup.style.display = 'none'; // Hide the Expire Book Popup
    }
});

// Handle Expire Old Book Submission (you can add your logic here)
expireSubmitButton.addEventListener('click', () => {
    const bookId = document.getElementById('expireBookId').value;
    const reason = document.getElementById('expireReason').value;

    console.log(`Expiring Book ID: ${bookId}, Reason: ${reason}`); // Log for testing

    // Add your custom logic to expire the book

    // Close the popup after submission
    expireBookPopup.style.display = 'none';
});


// Open the Update Bookshelf Popup
updateBookshelfCard.addEventListener('click', () => {
    updateBookshelfPopup.style.display = 'flex'; // Show the Update Bookshelf Popup
});

// Open the Last Image Popup when the first option is clicked
firstOptionButton.addEventListener('click', () => {
    updateBookshelfPopup.style.display = 'none'; // Hide the Update Bookshelf Popup
    lastImagePopup.style.display = 'flex'; // Show the Last Image Popup
});

// Close the Last Image Popup
closeImagePopup.addEventListener('click', () => {
    lastImagePopup.style.display = 'none'; // Hide the Last Image Popup
});

// Close popups when clicking outside them
window.addEventListener('click', (event) => {
    if (event.target === updateBookshelfPopup) {
        updateBookshelfPopup.style.display = 'none';
    }
    if (event.target === lastImagePopup) {
        lastImagePopup.style.display = 'none';
    }
});

    
        // Show Lend/Return selection popup when "Lend/Return Books" is clicked
        lendReturnCard.addEventListener('click', () => {
            lendReturnPopup.style.display = 'flex'; // Show first popup
        });
    
        // When "Lend" is clicked, show the Lend popup
        lendButton.addEventListener('click', () => {
            lendReturnPopup.style.display = 'none'; // Hide first popup
            lendBookPopup.style.display = 'flex'; // Show lend popup
        });
    
        // When "Return" is clicked, show the Return popup
        returnButton.addEventListener('click', () => {
            lendReturnPopup.style.display = 'none'; // Hide first popup
            returnBookPopup.style.display = 'flex'; // Show return popup
        });
    
        // Close popups when clicking outside
        window.addEventListener('click', (event) => {
            if (event.target === lendReturnPopup) {
                lendReturnPopup.style.display = 'none';
            }
            if (event.target === lendBookPopup) {
                lendBookPopup.style.display = 'none';
            }
            if (event.target === returnBookPopup) {
                returnBookPopup.style.display = 'none';
            }
        });
    
        // Navigation for "View Bookshelf"
        const viewBookshelfCard = document.getElementById('view-bookshelf');
        viewBookshelfCard.addEventListener('click', () => {
            window.location.href = 'bookshelf.html'; 
        });
        