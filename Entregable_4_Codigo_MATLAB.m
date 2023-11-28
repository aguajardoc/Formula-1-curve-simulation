classdef Entregable4 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        IniciarSimulacinconCurvaPersonalizadaButton  matlab.ui.control.Button
        CoeficientesdePolinomioPersonalizadoLabel  matlab.ui.control.Label
        a0EditField                     matlab.ui.control.NumericEditField
        a0EditFieldLabel                matlab.ui.control.Label
        a1EditField                     matlab.ui.control.NumericEditField
        a1EditFieldLabel                matlab.ui.control.Label
        a2EditField                     matlab.ui.control.NumericEditField
        a2EditFieldLabel                matlab.ui.control.Label
        a3EditField                     matlab.ui.control.NumericEditField
        a3EditFieldLabel                matlab.ui.control.Label
        IniciarSimulacinconCreacindeNuevaCurvaButton  matlab.ui.control.Button
        DistanciaRecorridaenDerrapemEditField  matlab.ui.control.NumericEditField
        DistanciaRecorridaenDerrapemEditFieldLabel  matlab.ui.control.Label
        RadiodeCurvaturaenmximomEditField  matlab.ui.control.NumericEditField
        RadiodeCurvaturaenmximomEditFieldLabel  matlab.ui.control.Label
        LongituddepistamEditField       matlab.ui.control.NumericEditField
        LongituddepistamEditFieldLabel  matlab.ui.control.Label
        EnergaPerdidaenDerrapeJEditField  matlab.ui.control.NumericEditField
        EnergaPerdidaenDerrapeLabel     matlab.ui.control.Label
        ControldelasimulacinLabel       matlab.ui.control.Label
        IniciarSimulacinButton          matlab.ui.control.Button
        RapidezInicialkmhEditField      matlab.ui.control.NumericEditField
        VelocidadInicialkmhLabel        matlab.ui.control.Label
        UIAxes                          matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: IniciarSimulacinButton
        function IniciarSimulacinButtonPushed(app, event)
            %{
Entregable 4 del Reto: Código

Alejandro Guajardo Caba - A01178375
Ricardo Manuel Barbosa Flores - A00823815
Homero Maximiliano Flores Betancourt - A00840253

F1005B: Modelación Computacional Aplicando Leyes de Conservación
Profesor: Gerardo Ramón Fox

El objetivo de este reto es modelar una posible curva que pueda aplicarse
en una nueva pista de Fórmula 1. Para esto, además de generar de manera
aleatoria los coeficientes de la función que modela la curva, es necesario
proveer la velocidad máxima a la que los carros pueden viajar sobre la
curva para evitar accidentes. Asimismo, conocer la zona de derrape y la
recta tangente a la curva en dicha zona es crítico para colocar las gradas
de espectadores en un lugar seguro que, además, maximice la experiencia de
los espectadores si una carrera se llegara a llevar a cabo. Finalmente, es
de suma importancia saber la distancia que recorrería el carro en caso de
descarrilarse, para asegurar el área tanto para espectadores como para los
conductores mismos; la energía perdida en el derrape se puede convertir en
calor, por lo que también es indispensable evitar la flamabilidad de ésa
zona.

Funcionamiento: A través de un ejecutable de MATLAB (.mlapp), se puede
alterar el parámetro de rapidez inicial para visualizar una simulación del
recorrido que haría el carro, incluyendo su trayectoria de derrape, en caso
de que esto ocurra, en un conjunto de parámetros generados anteriormente. 
También, se pueden generar curvas nuevas sobre las cuales se
puede experimentar con distintas rapideces. Además, se pueden insertar
coeficientes personalizados del polinomio cúbico, si es que se quiere
experimentar con una curva generada anteriormente.

Paquetería necesaria: MATLAB (De preferencia R2023b o superior), archivos
de sonido "Drift.wav", "Crash.wav" y "carro.wav", todos proveídos en la
misma carpeta del programa.

Referencias:

Fédération Internationale de l'Automobile. (2022, diciembre 7). 2023
FORMULA 1 TECHNICAL REGULATIONS. https://www.fia.com/sites/default/files/fia_2023_formula_1_technical_regulations_-_issue_4_-_2022-12-07.pdf

Motorsport. (2021, agosto 24). Licencia de circuitos FIA: requisitos para ser sede de F1 y más. https://es.motorsport.com/f1/news/licencia-circuitos-fia-requisitos-formula1/6509978/

Physics Of Formula 1. (s.f.). In the wet. https://physicsofformula1.wordpress.com/in-the-wet/
            %}

            % Reiniciar ejes y activar el hold para que se sobreponga el
            % carro sobre la "calle".
            hold(app.UIAxes, 'on');
            cla(app.UIAxes)

            %% { Cargar Efectos de Sonido } %%

            [y,Fs] = audioread("Drift.wav"); % Sonido de derrape
            [y2, Fs2] = audioread("Crash.wav"); % Sonido de choque
            [y3, Fs3] = audioread("carro.wav"); % Sonido de carro viajando

            %% { Funciones } %%

            % Coeficientes (obtenidos por el Entregable 2)
            a3 = -0.00004696730597170429;
            a2 = 0.007198311361420753;
            a1 = 0.843898854917533;
            a0 = 199.47267138843134;

            % Regresa la función evaluada en un x dado, de acuerdo a sus coeficientes
            funcion = @(x) a3*x.^3 + a2*x.^2 + a1*x + a0;

            % Regresa la primera derivada evaluada en un x dado, de acuerdo a los coeficientes de la función original
            primderiv = @(x) 3*a3*x.^2 + 2*a2*x + a1;

            % Regresa la segunda derivada evaluada en un x dado, de acuerdo a los coeficientes de la función original
            segderiv = @(x) 6*a3*x + 2*a2;

            % Regresa el radio de curvatura en un x dado, de acuerdo a los coeficientes de la función original
            radioCurvatura = @(x) ((1.0 + primderiv(x)^2)^1.5) / abs(segderiv(x));

            % Regresa el integrando de la funcion a integrar
            integrando = @(x) sqrt(1 + primderiv(x)^2);

            % Regresa la longitud de arco de acuerdo a los coeficientes de la función original
            function [suma_integral_final] = longitudArco()

                a = 30;  % Límite inferior
                b = 260; % Límite superior
                n = 499; % Número de iteraciones
                dx = (b-a)/n; % Paso
                suma_integral = 0; % Sumatoria de los trapecios

                % Se aplica la Regla del Trapecio con método numérico de integración
                for i = 1:n-1
                    xi(i) = a + dx*i;
                    suma_integral = suma_integral + integrando(xi(i)); % Sumar desde el segundo término hasta el penúltimo
                end

                suma_integral_final = (2 * suma_integral + integrando(a) + integrando(b)) * (dx/2);
            end

            % Regresa la recta tangente a una polinomio
            linea = @(rangox, x0, y0) primderiv(x0)*(rangox-x0) + y0;

            % Procesa el input de la velocidad del usuario
            vel = app.RapidezInicialkmhEditField.Value;

            %% { Zona de Derrape } %%

            % Crear un arreglo vacío
            zonaRiesgo = [];

            for i = 1:499
                a = 30; % Límite inferior
                b = 260; % Límite superior
                dx = (b-a)/499; % Paso
                rC_act = radioCurvatura(a + dx*i); % Calcular radio

                % Si es menor a 50, se agrega el punto al arreglo
                if rC_act < 50
                    zonaRiesgo(i) = a + dx*i;
                end
            end

            % Remover todos los elementos que sean 0
            zonaRiesgo = nonzeros(zonaRiesgo)';

            % Muestra la longitud de arco y el radio de curvatura en el
            % máximo de la curva
            app.LongituddepistamEditField.Value = longitudArco();
            app.RadiodeCurvaturaenmximomEditField.Value = 1 / (2*sqrt(a2^2 - 3*a3*a1));

            %% { Graficar la función cúbica obtenida } %%

            % Declarar un linspace de 30 a 260 y sus valores de y correspondientes
            x_valoresPol = linspace(30,260,500);
            y_valoresPol = funcion(x_valoresPol);

            % Graficar estos valores en los ejes de la interfaz (negro)
            plot(app.UIAxes, x_valoresPol,y_valoresPol, "-k","LineWidth", 10)

            %% { Graficar la zona de riesgo } %%

            % Graficar línea punteada con los valores de antes para que parezca calle
            plot(app.UIAxes, x_valoresPol,y_valoresPol, "--w", linewidth = 1.5)

            %% { Gradas } %%

            % Definir parámetros
            yRect = funcion(zonaRiesgo(1)) + 15; % El valor en y de la zona de riesgo trasladado 15 metros hacia arriba para ser más seguro.
            ancho = 80; % Parámetro dado
            alto = 10; % Parámetro dado
            angulo = 16.29*pi/180; % arctan(pendiente(zonaRiesgo(1)))

            rotacion = [cos(angulo), -sin(angulo); sin(angulo), cos(angulo)];

            % Coordenadas del Rectángulo pero rotadas por el angulo
            coordsRect = [0, 0; ancho, 0; ancho, alto; 0, alto];
            rectRotado = coordsRect * rotacion';

            % Mover el rectangulo en x y en y hacia una ubicación adecuada
            % (:,1) = coordenadas en x, (:, 2) = coordenadas en y de
            % esquinas
            rectRotado(:, 1) = rectRotado(:, 1) + zonaRiesgo(1);
            rectRotado(:, 2) = rectRotado(:, 2) + yRect;

            % Agregar rectángulo al plot
            fill(app.UIAxes,rectRotado(:, 1), rectRotado(:, 2), 'b');

            %% { Iniciar sonido de carro } %%
            sound(y3, Fs3)

            % Duración del sonido
            t = length(y) / Fs + 1;

            % Se usa para repetir el sonido dentro del ciclo
            tiempoTranscurrido = 0;

            %% {Sin derrape } %%

            % Si la velocidad máxima no se excede
            if vel < 95.676 && vel > 0

                % Empezar con un punto para que se pueda modificar la variable
                plotvelnorm = plot(app.UIAxes,x_valoresPol(1), y_valoresPol(1), 'diamondm', "MarkerSize", 5, "MarkerFaceColor", "m");

                for i=1:2:500
                    plotvelnorm.XData = x_valoresPol(i); % Cambiar valor de x
                    plotvelnorm.YData = y_valoresPol(i); % Cambiar valor de Y

                    pause(0.05) % Para velocidad de gráfico constante

                    % Actualizar el tiempo por la pausa
                    tiempoTranscurrido = tiempoTranscurrido + 0.05;

                    % Si el tiempo transcurrido excede la duración del
                    % sonido, reiniciar el contador y volver a reproducir
                    % el sonido.
                    if tiempoTranscurrido >= t
                        sound(y3, Fs3)
                        tiempoTranscurrido = 0;
                    end
                end

                % Parar el sonido cuando llega al final de la curva
                clear sound

                %% { Con derrape } %%

                % Si la velocidad máxima se excede
            elseif vel >= 95.676

                % Definir constantes necesarias para el cálculo de
                % distancia
                theta = 5.7*pi/180; % Máximo peralte en carreras de Fórmula 1, según Motorsport, 2021.
                uk = 1.5; % Coeficiente de fricción entre el asfalto y las llantas de un carro de Fórmula 1, según Physics of Formula 1, s.f.
                g = 9.81; % Gravedad

                % Convertir la velocidad dada en km/h a m/s
                velms = vel/3.6;

                % Cálculo de la distancia basado en conservación de energía:
                % Ekf = Eki - fkd
                d = ((velms^2)*(cos(theta) - uk*sin(theta))) / (2*g*uk);

                % Empezar con un punto para que se pueda modificar la
                % variable (como anteriormente)
                plotvelexcedenteP1 = plot(app.UIAxes,x_valoresPol(1), y_valoresPol(1), 'diamondm', "MarkerSize", 5, "MarkerFaceColor", "m");
                normal = 1;

                % Mientras no se exceda el primer valor de zonaRiesgo, que
                % guarda valores de x
                while x_valoresPol(normal) < 131.86372745490982

                    plotvelexcedenteP1.XData = x_valoresPol(normal);
                    plotvelexcedenteP1.YData = y_valoresPol(normal);

                    pause(0.05)
                    normal = normal + 2;
                end

                % Borrar el último punto que se graficó
                delete(plotvelexcedenteP1)

                % Quitar sonido y hacer que empiece el sonido de derrape
                clear sound
                sound(y, Fs)

                % Ya que se sabe la pendiente de la recta tangente
                % (primderiv(zonaRiesgo(1))), se puede obtener la
                % distancia en x necesaria para recorrer la distanica d obtenida. Primero
                % se obtiene el arcotangente de la primderiv para obtener el ángulo que
                % hace con la horizontal (que será constante en cualquier iteración del
                % programa) y de ahí se puede obtener la distancia en x con el coseno:
                % cos(x) = a/h, donde h es la distancia d y x el ángulo obtenido. Por lo
                % tanto: distx = d*cos(anguloTan)

                anguloTan = atan(primderiv(zonaRiesgo(1)));

                % anguloTan2 = atan(primderiv(zonaRiesgo(326))) [esto se usó como
                % comprobación de que realmente es el mismo ángulo]

                distx = d*cos(anguloTan);

                % Linspace desde el primer valor de la zona de riesgo hasta
                % aquel trasladado por la distancia en x hacia la derecha
                rangoxtan = linspace(zonaRiesgo(1), zonaRiesgo(1) + distx, 101);
                rangoy = linea(rangoxtan,zonaRiesgo(1),funcion(zonaRiesgo(1)));

                % Entonces, mientras no se exceda la distx a partir del primer punto de la
                % zona de derrape zonaRiesgo(1), graficar el movimiento del carro

                % Vector guardando distancias
                distanciaAct = linspace(0,d,101);

                % Valor de fricción
                masa = 796; % Peso mínimo de un carro de Fórmula 1 (Fédération Internationale de l'Automobile, 2022).
                fk = uk * masa * g / (cos(theta) - uk * sin(theta));

                % Se repite el proceso como anteriormente
                plotvelexcedenteP2 = plot(app.UIAxes, rangoxtan(1), rangoy(1), 'diamondr',"MarkerSize", 5, "MarkerFaceColor", "r");

                for derrape = 1:2:101
                    plotvelexcedenteP2.XData = rangoxtan(derrape);
                    plotvelexcedenteP2.YData = rangoy(derrape);

                    pause(0.05)
                    app.DistanciaRecorridaenDerrapemEditField.Value = distanciaAct(derrape);
                    app.EnergaPerdidaenDerrapeJEditField.Value = fk*distanciaAct(derrape);
                end

                delete(plotvelexcedenteP2)

                % Mostrar de color naranja para indicar que choca
                plot(app.UIAxes, rangoxtan(101), rangoy(101), 'diamond', "Color", [255, 165, 0] /256, "MarkerSize", 5, "MarkerFaceColor", [255, 165, 0] /256);

                % Reproducir sonido de choque
                sound(y2, Fs2)

                % Calcular y desplegar valores finales de distancia y
                % energía perdida
                app.DistanciaRecorridaenDerrapemEditField.Value = velms^2*(cos(theta) - uk*sin(theta))/(2*g*uk);
                app.EnergaPerdidaenDerrapeJEditField.Value = velms^2*(masa)/2;

            end
        end

        % Button pushed function: 
        % IniciarSimulacinconCreacindeNuevaCurvaButton
        function IniciarSimulacinconCreacindeNuevaCurvaButtonPushed(app, event)
            % Esta función repite lo mismo de la función anterior, pero
            % agrega la capacidad de generar una nueva curva con los
            % parámetros establecidos en el Entregable 2 de este reto
            % (Radio de Curvatura < 50, 300 < longitud de arco < 500, y que
            % toque los puntos (30,230) y (260,80)).

            %{ Funciones }%

            % Regresa la función evaluada en un x dado, de acuerdo a sus coeficientes
            funcion = @(a3,a2,a1,x,a0) a3*x.^3 + a2*x.^2 + a1*x + a0;
            funcionSina0 = @(a3,a2,a1,x) a3*x.^3 + a2*x.^2 + a1*x;

            % Regresa la primera derivada evaluada en un x dado, de acuerdo a los coeficientes de la función original
            primderiv = @(a3,a2,a1,x) 3*a3*x.^2 + 2*a2*x + a1;

            % Regresa un valor relacionado al radio de curvatura en los puntos críticos de la función, solo sirve como atajo exclusivamente para esos puntos
            rC_Crit = @(a3,a2,a1) a2^2 - 3*a3*a1;

            % Regresa el integrando de la funcion a integrar
            integrando = @(a3,a2,a1,x) sqrt(1 + primderiv(a3,a2,a1,x)^2);

            % Regresa la longitud de arco de acuerdo a los coeficientes de la función original
            function [suma_integral_final] = longitudArco(a3,a2,a1)
                a = 30; % Límite inferior
                b = 260; % Límite superior
                n = 499; % Número de interaciones
                dx = (b-a)/n; % Paso
                suma_integral = 0; % Sumatoria de los trapecios

                % Se aplica la Regla del Trapecio con método numérico de
                % integración
                for i = 1:n-1
                    x_i = a + dx*i;
                    suma_integral = suma_integral + integrando(a3,a2,a1,x_i); % Sumar desde el segundo término hasta el pénúltimo
                end
                suma_integral_final = (2*suma_integral + integrando(a3,a2,a1,a) + integrando(a3,a2,a1,b)) * (dx/2); % Multiplicar la suma por dos, sumar el primero y el último término, multiplicar por h/2
            end

            %{ Generación y validación de coeficientes }%

            % Definir parámetros para poder iniciar el ciclo
            R_c2 = 50; % Radio de curvatura en puntos críticos
            s = 299; % Longitud de arco

            % Términos correspondientes al polinomio cúbico
            a0 = 0;
            a1 = 0;
            a2 = 0;
            a3 = 0;

            % Punto final en y
            punto2 = 0;

            % Mientras NO se cumplan las condiciones (con el punto que toca
            % siendo preciso a 0.01m)
            while R_c2 > 50 || s < 300 || s > 500 || punto2 >= 80.01 || punto2 <= 79.99

                % Declarar parámetros como 0 para insertar en el segundo while
                a1 = 0;
                a2 = 0;
                a3 = 0;

                % Asegurarse de que los coeficientes sean distintos a 0, especialmente importante para a3, ya que debe ser una función cúbica
                while a1 == 0 || a2 == 0 || a3 == 0

                    % Generación aleatoria de floats de acuerdo a pruebas realizadas previamente por medio de Desmos y de la depuración
                    a1 = rand * 4 - 2;          % Número aleatorio en el rango [-2, 2]
                    a2 = rand * 0.07 - 0.035;   % Número aleatorio en el rango [-0.035, 0.035]
                    a3 = rand * 0.0002 - 0.0001;% Número aleatorio en el rango [-0.0001, 0.0001]

                    % Usar el atajo del radio de curvatura
                    R_c = rC_Crit(a3,a2,a1);

                    % Obtener el discriminante de la primera derivada de la función cúbica igualada a 0 con los valores generados
                    % Este sirve para encontrar el valor de x del punto crítico de la función después del ciclo (ver calculos.txt)
                    raiz = a2^2 - 3*a3*a1;

                    % Evitar soluciones imaginarias (y por ende evitando que no existan puntos críticos)
                    if raiz < 0
                        continue;
                    end

                    % Asegurando que el Radio de Curvatura sea menor a 50m en el punto crítico
                    if R_c < 0.0001
                        continue;
                    end

                    % Obtener longitud de arco y asegurarse de que sea entre 300 y 500m
                    s = longitudArco(a3,a2,a1);
                    if s < 300 || s > 500
                        continue;
                    end

                    % Obtener punto inicial y ajustar el término constante (a0) de acuerdo a ello
                    punto1 = funcionSina0(a3,a2,a1,30);
                    a0 = -punto1 + 230;

                    % Obtener el punto final, asegurandose de que sea (260,80), con una precisión de 0.01m
                    punto2 = funcion(a3,a2,a1,260,a0);
                    if punto2 >= 80.01 || punto2 <= 79.99
                        continue;
                    end
                end
            end

            %% Copia de la función anterior, pero involucrando los valores obtenidos
            % Solo habrá comentarios de aquello no explicado para la
            % primera función

            hold(app.UIAxes, 'on');
            cla(app.UIAxes)

            [y,Fs] = audioread("Drift.wav");
            [y2, Fs2] = audioread("Crash.wav");
            [y3, Fs3] = audioread("carro.wav");

            % Mostrar los valores obtenidos por el ciclo while
            app.a3EditField.Value = a3;
            app.a2EditField.Value = a2;
            app.a1EditField.Value = a1;
            app.a0EditField.Value = a0;

            % Regresa la segunda derivada evaluada en un x dado, de acuerdo a los coeficientes de la función original
            segderiv = @(a3,a2,a1,x) 6*a3*x + 2*a2;

            % Regresa el radio de curvatura en un x dado, de acuerdo a los coeficientes de la función original
            radioCurvatura = @(a3,a2,a1,x) ((1.0 + primderiv(a3,a2,a1,x)^2)^1.5) / abs(segderiv(a3,a2,a1,x));

            linea = @(rangox, x0, y0,a3,a2,a1) primderiv(a3,a2,a1,x0)*(rangox-x0) + y0;

            vel = app.RapidezInicialkmhEditField.Value;

            zonaRiesgo = [];

            for i = 1:500
                a = 30;
                b = 260;
                dx = (b-a)/499;
                rC_act = radioCurvatura(a3,a2,a1,a + dx*i);
                if rC_act < 50
                    zonaRiesgo(i) = a + dx*i;
                end
            end

            zonaRiesgo = nonzeros(zonaRiesgo)';

            app.LongituddepistamEditField.Value = longitudArco(a3,a2,a1);
            app.RadiodeCurvaturaenmximomEditField.Value = 1 / (2*sqrt(a2^2 - 3*a3*a1));

            x_valoresPol = linspace(30,260,500);
            y_valoresPol = funcion(a3,a2,a1,x_valoresPol,a0);

            plot(app.UIAxes, x_valoresPol,y_valoresPol, "-k","LineWidth", 10)
            plot(app.UIAxes, x_valoresPol,y_valoresPol, "--w", linewidth = 1.5)

            i = zonaRiesgo(1);

            sound(y3, Fs3)
            t = length(y) / Fs + 1;
            tiempoTranscurrido = 0;

            g = 9.81;
            theta = 5.7*pi/180;
            uk = 1.5;

            % Calcular la velocidad máxima usando la sumatoria de fuerzas
            % en x como base
            maxvel = sqrt(app.RadiodeCurvaturaenmximomEditField.Value*g*(sin(theta)/(cos(theta) - uk*sin(theta)) + (uk*cos(theta))/(cos(theta) - uk*sin(theta))));
            velms = vel/3.6;
            %% Sin derrape
            if velms < maxvel && velms > 0

                plotvelnorm = plot(app.UIAxes,x_valoresPol(1), y_valoresPol(1), 'diamondm', "MarkerSize", 5, "MarkerFaceColor", "m");

                for i=1:2:500
                    plotvelnorm.XData = x_valoresPol(i);
                    plotvelnorm.YData = y_valoresPol(i);

                    pause(0.05)
                    tiempoTranscurrido = tiempoTranscurrido + 0.05;
                    if tiempoTranscurrido >= t
                        sound(y3, Fs3)
                        tiempoTranscurrido = 0;
                    end
                end

                clear sound

                %% Con derrape
            elseif velms >= maxvel

                d = ((velms^2)*(cos(theta) - uk*sin(theta))) / (2*g*uk);

                plotvelexcedenteP1 = plot(app.UIAxes,x_valoresPol(1), y_valoresPol(1), 'diamondm', "MarkerSize", 5, "MarkerFaceColor", "m");
                normal = 1;

                while x_valoresPol(normal) < zonaRiesgo(1)

                    plotvelexcedenteP1.XData = x_valoresPol(normal);
                    plotvelexcedenteP1.YData = y_valoresPol(normal);

                    pause(0.05)
                    normal = normal + 2;
                end

                delete(plotvelexcedenteP1)
                clear sound
                sound(y, Fs)

                anguloTan = atan(primderiv(a3,a2,a1,zonaRiesgo(1)));

                distx = d*cos(anguloTan);

                rangoxtan = linspace(zonaRiesgo(1), zonaRiesgo(1) + distx, 101);
                rangoy = linea(rangoxtan,zonaRiesgo(1),funcion(a3,a2,a1,zonaRiesgo(1),a0),a3,a2,a1);

                plotvelexcedenteP2 = plot(app.UIAxes, rangoxtan(1), rangoy(1), 'diamondr',"MarkerSize", 5, "MarkerFaceColor", "r");

                for derrape = 1:2:101
                    plotvelexcedenteP2.XData = rangoxtan(derrape);
                    plotvelexcedenteP2.YData = rangoy(derrape);

                    pause(0.05)
                end

                sound(y2, Fs2)
                masa = 796;
                app.DistanciaRecorridaenDerrapemEditField.Value = velms^2*(cos(theta) - uk*sin(theta))/(2*g*uk);
                app.EnergaPerdidaenDerrapeJEditField.Value = velms^2*(masa)/2;
            end
        end

        % Button pushed function: 
        % IniciarSimulacinconCurvaPersonalizadaButton
        function IniciarSimulacinconCurvaPersonalizadaButtonPushed(app, event)
            % Esta función es exactamente igual a la primera, salvo que los
            % coeficientes del polinomio son aquellos insertados por el
            % usuario y que se ajusta aquello con el radio de curvatura en
            % el punto máximo/mínimo, ya que puede no existir.

            hold(app.UIAxes, 'on');
            cla(app.UIAxes)

            %{ Cargar Efectos de Sonido }%

            [y,Fs] = audioread("Drift.wav");
            [y2, Fs2] = audioread("Crash.wav");
            [y3, Fs3] = audioread("carro.wav");

            %{ Funciones }%

            % Validación de coeficientes
            if app.a3EditField.Value ~= 0
                a3 = app.a3EditField.Value;
                a2 = app.a2EditField.Value;
                a1 = app.a1EditField.Value;
                a0 = app.a0EditField.Value;
            else
                a3 = -0.00004696730597170429;
                a2 = 0.007198311361420753;
                a1 = 0.843898854917533;
                a0 = 199.47267138843134;
                app.a3EditField.Value = a3;
                app.a2EditField.Value = a2;
                app.a1EditField.Value = a1;
                app.a0EditField.Value = a0;
            end

            % Regresa la función evaluada en un x dado, de acuerdo a sus coeficientes
            funcion = @(x) a3*x.^3 + a2*x.^2 + a1*x + a0;

            % Regresa la primera derivada evaluada en un x dado, de acuerdo a los coeficientes de la función original
            primderiv = @(x) 3*a3*x.^2 + 2*a2*x + a1;

            % Regresa la segunda derivada evaluada en un x dado, de acuerdo a los coeficientes de la función original
            segderiv = @(x) 6*a3*x + 2*a2;

            % Regresa el radio de curvatura en un x dado, de acuerdo a los coeficientes de la función original
            radioCurvatura = @(x) ((1.0 + primderiv(x)^2)^1.5) / abs(segderiv(x));

            % Regresa el integrando de la funcion a integrar
            integrando = @(x) sqrt(1 + primderiv(x)^2);

            % Regresa la longitud de arco de acuerdo a los coeficientes de la función original
            function [suma_integral_final] = longitudArco()

                a = 30;  % Límite inferior
                b = 260; % Límite superior
                n = 499; % Número de iteraciones
                dx = (b-a)/n; % Paso
                suma_integral = 0; % Sumatoria de los trapecios

                % Se aplica la Regla del Trapecio con método numérico de integración
                for i = 1:n-1
                    xi(i) = a + dx*i;
                    suma_integral = suma_integral + integrando(xi(i)); % Sumar desde el segundo término hasta el penúltimo
                end

                suma_integral_final = (2 * suma_integral + integrando(a) + integrando(b)) * (dx/2);
            end

            linea = @(rangox, x0, y0) primderiv(x0)*(rangox-x0) + y0;

            vel = app.RapidezInicialkmhEditField.Value;

            %{ Zona de Derrape }%

            zonaRiesgo = [];

            for i = 1:500
                a = 30;
                b = 260;
                dx = (b-a)/499;
                rC_act = radioCurvatura(a + dx*i);
                if rC_act < 50
                    zonaRiesgo(i) = a + dx*i;
                end
            end

            zonaRiesgo = nonzeros(zonaRiesgo)';

            app.LongituddepistamEditField.Value = longitudArco();

            if a2^2 - 3*abs(a3)*abs(a1) >= 0
                app.RadiodeCurvaturaenmximomEditField.Value = 1 / (2*sqrt(a2^2 - 3*a3*a1));
            else
                app.RadiodeCurvaturaenmximomEditField.Value = Inf;
            end

            %% Graficar la función cúbica obtenida

            % Declarar un linspace de 30 a 260 y sus valores de y correspondientes
            x_valoresPol = linspace(30,260,500);
            y_valoresPol = funcion(x_valoresPol);

            % Graficar estos valores como líneas usando matplotlib
            plot(app.UIAxes, x_valoresPol,y_valoresPol, "-k","LineWidth", 10)

            %% Graficar la zona de riesgo

            % Graficar línea punteada con los valores de antes para que parezca calle
            plot(app.UIAxes, x_valoresPol,y_valoresPol, "--w", linewidth = 1.5)

            %% Graficar la recta tangente en la zona de riesgo

            sound(y3, Fs3)
            t = length(y) / Fs + 1;
            tiempoTranscurrido = 0;

            g = 9.81;
            theta = 5.7*pi/180;
            uk = 1.5;

            maxvel = sqrt(app.RadiodeCurvaturaenmximomEditField.Value*g*(sin(theta)/(cos(theta) - uk*sin(theta)) + (uk*cos(theta))/(cos(theta) - uk*sin(theta))));
            velms = vel/3.6;

            %% Sin derrape
            if velms < maxvel && velms > 0

                % Empezar con un punto para que se pueda modificar la variable
                plotvelnorm = plot(app.UIAxes,x_valoresPol(1), y_valoresPol(1), 'diamondm', "MarkerSize", 5, "MarkerFaceColor", "m");

                for i=1:2:500
                    plotvelnorm.XData = x_valoresPol(i); % Cambiar valor de x
                    plotvelnorm.YData = y_valoresPol(i); % Cambiar valor de Y

                    pause(0.05) % Para velocidad de gráfico constante
                    tiempoTranscurrido = tiempoTranscurrido + 0.05;
                    if tiempoTranscurrido >= t
                        sound(y3, Fs3)
                        tiempoTranscurrido = 0;
                    end
                end

                clear sound

                %% Con derrape
            elseif velms >= maxvel
                theta = 5.7*pi/180;
                uk = 1.5;
                g = 9.81;

                velms = vel/3.6;
                d = ((velms^2)*(cos(theta) - uk*sin(theta))) / (2*g*uk);

                % Empezar con un punto para que se pueda modificar la variable
                plotvelexcedenteP1 = plot(app.UIAxes,x_valoresPol(1), y_valoresPol(1), 'diamondm', "MarkerSize", 5, "MarkerFaceColor", "m");
                normal = 1;

                while x_valoresPol(normal) < 131.86372745490982

                    plotvelexcedenteP1.XData = x_valoresPol(normal);
                    plotvelexcedenteP1.YData = y_valoresPol(normal);

                    pause(0.05)
                    normal = normal + 2;
                end

                delete(plotvelexcedenteP1)
                clear sound
                sound(y, Fs)

                anguloTan = atan(primderiv(zonaRiesgo(1)));

                distx = d*cos(anguloTan);

                rangoxtan = linspace(i, i + distx, 101);
                rangoy = linea(rangoxtan,zonaRiesgo(1),funcion(zonaRiesgo(1)));

                plotvelexcedenteP2 = plot(app.UIAxes, rangoxtan(1), rangoy(1), 'diamondr',"MarkerSize", 5, "MarkerFaceColor", "r");

                for derrape = 1:2:101
                    plotvelexcedenteP2.XData = rangoxtan(derrape);
                    plotvelexcedenteP2.YData = rangoy(derrape);

                    pause(0.05)
                end
                sound(y2, Fs2)
                masa = 796;
                app.DistanciaRecorridaenDerrapemEditField.Value = velms^2*(cos(theta) - uk*sin(theta))/(2*g*uk);
                app.EnergaPerdidaenDerrapeJEditField.Value = velms^2*(masa)/2;

            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.749 0.9451 0.949];
            app.UIFigure.Position = [100 100 667 495];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Posición de Carro en Simulación de Derrape')
            xlabel(app.UIAxes, 'x [m]')
            ylabel(app.UIAxes, 'y [m]')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [200 129 441 367];

            % Create VelocidadInicialkmhLabel
            app.VelocidadInicialkmhLabel = uilabel(app.UIFigure);
            app.VelocidadInicialkmhLabel.HorizontalAlignment = 'right';
            app.VelocidadInicialkmhLabel.Position = [55 418 120 22];
            app.VelocidadInicialkmhLabel.Text = 'Rapidez Inicial (km/h)';

            % Create RapidezInicialkmhEditField
            app.RapidezInicialkmhEditField = uieditfield(app.UIFigure, 'numeric');
            app.RapidezInicialkmhEditField.LowerLimitInclusive = 'off';
            app.RapidezInicialkmhEditField.Limits = [0 Inf];
            app.RapidezInicialkmhEditField.ValueDisplayFormat = '%11.3f';
            app.RapidezInicialkmhEditField.HorizontalAlignment = 'center';
            app.RapidezInicialkmhEditField.Position = [73 382 77 22];
            app.RapidezInicialkmhEditField.Value = 95.676;

            % Create IniciarSimulacinButton
            app.IniciarSimulacinButton = uibutton(app.UIFigure, 'push');
            app.IniciarSimulacinButton.ButtonPushedFcn = createCallbackFcn(app, @IniciarSimulacinButtonPushed, true);
            app.IniciarSimulacinButton.BackgroundColor = [0.4078 0.6706 0.702];
            app.IniciarSimulacinButton.FontWeight = 'bold';
            app.IniciarSimulacinButton.Position = [49 337 125 30];
            app.IniciarSimulacinButton.Text = 'Iniciar Simulación';

            % Create ControldelasimulacinLabel
            app.ControldelasimulacinLabel = uilabel(app.UIFigure);
            app.ControldelasimulacinLabel.HorizontalAlignment = 'center';
            app.ControldelasimulacinLabel.FontWeight = 'bold';
            app.ControldelasimulacinLabel.Position = [40 463 144 22];
            app.ControldelasimulacinLabel.Text = 'Control de la simulación';

            % Create EnergaPerdidaenDerrapeLabel
            app.EnergaPerdidaenDerrapeLabel = uilabel(app.UIFigure);
            app.EnergaPerdidaenDerrapeLabel.HorizontalAlignment = 'right';
            app.EnergaPerdidaenDerrapeLabel.Position = [29 98 172 22];
            app.EnergaPerdidaenDerrapeLabel.Text = 'Energía Perdida en Derrape (J)';

            % Create EnergaPerdidaenDerrapeJEditField
            app.EnergaPerdidaenDerrapeJEditField = uieditfield(app.UIFigure, 'numeric');
            app.EnergaPerdidaenDerrapeJEditField.ValueDisplayFormat = '%e';
            app.EnergaPerdidaenDerrapeJEditField.Editable = 'off';
            app.EnergaPerdidaenDerrapeJEditField.HorizontalAlignment = 'center';
            app.EnergaPerdidaenDerrapeJEditField.Position = [62 62 100 22];

            % Create LongituddepistamEditFieldLabel
            app.LongituddepistamEditFieldLabel = uilabel(app.UIFigure);
            app.LongituddepistamEditFieldLabel.HorizontalAlignment = 'right';
            app.LongituddepistamEditFieldLabel.Position = [53 301 118 22];
            app.LongituddepistamEditFieldLabel.Text = 'Longitud de pista (m)';

            % Create LongituddepistamEditField
            app.LongituddepistamEditField = uieditfield(app.UIFigure, 'numeric');
            app.LongituddepistamEditField.Editable = 'off';
            app.LongituddepistamEditField.HorizontalAlignment = 'center';
            app.LongituddepistamEditField.Position = [62 271 100 22];

            % Create RadiodeCurvaturaenmximomEditFieldLabel
            app.RadiodeCurvaturaenmximomEditFieldLabel = uilabel(app.UIFigure);
            app.RadiodeCurvaturaenmximomEditFieldLabel.HorizontalAlignment = 'right';
            app.RadiodeCurvaturaenmximomEditFieldLabel.Position = [17 238 193 22];
            app.RadiodeCurvaturaenmximomEditFieldLabel.Text = 'Radio de Curvatura en máximo (m)';

            % Create RadiodeCurvaturaenmximomEditField
            app.RadiodeCurvaturaenmximomEditField = uieditfield(app.UIFigure, 'numeric');
            app.RadiodeCurvaturaenmximomEditField.Editable = 'off';
            app.RadiodeCurvaturaenmximomEditField.HorizontalAlignment = 'center';
            app.RadiodeCurvaturaenmximomEditField.Position = [62 207 100 22];

            % Create DistanciaRecorridaenDerrapemEditFieldLabel
            app.DistanciaRecorridaenDerrapemEditFieldLabel = uilabel(app.UIFigure);
            app.DistanciaRecorridaenDerrapemEditFieldLabel.HorizontalAlignment = 'right';
            app.DistanciaRecorridaenDerrapemEditFieldLabel.Position = [17 169 195 22];
            app.DistanciaRecorridaenDerrapemEditFieldLabel.Text = 'Distancia Recorrida en Derrape (m)';

            % Create DistanciaRecorridaenDerrapemEditField
            app.DistanciaRecorridaenDerrapemEditField = uieditfield(app.UIFigure, 'numeric');
            app.DistanciaRecorridaenDerrapemEditField.Editable = 'off';
            app.DistanciaRecorridaenDerrapemEditField.HorizontalAlignment = 'center';
            app.DistanciaRecorridaenDerrapemEditField.Position = [62 129 100 22];

            % Create IniciarSimulacinconCreacindeNuevaCurvaButton
            app.IniciarSimulacinconCreacindeNuevaCurvaButton = uibutton(app.UIFigure, 'push');
            app.IniciarSimulacinconCreacindeNuevaCurvaButton.ButtonPushedFcn = createCallbackFcn(app, @IniciarSimulacinconCreacindeNuevaCurvaButtonPushed, true);
            app.IniciarSimulacinconCreacindeNuevaCurvaButton.BackgroundColor = [0.9608 0.4706 0.4706];
            app.IniciarSimulacinconCreacindeNuevaCurvaButton.FontWeight = 'bold';
            app.IniciarSimulacinconCreacindeNuevaCurvaButton.Position = [299 92 295 23];
            app.IniciarSimulacinconCreacindeNuevaCurvaButton.Text = 'Iniciar Simulación con Creación de Nueva Curva';

            % Create a3EditFieldLabel
            app.a3EditFieldLabel = uilabel(app.UIFigure);
            app.a3EditFieldLabel.HorizontalAlignment = 'right';
            app.a3EditFieldLabel.Position = [241 25 25 22];
            app.a3EditFieldLabel.Text = 'a3';

            % Create a3EditField
            app.a3EditField = uieditfield(app.UIFigure, 'numeric');
            app.a3EditField.HorizontalAlignment = 'center';
            app.a3EditField.Position = [277 25 66 22];
            app.a3EditField.Value = -4.69673059717043e-05;

            % Create a2EditFieldLabel
            app.a2EditFieldLabel = uilabel(app.UIFigure);
            app.a2EditFieldLabel.HorizontalAlignment = 'right';
            app.a2EditFieldLabel.Position = [342 25 25 22];
            app.a2EditFieldLabel.Text = 'a2';

            % Create a2EditField
            app.a2EditField = uieditfield(app.UIFigure, 'numeric');
            app.a2EditField.HorizontalAlignment = 'center';
            app.a2EditField.Position = [378 25 64 22];
            app.a2EditField.Value = 0.00719831136142075;

            % Create a1EditFieldLabel
            app.a1EditFieldLabel = uilabel(app.UIFigure);
            app.a1EditFieldLabel.HorizontalAlignment = 'right';
            app.a1EditFieldLabel.Position = [441 25 25 22];
            app.a1EditFieldLabel.Text = 'a1';

            % Create a1EditField
            app.a1EditField = uieditfield(app.UIFigure, 'numeric');
            app.a1EditField.HorizontalAlignment = 'center';
            app.a1EditField.Position = [477 25 68 22];
            app.a1EditField.Value = 0.843898854917533;

            % Create a0EditFieldLabel
            app.a0EditFieldLabel = uilabel(app.UIFigure);
            app.a0EditFieldLabel.HorizontalAlignment = 'right';
            app.a0EditFieldLabel.Position = [544 25 25 22];
            app.a0EditFieldLabel.Text = 'a0';

            % Create a0EditField
            app.a0EditField = uieditfield(app.UIFigure, 'numeric');
            app.a0EditField.HorizontalAlignment = 'center';
            app.a0EditField.Position = [580 25 62 22];
            app.a0EditField.Value = 199.472671388431;

            % Create CoeficientesdePolinomioPersonalizadoLabel
            app.CoeficientesdePolinomioPersonalizadoLabel = uilabel(app.UIFigure);
            app.CoeficientesdePolinomioPersonalizadoLabel.Position = [20 25 228 22];
            app.CoeficientesdePolinomioPersonalizadoLabel.Text = 'Coeficientes de Polinomio Personalizado:';

            % Create IniciarSimulacinconCurvaPersonalizadaButton
            app.IniciarSimulacinconCurvaPersonalizadaButton = uibutton(app.UIFigure, 'push');
            app.IniciarSimulacinconCurvaPersonalizadaButton.ButtonPushedFcn = createCallbackFcn(app, @IniciarSimulacinconCurvaPersonalizadaButtonPushed, true);
            app.IniciarSimulacinconCurvaPersonalizadaButton.BackgroundColor = [0.498 0.9216 0.4706];
            app.IniciarSimulacinconCurvaPersonalizadaButton.FontWeight = 'bold';
            app.IniciarSimulacinconCurvaPersonalizadaButton.Position = [313 62 267 23];
            app.IniciarSimulacinconCurvaPersonalizadaButton.Text = 'Iniciar Simulación con Curva Personalizada';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Entregable4

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end