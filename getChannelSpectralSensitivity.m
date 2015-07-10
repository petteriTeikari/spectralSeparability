function [channelVector, plotColor] = getChannelSpectralSensitivity(channelWanted, ch, noOfChannels, wavelength, filters, PMTs, normalizeOn)

    % Depending on the setup, these might not be so fixed and you could
    % only have these fixed 4 options (RXD1/2/3/4). Add later more if you
    % can change the emission filters or mirrors for example without having
    % to remove the old definitons.

    %% CHANNEL-SPECIFIC 
    
        if strcmp(channelWanted, 'RXD1') % VIOLET (420-460 nm)

            % Microscope filters
            filtersWanted1 = {'BA420-460'};
            filterEmission = getDataMatrix(filters.emissionFilter, wavelength, filtersWanted1, 'filter', [], normalizeOn);

            filtersWanted2 = {'DM485'};
            filterDichroic = getDataMatrix(filters.emissionDichroic, wavelength, filtersWanted2, 'filter', [], normalizeOn);

            % note now, we need to invert the transmittance as it is defined on
            % disk as passing the longer wavelength through
            filterDichroic.data = 1 - filterDichroic.data;

            % Get this later clarified
            PMTWanted = {'PMT Ga-As-P'};
            PMT = getDataMatrix(PMTs, wavelength, PMTWanted, 'PMT', [], normalizeOn);

            % color (that matches the color of the sensitivity)        
            plotColor = [0.48 0.063 0.89];

        elseif strcmp(channelWanted, 'RXD2') % GREEN (495-540 nm)

            % Microscope filters
            filtersWanted1 = {'BA495-540HQ'};
            filterEmission = getDataMatrix(filters.emissionFilter, wavelength, filtersWanted1, 'filter', [], normalizeOn);

            filtersWanted2 = {'DM485'};
            filterDichroic = getDataMatrix(filters.emissionDichroic, wavelength, filtersWanted2, 'filter', [], normalizeOn);

            % Get this later clarified
            PMTWanted = {'PMT Ga-As-P'};
            PMT = getDataMatrix(PMTs, wavelength, PMTWanted, 'PMT', [], normalizeOn);

            % color (that matches the color of the sensitivity)        
            plotColor = [0 1 0]; 

        elseif strcmp(channelWanted, 'RXD3') % LONG-PASS (380-560 nm)

            % Microscope filters
            filtersWanted1 = {'BA420-460'};
            filterEmission = getDataMatrix(filters.emissionFilter, wavelength, filtersWanted1, 'filter', [], normalizeOn);
            
                % no filter
                filtersWanted1 = {'no filter'};
                filterEmission.data = ones(length(wavelength), 1);

            filtersWanted2 = {'DM570'};
            filterDichroic = getDataMatrix(filters.emissionDichroic, wavelength, filtersWanted2, 'filter', [], normalizeOn);

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
            filtersWanted1 = {'BA570-625HQ'};
            filterEmission = getDataMatrix(filters.emissionFilter, wavelength, filtersWanted1, 'filter', [], normalizeOn);

            filtersWanted2 = {'DM570'};
            filterDichroic = getDataMatrix(filters.emissionDichroic, wavelength, filtersWanted2, 'filter', [], normalizeOn)

            % Get this later clarified
            PMTWanted = {'PMT Ga-As-P'};
            PMT = getDataMatrix(PMTs, wavelength, PMTWanted, 'PMT', [], normalizeOn);

            % color (that matches the color of the sensitivity)        
            plotColor = [1 0 0]; 

        else
            error(['You wanted the channel "', channelWanted, '", which is not a valid channel'])
        end

    %% FINAL OUTPUT
    
        % now just multiply the components, add "ones"-vectors if only channel
        % have something weird happening, e.g.   
        channelVector = filterEmission.data .* filterDichroic.data .* PMT.data;
    
    %% Debug plot
    
        debugPlot = false;
        if debugPlot
            
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

                legStr = {['emission (', cell2mat(filtersWanted1), ')'];...
                          ['dichroic (', cell2mat(filtersWanted2), ')'];...
                          ['PMT (', cell2mat(PMTWanted), ')'];...
                          ['Channel Out (', channelWanted, ')']};

                leg(ch) = legend(legStr, 'FontSize', 8, 'Location', 'best');
                    legend('boxoff')
                    
                tit(ch) = title(channelWanted);
                
                set(p(ch,end), 'Color', plotColor)
                set(sp(ch), 'XLim', [400 700])
                
        end
        
        
    
    

        