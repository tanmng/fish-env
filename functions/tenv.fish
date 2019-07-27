#-------------------------------------------------------------------------------
# tenv
#
# set up environment variables for our use
#-------------------------------------------------------------------------------
function tenv -d 'Set up env vars' -a file_type -a profile
    set -x env_dir ~/.env

    if test -n "$file_type" && test -n "$profile"
        set -x config_file "$env_dir/$file_type"

        # Check the file for profile exists
        if ! test -f "$config_file"
            echo "File type $file_type is not available in $env_dir"
            return 2
        end

        # Confirm that the profile is there
        if fgrep -q "[$profile]" $config_file
            echo 'All is well, setting env var now'
        else
            echo "Could NOT find profile $profile in config file ($config_file). No env-var set"
        end
    else
        echo 'Missing type and/or profile'
        return 1
    end
end
