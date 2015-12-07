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
        set(h.p{1}(1), 'YData', channelMatrix.filtersUsed{1}.dichroicData)
        set(h.p{1}(2), 'YData', channelMatrix.filtersUsed{4}.dichroicData)
        % set(h.p{1}(3), 'XData', wavelength, 'YData', 0.35*excitationMatrix.data)            

        % LASER
        yLimitsExcit = [min(fluoroExcitationMatrix.data(:)) max(fluoroExcitationMatrix.data(:))];
        set(h.p{2}(1), 'YData', yLimitsExcit(end)*excitationMatrix.data)

        % EMISSIONS
        set(h.p{3}(1), 'YData', channelMatrix.filtersUsed{1}.emissionData)
        set(h.p{3}(2), 'YData', channelMatrix.filtersUsed{2}.emissionData)
        set(h.p{3}(3), 'YData', channelMatrix.filtersUsed{3}.emissionData)
        set(h.p{3}(4), 'YData', channelMatrix.filtersUsed{4}.emissionData)   

        set(h.p{3}(5), 'YData', fluoroEmissionMatrix.data(:,1))
        set(h.p{3}(6), 'YData', fluoroEmissionMatrix.data(:,2))
        set(h.p{3}(7), 'YData', fluoroEmissionMatrix.data(:,3))
        set(h.p{3}(8), 'YData', fluoroEmissionMatrix.data(:,4))   

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

        % set(h.sp(2), 'XLim', [700 950], 'YLim', [0 yLimitsExcit(end)])
        drawnow

        