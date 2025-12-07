# ECG Emotion Recognition Using DREAMER Dataset

This project implements a complete **MATLAB-based ECG Emotion Recognition System** using the DREAMER physiological dataset.  
The system extracts ECG signals, preprocesses them, detects R-peaks, computes HRV and amplitude-based features, performs FFT analysis, and classifies emotional states using percentile thresholds.  
All generated plots and the final project report are included in this repository.

---

## 🚀 Overview

- ECG preprocessing (normalization + bandpass filtering)  
- R-peak detection using `findpeaks()`  
- RR interval extraction  
- HRV and amplitude-based feature analysis  
- FFT power spectrum analysis  
- Correlation and boxplot visualizations  
- Percentile-based emotion classification  
- Outputs saved as high-quality plots  

---


## 🫀 ECG Processing Pipeline

### 1️⃣ Preprocessing
- DC offset removal  
- Amplitude normalization  
- Bandpass filtering (0.5–50 Hz)

### 2️⃣ R-Peak Detection
- Detected using height + minimum RR distance constraints  
- Used to compute RR intervals and amplitudes  

### 3️⃣ Feature Extraction
- Peak amplitude  
- RR intervals  
- Moving standard deviation (for dominance)  

### 4️⃣ Frequency-Domain Analysis
- FFT power spectrum shows dominant ECG frequencies  
- Useful for stress and arousal estimation  

### 5️⃣ Visualization
Generated charts include:
- Filtered ECG with R-peaks  
- RR interval trend  
- RR histogram  
- FFT power spectrum  
- Correlation matrix  
- Boxplots  
- Stacked emotional sub-feeling distribution  

---

## 😊 Emotion Classification

Emotions are computed using **percentile thresholds**:

### **Valence**
- Happy  
- Sad  
- Neutral  

### **Arousal**
- Excited  
- Calm  
- Neutral  

### **Dominance**
- Confident  
- Passive  
- Neutral  

These categories are derived using:
- Peak amplitude  
- RR interval  
- Moving RR standard deviation  

---

## ▶️ How to Run

### 1️⃣ Download DREAMER dataset  
The dataset **cannot be included** due to licensing.  
Download from the official source:
https://zenodo.org/record/546113


The script will automatically:
- Load ECG  
- Preprocess  
- Detect peaks  
- Extract features  
- Classify emotions  
- Generate and save all plots  

---

## 📘 Full Project Report

report/ECG_Emotion_Recognition.pdf

---

## 🛠 Technologies Used

- **MATLAB:** Signal processing, HRV analysis, FFT  
- **DREAMER Dataset:** Physiological emotion data  
- **GitHub:** Version control & documentation  

---

## 👥 Contributors

- **Bojja Divya**  
- **Bhavatarini .M**
- **Srinithi R.M**


---

## 📜 License

This project is licensed under the **MIT License**.





