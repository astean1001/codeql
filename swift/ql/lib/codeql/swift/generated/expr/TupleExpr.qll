// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.expr.Expr

module Generated {
  class TupleExpr extends Synth::TTupleExpr, Expr {
    override string getAPrimaryQlClass() { result = "TupleExpr" }

    /**
     * Gets the `index`th element of this tuple expression (0-based).
     *
     * This includes nodes from the "hidden" AST. It can be overridden in subclasses to change the
     * behavior of both the `Immediate` and non-`Immediate` versions.
     */
    Expr getImmediateElement(int index) {
      result =
        Synth::convertExprFromRaw(Synth::convertTupleExprToRaw(this)
              .(Raw::TupleExpr)
              .getElement(index))
    }

    /**
     * Gets the `index`th element of this tuple expression (0-based).
     */
    final Expr getElement(int index) { result = this.getImmediateElement(index).resolve() }

    /**
     * Gets any of the elements of this tuple expression.
     */
    final Expr getAnElement() { result = this.getElement(_) }

    /**
     * Gets the number of elements of this tuple expression.
     */
    final int getNumberOfElements() { result = count(int i | exists(this.getElement(i))) }
  }
}
