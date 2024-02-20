/**
 * Unsafe transfer interface
 */

 import codeql.solidity.ast.internal.TreeSitter

 /**
  * Currently we just detect this issue with two criteria
  * - Member property name is `transfer` or `transferFrom` with two (or three) argument
  * - Caller should be IERC20 interface
  * - TODO: We should check whether SafeERC20 is used or not.
  */

Solidity::FunctionDefinition getFunctionDef (Solidity::AstNode n) {
    if n instanceof Solidity::FunctionDefinition then result = n
    else result = getFunctionDef(n.getParent())
}
 
 
query predicate problems(
    Solidity::MemberExpression member,  
    string msg, Solidity::CallExpression call, string funcname, Solidity::CallExpression inner_call, string loc
) {
    call.getFunction() instanceof Solidity::MemberExpression and 
    call.getFunction() = member and
    member.getObject() instanceof Solidity::CallExpression and
    member.getObject() = inner_call and
    getFunctionDef(call).getName().toString() = funcname and
    inner_call.getFunction().toString() = "IERC20" and
    (("transfer" = member.getProperty().toString()) or  ("transferFrom" = member.getProperty().toString())) and
    if call.getLocation().getStartLine() = call.getLocation().getEndLine() then
        call.getLocation().getFile().getBaseName() + "#L" + call.getLocation().getStartLine() = loc 
    else call.getLocation().getFile().getBaseName() + "#L" + call.getLocation().getStartLine() + ":" + call.getLocation().getEndLine() = loc
    and if "transfer" = member.getProperty().toString() then msg = "Unsafe use of transfer with IERC in $@"
    else msg = "Unsafe use of transferFrom with IERC in $@"
} 
 