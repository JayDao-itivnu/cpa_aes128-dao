dbstop if error
ca
clear all
cleanupObj = onCleanup(@cleanMeUp);

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
% Prepare Lecroy
init_LeCroy;
% Init COM port to FPGA
myComPort = serial('COM3','BaudRate',115200,'Timeout',60); %4800 %921600 460800 115200
fopen(myComPort);

% Generate 128-bit (16 bytes) Plaintext


% Send PT
for g = 1:4
    for k = 1:16
        sendbyte(k) = Plaintext(k);
        fwrite(myComPort,sendbyte(k),'uint8');
    end
end
% Read the cipher
cipher = fread(myComPort,16,'uint8');

% Check to see if cipher is correct 

% Read the power wave
acquire_LeCroy_scope_data
