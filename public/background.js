chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    
    // Get version from API
    if (request.action === "checkUpdate") {
        fetch("https://quote-tab.netlify.app/update-info.json")
            .then(res => res.json())
            .then(data => sendResponse({ success: true, version: data.latest_version }))
            .catch(err => sendResponse({ success: false, error: err.message }));
        return true; // مهم جدًا
    }

    // Brawsing History
    if (request.action === "getHistory") {
        chrome.history.search({ text: '', maxResults: 1000, startTime: 0 }, results => {
            sendResponse({ data: results });
        });
        return true;
    }
});
