// The Kotlin plugin's POM depends on kotlin-gradle-plugins-bom, which lives on
// Maven Central rather than the plugin portal -- without both repositories here
// plugin resolution fails intermittently, depending on what the portal mirrors.
pluginManagement {
    repositories {
        gradlePluginPortal()
        mavenCentral()
    }
}

rootProject.name = "{{PROJECT_SLUG}}"
