#!/bin/bash
# Script để giải mã tệp và lưu vào thư mục chỉ định

# Mẫu dùng để phát hiện các đoạn mã cần xử lý
pattern=###########################################################

# Đặt giới hạn stack size
ulimit -s unlimited >/dev/null 2>&1

# Biểu tượng Unicode để làm đẹp
icon="🔐"
# Định nghĩa các biến màu
red='\e[0;31m'
green='\e[0;32m'
yellow='\e[0;33m'
blue='\e[0;34m'
cyan='\e[0;36m'
reset='\e[0m'
rainbow="${red}🇻🇳 TTP-AI${green} Decode${yellow} Shell${blue} Bash${cyan}${reset} Script${red}${reset}"

# Định nghĩa thanh chạy màu sắc
progressbar="${green}[                    ]${reset}"

# Tổng số bước xử lý
total_steps=20

# Mảng chứa danh sách màu sắc lấp lánh
colors=($red $green $yellow $blue $cyan)

# Lặp qua từng bước xử lý
for (( step=0; step<=total_steps; step++ )); do
    # Tính toán phần trăm hoàn thành
    percentage=$(( (step * 100) / total_steps ))
    
    # Tính toán số lượng ký tự trong thanh chạy dựa trên phần trăm hoàn thành
    completed_chars=$(( (step * ${#progressbar}) / total_steps ))
    
    # Xây dựng thanh chạy màu sắc với hiệu ứng lấp lánh
    progress="${colors[$(($step % ${#colors}))]}["
    for (( i=0; i<${#progressbar}; i++ )); do
        if [ "$i" -lt "$completed_chars" ]; then
            progress+="${colors[$(($step % ${#colors}))]}="
        elif [ "$i" -eq "$completed_chars" ]; then
            progress+="${colors[$(($step % ${#colors}))]}>${reset}"
        else
            progress+=" "
        fi
    done
    progress+="${reset}]"
    
    # In ra tiến trình xử lý
    echo -en "\r${progress} ${percentage}%"
    
    # Tạm dừng 0.1 giây trước khi chuyển sang bước tiếp theo
    sleep 0.5
done

# Xuống dòng và đặt con trỏ về đầu dòng
echo -e "\n"

# Tạo thư mục nếu không tồn tại
decode_dir="/sdcard/TTP-AI/decode"
mkdir -p "$decode_dir"

# Hàm để giải mã
dec() {
  if grep -q -e '=.*;.*=.*;' \
              -e 'base64 -d | sh$' \
              -e 'xxd -p -r | sh$' \
              -e 'base64 -d | bash$' \
                -e '" | sh' \
              -e "$pattern" "$(pwd)/$shuf.temp1.sh"; then
    while true; do
      if grep '=.*;.*=.*;' "$(pwd)/$shuf.temp1.sh"; then
        sed 's/eval "\$/echo "\$/g; s/\[ "$(id -u)" -ne 2000 \]/! true/' "$(pwd)/$shuf.temp1.sh" > "$(pwd)/$shuf.temp2.sh"
        bash "$(pwd)/$shuf.temp2.sh" > "$(pwd)/$shuf.temp1.sh"
        rm "$(pwd)/$shuf.temp2.sh"
        # base64
      elif grep -q 'base64 -d | sh$' "$(pwd)/$shuf.temp1.sh"; then
        sed 's/base64 -d | sh/base64 -d/; s/\[ "$(id -u)" -ne 2000 \]/! true/' "$(pwd)/$shuf.temp1.sh" > "$(pwd)/$shuf.temp2.sh"
        bash "$(pwd)/$shuf.temp2.sh" > "$(pwd)/$shuf.temp1.sh"
        rm "$(pwd)/$shuf.temp2.sh"
          # xxd
            elif grep -q 'xxd -p -r | sh$' "$(pwd)/$shuf.temp1.sh"; then
                sed 's/xxd -p -r | sh/xxd -p -r/; s/\[ "$(id -u)" -ne 2000 \]/! true/' "$(pwd)/$shuf.temp1.sh" > "$(pwd)/$shuf.temp2.sh"
                bash "$(pwd)/$shuf.temp2.sh" > "$(pwd)/$shuf.temp1.sh"
        rm "$(pwd)/$shuf.temp2.sh"
          # bash
            elif grep -q 'base64 -d | bash$' "$(pwd)/$shuf.temp1.sh"; then
                sed 's/base64 -d | bash/base64 -d/; s/\[ "$(id -u)" -ne 2000 \]/! true/' "$(pwd)/$shuf.temp1.sh" > "$(pwd)/$shuf.temp2.sh"
                bash "$(pwd)/$shuf.temp2.sh" > "$(pwd)/$shuf.temp1.sh"
        rm "$(pwd)/$shuf.temp2.sh"
        # sh
      elif grep -q '" | sh' "$(pwd)/$shuf.temp1.sh"; then
        sed 's/\" | sh/\" > \"\$(pwd)\/$shuf.temp1.sh\"/g; s/\[ "$(id -u)" -ne 2000 \]/! true/" "$(pwd)/$shuf.temp1.sh' > "$(pwd)/$shuf.temp2.sh"
        bash "$(pwd)/$shuf.temp2.sh"
        rm "$(pwd)/$shuf.temp2.sh"
      elif grep -q "$pattern" "$(pwd)/$shuf.temp1.sh"; then
        cp "$(pwd)/$shuf.temp1.sh" "$(pwd)/$shuf.temp2.sh"
        cat "$(pwd)/$shuf.temp2.sh" | grep -v '###########################################################' > "$(pwd)/$shuf.temp1.sh"
        rm "$(pwd)/$shuf.temp2.sh"
      else
        break
      fi
    done
  else
    # giải mã shc
    for sec in $(seq 1 16); do
      exec="$(pwd)/$shuf.temp1.sh"
      "$exec" > /dev/null 2>&1 &
      child=$!
      sleep 0.0"$sec"
      kill -STOP $child
      cmdline=$(cat /proc/$child/cmdline)
      echo "$cmdline" | sed 's/.*\(#!\)/\1/' | head -c "-$(echo "$exec" | wc -c)" > "$(pwd)/$shuf.temp2.sh"
      kill -TERM $child
      if grep -q '#!/' "$(pwd)/$shuf.temp2.sh"; then
        break
      else
        rm "$(pwd)/$shuf.temp2.sh"
        touch "$(pwd)/$shuf.temp2.sh"
      fi
    done
  fi
  mv "$(pwd)/$shuf.temp2.sh" "$(pwd)/$shuf.temp1.sh"
  echo ""
}

# Hiển thị thông báo và yêu cầu người dùng nhập đường dẫn
echo -e "$rainbow"
echo -e "${icon} ${red}Giải mã base64, Giải mã xxd, Giải mã shc, Giải mã bash-obfuscate, Giải mã bash base64 🇻🇳${reset}"
echo -e "${icon} ${blue}Ví dụ:${reset}"
echo -e "${icon} ${cyan} Đầu vào là một file: /sdcard/script.sh${reset}"
echo -e "${icon} ${green} Đầu vào là một thư mục: /sdcard/dir/${reset}"
echo -e "${icon} ${green} Tập tin giải mã sẽ lưu trong: /sdcard/TTP-AI/decode/${reset}"
echo ""
printf "${icon} ${cyan}Nhập đường dẫn: ${reset}"
read -r input
shuf=$(shuf -i 1-100 -n 1)
echo ""
if [ -z "$(find "$input" -maxdepth 1 -type f)" ]; then
  echo -e "${icon} ${green} Cảnh báo: Không tìm thấy đầu vào."
  exit 1
fi

# Lặp qua các tệp trong thư mục đầu vào
find "$input" -maxdepth 1 -type f | while IFS= read -r file; do
  cp "$file" "$(pwd)/$shuf.temp1.sh"
  chmod +x "$(pwd)/$shuf.temp1.sh"
  echo -e "${icon} ${green} Đang giải mã $(basename "$file")"
  dec > /dev/null 2>&1
  if grep -q -e '=.*;.*=.*;' -e 'base64 -d | sh$' -e '" | sh' -e "$pattern" "$(pwd)/$shuf.temp1.sh"; then
    dec > /dev/null 2>&1
  fi
  if [ -s "$(pwd)/$shuf.temp1.sh" ]; then
    mv "$(pwd)/$shuf.temp1.sh" "$decode_dir/$(basename "$file").TTP-DECODE.sh"
    echo -e "${icon} ${green} Thành công: Quá trình giải mã $(basename "$file") đã hoàn tất."
  else
    echo -e "${icon} ${red} Thất bại: Không thể giải mã $(basename "$file")." 
rm "$(pwd)/$shuf.temp1.sh" 
fi 
done
 echo ""
echo -e "${icon} ${green} Đã giải mã xong. Các tệp giải mã được lưu trong thư mục: $decode_dir"
 
