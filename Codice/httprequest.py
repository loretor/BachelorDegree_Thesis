#installare la libreria per le chiamate http con pip install requests
import requests

#il body della chiamata POST lo mettiamo in JSON che è più facile da gestire anche per python
contenuto = { "Temperatura": "23°C", "Umidità Suolo":"45%"}
#URL del nostro API Gateway fornito da AWS
URL = "http..."
r = requests.post(URL+"/instradamento", data = contenuto)
