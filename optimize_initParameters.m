function optim_parameters = optimize_initParameters()

    % Tunable laser
    optim_parameters.laser.range = [860 860];
    optim_parameters.laser.init = 860;

    % "short wavelength", by default at 485 or at 505 nm
    optim_parameters.DM1.range = [540 600];
    optim_parameters.DM1.init = 570;
    % "long wavelength", by default at 570 nm
    optim_parameters.DM2.range = [700 780];
    optim_parameters.DM2.init = 750;

    % Barrier filter
    optim_parameters.BF.range = [550 650];
    optim_parameters.BF.init = 630;

    % RXD1 - emission (center wavelength, fixed width)
    optim_parameters.RXD1emission.range = [490 560]; % for center
    optim_parameters.RXD1emission.init = 530; 
    % RXD2 - emission (center wavelength, fixed width)
    optim_parameters.RXD2emission.range = [550 610];
    optim_parameters.RXD2emission.init = 600;
    % RXD3 - emission (center wavelength, fixed width)
    optim_parameters.RXD3emission.range = [630 750];
    optim_parameters.RXD3emission.init = 700;
    % RXD4 - emission (center wavelength, fixed width)
    optim_parameters.RXD4emission.range = [720 800];
    optim_parameters.RXD4emission.init = 800;
        