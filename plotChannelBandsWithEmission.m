function plotChannelBandsWithEmission(fig, scrsz, wavelength, excitationMatrix, ...
    fluoroEmissionMatrix, fluoroExcitationMatrix, channelMatrix, PMTs, Xijk, Eijk, options)

    rows = 3;
    cols = 1;
    ind = 0;
    
    % correct the y-limits of excitation spectra manually
    yLimitsExcit = [min(fluoroExcitationMatrix.data(:)) max(fluoroExcitationMatrix.data(:))];
    
    % Fluorophores (j) : Fluorophores
    ind = ind+1; fluoEmisInd = ind;
    sp(ind) = subplot(rows, cols, ind);
    
    alphaValue = 0.55;
    
        for i = 1 : size(channelMatrix.data,2)
            x = wavelength;
            y = channelMatrix.data(:,i);
            y(isnan(y)) = 0; % otherwise, the facecolor does not work
            p(i) = area(x, y, 'FaceColor', 'k');
            hold on           
            child = get(p(i),'Children');
            set(child,'FaceAlpha',alphaValue)
        end
        
        p2 = plot(wavelength, fluoroEmissionMatrix.data);        
        hold off
        
        leg(ind) = legend([channelMatrix.name fluoroEmissionMatrix.name]);
            legend('boxoff');
            % http://www.mathworks.com/matlabcentral/newsreader/view_thread/334559
            % ch = get(leg(ind), 'Children');
            % set(ch(1:4), 'FaceAlpha', 0.5);
            
        tit(ind) = title('Fluorophores with Channel Sensitivities');
        lab(ind,1) = xlabel('Wavelength [nm]');
        lab(ind,2) = ylabel('Normalized fluorescence');
        
    % Emission filters
    ind = ind+1;
    sp(ind) = subplot(rows, cols, ind);
    
        for i = 1 : length(channelMatrix.filtersUsed)
            legStr{i} = cell2mat(channelMatrix.filtersUsed{i}.emission);
            y = channelMatrix.filtersUsed{i}.emissionData;
            y(isnan(y)) = 0;
            p3(i) = area(wavelength, y);
            hold on
            child = get(p3(i),'Children');
            set(child,'FaceAlpha',alphaValue)
        end
        hold off
        tit(ind) = title('Emission Filters');
        
        leg(ind) = legend(legStr, 'Interpreter', 'none');
            legend('boxoff');


    
    % Dichroics
    ind = ind+1;
    sp(ind) = subplot(rows, cols, ind);
    
        dichroicIndex = 0;
        sdmIndex = 0;
        legInd = 0;
        for i = 1 : length(channelMatrix.filtersUsed)            
            
            if i == 1 || i == 4              
                dichroicIndex = dichroicIndex+1;
                y = channelMatrix.filtersUsed{i}.dichroicData;
                y(isnan(y)) = 0;

                p4(dichroicIndex) = area(wavelength, y);
                hold on
                child = get(p4(dichroicIndex),'Children');
                set(child,'FaceAlpha',alphaValue)
                
                legInd = legInd + 1;
                legStr2{legInd} = cell2mat(channelMatrix.filtersUsed{i}.dichroic);
            end
            
            if i == 3
                sdmIndex = sdmIndex + 1;
                y = channelMatrix.filtersUsed{i}.SDM_Data;
                y(isnan(y)) = 0;
                p5(sdmIndex) = area(wavelength, y);
                child = get(p5(sdmIndex),'Children');
                set(child,'FaceAlpha',alphaValue)
                
                legInd = legInd + 1;
                legStr2{legInd} = cell2mat(channelMatrix.filtersUsed{i}.SDM);
            end
            
        end
        hold off
        tit(ind) = title('Dichroic Filters');
        
        leg(ind) = legend(legStr2, 'Interpreter', 'none');
            legend('boxoff');

    
    %% STYLE
    
        for i = 1 : size(fluoroEmissionMatrix.data, 2)
            set(p2(i), 'Color', fluoroEmissionMatrix.plotColor(i,:), 'LineWidth', 2)
        end

        for i = 1 : size(channelMatrix.data,2)
            set([p(i) p3(i)], 'FaceColor', channelMatrix.plotColor(i,:), 'EdgeColor', channelMatrix.plotColor(i,:))
            
        end
        
        set(p4(1), 'FaceColor', 'b')
        set(p4(2), 'FaceColor', 'r')
        set(p5(1), 'FaceColor', 'g')
        
        set(sp, 'YLim', [0 1.02*yLimitsExcit(2)])
        set(sp, 'XLim', [380 950]) % add some switch later
        
        export_fig(fullfile('figuresOut', 'channelSensitivities.png'), '-r150', '-a2')