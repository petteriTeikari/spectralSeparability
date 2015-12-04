function plotXijkSpectra(fig, scrsz, wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, channelMatrix, Xijk, Eijk, options)

    rows = size(Xijk.matrix,1); 
    cols = size(Xijk.matrix,2); 
    
    laserIndex = 1; 
    xLimits = [350 750];
    textLoc_x = 0.985*xLimits(2);
    textLoc_y = 0.8;
    
    for ch = 1 : length(channelMatrix.filtersUsed)
        titleString{ch} = sprintf('%s\n%s\n%s', channelMatrix.name{ch}, ...
                                                cell2mat(channelMatrix.filtersUsed{ch}.dichroic), ...
                                                cell2mat(channelMatrix.filtersUsed{ch}.emission));
    end
    
    % normalize the emissions per channel (let values be less than 1 if
    % none of the values exceed one), kinda quick fix atm
    for k = 1 : size(Xijk.matrix,2); % number of channels
        for j = 1 : size(Xijk.matrix,1); % number of fluorophores 
            channelFluorophores(:,j) = Xijk.emission{laserIndex,j,k};
        end
        maxValue(k) = max(max(channelFluorophores))        
        
        if maxValue(k) < 1
            maxValue(k) = 1;
        end
    end
    
    
    
    for j = 1 : size(Xijk.matrix,1); % number of fluorophores        
        for k = 1 : size(Xijk.matrix,2); % number of channels
            
            ind = k + (j-1)*cols;
            sp(j,k) = subplot(rows,cols,ind);
                p{j,k}(1) = area(wavelength, Xijk.channel{laserIndex,j,k});  
                hold on
                p{j,k}(2) = plot(wavelength, Xijk.emission{laserIndex,j,k} / maxValue(k));
                hold off                                
            
            % color            
            set(p{j,k}(1), 'FaceColor', channelMatrix.plotColor(k,:), 'EdgeColor', [.4 .4 .4]) % channel color
            set(p{j,k}(2), 'Color', fluoroEmissionMatrix.plotColor(j,:), 'LineWidth', 2) % fluorophore color
                            
            tx(j,k) = text(textLoc_x, textLoc_y, [num2str(Xijk.matrix(j,k),2)], 'HorizontalAlignment', 'right');
            
            if j == 1
                tit(k) = title(titleString{k});
            end
            
            if k == 1
                ylab(j) = ylabel(fluoroEmissionMatrix.name{j});
            end
            
        end        
    end
    
    % style
    set(sp, 'XLim', xLimits, 'YLim', [0 1])
    set(sp, 'FontSize', 7)
    set(tx, 'FontSize', 8, 'FontWeight', 'bold')
    set(tit, 'FontSize', 9, 'FontWeight', 'bold', 'Interpreter', 'none')
    set(ylab, 'FontSize', 9, 'FontWeight', 'bold')
    drawnow
    
    export_fig(fullfile('figuresOut', 'Xijk_SpectralPlot_630nmDichroic.png'), '-r200', '-a1')
    
    
