let fadeTimeout;
const FADE_DURATION = 800;
const RESET_DELAY = 5000;

function fadeScreen() {
    document.body.classList.add('faded');
    document.getElementById('center-group').classList.add('faded');

    setTimeout(() => {
        document.body.style.backgroundColor = 'black';
    }, FADE_DURATION);
}

function resetScreen() {
    clearTimeout(fadeTimeout);
    document.body.classList.remove('faded');
    document.getElementById('center-group').classList.remove('faded');
    document.body.style.backgroundColor = '';

    const navbarContainer = document.getElementById("navbar-container");
    if (navbarContainer) {
        navbarContainer.style.display = "none";
    }
}

function handleScreenFade() {
    fadeScreen();
    fadeTimeout = setTimeout(() => {
        resetScreen();
    }, RESET_DELAY + FADE_DURATION);
}

function toggleModal() {
    const modal = document.getElementById("adminModal");
    modal.classList.toggle("active");
}

function showNavbar() {
    const navbarContainer = document.getElementById("navbar-container");
    if (navbarContainer) {
        navbarContainer.style.display = "block";
    }
}

document.body.addEventListener('click', () => {
    const navbarContainer = document.getElementById("navbar-container");

    if (navbarContainer.style.display === "none") {
        showNavbar();
        handleScreenFade();
    } else {
        handleScreenFade();
    }
});

document.addEventListener("DOMContentLoaded", () => {
    const navbarContainer = document.getElementById("navbar-container");
    if (navbarContainer) {
        navbarContainer.style.display = "none";
    }
});
