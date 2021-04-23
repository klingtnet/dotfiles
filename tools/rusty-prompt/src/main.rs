extern crate colored;
extern crate dirs;
extern crate git2;
extern crate hostname;
extern crate humantime;
extern crate libc;

use colored::*;
use git2::{DescribeOptions, Repository, RepositoryState};
use std::env;
use std::ffi::CStr;
use std::time::Duration;

fn cmd_duration() -> Option<String> {
    let start = env::var("KN_CMD_START_TIME_NS")
        .ok()
        .and_then(|v| v.parse::<u64>().ok())?;
    let end = env::var("KN_CMD_END_TIME_NS")
        .ok()
        .and_then(|v| v.parse::<u64>().ok())?;
    if end < start {
        return None;
    }
    let dur = humantime::format_duration(Duration::from_nanos(end - start));
    Some(format!("{}", dur))
}

fn home_path() -> Option<String> {
    if let Some(home_path) = dirs::home_dir() {
        Some(home_path.to_string_lossy().into())
    } else {
        None
    }
}

fn cwd() -> Option<String> {
    if let Ok(cwd_path) = env::current_dir() {
        Some(cwd_path.to_string_lossy().into())
    } else {
        None
    }
}

fn tilde_home(path: String) -> String {
    if let Some(home) = home_path() {
        return path.replace(&home, "~");
    }
    path
}

fn shell_level() -> Option<String> {
    env::var("SHLVL").ok()
}

fn git_prompt() -> Option<String> {
    let mut cwd = env::current_dir().ok()?;
    while Repository::open(&cwd).is_err() {
        if !cwd.pop() {
            return None;
        }
    }
    let repo = Repository::open(cwd).ok()?;
    let mut repo_prompt: Vec<String> = Vec::new();

    if let Ok(git_ref) = repo.head() {
        if let Some(shorthand) = git_ref.shorthand() {
            repo_prompt.push(shorthand.to_owned());
        }
    }
    if let Ok(description) = repo
        .describe(DescribeOptions::new().describe_tags())
        .and_then(|desc| desc.format(None))
    {
        repo_prompt.push(format!("@{}", description));
    }
    if let Some(git_state) = git_repo_state(repo.state()) {
        repo_prompt.push(format!("in {} mode", git_state.to_owned()));
    }
    if repo_prompt.is_empty() {
        return None;
    }
    Some(repo_prompt.join(" "))
}

fn git_repo_state(repo_state: RepositoryState) -> Option<&'static str> {
    match repo_state {
        RepositoryState::Merge => Some("merge"),
        RepositoryState::Revert | RepositoryState::RevertSequence => Some("revert"),
        RepositoryState::CherryPick | RepositoryState::CherryPickSequence => Some("cherry-pick"),
        RepositoryState::Bisect => Some("bisect"),
        RepositoryState::Rebase
        | RepositoryState::RebaseInteractive
        | RepositoryState::RebaseMerge => Some("rebase"),
        _ => None,
    }
}

fn virtual_env() -> Option<String> {
    env::var("VIRTUAL_ENV").ok()
}

fn user_name() -> ColoredString {
    let uid = unsafe { libc::geteuid() };

    let username = unsafe {
        let passwd = libc::getpwuid(uid);
        CStr::from_ptr((*passwd).pw_name).to_string_lossy()
    };

    match uid {
        0 => username.red().bold(),
        _ => username.green().italic(),
    }
}

fn main() {
    // always use colors and ignore enviroment
    colored::control::set_override(true);
    let mut prompt: Vec<String> = Vec::new();

    let args = env::args().collect::<Vec<_>>();
    if let Some(return_code) = args.get(1).and_then(|s| s.parse::<i8>().ok()) {
        match return_code {
            0 => (),
            _ => prompt.push(format!("{}", return_code.to_string().red())),
        }
    }

    if let Some(lvl) = shell_level() {
        prompt.push(format!("s{}", lvl.white()));
    };
    prompt.push(format!(
        "{}@{}",
        user_name(),
        hostname::get()
            .unwrap_or_else(|_| "unknown-host".into())
            .to_string_lossy()
            .yellow()
    ));
    prompt.push(tilde_home(cwd().unwrap_or_default()));
    if let Some(git_ref) = git_prompt() {
        prompt.push(format!("({})", git_ref.blue()));
    }
    if let Some(venv_path) = virtual_env() {
        prompt.push(format!("({})", tilde_home(venv_path).blue()));
    }

    if let Some(dur) = cmd_duration() {
        prompt.push(dur);
    }
    println!("{}\n$ ", prompt.join(" "));
}
