#![feature(duration_extras)]

extern crate humantime;

use std::env;
use std::num::ParseIntError;
use std::time::Duration;

fn main() -> Result<(), ParseIntError> {
    let start = try!(env::var("KN_CMD_START_TIME_NS")
        .unwrap_or_default()
        .parse::<u64>());
    let end = try!(env::var("KN_CMD_END_TIME_NS")
        .unwrap_or_default()
        .parse::<u64>());
    let dur_str = humantime::format_duration(Duration::from_nanos(end - start)).to_string();
    println!("{}", dur_str);
    Ok(())
}
