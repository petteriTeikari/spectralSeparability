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
        peakWavelength = 860; % create synthetically, check whether this is correct!
                              % Replace maybe with actual in vivo
                              % measurements later
        FWHM = 3; % [nm], check whether 10 nm is true for our system, broad for a laser
        lightSources = import_lightSources(wavelength, peakWavelength, FWHM);    
        
            % TODO, add the computations inside a for-loop so you could
            % write a simple optimization routine for the laser peak as
            % well trying to minimize the spectral cross-talk when we have
            % the brightness information for 2-PM excitation
        
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
        normalizeOn.light = true;
        normalizeOn.excitation = false;
        normalizeOn.emission = true;
        normalizeOn.filter = true;
        normalizeOn.PMT = true;
        
        % Light source
        lightsWanted = {'Laser'}; % {'1PMequivalent'};
        excitationMatrix = getDataMatrix(lightSources, wavelength, lightsWanted, 'light', [], normalizeOn);
        
        % Fluorophores
        fluorophoresWanted = {'Methoxy-X04'; 'OGB-1'; 'SR-101'; 'AlexaFluor633'};        
        yType = 'emission';
        fluoroEmissionMatrix = getDataMatrix(fluoro2PM, wavelength, fluorophoresWanted, 'fluoro', yType, normalizeOn);
        yType = 'excitation';
        fluoroExcitationMatrix = getDataMatrix(fluoro2PM, wavelength, fluorophoresWanted, 'fluoro', yType, normalizeOn);
                
        % Channels 
        channelsWanted = {'RXD1'; 'RXD2'; 'RXD3'; 'RXD4'};
        emissionFiltWanted = {'BA420-460'; 'BA460-510'; 'BA570-625HQ'; 'synthEM_700_50'};
        dichroicsWanted = {'DM485'; 'synthDM_630'};
        barrierFilterWanted = {'SDM560'}; % this separates RXD1&RXD2 from RXD3&RXD4
        channelMatrix = getChannelWrapper(channelsWanted, length(channelsWanted), emissionFiltWanted, dichroicsWanted, barrierFilterWanted, wavelength, filters, PMTs, normalizeOn);
        
        % compute the spectral separability matrix, X_{ijk} 
        % e.g. Fig 3 of Oheim et al. (2014), http://dx.doi.org/10.1016/j.bbamcr.2014.03.010        
        % the give the corresponding channels
        fluorophoreIndices = []; % manual now, maybe add some automagic later
        Xijk = computeSpectralSeparabilityMatrix(wavelength,excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, fluorophoreIndices, barrierFilterWanted, filters, channelMatrix, 'specificity', normalizeOn);

        
        % as well as the E_{ijk} for relative brightness values (that takes
        % into account the molecular brightness and absolute fluorescence
        % collected fraction, for some details see Oheim et al. (2014), and
        % wait for the upcoming "M. Oheim, M. van't Hoff, Xijk — a figure of merit 
        % and software tool for evaluating spectral cross-talk in multi-channel fluorescence,"
        Eijk = computeSpectralSeparabilityMatrix(wavelength,excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, fluorophoreIndices, barrierFilterWanted, filters, channelMatrix, 'relative', normalizeOn);
        
        
    %% Plot spectral separability analysis
    
        options = [];        
        plot_XijkResults = false;
        saveOn = false;
        
        if plot_XijkResults
            
            fig5 = figure('Color', 'w', 'Name', 'Spectral Separability Basis Vectors');
                set(fig5,  'Position', [0.04*scrsz(3) 0.05*scrsz(4) 0.40*scrsz(3) 0.90*scrsz(4)])
                plotSpectralSeparability(fig5, scrsz, wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, channelMatrix, Xijk, Eijk, options)
                
                
            fig6 = figure('Color', 'w', 'Name', 'Xijk');
                set(fig6,  'Position', [0.65*scrsz(3) 0.725*scrsz(4) 0.35*scrsz(3) 0.35*scrsz(4)])
                upscaleFactor = 100;
                plotXijkAsImage(Xijk, upscaleFactor, fluoroEmissionMatrix, channelMatrix, saveOn)        


            fig7 = figure('Color', 'w', 'Name', 'Xijk (Spectra)');
                set(fig7,  'Position', [0.4*scrsz(3) 0.02*scrsz(4) 0.60*scrsz(3) 0.60*scrsz(4)])
                plotXijkSpectra(fig7, scrsz, wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, channelMatrix, Xijk, Eijk, options)
            
        end
        
    
    %% Optimize the system
    
        optimizeThe2PMSystem = true;
        if optimizeThe2PMSystem 
    
            % Above we have used fixed values, but we could want to find
            % optimal values for:

                % - Laser peak wavelength
                % - 2 Dichroic mirrors separating a) RXD1 and RXD2
                %                                 b) RXD3 and RXD4
                % - Emission filters (easiest to select manually as well after
                %           the optimization of laser and the dichroic mirrors
                % - Barrier filter (separates RXD1+RXD2, and RXD3+RXD4)

            % default values, you can either tweak the default values, or
            % manually overwrite the values that you want to change
            optim_parameters = optimize_initParameters();

            % we want to use the Xijk matrix as the cost function so that the
            % values on diagonal are maximized
            optim = optimize_2PM_system(optim_parameters, ...
                                wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, ...
                                fluorophoreIndices, barrierFilterWanted, filters, channelMatrix, 'specificity', normalizeOn, PMTs);
                            
        end
    
                        
    %% Spectral unmixing 
    
        % We could do just blind source separation for the channels
        % afterwards, and in this script determine the setup parameters
        % that maximally separate the fluorophores from each other so that
        % it is the easiest to do the post-processing
    
        % placeholder now, to be implemented later
        % out = computeSpectralMixing(excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, channelMatrix, Xijk, Eijk, options);
        