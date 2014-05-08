%--------- Uppgift 1 ---------

% Ladda signal
auload signal-hanel742.wav;
% Ursprungligen i Matlab - numera i Octave. Konvertera variabelnamn
data = ans;

fs = 400000;
% Ta fram fouriertransform och spektra
fData= fft(data);
absF=abs(fData);
l=length(data);
fAxis=[-200000:fs/l:200000-(fs/l)];

figure(1);
plot(fAxis,absF);
xlabel("Frekvens (Hz)");

% Filtrering av forsta delen
[B,A] = butter(10,[0.2, 0.4]);
filterData1 = filter(B,A,data);
tAxis = [0:19.5/l:19.5-(19.5/l)];
figure(2);
plot(tAxis,filterData1);
xlabel("Tid (s)");

% Filtrering av andra delen
[B,A] = butter(10,[0.5, 0.65]);
filterData2 = filter(B,A,data);
figure(3);
plot(tAxis,filterData2);
xlabel("Tid (s)");
 
% Filtrering av tredje delen
[B,A] = butter(10,[0.7, 0.8]);
filterData3 = filter(B,A,data);
figure(4);
plot(tAxis,filterData3);
xlabel("Tid (s)");
 
% filterData3 -> bara vitt brus. 
% filterData1 innehaller rimligen information. 

% Barfrekvensen for filterData1 ar: 
fc=57000;


%--------- Uppgift 2 ---------

%X-correlerar vitt brus  
Z = xcorr(filterData3,filterData3);
 
plot(Z);
 
% Storsta toppen ges vid 7.8*10^6 ms
% sidotoppar vid 7,948*10^6 och 7,652*10^6
% (7,948-7,8)*10^6 = 148 000 samples
% 148 000 samples / 400 000 hz = 0,37 s


%--------- Uppgift 3 ---------
% Filtrerar bort eko
% Anvander forsta 148 000 samples for att ta bort ekot som kommer sen.
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

% Skapa frekvensspektra for I for att se hur den ska filtreras
fI = fft(I);
absI = abs(fI);
plot(f,fI)
% Filtrera I
[B,A] = butter(10,0.2,'low'); 
filter_I = filter(B,A,I);

% Skapa frekvensspektra for Q for att se hur den ska filtreras
fQ= fft(Q);
absQ=abs(fQ);
plot(f,fQ)
% Filtrera Q
filter_Q = filter(B,A,Q);

ljud_Q=decimate(filter_Q, 40);
ljud_I=decimate(filter_I, 40);
 
soundsc(ljud_Q);