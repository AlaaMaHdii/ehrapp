import matplotlib.pyplot as plt
import numpy as np
from scipy import signal
from scipy.signal import butter, filtfilt
import wfdb

"""
ECG lead I, recorded for 20 seconds, digitized at 500 Hz with 12-bit resolution over a nominal ±10 mV range;
"""
Ts = 1 / 500  # Tid
Fs = 1 / Ts  # Samplefrekvensen
N = 1000  # Efter skabelonen

# Y-aksen, dette indeholder blot alle y-værdier.
tid = np.arange(0, N * Ts, Ts)


def get_header_from_hea(file_name):
    if not file_name.endswith(".hea"):
        file_name += ".hea"
    translation = {"female": "kvinde", "male": "mand"}
    with open(file_name) as fp:
        data = fp.readlines()
        ecg_date = data[-1].split(": ")[-1].strip()
        sex = translation[data[-2].split(": ")[-1].strip()]
        age = data[-3].split(": ")[-1].strip()
        return age, sex, ecg_date


person = "01"
optagelse = "6"

path = f"ecg-id-database-1.0.0/Person_{person}/rec_{optagelse}"

age, sex, ecg_date = get_header_from_hea(path)
print("Læser data fra", sex, age, ecg_date)
signals, info = wfdb.rdsamp(path, channels=[0, 1],
                            sampfrom=0, sampto=N)

ecg0 = signals[:, 0]  # Rå EKG data
ecg1 = signals[:, 1]  # Filteret EKG data

# Fjern baselinde-wander med FIR / High pass filter
highpass_filter = signal.firwin(numtaps=300 + 1, fs=500, cutoff=0.667, pass_zero=False)
signal_filtered_with_fir = signal.filtfilt(highpass_filter, 1, ecg0)


plt.title('EKG Filtret mod basislinje-drift')
plt.suptitle(f"Person {person}, {sex}, {age} år, {ecg_date}")
plt.plot(tid, ecg0)
plt.plot(tid, signal_filtered_with_fir)
plt.legend(['Ufiltret', 'Filtret uden basislinje-drift'], shadow=True)
plt.xlabel('Tid (s)')
plt.ylabel('Millivolts')
plt.show()

# Magnitude spectrum
plt.magnitude_spectrum(ecg0, Fs=Fs)
plt.magnitude_spectrum(signal_filtered_with_fir, Fs=Fs)
plt.legend(['Ufiltret', 'Filtret uden basislinje-drift'], shadow=True)
plt.title('EKG Spektrum Magnitude analyse')
plt.suptitle(f"Person {person}, {sex}, {age} år, {ecg_date}")
plt.show()


# Netstøj, fjernes med notch filter


# Fjern baseline wander
f1 = 0.667
Q1 = 0.1334
b, a = signal.iirnotch(f1, Q1, Fs)
signal.freqz(b, a, fs=Fs)
signal_filtered_with_fir_notch = signal.filtfilt(b, a, signal_filtered_with_fir)

# Fjern netstøj
f0 = 50   # Frekvensen som skal fjernes fra data, dette blev bekræftet til at være 50Hz fra magnitude spektrum,
            # hvilket viste en peak på 50Hz
Q = 0.4166  # Kvalitets faktor

b, a = signal.iirnotch(f0, Q, Fs)
signal.freqz(b, a, fs=Fs)
signal_filtered_with_fir_notch = signal.filtfilt(b, a, signal_filtered_with_fir)

plt.title('EKG, med FIR & Notch')
plt.suptitle(f"Person {person}, {sex}, {age} år, {ecg_date}")
plt.plot(ecg0)
plt.plot(signal_filtered_with_fir_notch)
plt.legend(['Ufiltret', 'Filtret uden netstøj'], shadow=True)
plt.xlabel('Tid (s)')
plt.ylabel('Millivolts')
plt.show()

plt.magnitude_spectrum(ecg0, Fs=Fs)
plt.magnitude_spectrum(signal_filtered_with_fir_notch, Fs=Fs)
plt.legend(['Ufiltret', 'Filtret uden basislinje-drift'], shadow=True)
plt.title('EKG Magnitude spektrum, med FIR & Notch')
plt.suptitle(f"Person {person}, {sex}, {age} år, {ecg_date}")
plt.show()


# Fjern EMG med n-point moving average side 6
#signal_filtered_with_fir_notch_ma = signal.filtfilt(signal_filtered_with_fir_notch[:8], [1], signal_filtered_with_fir_notch)
signal_filtered_with_fir_notch_ma = np.convolve(signal_filtered_with_fir_notch, np.ones(8)/8, mode='valid')

plt.title('EKG, med FIR & Notch & Moving Average')
plt.suptitle(f"Person {person}, {sex}, {age} år, {ecg_date}")
plt.plot(ecg0)
plt.plot(signal_filtered_with_fir_notch_ma)
plt.legend(['Ufiltret', 'Filtret'], shadow=True)
plt.xlabel('Tid (s)')
plt.ylabel('Millivolts')
plt.show()


plt.magnitude_spectrum(ecg0, Fs=Fs)
plt.magnitude_spectrum(signal_filtered_with_fir_notch_ma, Fs=Fs)
plt.title('EKG Magnitude spektrum, med FIR & Notch & Moving Average')
plt.suptitle(f"Person {person}, {sex}, {age} år, {ecg_date}")
plt.legend(['Ufiltret', 'Filtret'], shadow=True)
plt.show()