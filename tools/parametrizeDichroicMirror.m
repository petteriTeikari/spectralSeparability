function parametrizeDichroicMirror()

    %% data

        path = fullfile('..', 'data');
        file{1} = 'fv1000mpe_olympus_dm485_0-100%transmittance_400-700nm_DM_interpData.txt';
        file{2} = 'fv1000mpe_olympus_dm505_0-100%transmittance_400-700nm_DM_interpData.txt';
        file{3} = 'fv1000mpe_olympus_dm570_0-100%transmittance_400-700nm_DM_interpData.txt';
        % file{4} = 'T635lpxr_Chroma_5050-ascii.txt';
    
    %% import
    
        for i = 1 : length(file)
            tmp = importdata(fullfile(path, file{i}), '\t', 1);
            wavelength = tmp.data(:,1);
            transmittance(:,i) = tmp.data(:,2);

            % normalize
            transmittanceNorm(:,i) = transmittance(:,i) / max(transmittance(:,i));

            % smooth
            lowessParam = 0.05;
            transmittanceSmooth(:,i) = smooth(wavelength, transmittanceNorm(:,i), ...
                                            lowessParam, 'rloess');

        end

        %{
        subplot(1,3,1)
            plot(wavelength, transmittanceNorm); title('Norm')
        subplot(1,3,2)
            plot(wavelength, transmittanceSmooth); title('Smooth')
        subplot(1,3,3)
            plot(wavelength, transmittanceNorm-transmittanceSmooth); title('Diff.')
        %}
  
    %% fit
    
        % fit a sigmoid as an initial guess (this will get rid of the
        % oscillations but is easy to just use the same y_min, y_max and
        % slope and in the end just vary the intersection wavelength:
        % paramOut(i,3)
    
        options = [];
        for i = 1 : size(transmittanceNorm,2)
            init0 = sigmoid_initCoeffs(wavelength,transmittanceNorm(:,i));
            paramOut(i,:) = nlinfit(wavelength, transmittanceNorm(:,i), 'sigmoid_4param', init0, options);
            fitOut(:,i) = sigmoid_4param(paramOut(i,:), wavelength);
            
            % you could try sinusoids as well
                % cftool(wavelength, transmittanceNorm(:,i))
            
            % plot
            subplot(1,size(transmittanceNorm,2),i)
                p(i,:) = plot(wavelength, transmittanceNorm(:,i), 'ko', ...
                              wavelength, fitOut(:,i));
                          
            % legend
            leg = legend('Input', ['Sigmoid, slope = ', num2str(paramOut(i,4),4)], 'Sinusoids', 'Location', 'best');
                legend('boxoff');
            
            title(file{i}, 'FontSize', 7, 'Interpreter', 'none')
            
            if i == size(transmittanceNorm,2)
                paramOut
                averageSlope = mean(paramOut(:,4))
                tx = text(420, 0.6, ['Slope_a_v_e_r = ', num2str(averageSlope)]);
            end
        end
        
        set(tx, 'FontSize', 10, 'FontWeight', 'bold')
        set(p(:,2), 'Color', [0 .6 1], 'LineWidth', 2)
        export_fig('parametrizeDichroicMirror.png', '-r200', '-a1')
        
        
        
        
    
        
    function init_params = sigmoid_initCoeffs(x,y)

        % INIT_COEFFS Function to generate the initial parameters for the 4
        % parameter dose response curve.

        parms    = ones(1,4);
        parms(1) = min(y);
        parms(2) = max(y);
        parms(3) = (min(x)+max(x))/2;

        % get input sizes
        sizey    = size(y);
        sizex    = size(x);

        % further fixing
        %{
        if (y(1)-y(sizey)) ./ (x(2)-x(sizex))>0
            parms(4)=(y(1)-y(sizey))./(x(2)-x(sizex));
        else
            parms(4)=1;
        end    
        %}
        parms(4) = 1;

        init_params=parms;