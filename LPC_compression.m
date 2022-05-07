function LPC_compression(signal_in,fs)
% LPC compression(signal_in,fs) implements LPC compression
%as described in Audio signal processing class
    N = size(signal_in);
    frame_size = 0.05;
    frame_length = frame_size*fs;
    
    %determine if frame is voiced or unvoiced
    voicing = voicingdetector(signal_in, fs, frame_length);
    
    
    %find ak's and G
    filter_order = 15;
    i = 1;
    for frame=1:frame_length:(N(1)-frame_length)
        y = signal_in(frame:frame+frame_length);
        t_p(i) = pitchdetector(y, fs);
        [A,E] = lpc(y,filter_order);
        gain(i) = E;
        a((filter_order*(i-1)+i):(filter_order*(i-1)+i)+filter_order)= A;
        
        i = i+1;
    end 
    
    %distinguish between voiced and unvoiced
    for frame=1:(length(gain))
        %if the signal is unvoiced use random noise
        if(voicing(frame)==0) 
            wn=randn(1,frame_length);
            h=filter(1,a((filter_order*(frame-1)+frame):(filter_order*(frame-1)+frame)+filter_order),wn*100*gain(frame));
        
        %if the signal is voiced use impulse train
        else 
            for m=1:frame_length
                if(m/t_p(frame)==floor(m/t_p(frame)))
                    impulse_train(m)=1;
                else impulse_train(m)=0;
                end
            end
        h=filter(1,[1 a((filter_order*(frame-1)+frame):(filter_order*(frame-1)+frame)+filter_order)],impulse_train*gain(frame));
        end
        
    
        synth_signal(frame_length*(frame-1)+1:frame_length*frame)=h;
    end
    
    soundsc(signal_in,fs);
    soundsc(synth_signal,fs);

    

