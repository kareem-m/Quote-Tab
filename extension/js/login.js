const API_URL = "https://quote-tab-test.vercel.app/api/auth/login";

document.getElementById("loginForm").addEventListener("submit", async (e) => {
    e.preventDefault();

    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    const res = await fetch(API_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username, password })
    });

    const data = await res.json();

    if (res.ok) {
        localStorage.setItem("token", data.token);
        document.getElementById("message").innerText = "Login successful!";
        // Redirect to todo page
        window.location.href = "index.html";
    } else {
        document.getElementById("message").innerText = data.message || "Login failed!";
    }
});


// Toggle Password
const password = document.getElementById('password');
const togglePassword = document.getElementById('togglePassword');

togglePassword.addEventListener('click', () => {
    const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
    password.setAttribute('type', type);

    if (type === 'password') {
        togglePassword.classList.remove('icon-remove_red_eye');
        togglePassword.classList.add('icon-visibility_off');
    } else {
        togglePassword.classList.remove('icon-visibility_off');
        togglePassword.classList.add('icon-remove_red_eye');
    }
});
