/**
 * Unchecked Approve Return Value
 */

 import codeql.solidity.ast.internal.TreeSitter

 /**
  * Currently we just detect this issue with three criteria
  * - Member property name is `approve` with two argument
  * - Caller should be IERC20 interface
  * - Ancestors of call expression should not be assignment expression 
  */

Solidity::FunctionDefinition getFunctionDef (Solidity::AstNode n) {
    if n instanceof Solidity::FunctionDefinition then result = n
    else result = getFunctionDef(n.getParent())
}

boolean noAssignmentAncestor(Solidity::AstNode n) {
    if n instanceof Solidity::AssignmentExpression then result = false
    else if n.getParent() instanceof Solidity::FunctionBody or n.getParent() instanceof Solidity::ContractBody then result = true
    else result = noAssignmentAncestor(n.getParent())
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
    noAssignmentAncestor(call) = true and
    "approve" = member.getProperty().toString() and
    if call.getLocation().getStartLine() = call.getLocation().getEndLine() then
        call.getLocation().getFile().getBaseName() + "#L" + call.getLocation().getStartLine() = loc 
    else call.getLocation().getFile().getBaseName() + "#L" + call.getLocation().getStartLine() + ":" + call.getLocation().getEndLine() = loc
    and msg = "Return values of approve() not checked in $@"
} 
 