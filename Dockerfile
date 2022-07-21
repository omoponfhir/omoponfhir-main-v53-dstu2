#Build the Maven project
FROM maven:3.8.6-openjdk-8 as builder
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN mvn clean install

#Build the Tomcat container
FROM tomcat:8.5.81-jdk11-openjdk-slim
# Add environment variables here if you want to store them in the Dockerfile.
RUN apt-get update -y
RUN apt-get install postgresql-client -y

# Copy OMOP on FHIR war file to Tomcat webapps.
COPY --from=builder /usr/src/app/omoponfhir-dstu2-server/target/omoponfhir-dstu2-server.war $CATALINA_HOME/webapps/omopv53onfhir2.war

EXPOSE 8080
