function [channelVector, plotColor, filtersUsed] = getChannelSpectralSensitivity(channelWanted, ch, noOfchannelsWanted, ...
            emissionFiltWanted, dichroicsWanted, barrierFilterWanted, wavelength, filters, PMTs, normalizeOn)

    % Depending on the setup, these might not be so fixed and you could
    % only have these fixed 4 options (RXD1/2/3/4). Add later more if you
    % can change the emission filters or mirrors for example without having
    % to remove the old definitons.

    % barrierFilterWanted % better to use when computing the Xijk
    % dichroicsWanted
 
    % TODO: simplify the use of cells, remove double-cells at some point
    
    %% CHANNEL-SPECIFIC 
    
        if strcmp(channelWanted, 'RXD1') % VIOLET (420-460 nm)

            filters
            
            filters.emissionFilter
            
            % Microscope filters
            filtersWantedEmission = {emissionFiltWanted{1}};
            filterEmission = getDataMatrix(filters.emissionFilter, wavelength, filtersWantedEmission, 'filter', [], normalizeOn);

            filtersWantedDichroic = {dichroicsWanted{1}};
            filterDichroic = getDataMatrix(filters.emissionDichroic, wavelength, filtersWantedDichroic, 'filter', [], normalizeOn);
                   
            % note now, we need to invert the transmittance as it is defined on
            % disk as passing the longer wavelength through
            filterDichroic.data = 1 - filterDichroic.data;

            % Get this later clarified
            PMTWanted = {'PMT Ga-As'};
            PMT = getDataMatrix(PMTs, wavelength, PMTWanted, 'PMT', [], normalizeOn);

            % color (that matches the color of the sensitivity)        
            plotColor = [0.48 0.063 0.89];

        elseif strcmp(channelWanted, 'RXD2') % GREEN (495-540 nm)

            % Microscope filters
            filtersWantedEmission = {emissionFiltWanted{2}};
            filterEmission = getDataMatrix(filters.emissionFilter, wavelength, filtersWantedEmission, 'filter', [], normalizeOn);

            filtersWantedDichroic = {dichroicsWanted{1}};
            filterDichroic = getDataMatrix(filters.emissionDichroic, wavelength, filtersWantedDichroic, 'filter', [], normalizeOn);

            % Get this later clarified
            PMTWanted = {'PMT Ga-As-P'};
            PMT = getDataMatrix(PMTs, wavelength, PMTWanted, 'PMT', [], normalizeOn);

            % color (that matches the color of the sensitivity)        
            plotColor = [0 1 0]; 

        elseif strcmp(channelWanted, 'RXD3') % LONG-PASS (380-560 nm)

            % Microscope filters
            filtersWantedEmission = {emissionFiltWanted{3}};
            filterEmission = getDataMatrix(filters.emissionFilter, wavelength, filtersWantedEmission, 'filter', [], normalizeOn);
            
                % no filter
                %filtersWantedEmission = {'no filter'};
                %filterEmission.data = ones(length(wavelength), 1);                

            filtersWantedDichroic = {dichroicsWanted{2}}; % 'DM570'
            filterDichroic = getDataMatrix(filters.emissionDichroic, wavelength, filtersWantedDichroic, 'filter', [], normalizeOn);
           
            % note now, we need to invert the transmittance as it is defined on
            % disk as passing the longer wavelength through
            filterDichroic.data = 1 - filterDichroic.data;

            % Get this later clarified
            PMTWanted = {'PMT Ga-As-P'};
            PMT = getDataMatrix(PMTs, wavelength, PMTWanted, 'PMT', [], normalizeOn);

            % color (that matches the color of the sensitivity)        
            plotColor = [.1 .1 .1];

        elseif strcmp(channelWanted, 'RXD4') % RED (575-630 nm)

            % Microscope filters
            filtersWantedEmission = {emissionFiltWanted{4}};
            filterEmission = getDataMatrix(filters.emissionFilter, wavelength, filtersWantedEmission, 'filter', [], normalizeOn);
            
                % no filter
                filtersWantedEmission = {'no filter'};
                filterEmission.data = ones(length(wavelength), 1); 

            filtersWantedDichroic = {dichroicsWanted{2}}; % 'DM570'
            filterDichroic = getDataMatrix(filters.emissionDichroic, wavelength, filtersWantedDichroic, 'filter', [], normalizeOn);

            % filterDichroic.data = 1 - filterDichroic.data;
            
            % Get this later clarified
            PMTWanted = {'PMT Ga-As'};
            PMT = getDataMatrix(PMTs, wavelength, PMTWanted, 'PMT', [], normalizeOn);

            % color (that matches the color of the sensitivity)        
            plotColor = [1 0 0]; 

        else
            error(['You wanted the channel "', channelWanted, '", which is not a valid channel'])
        end

    %% FINAL OUTPUT
    
        % now just multiply the components, add "ones"-vectors if only channel
        % have something weird happening, e.g.   
        % size(filterEmission.data)
        % size(filterDichroic.data)
        % size(PMT.data)
        channelVector = filterEmission.data .* filterDichroic.data .* PMT.data;
        filtersUsed.emission = filtersWantedEmission;
        filtersUsed.emissionData = filterEmission.data;
        filtersUsed.dichroic = filtersWantedDichroic;
        filtersUsed.dichroicData = filterDichroic.data;
        
        % for easier plotting later, construct the legend string to be displayed    
        filtersUsed.legendString = [channelWanted, ' (', cell2mat(filtersUsed.dichroic), '+', cell2mat(filtersUsed.emission),')'];
        % filtersUsed
        
        
    %% Debug plot
    
        debugPlot = false;
        if debugPlot
            
            disp(' DEBUG PLOT from getChannelSpectralSensitivity.m')
            
            if ch == 1
                scrsz = get(0,'ScreenSize'); % get screen size for plotting    
                fig = figure;
                    set(fig,  'Position', [0.4*scrsz(3) 0.345*scrsz(4) 0.550*scrsz(3) 0.60*scrsz(4)])
                
            end
            
            rows = floor(noOfChannels/2);
            cols = ceil(noOfChannels/2);
            
            sp(ch) = subplot(rows,cols,ch);
            
                p(ch, :) = plot(wavelength, filterEmission.data, ...
                                 wavelength, filterDichroic.data, ...
                                 wavelength, PMT.data, ...
                                 wavelength, channelVector);

                legStr = {['emission (', cell2mat(filtersWantedEmission), ')'];...
                          ['dichroic (', cell2mat(filtersWantedDichroic), ')'];...
                          ['PMT (', cell2mat(PMTWanted), ')'];...
                          ['Channel Out (', channelWanted, ')']};

                leg(ch) = legend(legStr, 'FontSize', 8, 'Location', 'best');
                    legend('boxoff')
                    
                tit(ch) = title(channelWanted);
                
                set(p(ch,end), 'Color', plotColor)
                set(sp(ch), 'XLim', [400 700])
                
        end
        
    
    

        