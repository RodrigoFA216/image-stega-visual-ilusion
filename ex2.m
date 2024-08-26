%% Apertura de una imagen
imagen = imread('airplanef16c.bmp');  % Cambia la ruta por la de tu imagen

%% Separacion en capas RGB
R = imagen(:,:,1);
G = imagen(:,:,2);
B = imagen(:,:,3);

%% Creacion de una matriz del mismo tamaño de la imagen original en sus tres canales
[filas, columnas, ~] = size(imagen);
imagen_sintetizada = zeros(filas, columnas, 3, 'uint8');

%obtención del maximo y minimo
maxValue = max(imagen(:));
minValue = min(imagen(:));

L = ((maxValue+minValue)/2);
S = 0;
if L <= 0.5
    S = (maxValue-minValue)/(maxValue+minValue);
elseif L > 0.5
    S = (maxValue-minValue)/(2-(maxValue+minValue));
end

imagenes_guardadas = {};

for n = 0.5 : 0.1 : 1
    aux = S+n;
    a = 0;
    if aux >= 0
        a = (1-S)/S;
    elseif aux < 0
        a = n/(1-n);
    end
    imagen_sintetizada(:,:,1) = R + (a.*(R-L));
    imagen_sintetizada(:,:,2) = G + (a.*(G-L));
    imagen_sintetizada(:,:,3) = B + (a.*(B-L));
    
    figure;
    imshow(imagen_sintetizada);
    title(['Imagen sintetizada con N = ', num2str(n)]);
    
    % Guardar la imagen en la cell array
    imagenes_guardadas{end+1} = imagen_sintetizada;
end

% Cálculo del PSNR entre la imagen original y cada imagen sintetizada guardada
for i = 1:length(imagenes_guardadas)
    psnr_value = psnr(imagenes_guardadas{i}, imagen);
    fprintf('PSNR entre la imagen original y la imagen sintetizada con N = %.1f: %f dB\n', 0.5 + (i-1)*0.1, psnr_value);
end