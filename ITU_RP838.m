function output = ITU_RP838(frecuency,elevation,polarization,Intensity)
% Necessary TOOLBOXES: NO
%% Author: Andres Cornejo, UNIVERSIDAD NACIONAL AUTONOMA DE MEXICO
% Copyright ©2020
%% ***************************** INPUTS ***********************************
% f -> Link Frecuency
% theta -> Elevation angle of the path
% polarizacion -> Circular
% Rp -> Rain exceeded, R0.01, 0.01%
%**************************************************************************
f = frecuency;
theta = elevation;
Rp = Intensity;
%% ************************* COEFFICIENTS KH ******************************
mk = -0.18961;
ck = 0.71147;

A_abc = [[-5.33980, -0.10008, 1.13098];[-0.35351, 1.26970, 0.45400];...
    [-0.23789, 0.86036, 0.15354];[-0.94158, 0.64552, 0.16817]];

log10_k = 0;

for j=1:1:4
    aj = A_abc(j,1);
    bj = A_abc(j,2);
    cj = A_abc(j,3);
    log10_k = aj*exp(-(((log10(f)-bj)/cj)^2))+log10_k;
end
log10_k = mk*log10(f)+ck+log10_k;
KH = 10^(log10_k/1);
% *************************************************************************

%% ************************* COEFFICIENTS aH ******************************
ma = 0.67849;
ca = -1.95537;

A_abc = [[-0.14318, 1.82442, -0.55187];[0.29591, 0.77564, 0.19822];...
    [0.32177, 0.63773, 0.13164];[-5.37610, -0.96230, 1.47828]...
    ;[16.1721, -3.29980, 3.43990]];

aH = 0;

for j=1:1:5
    aj = A_abc(j,1);
    bj = A_abc(j,2);
    cj = A_abc(j,3);
    aH = aj*exp(-(((log10(f)-bj)/cj)^2))+aH;
end
aH = ma*log10(f)+ca + aH;
% *************************************************************************

%% ************************* COEFFICIENTS KV ******************************
mk = -0.16398;
ck = 0.63297;

A_abc = [[-3.80595, 0.56934, 0.81061];[-3.44965, -0.22911, 0.51059];...
    [-0.39902, 0.73042, 0.11899];[0.50167, 1.07319, 0.27195]];

log10_k = 0;

for j=1:1:4
    aj = A_abc(j,1);
    bj = A_abc(j,2);
    cj = A_abc(j,3);
    log10_k = aj*exp(-(((log10(f)-bj)/cj)^2))+log10_k;
end
log10_k = mk*log10(f)+ck+log10_k;
KV = 10^(log10_k);
% *************************************************************************

%% ************************* COEFFICIENTS aV ******************************
ma = -0.053739;
ca = 0.83433;

A_abc = [[-0.07771, 2.33840, -0.76284];[0.56727, 0.95545, 0.54039];...
    [-0.20238, 1.14520, 0.26809];[-48.2991, 0.791669, 0.116226]...
    ;[48.5833, 0.791459, 0.116479]];

aV = 0;

for j=1:1:5
    aj = A_abc(j,1);
    bj = A_abc(j,2);
    cj = A_abc(j,3);
    aV = aj*exp(-(((log10(f)-bj)/cj)^2))+aV;
end
aV = ma*log10(f)+ca + aV;
% *************************************************************************

%% ********************** COEFFICIENTS TOTALES ****************************
switch polarization 
    case 'circular'
        k = (KH+KV+(KH-KV)*(cos(theta*pi/180)^2)*cos(2*45*pi/180))/2;
        a = (KH*aH+KV*aV+(KH*aH+KV*aV)*(cos(theta*pi/180)^2)*cos(2*45*pi/180))/(2*k);
    otherwise
        error('Polarization does not exist');
end
% *************************************************************************

%% ********************* SPECIFIC ATTENUATION YR **************************
YR = k*(Rp^a);  %Specific Attenuation [dB/km]
output = YR;
% *************************************************************************

end