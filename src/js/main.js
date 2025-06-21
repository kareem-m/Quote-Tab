// Update Popup
const currentVersion = "2.3.3";

chrome.runtime.sendMessage({ action: "checkUpdate" }, (response) => {
    if (response.success) {
        if (response.version !== currentVersion) {
            const popup = document.getElementById("update-popup");
            popup.style.display = "block";
        }
    } else {
        console.error("Error fetching update info:", response.error);
    }
});


document.getElementById('close-popup').addEventListener('click', () => {
    const popup = document.getElementById('update-popup');
    popup.style.display = 'none';
});



// Check if localStorage is available
if (localStorage.getItem("name") == null) {
    localStorage.setItem("name", "");
}

if (localStorage.getItem("todo") == null) {
    localStorage.setItem("todo", "");
}


// Important Variable
const date = new Date();

// Time
function showTime() {
    const hour = document.querySelector(".hour"),
        minute = document.querySelector(".minute"),
        session = document.querySelector(".session"),
        date = new Date();

    let hours = date.getHours();
    if (hours > 12) {
        hours -= 12;
    } else if (hours === 0) {
        hours = 12;
    }
    hour.innerHTML = hours;

    minute.innerHTML = date.getMinutes() < 10 ? `0${date.getMinutes()}` : date.getMinutes();
    session.innerHTML = date.getHours() >= 12 ? "PM" : "AM";

    setTimeout(showTime, 1000);
}
showTime();


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


// Brawsing History
chrome.runtime.sendMessage({ action: "getHistory" }, function (response) {
    if (!response || !response.data) return;

    const counts = {};

    response.data.forEach(page => {
        try {
            const urlObj = new URL(page.url);
            const hostname = urlObj.hostname;

            if (!counts[hostname]) {
                // Extract clean site name from hostname
                const siteName = hostname
                    .replace(/^www\./, '')
                    .split('.')[0]
                    .replace(/^\w/, c => c.toUpperCase());

                counts[hostname] = {
                    count: 0,
                    sampleUrl: `${urlObj.protocol}//${urlObj.hostname}`,
                    sampleTitle: siteName
                };
            }

            counts[hostname].count += 1;
        } catch (e) {
            console.warn("Invalid URL skipped:", page.url);
        }
    });

    const sorted = Object.entries(counts)
        .sort((a, b) => b[1].count - a[1].count)
        .slice(0, 8);

    const list = document.getElementById('shortcut-list');
    list.innerHTML = ''; // Clear old list

    sorted.forEach(([hostname, data]) => {
        const li = document.createElement('li');
        const faviconUrl = `https://www.google.com/s2/favicons?sz=64&domain=${hostname}`;
        li.innerHTML = `
            <a href="${data.sampleUrl}">
                <img src="${faviconUrl}">
                <p>${data.sampleTitle}</p>
            </a>
        `;

        list.appendChild(li);
    });
});




// Quotes
fetch("js/quotes.json")
    .then(res => res.json())
    .then(data => {
        const randomIndex = Math.floor(Math.random() * data.length);
        const selectedQuote = data[randomIndex];

        const quote = document.querySelector(".quote");
        const author = document.querySelector(".author");

        quote.textContent = selectedQuote.quote;
        author.textContent = `— ${selectedQuote.author}`;
    })
    .catch(error => {
        const quote = document.querySelector(".quote");
        const author = document.querySelector(".author");

        quote.textContent = "No Wi-Fi, no wisdom. Reconnect and try again";
        author.textContent = "";
    });


// To do "focus"
const todo = document.querySelector(".todo");
todo.addEventListener("input", () => {
    localStorage.setItem("todo", todo.value);
});

todo.setAttribute("value", localStorage.getItem("todo"));



// Click Todo
const todoIcon = document.querySelector(".todoIcon"),
    todoList = document.querySelector(".todoList"),
    closeButtonOne = document.querySelector(".closeOne"),
    blurBackground = document.createElement("div");

blurBackground.classList.add("blur-background");
document.body.appendChild(blurBackground);

