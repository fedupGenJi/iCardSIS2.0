const FADE_DURATION = 800;
const RESET_DELAY = 5000;
const MOUSE_INACTIVITY_DELAY = 20000;

let fadeTimeout;
let isMouseHovering = false;
let mouseInactivityTimeout;

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
    if (isMouseHovering) return;
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
        if (!isMouseHovering) resetScreen();
    }, RESET_DELAY + FADE_DURATION);
}

function handleMouseActivity() {
    isMouseHovering = true;
    clearTimeout(mouseInactivityTimeout);

    mouseInactivityTimeout = setTimeout(() => {
        isMouseHovering = false;
        resetScreen();
    }, MOUSE_INACTIVITY_DELAY);
}

document.addEventListener('DOMContentLoaded', function () {
    document.body.addEventListener('click', handleScreenFade);
    document.body.addEventListener('mousemove', handleMouseActivity);
});

document.addEventListener('DOMContentLoaded', () => {
    const optionBox = document.querySelector('.box:nth-child(1)'); 

    if (optionBox) {
        optionBox.addEventListener('click', () => {
            window.location.href = '/library/bookshelf';
        });
    }
});

document.addEventListener('DOMContentLoaded', () => {
    const optionBox = document.querySelector('.box:nth-child(2)'); 

    if (optionBox) {
        optionBox.addEventListener('click', () => {
            window.location.href = '/library/lendReturn';
        });
    }
});

document.addEventListener('DOMContentLoaded', () => {
    const optionBox = document.querySelector('.box:nth-child(3)'); 

    if (optionBox) {
        optionBox.addEventListener('click', () => {
            window.location.href = '/library/updateBookshelf';
        });
    }
});

document.addEventListener('DOMContentLoaded', () => {
    const optionBox = document.querySelector('.box:nth-child(4)'); 

    if (optionBox) {
        optionBox.addEventListener('click', () => {
            window.location.href = '/library/errorReport';
        });
    }
});