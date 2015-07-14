function PMTs = import_SpectralSensitivityPMT(wavelength)

    % for PMT spectral sensitivities, see e.g.
    % http://www.olympusmicro.com/primer/techniques/confocal/detectorsintro.html
    
    % add actual sensitivities later, dummy init
    
    % PMT Ga-As-P (UV-Visible Range)
    ind = 1;
    tmpData = importdata(fullfile('data','pmt_Sensitivities_x300-680nm_Ga-As.txt'), ',', 1);
    PMTs{ind}.wavelength = tmpData.data(:,1);
    PMTs{ind}.sensitivity = tmpData.data(:,2);
    PMTs{ind}.name = 'PMT Ga-As-P';
    PMTs{ind}.plotColor = [0.4 0.4 0];
    
    % PMT Ga-As (UV-Visible-NIR Range)
    ind = ind+1;
    tmpData = importdata(fullfile('data','pmt_Sensitivities_x300_840nm_Ga-As-P.txt'), ',', 1);
    PMTs{ind}.wavelength = tmpData.data(:,1);
    PMTs{ind}.sensitivity = tmpData.data(:,2);
    PMTs{ind}.name = 'PMT Ga-As';
    PMTs{ind}.plotColor = [0 0 0];