const androidApp = document.getElementById('android-app');
const androidPopup = document.querySelector('.androidPopup');
const closeBtn = document.querySelector('.androidPopup .close');
const blurBackground = document.createElement("div");

blurBackground.classList.add("blur-background");
document.body.appendChild(blurBackground);

androidApp.addEventListener('click', () => {
    androidPopup.classList.toggle('show');
    blurBackground.classList.toggle("active");
});


closeBtn.addEventListener('click', () => {
    androidPopup.classList.remove('show');
    blurBackground.classList.remove("active");
});

document.addEventListener("click", (event) => {
    if (!androidPopup.contains(event.target) && event.target !== androidApp) {
        androidPopup.classList.remove("show");
        blurBackground.classList.remove("active");
    }
});