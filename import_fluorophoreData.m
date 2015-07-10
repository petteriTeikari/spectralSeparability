function [fluoro, fluoro2PM] = import_fluorophoreData(wavelength)

    % TODO: repetition of the same, replace it with a function
    % at some point.
    
    % TODO: default interpolation method now, which does not matter that
    % match as we densely sampled spectral data, check again if you start
    % getting 10nm spaced data or even more sparse.

    %% FLUORESCENT MARKERS (Single-photon Excitation)

        % OGB
        % https://www.lifetechnologies.com/order/catalog/product/O6807
        ind = 1;
        tmpData = importdata(fullfile('data','OregonGreen488_BAPTA.csv'), ',', 1);
            fluoro{ind}.wavelength = tmpData.data(:,1);
            fluoro{ind}.wavelengthRes = fluoro{ind}.wavelength(2) - fluoro{ind}.wavelength(1);
            fluoro{ind}.excitation = tmpData.data(:,2);
            fluoro{ind}.emission = tmpData.data(:,3);
            fluoro{ind}.name = 'OGB-1';
            fluoro{ind}.plotColor = [0 1 0];

        % Texas Red
        % http://www.lifetechnologies.com/ca/en/home/life-science/cell-analysis/fluorophores/texas-red.html
        ind = ind + 1;
        tmpData = importdata(fullfile('data','TexasRed.csv'), ',', 1);
            fluoro{ind}.wavelength = tmpData.data(:,1);
            fluoro{ind}.wavelengthRes = fluoro{ind}.wavelength(2) - fluoro{ind}.wavelength(1);
            fluoro{ind}.excitation = tmpData.data(:,2);
            fluoro{ind}.emission = tmpData.data(:,3);
            fluoro{ind}.name = 'Texas Red';
            fluoro{ind}.plotColor = [1 0 0];
            
        % FITC
        % https://www.lifetechnologies.com/ca/en/home/life-science/cell-analysis/fluorophores/fluorescein.html
        ind = ind + 1;
        tmpData = importdata(fullfile('data','Fluorescein(FITC).csv'), ',', 1);
            fluoro{ind}.wavelength = tmpData.data(:,1);
            fluoro{ind}.wavelengthRes = fluoro{ind}.wavelength(2) - fluoro{ind}.wavelength(1);
            fluoro{ind}.excitation = tmpData.data(:,2);
            fluoro{ind}.emission = tmpData.data(:,3);
            fluoro{ind}.name = 'FITC';
            fluoro{ind}.plotColor = [0 .6 .2];
            
        % SR-101
        % http://omlc.org/spectra/PhotochemCAD/html/012.html
        ind = ind + 1;
        tmpDataAbs = importdata(fullfile('data','SR101_012-abs.txt'), '\t', 23);
        tmpDataEms = importdata(fullfile('data','SR101_012-ems.txt'), '\t', 23);

            % Interpolate (as the wavelength vectors are different for
            % emission and excitation)
            fluoro{ind}.wavelength = wavelength;
            fluoro{ind}.excitation = interp1(tmpDataAbs.data(:,1), tmpDataAbs.data(:,2), wavelength);
            fluoro{ind}.emission = interp1(tmpDataEms.data(:,1), tmpDataEms.data(:,2), wavelength); 
            fluoro{ind}.name = 'SR-101';
            fluoro{ind}.plotColor = [0.5 0.1 0.15];
           
        % Doxyrubicin

            % Karukstis KK, Thompson EHZ, Whiles JA, Rosenfeld RJ. 1998. 
            % Deciphering the fluorescence signature of daunomycin and doxorubicin. Biophysical Chemistry 73:249–263. 
            % http://dx.doi.org/10.1016/S0301-4622(98)00150-1
        ind = ind + 1;
        tmpData = importdata(fullfile('data','karukstis1998_DOX_emission_inWater_500-750nm.txt'), ',', 1);
            fluoro{ind}.wavelength = tmpData.data(:,1);
            fluoro{ind}.wavelengthRes = fluoro{ind}.wavelength(2) - fluoro{ind}.wavelength(1);
            fluoro{ind}.emission = tmpData.data(:,2);
            fluoro{ind}.excitation = zeros(length(fluoro{ind}.emission),1); % no data atm
            fluoro{ind}.name = 'DOX';
            fluoro{ind}.plotColor = [0.6 0.35 0.15];
            
    %% FLUORESCENT MARKERS (Two-photon Excitation)
    
        % Harder to find tabulated version of these, so have to extract
        % graphically again 
        
            % Mütze J, Iyer V, Macklin JJ, Colonell J, Karsh B, Petrášek Z, Schwille P, Looger LL, Lavis LD, Harris TD. 2012. 
            % Excitation Spectra and Brightness Optimization of Two-Photon Excited Probes. 
            % Biophys J 102:934–944. 
            % http://dx.doi.org/10.1016/j.bpj.2011.12.056. 
        
        % Use now the same names as for the single-photon ones, so that we
        % can use the excitation spectrum from here, and emission spectrum
        % from the single-photon side
            
        % OGB-1 (Mütze et al., 2012)
        ind2PM = 1;
        tmp2PM = importdata(fullfile('data','mutze2012_OGB_dataPointsBetween720-1020.txt'), ',', 1);
            fluoro2PM{ind2PM}.wavelength = tmp2PM.data(:,1);
            fluoro2PM{ind2PM}.wavelengthRes = fluoro{ind2PM}.wavelength(2) - fluoro{ind2PM}.wavelength(1);
            fluoro2PM{ind2PM}.excitation = tmp2PM.data(:,2);
            fluoro2PM{ind2PM}.name = 'OGB-1';
            fluoro2PM = import_truncateInput(fluoro2PM, wavelength, 'excitation');
            
            % get the emission spectrum automagically from the
            % corresponding single-photon one
            ind_1PM = find(ismember(getNameList(fluoro), fluoro2PM{ind2PM}.name));
            if isempty(ind_1PM)
                warning(['no emission data found for fluorophore: "', fluoro2PM{ind2PM}.name, '", is that so or did you have a typo? Check implementation as well!'])
                fluoro2PM{ind2PM}.emission = [];
                fluoro2PM{ind2PM}.plotColor = [0 0 0];
                fluoro2PM{ind2PM}.wavelength = [];
            else
                fluoro2PM{ind2PM}.emission = fluoro{ind_1PM}.emission;
                fluoro2PM{ind2PM}.plotColor = fluoro{ind_1PM}.plotColor;
                fluoro2PM{ind2PM}.wavelength = fluoro{ind_1PM}.wavelength;
            end
            fluoro2PM = import_truncateInput(fluoro2PM, wavelength, 'emission');
            
        % SR-101 (Mütze et al., 2012)
        ind2PM = ind2PM + 1;
        tmp2PM = importdata(fullfile('data','mutze2012_SRh101_dataPointsBetween720-1060.txt'), ',', 1);
            
            fluoro2PM{ind2PM}.wavelength = tmp2PM.data(:,1);
            fluoro2PM{ind2PM}.wavelengthRes = fluoro{ind2PM}.wavelength(2) - fluoro{ind2PM}.wavelength(1);
            fluoro2PM{ind2PM}.excitation = tmp2PM.data(:,2);
            fluoro2PM{ind2PM}.name = 'SR-101';
            fluoro2PM = import_truncateInput(fluoro2PM, wavelength, 'excitation');
            
            % get the emission spectrum automagically from the
            % corresponding single-photon one
            ind_1PM = find(ismember(getNameList(fluoro), fluoro2PM{ind2PM}.name));
            if isempty(ind_1PM)
                warning(['no emission data found for fluorophore: "', fluoro2PM{ind2PM}.name, '", is that so or did you have a typo?'])
                error('Have to correct the code or add the emission data! this type of error not handled at the moment')
                fluoro2PM{ind2PM}.emission = [];
                fluoro2PM{ind2PM}.plotColor = [0 0 0];
                fluoro2PM{ind2PM}.wavelength = [];
            else
                fluoro2PM{ind2PM}.emission = fluoro{ind_1PM}.emission;
                fluoro2PM{ind2PM}.plotColor = fluoro{ind_1PM}.plotColor;
                fluoro2PM{ind2PM}.wavelength = fluoro{ind_1PM}.wavelength;
            end
            fluoro2PM = import_truncateInput(fluoro2PM, wavelength, 'emission');
            
        % FITC Green (Mütze et al., 2012)
        ind2PM = ind2PM + 1;
        tmp2PM = importdata(fullfile('data','mutze2012_FITCGreen__dataPointsBetween711-1037.txt'), ',', 1);
            
            fluoro2PM{ind2PM}.wavelength = tmp2PM.data(:,1);
            fluoro2PM{ind2PM}.wavelengthRes = fluoro{ind2PM}.wavelength(2) - fluoro{ind2PM}.wavelength(1);
            fluoro2PM{ind2PM}.excitation = tmp2PM.data(:,2);
            fluoro2PM{ind2PM}.name = 'FITC';
            fluoro2PM = import_truncateInput(fluoro2PM, wavelength, 'excitation');
            
            % get the emission spectrum automagically from the
            % corresponding single-photon one
            ind_1PM = find(ismember(getNameList(fluoro), fluoro2PM{ind2PM}.name));
            if isempty(ind_1PM)
                warning(['no emission data found for fluorophore: "', fluoro2PM{ind2PM}.name, '", is that so or did you have a typo?'])
                fluoro2PM{ind2PM}.emission = [];
                fluoro2PM{ind2PM}.plotColor = [0 0 0];
                fluoro2PM{ind2PM}.wavelength = [];
            else
                fluoro2PM{ind2PM}.emission = fluoro{ind_1PM}.emission;
                fluoro2PM{ind2PM}.plotColor = fluoro{ind_1PM}.plotColor;
                fluoro2PM{ind2PM}.wavelength = fluoro{ind_1PM}.wavelength;
            end
            fluoro2PM = import_truncateInput(fluoro2PM, wavelength, 'emission');
            

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
        
         % quickFix, as the wavelength is written over with the first pass
         % (excitation), and you cannot interpolate again different-sized x
         % and y vector, make it more elegant later
        for i = 1 : length(fluoro)
            wavelengthIn{i} = fluoro{i}.wavelength;
        end
    
        disp('1PM')
        fluoro = import_truncateInput(fluoro, wavelength, 'excitation');
        
        % quickFix
        for i = 1 : length(fluoro)
            fluoro{i}.wavelength = wavelengthIn{i};
        end
        
        fluoro = import_truncateInput(fluoro, wavelength, 'emission');
        
        % everything should be okay now, check later, this could be
        % redundant simply
        disp('2PM')
        fluoro2PM = import_truncateInput(fluoro2PM, wavelength, 'excitation');
        fluoro2PM = import_truncateInput(fluoro2PM, wavelength, 'emission');
    
    
        
        
        
        
        
        
        