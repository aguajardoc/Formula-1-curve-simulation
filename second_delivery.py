import random
import numpy as np
import math
import matplotlib.pyplot as plt
import time

''' Funciones '''

# Regresa la función evaluada en un x dado, de acuerdo a sus coeficientes
funcion = lambda a3,a2,a1,x,a0=0: a3*(x**3) + a2*(x**2) + a1*x + a0

# Regresa la primera derivada evaluada en un x dado, de acuerdo a los coeficientes de la función original
primderiv = lambda a3,a2,a1,x: 3*a3*x**2 + 2*a2*x + a1

# Regresa la segunda derivada evaluada en un x dado, de acuerdo a los coeficientes de la función original
segderiv = lambda a3,a2,a1,x: 6*a3*x + 2*a2

# Regresa el radio de curvatura en un x dado, de acuerdo a los coeficientes de la función original
radioCurvatura = lambda a3,a2,a1,x: ((1.0 + primderiv(a3,a2,a1,x)**2) ** 1.5) / np.abs(segderiv(a3,a2,a1,x))

# Regresa un valor relacionado al radio de curvatura en los puntos críticos de la función, solo sirve como atajo exclusivamente para esos puntos
rC_Crit = lambda a3,a2,a1: a2**2 - 3*a3*a1

# Regresa el integrando de la funcion a integrar
integrando = lambda a3, a2, a1, x: math.sqrt(1+ primderiv(a3,a2,a1,x)**2)

# Regresa la longitud de arco de acuerdo a los coeficientes de la función original
def longitudArco(a3,a2,a1):

    a = 30  # Límite inferior
    b = 260 # Límite superior
    n = 499 # Número de iteraciones
    dx = (b-a)/n # Paso
    suma_integral = 0 # Sumatoria de los trapecios
    
    # Se aplica la Regla del Trapecio con método numérico de integración
    for i in range(1, n):
        x_i = a + dx*i
        suma_integral += integrando(a3,a2,a1,x_i) # Sumar desde el segundo término hasta el penúltimo
    suma_integral = (2*suma_integral + integrando(a3,a2,a1,a) + integrando(a3,a2,a1,b)) * (dx/2) # Multiplicar la suma por dos, sumar el primero y el último término, multiplicar por h/2
    return suma_integral

''' Casos de prueba básicos '''

test = longitudArco(0,0,1)
# test debe ser aproximadamente 325.269119346 [Correcto]

test2 = funcion(1,1,1,2,7)
# test2 debe ser igual a 21 [Correcto]

test3 = primderiv(1,1,1,2)
# test3 debe ser igual a 17 [Correcto]

test4 = segderiv(1,1,123456789,2)
# test4 debe ser igual a 14 [Correcto]

test5 = radioCurvatura(2,3,4,5)
# test5 debe ser aproximadamente 94390.6060915 [Correcto]

test6 = rC_Crit(2,3,4)
# test6 debe ser igual a -15 [Correcto]

test7 = integrando(2,3,4,8)
# test7 debe ser aproximadamente 436.001146787 [Correcto]

''' Generación y validación de coeficientes '''

# Definir parámetros para poder iniciar el ciclo
R_c2 = 50. # Radio de curvatura en puntos críticos
s = 299. # Longitud de arco

# Términos correspondientes al polinomio cúbico
a0 = 0.
a1 = 0.
a2 = 0.
a3 = 0.

# Punto final en y
punto2 = 0.

# Inicializar un contador de iteraciones de generaciones de los coeficientes de la función intentados
iteraciones = 0

# Empezar a contar el tiempo
starttime = time.time()

