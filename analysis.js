/**
 * Copyright 2016 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the “License”);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an “AS IS” BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Called by Whisk.
 * 
 * It expects the following parameters as attributes of "args"
 * - cloudantUrl: "https://username:password@host"
 * - cloudantDbName: "openwhisk-vision"
 * - alchemyKey: "123456"
 * - watsonUsername: "username"
 * - watsonPassword: "password"
 * - imageDocumentId: "image document ID in cloudant"
 */
function main(args) {
  var fs = require('fs')
  var request = require('request')

  if (args.hasOwnProperty("imageDocumentId")) {
    var imageDocumentId = args.imageDocumentId;
    console.log("[", imageDocumentId, "] Processing image.jpg from document");
    var nano = require("nano")(args.cloudantUrl);
    var visionDb = nano.db.use(args.cloudantDbName);

    // use image id to build a unique filename
    var fileName = imageDocumentId + "-image.jpg";

    var async = require('async')
    async.waterfall([
      // get the image document from the db
      function (callback) {
        visionDb.get(imageDocumentId, {
          include_docs: true
        }, function (err, image) {
          callback(err, image);
        });
      },
      // get the image binary
      function (image, callback) {
        visionDb.attachment.get(image._id, "image.jpg").pipe(fs.createWriteStream(fileName))
          .on("finish", function () {
            callback(null, image);
          })
          .on("error", function (err) {
            callback(err);
          });
      },
      // trigger the analysis on the image file
      function (image, callback) {
        processImage(args, fileName, function (err, analysis) {
          if (err) {
            callback(err);
          } else {
            callback(null, analysis);
          }
        });
      }
    ], function (err, analysis) {
      if (err) {
        console.log("[", imageDocumentId, "] KO", err);
        whisk.error(err);
      } else {
        console.log("[", imageDocumentId, "] OK");
        whisk.done(analysis, null);
      }
    });
    return whisk.async();
  } else {
    console.log("Parameter 'imageDocumentId' not found", args);
    whisk.error("Parameter 'imageDocumentId' not found");
    return false;
  }
}

/**
 * Prepares and analyzes the image.
 * processCallback = function(err, analysis);
 */
function processImage(args, fileName, processCallback) {
  prepareImage(fileName, function (prepareErr, prepareFileName) {
    if (prepareErr) {
      processCallback(prepareErr, null);
    } else {
      analyzeImage(args, prepareFileName, function (err, analysis) {
        var fs = require('fs');
        fs.unlink(prepareFileName);
        processCallback(err, analysis);
      });
    }
  });
}

/**
 * Prepares the image, resizing it if it is too big for Watson or Alchemy.
 * prepareCallback = function(err, fileName);
 */
function prepareImage(fileName, prepareCallback) {
  var
    fs = require('fs'),
    async = require('async'),
    gm = require('gm').subClass({
      imageMagick: true
    });

  async.waterfall([
    function (callback) {
      // Retrieve the file size
      fs.stat(fileName, function (err, stats) {
        if (err) {
          callback(err);
        } else {
          callback(null, stats);
        }
      });
    },
    // Check if size is OK
    function (fileStats, callback) {
      if (fileStats.size > 900 * 1024) {
        // Resize the file
        gm(fileName).define("jpeg:extent=900KB").write(fileName + ".jpg",
          function (err) {
            if (err) {
              callback(err);
            } else {
              // Process the modified file
              callback(null, fileName + ".jpg");
            }
          });
      } else {
        callback(null, fileName);
      }
    }
  ], function (err, fileName) {
    prepareCallback(err, fileName);
  });
}

/**
 * Analyzes the image stored at fileName with the callback onAnalysisComplete(err, analysis).
 * analyzeCallback = function(err, analysis);
 */
function analyzeImage(args, fileName, analyzeCallback) {
  var
    request = require('request'),
    async = require('async'),
    fs = require('fs'),
    analysis = {};

  async.parallel([
    function (callback) {
        // Call AlchemyAPI Face Detection passing the image in the request
        fs.createReadStream(fileName).pipe(
          request({
              method: "POST",
              url: "https://access.alchemyapi.com/calls" +
                "/image/ImageGetRankedImageFaceTags" +
                "?apikey=" + args.alchemyKey +
                "&imagePostMode=raw" +
                "&outputMode=json" +
                "&knowledgeGraph=1",
              headers: {
                'Content-Length': fs.statSync(fileName).size
              },
              json: true

            },
            function (err, response, body) {
              if (err) {
                console.log("Face Detection", err)
              } else {
                analysis.face_detection = body
              }
              callback(null)
            }))
    },
    function (callback) {
        // Call AlchemyAPI Image Keywords passing the image in the request
        fs.createReadStream(fileName).pipe(
          request({
              method: "POST",
              url: "https://access.alchemyapi.com/calls" +
                "/image/ImageGetRankedImageKeywords" +
                "?apikey=" + args.alchemyKey +
                "&imagePostMode=raw" +
                "&outputMode=json" +
                "&knowledgeGraph=1",
              headers: {
                'Content-Length': fs.statSync(fileName).size
              },
              json: true

            },
            function (err, response, body) {
              if (err) {
                console.log("Image Keywords", err)
              } else {
                analysis.image_keywords = body
              }
              callback(null)
            }))
    },
    function (callback) {
        // Call Watson Visual Recognition passing the image in the request
        var params = {
          image_file: fs.createReadStream(fileName)
        }

        var watson = require('watson-developer-cloud')
        var visual_recognition = watson.visual_recognition({
          username: args.watsonUsername,
          password: args.watsonPassword,
          version: 'v1'
        })

        visual_recognition.recognize(params, function (err, body) {
          if (err) {
            console.log("Watson", err)
          } else {
            analysis.visual_recognition = body
          }
          callback(null)
        });
    }
  ],
    function (err, result) {
      analyzeCallback(err, analysis);
    }
  )
}
