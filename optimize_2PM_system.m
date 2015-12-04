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
    
        % init visualization figure (unused now, as was used with fmincon)
        visualizeOn = false;
        if visualizeOn            
            [h.fig, h.sp, h.p, h.imgH, h.labels] = optim_initVisualize(wavelength, fluoroExcitationMatrix);
        else
            h = [];
        end      
        
        % help the optimization so that the filters do not overlap, move
        % only RXD2 and RXD4
        width = 50;        
        
            if x0(6) - (width/2) < x0(5) + (width/2)
                x0(6) = x0(5) + 2*(width/2) + 30;
                disp('Manual shift of RXD2 towards longer wavelengths')
            end

            if x0(8) - (width/2) < x0(7) + (width/2)
                x0(8) = x0(7) + 2*(width/2) + 30;
                disp('Manual shift of RXD4 towards longer wavelengths')
            end  
            
        % GAOT (Genetic Algorithm optiomization) requires a bit different 
        % syntax so now define another cost function for it (same output, idea though)
        save('ga_tempVariables.mat', 'wavelength', 'fluoroEmissionMatrix', 'fluoroExcitationMatrix', ...
                                         'fluorophoreIndices', 'filters', 'matrixType', 'normalizeOn', 'h', 'PMTs')
                                     
            % TODO: remove at some points this cumbersome fix, which was
            % added as init try was with fmincon which did not require this
    
    %% OPTIMIZE
            
        % Several options in addition to Matlab's own (if you have the license)
        % http://www.geatbx.com/ea_matlab.html
    
        % Genetic algorithm (GAOT), using free 3rd party toolbox that
        % doesn't require any additional commercial toolboxes
        % https://github.com/estsauver/GAOT
            
            % re-define bounds
            bounds = [lb' ub'];
            % plotHandles = h; % plot handles unused now
            [x, endPop, bestSols, trace] = ga(bounds, 'optim_Xijk_costFunction_ga');
                % TODO: check if there is a name conflict with the official
                %       GA of Matlab
                
            % display the results
            disp('BEST PARAMETERS for the 2PM-system')
            disp(['laser peak = ', num2str(x(1)), ' nm'])
            disp(['DichroicMirror1 cut = ', num2str(x(2)), ' nm'])
            disp(['DichroicMirror2 cut = ', num2str(x(3)), ' nm'])
            disp(['Barrier filter cut = ', num2str(x(4)), ' nm'])
            disp(['RXD1 Emission passband center = ', num2str(x(5)), ' nm'])
            disp(['RXD2 Emission passband center = ', num2str(x(6)), ' nm'])
            disp(['RXD3 Emission passband center = ', num2str(x(7)), ' nm'])
            disp(['RXD4 Emission passband center = ', num2str(x(8)), ' nm'])
            
            % TODO: output these values and plot as well
            
    % init optim plot
    function [fig, sp, p, imgH, labels] = optim_initVisualize(wavelength, fluoroExcitationMatrix)
        
        fig = figure('Color','w', 'Name', 'Optimization Visualization');
            scrsz = get(0,'ScreenSize'); % get screen size for plotting    
            set(fig,  'Position', [0.04*scrsz(3) 0.5*scrsz(4) 0.92*scrsz(3) 0.5*scrsz(4)])

        rows = 4;
        cols = 4;
        
        yLimitsExcit = [min(fluoroExcitationMatrix.data(:)) max(fluoroExcitationMatrix.data(:))];
        
        % dummy x and y
        x = wavelength;
        y = zeros(length(wavelength),1);
        
        ind = 1;
            sp(ind) = subplot(rows,cols,[1 5]);
                p{ind}(1) = plot(x, y, 'b');
                hold on
                p{ind}(2) = plot(x, y, 'r');
                hold off
                title('Filters')
        
        ind = 2;
            sp(ind) = subplot(rows,cols,[2 6]);                
                p{ind} = fill(wavelength, zeros(length(wavelength),1), 'k');
                hold on
                pStatic = plot(wavelength, fluoroExcitationMatrix.data);
                hold off
        
        ind = 3;
            sp(ind) = subplot(rows,cols,[9 10 13 14]);
                p{ind}(1) = fill(x, y, 'k'); % easier to style fill than area
                hold on
                p{ind}(2) = fill(x, y, 'k');
                p{ind}(3) = fill(x, y, 'k');
                p{ind}(4) = fill(x, y, 'k');                
                p{ind}(5:8) = plot(x,y, x,y, x,y, x,y);
                
                labels.tit = title('Filtered Emission on diagonal');
                
        
        ind = 4;
            sp(ind) = subplot(rows,cols,[3 4 7 8 11 12 15 16]);                
                imgH = imshow([1 1; 1 1]);
                title('X_i_j_k')
        
        
        set(sp([1 3]), 'XLim', [400 750], 'YLim', [0 1.05])
        set(sp(2), 'XLim', [700 950], 'YLim', [0 yLimitsExcit(end)])
        set(sp, 'FontSize', 7)        
        
        %{
        set(p{1}(1:2), 'EdgeColor', 'none')
            set(p{1}(1), 'FaceColor', [0 0 1])
            set(p{1}(2), 'FaceColor', [1 0 0])
        %}
        
        set(p{2}, 'EdgeColor', 'none', 'facealpha' ,0.5)
            
        set(p{3}(1:4), 'EdgeColor', 'none', 'facealpha' ,0.3)
            set(p{3}(1), 'FaceColor', [0 0 1])
            set(p{3}(2), 'FaceColor', [0 1 0])
            set(p{3}(3), 'FaceColor', [1 0 0])
            set(p{3}(4), 'FaceColor', [0 0 0])