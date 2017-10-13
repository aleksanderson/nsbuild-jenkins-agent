/**
 * Patch pom.xml file to package self contained SDF CLI jar file
 */

const fs = require('fs');
const path = require('path');
const xml2js = require('xml2js');

const mavenAssemblyPlugin = `
  <plugin>
    <artifactId>maven-assembly-plugin</artifactId>
    <configuration>
        <archive>
            <manifest>
                <mainClass>com.netsuite.tools.SDF</mainClass>
            </manifest>
        </archive>
        <descriptorRefs>
            <descriptorRef>jar-with-dependencies</descriptorRef>
        </descriptorRefs>
    </configuration>
  </plugin>  
`;

const sdfDependency = `
  <dependency>
    <groupId>com.netsuite</groupId>
    <artifactId>sdfcli</artifactId>
    <version>2017.2.0</version>
  </dependency>
`;

function _patch(pomFilePath) {
  pomFilePath = path.resolve(process.cwd(), pomFilePath);
  const originalPomFile = fs.readFileSync(pomFilePath);

  xml2js.parseString(originalPomFile, (err, originalPomFileParsed) => {
    if(err) {
      return console.log(err);
    }
    
    xml2js.parseString(mavenAssemblyPlugin, (err, mavenAssemblyPluginParsed) => {
      if(err) {
        return console.log(err);
      }
      
      xml2js.parseString(sdfDependency, (err, sdfDependencyParsed) => {
        if(err) {
          return console.log(err);
        }

        originalPomFileParsed.project.build[0].plugins[0].plugin.unshift(mavenAssemblyPluginParsed.plugin);
        originalPomFileParsed.project.dependencies[0].dependency.unshift(sdfDependencyParsed.dependency);

        const builder = new xml2js.Builder();
        const originalPomFilePatched = builder.buildObject(originalPomFileParsed);

        fs.writeFileSync(pomFilePath, originalPomFilePatched);
      });
    });
  });
}

_patch(process.argv[2]);