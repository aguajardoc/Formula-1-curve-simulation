'''
Entregable 3 del Reto

Alejandro Guajardo Caba - A01178375
Ricardo Manuel Barbosa Flores - A00823815
Homero Maximiliano Flores Betancourt - A00840253

F1005B: Modelación Computacional Aplicando Leyes de Conservación
Profesor: Gerardo Ramón Fox

'''

import numpy as np
import matplotlib.pyplot as plt

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

# Graficar estos valores como líneas usando matplotlib
plt.plot(x_valoresPol,y_valoresPol, "-k",linewidth = 10, label = "Curva Generada")

# Declarar un linspace de la zona de riesgo y sus valores de y correspondientes
x_valores = np.linspace(zonaRiesgo[0],zonaRiesgo[-1],len(zonaRiesgo))
y_valores = list(range(len(zonaRiesgo)))

for i in range(len(zonaRiesgo)):
    y_valores[i] = funcion(zonaRiesgo[i])

# Graficar estos valores como una línea azul usando matplotlib
plt.plot(x_valores,y_valores[::], color="#FFEA00", linewidth=10.6, label = "Zona de Derrape/Riesgo")

# Graficar línea punteada con los valores de antes
plt.plot(x_valoresPol,y_valoresPol, "--w", linewidth = 1.5)

# Graficar la recta tangente en cualquier punto de la zona de riesgo
i = zonaRiesgo[0]
j = zonaRiesgo[-1]

x0 = i
y0 = funcion(i)

x02 = j
y02 = funcion(j)

rangox = np.linspace(x0 - 10, x0 + 80)
rangox2 = np.linspace(x02 - 10, x02 + 80)

linea = lambda rangox, x0, y0: pendiente(x0)*(rangox-x0) + y0

rayas = [2,2]

plt.gca().plot(rangox, linea(rangox,x0,y0), 'c--', linewidth = 1.5, dashes = rayas, label = "Recta Tangente Inicial")
plt.gca().plot(rangox2, linea(rangox2,x02,y02), 'm--', linewidth = 1.5, dashes = rayas, label = "Recta Tangente Final")

# Gradas de 80m x 10m
grada1 = plt.Rectangle([147.7,348.7], -80, 10, angle = 27, rotation_point = "xy")
grada2 = plt.Rectangle([221,267.1], 80, 10, angle = -73, rotation_point = "xy")
plt.gca().add_patch(grada1)
plt.gca().add_patch(grada2)

# Etiquetas de los ejes y leyenda
plt.xlabel("X")
plt.ylabel("Y")
plt.legend()

# Mostrar plot con ejes iguales :)
plt.axis("equal")
plt.show()