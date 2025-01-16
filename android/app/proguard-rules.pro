# This ProGuard rules file is designed to suppress warnings and keep necessary classes for Google libraries.

# Keep everything in the Google Guava library
-keep class com.google.common.** { *; }
-dontwarn com.google.common.**

# Keep everything in Google annotations
-keep class com.google.j2objc.annotations.** { *; }
-dontwarn com.google.j2objc.annotations.**

# Suppress warnings for any other com.google.* packages
-dontwarn com.google.**

# General settings to prevent issues with other libraries
-dontwarn org.checkerframework.**

# Keep all Gson model classes and their properties
-keep class * implements com.google.gson.** { *; }
-keep class * extends com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Keep Retrofit service classes
-keep class retrofit2.** { *; }
-dontwarn retrofit2.**

# Keep OkHttp client classes
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

# Keep annotation classes (if any)
-keepattributes *Annotation*

# Keep all classes from the Jackson library
-keep class com.fasterxml.jackson.** { *; }
-dontwarn com.fasterxml.jackson.**

# Keep everything in the Flutter package
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Keep all classes in your app
-keep class com.live.listorlife.** { *; }
# Keep attributes for annotations
-keepattributes *Annotation*
# Suppress warnings for Gson missing classes
-dontwarn com.google.gson.**
