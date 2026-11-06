# --- ÉTAPE 1 : Le Build (Java 11 / Maven) ---
FROM maven:3.9-eclipse-temurin-11 AS build
WORKDIR /app

# Copie des fichiers de configuration et des sources du projet
COPY pom.xml .
COPY src ./src

# Compilation du projet et génération du fichier JAR (en ignorant les tests pour aller plus vite)
RUN mvn clean package -DskipTests

# --- ÉTAPE 2 : Image finale minimale de production (JRE 11 Alpine) ---
FROM eclipse-temurin:11-jre-alpine
WORKDIR /app

# Copie du JAR généré depuis l'étape de build précédente
COPY --from=build /app/target/*.jar app.jar

# Exposition du port sur lequel tourne l'application Spring Boot (par défaut 8080)
EXPOSE 8080

# Commande de lancement de l'application
ENTRYPOINT ["java", "-jar", "app.jar"]