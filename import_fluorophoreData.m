function fluoro = import_fluorophoreData()

    %% FLUORESCENT MARKERS

        % OGB
        % https://www.lifetechnologies.com/order/catalog/product/O6807
        ind = 1;
        tmpOGB = importdata(fullfile('data','OregonGreen488_BAPTA.csv'), ',', 1);
            fluoro{ind}.wavelength = tmpOGB.data(:,1);
            fluoro{ind}.wavelengthRes = fluoro{1}.wavelength(2) - fluoro{1}.wavelength(1);
            fluoro{ind}.excitation = tmpOGB.data(:,2);
            fluoro{ind}.emission = tmpOGB.data(:,3);
            fluoro{ind}.name = 'OGB-1 488';
            fluoro{ind}.plotColor = [0 1 0];

        % Texas Red
        % http://www.lifetechnologies.com/ca/en/home/life-science/cell-analysis/fluorophores/texas-red.html
        ind = ind + 1;
        tmpTexasRed = importdata(fullfile('data','TexasRed.csv'), ',', 1);
            fluoro{ind}.wavelength = tmpTexasRed.data(:,1);
            fluoro{ind}.wavelengthRes = fluoro{1}.wavelength(2) - fluoro{1}.wavelength(1);
            fluoro{ind}.excitation = tmpTexasRed.data(:,2);
            fluoro{ind}.emission = tmpTexasRed.data(:,3);
            fluoro{ind}.name = 'Texas Red';
            fluoro{ind}.plotColor = [1 0 0];
            
        % SR-101
        % http://omlc.org/spectra/PhotochemCAD/html/012.html
        ind = ind + 1;
        tmpSR101abs = importdata(fullfile('data','SR101_012-abs.txt'), '\t', 23);
        tmpSR101ems = importdata(fullfile('data','SR101_012-ems.txt'), '\t', 23);

            % combine the wavelength vectors (use resolution of OGB)       
            wavelengthIndexToUse = 1;
            fluoro{ind}.wavelength = (ceil(min(tmpSR101abs.data(:,1))) ...
                        : fluoro{wavelengthIndexToUse}.wavelengthRes : ....
                        floor(max(tmpSR101ems.data(:,1))))';
            fluoro{ind}.wavelengthRes = fluoro{2}.wavelength(2) - fluoro{2}.wavelength(1);

            % Interpolate
            fluoro{ind}.excitation = interp1(tmpSR101abs.data(:,1), tmpSR101abs.data(:,2), fluoro{ind}.wavelength);
            fluoro{ind}.emission = interp1(tmpSR101ems.data(:,1), tmpSR101ems.data(:,2), fluoro{ind}.wavelength); 
            fluoro{ind}.name = 'SR-101';
            fluoro{ind}.plotColor = [0.5 0.1 0.15];
           
            

    %% AUTOFLUORESCENCE
    
        % How much spectral cross-talk from autofluorescence?
    
        % Astroglial autofluorescence, e.g. Fig. 2 of Oheim et al. (2014)
        % http://dx.doi.org/10.1016/j.bbamcr.2014.03.010
        
        % NADH
        
        % Baraghis E, Devor A, Fang Q, Srinivasan VJ, Wu W, Lesage F, Ayata C, Kasischke KA, Boas DA, Sakadžić S. 2011. 
        % Two-photon microscopy of cortical NADH fluorescence intensity changes: correcting contamination from the hemodynamic response. 
        % J. Biomed. Opt 16:106003–106003–13. 
        % http://dx.doi.org/10.1117/1.3633339.
        
        % Pu Y, Sordillo LA, Alfano RR. 2015. 
        % Nonnegative constraint analysis of key fluorophores within human breast cancer using 
        % native fluorescence spectroscopy excited by selective wavelength of 300 nm. 
        % In: Vol. 9318, p. 93180V–93180V–11. 
        % http://dx.doi.org/10.1117/12.2076102.

        
    %% FINALLY, truncate the wavelength vectors to be the same
    
        % get limits of all the fluorophores defined
        for ind = 1 : length(fluoro)
            minValues(ind) = min(fluoro{ind}.wavelength);
            maxValues(ind) = max(fluoro{ind}.wavelength); 
        end
        
        wavelengthRes = 1; % [nm]
        wavelengthOut = ( min(minValues) : wavelengthRes : max(maxValues) )';
    
        for ind = 1 : length(fluoro)

            % Interpolate
            fluoro{ind}.excitation = interp1(fluoro{ind}.wavelength, fluoro{ind}.excitation, wavelengthOut);
            fluoro{ind}.emission = interp1(fluoro{ind}.wavelength, fluoro{ind}.emission, wavelengthOut); 
            
            % re-assign wavelength
            fluoro{ind}.wavelength = wavelengthOut;
            fluoro{ind}.wavelengthRes = fluoro{ind}.wavelength(2) - fluoro{ind}.wavelength(1);
            % fluoro{ind}
            
        end
        
        