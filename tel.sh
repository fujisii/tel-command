function tell() {
    networksetup -setairportpower en0 off
    tel $1
    networksetup -setairportpower en0 on
}

function tel() {
    login_id="id"
    login_pw="password"
    url="https://example.com/"

    if [ -z "$1" ]; then
        echo "引数を指定してください"
        return
    fi
    values=$(curl -s --ntlm --user ${login_id}:${login_pw} ${url} -d keyword=$1 | grep "<td>")

    count=0
    row=""
    result="部門,役職,氏名,フリガナ,内線番号\n"
    echo $values | while read values
    do
        value=$(echo $values | tr -d "<td>" | tr -d '\r' | tr "/" " ")
        if [ -n "$row" ]; then
            row=$row","
        fi
        row=$row$value

        count=$(( $count+1 ))
        if [ $count -ge 5 ]; then
            result=$result$row"\n"
            count=0
            row=""
        fi
    done

    echo ${result} | column -t -s,
}
