%% ===== DREAMER EEG FULL ANALYSIS (All Plots + Stable Peak Detection) =====
clear; clc;

load('DREAMER.mat');   % contains EEG(14×128×60)

fs = 128;              % sampling rate

%% 1. Select EEG channel & trial
channel = 1;           % 1–14
trial   = 1;           % 1–60

eeg_data = squeeze(EEG(channel, :, trial));
t = (0:length(eeg_data)-1) / fs;

%% 2. Normalize EEG
eeg_data = eeg_data - mean(eeg_data);
eeg_data = eeg_data / max(abs(eeg_data));

%% 3. Bandpass filter (1–40 Hz)
eeg_filt = bandpass(eeg_data, [1 40], fs);

%% 4. Robust EEG Peak Detection
% Convert to Z-score for easier peak finding
zdata = (eeg_filt - mean(eeg_filt)) / std(eeg_filt);

% First attempt: use standard threshold
[~, locs] = findpeaks(zdata, ...
    'MinPeakHeight', 0.3 * max(zdata), ...
    'MinPeakDistance', round(0.03 * fs));  % Min 30 ms

% If too few peaks → fallback method
if length(locs) < 3
    disp("⚠ Using fallback peak detection...");
    [~, locs] = findpeaks(zdata, 'MinPeakDistance', 3);
end

disp("Peaks detected: " + length(locs));

%% 5. Peak-to-peak intervals (RR-like feature)
intervals = diff(locs) / fs;

%% 6. Peak amplitude feature
peak_ampl = zdata(locs(2:end));

% Match lengths
L = min(length(intervals), length(peak_ampl));
intervals = intervals(1:L);
peak_ampl = peak_ampl(1:L);

%% ========== PLOT 1: Filtered EEG + Peaks ==========
figure('Position',[100 100 1000 300]);
plot(t, eeg_filt, 'LineWidth', 1.3); hold on;
scatter(t(locs), eeg_filt(locs), 40, 'k', 'filled');
title(sprintf('Filtered EEG with Peaks (Channel %d, Trial %d)', channel, trial));
xlabel('Time (s)'); ylabel('Amplitude');
grid on; box on;

%% ========== PLOT 2: Peak Interval ==========
figure('Position',[100 100 800 300]);
plot(intervals, '-o', 'LineWidth', 1.4);
title('Peak-to-Peak Interval');
xlabel('Peak #'); ylabel('Interval (s)');
grid on; box on;

%% ========== PLOT 3: Histogram of Intervals ==========
figure('Position',[100 100 800 300]);
histogram(intervals, 12);
title('Interval Distribution');
xlabel('Interval (s)'); ylabel('Count');
grid on; box on;

%% ========== PLOT 4: FFT / Power Spectrum ==========
N = length(eeg_filt);
Y = abs(fft(eeg_filt));
f = (0:N-1) * (fs / N);

figure('Position',[100 100 800 300]);
plot(f(1:N/2), Y(1:N/2), 'LineWidth', 1.3);
title('EEG Power Spectrum');
xlabel('Frequency (Hz)'); ylabel('Magnitude');
grid on; box on;

%% ========== PLOT 5: Correlation Matrix ==========
features = [peak_ampl(:), intervals(:)];
corr_matrix = corr(features);

figure('Position',[100 100 500 450]);
imagesc(corr_matrix); colorbar;
title('Correlation Matrix');
set(gca,'XTick',[1 2],'XTickLabel',{'Peak Amplitude','Interval'});
set(gca,'YTick',[1 2],'YTickLabel',{'Peak Amplitude','Interval'});
grid on;

%% ========== PLOT 6: Boxplot ==========
figure('Position',[100 100 500 450]);
boxplot(features, {'Peak Amplitude','Interval'});
title('Feature Statistics');
grid on;

%% ========== PLOT 7: EEG Feature Classification ==========
valence = strings(L,1);
valence(peak_ampl > prctile(peak_ampl, 66)) = "High";
valence(peak_ampl < prctile(peak_ampl, 33)) = "Low";
valence(valence=="") = "Medium";

arousal = strings(L,1);
arousal(intervals < prctile(intervals, 33)) = "Fast";
arousal(intervals > prctile(intervals, 66)) = "Slow";
arousal(arousal=="") = "Normal";

vcount = [sum(valence=="High"), sum(valence=="Low"), sum(valence=="Medium")];
acount = [sum(arousal=="Fast"), sum(arousal=="Slow"), sum(arousal=="Normal")];
counts = [vcount; acount];

%% ========== PLOT 8: Stacked Bar Plot ==========
figure('Position',[100 100 900 300]);
bar(counts', 'stacked');
legend({'High/Fast','Low/Slow','Medium'},'Location','northwest');
set(gca,'XTickLabel',{'Valence','Arousal'});
title('EEG-Based State Classification');
ylabel('Count');
grid on;
