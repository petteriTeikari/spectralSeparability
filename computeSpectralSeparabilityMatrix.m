function Xijk = computeSpectralSeparabilityMatrix(excitationLaser, fluoroEmission, fluoroExcitation, fluorophoreIndices, channelMatrix, matrixType)

    % Eventually will contain a Matlab implementation of Spectral
    % Separability Index X_{ijk} and later also the relative brightness
    % variant E_{ijk}
    %     
    %     excitationLaser
    %     fluoroEmission
    %     fluoroExcitation
    %     fluorophoreIndices
    %     channelMatrix
    %     matrixType
    
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
    
    % For our 2-PM system we have only one light source, thus we should
    % have a matrix that is j x k (this works also for multiple light
    % sources)
    
    % Preallocate
    Xijk.matrix = zeros(noOfLightSources, noOfFluorophores, noOfChannels);
    
    % debug matrices
    numberOfWavelengthPoints = size(excitationLaser.data,1);
    excitationOfFluorophoreVector = zeros(noOfLightSources, noOfFluorophores, noOfChannels, numberOfWavelengthPoints);
    excitationOfFluorophoreScalar = zeros(noOfLightSources, noOfFluorophores, noOfChannels);
    emissionOfFluorophoreVector = zeros(noOfLightSources, noOfFluorophores, noOfChannels, numberOfWavelengthPoints);
    channelResponseVector = zeros(noOfLightSources, noOfFluorophores, noOfChannels, numberOfWavelengthPoints);
    channelResponseScalar = zeros(noOfLightSources, noOfFluorophores, noOfChannels);
    
    % trapezoid resolution
    nmRes = 1; % we don't really have absolute units 
    
    % debugMatrices
    debugPlot = true;
    
    
    
    for i = 1 : noOfLightSources        
        for j = 1 : noOfFluorophores            
            for k = 1 : noOfChannels
                
                % convert NaNs to zeros
                excitationLaser.data(:,i) = removeNaNs(excitationLaser.data(:,i), 'laser');
                fluoroExcitation.data(:,j) = removeNaNs(fluoroExcitation.data(:,j), 'excitation');
                fluoroEmission.data(:,j) = removeNaNs(fluoroEmission.data(:,j), 'emission');
                channelMatrix.data(:,k) = removeNaNs(channelMatrix.data(:,k), 'channel');
                
                % debug variables
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
                excitationOfFluorophoreVector(i,j,k,:) = excitationLaser.data(:,i) .* fluoroExcitation.data(:,j);
                
                % not exactly correct at this point (but okay to start with
                % as an estimate)
                excitationOfFluorophoreScalar(i,j,k) = trapz(excitationOfFluorophoreVector(i,j,k,:));
                if isnan(excitationOfFluorophoreScalar(i,j,k))
                    warning('BUG | Scaling scalar for of excitation is NaN, will give erroneous estimates')
                end
                
                % scale the emission with this estimate scalar
                emissionOfFluorophoreVector(i,j,k,:) = excitationOfFluorophoreScalar(i,j,k) .* fluoroEmission.data(:,j);
                
                % channelResponse
                squuezedEmissionVector = squeeze(emissionOfFluorophoreVector(i,j,k,:)); % remove singleton-dimensions
                channelResponseVector(i,j,k,:) = squuezedEmissionVector .* channelMatrix.data(:,k);
                channelResponseScalar(i,j,k) = trapz(squeeze(channelResponseVector(i,j,k,:)));
                
                % trapezoidal integration
                Xijk.emission{i,j,k} = squuezedEmissionVector;
                Xijk.channel{i,j,k} = channelMatrix.data(:,k);
                Xijk.response{i,j,k} = Xijk.emission{i,j,k} .* Xijk.channel{i,j,k};
                Xijk.matrix(i,j,k) = nmRes * trapz(Xijk.response{i,j,k});
                
                if debugPlot
                    if j == 1 
                        %{
                        [i j k]
                        figure
                        fluoroExcitation.name{j} 
                        excitationOfFluorophoreScalar(i,j,k)
                        hold on
                        plot(squuezedEmissionVector, 'r')
                        plot(fluoroEmission.data(:,j), 'k')
                        plot(squeeze(excitationOfFluorophoreVector(i,j,k,:)), 'g')
                        hold off
                        % plot(squuezedEmissionVector, 'b')
                        % channelMatrix.data(:,k)
                        title(num2str(k))
                        pause
                        %}
                    end
                    plot_Xijk_debugPerIteration()
                end
            end            
        end        
    end
        
    % TODO: if you start having multiple light sources, the current code
    % does not work for that
    
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
    
    % remove NaNs
    Xijk.matrix(isnan(Xijk.matrix)) = 0;
    
    
    
    function vectorOut = removeNaNs(vectorIn, dataType)
        
        vectorOut = vectorIn;
        vectorOut(isnan(vectorIn)) = 0;
        
        noNansIn = length(find(isnan(vectorIn)));
        noNansOut = length(find(isnan(vectorOut)));
        
    
    function plot_Xijk_debugPerIteration()
        % add later stuff
        
    
    