const FADE_DURATION = 800;
const RESET_DELAY = 5000;

let fadeTimeout;

function fadeScreen() {
    const introContainer = document.getElementById('intro-container');
    const otherElements = document.querySelectorAll('.navbarpostt, .homepage-container');
    const body = document.body;

    introContainer.classList.add('faded');
    body.classList.add('bg-faded');

    setTimeout(() => {
        otherElements.forEach(element => element.classList.remove('hidden'));
    }, FADE_DURATION);
}

function resetScreen() {
    clearTimeout(fadeTimeout);
    const introContainer = document.getElementById('intro-container');
    const otherElements = document.querySelectorAll('.navbarpostt, .homepage-container');
    const body = document.body;

    introContainer.classList.remove('faded');
    body.classList.remove('bg-faded');
    otherElements.forEach(element => element.classList.add('hidden'));
}

function handleScreenFade() {
    fadeScreen();
    fadeTimeout = setTimeout(() => {
        resetScreen();
    }, RESET_DELAY + FADE_DURATION);
}

document.addEventListener('DOMContentLoaded', function() {
    document.body.addEventListener('click', handleScreenFade);
});

function toggleModal() {
    const modal = document.getElementById("adminModal");
    modal.classList.toggle("active");
}