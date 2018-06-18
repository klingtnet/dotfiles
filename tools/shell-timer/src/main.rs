#![feature(duration_extras)]

extern crate humantime;

use std::env;
use std::time::Duration;

fn main() {
    let start = env::var("KN_CMD_START_TIME_NS")
        .unwrap_or_default()
        .parse::<u64>()
        .unwrap_or(0);
    let end = env::var("KN_CMD_END_TIME_NS")
        .unwrap_or_default()
        .parse::<u64>()
        .unwrap_or(0);
    let dur_str = humantime::format_duration(Duration::from_nanos(end - start)).to_string();
    println!("{}", dur_str);
}
