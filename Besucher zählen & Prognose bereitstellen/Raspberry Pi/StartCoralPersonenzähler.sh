#!/bin/bash
sleep 1
cd coral/tflite1/
python3 countApi.py &
source tflite1-env/bin/activate

# Start Personenzaehlung without Coral USB Accelerator 
python3 TFLite_detection_webcam.py --modeldir=Sample_TFLite_model 

# Start Personenzaehlung with Coral USB Accelerator 
#python3 TFLite_detection_webcam.py --modeldir=Sample_TFLite_model --edgetpu

