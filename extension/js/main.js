// Backend
const token = localStorage.getItem("token");
if (!token) {
    window.location.href = "login.html";
}

// Logout
document.getElementById("logout").addEventListener("click", () => {
    localStorage.removeItem("token");
    window.location.href = "login.html";
});


// Update Popup
const currentVersion = "3.0";

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




// Todo List (with API)
const todoInput = document.querySelector(".todoInput"),
    todoButton = document.querySelector(".todoButton"),
    todoButtonClear = document.querySelector(".todoButtonClear"),
    tasksDiv = document.querySelector(".tasks");

const API_URL = "https://quote-tab-test.vercel.app/api/todos";

// Create empty message element
const emptyMsg = document.createElement("p");
emptyMsg.className = "empty-msg";
emptyMsg.textContent = "There are no tasks";
tasksDiv.appendChild(emptyMsg);

function checkEmptyTasks() {
    if (tasksDiv.querySelectorAll("div[data-id]").length === 0) {
        if (!tasksDiv.contains(emptyMsg)) {
            tasksDiv.appendChild(emptyMsg);
        }
    } else {
        if (tasksDiv.contains(emptyMsg)) {
            emptyMsg.remove();
        }
    }
}

// Get tasks from API
async function getTasksFromAPI() {
    const res = await fetch(API_URL, {
        headers: {
            "Authorization": `Bearer ${token}`
        }
    });
    const tasks = await res.json();
    renderTasks(tasks);
}

// Render tasks on page
function renderTasks(tasks) {
    tasksDiv.innerHTML = "";

    if (!tasks || tasks.length === 0) {
        tasksDiv.appendChild(emptyMsg);
        return;
    }

    tasks.forEach(task => {
        createTaskElement(task._id, task.title, task.completed);
    });

    checkEmptyTasks();
}

// Create task element (used in render + add)
function createTaskElement(id, title, completed = false) {
    const div = document.createElement("div");
    div.setAttribute("data-id", id);
    div.className = "task";
    div.textContent = title;

    if (completed) div.classList.add("completed");

    const iconsDiv = document.createElement("div");
    iconsDiv.className = "icons";

    const toggleBtn = document.createElement("i");
    toggleBtn.className = "icon-checkmark";
    toggleBtn.addEventListener("click", () =>
        toggleTaskCompleted(id, !div.classList.contains("completed"), div, toggleBtn)
    );
    iconsDiv.appendChild(toggleBtn);

    const delButton = document.createElement("i");
    delButton.className = "icon-cross";
    delButton.addEventListener("click", () => delTaskFromAPI(id));
    iconsDiv.appendChild(delButton);

    div.appendChild(iconsDiv);

    if (completed) {
        tasksDiv.appendChild(div);
    } else {
        const firstCompleted = tasksDiv.querySelector(".completed");
        if (firstCompleted) {
            tasksDiv.insertBefore(div, firstCompleted);
        } else {
            tasksDiv.appendChild(div);
        }
    }

    checkEmptyTasks();
    return div;
}


// Toggle completed
async function toggleTaskCompleted(taskId, newStatus, div, toggleBtn) {
    if (newStatus) {
        // Play sound effect
        const audio = new Audio("images/sound.mp3");
        audio.play();

        div.classList.add("completed");
        tasksDiv.appendChild(div);
    } else {
        div.classList.remove("completed");
        const firstCompleted = tasksDiv.querySelector(".completed");
        if (firstCompleted) {
            tasksDiv.insertBefore(div, firstCompleted);
        } else {
            tasksDiv.appendChild(div);
        }
    }

    const res = await fetch(`${API_URL}?id=${taskId}`, {
        method: "PUT",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${token}`
        },
        body: JSON.stringify({ completed: newStatus })
    });

    if (!res.ok) {
        // revert status if failed
        if (newStatus) {
            div.classList.remove("completed");
        } else {
            div.classList.add("completed");
        }
        console.log("Error updating task");
    }
}

// Add task
async function addTaskToAPI(title) {
    if (tasksDiv.contains(emptyMsg)) {
        emptyMsg.remove();
    }

    const customId = Date.now().toString(36) + Math.random().toString(36).substr(2, 5);

    // Optimistic UI update
    const div = createTaskElement(customId, title, false);

    // Send request to backend
    const res = await fetch(API_URL, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${token}`
        },
        body: JSON.stringify({ _id: customId, title })
    });

    if (!res.ok) {
        // remove if request fails
        div.remove();
        checkEmptyTasks();
        console.log("Error while adding task");
    }
}

// Delete single task
async function delTaskFromAPI(taskId) {
    document.querySelector(`[data-id="${taskId}"]`)?.remove();
    checkEmptyTasks();

    const res = await fetch(`${API_URL}?id=${taskId}`, {
        method: "DELETE",
        headers: {
            "Authorization": `Bearer ${token}`
        }
    });

    if (!res.ok) {
        getTasksFromAPI();
    }
}

