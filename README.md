# Bachelor's Degree Thesis 👨‍💻🌱
## Creation of a Greenhouse with Raspberry
This Bachelor's Degree thesis aims to develop an embedded system that can control a greenhouse by collecting data from various sensors and controlling actuators to maintain optimal growing conditions for plants. All the data processed by the embedded system will be saved in a very simple Cloud Infrastructure. Moreover, the system will also incorporate a user-friendly interface (Flutter application) to enable the user to monitor the greenhouse remotely, dowloading data from the Cloud.

⚠️Unfortunately the [paper of the thesis](/RelazioneTesi.pdf) is written in Italian. Here, in this Readme file, I will try to explain very shortly how the system is organized.

## 🧑‍💻 Components of the team
- Matteo Carminati
- Lorenzo Torri

## 📂 Explanation of the repositories
In the folder [Modelli](/Modelli) there is a statechart UML representations of the project. 

In the folder [Codice/v4](/Codice/v4) there are all the .py files used to control Raspberry. In particular those files are in charge of getting data from sensors, analyze those data and then operate though the attuators when needed.
In particular the file [controller.py](/Codice/v4/Controller.py) is the one used to control Raspberry, in order to schedule all the tasks and to parallelize them.

In the folder [Codice/AWS](/Codice/AWS) there are all the .py files to create the Cloud Infrastructure.

In the folder [AppMobile/serra_app](/AppMobile/serra_app) there are all the files generated automatically by Flutter to run the application. In particular in the folder [AppMobile/serra_app/lib](/AppMobile/serra_app/lib) there are all the .dart files used for the user interface.

## Structure of the system
The thesis project is mainly composed of three components:
1. The Embedded system 📟🌱
2. The Cloud architecture ☁️
3. The Mobile application 📲

In particular, the first component is entirely dedicated to the control of environmental parameters and the functioning of the greenhouse itself; the second is responsible for saving the data processed by Raspberry in the Cloud; the third is used to display what is saved remotely, thus being able to monitor the Embedded system.

## Sensors and Attuators used
- DHT22 sensor to measure the temperature and relative humidity of the greenhouse. 

![Image](/Images/DHT22.png)

- CAPACITIVE SOIL MOISTURE sensor to measure the humidity of the soil.
 
![Image](/Images/CSMS.png)

- HC-SR04 sensor to monitor the level of water inside the tank used for irrigation, in order to notify the user when the tank is empty. 

![Image](/Images/HCSR04.png)

- As actuators: some pumps, a fan, and a LED strip.

Here there is a circuit map of all the electronic devices connected together
![Image](/Images/Circuits.png)

## Explanation of the StateChart, with Multithreading Tasking
We proceed to explain the scheduling of activities carried out by Raspberry, analyzing the possible states in which the system can be found.
The operating cycle of the Raspberry board continues to alternate between two macrostates:
- "lights off"
- "lights on"
During the time period between 08:00 and 20:00, Raspberry closes the circuit with the LEDs and turns them on, while after 20:00 until 08:00 of the following day, all activities on the board are interrupted and the lights are turned off. This is how the light and dark cycle for the greenhouse has been managed.

When the lights are on, the two main threads are active. They manage an alternation in measurements between the two sensors, the DHT22 and the Capacitive Soil Moisture Sensor. The two threads also share a lock, which must be acquired to perform a measurement. Therefore, when the "lights on" phase starts, the system enters an idle state, waiting for one of the two threads to acquire the lock. Depending on which thread has the lock, the system proceeds in one of two directions, "DHT22 Reading" or "Capacitive Reading". At the end of these macro operations, the system returns to the central area of the state chart to release the lock and enter a subsequent idle state
1. "DHT22 Reading" 
The measurement is taken using the sensor, and then the new measurement is saved in a queue of values. The subsequent decisions are made based on the average of this data structure. 
- If the average of the air humidity measurements falls within a pre-established minimum and maximum value, then we are in an ideal situation, and we return to the lock release phase. 
- If, on the other hand, the air humidity average is greater than an acceptable maximum value, the fan is turned on and then off with the aim of reducing the humidity level through air recirculation. 
- If the average is less than an acceptable minimum value, the humidification pump is turned on to increase the humidity beyond the minimum level allowed

2. "Capacitive Reading"
Also in this case the measurement is saved in a queue of values, then the subsequent decisions are made based on the average of this data structure
- If the average soil humidity is greater than an acceptable minimum value, then we return to the lock release phase. 
- In the opposite case, we are in a situation where the soil moisture is too low, meaning that the plant needs to be irrigated. Therefore, we enter the "Irrigation" state, which turns on and then off the pump dedicated to irrigation. Additionally, the HC-SR04 sensor, located on the tank cap, is activated to monitor the new water level after irrigation. Moreover after each irrigation a counter is increased, and each time this counter is a multiple of a value X, we fertilize the soil.

## Cloud Infrastructure
The cloud infrastructure is done using AWS Technologies. In particular we used a bucket s3 to store data and two lambda functions to control the calls to the API Gateway.
- The Raspberry board processes data that needs to be saved remotely, so an HTTP `POST` call is made to the API Gateway URL + `"/upload"` to achieve this result.
- The application can retrieve such data with a call to the API Gateway URL + `/download`

![Image](/Images/Cloud.png)
