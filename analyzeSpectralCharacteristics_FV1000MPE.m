function analyzeSpectralCharacteristics_FV1000MPE()

    %% Import data   
    
        % "Master" wavelength vector. We now have spectral measurement with
        % various wavelengths, we just pad those with NaN values for easier
        % handling
        nmRes = 1; % [nm]
        wavelength = (300 : nmRes : 1100)'; 
                 
        % FLUOROPHORES
        [fluoro, fluoro2PM] = import_fluorophoreData(wavelength);      
            list1PM = getNameList(fluoro)
            list2PM = getNameList(fluoro2PM)
        
        % Olympus FV100MPE filters
        filters = import_filterTransmissionData(wavelength);
        
        % Olympus FV100MPE PMT Spectral Sensitivities
        PMTs = import_SpectralSensitivityPMT(wavelength);

        % Laser lines, light sources, etc.
        peakWavelength = 900; % create synthetically, check whether this is correct!
                              % Replace maybe with actual in vivo
                              % measurements later
        FWHM = 3; % [nm], check whether 10 nm is true for our system, broad for a laser
        lightSources = import_lightSources(wavelength, peakWavelength, FWHM);    
        
        % Tissue Absorption
        tissueAttenuation = import_tissueAttenuation(wavelength);
        
            
    %% PLOT INPUTs
    
        fontSize = 9;
        fontName = 'Helvetica';
        scrsz = get(0,'ScreenSize'); % get screen size for plotting    
        close all

        plotOn = false; % true/false
        
        if plotOn
            
            % fig1 = figure('Color', 'w', 'Name', 'Light Sources');       
                % plotLightSources(lightSources, fig1, scrsz, fontSize, fontName)
                % not implemented at the moment
                
            fig2 = figure('Color', 'w', 'Name', 'Fluorophore Emission Spectra');       
                plotFluorophores(fluoro, fig2, scrsz, fontSize, fontName)

            fig3 = figure('Color', 'w', 'Name', 'Olympus Filter Transmittance');       
                plotFilters(filters, fig3, scrsz, fontSize, fontName)

            fig4 = figure('Color', 'w', 'Name', 'Olympus Filter #2');       
                plotExternalPMTfilterSets(filters, fig4, scrsz, fontSize, fontName)
        end
            
    
    %% Spectral separability analysis           
    
        % this requires three 2D matrices (has to be the same length as the
        % wavelength vector        
        normalizeOn = true; % normalize now everything
        
        % Light source
        lightsWanted = {'Laser'}; % {'1PMequivalent'};
        excitationMatrix = getDataMatrix(lightSources, wavelength, lightsWanted, 'light', [], normalizeOn);
        
        % Fluorophores
        fluorophoresWanted = {'BV421'; 'OGB-1'; 'SR-101'; 'AlexaFluor633'};
        absType = '2PM'; % or '1PM'
        yType = 'emission';
        fluoroEmissionMatrix = getDataMatrix(fluoro2PM, wavelength, fluorophoresWanted, 'fluoro', yType, normalizeOn);
        yType = 'excitation';
        fluoroExcitationMatrix = getDataMatrix(fluoro2PM, wavelength, fluorophoresWanted, 'fluoro', yType, normalizeOn);
                
        % Channels 
        channelsWanted = {'RXD1'; 'RXD2'; 'RXD3'; 'RXD4'};
        channelMatrix.data = zeros(length(wavelength), length(channelsWanted));
        for ch = 1 : length(channelsWanted)           
            % this function will combine the spectral sensitivities of the filters
            % (emission, dichroic mirrors, barrier filters etc.) with the
            % spectral sensitivity of the PMT
            [channelMatrix.data(:,ch), plotColor, filtersUsed] = getChannelSpectralSensitivity(channelsWanted{ch}, ch, length(channelsWanted), wavelength, filters, PMTs, normalizeOn);            
            channelMatrix.name{ch} = channelsWanted{ch};
            channelMatrix.plotColor(ch,:) = plotColor;
            channelMatrix.filtersUsed{ch} = filtersUsed;
        end        
        
        % compute the spectral separability matrix, X_{ijk} 
        % e.g. Fig 3 of Oheim et al. (2014), http://dx.doi.org/10.1016/j.bbamcr.2014.03.010        
        % the give the corresponding channels
        fluorophoreIndices = [2 3 4]; % manual now, maybe add some automagic later
        Xijk = computeSpectralSeparabilityMatrix(excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, fluorophoreIndices, channelMatrix, 'specificity');
              
        % as well as the E_{ijk} for relative brightness values (that takes
        % into account the molecular brightness and absolute fluorescence
        % collected fraction, for some details see Oheim et al. (2014), and
        % wait for the upcoming "M. Oheim, M. van't Hoff, Xijk — a figure of merit 
        % and software tool for evaluating spectral cross-talk in multi-channel fluorescence,"
        Eijk = computeSpectralSeparabilityMatrix(excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, fluorophoreIndices, channelMatrix, 'relative');
        
        
    %% Plot spectral separability analysis
    
        options = [];
        fig5 = figure('Color', 'w', 'Name', 'Spectral Separability Analysis');
        plotSpectralSeparability(fig5, scrsz, wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, channelMatrix, Xijk, Eijk, options)
        
    
    %% Spectral unmixing 
    
        % placeholder now, to be implemented later
        out = computeSpectralMixing(excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, channelMatrix, Xijk, Eijk, options);
        