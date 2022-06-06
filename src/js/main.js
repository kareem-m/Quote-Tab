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
  1 2 3 4 5         6 7 8 9 10 11    12 13 14 15 16 17     18 19 20 21 22 23 24
  Good Evening       Good Morning     Good Afternoon          Good Evening
*/

if (currentTime >= 6 && currentTime <= 11) {
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

// To fo focus
const todo = document.querySelector(".todo");
todo.addEventListener("input", () => {
  localStorage.setItem("todo", todo.value);
});
todo.setAttribute("value", localStorage.getItem("todo"));

// Click Todo
const todoIcon = document.querySelector(".todoIcon"),
  todoList = document.querySelector(".todoList"),
  closeButtonOne = document.querySelector(".closeOne");

todoIcon.addEventListener("click", () => {
  todoList.classList.toggle("show");
  todoInput.focus();
});

closeButtonOne.addEventListener("click", () => {
  todoList.classList.remove("show");
});

// Todo List
const todoInput = document.querySelector(".todoInput"),
  todoButton = document.querySelector(".todoButton"),
  todoButtonClear = document.querySelector(".todoButtonClear"),
  tasksDiv = document.querySelector(".tasks");

let tasks = [];

if (localStorage.getItem("tasks")) {
  tasks = JSON.parse(localStorage.getItem("tasks"));
}

getDataFromLocalStorage()

// click on button by enter key
todoInput.addEventListener("keypress", function(event) {
  if (event.key === "Enter") {
    event.preventDefault();
    todoButton.click();
  }
});

todoButton.addEventListener("click", () => {
  if (todoInput !== "") {
    addTasksToArray()
    todoInput.value = "";
  }
});

// Delete Tasks
tasksDiv.addEventListener("click", (e) => {
  if (e.target.classList.contains("close")) {
    // remove from localstorage
    delTask(e.target.parentElement.getAttribute("data-id"));
    // remove from page
    e.target.parentElement.remove();
  }
});

// Clear Tasks
todoButtonClear.addEventListener("click", () => {
  tasksDiv.innerHTML = "There are no tasks";
  localStorage.removeItem("tasks");
  tasks = [];
});

// push task into array of tasks
function addTasksToArray() {
  const task = {
    id: Date.now(),
    title: todoInput.value,
  };
  tasks.push(task);

  addTasksToPage();
  addTasksToLocalStorage();
}

// add tasks into page
function addTasksToPage() {
  tasksDiv.innerHTML = "";
  tasks.forEach((task) => {

    // Chick if task is done
    if(task.completed) {
      div.classList.add("done");
    }

    // make main div
    const div = document.createElement("div");
    div.setAttribute("data-id", task.id);
    div.innerHTML = task.title;
    
    // make delete button
    const delButton = document.createElement("i");
    delButton.className = "close";
    div.appendChild(delButton);

    tasksDiv.appendChild(div);
  });
}

// To add Tasks to localstorage
function addTasksToLocalStorage() {
  localStorage.setItem("tasks", JSON.stringify(tasks));
}

// To Get data from localstorage
function getDataFromLocalStorage() {
  let data = localStorage.getItem("tasks");
  if (data) {
    let tasks = JSON.parse(data);
    addTasksToPage();
  }
}

// delete tasks from localstorage
function delTask(taskId) {
  tasks = tasks.filter((task) => task.id != taskId);
  addTasksToLocalStorage();
}

// Click wallpaper icon
const wallpaperIcon = document.querySelector(".wallpaperIcon"),
  wallpaper = document.querySelector(".wallpaper"),
  closeButtonTwo = document.querySelector(".closeTwo");

wallpaperIcon.addEventListener("click", () => {
  wallpaper.classList.toggle("show");
});

closeButtonTwo.addEventListener("click", () => {
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