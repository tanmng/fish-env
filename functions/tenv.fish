#-------------------------------------------------------------------------------
# tenv
#
# set up environment variables for our use
#-------------------------------------------------------------------------------
function __tenv_set_env_var -d 'Set environment variable using section_name from file_path' -a section_name file_path
    # section_name must be a regular expression to make sure the best possible match
    # Get all the lines after the regex of section_name
    set -x lines (grep -A 50 -E "\[$section_name\]" $file_path)
    # echo $lines

    for line in $lines[2..-1]
        # The grep will return 0 when match
        if echo $line | grep -E '^ *\[.*\] *$' > /dev/null
            # Beginning of new section
            break
        end

        # Parse the line and set envrionment variables
        # echo $line
        set -x env_name (string match -r '^ *[^=]+ *' $line | xargs | tr /a-z/ /A-Z/)
        set -x env_val (string match -r ' *[^=]+ *$' $line 2> /dev/null | xargs)


        if [ "$env_name" != "" ]
            # Print something beautiful
            echo -n "Setting "
            set_color blue; echo -n $env_name; set_color normal
            echo -n " to "
            set_color red; echo -n "WAIT A SECOND, WHY SHOULD I PRINT THIS OUT AGAIN?"; set_color normal
            echo

            set -xg $env_name $env_val
        end
    end
end

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
            # echo 'All is well, setting env var now'
            __tenv_set_env_var $profile $config_file
        else
            echo "Could NOT find profile $profile in config file ($config_file). No env-var set"
        end
    else
        echo 'Missing type and/or profile'
        return 1
    end
end
