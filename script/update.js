
function GoToEditPage() {
    window.location.href="/html/edit.html"
}


function showDeletePopup() {
    const popup = document.getElementById("delete-popup");
    popup.style.display = "flex";
}

function hideDeletePopup() {
    const popup = document.getElementById("delete-popup");
    popup.style.display = "none";
}


function deleteEntry() {
    alert("Entry Deleted Successfully");
    hideDeletePopup();
}

function showAdminDetails() {
    const popup = document.getElementById('admin-popup');
    popup.style.display = 'flex';
}


function hideAdminDetails() {
    const popup = document.getElementById('admin-popup');
    popup.style.display = 'none';
}