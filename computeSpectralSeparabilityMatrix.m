function Xijk = computeSpectralSeparabilityMatrix(excitationLaser, fluoroEmission, fluoroExcitation, fluorophoreIndices, channelMatrix, matrixType)

    % Eventually will contain a Matlab implementation of Spectral
    % Separability Index X_{ijk} and later also the relative brightness
    % variant E_{ijk}
    
    excitationLaser
    fluoroEmission
    fluoroExcitation
    fluorophoreIndices
    channelMatrix
    matrixType
    
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
    Xijk = zeros(noOfLightSources, noOfFluorophores, noOfChannels);
    
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
                excitationLaser.data(isnan(excitationLaser.data(:,i)),i) = 0;
                fluoroExcitation.data(isnan(fluoroExcitation.data(:,j)),j) = 0;
                fluoroEmission.data(isnan(fluoroEmission.data(:,j)),j) = 0;
                channelMatrix.data(isnan(channelMatrix.data(:,k)),k) = 0;
                
                % debug variables
                excitationOfFluorophoreVector(i,j,k,:) = excitationLaser.data(:,i) .* fluoroExcitation.data(:,j);
                
                % not exactly correct at this point (but okay to start with
                % as an estimate)
                excitationOfFluorophoreScalar(i,j,k) = trapz(excitationOfFluorophoreVector(i,j,k,:));
                
                % scale the emission with this estimate scalar
                emissionOfFluorophoreVector(i,j,k,:) = excitationOfFluorophoreScalar(i,j,k) .* fluoroEmission.data(:,j);
                
                % channelResponse
                squuezedEmissionVector = squeeze(emissionOfFluorophoreVector(i,j,k,:)); % remove singleton-dimensions
                channelResponseVector(i,j,k,:) = squuezedEmissionVector .* channelMatrix.data(:,k);
                channelResponseScalar(i,j,k) = trapz(squeeze(channelResponseVector(i,j,k,:)));
                
                % trapezoidal integration
                Xijk(i,j,k) = nmRes * trapz(squuezedEmissionVector .* channelMatrix.data(:,k));
                
                if debugPlot
                    % [i j k]
                    plot_Xijk_debugPerIteration()
                end
            end            
        end        
    end
        
    % squeeze the channel dimension away so we get a 2D matrix, quick fix
    if noOfLightSources == 1
        Xijk2 = squeeze(Xijk);
        Xijk = Xijk2;
    end
   
    % normalize per channel
    for k = 1 : noOfChannels
        maxResponse = max(Xijk(:,k));
        normChannelResponse = Xijk(:,k) / maxResponse;
        Xijk(:,k) = normChannelResponse;
    end
    
    % remove NaNs
    Xijk(isnan(Xijk)) = 0;
    
    
    plotXijkAsImage(Xijk, 100, fluoroEmission, channelMatrix)
    
    
    function plot_Xijk_debugPerIteration()
        % add later stuff
        
    function plotXijkAsImage(Xijk, upscaleFactor, fluoroEmission, channelMatrix)
        
        % now we for example 3x4 matrix which will be so tiny when plotted
        XijkImage = imresize(Xijk, upscaleFactor, 'nearest');
        imshow(XijkImage)
        colormap('jet')
        colorbar
        
        xTickLocs = upscaleFactor * (0.5:1:(size(Xijk,2) - 0.5));
        yTickLocs = upscaleFactor * (0.5:1:(size(Xijk,1) - 0.5));
        axis on
                
        set(gca, 'YTickLabel', fluoroEmission.name, 'YTick', yTickLocs)
        set(gca, 'XTickLabel', channelMatrix.name, 'XTick', xTickLocs)
        
        title('X_i_j_k', 'FontWeight', 'bold', 'FontSize', 11)
    