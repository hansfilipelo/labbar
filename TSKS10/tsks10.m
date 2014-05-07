%--------- Uppgift 1 ---------

% Run command manually before executing the following code!
%   open /path/to/signal-hanel742.wav
fs = 400000;
% Ta fram fouriertransform och spektra
fData= fft(data);
absF=abs(fData);
l=length(data);
f=[0:1:l-1]/fs;
plot(f,absF);

% Filtrering av f�rsta delen
[B,A] = butter(10,[0.2, 0.4],'bandpass');
filterData1 = filter(B,A,data);
figure(2);
plot(filterData1);

% Filtrering av andra delen
[B,A] = butter(10,[0.5, 0.65],'bandpass');
filterData2 = filter(B,A,data);
figure(3);
plot(filterData2);
 
% Filtrering av tredje delen
[B,A] = butter(10,[0.7, 0.8],'bandpass');
filterData3 = filter(B,A,data);
figure(4);
plot(filterData3);
 
% filterData3 -> bara vitt brus. 
% filterData1 inneh�ller rimligen information. 

% B�rfrekvensen f�r filterData1 �r: 
fc=57000;


%--------- Uppgift 2 ---------
 
%IQ demodulation, l�gpass   
Z = xcorr(filterData3,filterData3);
 
plot(Z);
 
% St�rsta toppen ges vid 7.8*10^6 ms
% sidotoppar vid 7,948*10^6 och 7,652*10^6
% (7,948-7,8)*10^6 = 148 000 samples
% 148 000 samples / 400 000 hz = 0,37 s


%--------- Uppgift 3 ---------
% Filtrerar bort eko
% Anv�nder f�rsta 148 000 samples f�r att ta bort ekot som kommer sen.
nrOfSamples = 148000;

filtered = zeros(size(filterData1));
filtered(1:nrOfSamples) = filterData1(1:nrOfSamples);

for i = 0 : 50

noEcho = filtered((1+nrOfSamples*i):(nrOfSamples + nrOfSamples*i));
echo = filterData1((nrOfSamples+1+nrOfSamples*i):(i+2)*nrOfSamples);

filtered((nrOfSamples+1+nrOfSamples*i):(i+2)*nrOfSamples) = echo - 0.9*noEcho;

end

%I/Q-demodulation
t=[0:1/fs:19.5-(1/fs)];
I=2*cos(2*pi*fc*t' + pi/2).*filtered;
Q=-2*sin(2*pi*fc*t' + pi/2).*filtered;

% Skapa frekvensspektra f�r I f�r att se hur den ska filtreras
fI = fft(I);
absI = abs(fI);
plot(f,fI)
% Filtrera I
[B,A] = butter(10,0.2,'low'); 
filter_I = filter(B,A,I);

% Skapa frekvensspektra f�r Q f�r att se hur den ska filtreras
fQ= fft(Q);
absQ=abs(fQ);
plot(f,fQ)
% Filtrera Q
filter_Q = filter(B,A,Q);

ljud_Q=decimate(filter_Q, 40);
ljud_I=decimate(filter_I, 40);
 
soundsc(ljud_Q);