 function dataOut = getDataMatrix(data, wavelength, dataWanted, dataType, yType, normalizeOn)
 
    % dataWanted
 
    if strcmp(dataType, 'fluoro')
        
        if strcmp(yType, 'emission')
            yFieldName = 'emission';
            normalizeOnForThisData = normalizeOn.(yFieldName);
        elseif strcmp(yType, 'excitation')
            yFieldName = 'excitation';
            normalizeOnForThisData = normalizeOn.(yFieldName);
        else
            disp(['yFieldName = ', yFieldname])
            error('What yType you want, emission/excitation?')
        end
        
    elseif strcmp(dataType, 'filter')
        yFieldName = 'transmittance';
        
        normalizeOnForThisData = normalizeOn.(dataType);
       
    
    elseif strcmp(dataType, 'light')
        yFieldName = 'irradiance';
        
        normalizeOnForThisData = normalizeOn.(dataType);
        
    elseif strcmp(dataType, 'PMT')
        yFieldName = 'sensitivity';
        
        normalizeOnForThisData = normalizeOn.(dataType);
        
    else
        disp(['dataType = ', dataType])
        error('What dataType you want, fluoro/filter/light?')
    end

    for i = 1 : length(data)
        % data{i}
        names{i,1} = data{i}.name; % might be unnecessary
        dataIn{i} = data{i}.(yFieldName);
        wavelengthIn{i} = data{i}.wavelength;
    end

    for j = 1 : length(dataWanted)
        try
            ind(j) = find(ismember(names, dataWanted{j}));
        catch err
            
            % special occasion when you want a synthetic dichroic mirror
            if ~isempty(strfind(dataWanted{j}, 'synthDM'))
                
                % parse input string
                fields = textscan(dataWanted{j}, '%s%s', 'Delimiter', '_');
                cutLambda = str2double(fields{2});                
                transmittance = import_syntheticDichroicMirror(wavelength, cutLambda);
                dataIn{i} = transmittance;
                wavelengthIn{i} = wavelength;       
                ind = i; % quick fix, previous lines overwrite the input data
                
            else
                disp(names)
                error(['You wanted "', num2str(dataWanted{j}), '" but it was not defined. These were found:'])            
            end
        end
    end
    
    % remove the not-found indices
    % ind = logical(ind);
    % dataWanted
    % ind
    ind = ind(ind ~= 0);

    % truncate the fluorophore matrix (if needed), a bit of a hassle
    % but maybe better to keep it like this and not throw away the
    % "excess" wavelengths from the start (on disk) if they are later 
    % needed for something
    wavelengthRes = 1; % 1 nm
    wavelength_new = (min(wavelength) : wavelengthRes : max(wavelength))';

        dataNew = zeros(length(wavelength), length(dataIn));
        for ji = 1 : length(dataIn) % how many fluorophores e.g.
            % easier variable names for debugging (the changes in import_
            % functions often propagate here apparently)
            x = wavelengthIn{ji};
            y = dataIn{ji};
            % whos
            dataNew(:,ji) = interp1(x, y, wavelength_new);
        end

    % get only the wanted fluorophores from the truncated matrix
    matrixOut = zeros(length(wavelength), length(ind)); % preallocate
    
    for k = 1 : length(ind)
        matrixOut(:,k) = dataNew(:,ind(k));
        dataOut.plotColor(k,:) = data{ind(k)}.plotColor;
        dataOut.name{k} = data{ind(k)}.name;
        
        if normalizeOnForThisData
            matrixOut(:,k) = matrixOut(:,k) / max(matrixOut(:,k));
        end
    end
    
    % output the actual data as well    
    dataOut.data = matrixOut;
      
  
            
   