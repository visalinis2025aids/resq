/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See https://firebase.google.com/docs/functions
 */

const { setGlobalOptions } = require("firebase-functions/v2");
const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Limit concurrent containers
setGlobalOptions({
  maxInstances: 10,
});

// Sample HTTP function
exports.helloWorld = onRequest((request, response) => {
  logger.info("Hello from SafeBee!", { structuredData: true });
  response.send("Hello from SafeBee Firebase Functions!");
});