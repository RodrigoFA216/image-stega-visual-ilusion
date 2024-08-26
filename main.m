%% Apertura de una imagen
imagen = imread('airplanef16c.bmp');  % Cambia la ruta por la de tu imagen

%% Separacion en capas RGB
R = imagen(:,:,1);
G = imagen(:,:,2);
B = imagen(:,:,3);

%% Creacion de una matriz del mismo tamaño de la imagen original en sus tres canales
[filas, columnas, ~] = size(imagen);
imagen_sintetizada = zeros(filas, columnas, 3, 'uint8');

%% Llenado de la matriz
for col = 1:columnas
    if mod(col, 2) == 1
        imagen_sintetizada(:, col, :) = 128;
    else
        imagen_sintetizada(:, col, 1) = R(:, col);
        imagen_sintetizada(:, col, 2) = G(:, col);
        imagen_sintetizada(:, col, 3) = B(:, col);
    end
end

%% Mediciones
psnr_val = psnr(imagen_sintetizada, imagen);
ssim_val = ssim(imagen_sintetizada, imagen);
% fsim_val requiere el paquete de Matlab
% fsim_val = fsim(imagen_sintetizada, imagen);

fprintf('PSNR: %f\n', psnr_val);
fprintf('SSIM: %f\n', ssim_val);
% fprintf('FSIM: %f\n', fsim_val);

%% Guardado de la imagen sintetizada
imwrite(imagen_sintetizada, 'imagen_sintetizada.jpg');

%% Despliegue de la imagen original y la imagen sintetizada
figure;
%subplot(1,2,1);
imshow(imagen);
title('Imagen Original');
figure;
%subplot(1,2,2);
imshow(imagen_sintetizada);
title('Imagen Sintetizada');