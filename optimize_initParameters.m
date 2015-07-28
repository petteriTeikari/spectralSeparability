function optim_parameters = optimize_initParameters()

    % Tunable laser
    optim_parameters.laser.range = [720 950];
    optim_parameters.laser.init = 760;

    % "short wavelength", by default at 485 or at 505 nm
    optim_parameters.DM1.range = [485 485];
    optim_parameters.DM1.init = 485;
    % "long wavelength", by default at 570 nm
    optim_parameters.DM2.range = [NaN NaN];
    optim_parameters.DM2.init = NaN;

    % Barrier filter
    optim_parameters.BF.range = [560 560];
    optim_parameters.BF.init = 560;

    % RXD1 - emission (center wavelength, fixed width)
    optim_parameters.RXD1emission.range = [440 440]; % for center
    optim_parameters.RXD1emission.init = 440; 
    % RXD2 - emission (center wavelength, fixed width)
    optim_parameters.RXD2emission.range = [520 520];
    optim_parameters.RXD2emission.init = 520;
    % RXD3 - emission (center wavelength, fixed width)
    optim_parameters.RXD3emission.range = [600 600];
    optim_parameters.RXD3emission.init = 600;
    % RXD4 - emission (center wavelength, fixed width)
    optim_parameters.RXD4emission.range = [700 750];
    optim_parameters.RXD4emission.init = 700;
        