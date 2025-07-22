android {
    namespace "com.firstborn.edunjema3"
    compileSdk 34

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    defaultConfig {
        applicationId "com.firstborn.edunjema3"
        minSdkVersion 23
        targetSdkVersion 34
        versionCode 1
        versionName "1.0"
        multiDexEnabled true
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}

dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'
    implementation platform('com.google.firebase:firebase-bom:33.16.0')
    implementation 'com.google.firebase:firebase-analytics'
}

apply plugin: 'com.google.gms:google-services'