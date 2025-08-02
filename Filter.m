clc; clear; close all;
%% 1. Load Audio
[filename, pathname] = uigetfile({'*.wav;*.mp3', 'Audio Files (*.wav, *.mp3)'}, 'Pilih file audio');
if isequal(filename,0)
   disp('Tidak ada file dipilih.');
   return;
end
[audioIn, Fs] = audioread(fullfile(pathname, filename));
% Konversi ke mono jika stereo
if size(audioIn,2) > 1
   audioIn = mean(audioIn,2);
end
L = length(audioIn);
t = (0:L-1)/Fs;
%% 2. Generate Pink Noise
% Fungsi untuk pink noise sederhana (1/f noise)
% Metode: filter white noise dengan filter IIR
whiteNoise = randn(L,1);
% Desain filter pink noise sederhana (contoh: 1 pole filter)
b = [0.049922035 -0.095993537 0.050612699 -0.004408786];
a = [1 -2.494956002 2.017265875 -0.522189400];
pinkNoise = filter(b,a,whiteNoise);
pinkNoise = pinkNoise / max(abs(pinkNoise));  % normalisasi
%% 3. Filter pink noise supaya hanya di rentang 3000-5000 Hz
% FFT pink noise
PN_fft = fft(pinkNoise);
f_axis = (0:L-1)*(Fs/L);
% Bandpass filter di frekuensi 3000-5000 Hz (dengan transisi 200 Hz)
f_low = 3000; f_high = 5000;
transWidth = 200;
H = zeros(L,1);
for i = 1:L
   f = f_axis(i);
   if f >= (f_low - transWidth) && f <= (f_low + transWidth)
       H(i) = 0.5 * (1 + cos(pi * (f - f_low) / transWidth));
   elseif f > (f_low + transWidth) && f < (f_high - transWidth)
       H(i) = 1;
   elseif f >= (f_high - transWidth) && f <= (f_high + transWidth)
       H(i) = 0.5 * (1 + cos(pi * (f - f_high) / transWidth));
   else
       H(i) = 0;
   end
end
PN_fft_filtered = PN_fft .* H;
pinkNoiseBand = real(ifft(PN_fft_filtered));
pinkNoiseBand = pinkNoiseBand / max(abs(pinkNoiseBand)); % normalisasi
%% 4. Tambahkan pink noise bandpassed ke sinyal asli
noiseGain = 0.1;  % atur level noise
audioNoisy = audioIn + noiseGain * pinkNoiseBand;
audioNoisy = audioNoisy / max(abs(audioNoisy));  % normalisasi
%% 5. FFT dan Plot Spektrum Audio Asli
Y_in = fft(audioIn);
P2_in = abs(Y_in / L);
P1_in = P2_in(1:floor(L/2)+1);
P1_in(2:end-1) = 2 * P1_in(2:end-1);
f = Fs*(0:floor(L/2))/L;
figure;
plot(f, P1_in, 'k', 'LineWidth', 1.5);
xlabel('Frekuensi (Hz)');
ylabel('Amplitudo');
title('Spektrum Frekuensi Audio Asli');
xlim([0 6000]); grid on;
%% 6. FFT dan Plot Spektrum Noise + Audio
Y = fft(audioNoisy);
P2 = abs(Y / L);
P1 = P2(1:floor(L/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
figure;
plot(f, P1, 'b', 'LineWidth', 1.5);
xlabel('Frekuensi (Hz)');
ylabel('Amplitudo');
title('Spektrum Frekuensi Audio dengan Pink Noise 3000-5000 Hz');
xlim([0 6000]); grid on;
%% 7. Terapkan Low-Pass Filter 2000 Hz (FFT masking)
f_axis = (0:L-1)*(Fs/L);
H_lp = zeros(L,1);
H_lp(f_axis <= 2000) = 1;
Y_noisy = fft(audioNoisy);
if isrow(Y_noisy)
   Y_noisy = Y_noisy.';
end
Y_filtered = Y_noisy .* H_lp;
audioFiltered = real(ifft(Y_filtered));
audioFiltered = audioFiltered / max(abs(audioFiltered));
%% 8. Plot Spektrum Setelah Filtering
Yfilt = fft(audioFiltered);
Pf2 = abs(Yfilt / L);
Pf1 = Pf2(1:floor(L/2)+1);
Pf1(2:end-1) = 2*Pf1(2:end-1);
figure;
plot(f, Pf1, 'r', 'LineWidth', 1.5);
xlabel('Frekuensi (Hz)');
ylabel('Amplitudo');
title('Spektrum Frekuensi Setelah Low-Pass Filter 2000 Hz');
xlim([0 6000]); grid on;
%% 9. Plot Perbandingan Spektrum Sebelum dan Sesudah Filtering
figure;
plot(f, P1, 'b', 'LineWidth', 1.5); hold on;       % Sebelum filter (audioNoisy)
plot(f, Pf1, 'r', 'LineWidth', 1.5);               % Setelah filter (audioFiltered)
xlabel('Frekuensi (Hz)');
ylabel('Amplitudo');
title('Perbandingan Spektrum Frekuensi Sebelum dan Sesudah Filtering');
legend('Sebelum Filtering', 'Setelah Filtering');
xlim([0 6000]);
grid on;
%% 10. Simpan Audio
audiowrite('audio_pinkNoise_bandpassed.wav', audioNoisy, Fs);
audiowrite('audio_lowpass_filtered.wav', audioFiltered, Fs);
disp('File audio dengan pink noise dan hasil low-pass filter telah disimpan.');
