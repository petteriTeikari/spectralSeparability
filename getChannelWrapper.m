function channelMatrix = getChannelWrapper(channelsWanted, noOfchannelsWanted, emissionFiltWanted, ...
                        dichroicsWanted, barrierFilterWanted, wavelength, filters, PMTs, normalizeOn)

    channelMatrix.data = zeros(length(wavelength), noOfchannelsWanted);
    for ch = 1 : length(channelsWanted)           

        % this function will combine the spectral sensitivities of the filters
        % (emission, dichroic mirrors, barrier filters etc.) with the
        % spectral sensitivity of the PMT
        [channelMatrix.data(:,ch), plotColor, filtersUsed] = ...
            getChannelSpectralSensitivity(channelsWanted{ch}, ch, noOfchannelsWanted, ...
            emissionFiltWanted, dichroicsWanted, barrierFilterWanted, wavelength, filters, PMTs, normalizeOn);  
                
        channelMatrix.name{ch} = channelsWanted{ch};
        channelMatrix.plotColor(ch,:) = plotColor;
        channelMatrix.filtersUsed{ch} = filtersUsed;
    end  
    
    debugPlot = false;
    if debugPlot        
        for ch = 1 : length(channelsWanted)   
            plot(wavelength, channelMatrix.filtersUsed{ch}.dichroicData)
            title(ch)
            hold on
            pause(1)
        end        
    end