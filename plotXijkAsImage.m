function plotXijkAsImage(fig, scrsz, Xijk, upscaleFactor, fluoroEmission, channelMatrix)

    % now we for example 3x4 matrix which will be so tiny when plotted
    XijkImage = imresize(Xijk.matrix, upscaleFactor, 'nearest');
    imshow(XijkImage)
    colormap('jet')
    colorbar

    % now the excitation scalar matrix 
    kcps = squeeze(Xijk.excitationScalar); % fix for multiple light sources
    
    xTickLocs = upscaleFactor * (0.5:1:(size(Xijk.matrix,2) - 0.5));
    yTickLocs = upscaleFactor * (0.5:1:(size(Xijk.matrix,1) - 0.5));
    axis on

    for i = 1 : size(kcps,1)
        for j = 1 : size(kcps, 2)
            if i == j
                diagonalEmissions(j) = kcps(i,j);
            end
        end
    end
    
    diagonalEmissions
    
    set(gca, 'YTickLabel', fluoroEmission.name, 'YTick', yTickLocs)
    set(gca, 'XTickLabel', channelMatrix.name, 'XTick', xTickLocs)

    title('X_i_j_k', 'FontWeight', 'bold', 'FontSize', 11)
    
    export_fig(fullfile('figuresOut', 'Xijk_ImageMatrix_630nmDichroic.png'), '-r200', '-a1')
