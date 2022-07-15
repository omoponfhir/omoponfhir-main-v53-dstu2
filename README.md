# omoponfhir-main-v53-dstu2
OMOP v5.3 on FHIR DSTU2

OMOP Version: 5.3
FHIR Version: DSTU2

## Getting Started
### Cloning the Repo
This repository is setup to use submodules (references to other repositories). To clone everything properly, you must use the following command to move recursively through the submodules:
```
git clone --recurse-submodules https://github.com/omoponfhir/omoponfhir-main-v53-dstu2.git
```
This should pull the OMOP on FHIR DSTU 2 server, the OMOP version 5.3 database connector, and the OMOP 5.3 to FHIR DSTU 2 mapping layer.

### Setting up your Environment
There are several environment variables which are required to run OMOP-on-FHIR, which can be configured in a number of ways depending on method of development or prefered approach. An `example.env` file is provided as a template for use with Docker deployments, though each environment variable may also be set directly on the host system.

* JDBC_URL - The JDBC connection string for an OMOP v5.3 database (with OMOP-on-FHIR extensions).
* JDBC_USERNAME - The username for the OMOP v5.3 database.
* JDBC_PASSWORD - The password for the OMOP v5.3 database.
* SMART_INTROSPECTURL - (Optional) The Smart-on-FHIR introspect endpoint. This should be the server base plus "/smart/introspect".
* SMART_AUTHSERVERURL -  (Optional) The Smart-on-FHIR authorize endpoint. This should be the server base plus "/smart/authorize".
* SMART_TOKENSERVERURL -  (Optional) The Smart-on-FHIR token endpoint. This should be the server base plus "/smart/token".
* AUTH_BEARER - An auth bearer token for authentication with the OMOP on FHIR Server.
* AUTH_BASIC - A basic auth login for the FHIR Server, in the form of "username:password".
* FHIR_READONLY - A boolean value specifying whether or not the server should be able to write the OMOP database.
* SERVERBASE_URL - The HAPI FHIR server base URL. This should be the server base (without the /fhir endpoint). (Note: This is required for proper handling of features such as bundle navigation to allow the FHIR server to work behind a proxy.)
* LOCAL_CODEMAPPING_FILE_PATH - (Optional) For advanced users, a path may be provided to file mappig local codes to the OMOP concept tables.
* MEDICATION_TYPE - This variable allows users to control the representation of Medications in the MedicationRequest resource. The options are as follows:
  * "local" - The Medication is represented as a contained resource.
  * "link" - The Medication resource is provided separately and a reference is created.
  * "code" - The Medication is represented as a CodeableConcept.

## Deployment
### Docker
For Docker (without Docker compose), it is recommended that a `.env` file be used for environment variables. Otherwise, you will need to specify each environment variable individually.

To build the Docker image, from within the project root directory run:
```
docker build -t omoponfhir:v53-dstu2 .
```
This will create an image named "omoponfhir" and tag it with "v53-dstu2". The name and tag are arbitrary and can be changed based on user needs.

This will execute a two stage build process, in which the project files will be copied to a Maven image in order to generate the WAR file, which is then copied into a Tomcat image to be deployed.

*NOTE: The default path on the Tomcat server is set to be "omopv53onfhir2", based on the file name of the WAR. If you wish to use a different path, you will need to modify the final part of Line 14 in the Dockerfile, changing the file name in the destination path.*

Once the image is built, you can run it by using the following command:
```
docker run -p 8080:8080 --env-file ./.env omoponfhir:v53-dstu2
```
You will need to modify this comand appropriately as follows:
* **-p 8080:8080** is the port mapping from the host to the container's internal localhost. The first number represents the external host port you wish to expose the container on, while the second number is the internal localhost port. The second number should remain static as "8080", which is the default Tomcat port. For local deployments, it is recommended to keep the ports matched.
* **--env-file ./.env** specifies the path to the .env file that will be used for the runtime environment.
* **omoponfhir:v53-dstu2** should align with the name and tag of the image you used during the docker build process.

If using the default options shown here, your OMOP-on-FHIR server should now be accessilbe at: http://localhost:8080/omopv53onfhir2/

### Docker Compose
** TODO: Add Docker Compose template with instructions **