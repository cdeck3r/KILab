# How to Run TensorFlow Lite Object Detection Models on the Raspberry Pi

## Introduction
This guide provides step-by-step instructions for how to set up TensorFlow Lite on the Raspberry Pi and use it to run object detection models. It works for the Raspberry Pi 3 and Raspberry Pi 4 running either Rasbpian Buster or Rasbpian Stretch.

TensorFlow Lite (TFLite) models run much faster than regular TensorFlow models on the Raspberry Pi. You can see a comparison of framerates obtained using regular TensorFlow and TensorFlow Lite in my [TensorFlow Lite Performance Comparison YouTube video](https://www.youtube.com/watch?v=TiOKvOrYNII).

* [Section 1. Run TensorFlow Lite Object Detection Models on the Raspberry Pi](https://github.com/EdjeElectronics/TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi/blob/master/Raspberry_Pi_Guide.md#part-1---how-to-set-up-and-run-tensorflow-lite-object-detection-models-on-the-raspberry-pi)

This repository also includes scripts for running the TFLite and Edge TPU models on images, videos, or webcam/Picamera feeds.

## Section 1 - How to Set Up and Run TensorFlow Lite Object Detection Models on the Raspberry Pi

Setting up TensorFlow Lite on the Raspberry Pi is much easier than regular TensorFlow! These are the steps needed to set up TensorFlow Lite:

- 1a. Update the Raspberry Pi
- 1b. Download this repository and create virtual environment
- 1c. Install TensorFlow and OpenCV
- 1d. Set up TensorFlow Lite detection model
- 1e. Run TensorFlow Lite model!

### Step 1a. Update the Raspberry Pi
First, the Raspberry Pi needs to be fully updated. Open a terminal and issue:
```
sudo apt-get update
sudo apt-get dist-upgrade
```
Depending on how long it’s been since you’ve updated your Pi, the update could take anywhere between a minute and an hour. 

While we're at it, let's make sure the camera interface is enabled in the Raspberry Pi Configuration menu. Click the Pi icon in the top left corner of the screen, select Preferences -> Raspberry Pi Configuration, and go to the Interfaces tab and verify Camera is set to Enabled. If it isn't, enable it now, and reboot the Raspberry Pi.

```
sudo apt-get install python3-pip
sudo apt-get install python3-venv
```

### Step 1b. Download this repository and create virtual environment

Next, clone this GitHub repository by issuing the following command. The repository contains the scripts we'll use to run TensorFlow Lite, as well as a shell script that will make installing everything easier. Issue:

```
git clone https://github.com/EdjeElectronics/TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi.git
```

This downloads everything into a folder called TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi. That's a little long to work with, so rename the folder to "tflite1" and then cd into it:

```
mv TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi tflite1
cd tflite1
```

We'll work in this /home/pi/tflite1 directory for the rest of the guide. Next up is to create a virtual environment called "tflite1-env".

I'm using a virtual environment for this guide because it prevents any conflicts between versions of package libraries that may already be installed on your Pi. Keeping it installed in its own environment allows us to avoid this problem. For example, if you've already installed TensorFlow v1.8 on the Pi using my [other guide](https://www.youtube.com/watch?v=npZ-8Nj1YwY), you can leave that installation as-is without having to worry about overriding it.

Install virtualenv by issuing:

```
sudo pip3 install virtualenv
```

Then, create the "tflite1-env" virtual environment by issuing:

```
python3 -m venv tflite1-env
```

This will create a folder called tflite1-env inside the tflite1 directory. The tflite1-env folder will hold all the package libraries for this environment. Next, activate the environment by issuing:

```
source tflite1-env/bin/activate
```

**You'll need to issue the `source tflite1-env/bin/activate` command from inside the /home/pi/tflite1 directory to reactivate the environment every time you open a new terminal window. You can tell when the environment is active by checking if (tflite1-env) appears before the path in your command prompt, as shown in the screenshot below.**

At this point, here's what your tflite1 directory should look like if you issue `ls`.

<p align="center">
  <img src="/doc/tflite1_folder.png">
</p>

If your directory looks good, it's time to move on to Step 1c!

### Step 1c. Install TensorFlow Lite dependencies and OpenCV
Next, we'll install TensorFlow, OpenCV, and all the dependencies needed for both packages. OpenCV is not needed to run TensorFlow Lite, but the object detection scripts in this repository use it to grab images and draw detection results on them.

To make things easier, I wrote a shell script that will automatically download and install all the packages and dependencies. Run it by issuing:

```
bash get_pi_requirements.sh
```

This downloads about 400MB worth of installation files, so it will take a while. Go grab a cup of coffee while it's working! If you'd like to see everything that gets installed, simply open get_pi_dependencies.sh to view the list of packages.

**NOTE: If you get an error while running the `bash get_pi_requirements.sh` command, it's likely because your internet connection timed out, or because the downloaded package data was corrupted. If you get an error, try re-running the command a few more times.**

**ANOTHER NOTE: The shell script automatically installs the latest version of TensorFlow. If you'd like to install a specific version, issue `pip3 install tensorflow==X.XX` (where X.XX is replaced with the version you want to install) after running the script. This will override the existing installation with the specified version.**

**NOTE: If you get the following error: 
tensorboard 2.0.2 has requirement setuptools>=41.0.0, but you'll have setuptools 40.8.0 which is incompatible.**
Solution:

```
sudo pip3 install setuptools --upgrade
```

That was easy! On to the next step.

### Step 1d. Set up TensorFlow Lite detection model
Next, we'll set up the detection model that will be used with TensorFlow Lite. This guide shows how to either download a sample TFLite model provided by Google, or how to use a model that you've trained yourself by following [Part 1 of my TensorFlow Lite tutorial series](https://github.com/EdjeElectronics/TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi#part-1---how-to-train-convert-and-run-custom-tensorflow-lite-object-detection-models-on-windows-10).

A detection model has two files associated with it: a detect.tflite file (which is the model itself) and a labelmap.txt file (which provides a labelmap for the model). My preferred way to organize the model files is to create a folder (such as "BirdSquirrelRaccoon_TFLite_model") and keep both the detect.tflite and labelmap.txt in that folder. This is also how Google's downloadable sample TFLite model is organized.

#### Option 1. Using Google's sample TFLite model
Google provides a sample quantized SSDLite-MobileNet-v2 object detection model which is trained off the MSCOCO dataset and converted to run on TensorFlow Lite. It can detect and identify 80 different common objects, such as people, cars, cups, etc.

Download the sample model (which can be found on [the Object Detection page of the official TensorFlow website](https://www.tensorflow.org/lite/models/object_detection/overview)) by issuing:

```
wget https://storage.googleapis.com/download.tensorflow.org/models/tflite/coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip
```

Unzip it to a folder called "Sample_TFLite_model" by issuing (this command automatically creates the folder):

```
unzip coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip -d Sample_TFLite_model
```

Okay, the sample model is all ready to go! 

#### Option 2: Using your own custom-trained model
You can also use a custom object detection model by moving the model folder into the /home/pi/tflite directory. If you followed [Part 1 of my TensorFlow Lite guide](https://github.com/EdjeElectronics/TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi#part-1---how-to-train-convert-and-run-custom-tensorflow-lite-object-detection-models-on-windows-10) to train and convert a TFLite model on your PC, you should have a folder named "TFLite_model" with a detect.tflite and labelmap.txt file. (It will also have a tflite_graph.pb and tflite_graph.pbtxt file, which are not needed by TensorFlow Lite but can be left in the folder.) 

You can simply copy that folder to a USB drive, insert the USB drive in your Raspberry Pi, and move the folder into the /home/pi/tflite1 directory. (Or you can email it to yourself, or put it on Google Drive, or do whatever your preferred method of file transfer is.) Here's an example of what my "BirdSquirrelRaccoon_TFLite_model" folder looks like in my /home/pi/tflite1 directory: 

*(Add picture of BirdSquirrelRaccoon_TFLite_model in my /home/pi/tflite1 directory)*

Now your custom model is ready to go!

### Step 1e. Run the TensorFlow Lite model!
It's time to see the TFLite object detection model in action! First, free up memory and processing power by closing any applications you aren't using. Also, make sure you have your webcam or Picamera plugged in.

Run the real-time webcam detection script by issuing the following command from inside the /home/pi/tflite1 directory. (Before running the command, make sure the tflite1-env environment is active by checking that (tflite1-env) appears in front of the command prompt.) **The TFLite_detection_webcam.py script will work with either a Picamera or a USB webcam.**

```
python3 TFLite_detection_webcam.py --modeldir=Sample_TFLite_model
```

If your model folder has a different name than "Sample_TFLite_model", use that name instead. For example, I would use `--modeldir=BirdSquirrelRaccoon_TFLite_model` to run my custom bird, squirrel, and raccoon detection model.

After a few moments of initializing, a window will appear showing the webcam feed. Detected objects will have bounding boxes and labels displayed on them in real time.

Part 3 of my TensorFlow Lite training guide gives [instructions](https://github.com/EdjeElectronics/TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi#video) for using the TFLite_detection_image.py and TFLite_detection_video.py scripts. Make sure to use `python3` rather than `python` when running the scripts.


## Appendix: Common Errors
This appendix lists common errors that have been encountered by users following this guide, and solutions showing how to resolve them.

**Feel free to create Pull Requests to add your own errors and resolutions! I'd appreciate any help.**

### 1. TypeError: int() argument must be a string, a bytes-like object or a number, not 'NoneType'
The 'NoneType' error means that the program received an empty array from the webcam, which typically means something is wrong with the webcam or the interface to the webcam. Try plugging and re-plugging the webcam in a few times, and/or power cycling the Raspberry Pi, and see if that works. If not, you may need to try using a new webcam.

### 2. ImportError: No module named 'cv2'
This error occurs when you try to run any of the TFLite_detection scripts without activating the 'tflite1-env' first. It happens because Python cannot find the path to the OpenCV library (cv2) to import it. 

Resolve the issue by closing your terminal window, re-opening it, and issuing:

```
cd tflite1
source tflite1-env/bin/activate
```

Then, try re-running the script as described in [Step 1e](https://github.com/EdjeElectronics/TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi/blob/master/Raspberry_Pi_Guide.md#step-1e-run-the-tensorflow-lite-model).

### 3. THESE PACKAGES DO NOT MATCH THE HASHES FROM THE REQUIREMENTS FILE
This error can occur when you run the `bash get_pi_requirements.sh` command in Step 1c. It occurs because the package data got corrupted while downloading. You can resolve the error by re-running the `bash get_pi_requirements.sh` command a few more times until it successfully completes without reporting that error.
