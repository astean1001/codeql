/**
 * Rounding error in Compound V2
 */

 import codeql.solidity.ast.internal.TreeSitter

 /**
  * Currently we just detect this issue with two criteria
  * - There are functions named `redeemUnderlying`, `redeemFresh`
  * - There are calls to `divScalarByExpTruncate` in the body of `redeemFresh`
  * - TODO: After implementation of range analysis, we can add more criteria
  */

Solidity::FunctionDefinition getFunctionDef (Solidity::AstNode n) {
    if n instanceof Solidity::FunctionDefinition then result = n
    else result = getFunctionDef(n.getParent())
}
 
 
query predicate problems(
    Solidity::CallExpression pos, 
    string msg, Solidity::FunctionDefinition redeemFresh, string funcname, Solidity::FunctionDefinition divScalarByExpTruncate, string funcname2,  
    Solidity::CallExpression dst, string loc, Solidity::FunctionDefinition redeemUnderlying, string whatever
) {
    whatever = "" and
    redeemUnderlying.getName().toString() = "redeemUnderlying" and
    redeemFresh.getName().toString() = "redeemFresh" and
    divScalarByExpTruncate.getName().toString() = "divScalarByExpTruncate" and
    dst.getFunction().toString() = "divScalarByExpTruncate" and
    getFunctionDef(dst) = redeemFresh and
    pos = dst and
    funcname = redeemFresh.getName().toString() and
    funcname2 = divScalarByExpTruncate.getName().toString() and
    if dst.getLocation().getStartLine() = dst.getLocation().getEndLine() then
        dst.getLocation().getFile().getBaseName() + "#L" + dst.getLocation().getStartLine() = loc 
    else dst.getLocation().getFile().getBaseName() + "#L" + dst.getLocation().getStartLine() + ":" + dst.getLocation().getEndLine() = loc
    and msg = "[Compound V2] There is integer rounding error that leads to vault drainage in $@. Do not use $@ at $@."
} 
 