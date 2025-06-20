// Brawsing History
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.action === "getHistory") {
        chrome.history.search({ text: '', maxResults: 1000, startTime: 0 }, function (results) {
            sendResponse({ data: results });
        });
        return true;
    }
});
