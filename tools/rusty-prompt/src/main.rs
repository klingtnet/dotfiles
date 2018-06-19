extern crate colored;
extern crate git2;
extern crate hostname;

use colored::*;
use git2::Repository;
use hostname::get_hostname;
use std::env;
use std::process::Command;

fn home_path() -> String {
    env::home_dir()
        .unwrap_or_default()
        .to_string_lossy()
        .into_owned()
}

fn cwd() -> String {
    env::current_dir()
        .unwrap_or_default()
        .to_string_lossy()
        .into_owned()
}

fn tilde_home<S: Into<String>>(path: S) -> String {
    path.into().replace(&home_path(), "~")
}

fn user_name() -> String {
    env::var("USER")
        .or(env::var("USERNAME"))
        .unwrap_or_default()
}

fn host_name() -> String {
    get_hostname().unwrap_or_default()
}

fn shell_level() -> String {
    env::var("SHLVL").unwrap_or_default()
}

fn git_branch() -> String {
    let mut cwd = env::current_dir().unwrap();
    while let Err(_) = Repository::open(&cwd) {
        if !cwd.pop() {
            return "".to_owned();
        }
    }
    let repo = Repository::open(cwd).unwrap();
    let head = repo.head().unwrap();
    head.shorthand().unwrap_or_default().to_string()
}

fn virtual_env() -> String {
    env::var("VIRTUAL_ENV").unwrap_or_default()
}

fn main() {
    println!(
        "s{} {}@{} {} ({}) in {}",
        shell_level().cyan(),
        user_name().green(),
        host_name().yellow(),
        tilde_home(cwd()),
        git_branch().blue(),
        virtual_env().blue(),
    );
}
