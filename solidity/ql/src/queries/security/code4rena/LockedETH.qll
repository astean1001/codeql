/**
 * Transfer on payable address
 */

 import codeql.solidity.ast.internal.TreeSitter

 Solidity::FunctionDefinition getFunctionDef (Solidity::AstNode n) {
    if n instanceof Solidity::FunctionDefinition then result = n
    else result = getFunctionDef(n.getParent())
 }

 /**
  * Currently we just detect this issue with single criteria
  * - If modifier name as same as below : onlyOwner, onlyAdmin, onlyRole.
  * - TODO: If there is modifier parameter, check onlyRole string includes previleged string literal
  */ 
 
 query predicate problems(
    Solidity::ModifierInvocation modinv, string msg, Solidity::FunctionDefinition funcdef, string funcname, string temp, string modifier
 ) {
    (modinv.getChild(0).toString() = "onlyOwner" or
    modinv.getChild(0).toString() = "onlyAdmin" or
    modinv.getChild(0).toString() = "onlyRole") and
    getFunctionDef(modinv) = funcdef and
    getFunctionDef(modinv).getName().toString() = funcname and
    modinv.getChild(0).toString() = modifier and
    temp = "_" and
    msg = "Function $@ is previleged with $@, and might create single point of failure." 
 } 
 