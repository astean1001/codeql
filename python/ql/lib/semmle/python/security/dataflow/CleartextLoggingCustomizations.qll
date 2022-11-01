/**
 * Provides default sources, sinks and sanitizers for detecting
 * "Clear-text logging of sensitive information"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.SensitiveDataSources
private import semmle.python.dataflow.new.BarrierGuards

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "Clear-text logging of sensitive information"
 * vulnerabilities, as well as extension points for adding your own.
 */
module CleartextLogging {
  /**
   * A data flow source for "Clear-text logging of sensitive information" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets the classification of the sensitive data. */
    abstract string getClassification();
  }

  /**
   * A data flow sink for "Clear-text logging of sensitive information" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "Clear-text logging of sensitive information" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of sensitive data, considered as a flow source.
   */
  class SensitiveDataSourceAsSource extends Source, SensitiveDataSource {
    SensitiveDataSourceAsSource() {
      not SensitiveDataSource.super.getClassification() = SensitiveDataClassification::id()
    }

    override SensitiveDataClassification getClassification() {
      result = SensitiveDataSource.super.getClassification()
    }
  }

  /** A piece of data logged, considered as a flow sink. */
  class LoggingAsSink extends Sink {
    LoggingAsSink() { this = any(Logging write).getAnInput() }
  }

  /** A piece of data printed, considered as a flow sink. */
  class PrintedDataAsSink extends Sink {
    PrintedDataAsSink() {
      (
        this = API::builtin("print").getACall().getArg(_)
        or
        // special handling of writing to `sys.stdout` and `sys.stderr`, which is
        // essentially the same as printing
        this =
          API::moduleImport("sys")
              .getMember(["stdout", "stderr"])
              .getMember("write")
              .getACall()
              .getArg(0)
      ) and
      // since some of the inner error handling implementation of the logging module is
      // ```py
      //         sys.stderr.write('Message: %r\n'
      //         'Arguments: %s\n' % (record.msg,
      //                              record.args))
      // ```
      // any time we would report flow to such a logging sink, we can ALSO report
      // the flow to the `record.msg`/`record.args` sinks -- obviously we
      // don't want that.
      //
      // However, simply removing taint edges out of a sink is not a good enough solution,
      // since we would only flag one of the `logging.info` calls in the following example
      // due to use-use flow
      // ```py
      // logging.info(user_controlled)
      // logging.info(user_controlled)
      // ```
      //
      // The same approach is used in the command injection query.
      not exists(Module loggingInit |
        loggingInit.getName() = "logging.__init__" and
        this.getScope().getEnclosingModule() = loggingInit and
        // do allow this call if we're analyzing logging/__init__.py as part of CPython though
        not exists(loggingInit.getFile().getRelativePath())
      )
    }
  }
}
