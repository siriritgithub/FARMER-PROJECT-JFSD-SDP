# ---------------------------------------------------------------------------
# Stage 1: build the WAR
# ---------------------------------------------------------------------------
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /build

# Copy the POM first so Maven's dependency layer is cached across code changes.
COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B clean package -DskipTests

# ---------------------------------------------------------------------------
# Stage 2: runtime
# A JRE-only base keeps the final image small. The WAR is executable, so it
# runs with `java -jar` and serves the JSPs from embedded Tomcat.
# ---------------------------------------------------------------------------
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Run as a non-root user.
RUN groupadd -r spring && useradd -r -g spring spring

COPY --from=build /build/target/farmconnect.war app.war
RUN chown spring:spring app.war
USER spring

# Render / Railway inject PORT; 9091 is the local fallback.
ENV PORT=9091
EXPOSE 9091

# Container-aware heap sizing so the JVM respects the platform memory limit.
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+UseSerialGC"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.war"]
