# 🎧 Voice Noise Filtering using FFT and Band-Pass/Low-Pass Filters (MATLAB)

## 📌 Description
This MATLAB-based project simulates the **addition of pink noise** to a clean audio signal and performs **noise reduction** using **frequency domain filtering techniques**. It is useful for understanding signal processing concepts such as noise generation, FFT-based spectrum analysis, and filtering using frequency masks.

The system works by:
- Adding artificially generated pink noise within a 3000–5000 Hz band
- Visualizing the frequency content of original and noisy signals
- Applying a 2000 Hz low-pass filter using FFT masking
- Comparing the spectrum before and after filtering

---

## 🎯 Objectives
- Simulate real-world noise contamination in audio recordings
- Understand and apply FFT to analyze signal spectra
- Design and apply custom frequency filters in the spectral domain
- Compare and visualize signal behavior before and after filtering

---

## 🧠 Key Concepts
- **Pink Noise (1/f noise)** generation via IIR filtering
- **FFT (Fast Fourier Transform)** and inverse FFT
- **Band-pass and Low-pass filtering** using custom frequency masks
- **Spectral visualization** of audio signals
- **Normalization** and **audio export**

---

## 🛠️ How to Use
1. Run the script in MATLAB.
2. Choose a `.wav` or `.mp3` file when prompted.
3. The program will:
   - Convert stereo to mono (if needed)
   - Generate pink noise and band-limit it to 3000–5000 Hz
   - Add the noise to your signal
   - Visualize the FFT spectra of clean, noisy, and filtered signals
   - Apply a 2000 Hz low-pass filter
   - Save both noisy and filtered audio files

---

## 📁 Output Files
- `audio_pinkNoise_bandpassed.wav`: Noisy audio (with pink noise in 3000–5000 Hz)
- `audio_lowpass_filtered.wav`: Filtered audio (after low-pass filter at 2000 Hz)

---

## 📊 Sample Plots
| Plot | Description |
|------|-------------|
| Frequency Spectrum of Original Audio | Spectrum of the input clean signal |
| Spectrum with Pink Noise | Input signal contaminated with bandpassed pink noise |
| After Filtering | Signal after applying a 2000 Hz low-pass filter |
| Comparison | Overlaid plot showing before/after filtering |

---

## 🖼️ Project Images (Place in repo or insert actual image files)
- `assets/blynk-overview.png`: Overview of audio filtering steps
- `assets/blynk-setup.png`: (Optional if Blynk used or replace accordingly)
- `assets/wire-diagram.png`: If applicable, show audio I/O path
- `assets/foto-produk.png`: Your physical setup (e.g., mic, laptop)

Insert using:
```markdown
![Overview](assets/blynk-overview.png)
