function Xijk = computeSpectralSeparabilityMatrix(wavelength,excitationLaser, fluoroEmission, fluoroExcitation, fluorophoreIndices, ...
                                                    barrierFilterWanted, filters, channelMatrix, matrixType, normalizeOn)

    % Eventually will contain a Matlab implementation of Spectral
    % Separability Index X_{ijk} and later also the relative brightness
    % variant E_{ijk}

    
    % Based on:
    % ---------
    %     Oheim M. 2010. Instrumentation for Live-Cell Imaging and Main Formats - Springer. 
    %     In: Papkovsky, DB, editor. Humana Press. Methods in Molecular Biology 591. 
    %     http://dx.doi.org/10.1007/978-1-60761-404-3_1.
    %     
    %     Oheim M, van ’t Hoff M, Feltz A, Zamaleeva A, Mallet J-M, Collot M. 2014. 
    %     New red-fluorescent calcium indicators for optogenetics, photoactivation and multi-color imaging. 
    %     Biochimica et Biophysica Acta (BBA) - Molecular Cell Research 1843. 
    %     Calcium Signaling in Health and Disease:2284–2306. 
    %     http://dx.doi.org/10.1016/j.bbamcr.2014.03.010. (see Fig. 3)
    %     
    %     M. Oheim, M. van't Hoff, Xijk — a figure of merit and software tool for evaluating
    %     spectral cross-talk in multi-channel fluorescence, 2014. (in preparation).

    if strcmp(matrixType, 'specificity')
        
        % the Xijk (specificity)
        Xijk = [];
        %disp('Empty "placeholder" matrix for Xijk returned')
        
    elseif strcmp(matrixType, 'relative')
        
        % the Eijk (relative brightness
        Xijk = [];
        %disp('Empty "placeholder" matrix for Xijk returned')
        
    else
        
        error(['Typo probably in your matrixType? (', matrixType, ')'])
        
    end
    
    % Quantify excitation of each fluorophore
    noOfLightSources = size(excitationLaser.data,2); % i
    noOfFluorophores = size(fluoroExcitation.data,2); % j
    noOfChannels = size(channelMatrix.data,2); % k
    
    % get barrier dichroic, this separates RXD1&RXD2 from RXD3&RXD4
    filterBarrier = getDataMatrix(filters.barrierDichroic, wavelength, barrierFilterWanted, 'filter', [], normalizeOn);
        % filter the emissions with this barrier filter
        
        % manual fix, as RXD1 and RXD2 get wavelengths below cutoff, and
        % RXD3 and RXD4 above the cutoff
        ch = 1; barrierFilter{ch} = 1- filterBarrier.data;
        ch = 2; barrierFilter{ch} = 1- filterBarrier.data;
        ch = 3; barrierFilter{ch} = filterBarrier.data;
        ch = 4; barrierFilter{ch} = filterBarrier.data;
    
    % For our 2-PM system we have only one light source, thus we should
    % have a matrix that is j x k (this works also for multiple light
    % sources)
    
    % Preallocate
    Xijk.matrix = zeros(noOfLightSources, noOfFluorophores, noOfChannels);
    
    % debug matrices
    numberOfWavelengthPoints = size(excitationLaser.data,1);
    excitationOfFluorophoreVector = zeros(noOfLightSources, noOfFluorophores, noOfChannels, numberOfWavelengthPoints);
    excitationOfFluorophoreScalar = zeros(noOfLightSources, noOfFluorophores, noOfChannels);
    emissionOfFluorophoreVectorRaw = zeros(noOfLightSources, noOfFluorophores, noOfChannels, numberOfWavelengthPoints);
    emissionOfFluorophoreVector = zeros(noOfLightSources, noOfFluorophores, noOfChannels, numberOfWavelengthPoints);
    channelResponseVector = zeros(noOfLightSources, noOfFluorophores, noOfChannels, numberOfWavelengthPoints);
    channelResponseScalar = zeros(noOfLightSources, noOfFluorophores, noOfChannels);
    
    % trapezoid resolution
    nmRes = 1; % we don't really have absolute units 
    
    for i = 1 : noOfLightSources        
        for j = 1 : noOfFluorophores            
            for k = 1 : noOfChannels
                
                % convert NaNs to zeros
                excitationLaser.data(:,i) = removeNaNs(excitationLaser.data(:,i), 'laser');
                fluoroExcitation.data(:,j) = removeNaNs(fluoroExcitation.data(:,j), 'excitation');
                fluoroEmission.data(:,j) = removeNaNs(fluoroEmission.data(:,j), 'emission');
                channelMatrix.data(:,k) = removeNaNs(channelMatrix.data(:,k), 'channel');
                barrierFilter{k} = removeNaNs(barrierFilter{k}, 'barrier');
                
                % Note that now the excitation spectrum needs to be taken
                % from a study/database with 2PM excitation for which the
                % data is more scarce. You could have a situation where you
                % now only 1PM-data for your wanted fluorophone
                if nansum(fluoroExcitation.data(:,j)) == 0
                    warning(['fluorophore ', fluoroExcitation.name{j}, ' does not have any excitation data'])
                    disp('Assuming now that it has the excitation spectrum of its neighbor')
                    disp('For more-or-less idea of the emission then')
                    if noOfChannels > 1
                        if j > 1 % take the previous
                            fluoroExcitation.data(:,j) = fluoroExcitation.data(:,j-1);
                            disp([' .. used the excitation spectrum of ', fluoroExcitation.name{j-1}])
                        else % take the next one
                            fluoroExcitation.data(:,j) = fluoroExcitation.data(:,j+1);
                            disp([' .. used the excitation spectrum of ', fluoroExcitation.name{j+1}])
                        end    
                        fluoroExcitation.data(:,j) = removeNaNs(fluoroExcitation.data(:,j), 'excitation');
                    else
                        disp('only one channel, cannot guess the excitation spectrum')
                    end
                end
                
                % Weigh the tabulated excitation spectrum with the laser
                % that you are using
                excitationOfFluorophoreVector(i,j,k,:) = excitationLaser.data(:,i) .* fluoroExcitation.data(:,j);
                
                % Trapezoidal integration of the estimated excitation as a
                % scalar (in kcps)
                excitationOfFluorophoreScalar(i,j,k) = trapz(excitationOfFluorophoreVector(i,j,k,:));
                if isnan(excitationOfFluorophoreScalar(i,j,k))
                    warning('BUG | Scaling scalar for of excitation is NaN, will give erroneous estimates')
                end
                
                % Scale the emission with this estimate scalar
                % We assume that the shape of the emission does not change
                % really as a function of excitation intensity
                emissionOfFluorophoreVectorRaw(i,j,k,:) = excitationOfFluorophoreScalar(i,j,k) .* fluoroEmission.data(:,j);
                
                    % TODO: we could keep track the reductions in intensity
                    % here or later so that the spectra could be normalized
                    % but still keeping these filtering steps?
                                
                % we have to correct the emission with the used dichroic
                % mirror (DM1 and DM2; separating RXD1/RXD2 and RXD3/RXD4 respectively)
                dichroicMirror = channelMatrix.filtersUsed{k}.dichroicData;
                emissionOfFluorophoreVectorDichroic(i,j,k,:) = squeeze(emissionOfFluorophoreVectorRaw(i,j,k,:)) .* dichroicMirror;                
                
                
                % now filter this emission with the barrier filter (defined
                % above), first "splitter" of the light into 2 arms (1st
                % with RXD1 and RXD2, and the 2nd RXD3 and RXD4)
                emissionVector = squeeze(emissionOfFluorophoreVectorDichroic(i,j,k,:));                
                emissionOfFluorophoreVector(i,j,k,:) = emissionVector .* barrierFilter{k};
                
                % channelResponse                
                squuezedEmissionVector = squeeze(emissionOfFluorophoreVector(i,j,k,:)); % remove singleton-dimensions
                channelResponseVector(i,j,k,:) = squuezedEmissionVector .* channelMatrix.data(:,k);
                channelResponseScalar(i,j,k) = trapz(squeeze(channelResponseVector(i,j,k,:)));
                
                    % NOTE! TODO: Now the dichroic mirror has taken account
                    % twice (above the emission was corrected with, as well as
                    % in "getChannelSpectralSensitivity.m", so think later how
                    % to optimize this!
                    
                    % However, this effect should be rather small in
                    % practice as most of the PMT sensitivity spectrum is
                    % defined by the "last" emission filter (BAxxx-yyyy)
                
                % auxiliary outputs
                Xijk.excitation{i,j,k} = squeeze(excitationOfFluorophoreVector(i,j,k,:));
                Xijk.excitationScalar(i,j,k) = excitationOfFluorophoreScalar(i,j,k);
                Xijk.barrierFilter{i,j,k} = barrierFilter{k};
                Xijk.emission{i,j,k} = removeNaNs(squuezedEmissionVector, 'finalEmission');
                Xijk.channel{i,j,k} = removeNaNs(channelMatrix.data(:,k), 'finalChannel');
                Xijk.response{i,j,k} = Xijk.emission{i,j,k} .* Xijk.channel{i,j,k};
                excitationLaser
                
                % the actual Xijk
                Xijk.matrix(i,j,k) = nmRes * trapz(Xijk.response{i,j,k});
                Xijk.matrixAbs(i,j,k) = Xijk.matrix(i,j,k);
    
                debugPlot = true;
                if debugPlot
                    % plot_Xijk_debugPerIteration(wavelength, Xijk.emission{i,j,k}, Xijk.excitation{i,j,k}, Xijk.channel{i,j,k}, Xijk.response{i,j,k}, i, j, k)
                                        
                    if i == 1 && j == 1 % on every channel show
                        % plot_debug_Xijk_optimization(wavelength, excitationLaser.data(:,i), dichroicMirror, barrierFilter{k}, fluoroEmission.data, channelMatrix.data(:,k), k)
                    end
                end
            end   
        end        
    end    
    
        
    % TODO: if you start having multiple light sources, the current code
    % does not work for that
    % Xijk.matrix
    
    
    % squeeze the channel dimension away so we get a 2D matrix
    if noOfLightSources == 1
        Xijk2.matrix = squeeze(Xijk.matrix);
        Xijk.matrix = Xijk2.matrix;
    end
   
    % normalize per channel
    for k = 1 : noOfChannels
        maxResponse = max(Xijk.matrix(:,k));
        normChannelResponse = Xijk.matrix(:,k) / maxResponse;
        Xijk.matrix(:,k) = normChannelResponse;
    end
    
    % make the sum of each channel 1 (overwrites the previous normalization
    % uncomment this one if you don't want this
    for k = 1 : noOfChannels
        sumOfChannel = sum(Xijk.matrix(:,k));
        normChannelResponse = Xijk.matrix(:,k) / sumOfChannel;
        Xijk.matrix(:,k) = normChannelResponse;
    end
    
        % TODO with the sum, it would be easier to optimize the system, and
        % use the value on the diagonal (with 4x4 matrix) as the value to
        % optimize.
    
    % remove NaNs
    Xijk.matrix(isnan(Xijk.matrix)) = 0;
    
    % TODO (July 15, 2015)
    
        % Now our 2-PM excitation spectra are in normalized units, and the
        % differences in brightness / quantum efficiency (GM) is not taken
        % into account
        % e.g. normalized sensitivity could be 0.1 for fluorophore X at 900
        % nm, and 1.0 for fluorophore Y, but still the signal from X can be
        % a lot brighter and more troublesome when leaking to nearby
        % channel that uses dim fluorophore
        
        % similarly the emission is normalized before dichroic mirror and
        % barrier filter attenuation. This now has allowed us to analyze
        % the spectral shape leakage assuming that the brightness from all
        % the fluorophore is equal (which is not the case). Again the
        % sidelobe of some fluorophore can be a lot brighter than the
        % spectral emission peak of some dimmer fluorophore
        
    
    function vectorOut = removeNaNs(vectorIn, dataType)
        
        vectorOut = vectorIn;
        vectorOut(isnan(vectorIn)) = 0;
        
        noNansIn = length(find(isnan(vectorIn)));
        noNansOut = length(find(isnan(vectorOut)));
        
    
    function plot_Xijk_debugPerIteration(wavelength, emission, excitation, channel, response, i, j, k)
        
        rows = 4;
        cols = 4;
        ind = (k-1)*cols + j;
        subplot(rows,cols,ind)
        
        plot(wavelength, emission, wavelength, excitation, wavelength, channel, wavelength, response)
        title([num2str(i), ', ', num2str(j), ', ', num2str(k)])
        leg = legend('emission', ['excitation, trapz() = ', num2str(trapz(excitation))], 'channel', 'response');
        set(leg,  'FontSize', 7, 'Location', 'Best')
        legend('boxoff')
        drawnow
        
    function plot_debug_Xijk_optimization(wavelength, laser, dichroicMirror, barrierFilter, fluoroEmission, channelMatrix, k)
        
        rows = 2;
        cols = 2;
        
        subplot(rows,cols,k)
        
            plot(wavelength, laser, ...
                 wavelength, barrierFilter, ...
                 wavelength, dichroicMirror, ...
                 wavelength, channelMatrix, 'k')

            leg = legend('laser', 'barrier', 'dichroic', 'channel');
            title(['Channel ', num2str(k)])
            drawnow
        