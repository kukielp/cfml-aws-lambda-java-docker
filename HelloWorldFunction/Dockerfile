FROM openjdk:11 as build-image

ARG SCRATCH_DIR=/var/task/build
WORKDIR /var/task

COPY src/ src/
COPY jars/ jars/
COPY gradle/ gradle/
COPY build.gradle gradlew ./

RUN mkdir build
COPY gradle/lambda-build-init.gradle ./build

RUN echo $SCRATCH_DIR

RUN ./gradlew --project-cache-dir $SCRATCH_DIR/gradle-cache -Dsoftware.amazon.aws.lambdabuilders.scratch-dir=$SCRATCH_DIR --init-script $SCRATCH_DIR/lambda-build-init.gradle build --debug
RUN rm -r $SCRATCH_DIR/gradle-cache
RUN rm -r $SCRATCH_DIR/lambda-build-init.gradle
RUN cp -r $SCRATCH_DIR/*/build/distributions/lambda-build/* .
RUN ls -la /var/task/*

FROM public.ecr.aws/lambda/java:11

COPY --from=build-image /var/task/META-INF ./
COPY --from=build-image /var/task/cfmldemo ./cfmldemo
COPY --from=build-image /var/task/lib/ ./lib

RUN mkdir cfml
COPY cfml/ ./cfml
RUN mkdir warmer
COPY warmer/ ./warmer
RUN chmod +x ./warmer/*.sh
RUN ./warmer/warm.sh
RUN rm -rf ./warmer

# Command can be overwritten by providing a different command in the template directly.
CMD ["cfmldemo.App::handleRequest"]