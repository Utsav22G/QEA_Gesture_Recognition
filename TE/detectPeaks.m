
plot(normalAcceleration)
printspikes = detectPeaks(normalAcceleration)


function numberOfSpikes = detectPeaks(data)
    thresholdpos = max(data) / 3 + -1*min(data) / 10
    thresholdneg = min(data) / 3 + -1*max(data) / 10
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
        if(atValley == 1 && data(:,index) > 0)
            thunder = thunder + 1;
            atValley = 0;
        end
        if(atPeak == 1 && data(:,index) < 0)
            thunder = thunder + 1;
            atPeak = 0;
        end
    end
    numberOfSpikes = thunder;
end