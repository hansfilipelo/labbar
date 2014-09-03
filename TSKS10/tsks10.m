%--------- Uppgift 1 ---------

% Ladda signal i Octave
% auload signal-hanel742.wav;

% Ladda signal i Matlab
% open signal-hanel742;

% Ursprungligen i Matlab - numera i Octave. Konvertera variabelnamn
% data = ans;

fs = 400000;
% Ta fram fouriertransform och spektra
fData= fft(data);
absF=abs(fData);
l=length(data);
fAxis=[-200000:fs/l:200000-(fs/l)];

figure(1);
plot(fAxis,absF);
xlabel('Frekvens (Hz)');

% Filtrering av forsta delen
[B,A] = butter(10,[0.2, 0.4]);
filterData1 = filter(B,A,data);
tAxis = [0:19.5/l:19.5-(19.5/l)];
figure(2);
plot(tAxis,filterData1);
xlabel('Tid (s)');

% Filtrering av andra delen
[B,A] = butter(10,[0.5, 0.65]);
filterData2 = filter(B,A,data);
figure(3);
plot(tAxis,filterData2);
xlabel('Tid (s)');
 
% Filtrering av tredje delen
[B,A] = butter(10,[0.7, 0.8]);
filterData3 = filter(B,A,data);
figure(4);
plot(tAxis,filterData3);
xlabel('Tid (s)');
 
% filterData3 -> bara vitt brus. 
% filterData1 innehaller rimligen information. 

% Barfrekvensen for filterData1 ar: 
fc=38000;


%--------- Uppgift 2 ---------

%X-correlerar vitt brus  
Z = xcorr(filterData3,filterData3);
xCorrAxis = [0:19.5/l:39-(39/l)];

figure(5);
plot(xCorrAxis,Z);
xlabel('tau (s)');
axis([18,21,-300,300]);
 
% Storsta toppen ges vid tau = 19,50 s
% sidotoppar vid +- 0,37 s = 37 ms
% 37 ms ger 0,37 s x 400000 Hz = 148 000 samples


%--------- Uppgift 3 ---------
% Filtrerar bort eko
% Anvander forsta 148 000 samples for att ta bort ekot som kommer sen.
nrOfSamples = 148000;

filtered = zeros(size(filterData1));
filtered(1:nrOfSamples) = filterData1(1:nrOfSamples);

for i = 0 : 50

temp1 = filtered((1+nrOfSamples*i):(nrOfSamples + nrOfSamples*i));
temp2 = filterData1((nrOfSamples+1+nrOfSamples*i):(i+2)*nrOfSamples);

filtered((nrOfSamples+1+nrOfSamples*i):(i+2)*nrOfSamples) = temp2 - 0.9*temp1;

end

%I/Q-demodulation
t = [0:1/fs:19.5-(1/fs)];
xI = 2*cos(2*pi*fc*t);
xQ = -2*sin(2*pi*fc*t);

I = xI'.*filtered;
Q = xQ'.*filtered;

% Skapa frekvensspektra for I for att se hur den ska filtreras
fI = fft(I);
absI = abs(fI);
figure(6);
plot(fAxis,fI)
xlabel('Frekvens (Hz)');

% Filtrera I
[B,A] = butter(10,0.2,'low'); 
iFiltered = filter(B,A,I);

% Skapa frekvensspektra for Q for att se hur den ska filtreras
fQ = fft(Q);
absQ = abs(fQ);
figure(7);
plot(fAxis,fQ)
xlabel('Frekvens (Hz)');

% Filtrera Q
qFiltered = filter(B,A,Q);


% Sampla ner sa ljud gar att spela satt vardet till 9 i Octave, 40 i Matlab
qAudio=decimate(qFiltered, 40);
iAudio=decimate(iFiltered, 40);
 
% Spela ljud i Octave pa Linux
% playsound(qAudio)
% playsound(iAudio)

% Spela ljud i Matlab
% soundsc(iAudio)
% soundsc(qAudio)