# Mientras el radio de la circun
while R_c2 > 50 or s < 300 or s > 500 or punto2 >= 80.01 or punto2 <= 79.99:

    # Declarar parámetros como 0 para insertar en el segundo while
    a1 = 0
    a2 = 0
    a3 = 0

    # Asegurarse de que los coeficientes sean distintos a 0, especialmente importante para a3, ya que debe ser una función cúbica
    while(a1 == 0 or a2 == 0 or a3 == 0):

        # Generación aleatoria de floats de acuerdo a pruebas realizadas previamente por medio de Desmos y de la depuración
        a1 = random.uniform(-2,2)
        a2 = random.uniform(-0.035,0.035)
        a3 = random.uniform(-0.0001,0.0001)
        iteraciones += 1

    # Usar el atajo del radio de curvatura
    R_c = rC_Crit(a3,a2,a1)

    # Obtener el discriminante de la primera derivada de la función cúbica igualada a 0 con los valores generados
    # Este sirve para encontrar el valor de x del punto crítico de la función después del ciclo (ver calculos.txt)
    raiz = a2**2 - 3*a3*a1

    # Evitar soluciones imaginarias (y por ende evitando que no existan puntos críticos)
    if raiz < 0:
        continue

    # Asegurando que el Radio de Curvatura sea menor a 50m en el punto crítico
    if R_c < 0.0001:
        continue
    
    # Obtener longitud de arco y asegurarse de que sea entre 300 y 500m
    s = longitudArco(a3,a2,a1)
    if s < 300 or s > 500:
        continue
    
    # Obtener punto inicial y ajustar el término constante (a0) de acuerdo a ello
    punto1 = funcion(a3,a2,a1,30)
    a0 = -punto1 + 230
    
    # Obtener el punto final, asegurandose de que sea (260,80), con una precisión de 0.01m
    punto2 = funcion(a3,a2,a1,260, a0)
    if punto2 >= 80.01 or punto2 <= 79.99:
        continue

# Parar de contar el tiempo
endtime = time.time()
timetaken = endtime - starttime

# Obtener el centro en x del círculo, equivalente a la posición del punto crítico
# Es necesario obtenerlo ahora ya que el radio de la curvatura depende de este punto
centroX = (-a2 + math.sqrt(a2**2 - 3*a3*a1)) / (3*a3)

# Si es negativo o por alguna otra razón está fuera del rango, se está tomando el valor de x incorrecto (i.e. era un máximo pero se estaba tomando el mínimo o viceversa), por lo que se corrige
if centroX < 30 or centroX > 260:
    centroX = (-a2 - math.sqrt(raiz)) / (3*a3)

# Calcular radio de curvatura, sin atajos
R_c2 = radioCurvatura(a3,a2,a1,centroX)

# Imprimir que se ha encontrado un valor, incluyendo estadísticas de tiempo e iteraciones
print(f"\n\033[1m¡Polinomio Encontrado!\033[0m\nEste proceso tardó {timetaken} segundos, y revisó {iteraciones} combinaciones de coeficientes del polinomio cúbico.\n")

# Imprimir datos relevantes
print("Radio de curvatura en punto crítico: ", R_c2)
print("Longitud de arco: ", s)
print("a3: ", a3)
print("a2: ", a2)
print("a1: ", a1)
print("a0: ", a0)
print(f"Punto final: (260, {punto2})")

''' Gráficos '''

## Graficar la función cúbica obtenida

# Declarar un linspace de 30 a 260 y sus valores de y correspondientes
x_valores = np.linspace(30,260)
y_valores = funcion(a3,a2,a1,x_valores,a0)

# Graficar estos valores como una línea azul usando matplotlib
plt.plot(x_valores,y_valores, "-b")

## Graficar el círculo tangente

# centroX = centroX // Recordar que ya se ha definido

# El centro en y del círculo es la función evaluada en el centroX y trasladada por el radio de curvatura
if segderiv(a3,a2,a1,centroX) < 0: # Es un máximo y por ende se traslada hacia abajo
    centroY = funcion(a3, a2, a1, centroX, a0) - R_c2
else:
    centroY = funcion(a3, a2, a1, centroX, a0) + R_c2

# Determinar parámetros del círculo
circulo = plt.Circle((centroX, centroY), radius=R_c2, edgecolor='r', facecolor='none')
plt.gca().add_patch(circulo)    # gca = "get current axes", análogo al "hold on" en MATLAB. El método add_patch agrega el círculo a los ejes (en este caso los actuales)

## Graficar los puntos inicial y final
plt.scatter([30,260],[punto1 + a0,punto2], color='magenta', label='Puntos inicial y final')

# Mostrar texto a un lado de los puntos
plt.text(30, punto1 + a0, f"({30}, {punto1 + a0})") # punto1 + a0 siempre será igual a 230
plt.text(260, punto2, f"({260}, {punto2:.4f})")     # punto2 redondeado a 4 decimales

# Etiquetas de los ejes y leyenda
plt.xlabel("X")
plt.ylabel("Y")
plt.legend(["Curva Generada","Circunferencia Tangente"])

# Mostrar plot con ejes iguales :)
plt.axis("equal")
plt.show()
