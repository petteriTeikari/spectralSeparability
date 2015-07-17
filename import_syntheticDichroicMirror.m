function transmittance = import_syntheticDichroicMirror(wavelength, cutLambda)

    % see "tools/parametrizeDichroicMirror.m" for hwo to get the slope
    slope = 242;
    
    % normalized range
    min = 0;
    max = 1;
    
    % sigmoid
    transmittance = (max + ((min-max) ./ ( 1 + ((wavelength/cutLambda).^slope))));