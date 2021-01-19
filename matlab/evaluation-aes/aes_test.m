%% aes_test.m
clc;
clear;

dbstop if error
% cleanupObj = onCleanup(@cleanMeUp);

rng shuffle
%%rng(1);
%addpath(genpath('./utils'));
%addpath(genpath('./bin2hex'));
%addpath(genpath('./textprogressbar'));

format long;
if ~isempty(instrfind)
     fclose(instrfind);
      delete(instrfind);
end
fprintf('Loading the Port ...\n...\n');

myComPort = serial('COM7','BaudRate',9600,'Timeout',200); %4800 %921600 460800 115200
fopen(myComPort);
fprintf('Loading Success!\n\nBegin test!\n----------------\n');
Test =0;
for n =1: 1000
    Key = dec2hex(randi([0 15],1,32)).';
    Plaintext = dec2hex(randi([0 15],1,32)).';
    expCipher = Cipher(Key,Plaintext);
    fprintf('I=%d\n',n)
        
    % Send Key
    for k = 1:length(Key)/2
        sendbyte = Key((2*k-1):(2*k));
        x=uint8(hex2dec(sendbyte));
        fwrite(myComPort,x,'uint8');
    end
    
    % Send PT
    for k = 1:length(Plaintext)/2
        sendbyte = Plaintext((2*k-1):(2*k));
        x=uint8(hex2dec(sendbyte));
        fwrite(myComPort,x,'uint8');
    end
     
    cipher_2x16 = dec2hex(fread(myComPort,16,'uint8')).';
    cipher=lower(cipher_2x16(:)');
    if (expCipher == cipher)
        disp('OK!');
        Test= Test + 1;
    end
end
WrongTest =1000-Test;
fprintf('Closing the Port ...\n...\n');
fclose(myComPort);
disp('Completed!!')
disp('------------')
fprintf('Summarization:\nTotal test: 1000\nTotal correct cases: %d\nTotal wrong cases: %d\n', Test,WrongTest)