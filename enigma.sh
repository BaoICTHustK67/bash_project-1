#!/usr/bin/env bash
function display_menu(){
    echo '0. Exit'
    echo '1. Create a file'
    echo '2. Read a file'
    echo '3. Encrypt a file'
    echo '4. Decrypt a file'
    echo 'Enter an option:'
}
echo "Welcome to the Enigma!"


fname="^[a-zA-Z.]*$"
mess="^[A-Z ]+$"
re="^[ed]$"
num="^[0-8]$"
mess="^[A-Z ]+$"
conv="^[A-Z]+$"

while true; do
    display_menu
    read option
    case $option in 
        0 ) 
            echo 'See you later!'
            break
            ;;
        1 )
            echo 'Enter the filename:'
            read file_name
            if ! [[ $file_name =~ $fname ]]; then
                echo -e 'File name can contain letters and dots only!\n'
            else
                echo 'Enter a message:'
                read message
                if ! [[ $message =~ $mess ]]; then
                    echo -e 'This is not a valid message!\n'
                else
                    echo "$message" >>  "$file_name"
                    echo -e "The file was created successfully!\n"
                fi
            fi
            
            ;;
        2 ) 
            echo 'Enter the filename:' 
            read file_name
            result=$( find $file_name )
            if [[ $result == '' ]]; then 
                echo 'File not found!'
            else
               echo 'File content:'
               echo -e "$(cat $file_name)\n" 
            fi
    
            
            ;;
        3 )
            echo 'Enter the filename:' 
            read file_name
            result=$( find $file_name)
            if [[ $result == '' ]]; then 
                echo 'File not found!'
            else
                echo 'Enter password:'
                read password
                output_file=$file_name
                output_file+='.enc'
                openssl enc -aes-256-cbc -e -pbkdf2 -nosalt -in "$file_name" -out "$output_file" -pass pass:"$password" &>/dev/null
                    exit_code=$?
                    if [[ $exit_code -ne 0 ]]; then
                    echo "Fail"
                    else
                    rm $file_name
                    echo "Success"
                    fi
            fi
            ;;
        4 )
            echo 'Enter the filename:' 
            read file_name
            result=$( find $file_name)
            if [[ $result == '' ]]; then 
                echo 'File not found!'
            else
                echo 'Enter password:'
                read password
                output_file=$(echo "$file_name" | rev | cut -c5- |rev)
                openssl enc -aes-256-cbc -d -pbkdf2 -nosalt -in "$file_name" -out "$output_file" -pass pass:"$password" &>/dev/null
                    exit_code=$?
                    if [[ $exit_code -ne 0 ]]; then
                    echo "Fail"
                    else
                    rm $file_name
                    echo "Success"
                    fi
            fi
            ;;
        * )
            echo -e 'Invalid option!\n'
            ;;
    esac
done

