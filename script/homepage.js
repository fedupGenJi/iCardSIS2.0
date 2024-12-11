function GoToMenuPage()
{
    window.location.href="/html/menupage.html";
}


function showAdminDetails() {
    const popup = document.getElementById('admin-popup');
    popup.style.display = 'flex';
}


function hideAdminDetails() {
    const popup = document.getElementById('admin-popup');
    popup.style.display = 'none';
}