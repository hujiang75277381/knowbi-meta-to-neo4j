# pip install gitpython
import sys
import os
import csv
import numpy as np
import pandas as pd
from git import Repo, Diff

COMMITS_TO_PRINT = 1000

def print_commit(commit):
    print(str(commit.hexsha))
    print("\"{}\" by {} ({})".format(commit.summary,
                                     commit.author.name,
                                     commit.author.email))
    print(str(commit.authored_datetime))
    print(str("count: {} and size: {}".format(commit.count(),
                                              commit.size)))

def print_branch(branch):
    print("branch: {}".format(branch.name))
    commit_list = list(repo.iter_commits(branch)) #[:COMMITS_TO_PRINT]

    df = pd.DataFrame({'commit_hash': [], 'diff_type': [], 'commit_file': []})

    for commit in commit_list:
        if commit.parents:

            parent = commit.parents[0] # if commit.parents else EMPTY_TREE_SHA
            diffs = {
                diff.a_path: diff for diff in commit.diff(parent)
            }

            for objpath, stats in commit.stats.files.items():

                # Select the diff for the path in the stats
                diff = diffs.get(objpath)

                if not diff:
                    for diff in diffs.values():
                        if diff.b_path == repo_path and diff.renamed:
                            break

                df = df.append({'commit_hash': commit.hexsha, 'diff_type': diff_type(diff), 'commit_file': objpath}, ignore_index=True)

    df.to_csv(out_path + '/gp-commit-details.csv')

def diff_type(diff):
    if diff.renamed: return 'R'
    if diff.deleted_file: return 'D'
    if diff.new_file: return 'A'
    return 'M'

def print_repository(repo):
    print('Repo description: {}'.format(repo.description))
    print('Repo active branch is {}'.format(repo.active_branch))
    for remote in repo.remotes:
        print('Remote named "{}" with URL "{}"'.format(remote, remote.url))
    print('Last commit for repo is {}.'.format(str(repo.head.commit.hexsha)))

if __name__ == "__main__":
    repo_path = sys.argv[1]
    out_path = sys.argv[2]

    repo = Repo(repo_path)
    if not repo.bare:
        print('Repo at {} successfully loaded.'.format(repo_path))
        print_repository(repo)
        branches = list(repo.branches)
        for branch in branches:
            print_branch(branch)
            pass
    else:
        print('Could not load repository at {} :('.format(repo_path))
