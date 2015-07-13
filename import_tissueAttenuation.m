function tissueAttenuation = import_tissueAttenuation(wavelength)

    % import attenuation for typical absorbers in your target tissue (i.e.
    % mouse/rat brain tissue)
    
    % see e.g. Fig 1 of Horton et al. (2013)
    % http://dx.doi.org/10.1038/nphoton.2012.336
    
    % Fig 4 of Doane and Burda (2012)
    % http://dx.doi.org/10.1039/C2CS15260F
    % taken from: Weissleder (2001), http://dx.doi.org/10.1038/86684
    
    tissueAttenuation = [];