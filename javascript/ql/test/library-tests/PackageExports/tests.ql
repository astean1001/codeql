import javascript
import semmle.javascript.PackageExports as Exports

query PackageJSON getTopmostPackageJSON() { result = Exports::getTopmostPackageJSON() }

query DataFlow::Node getAValueExportedBy(PackageJSON json) {
  result = Exports::getAValueExportedBy(json)
}

query DataFlow::Node getAnExportedValue(Module mod, string name) {
  result = Exports::getAnExportedValue(mod, name)
}

query Module exports(string name, ASTNode export) { result.exports(name, export) }
