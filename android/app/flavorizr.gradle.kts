import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("vendor") {
            dimension = "flavor-type"
            applicationId = "com.flutter.deligo_vendor"
            resValue("string", "app_name", "Deligo Vendor")
        }
    }
}
