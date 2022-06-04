// Check if localStorage is available
if (localStorage.getItem("name") == null) {
  localStorage.setItem("name", "");
}

if (localStorage.getItem("todo") == null) {
  localStorage.setItem("todo", "");
}

if (localStorage.getItem("wallpaper") == null) {
  localStorage.setItem("wallpaper", "images/wallpaper.jpg");
}

// Important Variable
const date = new Date();

// Time
function showTime() {
  const hour = document.querySelector(".hour"),
    minute = document.querySelector(".minute"),
    session = document.querySelector(".session"),
    date = new Date();

  hour.innerHTML = date.getHours() > 12 ? date.getHours() - 12 : date.getHours();
  minute.innerHTML = date.getMinutes() < 10 ? `0${date.getMinutes()}` : date.getMinutes() ;
  session.innerHTML = date.getHours() > 12 ? session.innerHTML = "PM" : session.innerHTML = "AM";

  setTimeout(showTime, 1000);
}
showTime()

// Date
const day = document.querySelector(".day"),
  month = document.querySelector(".month"),
  year = document.querySelector(".year");

day.innerHTML = date.getDate();
month.innerHTML = date.getMonth() + 1;
year.innerHTML = date.getFullYear();

// Wellcome message
const wellcome = document.querySelector(".wellcome"),
  currentTime = date.getHours();

/*
  For Hellping
  1 2 3 4 5 6       7 8 9 10 11    12 13 14 15 16 17     18 19 20 21 22 23 24
  Good Evening      Good Morning     Good Afternoon         Good Evening
*/

if (currentTime >= 7 && currentTime <= 11) {
  wellcome.innerText = "Good Morning";
} else if (currentTime >= 12 && currentTime <= 17) {
  wellcome.innerText = "Good Afternoon";
} else {
  wellcome.innerText = "Good Evening";
}

// name
const inputName = document.querySelector(".inputName");

inputName.addEventListener("input", () => {
  localStorage.setItem("name", inputName.value);
});

inputName.setAttribute("value", localStorage.getItem("name"));

// Start Google Search
let searchInput = document.querySelector(".searchInput");
let searchButton = document.querySelector(".searchButton");

searchInput.addEventListener("keyup", function (event) {
  event.preventDefault();
  if (event.keyCode === 13) {
    searchButton.click();
  }
});

searchButton.onclick = function () {
  let url = `https://www.google.com/search?q=` + searchInput.value;
  window.open(url, "_self");
};


// Quotes
fetch("js/quotes.json")
  .then(response => response.json())
  .then(data => {

    const quote = document.querySelector(".quote"),
      author = document.querySelector(".author");

    for (let i = 1; i <= 31; i++) {
      if(i === date.getDate()) {
        quote.textContent = data[`quote${i}`]["quote"];
        author.textContent = data[`quote${i}`]["author"];
      }
    }

  })

// Todo
const todo = document.querySelector(".todo");
todo.addEventListener("input", () => {
  localStorage.setItem("todo", todo.value);
});
todo.setAttribute("value", localStorage.getItem("todo"));

// Click wallpaper icon
const wallpaperIcon = document.querySelector(".wallpaperIcon"),
  wallpaper = document.querySelector(".wallpaper");
  closeButton = document.querySelector(".close");

wallpaperIcon.addEventListener("click", () => {
  wallpaper.classList.toggle("show");
});

closeButton.addEventListener("click", () => {
  wallpaper.classList.remove("show");
});

// Drag And Drop
document.querySelectorAll(".drop-zone__input").forEach((inputElement) => {
  const dropZoneElement = inputElement.closest(".drop-zone");

  dropZoneElement.addEventListener("click", (e) => {
    inputElement.click();
  });

  inputElement.addEventListener("change", (e) => {
    if (inputElement.files.length) {
      updateThumbnail(dropZoneElement, inputElement.files[0]);
    }
  });

  dropZoneElement.addEventListener("dragover", (e) => {
    e.preventDefault();
    dropZoneElement.classList.add("drop-zone--over");
  });

  ["dragleave", "dragend"].forEach((type) => {
    dropZoneElement.addEventListener(type, (e) => {
      dropZoneElement.classList.remove("drop-zone--over");
    });
  });

  dropZoneElement.addEventListener("drop", (e) => {
    e.preventDefault();

    if (e.dataTransfer.files.length) {
      inputElement.files = e.dataTransfer.files;
      updateThumbnail(dropZoneElement, e.dataTransfer.files[0]);
    }

    dropZoneElement.classList.remove("drop-zone--over");
  });
});

/**
 * Updates the thumbnail on a drop zone element.
 *
 * @param {HTMLElement} dropZoneElement
 * @param {File} file
 */
function updateThumbnail(dropZoneElement, file) {
  let thumbnailElement = dropZoneElement.querySelector(".drop-zone__thumb");

  // First time - remove the prompt
  if (dropZoneElement.querySelector(".drop-zone__prompt")) {
    dropZoneElement.querySelector(".drop-zone__prompt").remove();
  }

  // First time - there is no thumbnail element, so lets create it
  if (!thumbnailElement) {
    thumbnailElement = document.createElement("div");
    thumbnailElement.classList.add("drop-zone__thumb");
    dropZoneElement.appendChild(thumbnailElement);
  }

  thumbnailElement.dataset.label = file.name;

  // Show thumbnail for image files
  if (file.type.startsWith("image/")) {
    const reader = new FileReader();

    reader.readAsDataURL(file);
    reader.onload = () => {
      localStorage.setItem("wallpaper", `${reader.result}`)
      thumbnailElement.style.backgroundImage = `url(${localStorage.getItem("wallpaper")})`;
      document.body.style.backgroundImage = `url(${localStorage.getItem("wallpaper")})`;
      document.location.reload(true);
    };
  } else {
    thumbnailElement.style.backgroundImage = null;
  }
}

document.body.style.backgroundImage = `url(${localStorage.getItem("wallpaper")})`

// For Contact
console.log("Hello if you want to contact with the developer");
console.log("You can here: https://www.facebook.com/kareem1911/");
console.log("And this is my Github profile: https://github.com/kareem-m");