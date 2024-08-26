clc; clear; close all

% Cargar imagen
I = imread('airplanef16c.bmp');  
M = size(I,1);
N = size(I,2);

% Separación de canales RGB
R = double(I(:,:,1));
G = double(I(:,:,2));
B = double(I(:,:,3));

% Inicialización de las imágenes sintetizadas
Rw = B;  
Gw = B;
Bw = B;

n = 0.5;

% Primer paso: generación de imágenes sintetizadas
for x = 1 : 2 : M
    for y = 1 : N
        A = [R(x,y), G(x,y), B(x,y)];
        minimo = min(A);
        maximo = max(A);
        L = (maximo + minimo)/2;

        if L <= 0.5
            S = (maximo - minimo) / (maximo + minimo);
        else
            S = (maximo - minimo) / (2 - (maximo + minimo));
        end

        if (S + n) >= 0
            alfa = (1 - S) / S;
        else
            alfa = n / (1 - n);
        end

        % Actualización de canales sintetizados
        Rw(x,y) = R(x,y) + (alfa * (R(x,y) - L));
        Gw(x,y) = G(x,y) + (alfa * (G(x,y) - L));
        Bw(x,y) = B(x,y) + (alfa * (B(x,y) - L));
    end
end

% Convertir de nuevo a uint8
Rw = uint8(Rw);
Gw = uint8(Gw);
Bw = uint8(Bw);

% Generar la imagen sintetizada guardada
imagen_sintetizada_guardada = cat(3, Rw, Gw, Bw);

% Segundo paso: combinación en bloques 3x3

% Inicialización de la imagen resultante
imagen_resultante = zeros(M, N, 3, 'uint8');

for i = 1:3:M-2
    for j = 1:3:N-2
        % Determinar el patrón del kernel
        if j < N/2
            % Primer mitad de la imagen: usar patrón [0,1,1;1,0,1;1,1,0]
            imagen_resultante(i, j, 1) = Rw(i+1, j+2); % 0
            imagen_resultante(i, j+1, 1) = Rw(i, j+1); % 1
            imagen_resultante(i, j+2, 1) = Rw(i, j+2); % 1
            imagen_resultante(i+1, j, 1) = Rw(i+1, j); % 1
            imagen_resultante(i+1, j+1, 1) = Rw(i+1, j+1); % 0
            imagen_resultante(i+1, j+2, 1) = Rw(i+1, j+2); % 1
            imagen_resultante(i+2, j, 1) = Rw(i+2, j); % 1
            imagen_resultante(i+2, j+1, 1) = Rw(i+2, j+1); % 1
            imagen_resultante(i+2, j+2, 1) = Rw(i+2, j+2); % 0

            imagen_resultante(i, j, 2) = Gw(i+1, j+2); % 0
            imagen_resultante(i, j+1, 2) = Gw(i, j+1); % 1
            imagen_resultante(i, j+2, 2) = Gw(i, j+2); % 1
            imagen_resultante(i+1, j, 2) = Gw(i+1, j); % 1
            imagen_resultante(i+1, j+1, 2) = Gw(i+1, j+1); % 0
            imagen_resultante(i+1, j+2, 2) = Gw(i+1, j+2); % 1
            imagen_resultante(i+2, j, 2) = Gw(i+2, j); % 1
            imagen_resultante(i+2, j+1, 2) = Gw(i+2, j+1); % 1
            imagen_resultante(i+2, j+2, 2) = Gw(i+2, j+2); % 0

            imagen_resultante(i, j, 3) = Bw(i+1, j+2); % 0
            imagen_resultante(i, j+1, 3) = Bw(i, j+1); % 1
            imagen_resultante(i, j+2, 3) = Bw(i, j+2); % 1
            imagen_resultante(i+1, j, 3) = Bw(i+1, j); % 1
            imagen_resultante(i+1, j+1, 3) = Bw(i+1, j+1); % 0
            imagen_resultante(i+1, j+2, 3) = Bw(i+1, j+2); % 1
            imagen_resultante(i+2, j, 3) = Bw(i+2, j); % 1
            imagen_resultante(i+2, j+1, 3) = Bw(i+2, j+1); % 1
            imagen_resultante(i+2, j+2, 3) = Bw(i+2, j+2); % 0
        else
            % Segunda mitad de la imagen: usar patrón [1,0,0;0,1,0;0,0,1]
            imagen_resultante(i, j, 1) = R(i, j);    % 1
            imagen_resultante(i, j+1, 1) = R(i, j+1); % 0
            imagen_resultante(i, j+2, 1) = R(i, j+2); % 0
            imagen_resultante(i+1, j, 1) = R(i+1, j); % 0
            imagen_resultante(i+1, j+1, 1) = R(i+1, j+1); % 1
            imagen_resultante(i+1, j+2, 1) = R(i+1, j+2); % 0
            imagen_resultante(i+2, j, 1) = R(i+2, j); % 0
            imagen_resultante(i+2, j+1, 1) = R(i+2, j+1); % 0
            imagen_resultante(i+2, j+2, 1) = R(i+2, j+2); % 1

            imagen_resultante(i, j, 2) = G(i, j);    % 1
            imagen_resultante(i, j+1, 2) = G(i, j+1); % 0
            imagen_resultante(i, j+2, 2) = G(i, j+2); % 0
            imagen_resultante(i+1, j, 2) = G(i+1, j); % 0
            imagen_resultante(i+1, j+1, 2) = G(i+1, j+1); % 1
            imagen_resultante(i+1, j+2, 2) = G(i+1, j+2); % 0
            imagen_resultante(i+2, j, 2) = G(i+2, j); % 0
            imagen_resultante(i+2, j+1, 2) = G(i+2, j+1); % 0
            imagen_resultante(i+2, j+2, 2) = G(i+2, j+2); % 1

            imagen_resultante(i, j, 3) = B(i, j);    % 1
            imagen_resultante(i, j+1, 3) = B(i, j+1); % 0
            imagen_resultante(i, j+2, 3) = B(i, j+2); % 0
            imagen_resultante(i+1, j, 3) = B(i+1, j); % 0
            imagen_resultante(i+1, j+1, 3) = B(i+1, j+1); % 1
            imagen_resultante(i+1, j+2, 3) = B(i+1, j+2); % 0
            imagen_resultante(i+2, j, 3) = B(i+2, j); % 0
            imagen_resultante(i+2, j+1, 3) = B(i+2, j+1); % 0
            imagen_resultante(i+2, j+2, 3) = B(i+2, j+2); % 1
        end
    end
end

% Mostrar la imagen resultante
figure;
imshow(imagen_resultante);
title('Imagen resultante con bloques 3x3 combinados y patrones modificados');
