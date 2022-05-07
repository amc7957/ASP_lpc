function voicing = voicingdetector(signal_in, fs, frame_length)
    N = size(signal_in);
    i = 1;
    for frame=1:frame_length:(N(1)-frame_length)
        y = signal_in(frame:frame+frame_length);
        y_corr = xcorr(y);
        [pk, loc] = findpeaks(y_corr);
        f_p(i)= mean(fs./diff(loc));
        
        if(80<=f_p(i) & 300>=f_p(i))
            voicing(i)=1;    % voiced
        elseif 80>=f_p(i)
            voicing(i)=0;   %unvoiced
        else
            voicing(i)=-1;    %silent
        end
        i = i+1;
    end
    