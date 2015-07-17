function plotXijkAsImage(fig, scrsz, Xijk, upscaleFactor, fluoroEmission, channelMatrix)

    % now we for example 3x4 matrix which will be so tiny when plotted
    XijkImage = imresize(Xijk.matrix, upscaleFactor, 'nearest');
    imshow(XijkImage)
    colormap('jet')
    colorbar

    xTickLocs = upscaleFactor * (0.5:1:(size(Xijk.matrix,2) - 0.5));
    yTickLocs = upscaleFactor * (0.5:1:(size(Xijk.matrix,1) - 0.5));
    axis on

    set(gca, 'YTickLabel', fluoroEmission.name, 'YTick', yTickLocs)
    set(gca, 'XTickLabel', channelMatrix.name, 'XTick', xTickLocs)

    title('X_i_j_k', 'FontWeight', 'bold', 'FontSize', 11)
    
    export_fig(fullfile('figuresOut', 'Xijk_ImageMatrix_630nmDichroic.png'), '-r200', '-a1')
