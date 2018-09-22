
plot(normalAcceleration)
printspikes = detectPeaks(normalAcceleration)


function numberOfSpikes = detectPeaks(data)
    thresholdpos = 2.0;
    thresholdneg = 0.9;
    atPeak = 0;
    atValley = 0;
    thunder = 0;
    for index = 1:length(data)
        lastone = data(:,index);
        if data(:,index) > thresholdpos
            atPeak = 1;
        end
        if data(:,index) < thresholdneg
            atValley = 1;
        end
        if(atValley == 1 && data(:,index) > 1.0)
            thunder = thunder + 1;
            atValley = 0;
        end
        if(atPeak == 1 && data(:,index) < 1.0)
            thunder = thunder + 1;
            atPeak = 0;
        end
    end
    numberOfSpikes = thunder;
end