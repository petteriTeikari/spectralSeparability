function structureOut = import_truncateInput(structureIn, wavelength, yField)

    % get limits of all the various wavelengths
    for ind = 1 : length(structureIn)
        minValues(ind) = min(structureIn{ind}.wavelength);
        maxValues(ind) = max(structureIn{ind}.wavelength); 
    end

    inputWavelengthRange = [min(minValues) max(maxValues)];
    wavelengthOut = wavelength;
    % TODO: check whether these match at some point

    structureOut = structureIn;
    for ind = 1 : length(structureIn)

        x = structureIn{ind}.wavelength;            
        y = structureIn{ind}.(yField);

        % Interpolate            
        structureOut{ind}.(yField) = interp1(x, y, wavelengthOut);

        % re-assign wavelength
        structureOut{ind}.wavelength = wavelengthOut;
        structureOut{ind}.wavelengthRes = structureIn{ind}.wavelength(2) - structureIn{ind}.wavelength(1);
        % fluoro{ind}

    end