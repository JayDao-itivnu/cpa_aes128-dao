clc;clear;

tic;
%% Loading Variables
% Loading Inputs.mat and traces1000x512.mat

load Input.mat;
% load traces1000x512.mat;
load SubBytes.mat;

%% Hypotherical PWR Consumption Calculation
n=256;
s=1000;
PlainText = Inputs;
key=0:255;
for c= 1:n
    for r = 1:s 
    Output_AddRoundKey(r,c)=bitxor(PlainText(r),key(c)); % T est une matrice qui represente la 8 emme byte de plaintext
    end
end

for c= 1:n
    for r = 1:s 
    Output_SubBytes (r,c) = SubBytes(Output_AddRoundKey (r,c)+1); % SubBytes est la matrice de la foncyion S-box de l'AES.
    end
end

for c= 1:n
    for r = 1:s 
    Weight_Hamm (r,c) = sum(bitget(Output_SubBytes(r,c),1:8));
    end
end

[m,f] = size(traces_Y);%  T est la matrice qui contient les traces electromagnetique, nous avons recuper� 2000 traces et chaque trace contient 5002 point osciloscope. 
%Trace = abs(T);

%% Correlation Calculation
for i=1:length(key)
    for j=1:f
        cor = corrcoef(Weight_Hamm(:,i), (traces_Y(:,j))); % Calcul direct pour les 2000 textes
        Corr_Matrx(j,i) = cor(1,2);
        clear cor;
    end

end
[z i] = max(max(abs(Corr_Matrx)));
Secret_Key = key(i);
attackTime= toc;

%% Display result
disp(['Secret Key is: ', num2str(Secret_Key)]);
disp(['Processing Duration is: ', num2str(attackTime)]);
for c= 1:256
   for r = 1:f 
    T_cor (r) = abs(Corr_Matrx(r,c));
   end 
    Plot_max_cor (c) = max (T_cor);
end
% 




    


