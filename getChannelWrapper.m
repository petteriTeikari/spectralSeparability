function channelMatrix = getChannelWrapper(channelsWanted, noOfchannelsWanted, dichroicsWanted, barrierFilterWanted, wavelength, filters, PMTs, normalizeOn)

    channelMatrix.data = zeros(length(wavelength), noOfchannelsWanted);
    for ch = 1 : length(channelsWanted)           
        % this function will combine the spectral sensitivities of the filters
        % (emission, dichroic mirrors, barrier filters etc.) with the
        % spectral sensitivity of the PMT
        [channelMatrix.data(:,ch), plotColor, filtersUsed] = ...
            getChannelSpectralSensitivity(channelsWanted{ch}, ch, noOfchannelsWanted, ...
            dichroicsWanted, barrierFilterWanted, wavelength, filters, PMTs, normalizeOn);            
        channelMatrix.name{ch} = channelsWanted{ch};
        channelMatrix.plotColor(ch,:) = plotColor;
        channelMatrix.filtersUsed{ch} = filtersUsed;
    end  