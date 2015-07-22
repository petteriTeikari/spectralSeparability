function optim_parameters = optimize_initParameters()

    % Tunable laser
    optim_parameters.laser.range = [720 950];
    optim_parameters.laser.init = 760;

    % "short wavelength", by default at 485 or at 505 nm
    optim_parameters.DM1.range = [445 505];
    optim_parameters.DM1.init = 485;
    % "long wavelength", by default at 570 nm
    optim_parameters.DM2.range = [570 630];
    optim_parameters.DM2.init = 570;

    % Barrier filter
    optim_parameters.BF.range = [560 560];
    optim_parameters.BF.init = 560;

    % RXD1 - emission (center wavelength, fixed width)
    optim_parameters.RXD1emission.range = [400 460]; % for center
    optim_parameters.RXD1emission.init = 455; 
    % RXD2 - emission (center wavelength, fixed width)
    optim_parameters.RXD2emission.range = [460 560];
    optim_parameters.RXD2emission.init = 465;
    % RXD3 - emission (center wavelength, fixed width)
    optim_parameters.RXD3emission.range = [560 650];
    optim_parameters.RXD3emission.init = 600;
    % RXD4 - emission (center wavelength, fixed width)
    optim_parameters.RXD4emission.range = [620 720];
    optim_parameters.RXD4emission.init = 600;
        