# deploy app to clound foundry

#find 
$scriptsPath = $MyInvocation.MyCommand.Definition
$scripts_dir = Split-Path -parent $scriptsPath
$project_root = Split-Path -parent $scripts_dir


mvn clean package --file "$project_root/EIDAS-Parent" -P embedded -P coreDependencies -D maven.test.skip=true

cf push stub-sp-reference           -f "$scripts_dir/default-manifest.yml"        -p "$project_root/EIDAS-SP/target/SP.war"
cf push uk-connector-node-reference -f "$scripts_dir/connector-node-manifest.yml" -p "$project_root/EIDAS-Node/target/EidasNode.war"
cf push es-proxy-node-reference     -f "$scripts_dir/proxy-node-manifest.yml"     -p "$project_root/EIDAS-Node/target/EidasNode.war"
cf push stub-idp-reference          -f "$scripts_dir/default-manifest.yml"        -p "$project_root/EIDAS-IdP-1.0/target/IdP.war"


#deploy bridge
$bridge_parent = Split-Path -parent $project_root
$bridge_root = "$bridge_parent/verify-eidas-bridge"
cd $bridge_root
./gradlew distZip
cf push eidas-bridge -p build/distributions/verify-eidas-bridge.zip -f bridge-manifest.yml
