function __omf_assert_args_count -a count
    set -l cmd (commandline -poc)
    set -e cmd[1]
    test (count $cmd) -eq $count
end

function __fish_print_env_files -d 'Print list of all files under .env'
    set -x env_dir ~/.env/
    set -l file_names (command find $env_dir -maxdepth 1 -type f -exec basename {} \; )
    for file_name in $file_names
        echo "$file_name"\t"$env_dir$file_name"
    end
end

function __fish_print_profiles_from_env_file -d 'Print the list of all profiles from an env file'
    if ! __omf_assert_args_count 1
        # This should only run when we have an argument to our command
        return
    end

    set -l cmd (commandline -poc)
    set -l env_file_name $cmd[-1]

    set -x env_dir ~/.env/
    set -x env_file "$env_dir$env_file_name"
    command sed -n 's/^ *\[\(.*\)\] *$/\1/p' $env_file | grep -Eo '[^ ]+$'
end

complete --command tenv --no-files -n "__omf_assert_args_count 0" --arguments '(__fish_print_env_files)'
complete --command tenv --no-files -n "__omf_assert_args_count 1" --arguments '(__fish_print_profiles_from_env_file)'
