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

''' Zona de Derrape '''

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

# Validación del radio de curvatura en la zona de riesgo
#print(f"Radio de Curvatura en zona de riesgo: {zonaRiesgoCurv[::]}")

### Obtención de la Zona de Riesgo
print(f"\nRango de puntos en x de la Zona de Riesgo: {zonaRiesgo[0]}, {zonaRiesgo[-1]}\n")

## Graficar la función cúbica obtenida

# Declarar un linspace de 30 a 260 y sus valores de y correspondientes
x_valoresPol = np.linspace(30,260,500)
y_valoresPol = funcion(x_valoresPol)

# Graficar estos valores como líneas usando matplotlib
plt.plot(x_valoresPol,y_valoresPol, "-k",linewidth = 10, label = "Curva Generada")

## Graficar la zona de riesgo

# Declarar un linspace de la zona de riesgo y sus valores de y correspondientes
x_valores = np.linspace(zonaRiesgo[0],zonaRiesgo[-1],len(zonaRiesgo))
y_valores = list(range(len(zonaRiesgo)))

for i in range(len(zonaRiesgo)):
    y_valores[i] = funcion(zonaRiesgo[i])

# Graficar estos valores usando matplotlib
plt.plot(x_valores,y_valores[::], color="#FFEA00", linewidth=10.6, label = "Zona de Derrape/Riesgo")

# Graficar línea punteada con los valores de antes para que parezca calle
plt.plot(x_valoresPol,y_valoresPol, "--w", linewidth = 1.5)

## Graficar la recta tangente en la zona de riesgo
i = zonaRiesgo[0]
j = zonaRiesgo[-1]

x0 = i
y0 = funcion(i)

x02 = j
y02 = funcion(j)

rangox = np.linspace(x0 - 10, x0 + 80)
rangox2 = np.linspace(x02 - 10, x02 + 80)

# Función de la recta tangente
linea = lambda rangox, x0, y0: pendiente(x0)*(rangox-x0) + y0
# Función de la recta normal
normal = lambda rangox, x0, y0: (-1/(pendiente(x0))) * (rangox-x0) + y0

# Valor que determina la longitud de las rayas punteadas, correspondiente al parámtero "dashes"
rayas = [2,2]

# En los ejes actuales, graficar: el rango de x como valores de x, aquellos evaluados en la función de la recta tangente como y.
plt.gca().plot(rangox, linea(rangox,x0,y0), 'c--', linewidth = 1.5, dashes = rayas, label = "Recta Tangente Inicial") # Color cián
plt.gca().plot(rangox2, linea(rangox2,x02,y02), 'm--', linewidth = 1.5, dashes = rayas, label = "Recta Tangente Final") # Color magenta
plt.gca().plot(rangox, normal(rangox,x0,y0), 'r--', linewidth = 1.5, dashes = rayas, label = "Recta Normal Inicial")

### Gradas de 80m x 10m (angle = tan^{-1} (pendiente(x0)))
grada1 = plt.Rectangle([zonaRiesgo[0],funcion(zonaRiesgo[0]) + 15], 80, 10, angle = 16.29, rotation_point = "xy")
plt.gca().add_patch(grada1)

# Etiquetas de los ejes y leyenda
plt.xlabel("X [m]")
plt.ylabel("Y [m]")
plt.legend()

# Mostrar plot con ejes iguales :)
plt.axis("equal")
plt.show()