# ES3H3 — Hand Gesture Recognition & Gesture-Controlled Tic-Tac-Toe (MATLAB)

> Group project for the ES3H3 module at the University of Warwick.
> **My contribution: I designed, trained, and tested the gesture recognition models** (the deep-learning pipeline) that drive the application.

A computer-vision system that recognises hand gestures from a live webcam feed and uses them to play Tic-Tac-Toe. The project explores **two complementary approaches**: a deep-learning classifier (ResNet-18 transfer learning) and a classical image-processing pipeline.

---

## My Work — Deep Learning Pipeline

I was responsible for the full model lifecycle: data collection, training, and live testing.

### Training (`01_deep_learning/training/`)
- **`train_gesture_net.m`** — Main training script. Transfer learning on **ResNet-18**, retraining the final layers for a 6-class gesture set (F1, F2, F3, X, O, Palm). Uses an 80/20 train/validation split, Adam optimiser, grayscale-to-RGB preprocessing, and reports validation accuracy with a confusion chart.
- **`trainModel.m`** — Earlier 3-class Rock-Paper-Scissors variant with image augmentation (rotation, translation).

### Testing (`01_deep_learning/testing/`)
- **`live_gesture_test.m`** — Real-time webcam classification with a **temporal stability filter**: a gesture is only confirmed after appearing consistently across several frames (with stricter thresholds for the "Palm" class) to suppress flickering predictions.
- **`LiveTestRPS.m`** — Live test harness for the RPS model with on-screen prediction and confidence overlay.

### Data Collection (`01_deep_learning/data_collection/`)
- **`capture_images.m`** — Webcam capture tool with a fixed crop box and on-the-fly augmentation (random rotation, scale, translation, reflection) to expand the dataset per capture.

### Trained Models (`01_deep_learning/models/`)
- **`gestureNet.mat`** — Trained 6-gesture ResNet-18 model.
- **`gesture_model_resnet18_14gestures.mat`** — Extended 14-gesture model.

---

## Classical Computer Vision Approach (`02_classical_cv/`)

A non-deep-learning pipeline for comparison, using traditional image processing:

- **`prep.m`** — Preprocessing: grayscale, Gaussian blur, adaptive binarisation, morphological cleanup, largest-blob extraction.
- **`score_iou.m`** — Intersection-over-Union score against reference templates.
- **`classify_gesture.m`** — Template-matching classifier for X / O gestures using IoU, solidity, and shape complexity.
- **`test_segmentation.m`** — Finger-counting via blob analysis and column projection profiles.
- **`setup_dataset_folders.m`**, **`image_generating.m`** — Dataset scaffolding and capture utilities.

---

## Applications (`03_applications/`)

MATLAB App Designer interfaces that bring it all together:

- **`ES3H3Group2.mlapp`** — **Final application.**
- **`tictacto_cv.mlapp`** — Gesture-controlled Tic-Tac-Toe game.
- **`es3h3.mlapp`**, **`testapp.mlapp`** — Earlier development versions.

---

## Technologies

- MATLAB — Deep Learning Toolbox, Image Processing Toolbox, Computer Vision Toolbox
- ResNet-18 (transfer learning)
- MATLAB App Designer
- Webcam Support Package

---

## How to Run

1. Open MATLAB with the required toolboxes installed.
2. **To use the final app:** open `03_applications/ES3H3Group2.mlapp` and click Run.
3. **To test a model live:** ensure a webcam is connected and run `01_deep_learning/testing/live_gesture_test.m` (loads `gestureNet.mat`).
4. **To retrain:** collect data with `capture_images.m`, then run `train_gesture_net.m`.

---

## Module Context

**ES3H3**, University of Warwick, Year 3 (2025–26).

---

## License & Attribution

This is a **group coursework project** co-authored with other University of Warwick students; it is published here for portfolio and reference purposes only. My own contribution is the **deep-learning gesture-recognition pipeline** (`01_deep_learning/` — data collection, model training, and live testing).

Because the project is **jointly owned**, no blanket open-source licence is applied. My individual contributions may be reused with attribution; all other material remains the property of the respective co-authors. Please get in touch before reusing any part of this work.
