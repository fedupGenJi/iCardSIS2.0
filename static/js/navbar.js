function toggleModal() {
    const modal = document.getElementById("adminModal");
    modal.classList.toggle("active");
}

function logout() {
    window.location.href = '/logout';
}

document.addEventListener('DOMContentLoaded', () => {
    const logo = document.querySelector('.navbar-left .logo');

    const redirectToHomepage = () => {
        window.location.href = '/';
    };

    if (logo) {
        logo.addEventListener('click', redirectToHomepage);
    }
});