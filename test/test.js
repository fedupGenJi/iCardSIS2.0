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
}

function handleScreenFade() {
    fadeScreen(); 
    fadeTimeout = setTimeout(resetScreen, RESET_DELAY + FADE_DURATION); 
}

document.body.addEventListener('click', handleScreenFade);
