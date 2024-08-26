clc; clear; close all

I = imread('1.bmp');
R = ind2gray(double(I(:,:,1)),gray(256)); G = ind2gray(double(I(:,:,2)),gray(256)); B = ind2gray(double(I(:,:,3)),gray(256));
M = size(I,1); N = size(I,2);
Rw = B;
Gw = B;
Bw = B;

n = 0.5;

% Este for causa patron de bandas
for x = 1 : 2 : M % Saltos pequeños mayor distorsion en color, saltos grandes hacen mas gris la imagen
    for y = 1 : N
% Este for cause patrón de bloques
% for x = 1 : 2 : M % Saltos pequeños mayor distorsion en color, saltos grandes hacen mas gris la imagen
%     for y = 1 : 2 : N
       A = [R(x,y) G(x,y) B(x,y)];
       minimo = min(A);
       maximo = max(A);
       L = (maximo + minimo)/2;

       if L<=0.5
           S = (maximo-minimo)/(maximo+minimo);
       end

       if L>0.5
           S = (maximo-minimo)/(2-(maximo+minimo));
       end

       if (S+n)>=0
            alfa = (1-S)/S;
       end
       
       if (S+n)<0
           alfa = n/(1-n);
       end

       Rw(x,y) = R(x,y)+(alfa*(R(x,y)-L));
       Gw(x,y) = G(x,y)+(alfa*(G(x,y)-L));
       Bw(x,y) = B(x,y)+(alfa*(B(x,y)-L));

    end
end

Rw = gray2ind(Rw,256);
Gw = gray2ind(Gw,256);
Bw = gray2ind(Bw,256);

Istego(:,:,1) = Rw;
Istego(:,:,2) = Gw;
Istego(:,:,3) = Bw;

figure(); imshow(Istego);