// Add task with button or Enter
todoButton.addEventListener("click", () => {
    if (todoInput.value.trim() !== "") {
        addTaskToAPI(todoInput.value);
        todoInput.value = "";
    }
});

todoInput.addEventListener("keypress", function (event) {
    if (event.key === "Enter") {
        event.preventDefault();
        todoButton.click();
    }
});

// When page reload
getTasksFromAPI();


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
const checkbox_shortcuts = document.getElementById("toggle-shortcuts");
const shortcut_list = document.querySelector("#shortcut-list");

// set default value if not set
if (localStorage.getItem("showShortcuts") === null) {
    localStorage.setItem("showShortcuts", "false");
}

// read from localStorage
const shortcutsState = localStorage.getItem("showShortcuts") === "true";

// apply initial state
checkbox_shortcuts.checked = shortcutsState;
shortcut_list.classList.toggle("active", shortcutsState);

// listen for change
checkbox_shortcuts.addEventListener("change", () => {
    const isChecked = checkbox_shortcuts.checked;
    localStorage.setItem("showShortcuts", isChecked);
    shortcut_list.classList.toggle("active", isChecked);
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



// Show prayer
const checkbox = document.getElementById("toggle-prayer");
const nextPrayerElement = document.querySelector("#nextPrayer");

// set default value if not set
if (localStorage.getItem("showPrayer") === null) {
    localStorage.setItem("showPrayer", "false");
}

// read from localStorage
const savedPrayerState = localStorage.getItem("showPrayer") === "true";

// apply initial state
checkbox.checked = savedPrayerState;
nextPrayerElement.classList.toggle("active", savedPrayerState);

// listen for change
checkbox.addEventListener("change", () => {
    const isChecked = checkbox.checked;
    localStorage.setItem("showPrayer", isChecked);
    nextPrayerElement.classList.toggle("active", isChecked);
});



// Next Prayer
async function getPrayerTimingsByCity(prayerCity, prayerCountry = "Egypt") {
    const url = `https://api.aladhan.com/v1/timingsByCity?city=${encodeURIComponent(prayerCity)}&country=${encodeURIComponent(prayerCountry)}&method=5`;
    const response = await fetch(url);
    const data = await response.json();
    if (data.code === 200 && data.data && data.data.timings) {
        return data.data.timings;
    } else {
        throw new Error("Failed to fetch prayer timings");
    }
}

function formatTo12Hour(timeStr) {
    let [h, m] = timeStr.split(":").map(x => parseInt(x, 10));
    const suffix = h >= 12 ? "PM" : "AM";
    h = h % 12 || 12;
    return `${h}:${m.toString().padStart(2, "0")} ${suffix}`;
}

function getNextPrayerInfo(prayerTimings) {
    const now = new Date();
    const prayerOrder = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];
    for (const prayerName of prayerOrder) {
        const timeStr = prayerTimings[prayerName];
        const [h, m] = timeStr.split(":").map(x => parseInt(x, 10));
        const prayerDate = new Date(now.getFullYear(), now.getMonth(), now.getDate(), h, m);
        if (prayerDate > now) {
            return { prayerName, prayerTime: formatTo12Hour(timeStr) };
        }
    }
    return { prayerName: "Fajr", prayerTime: formatTo12Hour(prayerTimings["Fajr"]) };
}

async function updateNextPrayer(prayerCity) {
    const nextPrayerDiv = document.getElementById("nextPrayer");
    nextPrayerDiv.textContent = "Loading prayer times...";
    try {
        const prayerTimings = await getPrayerTimingsByCity(prayerCity);
        const nextPrayer = getNextPrayerInfo(prayerTimings);
        nextPrayerDiv.textContent = `${nextPrayer.prayerName} - ${nextPrayer.prayerTime}`;
    } catch (err) {
        nextPrayerDiv.textContent = "Error loading prayer: " + err.message;
    }
}

document.getElementById("city").addEventListener("change", async (e) => {
    const selectedPrayerCity = e.target.value;
    localStorage.setItem("selectedPrayerCity", selectedPrayerCity);
    updateNextPrayer(selectedPrayerCity);
});

window.addEventListener("DOMContentLoaded", () => {
    const savedPrayerCity = localStorage.getItem("selectedPrayerCity") || "Alexandria";
    document.getElementById("city").value = savedPrayerCity;
    updateNextPrayer(savedPrayerCity);
});


// Console message
console.log('%c Developed by: Eng. Kareem Elramady https://kareem.is-a.dev', 'background: white; color: black; padding: 10px; border: 1px solid black; font-size: 16px; border-radius: 10px;');