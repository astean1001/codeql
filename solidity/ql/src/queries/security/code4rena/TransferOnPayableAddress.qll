/**
 * Transfer on payable address
 */

import codeql.solidity.ast.internal.TreeSitter

/**
 * Currently we just detect this issue with single criteria
 * - Member property name is `send` or `transfer` with one argument
 * - TODO: We should check whether the callee is actually payable address or not.
 */


query predicate problems(
    Solidity::MemberExpression member, string msg, Solidity::CallExpression call, string loc
) {
    call.getFunction() instanceof Solidity::MemberExpression and 
    call.getFunction() = member and
    ("transfer" = member.getProperty().toString() or  "send" = member.getProperty().toString()) and
    count(call.getChild(_)) = 1 and
    if call.getLocation().getStartLine() = call.getLocation().getEndLine() then
        call.getLocation().getFile().getBaseName() + "#L" + call.getLocation().getStartLine() = loc 
    else call.getLocation().getFile().getBaseName() + "#L" + call.getLocation().getStartLine() + ":" + call.getLocation().getEndLine() = loc
    and if "transfer" = member.getProperty().toString() then msg = "Using transfer on a payable address at $@ is not recommended"
    else msg = "Using send on a payable address at $@ is not recommended"
} 
