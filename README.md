# Simulation of a Formula 1 Curve

## final_delivery.mlapp

MATLAB App that simulates a Formula 1 car's path over a computer generated curve. The app shows whether a car would drift out of a curve, depending on its speed, calculating the distance it would travel and the energy lost as heat during the drift. The app also includes sound effects for dramatic effect, emphasizing the importance of driver security during high-speed races.

The default curve is a third degree polynomial, whose values can be changed within the app to better suit user needs. Additionally, a completely new curve can be generated with random values which can be adjuusted later on if necessary.

This app was designed as a final project during my first semester at university. The course was taught in Spanish, so all elements of the app are implemented in Spanish.

Because of the academic nature of this project, the generated curve has to abide to a list of requirements, presented below.

Restrictions for the generated curve:
- The curve must be within 300 and 500 meters in length.
- The starting point must be (30, 230) in the cartesian coordinate system.
- The ending point must be on or about (260, 80) in the cartesian coordinate system.
- The radius of curvature must be less than 50 meters at any given point, preferably at local extrema.

## final_delivery.m
Contains the same code, but can't be run as a MATLAB App; it allows viewing of the source code without downloading the .mlapp file.

## second_delivery.py
Python script that generates a curve from scratch, using the random, numpy, math, and matplotlib libraries. After generating the curve, the program prints the time it took to generate it (using the time library), the data relevant to the polynomial, and displays a graph of the curve with the circle tangent to the curve at a local extremum. This code was then adapted in the MATLAB App to use MATLAB syntax.

## third_delivery.py
Based on a curve generated with the second_delivery.py file, this program determines its "Danger Zone", in which a Formula 1 car could unexpectedly drift. Using matplotlib and numpy, the script then displays the curve's graph with an adequate placement for spectator areas, along with the possible path a car could take if it drifted: tangent to the curve at the first point of the Danger Zone.

## calculos.txt
Establishes an explanation for a process performed in the second_delivery.py code.

## Crash.wav, Drift.wav, carro,wav
Audio files for the car's sound effects, played while running the MATLAB App.

## How to run

### 1. Download the .mlapp file
Although both, .mlapp and .m, files contain the same code, only the mlapp file can execute the code as a MATLAB App.

### 2. Open the latest version of MATLAB
### 3. Click on "Design App" within the "APPS" tab
### 4. Open the .mlapp file on the left side of the App Designer
### 5. Press F5 to run
### 6. Play with the app's features ;)

## Note 
The final_delivery.m file allows visualization of the code without downloading the .mlapp file
