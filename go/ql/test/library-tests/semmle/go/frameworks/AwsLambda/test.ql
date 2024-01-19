import go
import semmle.go.frameworks.AwsLambda
import TestUtilities.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(Function fn | fn.hasQualifiedName(_, "sink") | sink = fn.getACall().getAnArgument())
  }
}

import TaintFlowTest<Config>
