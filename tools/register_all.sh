#!/bin/bash

python service_mongo.py add questionanswering QA localhost 8082 text\&text_image
python service_mongo.py add imagematching IMM localhost 8083 image\&text_image
python service_mongo.py add calendar CA localhost 8084 text
python service_mongo.py add imageclassification IMC localhost 8085 image\&text_image
python service_mongo.py add facerecognition FACE localhost 8086 image\&text_image
python service_mongo.py add digitrecognition DIG localhost 8087 image\&text_image
python service_mongo.py add weather WE localhost 8088 text
python service_mongo.py add musicservice MS localhost 8089 text

echo "All service installed successfully!"
