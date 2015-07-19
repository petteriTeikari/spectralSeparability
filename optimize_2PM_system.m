function optim = optimize_2PM_system(optim_parameters, ...
                            wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, ...
                            fluorophoreIndices, barrierFilterWanted, filters, channelMatrix, matrixType, normalizeOn, PMTs)
              
    if nargin == 0
        load variablesTemp.mat
        close all
    else
        save variablesTemp.mat
    end
    
    optim = 0;
    
    %% OPTIMIZATION SETUP
    
        % visualize the progress
        visualizeOn = false;
    
        % Parameter to be changed during optimization
        x0 = [optim_parameters.laser.init ...
             optim_parameters.DM1.init ...
             optim_parameters.DM2.init ...
             optim_parameters.BF.init ...
             optim_parameters.RXD1emission.init ...
             optim_parameters.RXD2emission.init ...
             optim_parameters.RXD3emission.init ...
             optim_parameters.RXD4emission.init]; 

        % constrain the range, use the variable names used in Matlab help

            % upper wavelength limits
            ub = [optim_parameters.laser.range(2) ...
                  optim_parameters.DM1.range(2) ...
                  optim_parameters.DM2.range(2) ...
                  optim_parameters.BF.range(2) ...
                  optim_parameters.RXD1emission.range(2) ...
                  optim_parameters.RXD2emission.range(2) ...
                  optim_parameters.RXD3emission.range(2) ...
                  optim_parameters.RXD4emission.range(2)];

            % lower wavelength limits
            lb = [optim_parameters.laser.range(1) ...
                  optim_parameters.DM1.range(1) ...
                  optim_parameters.DM2.range(1) ...
                  optim_parameters.BF.range(1) ...
                  optim_parameters.RXD1emission.range(1) ...
                  optim_parameters.RXD2emission.range(1) ...
                  optim_parameters.RXD3emission.range(1) ...
                  optim_parameters.RXD4emission.range(1)];

        % Inequality estimation parameters, 
        % 'doc fmincon' for more info
        % You could later want to add some more constraints, if you want
        % the absolute emission (kcps) to be above given thresold for
        % example, etc.
        A = [];
        b = [];
        Aeq = [];
        beq = [];            
        nonlcon = [];
    
        % init visualization figure
        visualizeOn = true;
        if visualizeOn            
            [h.fig, h.sp, h.p, h.imgH, h.labels] = optim_initVisualize(wavelength, fluoroExcitationMatrix);
        else
            
        end        
            
        % quick'n'dirty testing
        x0 = [800]; ub = [900]; lb = [740];
        
        % define the cost function     
        f = @(x0) Xijk_costFunction(x0, wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, ...
            fluorophoreIndices, barrierFilterWanted, filters, channelMatrix, matrixType, normalizeOn, visualizeOn, h, PMTs);
    
        % Define options for minimization function
            options = optimset('Display', 'on');
    
    %% OPTIMIZE
            
        % see e.g.
        % http://www.mathworks.com/help/optim/ug/choosing-a-solver.html#brhkghv-21
        % fmincon: http://www.mathworks.com/help/optim/ug/fmincon.html#f355328
       
        
        % fmincon       
        [x, fval] = fmincon(f,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)
        x0
        
     

    
    
    
    
    %% COST FUNCTION
    function SS = Xijk_costFunction(x, wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, ...
                    fluorophoreIndices, barrierFilterWanted, filters, channelMatrix, matrixType, normalizeOn, visualizeOn, h, PMTs)
        
        % Parse input x
        disp(x)
        laserPeak = x(1);
        
        if length(x) == 1 
            % quick'n'dirty testing with the laser peak only
            DM1cut = 485;
            DM2cut = 630;
            BFcut = 560;
            RXD1center = 420;
            RXD2center = 480;
            RXD3center = 590;
            RXD4center = 650;
        else
            % with all the optimization parameters
            DM1cut = x(2);
            DM2cut = x(3);
            BFcut = x(4);
            RXD1center = x(5);
            RXD2center = x(6);
            RXD3center = x(7);
            RXD4center = x(8);
        end
                
        % laser spectrum
        FWHM = 3; % [nm], check whether 10 nm is true for our system, broad for a laser
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
        width = 50;
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
    
        [XijkDiag, kcps] = getDiagonals(Xijk.matrix, Xijk.excitationScalar);
        disp(XijkDiag)
        % disp(kcps)
        
        % minimize (minimize the difference to 1, which in practice means
        % that for given channel, all the signal is coming from a single
        % fluorophore)
        XijkDiag = XijkDiag - 1;
        
        % actually we minimize sum of squares (residuals)
        SS = sum(XijkDiag(1:end) .^ 2); 
        
        % TODO: init, and update the values (a lot faster
        visualizeOn = true;
        if visualizeOn
            optim_updateVisualization(h, ...
                    wavelength, Xijk, channelMatrix, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, ...
                    XijkDiag, SS);            
        end
    
    % init optim plot
    function [fig, sp, p, imgH, labels] = optim_initVisualize(wavelength, fluoroExcitationMatrix)
        
        fig = figure('Color','w', 'Name', 'Optimization Visualization');
            scrsz = get(0,'ScreenSize'); % get screen size for plotting    
            set(fig,  'Position', [0.04*scrsz(3) 0.3*scrsz(4) 0.92*scrsz(3) 0.6*scrsz(4)])

        rows = 4;
        cols = 4;
        
        yLimitsExcit = [min(fluoroExcitationMatrix.data(:)) max(fluoroExcitationMatrix.data(:))];
        
        ind = 1;
            sp(ind) = subplot(rows,cols,[1 5]);
                p{ind} = plot(NaN,NaN, NaN,NaN, NaN,NaN);
                title('Filters')
        
        ind = 2;
            sp(ind) = subplot(rows,cols,[2 6]);                
                p{ind} = plot(wavelength, [zeros(length(wavelength),1) fluoroExcitationMatrix.data]);
        
        ind = 3;
            sp(ind) = subplot(rows,cols,[9 10 13 14]);
                x = [1 2]; y = [0 0];
                p{ind}(1:4) = plot(x,y, x,y, x,y, x,y);
                labels.tit = title('Filtered Emission on diagonal');
        
        ind = 4;
            sp(ind) = subplot(rows,cols,[3 4 7 8 11 12 15 16]);                
                imgH = imshow([1 1; 1 1]);
                title('X_i_j_k')
        
        set(sp([1 3]), 'XLim', [400 750], 'YLim', [0 1.05])
        set(sp(2), 'XLim', [700 950], 'YLim', [0 yLimitsExcit(end)])
        set(sp, 'FontSize', 7)
        
        %{
        set(p{3}(:), 'EdgeColor', 'none')
            set(p{3}(1), 'FaceColor', [0 0 1])
            set(p{3}(2), 'FaceColor', [0 1 0])
            set(p{3}(3), 'FaceColor', [1 0 0])
            set(p{3}(4), 'FaceColor', [0 0 0])
        %}
      
    % update optim plots    
    function optim_updateVisualization(h, ...
                    wavelength, Xijk, channelMatrix, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, XijkDiag, SS)
            
            %{
            h.fig
            h.sp
            h.p
            h.imgH
            h.labels.tit
            h.labels.xlab
            h.labels.ylab
            %}
            
            % FILTERS
            set(h.p{1}(1), 'XData', wavelength, 'YData', channelMatrix.filtersUsed{1}.dichroicData)
            set(h.p{1}(2), 'XData', wavelength, 'YData', channelMatrix.filtersUsed{4}.dichroicData)
            % set(h.p{1}(3), 'XData', wavelength, 'YData', 0.35*excitationMatrix.data)            
            
            % LASER
            yLimitsExcit = [min(fluoroExcitationMatrix.data(:)) max(fluoroExcitationMatrix.data(:))];
            set(h.p{2}(1), 'XData', wavelength, 'YData', yLimitsExcit(end)*excitationMatrix.data)
            
            % EMISSIONS
            set(h.p{3}(1), 'XData', wavelength, 'YData', channelMatrix.filtersUsed{1}.emissionData)
            set(h.p{3}(2), 'XData', wavelength, 'YData', channelMatrix.filtersUsed{2}.emissionData)
            set(h.p{3}(3), 'XData', wavelength, 'YData', channelMatrix.filtersUsed{3}.emissionData)
            set(h.p{3}(4), 'XData', wavelength, 'YData', channelMatrix.filtersUsed{4}.emissionData)   
            
            % Xijk
            upscaleFactor = 100;
            saveOn = false;
            plotXijkAsImage(Xijk, upscaleFactor, fluoroEmissionMatrix, channelMatrix, saveOn)        

            
            %{
            plot(wavelength, channelMatrix.filtersUsed{1}.dichroicData, ...
                 wavelength, channelMatrix.filtersUsed{4}.dichroicData, ...
                 wavelength, channelMatrix.filtersUsed{1}.emissionData, ...
                 wavelength, channelMatrix.filtersUsed{2}.emissionData, ...
                 wavelength, channelMatrix.filtersUsed{3}.emissionData, ...
                 wavelength, channelMatrix.filtersUsed{4}.emissionData, ...
                 wavelength, channelMatrix.filtersUsed{4}.emissionData, ...
                 wavelength, excitationMatrix.data)
            
            legend('DM1', 'DM2', 'EM1', 'EM2', 'EM3', 'EM4', 'BF', 'LASER')
            legend('boxoff')
            %legend(['DM1 ch1, ', num2str(x(2)), ' nm'], ['DM2 ch4, ', num2str(x(3)), ' nm'], [Laser, ', num2str(x(1)), ' nm'])
            title(['SS = ', num2str(SS)])
            %}
            drawnow
            
        
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