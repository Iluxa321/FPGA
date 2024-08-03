w = 0 : 2*pi/128 : 2*pi - 2*pi/128;
k = 0 : 127;
 % входные данные
x = 100*exp(1j*w) + 100;
%x = ones(1,16) * 255;
y = 100*exp(1j*(w+pi/2)) + 100;
%y = ones(1,16) * 255;
w = exp(-1j*2*pi*k/256);

% Рассчет бабочки
m = y .* w;
X = x + m;
Y = x - m;

 % сохранение данных
fp1 = fopen("..\Data\data_X.txt", "w");
fp2 = fopen("..\Data\data_Y.txt", "w");
fp3 = fopen("..\Data\data_A.txt", "w");
fp4 = fopen("..\Data\data_B.txt", "w");
save_Xr = real(X);
save_Xi = imag(X);
save_Yr = real(Y);
save_Yi = imag(Y);
for i = 1 : length(save_Xr)
    fprintf(fp1, "%d %d\n", int32(save_Xr(i)), int32(save_Xi(i)));
    fprintf(fp2, "%d %d\n", int32(save_Yr(i)), int32(save_Yi(i)));
    
    fprintf(fp3, "%d %d\n", int32(real(x(i))), int32(imag(x(i))));
    fprintf(fp4, "%d %d\n", int32(real(y(i))), int32(imag(y(i))));
    
end

fclose(fp1);
fclose(fp2);
fclose(fp3);
fclose(fp4);
