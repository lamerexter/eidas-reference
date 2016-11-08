#!/usr/bin/env bash

EIDAS_DEBUG=$(echo "${EIDAS_DEBUG}" | tr '[:upper:]' '[:lower:]')

if [ "${EIDAS_DEBUG}x" == "yx" ]; then
  echo "DEBUG MODE"
  set -o xtrace 
fi

# Release/Version Number
VERSION="${BUILD_NUMBER}"

echo "Release Version=${BUILD_NUMBER}
      Comprising of:
           eidas-reference: ${EIDAS_REFERENCE}
           eidas-keystore:  ${EIDAS_KEYSTORE}
           eidas-metadata:  ${EIDAS_METADATA}"

PROJECTS_DIR="${WORKSPACE}"
ENVIRONMENT="${ENVIRONMENT}" 

uploadToBintray() {
  local PACKAGE="$1"
  local ROLE="$2"
  curl -T "${PROJECTS_DIR}/artifacts/${ROLE}_${VERSION}.war" -u${EIDAS_BINTRAY_USER}:${EIDAS_BINTRAY_API_KEY} "https://api.bintray.com/content/msa/eidas-alpha/eidas-reference-artifacts/${BUILD_NUMBER}/${ROLE}_${VERSION}.war"
  curl -X POST -u${EIDAS_BINTRAY_USER}:${EIDAS_BINTRAY_API_KEY} "https://api.bintray.com/content/msa/eidas-alpha/eidas-reference-artifacts/${BUILD_NUMBER}/publish"
}

saveArtifact() {
  local FOLDER="$1"
  local WAR="$2"
  local ROLE="$3"
  local DEST="${PROJECTS_DIR}/artifacts"
  if [ ! -d "${DEST}" ]; then
    mkdir "${DEST}"
  fi
  cp "$PROJECTS_DIR/$FOLDER/target/$WAR" "${DEST}/${ROLE}_${VERSION}.war"
}

generateSettingsXml() {
cat <<EOF > "$PROJECTS_DIR/settings.xml"
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <mirrors>
    <mirror>
      <id>localsamls</id>
      <name>Local samls</name>
      <url>file://$PWD/EIDAS-Encryption/src/main/lib</url>
      <mirrorOf>EIDASprojectrepo</mirrorOf>
    </mirror>
    <mirror>
      <id>artifactory</id>
      <name>IDA Artifactory</name>
      <url>https://artifactory.ida.digital.cabinet-office.gov.uk/artifactory/remote-repos</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>
</settings>
EOF
}


main() {
  echo "Release=$VERSION"

  generateSettingsXml
  
  mvn --file "EIDAS-Parent/pom.xml" clean install -P embedded -P coreDependencies --settings settings.xml -Dmaven.test.skip=true
     
  saveArtifact    EIDAS-SP    SP.war      stub-sp
  uploadToBintray EIDAS-SP    stub-sp
  
  saveArtifact    EIDAS-Node    EidasNode.war connector-node
  uploadToBintray EIDAS-Node    connector-node
  
  saveArtifact    EIDAS-Node      EidasNode.war proxy-node
  uploadToBintray EIDAS-Node    proxy-node
  
  saveArtifact    EIDAS-IdP-1.0 IdP.war     stub-idp
  uploadToBintray EIDAS-IdP-1.0 stub-idp  
}

main "$@"
