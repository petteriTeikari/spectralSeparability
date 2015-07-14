function plotXijkSpectra(fig, scrsz, wavelength, excitationMatrix, fluoroEmissionMatrix, fluoroExcitationMatrix, channelMatrix, Xijk, Eijk, options)

    set(fig,  'Position', [0.4*scrsz(3) 0.25*scrsz(4) 0.60*scrsz(3) 0.60*scrsz(4)])

    rows = size(Xijk.matrix,1); 
    cols = size(Xijk.matrix,2); 
    
    for j = 1 : size(Xijk.matrix,1); % number of fluorophores        
        for k = 1 : size(Xijk.matrix,2); % number of channels
            
            ind = k + (j-1)*cols
            sp(j,k) = subplot(rows,cols,ind);
                % plot(wavelength,
            
        end        
    end