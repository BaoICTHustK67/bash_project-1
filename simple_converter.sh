#!/usr/bin/bash

re="^-?[0-9]+$"
float="^-?[0-9]+\.[0-9]+$"
convert="^[a-zA-Z]+_to_[a-zA-Z]+$"

line_num=1
line=$(wc -l definitions.txt | cut -d ' ' -f1)

function menu(){
echo 'Select an option' 
echo "0. Type '0' or 'quit' to end program"
echo '1. Convert units'
echo '2. Add a definition'
echo '3. Delete a definition' 
}

echo -e 'Welcome to the Simple converter!' 

while true 
do
    menu
    read -r opt_input
    case $opt_input in 
        0 | 'quit' )
            echo 'Goodbye!'
            break
            ;;
         1 )
        if [[ $line -ne 0 ]]; then
            echo -e "Type the line number to convert units or '0' to return\n$(awk '{print NR". " $0}' "definitions.txt") "
            read line_input
            if [[ $line_input -ne 0 ]] || [[ $line_input != 0 ]]; then 
                while ! [[ $line_input =~ $re ]] || ! [[ $line_input -lt $line ]] ; do 
                    echo 'Enter a valid line number!'
                    read line_input
                    done
            
            echo 'Enter a value to convert:'
            read val
            while ! [[ $val =~ $re ]] && ! [[ $val =~ $float ]] ; do 
                    echo 'Enter a float or integer value!'
                    read val
                    done
            ratio=$(sed -n "${line_input}p" "definitions.txt"  | cut -d ' ' -f 2 )
            echo "Result: $(echo "scale=2; $val*$ratio" | bc -l)"
            else
                true
            fi
            
        else 
            echo 'Please add a definition first!'
        fi
            
            ;;
         2 )
            echo 'Enter a definition:'
            read -a def
            string="${def[0]}"
            constant="${def[1]}"
            def_num="${#def[@]}"
            while [[ $def_num -ne 2 ]] || ! [[ $constant =~ $float || $constant =~ $re ]] ||  ! [[ $string =~ $convert ]]
            do
                echo -e 'The definition is incorrect!\n'
                echo 'Enter a definition:'
                read -a def
                string="${def[0]}"
                constant="${def[1]}"
                def_num="${#def[@]}"
            done
            echo "${def[0]} ${def[1]}" >> "definitions.txt" 
            line=$(wc -l definitions.txt | cut -d ' ' -f1)
            ;;
         3 )
            if [[ $line -eq 0 ]]; then
                    echo 'Please add a definition first!'
            else
                echo -e "Type the line number to delete or '0' to return\n$(awk '{print NR". " $0}' "definitions.txt") "
                read line_num
                while ! [[ $line_num =~ $re ]]; do
                    echo "Enter a valid line number!"
                    read line_num
                    done
                while [[ $line_num -lt 1 || $line_num -gt $line ]] && [[ $line_num -ne 0 ]]; do
                    echo "Enter a valid line number!"
                    read line_num
                    done
                if [[ $line_num -eq 0 ]]; then 
                    true
                else
                sed -i "${line_num}d" "definitions.txt"
                fi
            fi
            ;;
        * )
            echo 'Invalid option!'
    esac
done
        
