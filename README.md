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
- CAPACITIVE SOIL MOISTURE sensor to measure the humidity of the soil.
- HC-SR04 sensor to monitor the level of water inside the tank used for irrigation, in order to notify the user when the tank is empty.
- As actuators: some pumps, a fan, and a LED strip.

Here there is a circuit map of all the electronic devices connected together
![Image](/Images/Circuits.png)
