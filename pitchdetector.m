function pitch_period = pitchdetector(signal_in, fs)

    autocor=xcorr(signal_in);
    [PKS,LOCS]=findpeaks(autocor);
    pitch_period = mean(fs./diff(LOCS));
    
    