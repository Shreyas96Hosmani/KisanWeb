importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyCmZL0C_o9RRTgyDaZO0DY78yr9fGuAdTQ",
    authDomain: "kisanchat-hinjawadi-dev.firebaseapp.com",
    databaseURL: "https://kisanchat-hinjawadi-dev.firebaseio.com",
    projectId: "kisanchat-hinjawadi-dev",
    storageBucket: "kisanchat-hinjawadi-dev.appspot.com",
    messagingSenderId: "379951119240",
    appId: "1:379951119240:web:f420f059597994a716983d",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});