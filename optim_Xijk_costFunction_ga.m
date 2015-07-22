%% COST FUNCTION
function [x, diagonal] = optim_Xijk_costFunction_ga(x, options)

    % Parse input x
    % disp(x)
    laserPeak = x(1);
    DM1cut = x(2);
    DM2cut = x(3);
    BFcut = x(4);
    RXD1center = x(5);
    RXD2center = x(6);
    RXD3center = x(7);
    RXD4center = x(8);
    
    % load the quick fix                                         
    load('ga_tempVariables.mat')    
    
    % laser spectrum
    FWHM = 1; % [nm], check whether 10 nm is true for our system, broad for a laser
    lightSources = import_lightSources(wavelength, laserPeak, FWHM);
    lightsWanted = {'Laser'};
    excitationMatrix = getDataMatrix(lightSources, wavelength, lightsWanted, 'light', [], normalizeOn);


    % static definition
    % dichroicsWanted = {'DM485'; 'DM570'}; 
    channelsWanted = {'RXD1'; 'RXD2'; 'RXD3'; 'RXD4'};        

    % overwrite 
    dichroicsWanted{1} = ['synthDM_', num2str(DM1cut)]; % DM1
    dichroicsWanted{2} = ['synthDM_', num2str(DM2cut)]; % DM2

    % emission filters     
    width = 50; % note twice defined (quick'n'dirty)
    emissionFiltWanted = {['synthEM_', num2str(RXD1center), '_', num2str(width)]; ...
                          ['synthEM_', num2str(RXD2center), '_', num2str(width)]; ...
                          ['synthEM_', num2str(RXD3center), '_', num2str(width)]; ...
                          ['synthEM_', num2str(RXD4center), '_', num2str(width)]};



    % barrier filter, this separates RXD1&RXD2 from RXD3&RXD4
    % barrierFilterWanted = {'SDM560'};
    barrierFilterWanted = {['synthBARRIER_', num2str(BFcut)]}; % DM1        


    channelMatrix = getChannelWrapper(channelsWanted, length(channelsWanted), emissionFiltWanted, dichroicsWanted, barrierFilterWanted, wavelength, filters, PMTs, normalizeOn);

    Xijk = computeSpectralSeparabilityMatrix(wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, ...
                fluorophoreIndices, barrierFilterWanted, filters, channelMatrix, matrixType, normalizeOn);

    % trace (diagonal that we want to maximize)
    [XijkDiag, kcps] = optim_getDiagonals(Xijk.matrix, Xijk.excitationScalar);       
    
    % GA Maximizes so we can keep Xijk as the cost to be optimized, in
    % contrast to fmincon which would require computation of sum of squares
    % (difference from diagonal being 1)
        
    diagonal = sum(XijkDiag(2:3) .^ 2);
    
    % display    
    debugString = sprintf('%s\t%s\t%s', num2str(length(XijkDiag) - diagonal,3), ' -- ', num2str(x,3));
    disp(debugString)

    