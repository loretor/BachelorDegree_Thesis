# Bachelor's Degree Thesis 👨‍💻
This Bachelor's Degree thesis aims to develop an embedded system that can control a greenhouse by collecting data from various sensors and controlling actuators to maintain optimal growing conditions for plants. All the data processed by the embedded system will be saved in a very simple Cloud Infrastructure. Moreover, the system will also incorporate a user-friendly interface (Flutter application) to enable the user to monitor the greenhouse remotely, dowloading data from the Cloud.

# 🧑‍💻 Components of the team
- Matteo Carminati
- Lorenzo Torri

# 📂 Explanation of the repositories
In the folder [Modelli](/Modelli) there is a statechart UML representations of the project. 

In the folder [Codice/v4](/Codice/v4) there are all the .py files used to control Raspberry. In particular those files are in charge of getting data from sensors, analyze those data and then operate though the attuators when needed.
In particular the file [controller.py](/Codice/v4/Controller.py) is the one used to control Raspberry, in order to schedule all the tasks and to parallelize them.

In the folder [Codice/AWS](/Codice/AWS) there are all the .py files to create the Cloud Infrastructure.

In the folder [AppMobile/serra_app](/AppMobile/serra_app) there are all the files generated automatically by Flutter to run the application. In particular in the folder [AppMobile/serra_app/lib](/AppMobile/serra_app/lib) there are all the .dart files used for the user interface.



