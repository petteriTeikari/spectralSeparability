function plotSpectralSeparability(fig, scrsz, wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, channelMatrix, Xijk, Eijk, options)

    set(fig,  'Position', [0.04*scrsz(3) 0.05*scrsz(4) 0.40*scrsz(3) 0.90*scrsz(4)])

    rows = 3; cols = 1;
    
    % Excitation (i) : Light Sources
    ind = 1;  excitInd = ind; fluoExcitInd = ind;
    sp(ind) = subplot(rows, cols, ind);
        
        % size(excitationMatrix.data)
        % size(wavelength)
        % size(fluoroExcitationMatrix.data)
        
        % p{ind} = plot(wavelength, excitationMatrix.data, wavelength, fluoroExcitationMatrix.data);        
        ar{ind} = area(wavelength, excitationMatrix.data);
        hold on
        p{ind} = plot(wavelength, fluoroExcitationMatrix.data);
        hold off
        legStr = [excitationMatrix.name; fluoroExcitationMatrix.name'];
        leg(ind) = legend(legStr);
            legend('boxoff');
        title('Light Sources + Excitation Spectra, "i of X_i_j_k"')
        lab(ind,1) = xlabel('Wavelength [nm]');
        lab(ind,2) = ylabel('Normalized Irradiance/Sensitivity');
    
    % Fluorophores (j) : Fluorophores
    ind = ind+1; fluoEmisInd = ind;
    sp(ind) = subplot(rows, cols, ind);
        % size(fluoroMatrix.data)
        p{ind} = plot(wavelength, fluoroEmissionMatrix.data);
            % fluoroMatrix.plotColor, add later
        leg(ind) = legend(fluoroEmissionMatrix.name);
            legend('boxoff');
        title('Fluorophores (emission), j of X_i_j_k')
        lab(ind,1) = xlabel('Wavelength [nm]');
        lab(ind,2) = ylabel('Normalized fluorescence');
    
    % Channels (k)
    ind = ind+1; filterInd = ind;
    sp(ind) = subplot(rows, cols, ind);
        % size(channelMatrix.data)
        p{ind} = plot(wavelength, channelMatrix.data);    
        % unwrap the structure for legendString
        for legSt = 1 : length(channelMatrix.filtersUsed)
            legStr{legSt} = channelMatrix.filtersUsed{legSt}.legendString;
        end
        % legStr % TODO, contains extra entry?
        leg(ind) = legend(legStr);        
            legend('boxoff');
        title('Filters/Channels, k of X_i_j_k')
        lab(ind,1) = xlabel('Wavelength [nm]');
        lab(ind,2) = ylabel('Normalized sensitivity');
        
    % style 
    set(sp(1:ind), 'XLim', [350 750], 'YLim', [0 1])
    set(sp(1), 'XLim', [700 1100]) % add some switch later
    % set(leg, 'Location', 'NorthEastOutside')
    set(leg, 'FontSize', 7, 'Color', [.3 .3 .3])
    
    % correct colors
    for i = 1 : size(excitationMatrix.data,2)
        set(p{excitInd}(i), 'Color', 'k')
    end    
    
    for i = 1 : size(fluoroExcitationMatrix.data,2)        
        set(p{fluoExcitInd}(i), 'Color', fluoroExcitationMatrix.plotColor(i,:))
    end
    
    for i = 1 : size(fluoroEmissionMatrix.data, 2)
        set(p{fluoEmisInd}(i), 'Color', fluoroEmissionMatrix.plotColor(i,:))
    end
    
    for i = 1 : size(channelMatrix.data,2)
        set(p{filterInd}(i), 'Color', channelMatrix.plotColor(i,:))
    end
    
    export_fig(fullfile('figuresOut', 'XijkBasisVectors_plot.png'), '-r200', '-a1')
        
    