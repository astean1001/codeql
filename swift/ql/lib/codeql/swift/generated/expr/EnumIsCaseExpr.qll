// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.decl.EnumElementDecl
import codeql.swift.elements.expr.Expr

module Generated {
  class EnumIsCaseExpr extends Synth::TEnumIsCaseExpr, Expr {
    override string getAPrimaryQlClass() { result = "EnumIsCaseExpr" }

    /**
     * Gets the sub expression of this enum is case expression.
     *
     * This includes nodes from the "hidden" AST. It can be overridden in subclasses to change the
     * behavior of both the `Immediate` and non-`Immediate` versions.
     */
    Expr getImmediateSubExpr() {
      result =
        Synth::convertExprFromRaw(Synth::convertEnumIsCaseExprToRaw(this)
              .(Raw::EnumIsCaseExpr)
              .getSubExpr())
    }

    /**
     * Gets the sub expression of this enum is case expression.
     */
    final Expr getSubExpr() { result = this.getImmediateSubExpr().resolve() }

    /**
     * Gets the element of this enum is case expression.
     *
     * This includes nodes from the "hidden" AST. It can be overridden in subclasses to change the
     * behavior of both the `Immediate` and non-`Immediate` versions.
     */
    EnumElementDecl getImmediateElement() {
      result =
        Synth::convertEnumElementDeclFromRaw(Synth::convertEnumIsCaseExprToRaw(this)
              .(Raw::EnumIsCaseExpr)
              .getElement())
    }

    /**
     * Gets the element of this enum is case expression.
     */
    final EnumElementDecl getElement() { result = this.getImmediateElement().resolve() }
  }
}
