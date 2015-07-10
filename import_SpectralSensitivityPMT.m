function PMTs = import_SpectralSensitivityPMT(wavelength)

    % for PMT spectral sensitivities, see e.g.
    % http://www.olympusmicro.com/primer/techniques/confocal/detectorsintro.html
    
    % add actual sensitivities later, dummy init
    
    % PMT Ga-As-P (UV-Visible Range)
    ind = 1;
    PMTs{ind}.wavelength = wavelength;
    PMTs{ind}.sensitivity = ones(length(wavelength), 1);
    PMTs{ind}.name = 'PMT Ga-As-P';
    PMTs{ind}.plotColor = [0.4 0.4 0];
    
    % PMT Ga-As (UV-Visible-NIR Range)
    ind = ind+1;
    PMTs{ind}.wavelength = wavelength;
    PMTs{ind}.sensitivity = ones(length(wavelength), 1);
    PMTs{ind}.name = 'PMT Ga-As';
    PMTs{ind}.plotColor = [0 0 0];