use std::env;
use std::path::PathBuf;

use clap::Args;

use codeql_extractor::autobuilder;

#[derive(Args)]
// The autobuilder takes no command-line options, but this may change in the future.
pub struct Options {}

pub fn run(_: Options) -> std::io::Result<()> {
    let database = env::var("CODEQL_EXTRACTOR_SOLIDITY_WIP_DATABASE")
        .expect("CODEQL_EXTRACTOR_SOLIDITY_WIP_DATABASE not set");

    autobuilder::Autobuilder::new("solidity", PathBuf::from(database))
        .include_extensions(&[".sol"])
        // If we need to include some config files, we can do so here.
        // .include_globs(&["**/hardhat.config.js", "**/truffle-config.js"])
        .exclude_globs(&["**/.git"])
        .size_limit("5m")
        .run()
}
