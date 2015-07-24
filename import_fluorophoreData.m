function [fluoro, fluoro2PM] = import_fluorophoreData(wavelength)

    % TODO: repetition of the same, replace it with a function
    % at some point.
    
        % e.g.
        % columnHeaders = {'wavelength'; 'excitation'; 'emission'};
        % fluoro{ind}.(columnHeaders{1}) = tmpData.data(:,1);
        % fluoro{ind} = import_1PM_fluor(filePath, delimiterIn, noOfHeaderRows, columnHeaders)
    
    % TODO: default interpolation method now, which does not matter that
    % match as we densely sampled spectral data, check again if you start
    % getting 10nm spaced data or even more sparse.
    
    % TODO: Is there a database for all the fluorophores so you could at
    % least retrieve the 1-PM emission/excitation spectra automagically
    
    % TODO: Now the 2-PM excitation spectra have different units (GM or
    % kcps), add a warning about it. They are correlated (according to
    % Mütze et al. 2012, ) 

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
           
        % SR-101 (Chroma)
        % https://www.chroma.com/products/parts/t610lpxr?fluorochromes=10488,10411
        ind = ind + 1;
        tmpData = importdata(fullfile('data','SR101.csv'), ',', 1);
            fluoro{ind}.wavelength = tmpData.data(:,1);
            fluoro{ind}.wavelengthRes = fluoro{ind}.wavelength(2) - fluoro{ind}.wavelength(1);
            fluoro{ind}.excitation = tmpData.data(:,2);
            fluoro{ind}.emission = tmpData.data(:,3);
            fluoro{ind}.name = 'SR-101';
            fluoro{ind}.plotColor = [1 0.1 0.15];
            
        % Red alternative for SR-101
        
            % Kim D, Moon H, Baik SH, Singha S, Jun YW, Wang T, Kim KH, Park BS, Jung J, Mook-Jung I, Ahn KH. 2015. 
            % Two-Photon Absorbing Dyes with Minimal Autofluorescence in Tissue Imaging: Application to in Vivo Imaging of Amyloid-β Plaques with a Negligible Background Signal. 
            % J. Am. Chem. Soc. 137:6781–6789. 
            % http://dx.doi.org/10.1021/jacs.5b03548.

            
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
            fluoro{ind}.plotColor = [0.6 0.35 0.85];
            
        % Qtracker® vascular labels with NIR emission
        % http://www.lifetechnologies.com/ca/en/home/life-science/cell-analysis/cellular-imaging/small-animal-in-vivo-imaging-saivi/qdots-for-in-vivo-applications.html#invivo
        
        % BV421 (Brilliant Violet) offers a good green / violet ratio in 2PM (Fig 6H)
        
            % Chattopadhyay et al. 2012. 
            % Brilliant violet fluorophores: A new class of ultrabright fluorescent compounds for immunofluorescence experiments. 
            % Cytometry 81A:456–466. http://dx.doi.org/10.1002/cyto.a.22043.

            % http://www.biolegend.com/brilliantviolet
            ind = ind + 1;
            tmpData = importdata(fullfile('data','bv421_1nmRes_bioLegend.csv'), ',', 1);
            fluoro{ind}.wavelength = tmpData.data(:,1);
            fluoro{ind}.wavelengthRes = fluoro{ind}.wavelength(2) - fluoro{ind}.wavelength(1);            
            fluoro{ind}.excitation = tmpData.data(:,2);
            fluoro{ind}.emission = tmpData.data(:,3);
            fluoro{ind}.name = 'BV421';
            fluoro{ind}.plotColor = [1 0 1];
        
        % Indo-1 would be a blue Calcium indicator
                   

        % Alexa Fluor 633 (Chroma)
        % https://www.chroma.com/products/parts/t610lpxr?fluorochromes=10488,10411
        % ... or http://www.lifetechnologies.com/ca/en/home/brands/molecular-probes/key-molecular-probes-products/alexa-fluor/alexa-fluor-products.html
        
            % (Alexa Fluor 633) selectively labels neocortical arteries and arterioles by binding to elastin fibers. 
            % We measured sensory stimulus–evoked arteriole dilation dynamics in mouse, rat and cat visual cortex using 
            % Alexa Fluor 633 together with neuronal activity using calcium indicators or blood flow using fluorescein dextran.
            
            % Shen Z, Lu Z, Chhatbar PY, O’Herron P, Kara P. 2012. 
            % An artery-specific fluorescent dye for studying neurovascular coupling. 
            % Nat Methods 9:273–276. http://dx.doi.org/10.1038/nmeth.1857.
        
            ind = ind + 1;
            tmpData = importdata(fullfile('data','AlexaFluor633.csv'), ',', 1);
            fluoro{ind}.wavelength = tmpData.data(:,1);
            fluoro{ind}.wavelengthRes = fluoro{ind}.wavelength(2) - fluoro{ind}.wavelength(1);            
            fluoro{ind}.excitation = tmpData.data(:,2);
            fluoro{ind}.emission = tmpData.data(:,3);
            fluoro{ind}.name = 'AlexaFluor633';
            fluoro{ind}.plotColor = [1 0 0];
            
        % Methoxy-X04
        % Heo CH, Kim KH, Kim HJ, Baik SH, Song H, Kim YS, Lee J, Mook-jung I, Kim HM. 2013. 
        % A two-photon fluorescent probe for amyloid-β plaques in living mice. Chem. Commun. 49:1303–1305. 
        % http://dx.doi.org/10.1039/C2CC38570H.
        
            ind = ind + 1;
            tmpData = importdata(fullfile('data','methoxyX04_1PM_Heo2013_inH20.csv'), ',', 1);
            fluoro{ind}.wavelength = tmpData.data(:,1);
            fluoro{ind}.wavelengthRes = fluoro{ind}.wavelength(2) - fluoro{ind}.wavelength(1);            
            fluoro{ind}.excitation = tmpData.data(:,2);
            fluoro{ind}.emission = tmpData.data(:,3);
            fluoro{ind}.name = 'Methoxy-X04';
            fluoro{ind}.plotColor = [0 0 1];

        % di-8-ANEPPS, voltage-sensitive dye (VSD)
        % https://www.lifetechnologies.com/order/catalog/product/D3167
        
            % see e.g.
            % Pucihar G, Kotnik T, Miklavčič D. 2009. 
            % Measuring the Induced Membrane Voltage with Di-8-ANEPPS. J Vis Exp. 
            % http://dx.doi.org/10.3791/1659.
            
            % Grandy TH, Greenfield SA, Devonshire IM. 2012. 
            % An evaluation of in vivo voltage-sensitive dyes: 
            % pharmacological side effects and signal-to-noise ratios after effective 
            % removal of brain-pulsation artifacts. 
            % Journal of Neurophysiology 108:2931–2945. 
            % http://dx.doi.org/10.1152/jn.00512.2011.
            
            ind = ind + 1;
            tmpData = importdata(fullfile('data','Di-4-ANEPPS.csv'), ',', 1);
            fluoro{ind}.wavelength = tmpData.data(:,1);
            fluoro{ind}.wavelengthRes = fluoro{ind}.wavelength(2) - fluoro{ind}.wavelength(1);            
            fluoro{ind}.excitation = tmpData.data(:,2);
            fluoro{ind}.emission = tmpData.data(:,3);
            fluoro{ind}.name = 'Di-4-ANEPPS';
            fluoro{ind}.plotColor = [.4 .2 .1];

            
            
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
        tmp2PM = importdata(fullfile('data','mutze2012_FITCGreen_dataPointsBetween711-1037.txt'), ',', 1);
            
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
            
        % Alexa Fluor 633 (Mütze et al., 2012)
        ind2PM = ind2PM + 1;
        tmp2PM = importdata(fullfile('data','mutze2012_alexaFluor633_720-1010nm.txt'), ',', 1);
            
            fluoro2PM{ind2PM}.wavelength = tmp2PM.data(:,1);
            fluoro2PM{ind2PM}.wavelengthRes = fluoro{ind2PM}.wavelength(2) - fluoro{ind2PM}.wavelength(1);
            fluoro2PM{ind2PM}.excitation = tmp2PM.data(:,2);
            fluoro2PM{ind2PM}.name = 'AlexaFluor633';
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
            
        % BV421 (Dummy)
        ind2PM = ind2PM + 1;
                fluoro2PM{ind2PM}.name = 'BV421';
                fluoro2PM{ind2PM}.wavelength = wavelength;
                fluoro2PM{ind2PM}.excitation = zeros(length(wavelength),1);
                fluoro2PM{ind2PM}.excitation(:) = NaN;     
                fluoro2PM = import_truncateInput(fluoro2PM, wavelength, 'excitation');
                
                ind_1PM = find(ismember(getNameList(fluoro), fluoro2PM{ind2PM}.name));                
                fluoro2PM{ind2PM}.wavelengthRes = fluoro{ind2PM}.wavelength(2) - fluoro{ind2PM}.wavelength(1);                          
                fluoro2PM{ind2PM}.emission = fluoro{ind_1PM}.emission;
                fluoro2PM{ind2PM}.plotColor = fluoro{ind_1PM}.plotColor;
                fluoro2PM{ind2PM}.wavelength = fluoro{ind_1PM}.wavelength;
                fluoro2PM = import_truncateInput(fluoro2PM, wavelength, 'emission');
                
            
        % DOX (Yuan et al. 2015)
        % http://dx.doi.org/10.1039/C4NR06420H
        ind2PM = ind2PM + 1;
        tmp2PM = importdata(fullfile('data','yuan2014_dox2PM_x500-950.txt'), ',', 1);
            
            fluoro2PM{ind2PM}.wavelength = tmp2PM.data(:,1);
            fluoro2PM{ind2PM}.wavelengthRes = fluoro{ind2PM}.wavelength(2) - fluoro{ind2PM}.wavelength(1);
            fluoro2PM{ind2PM}.excitation = tmp2PM.data(:,2);
            fluoro2PM{ind2PM}.name = 'DOX';
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
        
        % Methoxy-X04
        % Heo CH, Kim KH, Kim HJ, Baik SH, Song H, Kim YS, Lee J, Mook-jung I, Kim HM. 2013. 
        % A two-photon fluorescent probe for amyloid-β plaques in living mice. Chem. Commun. 49:1303–1305. 
        % http://dx.doi.org/10.1039/C2CC38570H.        
        ind2PM = ind2PM + 1;
        tmp2PM = importdata(fullfile('data','methoxy_2PMexcitation_Heo2013_extrapolated.csv'), ',', 1);
            
            fluoro2PM{ind2PM}.wavelength = tmp2PM.data(:,1);
            fluoro2PM{ind2PM}.wavelengthRes = fluoro{ind2PM}.wavelength(2) - fluoro{ind2PM}.wavelength(1);
            fluoro2PM{ind2PM}.excitation = tmp2PM.data(:,2);
            fluoro2PM{ind2PM}.name = 'Methoxy-X04';
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
        
        % di-8-ANEPPS, voltage-sensitive dye (VSD)
        
            % 2-PM excitation spectrum from:
            % Fisher JAN, Salzberg BM, Yodh AG. 2005. 
            % Near infrared two-photon excitation cross-sections of voltage-sensitive dyes. 
            % Journal of Neuroscience Methods 148:94–102. 
            % http://dx.doi.org/10.1016/j.jneumeth.2005.06.027.
            ind2PM = ind2PM + 1;
            tmp2PM = importdata(fullfile('data','fisher2005_di-8-ANEPPS_2PMexcitation.csv'), ',', 1);
            
            fluoro2PM{ind2PM}.wavelength = tmp2PM.data(:,1);
            fluoro2PM{ind2PM}.wavelengthRes = fluoro{ind2PM}.wavelength(2) - fluoro{ind2PM}.wavelength(1);
            fluoro2PM{ind2PM}.excitation = tmp2PM.data(:,2);
            fluoro2PM{ind2PM}.name = 'Di-4-ANEPPS';
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

        
      
    %% ERROR HANDLING
    
        % if your delimiter is incorrectly defined, you get
        % Attempt to reference field of non-structure array.
        % Error in import_fluorophoreData (line 301)
        %                fluoro2PM{ind2PM}.wavelength = tmp2PM.data(:,1);
            

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
    
        % disp('1PM')
        fluoro = import_truncateInput(fluoro, wavelength, 'excitation');
        
        % quickFix
        for i = 1 : length(fluoro)
            fluoro{i}.wavelength = wavelengthIn{i};
        end
        
        fluoro = import_truncateInput(fluoro, wavelength, 'emission');
        
        % everything should be okay now, check later, this could be
        % redundant simply
        % disp('2PM')
        fluoro2PM = import_truncateInput(fluoro2PM, wavelength, 'excitation');
        fluoro2PM = import_truncateInput(fluoro2PM, wavelength, 'emission');
    
    
        
        
        
        
        
        
        