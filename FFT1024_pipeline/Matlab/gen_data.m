w = 0 : 2*pi/1024 : 2*pi - 2*pi/1024;
x = 150*sin(w) + 100*sin(w*3) + 200;
x = [x, 0*sin(2*w) + 0*sin(w*5) + 255];
x = uint32(x);
%x = bitshift(x,16);
fp1 = fopen("..\Data\data2.dat", "wb");

for i = 1 : length(x)
    fprintf(fp1,"%x\n", x(i)); 
end

fclose(fp1);

%{
fp1 = fopen("F:\Program\Quartus\FFT32\init_RAM.txt", "w");

for i = 1 : 2 : length(x) / 2
    fprintf(fp1, "%d\n", x(i)); 
    fprintf(fp1, "%d\n", x(i+16));
end
for i = 2 : 2 : length(x) / 2
    fprintf(fp1, "%d\n", x(i)); 
    fprintf(fp1, "%d\n", x(i+16));
end

fclose(fp1);

for i = 1 : 1 : length(x)
    fprintf("%d: %d\n", i-1, x(i));
end
%}