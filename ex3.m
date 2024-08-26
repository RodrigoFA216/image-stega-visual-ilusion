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
    
    figure;
    imshow(imagen_sintetizada_uint8);
    title(['Imagen sintetizada con N = ', num2str(n)]);
    
    imagenes_guardadas{end+1} = imagen_sintetizada_uint8;
end

% Cálculo del PSNR entre la imagen original y cada imagen sintetizada guardada
for i = 1:length(imagenes_guardadas)
    psnr_value = psnr(imagenes_guardadas{i}, imagen);
    fprintf('PSNR entre la imagen original y la imagen sintetizada con N = %.1f: %f dB\n', 0.5 + (i-1)*0.1, psnr_value);
end


