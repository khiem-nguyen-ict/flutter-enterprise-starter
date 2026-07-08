pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.0.1" apply false
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
}

include(":app")

// Force a consistent compileSdk across the app and all Flutter plugin
// subprojects. Some published plugins (e.g. connectivity_plus 5.0.2) hardcode
// an older compileSdk that conflicts with their newer transitive AndroidX
// dependencies, which fails the AAR metadata check. This keeps every module
// on the installed API level (36) and survives `flutter pub get`.
val forcedCompileSdk = 36
gradle.allprojects {
    afterEvaluate {
        extensions.findByName("android")?.let { androidExt ->
            val cls = androidExt.javaClass
            val intSetter =
                cls.methods.firstOrNull { it.name == "setCompileSdk" && it.parameterCount == 1 }
                    ?: cls.methods.firstOrNull { it.name == "setCompileSdkVersion" && it.parameterCount == 1 }
            when (intSetter?.parameterTypes?.get(0)?.name) {
                "int", "java.lang.Integer" -> intSetter.invoke(androidExt, forcedCompileSdk)
                else -> intSetter?.invoke(androidExt, forcedCompileSdk.toString())
            }
        }
    }
}
