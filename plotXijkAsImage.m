function plotXijkAsImage(fig, scrsz, Xijk, upscaleFactor, fluoroEmission, channelMatrix)

    % now we for example 3x4 matrix which will be so tiny when plotted
    XijkImage = imresize(Xijk.matrix, upscaleFactor, 'nearest');
    imshow(XijkImage)
    colormap('pink')
        % TODO: Custom colormap, that visualizes the differences like jet
        % but allows text to be overlaid with decent readability
    colorbar

    % now the excitation scalar matrix 
    absXijk = squeeze(Xijk.matrixAbs);
    kcps = squeeze(Xijk.excitationScalar); % fix for multiple light sources
    
    xTickLocs = upscaleFactor * (0.5:1:(size(Xijk.matrix,2) - 0.5));
    yTickLocs = upscaleFactor * (0.5:1:(size(Xijk.matrix,1) - 0.5));
    axis on
    whos
    
    % for text
    yOffset = (yTickLocs(2) - yTickLocs(1)) * 0.15;
    thrTextColor = 0.5;
    
    
    % get trace of the kcps
    for i = 1 : size(kcps,1)
        for j = 1 : size(kcps, 2)
            if i == j
                diagonalAbsEmissions(j) = kcps(i,j);
                absXijkDiag(j) = absXijk(i,j);
            end
            t(i,j,1) = text(xTickLocs(j), yTickLocs(i)-yOffset, num2str(Xijk.matrix(i,j),2));
            t(i,j,2) = text(xTickLocs(j), yTickLocs(i)+yOffset, num2str(absXijk(i,j),2));
            % t(i,j,3) = text(xTickLocs(j), yTickLocs(i)+(2*yOffset), num2str(kcps(i,j),2));
            
            % fix the contrast issue
                if Xijk.matrix(i,j) > thrTextColor
                    set(t(i,j,:), 'Color', [0 0 0])
                else
                    set(t(i,j,:), 'Color', [1 1 1])
                end          
            
        end
    end
    
    % diagonalEmissions
    
    set(gca, 'YTickLabel', fluoroEmission.name, 'YTick', yTickLocs)
    set(gca, 'XTickLabel', channelMatrix.name, 'XTick', xTickLocs)
    set(gca, 'FontSize', 8)
    
    set(t, 'HorizontalAlignment', 'center', 'FontSize', 6)
    set(t(:,:,1), 'FontWeight', 'bold', 'FontSize', 7)
    
    title(['X_i_j_k, Laser peak = ', num2str(Xijk.laserPeak), ' nm '], 'FontWeight', 'bold', 'FontSize', 11)
    
    export_fig(fullfile('figuresOut', ['Xijk_ImageMatrix_', num2str(Xijk.laserPeak), '.png']), '-r150', '-a1')
