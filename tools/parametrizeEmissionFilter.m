function parametrizeEmissionFilter()

    %% data

        path = fullfile('..', 'data');
        file{1} = 'fv1000mpe_olympus_dm485_0-100%transmittance_400-700nm_BA420-460_interpData.txt';
        file{2} = 'fv1000mpe_olympus_dm485_0-100%transmittance_400-700nm_BA495-540HQ_interpData.txt';
        file{3} = 'fv1000mpe_olympus_dm505_0-100%transmittance_400-700nm_BA460-510_interpData.txt';
        file{4} = 'fv1000mpe_olympus_dm505_0-100%transmittance_400-700nm_BA515-560_interpData.txt';
        file{5} = 'fv1000mpe_olympus_dm570_0-100%transmittance_400-700nm_BA570-625HQ_interpData.txt';        
        % file{4} = 'T635lpxr_Chroma_5050-ascii.txt';
    
    %% import
    
        for i = 1 : length(file)
            
            tmp = importdata(fullfile(path, file{i}), '\t', 1);
            wavelength = tmp.data(:,1);
            transmittance(:,i) = tmp.data(:,2);

            % normalize
            transmittanceNorm(:,i) = transmittance(:,i) / max(transmittance(:,i));

            % binarize
            transmittanceNorm(isnan(transmittanceNorm(:,i)),i) = 0;
            transLogical(:,i) = transmittanceNorm(:,i);
            threshold = 0.6;
            transLogical((transLogical(:,i) < threshold),i) = 0;
            transLogical((transLogical(:,i) >= threshold),i) = 1;
            indOne = find(transLogical(:,i) == 1);
            indCenter = round(median(indOne));
            centerLambda(i) = wavelength(indCenter)
            peakWidth(i) = wavelength(max(indOne)) - wavelength(min(indOne))
            
                                        
        end
        
        subplot(1,2,1)
            plot(wavelength, transmittanceNorm); title('Norm')
        subplot(1,2,2)
            plot(wavelength, transLogical); title('Norm')