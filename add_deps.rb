require 'xcodeproj'

project_path = 'MongezOrg.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Find the main target
target = project.targets.first

# Helper to add a remote swift package
def add_remote_package(project, repositoryURL, version)
  pkg = Xcodeproj::Project::Object::XCRemoteSwiftPackageReference.new(project, project.generate_uuid)
  pkg.repositoryURL = repositoryURL
  pkg.requirement = {
    "kind" => "exactVersion",
    "version" => version
  }
  project.root_object.package_references << pkg
  pkg
end

# Add Firebase
firebase_pkg = add_remote_package(project, "https://github.com/firebase/firebase-ios-sdk", "10.19.0")

# Add GoogleSignIn
google_pkg = add_remote_package(project, "https://github.com/google/GoogleSignIn-iOS", "7.1.0")

# Helper to add a local swift package
def add_local_package(project, relative_path)
  pkg = Xcodeproj::Project::Object::XCLocalSwiftPackageReference.new(project, project.generate_uuid)
  pkg.relative_path = relative_path
  project.root_object.package_references << pkg
  pkg
end

# Add Common module
common_pkg = add_local_package(project, "Modules/Common")

# To actually link the products in the target, we need XCSwiftPackageProductDependency
def add_product_dependency(project, target, package, product_name)
  product_dep = Xcodeproj::Project::Object::XCSwiftPackageProductDependency.new(project, project.generate_uuid)
  product_dep.package = package
  product_dep.product_name = product_name
  
  # Add to target's package_product_dependencies
  target.package_product_dependencies << product_dep
  
  # Also need to add to the frameworks build phase
  build_file = Xcodeproj::Project::Object::PBXBuildFile.new(project, project.generate_uuid)
  build_file.product_ref = product_dep
  target.frameworks_build_phase.files << build_file
end

# Add the Common product dependency
add_product_dependency(project, target, common_pkg, "Common")

project.save
puts "Added dependencies successfully."
