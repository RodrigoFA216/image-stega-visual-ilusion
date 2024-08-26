%% Apertura de una imagen
imagen = imread('airplanef16c.bmp');  % Cambia la ruta por la de tu imagen

%% Separación en capas RGB
R = double(imagen(:,:,1));
G = double(imagen(:,:,2));
B = double(imagen(:,:,3));

%% Creación de una matriz del mismo tamaño de la imagen original en sus tres canales
[filas, columnas, ~] = size(imagen);
imagen_sintetizada = zeros(filas, columnas, 3, 'double');

maxValue = max(max(R, G), B);
minValue = min(min(R, G), B);

% L y S ahora son matrices del mismo tamaño que las capas de la imagen
L = (maxValue + minValue) / 2;
S = zeros(filas, columnas);

S(L <= 0.5) = (maxValue(L <= 0.5) - minValue(L <= 0.5)) ./ (maxValue(L <= 0.5) + minValue(L <= 0.5));
S(L > 0.5) = (maxValue(L > 0.5) - minValue(L > 0.5)) ./ (2 - (maxValue(L > 0.5) + minValue(L > 0.5)));

% Cell array para almacenar las imágenes sintetizadas
imagenes_guardadas = {};

for n = 0.5 : 0.1 : 1
    aux = S + n;
    a = zeros(filas, columnas);
    
    a(aux >= 0) = (1 - S(aux >= 0)) ./ S(aux >= 0);
    a(aux < 0) = n / (1 - n);
    
    imagen_sintetizada(:,:,1) = R + a .* (R - L);
    imagen_sintetizada(:,:,2) = G + a .* (G - L);
    imagen_sintetizada(:,:,3) = B + a .* (B - L);
    
    % Convertir la imagen sintetizada de vuelta a uint8
    imagen_sintetizada_uint8 = uint8(imagen_sintetizada);
    
    %figure;
    %imshow(imagen_sintetizada_uint8);
    %title(['Imagen sintetizada con N = ', num2str(n)]);
    
    imagenes_guardadas{end+1} = imagen_sintetizada_uint8;
end

% Cálculo del PSNR entre la imagen original y cada imagen sintetizada guardada
for i = 1:length(imagenes_guardadas)
    psnr_value = psnr(imagenes_guardadas{i}, imagen);
    fprintf('PSNR entre la imagen original y la imagen sintetizada con N = %.1f: %f dB\n', 0.5 + (i-1)*0.1, psnr_value);
end

%% Obtener la imagen sintetizada guardada
imagen_sintetizada_guardada = imagenes_guardadas{1};

%% Separación en capas RGB de ambas imágenes
R_original = double(imagen(:,:,1));
G_original = double(imagen(:,:,2));
B_original = double(imagen(:,:,3));

R_guardada = double(imagen_sintetizada_guardada(:,:,1));
G_guardada = double(imagen_sintetizada_guardada(:,:,2));
B_guardada = double(imagen_sintetizada_guardada(:,:,3));


%% Inicialización de la imagen resultante
[filas, columnas, ~] = size(imagen);
imagen_resultante = zeros(filas, columnas, 3, 'uint8');

%% Síntesis de la imagen combinando bloques 2x2
for i = 1:2:filas-1
    for j = 1:2:columnas-1
        % Bloque 2x2 en el canal R
        imagen_resultante(i, j, 1) = R_original(i, j);          % 1
        imagen_resultante(i, j+1, 1) = R_guardada(i, j+1);      % 0
        imagen_resultante(i+1, j, 1) = R_guardada(i+1, j);      % 0
        imagen_resultante(i+1, j+1, 1) = R_original(i+1, j+1);  % 1

        % Bloque 2x2 en el canal G
        imagen_resultante(i, j, 2) = G_original(i, j);          % 1
        imagen_resultante(i, j+1, 2) = G_guardada(i, j+1);      % 0
        imagen_resultante(i+1, j, 2) = G_guardada(i+1, j);      % 0
        imagen_resultante(i+1, j+1, 2) = G_original(i+1, j+1);  % 1

        % Bloque 2x2 en el canal B
        imagen_resultante(i, j, 3) = B_original(i, j);          % 1
        imagen_resultante(i, j+1, 3) = B_guardada(i, j+1);      % 0
        imagen_resultante(i+1, j, 3) = B_guardada(i+1, j);      % 0
        imagen_resultante(i+1, j+1, 3) = B_original(i+1, j+1);  % 1
    end
end

%% Mostrar la imagen resultante
figure;
imshow(imagen_resultante);
title('Imagen resultante con bloques 2x2 combinados');