todoIcon.addEventListener("click", (event) => {
    todoList.classList.toggle("show");
    blurBackground.classList.toggle("active");
    todoInput.focus();
    event.stopPropagation();
});

closeButtonOne.addEventListener("click", () => {
    todoList.classList.remove("show");
    blurBackground.classList.remove("active");
});

todoList.addEventListener("click", (event) => {
    event.stopPropagation();
});

document.addEventListener("click", (event) => {
    if (!todoList.contains(event.target) && event.target !== todoIcon) {
        todoList.classList.remove("show");
        blurBackground.classList.remove("active");
    }
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
todoInput.addEventListener("keypress", function (event) {
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
        if (task.completed) {
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

// Click settings icon
const settingsIcon = document.querySelector(".settingsIcon"),
    settings = document.querySelector(".settings"),
    closeButtonTwo = document.querySelector(".closeTwo");

settingsIcon.addEventListener("click", (event) => {
    settings.classList.toggle("show");
    blurBackground.classList.toggle("active");
    event.stopPropagation();
});

closeButtonTwo.addEventListener("click", () => {
    settings.classList.remove("show");
    blurBackground.classList.remove("active");
});

settings.addEventListener("click", (event) => {
    event.stopPropagation();
});

document.addEventListener("click", (event) => {
    if (!settings.contains(event.target) && event.target !== settingsIcon) {
        settings.classList.remove("show");
        blurBackground.classList.remove("active");
    }
});

// Show Shortcuts
const checkbox = document.getElementById("toggle-shortcuts");
const targetElement = document.querySelector("#shortcut-list");

// set default value if not set
if (localStorage.getItem("showShortcuts") === null) {
    localStorage.setItem("showShortcuts", "false");
}

// read from localStorage
const savedState = localStorage.getItem("showShortcuts") === "true";

// apply initial state
checkbox.checked = savedState;
targetElement.classList.toggle("active", savedState);

// listen for change
checkbox.addEventListener("change", () => {
    const isChecked = checkbox.checked;
    localStorage.setItem("showShortcuts", isChecked);
    targetElement.classList.toggle("active", isChecked);
});



// Drag And Drop Wallpaper
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


function updateThumbnail(dropZoneElement, file) {
    let thumbnailElement = dropZoneElement.querySelector(".drop-zone__thumb");

    if (dropZoneElement.querySelector(".drop-zone__prompt")) {
        dropZoneElement.querySelector(".drop-zone__prompt").remove();
    }

    if (!thumbnailElement) {
        thumbnailElement = document.createElement("div");
        thumbnailElement.classList.add("drop-zone__thumb");
        dropZoneElement.appendChild(thumbnailElement);
    }

    thumbnailElement.dataset.label = file.name;

    if (file.type.startsWith("image/")) {
        const reader = new FileReader();

        reader.readAsDataURL(file);
        reader.onload = () => {
            chrome.storage.local.set({ wallpaper: reader.result }, () => {
                thumbnailElement.style.backgroundImage = `url(${reader.result})`;
                document.body.style.backgroundImage = `url(${reader.result})`;
                document.location.reload(true);
            });
        };
    } else {
        thumbnailElement.style.backgroundImage = null;
    }
}



chrome.storage.local.get("wallpaper", (result) => {
    if (result.wallpaper) {
        document.body.style.backgroundImage = `url(${result.wallpaper})`;
    }
});

chrome.storage.local.get("wallpaper", (result) => {
    if (result.wallpaper) {
        document.body.style.backgroundImage = `url(${result.wallpaper})`;
    } else {
        const defaultWallpaper = "images/wallpaper.jpg";
        document.body.style.backgroundImage = `url(${defaultWallpaper})`;

        chrome.storage.local.set({ wallpaper: defaultWallpaper });
    }
});



// Console message
console.log('%c Developed by: Eng. Kareem Elramady https://kareem.is-a.dev', 'background: white; color: black; padding: 10px; border: 1px solid black; font-size: 16px; border-radius: 10px;');