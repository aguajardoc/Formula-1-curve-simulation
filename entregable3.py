'''
Entregable 3 del Reto

Alejandro Guajardo Caba - A01178375
Ricardo Manuel Barbosa Flores - A00823815
Homero Maximiliano Flores Betancourt - A00840253

F1005B: Modelación Computacional Aplicando Leyes de Conservación
Profesor: Gerardo Ramón Fox

'''

import random
import numpy as np
import math
import matplotlib.pyplot as plt
import time

''' Funciones '''

a3 = -0.00004696730597170429
a2 = 0.007198311361420753
a1 = 0.843898854917533
a0 = 199.47267138843134

# Regresa la función evaluada en un x dado, de acuerdo a sus coeficientes
funcion = lambda x: a3*(x**3) + a2*(x**2) + a1*x + a0

# Regresa la primera derivada evaluada en un x dado, de acuerdo a los coeficientes de la función original
primderiv = lambda x: 3*a3*x**2 + 2*a2*x + a1

# Regresa la segunda derivada evaluada en un x dado, de acuerdo a los coeficientes de la función original
segderiv = lambda x: 6*a3*x + 2*a2

# Regresa el radio de curvatura en un x dado, de acuerdo a los coeficientes de la función original
radioCurvatura = lambda x: ((1.0 + primderiv(x)**2) ** 1.5) / np.abs(segderiv(x))

# Regresa la pendiente de la recta tangente en cualquier punto (pero se usa para la zona de riesgo)
pendiente = lambda x: 3*a3*(x**2) + 2*a2*x + a1

''' Zonas de Derrape '''

zonaRiesgo = []
zonaRiesgoCurv = []
for i in range(500):
    a = 30
    b = 260
    dx = (b-a)/499
    rC_act = radioCurvatura(a + dx*i)
    if rC_act < 50:
        zonaRiesgoCurv.append(rC_act)
        zonaRiesgo.append(a + dx*i)

print(f"Radio de Curvatura en zona de riesgo: {zonaRiesgoCurv[::]}")
print(f"\n\n\Rango de puntos de Zona de Riesgo: {zonaRiesgo[0]}, {zonaRiesgo[-1]} ")

## Graficar la función cúbica obtenida

# Declarar un linspace de 30 a 260 y sus valores de y correspondientes
x_valoresPol = np.linspace(30,260,500)
y_valoresPol = funcion(x_valoresPol)

# Graficar estos valores como una línea azul usando matplotlib
plt.plot(x_valoresPol,y_valoresPol, "-b")

# Declarar un linspace de 30 a 260 y sus valores de y correspondientes
x_valores = np.linspace(zonaRiesgo[0],zonaRiesgo[-1],len(zonaRiesgo))
y_valores = list(range(len(zonaRiesgo)))

for i in range(len(zonaRiesgo)):
    y_valores[i] = funcion(zonaRiesgo[i])

# Graficar estos valores como una línea azul usando matplotlib
plt.plot(x_valores,y_valores[::], "-r", linewidth = 3)

## Graficar los puntos inicial y final
plt.scatter([30,260],[230, 79.99485194035822], color='magenta', label='Puntos inicial y final')

# Graficar la recta tangente en cualquier punto de la zona de riesgo
#for i in zonaRiesgo:
i = float(input("Punto de la lista: "))

x0 = i
y0 = funcion(i)

rangox = np.linspace(x0 - 50, x0 + 50)

linea = lambda rangox, x0, y0: pendiente(x0)*(rangox-x0) + y0
plt.gca().plot(rangox, linea(rangox,x0,y0), 'c--', linewidth = 1)


# Mostrar texto a un lado de los puntos
plt.text(30, 230 + a0, f"({30}, {230})") # punto1 + a0 siempre será igual a 230
plt.text(260, 79.99485194035822, f"({260}, {79.99485194035822:.4f})")     # punto2 redondeado a 4 decimales

# Etiquetas de los ejes y leyenda
plt.xlabel("X")
plt.ylabel("Y")
plt.legend(["Curva Generada","Zona de Riesgo","Rectas Tangentes"])

# Mostrar plot con ejes iguales :)
plt.axis("equal")
plt.show()