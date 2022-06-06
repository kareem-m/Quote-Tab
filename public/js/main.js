null==localStorage.getItem("name")&&localStorage.setItem("name",""),null==localStorage.getItem("todo")&&localStorage.setItem("todo",""),null==localStorage.getItem("wallpaper")&&localStorage.setItem("wallpaper","images/wallpaper.jpg");const date=new Date;function showTime(){const e=document.querySelector(".hour"),t=document.querySelector(".minute"),o=document.querySelector(".session"),a=new Date;e.innerHTML=12<a.getHours()?a.getHours()-12:a.getHours(),t.innerHTML=a.getMinutes()<10?"0"+a.getMinutes():a.getMinutes(),o.innerHTML=12<a.getHours()?o.innerHTML="PM":o.innerHTML="AM",setTimeout(showTime,1e3)}showTime();const day=document.querySelector(".day"),month=document.querySelector(".month"),year=document.querySelector(".year"),wellcome=(day.innerHTML=date.getDate(),month.innerHTML=date.getMonth()+1,year.innerHTML=date.getFullYear(),document.querySelector(".wellcome")),currentTime=date.getHours(),inputName=(6<=currentTime&&currentTime<=11?wellcome.innerText="Good Morning":12<=currentTime&&currentTime<=17?wellcome.innerText="Good Afternoon":wellcome.innerText="Good Evening",document.querySelector(".inputName"));inputName.addEventListener("input",()=>{localStorage.setItem("name",inputName.value)}),inputName.setAttribute("value",localStorage.getItem("name"));let searchInput=document.querySelector(".searchInput"),searchButton=document.querySelector(".searchButton");searchInput.addEventListener("keyup",function(e){e.preventDefault(),13===e.keyCode&&searchButton.click()}),searchButton.onclick=function(){var e="https://www.google.com/search?q="+searchInput.value;window.open(e,"_self")},fetch("js/quotes.json").then(e=>e.json()).then(t=>{const o=document.querySelector(".quote"),a=document.querySelector(".author");for(let e=1;e<=31;e++)e===date.getDate()&&(o.textContent=t["quote"+e].quote,a.textContent=t["quote"+e].author)});const todo=document.querySelector(".todo"),todoIcon=(todo.addEventListener("input",()=>{localStorage.setItem("todo",todo.value)}),todo.setAttribute("value",localStorage.getItem("todo")),document.querySelector(".todoIcon")),todoList=document.querySelector(".todoList"),closeButtonOne=document.querySelector(".closeOne"),todoInput=(todoIcon.addEventListener("click",()=>{todoList.classList.toggle("show"),todoInput.focus()}),closeButtonOne.addEventListener("click",()=>{todoList.classList.remove("show")}),document.querySelector(".todoInput")),todoButton=document.querySelector(".todoButton"),todoButtonClear=document.querySelector(".todoButtonClear"),tasksDiv=document.querySelector(".tasks");let tasks=[];function addTasksToArray(){var e={id:Date.now(),title:todoInput.value};tasks.push(e),addTasksToPage(),addTasksToLocalStorage()}function addTasksToPage(){tasksDiv.innerHTML="",tasks.forEach(e=>{e.completed&&t.classList.add("done");const t=document.createElement("div"),o=(t.setAttribute("data-id",e.id),t.innerHTML=e.title,document.createElement("i"));o.className="close",t.appendChild(o),tasksDiv.appendChild(t)})}function addTasksToLocalStorage(){localStorage.setItem("tasks",JSON.stringify(tasks))}function getDataFromLocalStorage(){var e=localStorage.getItem("tasks");e&&(JSON.parse(e),addTasksToPage())}function delTask(t){tasks=tasks.filter(e=>e.id!=t),addTasksToLocalStorage()}localStorage.getItem("tasks")&&(tasks=JSON.parse(localStorage.getItem("tasks"))),getDataFromLocalStorage(),todoInput.addEventListener("keypress",function(e){"Enter"===e.key&&(e.preventDefault(),todoButton.click())}),todoButton.addEventListener("click",()=>{""!==todoInput&&(addTasksToArray(),todoInput.value="")}),tasksDiv.addEventListener("click",e=>{e.target.classList.contains("close")&&(delTask(e.target.parentElement.getAttribute("data-id")),e.target.parentElement.remove())}),todoButtonClear.addEventListener("click",()=>{tasksDiv.innerHTML="There are no tasks",localStorage.removeItem("tasks"),tasks=[]});const wallpaperIcon=document.querySelector(".wallpaperIcon"),wallpaper=document.querySelector(".wallpaper"),closeButtonTwo=document.querySelector(".closeTwo");function updateThumbnail(e,t){let o=e.querySelector(".drop-zone__thumb");if(e.querySelector(".drop-zone__prompt")&&e.querySelector(".drop-zone__prompt").remove(),o||((o=document.createElement("div")).classList.add("drop-zone__thumb"),e.appendChild(o)),o.dataset.label=t.name,t.type.startsWith("image/")){const a=new FileReader;a.readAsDataURL(t),a.onload=()=>{localStorage.setItem("wallpaper",""+a.result),o.style.backgroundImage=`url(${localStorage.getItem("wallpaper")})`,document.body.style.backgroundImage=`url(${localStorage.getItem("wallpaper")})`,document.location.reload(!0)}}else o.style.backgroundImage=null}wallpaperIcon.addEventListener("click",()=>{wallpaper.classList.toggle("show")}),closeButtonTwo.addEventListener("click",()=>{wallpaper.classList.remove("show")}),document.querySelectorAll(".drop-zone__input").forEach(t=>{const o=t.closest(".drop-zone");o.addEventListener("click",e=>{t.click()}),t.addEventListener("change",e=>{t.files.length&&updateThumbnail(o,t.files[0])}),o.addEventListener("dragover",e=>{e.preventDefault(),o.classList.add("drop-zone--over")}),["dragleave","dragend"].forEach(e=>{o.addEventListener(e,e=>{o.classList.remove("drop-zone--over")})}),o.addEventListener("drop",e=>{e.preventDefault(),e.dataTransfer.files.length&&(t.files=e.dataTransfer.files,updateThumbnail(o,e.dataTransfer.files[0])),o.classList.remove("drop-zone--over")})}),document.body.style.backgroundImage=`url(${localStorage.getItem("wallpaper")})`,console.log("Hello if you want to contact with the developer"),console.log("You can here: https://www.facebook.com/kareem1911/"),console.log("And this is my Github profile: https://github.com/kareem-m");