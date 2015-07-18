function transmittance = import_syntheticEmissionFilter(wavelength, centerLambda, widthNm)

    transmittance = zeros(length(wavelength),1);
    
    % get indices for pass-band
    minInd = find(wavelength == floor(centerLambda - widthNm/2));
    maxInd = find(wavelength == ceil(centerLambda + widthNm/2));
    
    % set them to one
    transmittance(minInd:maxInd) = 1;
    
    % smooth a bit to round the edges
    transmittance = smooth(wavelength, transmittance, 0.02, 'lowess');