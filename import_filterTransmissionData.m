function filters = import_filterTransmissionData(wavelength)

    % extracted with Matlab "extractDataFromGraph" graphically from the plotted curves there:
    % https://pixel.univ-rennes1.fr/pdf/Light%20Pathway.pdf (pg. 3)
    % Transmission curves | OLYMPUS FV1000MPE
    % the grid was removed in GIMP with Dilate+Erode

    noOfHeaders = 1;
    delim = '\t'; % tab-delimited

    % DM485
    % FV10MP-MV/G

        i = 1;
        filters.emissionDichroic{i}.name = 'DM485';
            fileName = 'fv1000mpe_olympus_dm485_0-100%transmittance_400-700nm_DM_interpData.txt';
            tmp = importdata(fullfile('data',fileName), delim, noOfHeaders);
            filters.emissionDichroic{i}.wavelength = tmp.data(:,1);
            filters.emissionDichroic{i}.transmittance = tmp.data(:,2);
            filters.emissionDichroic{i}.plotColor = 'b';

        j = 1;
        filters.emissionFilter{j}.name = 'BA495-540HQ';
            fileName = 'fv1000mpe_olympus_dm485_0-100%transmittance_400-700nm_BA495-540HQ_interpData.txt';
            tmp = importdata(fullfile('data',fileName), delim, noOfHeaders);
            filters.emissionFilter{j}.wavelength = tmp.data(:,1);
            filters.emissionFilter{j}.transmittance = tmp.data(:,2);
            filters.emissionFilter{j}.plotColor = [0 1 1];

        j = j + 1;
        filters.emissionFilter{j}.name = 'BA420-460';
            fileName = 'fv1000mpe_olympus_dm485_0-100%transmittance_400-700nm_BA420-460_interpData.txt';
            tmp = importdata(fullfile('data',fileName), delim, noOfHeaders);
            filters.emissionFilter{j}.wavelength = tmp.data(:,1);
            filters.emissionFilter{j}.transmittance = tmp.data(:,2);
            filters.emissionFilter{j}.plotColor = [0.75 0 0.75];


    % DM505
    % FV10MP-MC/Y

        i = i + 1;
        filters.emissionDichroic{i}.name = 'DM505';
            fileName = 'fv1000mpe_olympus_dm505_0-100%transmittance_400-700nm_DM_interpData.txt';
            tmp = importdata(fullfile('data',fileName), delim, noOfHeaders);
            filters.emissionDichroic{i}.wavelength = tmp.data(:,1);
            filters.emissionDichroic{i}.transmittance = tmp.data(:,2);
            filters.emissionDichroic{i}.plotColor = 'g';

        j = j + 1;
        filters.emissionFilter{j}.name = 'BA515-560';
            fileName = 'fv1000mpe_olympus_dm505_0-100%transmittance_400-700nm_BA515-560_interpData.txt';
            tmp = importdata(fullfile('data',fileName), delim, noOfHeaders);
            filters.emissionFilter{j}.wavelength = tmp.data(:,1);
            filters.emissionFilter{j}.transmittance = tmp.data(:,2);
            filters.emissionFilter{j}.plotColor = [0 1 0];

        j = j + 1;
        filters.emissionFilter{j}.name = 'BA460-510';
            fileName = 'fv1000mpe_olympus_dm505_0-100%transmittance_400-700nm_BA460-510_interpData.txt';
            tmp = importdata(fullfile('data',fileName), delim, noOfHeaders);
            filters.emissionFilter{j}.wavelength = tmp.data(:,1);
            filters.emissionFilter{j}.transmittance = tmp.data(:,2);
            filters.emissionFilter{j}.plotColor = [0 0 1];


    % DM570
    % FV10MP-MG/R

        i = i + 1;
        filters.emissionDichroic{i}.name = 'DM570';
            fileName = 'fv1000mpe_olympus_dm570_0-100%transmittance_400-700nm_DM_interpData.txt';
            tmp = importdata(fullfile('data',fileName), delim, noOfHeaders);
            filters.emissionDichroic{i}.wavelength = tmp.data(:,1);
            filters.emissionDichroic{i}.transmittance = tmp.data(:,2);
            filters.emissionDichroic{i}.plotColor = 'r';

        j = j + 1;
        filters.emissionFilter{j}.name = 'BA570-625HQ';
            % replicate plot of of "BA495-540HQ"
            fileName = 'fv1000mpe_olympus_dm570_0-100%transmittance_400-700nm_BA570-625HQ_interpData.txt';
            tmp = importdata(fullfile('data',fileName), delim, noOfHeaders);
            filters.emissionFilter{j}.wavelength = tmp.data(:,1);
            filters.emissionFilter{j}.transmittance = tmp.data(:,2);
            filters.emissionFilter{j}.plotColor = [1 0 0];


    % BARRIER FILTERS
    
        k = 1;
            filters.barrierDichroic{k}.name = 'SDM560';
            fileName = 'olympus_barrierFilters_SDM560.txt';
            tmp = importdata(fullfile('data',fileName), delim, noOfHeaders);
            filters.barrierDichroic{k}.wavelength = tmp.data(:,1);
            filters.barrierDichroic{k}.transmittance = tmp.data(:,2);
            filters.barrierDichroic{k}.plotColor = 'g';
        
        
        k = k + 1;
            filters.barrierDichroic{k}.name = 'SDM640';
            fileName = 'olympus_barrierFilters_SDM640.txt';
            tmp = importdata(fullfile('data',fileName), delim, noOfHeaders);
            filters.barrierDichroic{k}.wavelength = tmp.data(:,1);
            filters.barrierDichroic{k}.transmittance = tmp.data(:,2);
            filters.barrierDichroic{k}.plotColor = 'r';
           
    % 3rd Party Dichroic mirrors
    
        i = i + 1;
        filters.emissionDichroic{i}.name = 'T635lpxr';
        fileName = 'T635lpxr_Chroma_5050-ascii.txt';
        tmp = importdata(fullfile('data',fileName), delim, noOfHeaders);
            filters.emissionDichroic{i}.wavelength = tmp.data(:,1);
            filters.emissionDichroic{i}.transmittance = tmp.data(:,2);
            filters.emissionDichroic{i}.plotColor = 'r';

	i = i + 1;
        filters.emissionDichroic{i}.name = 'T470lpxr';
        fileName = 'T470lpxr_Chroma_5155-ascii.txt';
        tmp = importdata(fullfile('data',fileName), delim, noOfHeaders);
            filters.emissionDichroic{i}.wavelength = tmp.data(:,1);
            filters.emissionDichroic{i}.transmittance = tmp.data(:,2);
            filters.emissionDichroic{i}.plotColor = 'b';
            
    % 3rd Party emission filters
        
        j = j + 1;
        filters.emissionFilter{j}.name = 'ET700lp';        
            
            fileName = 'ET700lp_474107-ascii.csv';
            tmp = importdata(fullfile('data',fileName), ',', noOfHeaders);
            filters.emissionFilter{j}.wavelength = tmp.data(:,1);
            filters.emissionFilter{j}.transmittance = tmp.data(:,2);
            filters.emissionFilter{j}.plotColor = [.5 0 .25];
    
        j = j + 1;
        filters.emissionFilter{j}.name = 'ET655lp';        
            
            fileName = 'ET730-140m-2p.txt';
            tmp = importdata(fullfile('data',fileName), '\t', noOfHeaders);
            filters.emissionFilter{j}.wavelength = tmp.data(:,1);
            filters.emissionFilter{j}.transmittance = tmp.data(:,2);
            filters.emissionFilter{j}.plotColor = [.5 0 .25];

	j = j + 1;
        filters.emissionFilter{j}.name = 'ET440-40';        
            
            fileName = 'ET440-40m-2p.txt';
            tmp = importdata(fullfile('data',fileName), '\t', noOfHeaders);
            filters.emissionFilter{j}.wavelength = tmp.data(:,1);
            filters.emissionFilter{j}.transmittance = tmp.data(:,2);
            filters.emissionFilter{j}.plotColor = [0 0 1]; % TODO, refine colors

	j = j + 1;
        filters.emissionFilter{j}.name = 'ET525-50';        
            
            fileName = 'ET525-50m-2p.txt';
            tmp = importdata(fullfile('data',fileName), '\t', noOfHeaders);
            filters.emissionFilter{j}.wavelength = tmp.data(:,1);
            filters.emissionFilter{j}.transmittance = tmp.data(:,2);
            filters.emissionFilter{j}.plotColor = [0 1 0]; % TODO, refine colors

	j = j + 1;
        filters.emissionFilter{j}.name = 'ET595-50';        
            
            fileName = 'ET595-50m-2p.txt';
            tmp = importdata(fullfile('data',fileName), '\t', noOfHeaders);
            filters.emissionFilter{j}.wavelength = tmp.data(:,1);
            filters.emissionFilter{j}.transmittance = tmp.data(:,2);
            filters.emissionFilter{j}.plotColor = [1 0 0]; % TODO, refine colors
            
    % Now the values can be in percent, easier to scale to 0:1 for
    % following computations
    for i = 1 : length(filters.emissionDichroic)
        filters.emissionDichroic{i}.transmittance = filters.emissionDichroic{i}.transmittance / ...
            max(filters.emissionDichroic{i}.transmittance);
    end

    for j = 1 : length(filters.emissionFilter)
        filters.emissionFilter{j}.transmittance = filters.emissionFilter{j}.transmittance / ...
            max(filters.emissionFilter{j}.transmittance);
    end
    
    % truncate
    filters.emissionFilter = import_truncateInput(filters.emissionFilter, wavelength, 'transmittance');
    filters.emissionDichroic = import_truncateInput(filters.emissionDichroic, wavelength, 'transmittance');
