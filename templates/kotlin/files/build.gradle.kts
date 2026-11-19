plugins {
    kotlin("jvm") version "2.4.21"
}

// Gradle writes build/ beside the sources, and here that is a bind mount the
// clean-tree check watches. /cache is the one writable place that is not the project.
layout.buildDirectory = file("/cache/build")

// Gradle's own layout is src/main/kotlin and src/test/kotlin. The template puts
// the module at src/ so its filename can carry the project name.
kotlin {
    sourceSets["main"].kotlin.setSrcDirs(listOf("src"))
    sourceSets["test"].kotlin.setSrcDirs(listOf("test"))
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}
