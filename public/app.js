// ======================================================
// SafeBee Live Tracker
// Part 1
// Firebase + Leaflet Initialization
// ======================================================

import { initializeApp } from
"https://www.gstatic.com/firebasejs/12.16.0/firebase-app.js";

import {
    getFirestore,
    doc,
    collection,
    query,
    orderBy,
    onSnapshot
} from
"https://www.gstatic.com/firebasejs/12.16.0/firebase-firestore.js";



// ======================================================
// Firebase Configuration
// ======================================================

const firebaseConfig = {

    apiKey: "YOUR_API_KEY",

    authDomain: "resq-204f0.firebaseapp.com",

    projectId: "resq-204f0",

    storageBucket: "resq-204f0.firebasestorage.app",

    messagingSenderId: "997083375256",

    appId: "YOUR_WEB_APP_ID"

};

const app = initializeApp(firebaseConfig);

const db = getFirestore(app);



// ======================================================
// Get Alert ID
// ======================================================

const params = new URLSearchParams(window.location.search);

const alertId = params.get("alertId");



// ======================================================
// HTML Components
// ======================================================

const status = document.getElementById("status");

const latitudeText = document.getElementById("latitude");

const longitudeText = document.getElementById("longitude");

const speedText = document.getElementById("speed");

const headingText = document.getElementById("heading");

const timeText = document.getElementById("time");

const navigateButton =
document.getElementById("navigate");



if (!alertId) {

    status.innerHTML = "❌ Alert ID Missing";

    throw new Error("Alert ID Missing");

}



// ======================================================
// OpenStreetMap
// ======================================================

const map = L.map("map").setView(

    [11.0168,76.9558],

    17

);

L.tileLayer(

"https://tile.openstreetmap.org/{z}/{x}/{y}.png",

{

attribution:
"&copy; OpenStreetMap Contributors"

}

).addTo(map);



// ======================================================
// Polyline
// ======================================================

let travelledPath = [];

const polyline = L.polyline(

travelledPath,

{

color:"blue",

weight:5

}

).addTo(map);



// ======================================================
// Arrow Marker
// ======================================================

const arrowIcon = L.divIcon({

className:"",

html:`
<div id="arrow"
style="
font-size:40px;
color:red;
transform:rotate(0deg);
transition:0.3s;
">
➤
</div>
`,

iconSize:[40,40]

});

const marker = L.marker(

[11.0168,76.9558],

{

icon:arrowIcon

}

).addTo(map);



// ======================================================
// Firestore References
// ======================================================

const sosRef = doc(

db,

"sos_alerts",

alertId

);

// Route History Collection

const routeRef = query(

collection(

db,

"sos_alerts",

alertId,

"route"

),

orderBy("time")

);



// ======================================================
// Heading Conversion
// ======================================================

function headingToText(degree){

if(degree==null)
return "Unknown";

if(degree>=337.5 || degree<22.5)
return "North";

if(degree<67.5)
return "North-East";

if(degree<112.5)
return "East";

if(degree<157.5)
return "South-East";

if(degree<202.5)
return "South";

if(degree<247.5)
return "South-West";

if(degree<292.5)
return "West";

return "North-West";

}// ======================================================
// SafeBee Live Tracker
// Part 2
// Real-Time Tracking
// ======================================================

// Listen for latest SOS document
onSnapshot(

    sosRef,

    (snapshot)=>{

        if(!snapshot.exists()){

            status.innerHTML =
            "❌ Emergency Not Found";

            return;

        }

        const data = snapshot.data();

        const latitude =
        data.latitude ?? 0;

        const longitude =
        data.longitude ?? 0;

        const speed =
        data.speed ?? 0;

        const heading =
        data.heading ?? 0;

        const active =
        data.active ?? false;

        const lastUpdated =
        data.lastUpdated;



        // -----------------------------
        // Update Details
        // -----------------------------

        if(latitudeText)
            latitudeText.innerHTML =
            latitude.toFixed(6);

        if(longitudeText)
            longitudeText.innerHTML =
            longitude.toFixed(6);

        if(speedText)
            speedText.innerHTML =
            (speed*3.6).toFixed(2)
            + " km/h";

        if(headingText)
            headingText.innerHTML =
            headingToText(heading)
            + " ("
            + heading.toFixed(0)
            + "°)";

        if(lastUpdated && timeText){

            timeText.innerHTML =
            lastUpdated
            .toDate()
            .toLocaleTimeString();

        }



        // -----------------------------
        // Move Marker
        // -----------------------------

        const position = [

            latitude,

            longitude

        ];

        marker.setLatLng(position);

        map.flyTo(

            position,

            map.getZoom(),

            {

                animate:true,

                duration:1

            }

        );



        // -----------------------------
        // Rotate Arrow
        // -----------------------------

        const arrow =
        document.getElementById("arrow");

        if(arrow){

            arrow.style.transform =
            `rotate(${heading}deg)`;

        }



        // -----------------------------
        // Status
        // -----------------------------

        if(active){

            status.innerHTML =
            "🟢 Emergency Active - Live Tracking";

        }

        else{

            status.innerHTML =
            "⚪ Emergency Ended";

        }



        // -----------------------------
        // Navigate Button
        // -----------------------------

        if(navigateButton){

            navigateButton.onclick = ()=>{

                window.open(

                `https://www.google.com/maps/dir/?api=1&destination=${latitude},${longitude}`,

                "_blank"

                );

            };

        }

    },

    (error)=>{

        console.error(error);

        status.innerHTML =
        "❌ Firebase Connection Error";

    }

);



// ======================================================
// Listen to Route History
// ======================================================

onSnapshot(

    routeRef,

    (snapshot)=>{

        travelledPath = [];

        snapshot.forEach((doc)=>{

            const data = doc.data();

            travelledPath.push([

                data.latitude,

                data.longitude

            ]);

        });

        polyline.setLatLngs(travelledPath);

    },

    (error)=>{

        console.error(error);

    }

);



// ======================================================
// Tracker Started
// ======================================================

console.log("====================================");

console.log("SafeBee Live Tracker Started");

console.log("Alert ID :",alertId);

console.log("====================================");