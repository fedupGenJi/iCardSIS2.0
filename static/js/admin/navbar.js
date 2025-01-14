function toggleModal() {
    const modal = document.getElementById("adminModal");
    modal.classList.toggle("active");
}

function logout() {
    window.location.href = '/logout';
}