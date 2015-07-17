function optim = optimize_2PM_system(optim_parameters, ...
                            wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, ...
                            fluorophoreIndices, barrierFilterWanted, filters, channelMatrix, matrixType, normalizeOn, PMTs)
              
    if nargin == 0
        load variablesTemp.mat
    else
        save variablesTemp.mat
    end
    
    optim = 0;
    
    %% OPTIMIZATION SETUP
    
        % visualize the progress
        visualizeOn = true;
    
        % Parameter to be changed during optimization
        x = [optim_parameters.laser.init ...
             optim_parameters.DM1.init ...
             optim_parameters.DM2.init]; % [laserPeak DM1cut DM2cut]

        % constrain the range, use the variable names used in Matlab help

            % upper wavelength limits
            ub = [optim_parameters.laser.range(2) ...
                  optim_parameters.DM1.range(2) ...
                  optim_parameters.DM2.range(2)];

            % lower wavelength limits
            lb = [optim_parameters.laser.range(1) ...
                  optim_parameters.DM1.range(1) ...
                  optim_parameters.DM2.range(1)];

            % Inequality estimation parameters, 
            % 'doc fmincon' for more info
            A = [];
            b = [];
            Aeq = [];
            beq = [];            
            nonlcon = [];
    
        % define the cost function
        f = @(x) Xijk_costFunction(x, wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, ...
            fluorophoreIndices, barrierFilterWanted, filters, channelMatrix, matrixType, normalizeOn, visualizeOn, PMTs);
    
        % Define options for minimization function
            options = optimset('Algorithm', 'interior-point', 'Display', 'on');
    
    %% OPTIMIZE
            
        [x, fval] = fmincon(f,x,A,b,Aeq,beq,lb,ub,nonlcon,options)
    
    
    
    
    
    %% COST FUNCTION
    function SS = Xijk_costFunction(x, wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, ...
                    fluorophoreIndices, barrierFilterWanted, filters, channelMatrix, matrixType, normalizeOn, visualizeOn, PMTs)
        
        % Parse input x
        disp(x)
        laserPeak = x(1);
        DM1cut = x(2);
        DM2cut = x(3);
                
        % laser spectrum
        FWHM = 3; % [nm], check whether 10 nm is true for our system, broad for a laser
        lightSources = import_lightSources(wavelength, laserPeak, FWHM);
        lightsWanted = {'Laser'};
        excitationMatrix = getDataMatrix(lightSources, wavelength, lightsWanted, 'light', [], normalizeOn);
         
        % static definition
        dichroicsWanted = {'DM485'; 'DM570'}; 
        
        % overwrite 
        %dichroicsWanted{1} = ['synthDM_', num2str(DM1cut)]; % DM1
        %dichroicsWanted{2} = ['synthDM_', num2str(DM2cut)]; % DM2
             
        channelsWanted = {'RXD1'; 'RXD2'; 'RXD3'; 'RXD4'};        
        barrierFilterWanted = {'SDM560'}; % this separates RXD1&RXD2 from RXD3&RXD4
        channelMatrix = getChannelWrapper(channelsWanted, length(channelsWanted), dichroicsWanted, barrierFilterWanted, wavelength, filters, PMTs, normalizeOn);
            
        Xijk = computeSpectralSeparabilityMatrix(wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, ...
                    fluorophoreIndices, barrierFilterWanted, filters, channelMatrix, matrixType, normalizeOn);
    
        [XijkDiag, kcps] = getDiagonals(Xijk.matrix, Xijk.excitationScalar);
    
        % minimize 
        XijkDiag = XijkDiag - 1;
        
        % actually we minimize sum of squares (residuals)
        SS = sum(XijkDiag .^ 2);
        
        if visualizeOn
            plot(wavelength, channelMatrix.filtersUsed{2}.dichroicData, ...
                 wavelength, channelMatrix.filtersUsed{4}.dichroicData, ...
                 wavelength, excitationMatrix.data)
            legend(['DM1, ', num2str(x(2)), ' nm'], ...
                   ['DM2, ', num2str(x(3)), ' nm'], ...
                   ['Laser, ', num2str(x(1)), ' nm'])
            title(['SS = ', num2str(SS)])
            drawnow
            pause
        end
        
    %% SUBFUNCTION for COST FUNCTION 
    function [XijkDiag, kcps] = getDiagonals(Xijk_matrix, kcpsIn)
        
        % return diagonal of Xijk matrix
        kcpsIn = squeeze(kcpsIn);
        
        for i = 1 : size(Xijk_matrix,1)
            for j = 1 : size(Xijk_matrix,2)
                if i == j
                    XijkDiag(i) = Xijk_matrix(i,j); % relative in relation to that channel
                    kcps(i) = kcpsIn(i,j); % absolute units, kcps
                end
            end
        end
    